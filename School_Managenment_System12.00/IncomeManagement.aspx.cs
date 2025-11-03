using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SchoolFinancialManagementSystem
{
    public partial class Income : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                BindIncomeGrid();
                UpdateStatistics();

                // Set default date to today
                TxtIncomeDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            }
        }

        protected void BtnAddIncome_Click(object sender, EventArgs e)
        {
            if (ValidateForm())
            {
                try
                {
                    using (var con = new SqlConnection(connectionString))
                    {
                        string query = @"INSERT INTO Income (IncomeType, Amount, IncomeDate, Category, Description, ReceivedFrom, PaymentMode, CreatedBy) 
                                       VALUES (@IncomeType, @Amount, @IncomeDate, @Category, @Description, @ReceivedFrom, @PaymentMode, @CreatedBy)";

                        using (var cmd = new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue("@IncomeType", DdlIncomeType.SelectedValue);
                            cmd.Parameters.AddWithValue("@Amount", decimal.Parse(TxtAmount.Text));
                            cmd.Parameters.AddWithValue("@IncomeDate", DateTime.Parse(TxtIncomeDate.Text));
                            cmd.Parameters.AddWithValue("@Category", DdlCategory.SelectedValue);
                            cmd.Parameters.AddWithValue("@Description", TxtDescription.Text);
                            cmd.Parameters.AddWithValue("@ReceivedFrom", TxtReceivedFrom.Text);
                            cmd.Parameters.AddWithValue("@PaymentMode", DdlPaymentMode.SelectedValue);
                            cmd.Parameters.AddWithValue("@CreatedBy", Session["UserID"]);

                            con.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    ShowMessage("Income record added successfully!");
                    ClearForm();
                    BindIncomeGrid();
                    UpdateStatistics();
                }
                catch (Exception ex)
                {
                    ShowMessage($"Error adding income record: {ex.Message}");
                }
            }
        }

        protected void BtnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void BtnAddNew_Click(object sender, EventArgs e)
        {
            // Scroll to form section
            ScriptManager.RegisterStartupScript(this, GetType(), "ScrollToForm",
                $"document.getElementById('{DdlIncomeType.ClientID}').scrollIntoView({{behavior: 'smooth'}});", true);
        }

        protected void GvIncome_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteRecord")
            {
                int incomeId = Convert.ToInt32(e.CommandArgument);
                DeleteIncomeRecord(incomeId);
            }
            else if (e.CommandName == "EditRecord")
            {
                int incomeId = Convert.ToInt32(e.CommandArgument);
                LoadIncomeRecordForEdit(incomeId);
            }
        }

        protected void GvIncome_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GvIncome.PageIndex = e.NewPageIndex;
            BindIncomeGrid();
        }

        protected void TxtSearch_TextChanged(object sender, EventArgs e)
        {
            BindIncomeGrid();
        }

        protected void BtnExport_Click(object sender, EventArgs e)
        {
            ExportToExcel();
        }

        private void BindIncomeGrid()
        {
            try
            {
                using (var con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT * FROM Income 
                                   WHERE (@SearchTerm = '' OR 
                                         IncomeType LIKE '%' + @SearchTerm + '%' OR 
                                         Category LIKE '%' + @SearchTerm + '%' OR
                                         ReceivedFrom LIKE '%' + @SearchTerm + '%')
                                   ORDER BY IncomeDate DESC";

                    using (var cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@SearchTerm", TxtSearch.Text.Trim());

                        using (var da = new SqlDataAdapter(cmd))
                        {
                            var dt = new DataTable();
                            da.Fill(dt);
                            GvIncome.DataSource = dt;
                            GvIncome.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading income records: {ex.Message}");
            }
        }

        private void UpdateStatistics()
        {
            try
            {
                using (var con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Total Income
                    string totalQuery = "SELECT ISNULL(SUM(Amount), 0) FROM Income";
                    using (var cmd = new SqlCommand(totalQuery, con))
                    {
                        decimal totalIncome = Convert.ToDecimal(cmd.ExecuteScalar());
                        LblTotalIncome.Text = $"Rs{totalIncome:N2}";
                    }

                    // Monthly Income
                    string monthlyQuery = @"SELECT ISNULL(SUM(Amount), 0) FROM Income 
                                          WHERE MONTH(IncomeDate) = MONTH(GETDATE()) 
                                          AND YEAR(IncomeDate) = YEAR(GETDATE())";
                    using (var cmd = new SqlCommand(monthlyQuery, con))
                    {
                        decimal monthlyIncome = Convert.ToDecimal(cmd.ExecuteScalar());
                        LblMonthlyIncome.Text = $"Rs{monthlyIncome:N2}";
                    }

                    // Transaction Count
                    string countQuery = "SELECT COUNT(*) FROM Income";
                    using (var cmd = new SqlCommand(countQuery, con))
                    {
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        LblTransactionCount.Text = count.ToString("N0");
                    }

                    // Average Income
                    string avgQuery = "SELECT ISNULL(AVG(Amount), 0) FROM Income";
                    using (var cmd = new SqlCommand(avgQuery, con))
                    {
                        decimal avgIncome = Convert.ToDecimal(cmd.ExecuteScalar());
                        LblAvgIncome.Text = $"Rs{avgIncome:N2}";
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error updating statistics: {ex.Message}");
            }
        }

        private void DeleteIncomeRecord(int incomeId)
        {
            try
            {
                using (var con = new SqlConnection(connectionString))
                {
                    string query = "DELETE FROM Income WHERE IncomeId = @IncomeId";
                    using (var cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@IncomeId", incomeId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowMessage("Income record deleted successfully!");
                BindIncomeGrid();
                UpdateStatistics();
            }
            catch (Exception ex)
            {
                ShowMessage($"Error deleting record: {ex.Message}");
            }
        }

        private void LoadIncomeRecordForEdit(int incomeId)
        {
            try
            {
                using (var con = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM Income WHERE IncomeId = @IncomeId";
                    using (var cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@IncomeId", incomeId);
                        using (var da = new SqlDataAdapter(cmd))
                        {
                            var dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                DataRow row = dt.Rows[0];
                                DdlIncomeType.SelectedValue = row["IncomeType"].ToString();
                                TxtAmount.Text = Convert.ToDecimal(row["Amount"]).ToString("F2");
                                TxtIncomeDate.Text = Convert.ToDateTime(row["IncomeDate"]).ToString("yyyy-MM-dd");
                                DdlCategory.SelectedValue = row["Category"].ToString();
                                TxtDescription.Text = row["Description"].ToString();
                                TxtReceivedFrom.Text = row["ReceivedFrom"].ToString();
                                DdlPaymentMode.SelectedValue = row["PaymentMode"].ToString();

                                ShowMessage("Record loaded for editing. Update the values and click 'Add Income' to save changes.");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading record for edit: {ex.Message}");
            }
        }

        private void ExportToExcel()
        {
            try
            {
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=IncomeRecords_" + DateTime.Now.ToString("yyyyMMdd") + ".xls");
                Response.Charset = "";
                Response.ContentType = "application/vnd.ms-excel";

                using (var sw = new StringWriter())
                {
                    using (var hw = new HtmlTextWriter(sw))
                    {
                        // Create a temporary GridView for export
                        var gvExport = new GridView();
                        gvExport.DataSource = GetExportData();
                        gvExport.DataBind();

                        gvExport.RenderControl(hw);

                        Response.Output.Write(sw.ToString());
                        Response.Flush();
                        Response.End();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error exporting data: {ex.Message}");
            }
        }

        private DataTable GetExportData()
        {
            var dt = new DataTable();
            using (var con = new SqlConnection(connectionString))
            {
                string query = "SELECT IncomeType, Amount, IncomeDate, Category, ReceivedFrom, PaymentMode, Description FROM Income ORDER BY IncomeDate DESC";
                using (var cmd = new SqlCommand(query, con))
                {
                    using (var da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            return dt;
        }

        public string GetCategoryClass(string category)
        {
            if (string.IsNullOrEmpty(category))
                return "other";

            switch (category.ToLower())
            {
                case "student fees":
                    return "fees";
                case "government funds":
                    return "government";
                case "donations":
                    return "donations";
                case "other income":
                    return "other";
                default:
                    return "other";
            }
        }

        private bool ValidateForm()
        {
            if (string.IsNullOrEmpty(DdlIncomeType.SelectedValue))
            {
                ShowMessage("Please select income type");
                return false;
            }

            if (string.IsNullOrEmpty(TxtAmount.Text) || !decimal.TryParse(TxtAmount.Text, out decimal amount) || amount <= 0)
            {
                ShowMessage("Please enter a valid amount");
                return false;
            }

            if (string.IsNullOrEmpty(TxtIncomeDate.Text) || !DateTime.TryParse(TxtIncomeDate.Text, out _))
            {
                ShowMessage("Please select a valid date");
                return false;
            }

            if (string.IsNullOrEmpty(DdlCategory.SelectedValue))
            {
                ShowMessage("Please select category");
                return false;
            }

            if (string.IsNullOrEmpty(TxtReceivedFrom.Text))
            {
                ShowMessage("Please enter source");
                return false;
            }

            if (string.IsNullOrEmpty(DdlPaymentMode.SelectedValue))
            {
                ShowMessage("Please select payment mode");
                return false;
            }

            return true;
        }

        private void ShowMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowMessage",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }

        private void ClearForm()
        {
            DdlIncomeType.SelectedIndex = 0;
            TxtAmount.Text = "";
            TxtIncomeDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            DdlCategory.SelectedIndex = 0;
            TxtDescription.Text = "";
            TxtReceivedFrom.Text = "";
            DdlPaymentMode.SelectedIndex = 0;
        }
    }
}