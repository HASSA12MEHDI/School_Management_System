using System;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class BudgetReports : System.Web.UI.Page
    {
        private readonly string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf"";Integrated Security=True";

        // Public properties for JavaScript access
        public decimal TotalIncomeValue { get; set; }
        public decimal TotalExpensesValue { get; set; }
        public decimal TotalBudgetValue { get; set; }
        public decimal TotalSalariesValue { get; set; }
        public decimal NetIncomeValue { get; set; }
        public decimal RemainBudgetValue { get; set; }
        public decimal TotalProfitValue { get; set; }
        public decimal FeeConcessionsValue { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set default to 2025 to match your data
                if (string.IsNullOrEmpty(DdlYear.SelectedValue))
                    DdlYear.SelectedValue = "2025";

                LoadBudgetData();

                LoadFeeConcessions();
            }
        }

        protected void BtnRefreshReports_Click(object sender, EventArgs e)
        {
            LoadBudgetData();

            LoadFeeConcessions();

            // Show success message
            ScriptManager.RegisterStartupScript(this, GetType(), "refreshSuccess",
                "showAlert('Reports refreshed successfully!', 'success');", true);
        }

        protected void BtnRunBudgetChecks_Click(object sender, EventArgs e)
        {
            RunBudgetHealthChecks();

            ShowAlert("Budget health checks completed successfully!", "success");
        }

        protected void DdlYear_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadBudgetData();

            LoadFeeConcessions();
        }

        private void LoadBudgetData()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Get selected year from dropdown
                    int selectedYear = Convert.ToInt32(DdlYear.SelectedValue);

                    // Debug: Check what year we're filtering for
                    System.Diagnostics.Debug.WriteLine($"Filtering for Year: {selectedYear}");

                    // 1. Calculate Total Income (Income + FeePayment - Concessions)
                    decimal incomeFromTable = GetIncomeFromTable(con, selectedYear);
                    decimal totalFeePayment = GetTotalFeePayment(con, selectedYear);
                    decimal totalFeeConcession = GetTotalFeeConcession(con, selectedYear);

                    // CORRECTED: Total income = Income from table + Fee payments - Fee concessions
                    decimal totalIncome = incomeFromTable + totalFeePayment - totalFeeConcession;

                    // Store fee concessions value for display
                    FeeConcessionsValue = totalFeeConcession;

                    // Debug income values
                    System.Diagnostics.Debug.WriteLine($"Income Breakdown - From Table: {incomeFromTable}, Fee Payments: {totalFeePayment}, Concessions: {totalFeeConcession}, Total: {totalIncome}");

                    // Update Income Labels
                    LblTotalIncome.Text = FormatCurrency(totalIncome);
                    LblIncomeFromTable.Text = FormatCurrency(incomeFromTable);
                    LblTotalFeePayment.Text = FormatCurrency(totalFeePayment);
                    LblTotalFeeConcession.Text = FormatCurrency(totalFeeConcession);
                    LblNetIncomeCalc.Text = FormatCurrency(totalIncome);

                    // 2. Calculate Total Expenses
                    decimal totalExpenses = GetTotalExpenses(con, selectedYear);
                    LblTotalExpenses.Text = FormatCurrency(totalExpenses);
                    LblExpensesTotal.Text = FormatCurrency(totalExpenses);

                    // 3. Calculate Total Budget
                    decimal totalBudget = GetTotalBudget(con, selectedYear);
                    LblTotalBudget.Text = FormatCurrency(totalBudget);
                    LblBudgetTotal.Text = FormatCurrency(totalBudget);

                    // 4. Calculate Total Salaries
                    decimal totalSalaries = GetTotalSalaries(con);
                    LblTotalSalaries.Text = FormatCurrency(totalSalaries);
                    LblSalariesTotal.Text = FormatCurrency(totalSalaries);

                    // 5. Calculate Net Income (Total Income - Total Budget)
                    decimal netIncome = totalIncome - totalBudget;
                    LblNetIncome.Text = FormatCurrency(netIncome);

                    // 6. Calculate Remain Budget (Budget - Expenses - Salaries)
                    decimal remainBudget = totalBudget - totalExpenses - totalSalaries;
                    LblRemainBudget.Text = FormatCurrency(remainBudget);
                    LblRemainBudgetCalc.Text = FormatCurrency(remainBudget);

                    // 7. Calculate Total Profit (Net Income + Remain Budget)
                    decimal totalProfit = netIncome + remainBudget;
                    LblTotalProfit.Text = FormatCurrency(totalProfit);

                    // Store values for JavaScript
                    TotalIncomeValue = totalIncome;
                    TotalExpensesValue = totalExpenses;
                    TotalBudgetValue = totalBudget;
                    TotalSalariesValue = totalSalaries;
                    NetIncomeValue = netIncome;
                    RemainBudgetValue = remainBudget;
                    TotalProfitValue = totalProfit;

                    // Update fee concessions display
                    LblConcessionYear.Text = selectedYear.ToString();
                    LblTotalConcessionDisplay.Text = FormatCurrency(totalFeeConcession);

                    // Set negative value styling
                    SetNegativeValueStyling();

                    // Update financial health summary
                    UpdateFinancialHealthSummary(totalBudget, totalExpenses, totalSalaries, totalIncome, remainBudget, netIncome);

                    // Run budget health checks
                    RunBudgetHealthChecks(con, totalIncome, totalBudget, totalExpenses, totalSalaries, netIncome, remainBudget, selectedYear);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in LoadBudgetData: {ex.Message}");
                ShowAlert($"Error loading budget data: {ex.Message}", "danger");
            }
        }

        private decimal GetIncomeFromTable(SqlConnection con, int year)
        {
            try
            {
                string query = @"SELECT ISNULL(SUM(Amount), 0) 
                               FROM Income 
                               WHERE YEAR(IncomeDate) = @Year";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Year", year);

                    object result = cmd.ExecuteScalar();
                    decimal totalIncome = result != DBNull.Value ? Convert.ToDecimal(result) : 0;

                    System.Diagnostics.Debug.WriteLine($"GetIncomeFromTable Result for Year {year}: {totalIncome}");
                    return totalIncome;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetIncomeFromTable: {ex.Message}");
                return 0;
            }
        }

        private decimal GetTotalFeePayment(SqlConnection con, int year)
        {
            try
            {
                string query = @"SELECT ISNULL(SUM(AmountPaid), 0) 
                               FROM FeePayments 
                               WHERE YEAR(PaymentDate) = @Year";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Year", year);

                    object result = cmd.ExecuteScalar();
                    decimal feePayments = result != DBNull.Value ? Convert.ToDecimal(result) : 0;
                    System.Diagnostics.Debug.WriteLine($"Total Fee Payments for Year {year}: {feePayments}");
                    return feePayments;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetTotalFeePayment: {ex.Message}");
                return 0;
            }
        }

        private decimal GetTotalFeeConcession(SqlConnection con, int year)
        {
            try
            {
                // CORRECTED: Simplified query to get total fee concessions
                string query = @"SELECT ISNULL(SUM(
                                    CASE 
                                        WHEN DiscountAmount IS NOT NULL AND DiscountAmount > 0 THEN DiscountAmount
                                        WHEN DiscountPercent IS NOT NULL AND DiscountPercent > 0 THEN 
                                            (DiscountPercent / 100.0) * 1000 -- Assuming average fee of 1000 for calculation
                                        ELSE 0 
                                    END), 0) 
                               FROM FeeConcessions 
                               WHERE YEAR(CreatedDate) = @Year 
                               AND IsActive = 1";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Year", year);

                    object result = cmd.ExecuteScalar();
                    decimal concessions = result != DBNull.Value ? Convert.ToDecimal(result) : 0;
                    System.Diagnostics.Debug.WriteLine($"Total Fee Concessions for Year {year}: {concessions}");
                    return concessions;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetTotalFeeConcession: {ex.Message}");
                return 0;
            }
        }

        private decimal GetTotalExpenses(SqlConnection con, int year)
        {
            try
            {
                string query = @"SELECT ISNULL(SUM(Amount), 0) 
                               FROM Expenses 
                               WHERE YEAR(ExpenseDate) = @Year";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Year", year);

                    object result = cmd.ExecuteScalar();
                    decimal expenses = result != DBNull.Value ? Convert.ToDecimal(result) : 0;
                    System.Diagnostics.Debug.WriteLine($"Total Expenses for Year {year}: {expenses}");
                    return expenses;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetTotalExpenses: {ex.Message}");
                return 0;
            }
        }

        private decimal GetTotalBudget(SqlConnection con, int year)
        {
            try
            {
                string query = @"SELECT ISNULL(SUM(BudgetAmount), 0) 
                               FROM Budget 
                               WHERE Year = @Year 
                               AND IsActive = 1";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Year", year);

                    object result = cmd.ExecuteScalar();
                    decimal budget = result != DBNull.Value ? Convert.ToDecimal(result) : 0;
                    System.Diagnostics.Debug.WriteLine($"Total Budget for Year {year}: {budget}");
                    return budget;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetTotalBudget: {ex.Message}");
                return 0;
            }
        }

        private decimal GetTotalSalaries(SqlConnection con)
        {
            try
            {
                string query = @"SELECT ISNULL(SUM(Salary), 0) 
                               FROM Teachers 
                               WHERE IsActive = 1";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    object result = cmd.ExecuteScalar();
                    decimal salaries = result != DBNull.Value ? Convert.ToDecimal(result) : 0;
                    System.Diagnostics.Debug.WriteLine($"Total Salaries: {salaries}");
                    return salaries;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetTotalSalaries: {ex.Message}");
                return 0;
            }
        }



        private void RunBudgetHealthChecks()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Get selected year
                    int selectedYear = Convert.ToInt32(DdlYear.SelectedValue);

                    // Get yearly financial data
                    decimal incomeFromTable = GetIncomeFromTable(con, selectedYear);
                    decimal totalFeePayment = GetTotalFeePayment(con, selectedYear);
                    decimal totalFeeConcession = GetTotalFeeConcession(con, selectedYear);
                    decimal totalIncome = incomeFromTable + totalFeePayment - totalFeeConcession;
                    decimal totalBudget = GetTotalBudget(con, selectedYear);
                    decimal totalExpenses = GetTotalExpenses(con, selectedYear);
                    decimal totalSalaries = GetTotalSalaries(con);
                    decimal netIncome = totalIncome - totalBudget;
                    decimal remainBudget = totalBudget - totalExpenses - totalSalaries;

                    // Check for critical conditions and create alerts if needed
                    RunBudgetHealthChecks(con, totalIncome, totalBudget, totalExpenses, totalSalaries, netIncome, remainBudget, selectedYear);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error running budget health checks: {ex.Message}");
            }
        }

        private void RunBudgetHealthChecks(SqlConnection con, decimal totalIncome, decimal totalBudget, decimal totalExpenses, decimal totalSalaries, decimal netIncome, decimal remainBudget, int year)
        {
            try
            {
                // Clear old alerts for current year
                ClearCurrentYearAlerts(con, year);

                // Check 1: Negative net income
                if (netIncome < 0)
                {
                    CreateBudgetAlert(con, "CRITICAL: Operational Loss",
                        $"Net income is negative: ₹{Math.Abs(netIncome):N2}. Income (₹{totalIncome:N2}) is less than budget (₹{totalBudget:N2}).",
                        Math.Abs(netIncome), totalBudget, year);
                }

                // Check 2: Expenses exceed budget
                if (totalExpenses > totalBudget && totalBudget > 0)
                {
                    decimal exceededBy = totalExpenses - totalBudget;
                    CreateBudgetAlert(con, "Budget Overrun",
                        $"Expenses (₹{totalExpenses:N2}) exceeded budget (₹{totalBudget:N2}) by ₹{exceededBy:N2}",
                        exceededBy, totalBudget, year);
                }

                // Check 3: Low remaining budget
                if (totalBudget > 0 && remainBudget < (totalBudget * 0.1m))
                {
                    decimal remainingPercent = (remainBudget / totalBudget) * 100;
                    CreateBudgetAlert(con, "Low Budget Warning",
                        $"Only {remainingPercent:F1}% of budget remains (₹{remainBudget:N2}). Consider reviewing expenses.",
                        totalBudget * 0.1m - remainBudget, totalBudget, year);
                }

                // Check 4: No budget set
                if (totalBudget == 0)
                {
                    CreateBudgetAlert(con, "Budget Not Set",
                        "No active budget has been configured for the current year.",
                        0, 0, year);
                }

                // Check 5: High expense ratio
                if (totalIncome > 0 && (totalExpenses / totalIncome) > 0.8m)
                {
                    decimal expenseRatio = (totalExpenses / totalIncome) * 100;
                    CreateBudgetAlert(con, "High Expense Ratio",
                        $"Expenses are {expenseRatio:F1}% of income, which is above the 80% recommended threshold.",
                        totalExpenses, totalIncome, year);
                }

                // Check 6: High fee concessions
                if (totalIncome > 0 && (FeeConcessionsValue / totalIncome) > 0.2m)
                {
                    decimal concessionRatio = (FeeConcessionsValue / totalIncome) * 100;
                    CreateBudgetAlert(con, "High Fee Concessions",
                        $"Fee concessions are {concessionRatio:F1}% of total income, which is above the 20% recommended threshold.",
                        FeeConcessionsValue, totalIncome, year);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in RunBudgetHealthChecks: {ex.Message}");
            }
        }

        private void ClearCurrentYearAlerts(SqlConnection con, int year)
        {
            try
            {
                string query = @"UPDATE BudgetAlerts SET IsActive = 0 
                               WHERE YEAR(CreatedDate) = @Year";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Year", year);
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in ClearCurrentYearAlerts: {ex.Message}");
            }
        }

        private void CreateBudgetAlert(SqlConnection con, string category, string message, decimal exceededBy, decimal budgetAmount, int year)
        {
            try
            {
                string insertQuery = @"INSERT INTO BudgetAlerts (Category, AlertMessage, ExceededBy, BudgetAmount, CreatedDate, IsActive) 
                                     VALUES (@Category, @AlertMessage, @ExceededBy, @BudgetAmount, GETDATE(), 1)";

                using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Category", category);
                    cmd.Parameters.AddWithValue("@AlertMessage", message);
                    cmd.Parameters.AddWithValue("@ExceededBy", exceededBy);
                    cmd.Parameters.AddWithValue("@BudgetAmount", budgetAmount);
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in CreateBudgetAlert: {ex.Message}");
            }
        }

        private void SetNegativeValueStyling()
        {
            SetNegativeStyle(LblNetIncome);
            SetNegativeStyle(LblRemainBudget);
            SetNegativeStyle(LblTotalProfit);
            SetNegativeStyle(LblRemainBudgetCalc);
            SetNegativeStyle(LblSavings);
        }

        private void SetNegativeStyle(Label label)
        {
            try
            {
                if (label.Text.StartsWith("₹-") || label.Text.StartsWith("-₹"))
                {
                    label.CssClass = label.CssClass.Replace("positive-value", "") + " negative-value";
                }
                else
                {
                    label.CssClass = label.CssClass.Replace("negative-value", "") + " positive-value";
                }
            }
            catch
            {
                // Ignore conversion errors
            }
        }

        private void UpdateFinancialHealthSummary(decimal totalBudget, decimal totalExpenses, decimal totalSalaries, decimal totalIncome, decimal remainBudget, decimal netIncome)
        {
            try
            {
                // Calculate financial health
                string healthStatus = "Excellent";
                string healthClass = "financial-health-excellent";

                if (totalBudget == 0)
                {
                    healthStatus = "No Budget";
                    healthClass = "financial-health-poor";
                }
                else if (netIncome < 0)
                {
                    healthStatus = "Critical";
                    healthClass = "financial-health-poor";
                }
                else
                {
                    decimal utilizationRate = totalBudget > 0 ? (totalExpenses + totalSalaries) / totalBudget * 100 : 0;

                    if (utilizationRate > 90)
                    {
                        healthStatus = "Poor";
                        healthClass = "financial-health-poor";
                    }
                    else if (utilizationRate > 75)
                    {
                        healthStatus = "Fair";
                        healthClass = "financial-health-fair";
                    }
                    else if (utilizationRate > 60)
                    {
                        healthStatus = "Good";
                        healthClass = "financial-health-good";
                    }
                }

                LblFinancialHealth.Text = healthStatus;
                LblFinancialHealth.CssClass = $"health-value {healthClass}";

                // Update savings (remaining budget)
                LblSavings.Text = FormatCurrency(remainBudget);
                SetNegativeStyle(LblSavings);

                // Monthly average (using current income as monthly average for now)
                LblMonthlyAverage.Text = FormatCurrency(totalIncome);

                // Active budgets count
                LblActiveBudgets.Text = CountActiveBudgets().ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating financial health: {ex.Message}");
            }
        }

        private int CountActiveBudgets()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT COUNT(*) FROM Budget 
                                   WHERE IsActive = 1 
                                   AND Year = @Year";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        int selectedYear = Convert.ToInt32(DdlYear.SelectedValue);
                        cmd.Parameters.AddWithValue("@Year", selectedYear);
                        return Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error counting active budgets: {ex.Message}");
                return 0;
            }
        }

        private string FormatCurrency(decimal amount)
        {
            return $"₹{amount:N2}";
        }

        private void ShowAlert(string message, string type)
        {
            // You can implement a toast notification system here
            System.Diagnostics.Debug.WriteLine($"{type.ToUpper()}: {message}");
        }

        // Formatting method for repeater
        public string FormatAlertDate(object date)
        {
            if (date == DBNull.Value || date == null)
                return "N/A";

            DateTime dateValue = Convert.ToDateTime(date);
            return dateValue.ToString("MMM dd, yyyy hh:mm tt");
        }

        // Method to get alert CSS class based on type
        public string GetAlertCssClass(object alertType)
        {
            if (alertType == null || alertType == DBNull.Value)
                return "alert-advisory";

            string alertTypeString = alertType.ToString().ToLower();

            if (alertTypeString == "critical")
                return "alert-critical";
            else if (alertTypeString == "warning")
                return "alert-warning";
            else
                return "alert-advisory";
        }

        // Public methods for JavaScript to access values
        public string GetTotalIncomeValue()
        {
            return TotalIncomeValue.ToString(CultureInfo.InvariantCulture);
        }

        public string GetTotalExpensesValue()
        {
            return TotalExpensesValue.ToString(CultureInfo.InvariantCulture);
        }

        public string GetTotalBudgetValue()
        {
            return TotalBudgetValue.ToString(CultureInfo.InvariantCulture);
        }

        public string GetTotalSalariesValue()
        {
            return TotalSalariesValue.ToString(CultureInfo.InvariantCulture);
        }

        public string GetNetIncomeValue()
        {
            return NetIncomeValue.ToString(CultureInfo.InvariantCulture);
        }

        public string GetRemainBudgetValue()
        {
            return RemainBudgetValue.ToString(CultureInfo.InvariantCulture);
        }

        public string GetTotalProfitValue()
        {
            return TotalProfitValue.ToString(CultureInfo.InvariantCulture);
        }

        public string GetFeeConcessionsValue()
        {
            return FeeConcessionsValue.ToString(CultureInfo.InvariantCulture);
        }

        // Fee Concessions Display Methods
        private void LoadFeeConcessions()
        {
            try
            {
                int selectedYear = Convert.ToInt32(DdlYear.SelectedValue);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Get the actual data for display
                    string query = @"SELECT 
                                    fc.ConcessionId,
                                    s.FirstName + ' ' + s.LastName AS StudentName,
                                    'Fee ID: ' + CAST(fc.FeeId AS VARCHAR) AS FeeType,
                                    CASE 
                                        WHEN fc.DiscountPercent IS NOT NULL THEN CAST(fc.DiscountPercent AS VARCHAR) + '%'
                                        WHEN fc.DiscountAmount IS NOT NULL THEN '₹' + CAST(fc.DiscountAmount AS VARCHAR)
                                        ELSE 'N/A'
                                    END AS DiscountDisplay,
                                    fc.Reason,
                                    fc.ValidFrom,
                                    fc.ValidTo,
                                    fc.CreatedDate
                                FROM FeeConcessions fc
                                INNER JOIN Students s ON fc.StudentId = s.StudentId
                                WHERE YEAR(fc.CreatedDate) = @Year AND fc.IsActive = 1
                                ORDER BY fc.CreatedDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Year", selectedYear);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        System.Diagnostics.Debug.WriteLine($"Query returned {dt.Rows.Count} rows for display");

                        if (dt.Rows.Count > 0)
                        {
                            GvFeeConcessions.DataSource = dt;
                            GvFeeConcessions.DataBind();
                            GvFeeConcessions.Visible = true;
                            LblNoConcessions.Visible = false;

                            // Debug: Print each row
                            foreach (DataRow row in dt.Rows)
                            {
                                System.Diagnostics.Debug.WriteLine($"Display concession: Student={row["StudentName"]}, Fee={row["FeeType"]}, Discount={row["DiscountDisplay"]}");
                            }
                        }
                        else
                        {
                            GvFeeConcessions.Visible = false;
                            LblNoConcessions.Visible = true;
                            LblNoConcessions.Text = $"No fee concessions found for year {selectedYear}";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading fee concessions: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
                GvFeeConcessions.Visible = false;
                LblNoConcessions.Visible = true;
                LblNoConcessions.Text = $"Error loading fee concessions: {ex.Message}";
            }
        }
    }
}