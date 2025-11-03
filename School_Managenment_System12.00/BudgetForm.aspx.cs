using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SchoolFinancialManagementSystem
{
    public partial class BudgetForm : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
        private int editBudgetId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadTeachers();
                UpdateStatistics();
                SetCurrentYear();

                // Check if we're editing an existing budget
                if (Request.QueryString["edit"] != null)
                {
                    editBudgetId = Convert.ToInt32(Request.QueryString["edit"]);
                    LoadBudgetForEdit(editBudgetId);
                }
            }
        }

        protected void BtnSaveBudget_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    if (editBudgetId > 0)
                    {
                        UpdateBudget();
                    }
                    else
                    {
                        SaveNewBudget();
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage($"Error saving budget: {ex.Message}");
                }
            }
        }

        protected void BtnClearForm_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
            Response.Redirect("BudgetForm.aspx");
        }

        protected void BtnViewBudgets_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewBudgets.aspx");
        }

        protected void ChkIsSalaryBudget_CheckedChanged(object sender, EventArgs e)
        {
            PnlTeacherSelection.Visible = ChkIsSalaryBudget.Checked;
            if (ChkIsSalaryBudget.Checked)
            {
                ReqTeacher.Enabled = true;
            }
            else
            {
                ReqTeacher.Enabled = false;
            }
        }

        private void SaveNewBudget()
        {
            using (var con = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO Budget (Category, BudgetAmount, Month, Year, Description, 
                                       CreatedBy, IsSalaryBudget, TeacherId, IsActive) 
                               VALUES (@Category, @BudgetAmount, @Month, @Year, @Description, 
                                       @CreatedBy, @IsSalaryBudget, @TeacherId, @IsActive)";

                using (var cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Category", DdlCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@BudgetAmount", decimal.Parse(TxtBudgetAmount.Text));
                    cmd.Parameters.AddWithValue("@Month", Convert.ToInt32(DdlMonth.SelectedValue));
                    cmd.Parameters.AddWithValue("@Year", Convert.ToInt32(TxtYear.Text));
                    cmd.Parameters.AddWithValue("@Description", TxtDescription.Text);
                    cmd.Parameters.AddWithValue("@CreatedBy", Session["UserID"]);
                    cmd.Parameters.AddWithValue("@IsSalaryBudget", ChkIsSalaryBudget.Checked);

                    if (ChkIsSalaryBudget.Checked && !string.IsNullOrEmpty(DdlTeacher.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", Convert.ToInt32(DdlTeacher.SelectedValue));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", DBNull.Value);
                    }

                    cmd.Parameters.AddWithValue("@IsActive", true);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            ShowMessage("Budget created successfully!");
            ClearForm();
            UpdateStatistics();
        }

        private void UpdateBudget()
        {
            using (var con = new SqlConnection(connectionString))
            {
                string query = @"UPDATE Budget SET Category = @Category, BudgetAmount = @BudgetAmount, 
                                Month = @Month, Year = @Year, Description = @Description, 
                                IsSalaryBudget = @IsSalaryBudget, TeacherId = @TeacherId,
                                UpdatedDate = GETDATE()
                                WHERE BudgetId = @BudgetId";

                using (var cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@BudgetId", editBudgetId);
                    cmd.Parameters.AddWithValue("@Category", DdlCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@BudgetAmount", decimal.Parse(TxtBudgetAmount.Text));
                    cmd.Parameters.AddWithValue("@Month", Convert.ToInt32(DdlMonth.SelectedValue));
                    cmd.Parameters.AddWithValue("@Year", Convert.ToInt32(TxtYear.Text));
                    cmd.Parameters.AddWithValue("@Description", TxtDescription.Text);
                    cmd.Parameters.AddWithValue("@IsSalaryBudget", ChkIsSalaryBudget.Checked);

                    if (ChkIsSalaryBudget.Checked && !string.IsNullOrEmpty(DdlTeacher.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", Convert.ToInt32(DdlTeacher.SelectedValue));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", DBNull.Value);
                    }

                    con.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowMessage("Budget updated successfully!");
                        ClearForm();
                        UpdateStatistics();
                        Response.Redirect("ViewBudgets.aspx");
                    }
                    else
                    {
                        ShowMessage("Budget not found or update failed!");
                    }
                }
            }
        }

        private void LoadBudgetForEdit(int budgetId)
        {
            try
            {
                using (var con = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM Budget WHERE BudgetId = @BudgetId";
                    using (var cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@BudgetId", budgetId);
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            var dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                DataRow row = dt.Rows[0];

                                DdlCategory.SelectedValue = row["Category"].ToString();
                                TxtBudgetAmount.Text = Convert.ToDecimal(row["BudgetAmount"]).ToString("F2");
                                DdlMonth.SelectedValue = row["Month"].ToString();
                                TxtYear.Text = row["Year"].ToString();
                                TxtDescription.Text = row["Description"].ToString();

                                bool isSalaryBudget = Convert.ToBoolean(row["IsSalaryBudget"]);
                                ChkIsSalaryBudget.Checked = isSalaryBudget;
                                PnlTeacherSelection.Visible = isSalaryBudget;

                                if (isSalaryBudget && row["TeacherId"] != DBNull.Value)
                                {
                                    DdlTeacher.SelectedValue = row["TeacherId"].ToString();
                                }

                                LblFormTitle.Text = "Edit Budget";
                                BtnCancel.Visible = true;
                                editBudgetId = budgetId;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading budget: {ex.Message}");
            }
        }

        private void LoadTeachers()
        {
            try
            {
                using (var con = new SqlConnection(connectionString))
                {
                    string query = "SELECT TeacherId, FirstName + ' ' + LastName AS TeacherName FROM Teachers WHERE IsActive = 1 ORDER BY FirstName";
                    using (var cmd = new SqlCommand(query, con))
                    {
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            var dt = new DataTable();
                            da.Fill(dt);

                            DdlTeacher.DataSource = dt;
                            DdlTeacher.DataTextField = "TeacherName";
                            DdlTeacher.DataValueField = "TeacherId";
                            DdlTeacher.DataBind();
                            DdlTeacher.Items.Insert(0, new ListItem("Select Teacher", ""));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading teachers: {ex.Message}");
            }
        }

        private void UpdateStatistics()
        {
            try
            {
                using (var con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Total Budget
                    string totalQuery = "SELECT ISNULL(SUM(BudgetAmount), 0) FROM Budget WHERE IsActive = 1 AND Year = YEAR(GETDATE())";
                    using (var cmd = new SqlCommand(totalQuery, con))
                    {
                        decimal totalBudget = Convert.ToDecimal(cmd.ExecuteScalar());
                        LblTotalBudget.Text = $"Rs{totalBudget:N2}";
                    }

                    // Monthly Budget
                    string monthlyQuery = @"SELECT ISNULL(SUM(BudgetAmount), 0) FROM Budget 
                                          WHERE IsActive = 1 AND Month = MONTH(GETDATE()) 
                                          AND Year = YEAR(GETDATE())";
                    using (var cmd = new SqlCommand(monthlyQuery, con))
                    {
                        decimal monthlyBudget = Convert.ToDecimal(cmd.ExecuteScalar());
                        LblMonthlyBudget.Text = $"Rs{monthlyBudget:N2}";
                    }

                    // Active Budgets Count
                    string countQuery = "SELECT COUNT(*) FROM Budget WHERE IsActive = 1";
                    using (var cmd = new SqlCommand(countQuery, con))
                    {
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        LblActiveBudgets.Text = count.ToString();
                    }

                    // Salary Budget
                    string salaryQuery = "SELECT ISNULL(SUM(BudgetAmount), 0) FROM Budget WHERE IsActive = 1 AND IsSalaryBudget = 1";
                    using (var cmd = new SqlCommand(salaryQuery, con))
                    {
                        decimal salaryBudget = Convert.ToDecimal(cmd.ExecuteScalar());
                        LblSalaryBudget.Text = $"Rs{salaryBudget:N2}";
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error updating statistics: {ex.Message}");
            }
        }

        private void SetCurrentYear()
        {
            TxtYear.Text = DateTime.Now.Year.ToString();
        }

        private void ClearForm()
        {
            DdlCategory.SelectedIndex = 0;
            TxtBudgetAmount.Text = "";
            DdlMonth.SelectedIndex = 0;
            SetCurrentYear();
            TxtDescription.Text = "";
            ChkIsSalaryBudget.Checked = false;
            PnlTeacherSelection.Visible = false;
            DdlTeacher.SelectedIndex = 0;
            LblFormTitle.Text = "Create New Budget";
            BtnCancel.Visible = false;
            editBudgetId = 0;
        }

        private void ShowMessage(string message)
        {
            string script = $@"<script type='text/javascript'>
                alert('{message.Replace("'", "\\'")}');
            </script>";
            ClientScript.RegisterStartupScript(this.GetType(), "Alert", script);
        }
    }
}