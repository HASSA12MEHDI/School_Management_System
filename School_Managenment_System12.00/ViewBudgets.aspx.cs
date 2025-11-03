using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SchoolFinancialManagementSystem
{
    public partial class ViewBudgets : System.Web.UI.Page
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

                LoadYearFilter();
                BindBudgetsGrid();
                UpdateSummaryStats();
            }
        }

        protected void BtnCreateNew_Click(object sender, EventArgs e)
        {
            try
            {
                Response.Redirect("BudgetForm.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowMessage($"Error redirecting to budget form: {ex.Message}", "error");
            }
        }

        protected void GvBudgets_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandArgument != null && int.TryParse(e.CommandArgument.ToString(), out int budgetId))
            {
                switch (e.CommandName)
                {
                    case "EditBudget":
                        Response.Redirect($"BudgetForm.aspx?edit={budgetId}");
                        break;
                    case "ToggleStatus":
                        ToggleBudgetStatus(budgetId);
                        break;
                    case "DeleteBudget":
                        DeleteBudget(budgetId);
                        break;
                }
            }
            else
            {
                ShowMessage("Invalid budget ID.", "error");
            }
        }

        protected void GvBudgets_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GvBudgets.PageIndex = e.NewPageIndex;
            BindBudgetsGrid();
        }

        protected void GvBudgets_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Add tooltips for better UX
                var btnEdit = e.Row.FindControl("BtnEdit") as LinkButton;
                var btnToggle = e.Row.FindControl("BtnToggle") as LinkButton;
                var btnDelete = e.Row.FindControl("BtnDelete") as LinkButton;

                if (btnEdit != null) btnEdit.ToolTip = "Edit this budget";
                if (btnDelete != null) btnDelete.ToolTip = "Delete this budget permanently";
            }
        }

        protected void TxtSearch_TextChanged(object sender, EventArgs e)
        {
            GvBudgets.PageIndex = 0; // Reset to first page when searching
            BindBudgetsGrid();
        }

        protected void DdlYearFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindBudgetsGrid();
        }

        protected void DdlMonthFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindBudgetsGrid();
        }

        protected void DdlTypeFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindBudgetsGrid();
        }

        protected void DdlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindBudgetsGrid();
        }

        protected void BtnExport_Click(object sender, EventArgs e)
        {
            try
            {
                ExportToExcel();
            }
            catch (Exception ex)
            {
                ShowExportStatus($"Error exporting to Excel: {ex.Message}", "error");
                ShowMessage($"Error exporting to Excel: {ex.Message}", "error");
            }
        }

        private void BindBudgetsGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    string query = BuildBudgetQuery();

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        // Clear parameters first
                        cmd.Parameters.Clear();

                        // Add parameters with proper handling
                        cmd.Parameters.AddWithValue("@SearchTerm", string.IsNullOrEmpty(TxtSearch.Text.Trim()) ? "" : TxtSearch.Text.Trim());

                        // For Year - handle empty string as all years
                        if (string.IsNullOrEmpty(DdlYearFilter.SelectedValue) || DdlYearFilter.SelectedValue == "")
                        {
                            cmd.Parameters.AddWithValue("@Year", DBNull.Value);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@Year", DdlYearFilter.SelectedValue);
                        }

                        // For Month - handle empty string as all months
                        if (string.IsNullOrEmpty(DdlMonthFilter.SelectedValue) || DdlMonthFilter.SelectedValue == "")
                        {
                            cmd.Parameters.AddWithValue("@Month", DBNull.Value);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@Month", DdlMonthFilter.SelectedValue);
                        }

                        // For BudgetType - handle empty string as all types
                        if (string.IsNullOrEmpty(DdlTypeFilter.SelectedValue) || DdlTypeFilter.SelectedValue == "")
                        {
                            cmd.Parameters.AddWithValue("@BudgetType", DBNull.Value);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@BudgetType", DdlTypeFilter.SelectedValue);
                        }

                        // For Status - handle empty string as all status
                        if (string.IsNullOrEmpty(DdlStatusFilter.SelectedValue) || DdlStatusFilter.SelectedValue == "")
                        {
                            cmd.Parameters.AddWithValue("@Status", DBNull.Value);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@Status", DdlStatusFilter.SelectedValue);
                        }

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            // Debug output
                            System.Diagnostics.Debug.WriteLine($"Retrieved {dt.Rows.Count} budgets from database");

                            GvBudgets.DataSource = dt;
                            GvBudgets.DataBind();

                            // Update record count
                            LblRecordCount.Text = $"{dt.Rows.Count} records";

                            // Show message if no records found
                            if (dt.Rows.Count == 0)
                            {
                                ShowNoDataMessage();
                            }
                        }
                    }
                }
                UpdateSummaryStats();
            }
            catch (SqlException sqlEx)
            {
                ShowMessage($"Database error: {sqlEx.Message}", "error");
                System.Diagnostics.Debug.WriteLine($"SQL Error: {sqlEx.Message}");
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading budgets: {ex.Message}", "error");
                System.Diagnostics.Debug.WriteLine($"General Error: {ex.Message}");
            }
        }

        private string BuildBudgetQuery()
        {
            return @"SELECT 
                        b.BudgetId,
                        b.Category,
                        b.BudgetAmount,
                        b.Month,
                        b.Year,
                        b.Description,
                        b.CreatedBy,
                        b.CreatedDate,
                        b.IsSalaryBudget,
                        b.TeacherId,
                        b.UpdatedDate,
                        b.IsActive,
                        t.FirstName + ' ' + t.LastName as TeacherName,
                        u.Username as CreatedByName
                     FROM Budget b
                     LEFT JOIN Teachers t ON b.TeacherId = t.TeacherId
                     LEFT JOIN Users u ON b.CreatedBy = u.UserId
                     WHERE (@SearchTerm = '' OR 
                          b.Category LIKE '%' + @SearchTerm + '%' OR 
                          b.Description LIKE '%' + @SearchTerm + '%' OR
                          t.FirstName LIKE '%' + @SearchTerm + '%' OR
                          t.LastName LIKE '%' + @SearchTerm + '%')
                     AND (@Year IS NULL OR b.Year = @Year)
                     AND (@Month IS NULL OR b.Month = @Month)
                     AND (@BudgetType IS NULL OR 
                          (@BudgetType = 'Salary' AND b.IsSalaryBudget = 1) OR
                          (@BudgetType = 'Regular' AND b.IsSalaryBudget = 0))
                     AND (@Status IS NULL OR 
                          (@Status = 'Active' AND b.IsActive = 1) OR
                          (@Status = 'Inactive' AND b.IsActive = 0))
                     ORDER BY b.Year DESC, b.Month DESC, b.CreatedDate DESC";
        }

        private void LoadYearFilter()
        {
            try
            {
                DdlYearFilter.Items.Clear();
                DdlYearFilter.Items.Add(new ListItem("All Years", ""));

                int currentYear = DateTime.Now.Year;
                for (int year = currentYear + 2; year >= currentYear - 2; year--)
                {
                    DdlYearFilter.Items.Add(new ListItem(year.ToString(), year.ToString()));
                }

                // Set to empty to show all years by default
                DdlYearFilter.SelectedValue = "";
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading year filter: {ex.Message}", "error");
            }
        }

        private void ToggleBudgetStatus(int budgetId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Budget 
                                    SET IsActive = ~IsActive, 
                                        UpdatedDate = GETDATE() 
                                    WHERE BudgetId = @BudgetId;
                                    
                                    SELECT IsActive FROM Budget WHERE BudgetId = @BudgetId";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@BudgetId", budgetId);
                        con.Open();
                        bool newStatus = (bool)cmd.ExecuteScalar();

                        ShowMessage($"Budget {(newStatus ? "activated" : "deactivated")} successfully!", "success");
                    }
                }
                BindBudgetsGrid();
            }
            catch (Exception ex)
            {
                ShowMessage($"Error updating budget status: {ex.Message}", "error");
            }
        }

        private void DeleteBudget(int budgetId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "DELETE FROM Budget WHERE BudgetId = @BudgetId";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@BudgetId", budgetId);
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowMessage("Budget deleted successfully!", "success");
                        }
                        else
                        {
                            ShowMessage("Budget not found or already deleted!", "warning");
                        }
                    }
                }
                BindBudgetsGrid();
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 547) // Foreign key constraint violation
                {
                    ShowMessage("Cannot delete this budget because it is referenced by other records.", "error");
                }
                else
                {
                    ShowMessage($"Error deleting budget: {sqlEx.Message}", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error deleting budget: {ex.Message}", "error");
            }
        }

        private void UpdateSummaryStats()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT 
                                    COUNT(*) as TotalBudgets,
                                    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) as ActiveBudgets,
                                    SUM(CASE WHEN IsSalaryBudget = 1 THEN 1 ELSE 0 END) as SalaryBudgets,
                                    ISNULL(SUM(BudgetAmount), 0) as TotalAmount
                                    FROM Budget 
                                    WHERE (@SearchTerm = '' OR 
                                          Category LIKE '%' + @SearchTerm + '%' OR 
                                          Description LIKE '%' + @SearchTerm + '%')
                                    AND (@Year IS NULL OR Year = @Year)
                                    AND (@Month IS NULL OR Month = @Month)
                                    AND (@BudgetType IS NULL OR 
                                         (@BudgetType = 'Salary' AND IsSalaryBudget = 1) OR
                                         (@BudgetType = 'Regular' AND IsSalaryBudget = 0))
                                    AND (@Status IS NULL OR 
                                         (@Status = 'Active' AND IsActive = 1) OR
                                         (@Status = 'Inactive' AND IsActive = 0))";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@SearchTerm", string.IsNullOrEmpty(TxtSearch.Text.Trim()) ? "" : TxtSearch.Text.Trim());

                        if (string.IsNullOrEmpty(DdlYearFilter.SelectedValue) || DdlYearFilter.SelectedValue == "")
                            cmd.Parameters.AddWithValue("@Year", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@Year", DdlYearFilter.SelectedValue);

                        if (string.IsNullOrEmpty(DdlMonthFilter.SelectedValue) || DdlMonthFilter.SelectedValue == "")
                            cmd.Parameters.AddWithValue("@Month", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@Month", DdlMonthFilter.SelectedValue);

                        if (string.IsNullOrEmpty(DdlTypeFilter.SelectedValue) || DdlTypeFilter.SelectedValue == "")
                            cmd.Parameters.AddWithValue("@BudgetType", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@BudgetType", DdlTypeFilter.SelectedValue);

                        if (string.IsNullOrEmpty(DdlStatusFilter.SelectedValue) || DdlStatusFilter.SelectedValue == "")
                            cmd.Parameters.AddWithValue("@Status", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@Status", DdlStatusFilter.SelectedValue);

                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                LblTotalBudgets.Text = reader["TotalBudgets"].ToString();
                                LblActiveBudgets.Text = reader["ActiveBudgets"].ToString();
                                LblSalaryBudgets.Text = reader["SalaryBudgets"].ToString();

                                decimal totalAmount = Convert.ToDecimal(reader["TotalAmount"]);
                                LblTotalAmount.Text = $"Rs{totalAmount:N2}";
                                LblGridTotalAmount.Text = $"Total: Rs{totalAmount:N2}";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Set default values on error
                LblTotalBudgets.Text = "0";
                LblActiveBudgets.Text = "0";
                LblSalaryBudgets.Text = "0";
                LblTotalAmount.Text = "Rs0.00";
                LblGridTotalAmount.Text = "Total: Rs0.00";

                System.Diagnostics.Debug.WriteLine($"Error in UpdateSummaryStats: {ex.Message}");
            }
        }

        private void ShowNoDataMessage()
        {
            // Debug message
            System.Diagnostics.Debug.WriteLine("No budget data found in database with current filters");
        }

        private void ExportToExcel()
        {
            try
            {
                // Get the data for export
                DataTable dt = GetExportData();

                if (dt == null || dt.Rows.Count == 0)
                {
                    ShowExportStatus("No data available to export.", "error");
                    ShowMessage("No data available to export.", "warning");
                    return;
                }

                // Clear the response
                Response.Clear();
                Response.Buffer = true;

                // Set the content type and headers for Excel
                Response.AddHeader("content-disposition", "attachment;filename=Budgets_Export_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".xls");
                Response.Charset = "";
                Response.ContentType = "application/vnd.ms-excel";

                // Create StringWriter and HtmlTextWriter
                using (StringWriter sw = new StringWriter())
                {
                    using (HtmlTextWriter hw = new HtmlTextWriter(sw))
                    {
                        // Create a temporary grid for export
                        GridView gvExport = new GridView();
                        gvExport.DataSource = dt;
                        gvExport.DataBind();

                        // Apply basic formatting for Excel
                        gvExport.HeaderStyle.BackColor = System.Drawing.Color.LightGray;
                        gvExport.HeaderStyle.Font.Bold = true;

                        // Add border style to all cells
                        gvExport.BorderStyle = BorderStyle.Solid;
                        gvExport.BorderWidth = 1;

                        // Render the grid
                        gvExport.RenderControl(hw);

                        // Write the content to response
                        Response.Output.Write(sw.ToString());
                        Response.Flush();
                    }
                }

                // End the response properly
                Response.End();
            }
            catch (System.Threading.ThreadAbortException)
            {
                // ThreadAbortException is expected when using Response.End()
                // We can ignore this exception
            }
            catch (Exception ex)
            {
                ShowExportStatus($"Error exporting data: {ex.Message}", "error");
                ShowMessage($"Error exporting data: {ex.Message}", "error");
                System.Diagnostics.Debug.WriteLine($"Export Error: {ex.Message}");
            }
        }

        private DataTable GetExportData()
        {
            DataTable dt = new DataTable();
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    // Use the same filters as the main grid
                    string query = @"SELECT 
                                    BudgetId as 'ID',
                                    Category as 'Category',
                                    BudgetAmount as 'Amount',
                                    Month as 'Month',
                                    Year as 'Year',
                                    Description as 'Description',
                                    CASE WHEN IsSalaryBudget = 1 THEN 'Salary' ELSE 'Regular' END as 'Type',
                                    CASE WHEN IsActive = 1 THEN 'Active' ELSE 'Inactive' END as 'Status',
                                    CreatedDate as 'Created Date'
                                    FROM Budget 
                                    WHERE (@SearchTerm = '' OR 
                                          Category LIKE '%' + @SearchTerm + '%' OR 
                                          Description LIKE '%' + @SearchTerm + '%')
                                    AND (@Year IS NULL OR Year = @Year)
                                    AND (@Month IS NULL OR Month = @Month)
                                    AND (@BudgetType IS NULL OR 
                                         (@BudgetType = 'Salary' AND IsSalaryBudget = 1) OR
                                         (@BudgetType = 'Regular' AND IsSalaryBudget = 0))
                                    AND (@Status IS NULL OR 
                                         (@Status = 'Active' AND IsActive = 1) OR
                                         (@Status = 'Inactive' AND IsActive = 0))
                                    ORDER BY Year DESC, Month DESC, CreatedDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        // Apply the same filters as the main grid
                        cmd.Parameters.AddWithValue("@SearchTerm", string.IsNullOrEmpty(TxtSearch.Text.Trim()) ? "" : TxtSearch.Text.Trim());

                        if (string.IsNullOrEmpty(DdlYearFilter.SelectedValue) || DdlYearFilter.SelectedValue == "")
                            cmd.Parameters.AddWithValue("@Year", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@Year", DdlYearFilter.SelectedValue);

                        if (string.IsNullOrEmpty(DdlMonthFilter.SelectedValue) || DdlMonthFilter.SelectedValue == "")
                            cmd.Parameters.AddWithValue("@Month", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@Month", DdlMonthFilter.SelectedValue);

                        if (string.IsNullOrEmpty(DdlTypeFilter.SelectedValue) || DdlTypeFilter.SelectedValue == "")
                            cmd.Parameters.AddWithValue("@BudgetType", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@BudgetType", DdlTypeFilter.SelectedValue);

                        if (string.IsNullOrEmpty(DdlStatusFilter.SelectedValue) || DdlStatusFilter.SelectedValue == "")
                            cmd.Parameters.AddWithValue("@Status", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@Status", DdlStatusFilter.SelectedValue);

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetExportData: {ex.Message}");
                throw; // Re-throw to handle in calling method
            }
            return dt;
        }

        public string GetMonthName(string monthNumber)
        {
            if (int.TryParse(monthNumber, out int month))
            {
                string[] months = {
                    "", "January", "February", "March", "April", "May", "June",
                    "July", "August", "September", "October", "November", "December"
                };

                return (month >= 1 && month <= 12) ? months[month] : "Invalid Month";
            }
            return "Invalid Month";
        }

        public string GetTeacherName(object teacherId)
        {
            if (teacherId == null || teacherId == DBNull.Value || string.IsNullOrEmpty(teacherId.ToString()))
                return "N/A";

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT FirstName + ' ' + LastName as TeacherName FROM Teachers WHERE TeacherId = @TeacherId";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                        con.Open();
                        object result = cmd.ExecuteScalar();
                        return result != null ? result.ToString() : "N/A";
                    }
                }
            }
            catch
            {
                return "N/A";
            }
        }

        private void ShowMessage(string message, string type = "success")
        {
            // Convert type to Bootstrap alert class
            string alertClass;
            switch (type.ToLower())
            {
                case "error":
                    alertClass = "alert-danger";
                    break;
                case "warning":
                    alertClass = "alert-warning";
                    break;
                case "info":
                    alertClass = "alert-info";
                    break;
                default:
                    alertClass = "alert-success";
                    break;
            }

            string script = $@"
                <script type='text/javascript'>
                    $(document).ready(function() {{
                        showNotification('{message.Replace("'", "\\'")}', '{alertClass}');
                    }});
                </script>";

            ClientScript.RegisterStartupScript(this.GetType(), "Alert", script);
        }

        private void ShowExportStatus(string message, string type = "success")
        {
            // Update the export status div
            exportStatus.InnerHtml = message;
            exportStatus.Style.Add("display", "block");

            if (type == "error")
            {
                exportStatus.Attributes["class"] = "export-status export-error";
            }
            else
            {
                exportStatus.Attributes["class"] = "export-status export-success";
            }

            // Hide the status after 5 seconds
            string script = $@"
                <script type='text/javascript'>
                    setTimeout(function() {{
                        var statusDiv = document.getElementById('{exportStatus.ClientID}');
                        if (statusDiv) {{
                            statusDiv.style.display = 'none';
                        }}
                    }}, 5000);
                </script>";

            ClientScript.RegisterStartupScript(this.GetType(), "HideExportStatus", script);
        }
    }
}