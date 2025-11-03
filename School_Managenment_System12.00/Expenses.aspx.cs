using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace School_Managenment_System12._00
{
    public partial class Expenses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Master != null)
                {
                    System.Web.UI.WebControls.Label lblPageTitle = (System.Web.UI.WebControls.Label)Master.FindControl("lblPageTitle");
                    if (lblPageTitle != null)
                    {
                        lblPageTitle.Text = "Expenses Management";
                    }
                }

                LoadExpenses();
                LoadStatistics();
                ClearForm();
            }
        }

        private void LoadExpenses()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connectionString))
            {
                ShowAlert("Database connection not configured.", "danger");
                return;
            }

            string query = @"SELECT e.ExpenseId, e.ExpenseType, e.Amount, e.ExpenseDate, e.Category, 
                            e.Description, e.PaidTo, e.PaymentMode, e.CreatedDate, u.Username as CreatedBy
                            FROM Expenses e 
                            INNER JOIN Users u ON e.CreatedBy = u.UserId
                            WHERE 1=1";

            if (!string.IsNullOrEmpty(txtSearch.Text))
            {
                query += " AND (e.ExpenseType LIKE @Search OR e.Description LIKE @Search OR e.PaidTo LIKE @Search)";
            }

            if (!string.IsNullOrEmpty(ddlCategoryFilter.SelectedValue))
            {
                query += " AND e.Category = @Category";
            }

            if (!string.IsNullOrEmpty(ddlPaymentFilter.SelectedValue))
            {
                query += " AND e.PaymentMode = @PaymentMode";
            }

            query += " ORDER BY e.ExpenseDate DESC, e.CreatedDate DESC";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                if (!string.IsNullOrEmpty(txtSearch.Text))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text + "%");
                }

                if (!string.IsNullOrEmpty(ddlCategoryFilter.SelectedValue))
                {
                    cmd.Parameters.AddWithValue("@Category", ddlCategoryFilter.SelectedValue);
                }

                if (!string.IsNullOrEmpty(ddlPaymentFilter.SelectedValue))
                {
                    cmd.Parameters.AddWithValue("@PaymentMode", ddlPaymentFilter.SelectedValue);
                }

                try
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvExpenses.DataSource = dt;
                    gvExpenses.DataBind();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading expenses: " + ex.Message, "danger");
                }
            }
        }

        private void LoadStatistics()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connectionString))
            {
                SetDefaultStatistics();
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    // Total Expenses
                    string totalQuery = "SELECT ISNULL(SUM(Amount), 0) FROM Expenses";
                    SqlCommand totalCmd = new SqlCommand(totalQuery, con);
                    decimal totalExpenses = Convert.ToDecimal(totalCmd.ExecuteScalar());
                    lblTotalExpenses.Text = totalExpenses.ToString("C");

                    // This Month Expenses
                    string monthQuery = @"SELECT ISNULL(SUM(Amount), 0) FROM Expenses 
                                        WHERE MONTH(ExpenseDate) = MONTH(GETDATE()) 
                                        AND YEAR(ExpenseDate) = YEAR(GETDATE())";
                    SqlCommand monthCmd = new SqlCommand(monthQuery, con);
                    decimal monthExpenses = Convert.ToDecimal(monthCmd.ExecuteScalar());
                    lblThisMonth.Text = monthExpenses.ToString("C");

                    // Today's Expenses
                    string todayQuery = "SELECT ISNULL(SUM(Amount), 0) FROM Expenses WHERE CAST(ExpenseDate AS DATE) = CAST(GETDATE() AS DATE)";
                    SqlCommand todayCmd = new SqlCommand(todayQuery, con);
                    decimal todayExpenses = Convert.ToDecimal(todayCmd.ExecuteScalar());
                    lblToday.Text = todayExpenses.ToString("C");

                    // Active Categories
                    string categoriesQuery = "SELECT COUNT(DISTINCT Category) FROM Expenses";
                    SqlCommand categoriesCmd = new SqlCommand(categoriesQuery, con);
                    int activeCategories = Convert.ToInt32(categoriesCmd.ExecuteScalar());
                    lblCategories.Text = activeCategories.ToString();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading statistics: " + ex.Message, "danger");
                    SetDefaultStatistics();
                }
            }
        }

        private void SetDefaultStatistics()
        {
            lblTotalExpenses.Text = "$0";
            lblThisMonth.Text = "$0";
            lblToday.Text = "$0";
            lblCategories.Text = "0";
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;

                if (string.IsNullOrEmpty(connectionString))
                {
                    ShowAlert("Database connection not configured.", "danger");
                    return;
                }

                // First, check if the user exists
                int currentUserId = GetCurrentUserId();
                if (!CheckUserExists(currentUserId))
                {
                    ShowAlert("Invalid user account. Please contact administrator.", "danger");
                    return;
                }

                string query;
                bool isEdit = !string.IsNullOrEmpty(hfExpenseId.Value);

                if (isEdit)
                {
                    query = @"UPDATE Expenses SET ExpenseType = @ExpenseType, Amount = @Amount, 
                             ExpenseDate = @ExpenseDate, Category = @Category, Description = @Description,
                             PaidTo = @PaidTo, PaymentMode = @PaymentMode
                             WHERE ExpenseId = @ExpenseId";
                }
                else
                {
                    query = @"INSERT INTO Expenses (ExpenseType, Amount, ExpenseDate, Category, Description, PaidTo, PaymentMode, CreatedBy)
                             VALUES (@ExpenseType, @Amount, @ExpenseDate, @Category, @Description, @PaidTo, @PaymentMode, @CreatedBy)";
                }

                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ExpenseType", txtExpenseType.Text.Trim());
                    cmd.Parameters.AddWithValue("@Amount", decimal.Parse(txtAmount.Text));
                    cmd.Parameters.AddWithValue("@ExpenseDate", DateTime.Parse(txtExpenseDate.Text));
                    cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@PaidTo", string.IsNullOrEmpty(txtPaidTo.Text) ? (object)DBNull.Value : txtPaidTo.Text.Trim());
                    cmd.Parameters.AddWithValue("@PaymentMode", ddlPaymentMode.SelectedValue);

                    if (isEdit)
                    {
                        cmd.Parameters.AddWithValue("@ExpenseId", int.Parse(hfExpenseId.Value));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@CreatedBy", currentUserId);
                    }

                    try
                    {
                        con.Open();
                        int result = cmd.ExecuteNonQuery();

                        if (result > 0)
                        {
                            string message = isEdit ? "Expense updated successfully!" : "Expense created successfully!";
                            ShowAlert(message, "success");
                            LoadExpenses();
                            LoadStatistics();
                            ClearForm();
                        }
                        else
                        {
                            ShowAlert("Error saving expense.", "danger");
                        }
                    }
                    catch (SqlException ex)
                    {
                        if (ex.Number == 547) // Foreign key violation
                        {
                            ShowAlert("User account not found. Please contact administrator.", "danger");
                        }
                        else
                        {
                            ShowAlert("Database error: " + ex.Message, "danger");
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowAlert("Error saving expense: " + ex.Message, "danger");
                    }
                }
            }
        }

        private bool CheckUserExists(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connectionString))
                return false;

            string query = "SELECT COUNT(1) FROM Users WHERE UserId = @UserId";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);

                try
                {
                    con.Open();
                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
                catch
                {
                    return false;
                }
            }
        }

        // Rest of your methods remain the same...
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void gvExpenses_RowEditing(object sender, GridViewEditEventArgs e)
        {
            int expenseId = Convert.ToInt32(gvExpenses.DataKeys[e.NewEditIndex].Value);
            LoadExpenseForEdit(expenseId);
            e.Cancel = true;
        }

        protected void gvExpenses_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int expenseId = Convert.ToInt32(gvExpenses.DataKeys[e.RowIndex].Value);
            DeleteExpense(expenseId);
        }

        protected void gvExpenses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvExpenses.PageIndex = e.NewPageIndex;
            LoadExpenses();
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadExpenses();
        }

        protected void ddlCategoryFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadExpenses();
        }

        protected void ddlPaymentFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadExpenses();
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            ExportToExcel();
        }

        protected void gvExpenses_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton btnDelete = (LinkButton)e.Row.FindControl("btnDelete");
                if (btnDelete != null)
                {
                    btnDelete.OnClientClick = "return confirm('Are you sure you want to delete this expense?');";
                }
            }
        }

        private void LoadExpenseForEdit(int expenseId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connectionString))
            {
                ShowAlert("Database connection not configured.", "danger");
                return;
            }

            string query = @"SELECT ExpenseId, ExpenseType, Amount, ExpenseDate, Category, Description, PaidTo, PaymentMode 
                           FROM Expenses WHERE ExpenseId = @ExpenseId";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@ExpenseId", expenseId);

                try
                {
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        hfExpenseId.Value = reader["ExpenseId"].ToString();
                        txtExpenseType.Text = reader["ExpenseType"].ToString();
                        txtAmount.Text = Convert.ToDecimal(reader["Amount"]).ToString("F2");
                        txtExpenseDate.Text = Convert.ToDateTime(reader["ExpenseDate"]).ToString("yyyy-MM-dd");
                        ddlCategory.SelectedValue = reader["Category"].ToString();
                        txtDescription.Text = reader["Description"].ToString();
                        txtPaidTo.Text = reader["PaidTo"] != DBNull.Value ? reader["PaidTo"].ToString() : "";
                        ddlPaymentMode.SelectedValue = reader["PaymentMode"].ToString();

                        lblFormTitle.Text = "Edit Expense";
                        btnSave.Text = "Update Expense";

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "scrollToForm", "document.querySelector('.form-section').scrollIntoView({ behavior: 'smooth' });", true);
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading expense for edit: " + ex.Message, "danger");
                }
            }
        }

        private void DeleteExpense(int expenseId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connectionString))
            {
                ShowAlert("Database connection not configured.", "danger");
                return;
            }

            string query = "DELETE FROM Expenses WHERE ExpenseId = @ExpenseId";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@ExpenseId", expenseId);

                try
                {
                    con.Open();
                    int result = cmd.ExecuteNonQuery();

                    if (result > 0)
                    {
                        ShowAlert("Expense deleted successfully!", "success");
                        LoadExpenses();
                        LoadStatistics();
                    }
                    else
                    {
                        ShowAlert("Error deleting expense.", "danger");
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error deleting expense: " + ex.Message, "danger");
                }
            }
        }

        private void ExportToExcel()
        {
            try
            {
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=Expenses_" + DateTime.Now.ToString("yyyyMMdd") + ".xls");
                Response.Charset = "";
                Response.ContentType = "application/vnd.ms-excel";

                StringWriter sw = new StringWriter();
                HtmlTextWriter hw = new HtmlTextWriter(sw);

                GridView gvExport = new GridView();
                gvExport.DataSource = gvExpenses.DataSource;
                gvExport.DataBind();

                gvExport.HeaderStyle.BackColor = System.Drawing.Color.Purple;
                gvExport.HeaderStyle.ForeColor = System.Drawing.Color.White;
                gvExport.HeaderStyle.Font.Bold = true;

                gvExport.RenderControl(hw);

                Response.Output.Write(sw.ToString());
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                ShowAlert("Error exporting to Excel: " + ex.Message, "danger");
            }
        }

        private void ClearForm()
        {
            hfExpenseId.Value = string.Empty;
            txtExpenseType.Text = string.Empty;
            txtAmount.Text = string.Empty;
            txtExpenseDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            ddlCategory.SelectedIndex = 0;
            txtDescription.Text = string.Empty;
            txtPaidTo.Text = string.Empty;
            ddlPaymentMode.SelectedIndex = 0;

            lblFormTitle.Text = "Add New Expense";
            btnSave.Text = "Save Expense";
        }

        private void ShowAlert(string message, string type)
        {
            pnlAlert.CssClass = $"alert alert-{type} alert-dismissible fade show";
            lblAlertMessage.Text = message;
            pnlAlert.Visible = true;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "hideAlert",
                "setTimeout(function() { $('.alert').alert('close'); }, 5000);", true);
        }

        private int GetCurrentUserId()
        {
            if (Session["UserId"] != null)
            {
                return Convert.ToInt32(Session["UserId"]);
            }

            // Try to get the first available user from database
            string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;
            if (!string.IsNullOrEmpty(connectionString))
            {
                string query = "SELECT TOP 1 UserId FROM Users ORDER BY UserId";
                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    try
                    {
                        con.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            return Convert.ToInt32(result);
                        }
                    }
                    catch
                    {
                        // If error, return default 1
                    }
                }
            }

            return 1; // Default fallback
        }
    }
}