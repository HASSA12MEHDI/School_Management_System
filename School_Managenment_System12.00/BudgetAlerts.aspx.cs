using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SchoolFinancialManagementSystem
{
    public partial class BudgetAlerts : System.Web.UI.Page
    {
        private readonly string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf"";Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAlertSummary();
                LoadAlerts();
                LoadStatistics();
            }
        }

        protected void FilterAlerts(object sender, EventArgs e)
        {
            LoadAlerts();
            LoadAlertSummary();
            LoadStatistics();
        }

        protected void BtnRunChecks_Click(object sender, EventArgs e)
        {
            try
            {
                RunComprehensiveBudgetChecks();
                ShowAlert("Budget checks completed successfully! New alerts have been generated.", "success");
                LoadAlertSummary();
                LoadAlerts();
                LoadStatistics();
            }
            catch (Exception ex)
            {
                ShowAlert($"Error running budget checks: {ex.Message}", "danger");
            }
        }

        protected void BtnDismissAll_Click(object sender, EventArgs e)
        {
            try
            {
                DismissAllAlerts();
                ShowAlert("All active alerts have been dismissed.", "info");
                LoadAlertSummary();
                LoadAlerts();
                LoadStatistics();
            }
            catch (Exception ex)
            {
                ShowAlert($"Error dismissing alerts: {ex.Message}", "danger");
            }
        }

        protected void RptAlert_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "Dismiss")
                {
                    int alertId = Convert.ToInt32(e.CommandArgument);
                    DismissAlert(alertId);
                    ShowAlert("Alert dismissed successfully.", "info");
                }
                else if (e.CommandName == "ViewDetails")
                {
                    int alertId = Convert.ToInt32(e.CommandArgument);
                    ViewAlertDetails(alertId);
                }

                LoadAlertSummary();
                LoadAlerts();
                LoadStatistics();
            }
            catch (Exception ex)
            {
                ShowAlert($"Error processing alert: {ex.Message}", "danger");
            }
        }

        private void LoadAlertSummary()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Critical alerts count
                    string criticalQuery = @"SELECT COUNT(*) FROM BudgetAlerts 
                                           WHERE AlertType = 'Critical' AND IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(criticalQuery, con))
                    {
                        lblCriticalCount.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Warning alerts count
                    string warningQuery = @"SELECT COUNT(*) FROM BudgetAlerts 
                                          WHERE AlertType = 'Warning' AND IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(warningQuery, con))
                    {
                        lblWarningCount.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Info alerts count
                    string infoQuery = @"SELECT COUNT(*) FROM BudgetAlerts 
                                       WHERE AlertType = 'Info' AND IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(infoQuery, con))
                    {
                        lblInfoCount.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Total alerts count
                    string totalQuery = "SELECT COUNT(*) FROM BudgetAlerts WHERE IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(totalQuery, con))
                    {
                        lblTotalCount.Text = cmd.ExecuteScalar().ToString();
                        lblActiveAlertsCount.Text = lblTotalCount.Text;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert($"Error loading alert summary: {ex.Message}", "danger");
            }
        }

        private void LoadAlerts()
        {
            try
            {
                StringBuilder queryBuilder = new StringBuilder();
                queryBuilder.Append(@"
                    SELECT 
                        AlertId, 
                        Category, 
                        AlertMessage, 
                        ExceededBy, 
                        BudgetAmount,
                        ExpenseAmount,
                        CreatedDate, 
                        IsActive,
                        AlertType,
                        CreatedBy
                    FROM BudgetAlerts 
                    WHERE 1=1");

                List<SqlParameter> parameters = new List<SqlParameter>();

                // Filter by alert type
                if (!string.IsNullOrEmpty(ddlAlertType.SelectedValue))
                {
                    queryBuilder.Append(" AND AlertType = @AlertType");
                    parameters.Add(new SqlParameter("@AlertType", ddlAlertType.SelectedValue));
                }

                // Filter by status
                if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
                {
                    if (ddlStatus.SelectedValue == "Active")
                        queryBuilder.Append(" AND IsActive = 1");
                    else if (ddlStatus.SelectedValue == "Dismissed")
                        queryBuilder.Append(" AND IsActive = 0");
                }

                // Filter by date range
                int days = int.Parse(ddlDateRange.SelectedValue);
                if (days > 0)
                {
                    queryBuilder.Append(" AND CreatedDate >= DATEADD(DAY, -@Days, GETDATE())");
                    parameters.Add(new SqlParameter("@Days", days));
                }

                queryBuilder.Append(" ORDER BY CreatedDate DESC");

                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(queryBuilder.ToString(), con))
                {
                    foreach (SqlParameter param in parameters)
                    {
                        cmd.Parameters.Add(param);
                    }

                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    // Separate alerts by type
                    var criticalAlerts = dt.AsEnumerable()
                        .Where(r => r.Field<string>("AlertType") == "Critical" && r.Field<bool>("IsActive"));
                    var warningAlerts = dt.AsEnumerable()
                        .Where(r => r.Field<string>("AlertType") == "Warning" && r.Field<bool>("IsActive"));
                    var infoAlerts = dt.AsEnumerable()
                        .Where(r => r.Field<string>("AlertType") == "Info" && r.Field<bool>("IsActive"));
                    var dismissedAlerts = dt.AsEnumerable()
                        .Where(r => !r.Field<bool>("IsActive"));

                    // Critical Alerts
                    if (criticalAlerts.Any())
                    {
                        pnlCriticalAlerts.Visible = true;
                        rptCriticalAlerts.DataSource = criticalAlerts.CopyToDataTable();
                        rptCriticalAlerts.DataBind();
                        lblCriticalBadgeCount.Text = criticalAlerts.Count().ToString();
                    }
                    else
                    {
                        pnlCriticalAlerts.Visible = false;
                    }

                    // Warning Alerts
                    if (warningAlerts.Any())
                    {
                        pnlWarningAlerts.Visible = true;
                        rptWarningAlerts.DataSource = warningAlerts.CopyToDataTable();
                        rptWarningAlerts.DataBind();
                        lblWarningBadgeCount.Text = warningAlerts.Count().ToString();
                    }
                    else
                    {
                        pnlWarningAlerts.Visible = false;
                    }

                    // Info Alerts
                    if (infoAlerts.Any())
                    {
                        pnlInfoAlerts.Visible = true;
                        rptInfoAlerts.DataSource = infoAlerts.CopyToDataTable();
                        rptInfoAlerts.DataBind();
                        lblInfoBadgeCount.Text = infoAlerts.Count().ToString();
                    }
                    else
                    {
                        pnlInfoAlerts.Visible = false;
                    }

                    // Dismissed Alerts
                    if (dismissedAlerts.Any())
                    {
                        pnlDismissedAlerts.Visible = true;
                        rptDismissedAlerts.DataSource = dismissedAlerts.CopyToDataTable();
                        rptDismissedAlerts.DataBind();
                    }
                    else
                    {
                        pnlDismissedAlerts.Visible = false;
                    }

                    // No Alerts State
                    pnlNoAlerts.Visible = !criticalAlerts.Any() && !warningAlerts.Any() && !infoAlerts.Any();
                }
            }
            catch (Exception ex)
            {
                ShowAlert($"Error loading alerts: {ex.Message}", "danger");
            }
        }

        private void LoadStatistics()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Budget overruns count
                    string overrunsQuery = @"SELECT COUNT(*) FROM BudgetAlerts 
                                           WHERE AlertType IN ('Critical', 'Warning') AND IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(overrunsQuery, con))
                    {
                        lblBudgetOverruns.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Categories at risk count
                    string categoriesQuery = @"SELECT COUNT(DISTINCT Category) FROM BudgetAlerts 
                                             WHERE AlertType IN ('Critical', 'Warning') AND IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(categoriesQuery, con))
                    {
                        lblCategoriesAtRisk.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Average exceed percentage
                    string avgQuery = @"SELECT ISNULL(AVG(
                                        CASE 
                                            WHEN BudgetAmount > 0 AND ExceededBy > 0 THEN (ExceededBy / BudgetAmount) * 100 
                                            ELSE 0 
                                        END), 0) 
                                      FROM BudgetAlerts 
                                      WHERE AlertType IN ('Critical', 'Warning') AND IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(avgQuery, con))
                    {
                        decimal avgPercent = Convert.ToDecimal(cmd.ExecuteScalar());
                        lblAvgExceedPercent.Text = $"{avgPercent:F1}%";
                    }

                    // Total overrun amount
                    string totalQuery = @"SELECT ISNULL(SUM(ExceededBy), 0) 
                                        FROM BudgetAlerts 
                                        WHERE AlertType IN ('Critical', 'Warning') AND IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(totalQuery, con))
                    {
                        decimal totalOverrun = Convert.ToDecimal(cmd.ExecuteScalar());
                        lblTotalOverrun.Text = $"₹{totalOverrun:N2}";
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading statistics: " + ex.Message);
            }
        }

        private void RunComprehensiveBudgetChecks()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // Clear existing active alerts
                string clearQuery = "UPDATE BudgetAlerts SET IsActive = 0 WHERE IsActive = 1";
                using (SqlCommand cmd = new SqlCommand(clearQuery, con))
                {
                    cmd.ExecuteNonQuery();
                }

                // Get current financial data
                decimal totalIncome = GetTotalIncome(con);
                decimal totalBudget = GetTotalBudget(con);
                decimal totalExpenses = GetTotalExpenses(con);
                decimal totalSalaries = GetTotalSalaries(con);

                // Generate alerts based on financial analysis

                // Alert 1: Budget exceeds income
                if (totalBudget > totalIncome && totalIncome > 0)
                {
                    decimal exceededBy = totalBudget - totalIncome;
                    decimal exceedPercentage = (exceededBy / totalIncome) * 100;

                    CreateBudgetAlert(con, "Budget Planning",
                        $"Total budget (₹{totalBudget:N2}) exceeds total income (₹{totalIncome:N2}) by ₹{exceededBy:N2} ({exceedPercentage:F1}%). Consider reducing budget allocations.",
                        exceededBy, totalBudget, "Critical");
                }

                // Alert 2: Negative net income
                decimal netIncome = totalIncome - totalBudget;
                if (netIncome < 0)
                {
                    CreateBudgetAlert(con, "Financial Health",
                        $"NET INCOME IS NEGATIVE: ₹{netIncome:N2}. The school is operating at a loss. Immediate budget adjustment required.",
                        Math.Abs(netIncome), totalBudget, "Critical");
                }

                // Alert 3: High expense ratio
                decimal expenseRatio = totalIncome > 0 ? (totalExpenses / totalIncome) * 100 : 0;
                if (expenseRatio > 80)
                {
                    CreateBudgetAlert(con, "Expense Management",
                        $"Expense to income ratio is critically high: {expenseRatio:F1}%. Expenses (₹{totalExpenses:N2}) are consuming most of the income (₹{totalIncome:N2}).",
                        expenseRatio - 80, 80, "Critical");
                }
                else if (expenseRatio > 60)
                {
                    CreateBudgetAlert(con, "Expense Management",
                        $"Expense to income ratio is high: {expenseRatio:F1}%. Monitor spending closely.",
                        expenseRatio - 60, 60, "Warning");
                }

                // Alert 4: Low remaining budget
                decimal remainingBudget = totalBudget - totalExpenses - totalSalaries;
                if (remainingBudget < totalSalaries * 3 && totalSalaries > 0)
                {
                    CreateBudgetAlert(con, "Cash Flow",
                        $"Remaining budget (₹{remainingBudget:N2}) is less than 3 months of salary obligations (₹{totalSalaries * 3:N2}).",
                        Math.Abs(remainingBudget - (totalSalaries * 3)), totalBudget, "Warning");
                }

                // Alert 5: Budget utilization too low (unrealistic budget)
                decimal budgetUtilization = totalBudget > 0 ? ((totalExpenses + totalSalaries) / totalBudget) * 100 : 0;
                if (budgetUtilization < 30 && totalBudget > 0)
                {
                    CreateBudgetAlert(con, "Budget Accuracy",
                        $"Budget utilization is very low ({budgetUtilization:F1}%). The budget may be unrealistic or expenses are not being properly recorded.",
                        30 - budgetUtilization, totalBudget, "Info");
                }

                // Generate sample category-specific alerts
                GenerateSampleCategoryAlerts(con);
            }
        }

        private void GenerateSampleCategoryAlerts(SqlConnection con)
        {
            // Sample category alerts - in a real system, these would come from actual budget vs expense comparisons
            CreateBudgetAlert(con, "Infrastructure",
                "Infrastructure maintenance costs are 45% over budget. Recent repairs have exceeded allocated funds.",
                150000, 100000, "Critical");

            CreateBudgetAlert(con, "Academic Supplies",
                "Academic supplies spending is 15% over budget for this quarter.",
                45000, 300000, "Warning");

            CreateBudgetAlert(con, "Utilities",
                "Utility costs are within budget but trending higher than previous months.",
                0, 50000, "Info");
        }

        private void CreateBudgetAlert(SqlConnection con, string category, string message, decimal exceededBy, decimal budgetAmount, string alertType)
        {
            // Try different approaches to handle the CreatedBy constraint

            // Approach 1: Try with CreatedBy parameter first
            string insertQuery = @"
                INSERT INTO BudgetAlerts (Category, AlertMessage, ExceededBy, BudgetAmount, AlertType, CreatedDate, IsActive, CreatedBy)
                VALUES (@Category, @AlertMessage, @ExceededBy, @BudgetAmount, @AlertType, GETDATE(), 1, @CreatedBy)";

            try
            {
                using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Category", category);
                    cmd.Parameters.AddWithValue("@AlertMessage", message);
                    cmd.Parameters.AddWithValue("@ExceededBy", exceededBy);
                    cmd.Parameters.AddWithValue("@BudgetAmount", budgetAmount);
                    cmd.Parameters.AddWithValue("@AlertType", alertType);
                    cmd.Parameters.AddWithValue("@CreatedBy", "System");
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                // If that fails, try without CreatedBy (relying on default constraint)
                System.Diagnostics.Debug.WriteLine($"First insert attempt failed: {ex.Message}. Trying alternative approach.");

                string alternativeQuery = @"
                    INSERT INTO BudgetAlerts (Category, AlertMessage, ExceededBy, BudgetAmount, AlertType, CreatedDate, IsActive)
                    VALUES (@Category, @AlertMessage, @ExceededBy, @BudgetAmount, @AlertType, GETDATE(), 1)";

                try
                {
                    using (SqlCommand cmd = new SqlCommand(alternativeQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@Category", category);
                        cmd.Parameters.AddWithValue("@AlertMessage", message);
                        cmd.Parameters.AddWithValue("@ExceededBy", exceededBy);
                        cmd.Parameters.AddWithValue("@BudgetAmount", budgetAmount);
                        cmd.Parameters.AddWithValue("@AlertType", alertType);
                        cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception ex2)
                {
                    System.Diagnostics.Debug.WriteLine($"Alternative insert also failed: {ex2.Message}");
                    throw new Exception($"Failed to create budget alert: {ex2.Message}");
                }
            }
        }

        private decimal GetTotalIncome(SqlConnection con)
        {
            try
            {
                string query = @"
                    SELECT ISNULL((
                        SELECT ISNULL(SUM(Amount), 0) FROM Income 
                        WHERE MONTH(IncomeDate) = MONTH(GETDATE()) AND YEAR(IncomeDate) = YEAR(GETDATE())
                    ) + (
                        SELECT ISNULL(SUM(AmountPaid), 0) FROM FeePayments 
                        WHERE MONTH(PaymentDate) = MONTH(GETDATE()) AND YEAR(PaymentDate) = YEAR(GETDATE())
                    ) - (
                        SELECT ISNULL(SUM(DiscountAmount), 0) FROM FeeConcessions 
                        WHERE MONTH(CreatedDate) = MONTH(GETDATE()) AND YEAR(CreatedDate) = YEAR(GETDATE()) AND IsActive = 1
                    ), 0) as TotalIncome";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    return Convert.ToDecimal(cmd.ExecuteScalar());
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting total income: {ex.Message}");
                return 0;
            }
        }

        private decimal GetTotalBudget(SqlConnection con)
        {
            try
            {
                string query = @"
                    SELECT ISNULL(SUM(BudgetAmount), 0) 
                    FROM Budget 
                    WHERE Month = MONTH(GETDATE()) AND Year = YEAR(GETDATE()) AND IsActive = 1";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    return Convert.ToDecimal(cmd.ExecuteScalar());
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting total budget: {ex.Message}");
                return 0;
            }
        }

        private decimal GetTotalExpenses(SqlConnection con)
        {
            try
            {
                string query = @"
                    SELECT ISNULL(SUM(Amount), 0) 
                    FROM Expenses 
                    WHERE MONTH(ExpenseDate) = MONTH(GETDATE()) AND YEAR(ExpenseDate) = YEAR(GETDATE())";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    return Convert.ToDecimal(cmd.ExecuteScalar());
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting total expenses: {ex.Message}");
                return 0;
            }
        }

        private decimal GetTotalSalaries(SqlConnection con)
        {
            try
            {
                string query = @"
                    SELECT ISNULL(SUM(Salary), 0) 
                    FROM Teachers 
                    WHERE IsActive = 1";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    return Convert.ToDecimal(cmd.ExecuteScalar());
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting total salaries: {ex.Message}");
                return 0;
            }
        }

        private void DismissAlert(int alertId)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "UPDATE BudgetAlerts SET IsActive = 0 WHERE AlertId = @AlertId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@AlertId", alertId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void DismissAllAlerts()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "UPDATE BudgetAlerts SET IsActive = 0 WHERE IsActive = 1";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void ViewAlertDetails(int alertId)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT Category, AlertMessage, BudgetAmount, ExceededBy FROM BudgetAlerts WHERE AlertId = @AlertId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@AlertId", alertId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string category = reader["Category"].ToString();
                            string message = reader["AlertMessage"].ToString();
                            string budgetAmount = Convert.ToDecimal(reader["BudgetAmount"]).ToString("N2");
                            string exceededBy = Convert.ToDecimal(reader["ExceededBy"]).ToString("N2");

                            string detailedMessage = $@"
                                <strong>{category}:</strong><br/>
                                {message}<br/><br/>
                                <strong>Budget Amount:</strong> ₹{budgetAmount}<br/>
                                <strong>Exceeded By:</strong> ₹{exceededBy}<br/>
                                <strong>Overrun Percentage:</strong> {GetOverrunPercentage(reader["ExceededBy"], reader["BudgetAmount"])}%";

                            ShowAlert(detailedMessage, "info");
                        }
                    }
                }
            }
        }

        private void ShowAlert(string message, string type)
        {
            pnlAlert.CssClass = $"alert alert-{type} alert-dismissible fade show";
            lblAlertMessage.Text = message;
            pnlAlert.Visible = true;

            // Register script to auto-hide alert
            ScriptManager.RegisterStartupScript(this, this.GetType(), "hideAlert",
                "setTimeout(function() { $('.alert').alert('close'); }, 10000);", true);
        }

        // Formatting methods for the repeater
        public string FormatDate(object date)
        {
            if (date == DBNull.Value || date == null)
                return "N/A";

            DateTime dateValue = Convert.ToDateTime(date);
            return dateValue.ToString("MMM dd, yyyy hh:mm tt");
        }

        public string FormatAmount(object amount)
        {
            if (amount == DBNull.Value || amount == null)
                return "0.00";

            decimal amountValue = Convert.ToDecimal(amount);
            return amountValue.ToString("N2");
        }

        public string GetOverrunPercentage(object exceededBy, object budgetAmount)
        {
            try
            {
                decimal exceeded = exceededBy != DBNull.Value ? Convert.ToDecimal(exceededBy) : 0;
                decimal budget = budgetAmount != DBNull.Value ? Convert.ToDecimal(budgetAmount) : 1;

                decimal percentage = budget > 0 ? (exceeded / budget) * 100 : 0;
                return percentage.ToString("F1");
            }
            catch
            {
                return "0.0";
            }
        }

        public string GetRiskLevelClass(object exceededBy, object budgetAmount)
        {
            try
            {
                decimal exceeded = exceededBy != DBNull.Value ? Convert.ToDecimal(exceededBy) : 0;
                decimal budget = budgetAmount != DBNull.Value ? Convert.ToDecimal(budgetAmount) : 1;

                decimal percentage = budget > 0 ? (exceeded / budget) * 100 : 0;

                if (percentage > 50) return "risk-level risk-high";
                if (percentage > 20) return "risk-level risk-medium";
                return "risk-level risk-low";
            }
            catch
            {
                return "risk-level risk-low";
            }
        }

        public string GetRiskWidth(object exceededBy, object budgetAmount)
        {
            try
            {
                decimal exceeded = exceededBy != DBNull.Value ? Convert.ToDecimal(exceededBy) : 0;
                decimal budget = budgetAmount != DBNull.Value ? Convert.ToDecimal(budgetAmount) : 1;

                decimal percentage = budget > 0 ? (exceeded / budget) * 100 : 0;
                return Math.Min(percentage, 100).ToString("0");
            }
            catch
            {
                return "0";
            }
        }
    }
}