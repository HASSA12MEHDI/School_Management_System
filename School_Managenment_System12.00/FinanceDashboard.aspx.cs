using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Services;
using System.Web.Services;
using System.Collections.Generic;
using System.Web.Script.Serialization;

namespace SchoolFinancialManagementSystem
{
    public partial class FinanceDashboard : System.Web.UI.Page
    {
        // Connection string property with better error handling
        private string ConnectionString
        {
            get
            {
                try
                {
                    return System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
                }
                catch (Exception ex)
                {
                    // Log the error
                    System.Diagnostics.Trace.WriteLine("Error retrieving connection string: " + ex.Message);
                    throw new Exception("Database connection configuration error. Please contact system administrator.");
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    // Check if we can connect to the database
                    TestDatabaseConnection();

                    // Load all dashboard data
                    LoadDashboardData();
                    LoadRecentTransactions();
                    LoadBudgetAlerts();
                    LoadExpenseCategories();
                    LoadIncomeCategories();
                    LoadMonthlyComparison();
                    LoadYearlyOverview();
                }
                catch (Exception ex)
                {
                    // Log the error
                    System.Diagnostics.Trace.WriteLine("Error loading dashboard data: " + ex.Message);
                    // Show user-friendly error message
                    ShowErrorMessage("An error occurred while loading the dashboard: " + ex.Message);
                }
            }
        }

        private void TestDatabaseConnection()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();
                    // Simple test query
                    using (SqlCommand cmd = new SqlCommand("SELECT 1", conn))
                    {
                        cmd.ExecuteScalar();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Cannot connect to the database: " + ex.Message);
            }
        }

        private void LoadDashboardData()
        {
            try
            {
                // Load Total Income - Modified to include fee payments only
                decimal totalIncome = GetTotalIncome();
                lblTotalIncome.Text = totalIncome.ToString("C");

                // Load Total Expenses
                decimal totalExpenses = GetTotalExpenses();
                lblTotalExpenses.Text = totalExpenses.ToString("C");

                // Load Budget Utilization
                GetBudgetUtilization();

                // Load Active Alerts
                GetActiveAlerts();

                // Calculate trends
                CalculateTrends();
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading dashboard data: " + ex.Message);
            }
        }

        private decimal GetTotalIncome()
        {
            decimal totalIncome = 0;

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();

                // Get income from Income table
                using (SqlCommand cmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(Amount), 0) FROM Income 
                      WHERE MONTH(IncomeDate) = MONTH(GETDATE()) 
                      AND YEAR(IncomeDate) = YEAR(GETDATE())", conn))
                {
                    totalIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                }

                // Get income from FeePayments
                using (SqlCommand cmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(AmountPaid), 0) FROM FeePayments
                      WHERE MONTH(PaymentDate) = MONTH(GETDATE()) 
                      AND YEAR(PaymentDate) = YEAR(GETDATE())", conn))
                {
                    totalIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                }
            }

            return totalIncome;
        }

        private decimal GetTotalExpenses()
        {
            decimal totalExpenses = 0;

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();

                using (SqlCommand cmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(Amount), 0) FROM Expenses 
                      WHERE MONTH(ExpenseDate) = MONTH(GETDATE()) 
                      AND YEAR(ExpenseDate) = YEAR(GETDATE())", conn))
                {
                    totalExpenses = Convert.ToDecimal(cmd.ExecuteScalar());
                }
            }

            return totalExpenses;
        }

        private void GetBudgetUtilization()
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();

                using (SqlCommand cmd = new SqlCommand(
                    @"SELECT 
                        ISNULL(SUM(b.BudgetAmount), 0) as TotalBudget,
                        ISNULL(SUM(e.TotalSpent), 0) as TotalSpent
                    FROM Budget b
                    LEFT JOIN (
                        SELECT 
                            Category,
                            ISNULL(SUM(Amount), 0) as TotalSpent
                        FROM Expenses
                        WHERE MONTH(ExpenseDate) = MONTH(GETDATE())
                        AND YEAR(ExpenseDate) = YEAR(GETDATE())
                        GROUP BY Category
                    ) e ON b.Category = e.Category
                    WHERE b.Month = MONTH(GETDATE()) 
                    AND b.Year = YEAR(GETDATE()) 
                    AND b.IsActive = 1", conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            decimal totalBudget = Convert.ToDecimal(reader["TotalBudget"]);
                            decimal totalSpent = Convert.ToDecimal(reader["TotalSpent"]);

                            if (totalBudget > 0)
                            {
                                decimal utilization = (totalSpent / totalBudget) * 100;
                                lblBudgetUtilization.Text = utilization.ToString("F1") + "%";

                                if (utilization > 90)
                                    lblBudgetStatus.Text = "Critical";
                                else if (utilization > 75)
                                    lblBudgetStatus.Text = "Warning";
                                else
                                    lblBudgetStatus.Text = "On track";
                            }
                            else
                            {
                                lblBudgetUtilization.Text = "0%";
                                lblBudgetStatus.Text = "No budget set";
                            }
                        }
                    }
                }
            }
        }

        private void GetActiveAlerts()
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();

                using (SqlCommand cmd = new SqlCommand(
                    @"SELECT COUNT(*) FROM BudgetAlerts 
                      WHERE IsActive = 1 
                      AND CreatedDate >= DATEADD(day, -30, GETDATE())", conn))
                {
                    int alertCount = Convert.ToInt32(cmd.ExecuteScalar());
                    lblActiveAlerts.Text = alertCount.ToString();

                    if (alertCount > 5)
                        lblAlertsStatus.Text = "Critical alerts";
                    else if (alertCount > 0)
                        lblAlertsStatus.Text = "Needs attention";
                    else
                        lblAlertsStatus.Text = "No critical alerts";
                }
            }
        }

        private void CalculateTrends()
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();

                // Get current month income
                decimal currentMonthIncome = 0;
                using (SqlCommand cmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(Amount), 0) FROM Income 
                      WHERE MONTH(IncomeDate) = MONTH(GETDATE()) 
                      AND YEAR(IncomeDate) = YEAR(GETDATE())", conn))
                {
                    currentMonthIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                }

                // Add fee payments to current month income
                using (SqlCommand cmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(AmountPaid), 0) FROM FeePayments
                      WHERE MONTH(PaymentDate) = MONTH(GETDATE()) 
                      AND YEAR(PaymentDate) = YEAR(GETDATE())", conn))
                {
                    currentMonthIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                }

                // Get last month income
                decimal lastMonthIncome = 0;
                using (SqlCommand cmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(Amount), 0) FROM Income 
                      WHERE MONTH(IncomeDate) = MONTH(DATEADD(month, -1, GETDATE())) 
                      AND YEAR(IncomeDate) = YEAR(DATEADD(month, -1, GETDATE()))", conn))
                {
                    lastMonthIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                }

                // Add fee payments to last month income
                using (SqlCommand cmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(AmountPaid), 0) FROM FeePayments
                      WHERE MONTH(PaymentDate) = MONTH(DATEADD(month, -1, GETDATE())) 
                      AND YEAR(PaymentDate) = YEAR(DATEADD(month, -1, GETDATE()))", conn))
                {
                    lastMonthIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                }

                // Get current month expenses
                decimal currentMonthExpenses = 0;
                using (SqlCommand cmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(Amount), 0) FROM Expenses 
                      WHERE MONTH(ExpenseDate) = MONTH(GETDATE()) 
                      AND YEAR(ExpenseDate) = YEAR(GETDATE())", conn))
                {
                    currentMonthExpenses = Convert.ToDecimal(cmd.ExecuteScalar());
                }

                // Get last month expenses
                decimal lastMonthExpenses = 0;
                using (SqlCommand cmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(Amount), 0) FROM Expenses 
                      WHERE MONTH(ExpenseDate) = MONTH(DATEADD(month, -1, GETDATE())) 
                      AND YEAR(ExpenseDate) = YEAR(DATEADD(month, -1, GETDATE()))", conn))
                {
                    lastMonthExpenses = Convert.ToDecimal(cmd.ExecuteScalar());
                }

                // Calculate income trend
                decimal incomeTrend = 0;
                if (lastMonthIncome > 0)
                    incomeTrend = ((currentMonthIncome - lastMonthIncome) / lastMonthIncome) * 100;

                // Calculate expense trend
                decimal expenseTrend = 0;
                if (lastMonthExpenses > 0)
                    expenseTrend = ((currentMonthExpenses - lastMonthExpenses) / lastMonthExpenses) * 100;

                lblIncomeTrend.Text = string.Format("{0}{1:F1}% from last month",
                    incomeTrend > 0 ? "+" : "", incomeTrend);
                lblIncomeTrend.CssClass = incomeTrend >= 0 ? "trend-up" : "trend-down";

                lblExpenseTrend.Text = string.Format("{0}{1:F1}% from last month",
                    expenseTrend > 0 ? "+" : "", expenseTrend);
                lblExpenseTrend.CssClass = expenseTrend <= 0 ? "trend-up" : "trend-down";
            }
        }

        private void LoadRecentTransactions()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT TOP 10 
                            'Income' as Type,
                            IncomeDate as Date,
                            Description,
                            Category,
                            Amount
                        FROM Income
                        UNION ALL
                        SELECT 
                            'Expense' as Type,
                            ExpenseDate as Date,
                            Description,
                            Category,
                            Amount
                        FROM Expenses
                        UNION ALL
                        SELECT 
                            'Fee Payment' as Type,
                            PaymentDate as Date,
                            'Fee Payment - ' + ISNULL(s.FirstName, '') + ' ' + ISNULL(s.LastName, '') as Description,
                            'Fees',
                            AmountPaid as Amount
                        FROM FeePayments fp
                        LEFT JOIN Students s ON fp.StudentId = s.StudentId
                        ORDER BY Date DESC", conn))
                    {
                        DataTable dt = new DataTable();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(dt);

                        gvRecentTransactions.DataSource = dt;
                        gvRecentTransactions.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading recent transactions: " + ex.Message);
            }
        }

        private void LoadBudgetAlerts()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT TOP 5 
                            Category,
                            BudgetAmount,
                            (SELECT ISNULL(SUM(Amount), 0) 
                             FROM Expenses e 
                             WHERE e.Category = ba.Category 
                             AND MONTH(e.ExpenseDate) = MONTH(GETDATE())
                             AND YEAR(e.ExpenseDate) = YEAR(GETDATE())) as ActualAmount,
                            AlertType as Status
                        FROM BudgetAlerts ba
                        WHERE IsActive = 1
                        ORDER BY CreatedDate DESC", conn))
                    {
                        DataTable dt = new DataTable();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(dt);

                        gvBudgetAlerts.DataSource = dt;
                        gvBudgetAlerts.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading budget alerts: " + ex.Message);
            }
        }

        private void LoadExpenseCategories()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT 
                            Category,
                            SUM(Amount) as TotalAmount
                        FROM Expenses
                        WHERE MONTH(ExpenseDate) = MONTH(GETDATE())
                        AND YEAR(ExpenseDate) = YEAR(GETDATE())
                        GROUP BY Category
                        ORDER BY TotalAmount DESC", conn))
                    {
                        DataTable dt = new DataTable();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(dt);

                        // Convert to JSON for chart
                        var categories = new List<string>();
                        var amounts = new List<decimal>();

                        foreach (DataRow row in dt.Rows)
                        {
                            categories.Add(row["Category"].ToString());
                            amounts.Add(Convert.ToDecimal(row["TotalAmount"]));
                        }

                        // Store in hidden fields for JavaScript access
                        hfExpenseCategories.Value = new JavaScriptSerializer().Serialize(categories);
                        hfExpenseAmounts.Value = new JavaScriptSerializer().Serialize(amounts);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading expense categories: " + ex.Message);
            }
        }

        private void LoadIncomeCategories()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();

                    // Get income from Income table
                    DataTable incomeDt = new DataTable();
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT 
                            Category,
                            SUM(Amount) as TotalAmount
                        FROM Income
                        WHERE MONTH(IncomeDate) = MONTH(GETDATE())
                        AND YEAR(IncomeDate) = YEAR(GETDATE())
                        GROUP BY Category
                        ORDER BY TotalAmount DESC", conn))
                    {
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(incomeDt);
                    }

                    // Get fee payments
                    decimal feePaymentsTotal = 0;
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT ISNULL(SUM(AmountPaid), 0) FROM FeePayments
                          WHERE MONTH(PaymentDate) = MONTH(GETDATE()) 
                          AND YEAR(PaymentDate) = YEAR(GETDATE())", conn))
                    {
                        feePaymentsTotal = Convert.ToDecimal(cmd.ExecuteScalar());
                    }

                    // Convert to JSON for chart
                    var categories = new List<string>();
                    var amounts = new List<decimal>();

                    foreach (DataRow row in incomeDt.Rows)
                    {
                        categories.Add(row["Category"].ToString());
                        amounts.Add(Convert.ToDecimal(row["TotalAmount"]));
                    }

                    // Add fee payments if there are any
                    if (feePaymentsTotal > 0)
                    {
                        categories.Add("Fees");
                        amounts.Add(feePaymentsTotal);
                    }

                    // Store in hidden fields for JavaScript access
                    hfIncomeCategories.Value = new JavaScriptSerializer().Serialize(categories);
                    hfIncomeAmounts.Value = new JavaScriptSerializer().Serialize(amounts);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading income categories: " + ex.Message);
            }
        }

        private void LoadMonthlyComparison()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();

                    // Initialize arrays for all months
                    string[] months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
                    decimal[] incomeData = new decimal[12];
                    decimal[] expenseData = new decimal[12];

                    // Get income data for each month
                    for (int i = 1; i <= 12; i++)
                    {
                        // Get income from Income table
                        using (SqlCommand cmd = new SqlCommand(
                            @"SELECT ISNULL(SUM(Amount), 0) FROM Income 
                              WHERE MONTH(IncomeDate) = @Month 
                              AND YEAR(IncomeDate) = YEAR(GETDATE())", conn))
                        {
                            cmd.Parameters.AddWithValue("@Month", i);
                            incomeData[i - 1] += Convert.ToDecimal(cmd.ExecuteScalar());
                        }

                        // Get fee payments
                        using (SqlCommand cmd = new SqlCommand(
                            @"SELECT ISNULL(SUM(AmountPaid), 0) FROM FeePayments
                              WHERE MONTH(PaymentDate) = @Month 
                              AND YEAR(PaymentDate) = YEAR(GETDATE())", conn))
                        {
                            cmd.Parameters.AddWithValue("@Month", i);
                            incomeData[i - 1] += Convert.ToDecimal(cmd.ExecuteScalar());
                        }

                        // Get expenses
                        using (SqlCommand cmd = new SqlCommand(
                            @"SELECT ISNULL(SUM(Amount), 0) FROM Expenses 
                              WHERE MONTH(ExpenseDate) = @Month 
                              AND YEAR(ExpenseDate) = YEAR(GETDATE())", conn))
                        {
                            cmd.Parameters.AddWithValue("@Month", i);
                            expenseData[i - 1] = Convert.ToDecimal(cmd.ExecuteScalar());
                        }
                    }

                    // Store in hidden fields for JavaScript access
                    hfMonthlyLabels.Value = new JavaScriptSerializer().Serialize(months);
                    hfMonthlyIncome.Value = new JavaScriptSerializer().Serialize(incomeData);
                    hfMonthlyExpense.Value = new JavaScriptSerializer().Serialize(expenseData);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading monthly comparison: " + ex.Message);
            }
        }

        private void LoadYearlyOverview()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();

                    // Get the last 5 years
                    int currentYear = DateTime.Now.Year;
                    var years = new List<string>();
                    var incomeData = new List<decimal>();
                    var expenseData = new List<decimal>();

                    for (int i = 4; i >= 0; i--)
                    {
                        int year = currentYear - i;
                        years.Add(year.ToString());

                        decimal yearIncome = 0;
                        decimal yearExpense = 0;

                        // Get income for the year
                        using (SqlCommand cmd = new SqlCommand(
                            @"SELECT ISNULL(SUM(Amount), 0) FROM Income 
                              WHERE YEAR(IncomeDate) = @Year", conn))
                        {
                            cmd.Parameters.AddWithValue("@Year", year);
                            yearIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                        }

                        // Get fee payments for the year
                        using (SqlCommand cmd = new SqlCommand(
                            @"SELECT ISNULL(SUM(AmountPaid), 0) FROM FeePayments
                              WHERE YEAR(PaymentDate) = @Year", conn))
                        {
                            cmd.Parameters.AddWithValue("@Year", year);
                            yearIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                        }

                        // Get expenses for the year
                        using (SqlCommand cmd = new SqlCommand(
                            @"SELECT ISNULL(SUM(Amount), 0) FROM Expenses 
                              WHERE YEAR(ExpenseDate) = @Year", conn))
                        {
                            cmd.Parameters.AddWithValue("@Year", year);
                            yearExpense = Convert.ToDecimal(cmd.ExecuteScalar());
                        }

                        incomeData.Add(yearIncome);
                        expenseData.Add(yearExpense);
                    }

                    // Store in hidden fields for JavaScript access
                    hfYearlyLabels.Value = new JavaScriptSerializer().Serialize(years);
                    hfYearlyIncome.Value = new JavaScriptSerializer().Serialize(incomeData);
                    hfYearlyExpense.Value = new JavaScriptSerializer().Serialize(expenseData);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading yearly overview: " + ex.Message);
            }
        }

        // This method was missing, causing the first error
        public string GetAlertStatusClass(string status)
        {
            switch (status.ToLower())
            {
                case "exceeded":
                    return "status-danger";
                case "warning":
                    return "status-warning";
                default:
                    return "status-income";
            }
        }

        protected void btnAddIncome_Click(object sender, EventArgs e)
        {
            Response.Redirect("IncomeManagement.aspx");
        }

        protected void btnAddExpense_Click(object sender, EventArgs e)
        {
            Response.Redirect("Expenses.aspx");
        }

        protected void btnCreateBudget_Click(object sender, EventArgs e)
        {
            Response.Redirect("BudgetForm.aspx");
        }

        protected void btnViewReports_Click(object sender, EventArgs e)
        {
            Response.Redirect("BudgetReports.aspx");
        }

        protected void btnViewAllTransactions_Click(object sender, EventArgs e)
        {
            Response.Redirect("View_AllTransaction.aspx");
        }

        protected void btnViewAllAlerts_Click(object sender, EventArgs e)
        {
            Response.Redirect("BudgetAlerts.aspx");
        }

        protected void ddlChartPeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                // Get the selected period
                int period = Convert.ToInt32(ddlChartPeriod.SelectedValue);

                // Refresh chart data based on selected period
                LoadMonthlyComparisonWithPeriod(period);
                LoadYearlyOverviewWithPeriod(period);

                // Force a postback to update the charts
                ScriptManager.RegisterStartupScript(this, GetType(), "UpdateCharts", "updateCharts();", true);
            }
            catch (Exception ex)
            {
                // Log the error
                System.Diagnostics.Trace.WriteLine("Error in ddlChartPeriod_SelectedIndexChanged: " + ex.Message);
                ShowErrorMessage("An error occurred while updating the chart data: " + ex.Message);
            }
        }

        protected void ddlExpensePeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                // Get the selected period
                int period = Convert.ToInt32(ddlExpensePeriod.SelectedValue);

                // Refresh expense distribution chart based on selected period
                LoadExpenseCategoriesWithPeriod(period);

                // Force a postback to update the charts
                ScriptManager.RegisterStartupScript(this, GetType(), "UpdateExpenseChart", "updateExpenseChart();", true);
            }
            catch (Exception ex)
            {
                // Log the error
                System.Diagnostics.Trace.WriteLine("Error in ddlExpensePeriod_SelectedIndexChanged: " + ex.Message);
                ShowErrorMessage("An error occurred while updating the expense distribution: " + ex.Message);
            }
        }

        protected void ddlIncomePeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                // Get the selected period
                int period = Convert.ToInt32(ddlIncomePeriod.SelectedValue);

                // Refresh income sources chart based on selected period
                LoadIncomeCategoriesWithPeriod(period);

                // Force a postback to update the charts
                ScriptManager.RegisterStartupScript(this, GetType(), "UpdateIncomeChart", "updateIncomeChart();", true);
            }
            catch (Exception ex)
            {
                // Log the error
                System.Diagnostics.Trace.WriteLine("Error in ddlIncomePeriod_SelectedIndexChanged: " + ex.Message);
                ShowErrorMessage("An error occurred while updating the income sources: " + ex.Message);
            }
        }

        protected void ddlYearlyPeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                // Get the selected period
                int period = Convert.ToInt32(ddlYearlyPeriod.SelectedValue);

                // Refresh yearly overview chart based on selected period
                LoadYearlyOverviewWithPeriod(period);

                // Force a postback to update the charts
                ScriptManager.RegisterStartupScript(this, GetType(), "UpdateYearlyChart", "updateYearlyChart();", true);
            }
            catch (Exception ex)
            {
                // Log the error
                System.Diagnostics.Trace.WriteLine("Error in ddlYearlyPeriod_SelectedIndexChanged: " + ex.Message);
                ShowErrorMessage("An error occurred while updating the yearly overview: " + ex.Message);
            }
        }

        private void LoadMonthlyComparisonWithPeriod(int months)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();

                    // Initialize arrays for the specified number of months
                    var monthLabels = new List<string>();
                    var incomeData = new List<decimal>();
                    var expenseData = new List<decimal>();

                    // Get data for each month
                    for (int i = months - 1; i >= 0; i--)
                    {
                        DateTime monthDate = DateTime.Now.AddMonths(-i);
                        int month = monthDate.Month;
                        int year = monthDate.Year;

                        monthLabels.Add(monthDate.ToString("MMM"));

                        decimal monthIncome = 0;
                        decimal monthExpense = 0;

                        // Get income from Income table
                        using (SqlCommand cmd = new SqlCommand(
                            @"SELECT ISNULL(SUM(Amount), 0) FROM Income 
                              WHERE MONTH(IncomeDate) = @Month 
                              AND YEAR(IncomeDate) = @Year", conn))
                        {
                            cmd.Parameters.AddWithValue("@Month", month);
                            cmd.Parameters.AddWithValue("@Year", year);
                            monthIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                        }

                        // Get fee payments
                        using (SqlCommand cmd = new SqlCommand(
                            @"SELECT ISNULL(SUM(AmountPaid), 0) FROM FeePayments
                              WHERE MONTH(PaymentDate) = @Month 
                              AND YEAR(PaymentDate) = @Year", conn))
                        {
                            cmd.Parameters.AddWithValue("@Month", month);
                            cmd.Parameters.AddWithValue("@Year", year);
                            monthIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                        }

                        // Get expenses
                        using (SqlCommand cmd = new SqlCommand(
                            @"SELECT ISNULL(SUM(Amount), 0) FROM Expenses 
                              WHERE MONTH(ExpenseDate) = @Month 
                              AND YEAR(ExpenseDate) = @Year", conn))
                        {
                            cmd.Parameters.AddWithValue("@Month", month);
                            cmd.Parameters.AddWithValue("@Year", year);
                            monthExpense = Convert.ToDecimal(cmd.ExecuteScalar());
                        }

                        incomeData.Add(monthIncome);
                        expenseData.Add(monthExpense);
                    }

                    // Store in hidden fields for JavaScript access
                    hfMonthlyLabels.Value = new JavaScriptSerializer().Serialize(monthLabels);
                    hfMonthlyIncome.Value = new JavaScriptSerializer().Serialize(incomeData);
                    hfMonthlyExpense.Value = new JavaScriptSerializer().Serialize(expenseData);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading monthly comparison with period: " + ex.Message);
            }
        }

        private void LoadExpenseCategoriesWithPeriod(int periodType)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();

                    DateTime startDate;
                    DateTime endDate = DateTime.Now;

                    // Set the date range based on the period type
                    switch (periodType)
                    {
                        case 1: // Current Month
                            startDate = new DateTime(endDate.Year, endDate.Month, 1);
                            break;
                        case 2: // Last Month
                            endDate = new DateTime(endDate.Year, endDate.Month, 1).AddDays(-1);
                            startDate = new DateTime(endDate.Year, endDate.Month, 1);
                            break;
                        case 3: // This Quarter
                            int quarter = (endDate.Month - 1) / 3 + 1;
                            startDate = new DateTime(endDate.Year, (quarter - 1) * 3 + 1, 1);
                            break;
                        default:
                            startDate = new DateTime(endDate.Year, endDate.Month, 1);
                            break;
                    }

                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT 
                            Category,
                            SUM(Amount) as TotalAmount
                        FROM Expenses
                        WHERE ExpenseDate BETWEEN @StartDate AND @EndDate
                        GROUP BY Category
                        ORDER BY TotalAmount DESC", conn))
                    {
                        cmd.Parameters.AddWithValue("@StartDate", startDate);
                        cmd.Parameters.AddWithValue("@EndDate", endDate);

                        DataTable dt = new DataTable();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(dt);

                        // Convert to JSON for chart
                        var categories = new List<string>();
                        var amounts = new List<decimal>();

                        foreach (DataRow row in dt.Rows)
                        {
                            categories.Add(row["Category"].ToString());
                            amounts.Add(Convert.ToDecimal(row["TotalAmount"]));
                        }

                        // Store in hidden fields for JavaScript access
                        hfExpenseCategories.Value = new JavaScriptSerializer().Serialize(categories);
                        hfExpenseAmounts.Value = new JavaScriptSerializer().Serialize(amounts);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading expense categories with period: " + ex.Message);
            }
        }

        private void LoadIncomeCategoriesWithPeriod(int periodType)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();

                    DateTime startDate;
                    DateTime endDate = DateTime.Now;

                    // Set the date range based on the period type
                    switch (periodType)
                    {
                        case 1: // Current Month
                            startDate = new DateTime(endDate.Year, endDate.Month, 1);
                            break;
                        case 2: // Last Month
                            endDate = new DateTime(endDate.Year, endDate.Month, 1).AddDays(-1);
                            startDate = new DateTime(endDate.Year, endDate.Month, 1);
                            break;
                        case 3: // This Quarter
                            int quarter = (endDate.Month - 1) / 3 + 1;
                            startDate = new DateTime(endDate.Year, (quarter - 1) * 3 + 1, 1);
                            break;
                        default:
                            startDate = new DateTime(endDate.Year, endDate.Month, 1);
                            break;
                    }

                    // Get income from Income table
                    DataTable incomeDt = new DataTable();
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT 
                            Category,
                            SUM(Amount) as TotalAmount
                        FROM Income
                        WHERE IncomeDate BETWEEN @StartDate AND @EndDate
                        GROUP BY Category
                        ORDER BY TotalAmount DESC", conn))
                    {
                        cmd.Parameters.AddWithValue("@StartDate", startDate);
                        cmd.Parameters.AddWithValue("@EndDate", endDate);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(incomeDt);
                    }

                    // Get fee payments
                    decimal feePaymentsTotal = 0;
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT ISNULL(SUM(AmountPaid), 0) FROM FeePayments
                          WHERE PaymentDate BETWEEN @StartDate AND @EndDate", conn))
                    {
                        cmd.Parameters.AddWithValue("@StartDate", startDate);
                        cmd.Parameters.AddWithValue("@EndDate", endDate);
                        feePaymentsTotal = Convert.ToDecimal(cmd.ExecuteScalar());
                    }

                    // Convert to JSON for chart
                    var categories = new List<string>();
                    var amounts = new List<decimal>();

                    foreach (DataRow row in incomeDt.Rows)
                    {
                        categories.Add(row["Category"].ToString());
                        amounts.Add(Convert.ToDecimal(row["TotalAmount"]));
                    }

                    // Add fee payments if there are any
                    if (feePaymentsTotal > 0)
                    {
                        categories.Add("Fees");
                        amounts.Add(feePaymentsTotal);
                    }

                    // Store in hidden fields for JavaScript access
                    hfIncomeCategories.Value = new JavaScriptSerializer().Serialize(categories);
                    hfIncomeAmounts.Value = new JavaScriptSerializer().Serialize(amounts);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading income categories with period: " + ex.Message);
            }
        }

        private void LoadYearlyOverviewWithPeriod(int years)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();

                    // Get the specified number of years
                    int currentYear = DateTime.Now.Year;
                    var yearLabels = new List<string>();
                    var incomeData = new List<decimal>();
                    var expenseData = new List<decimal>();

                    for (int i = years - 1; i >= 0; i--)
                    {
                        int year = currentYear - i;
                        yearLabels.Add(year.ToString());

                        decimal yearIncome = 0;
                        decimal yearExpense = 0;

                        // Get income for the year
                        using (SqlCommand cmd = new SqlCommand(
                            @"SELECT ISNULL(SUM(Amount), 0) FROM Income 
                              WHERE YEAR(IncomeDate) = @Year", conn))
                        {
                            cmd.Parameters.AddWithValue("@Year", year);
                            yearIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                        }

                        // Get fee payments for the year
                        using (SqlCommand cmd = new SqlCommand(
                            @"SELECT ISNULL(SUM(AmountPaid), 0) FROM FeePayments
                              WHERE YEAR(PaymentDate) = @Year", conn))
                        {
                            cmd.Parameters.AddWithValue("@Year", year);
                            yearIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                        }

                        // Get expenses for the year
                        using (SqlCommand cmd = new SqlCommand(
                            @"SELECT ISNULL(SUM(Amount), 0) FROM Expenses 
                              WHERE YEAR(ExpenseDate) = @Year", conn))
                        {
                            cmd.Parameters.AddWithValue("@Year", year);
                            yearExpense = Convert.ToDecimal(cmd.ExecuteScalar());
                        }

                        incomeData.Add(yearIncome);
                        expenseData.Add(yearExpense);
                    }

                    // Store in hidden fields for JavaScript access
                    hfYearlyLabels.Value = new JavaScriptSerializer().Serialize(yearLabels);
                    hfYearlyIncome.Value = new JavaScriptSerializer().Serialize(incomeData);
                    hfYearlyExpense.Value = new JavaScriptSerializer().Serialize(expenseData);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading yearly overview with period: " + ex.Message);
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetRealTimeData()
        {
            // This method can be called via AJAX to get real-time updates
            JavaScriptSerializer js = new JavaScriptSerializer();
            string result = "";
            string connectionString = "";

            try
            {
                connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
            }
            catch (Exception ex)
            {
                // Log the error
                System.Diagnostics.Trace.WriteLine("Error retrieving connection string in GetRealTimeData: " + ex.Message);

                var errorData = new
                {
                    Error = true,
                    Message = "Database connection configuration error. Please contact system administrator.",
                    LastUpdated = DateTime.Now.ToString("HH:mm:ss")
                };

                return js.Serialize(errorData);
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Get current month's income
                    decimal totalIncome = 0;

                    // Income from Income table
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT ISNULL(SUM(Amount), 0) FROM Income 
                          WHERE MONTH(IncomeDate) = MONTH(GETDATE()) 
                          AND YEAR(IncomeDate) = YEAR(GETDATE())", conn))
                    {
                        totalIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                    }

                    // Fee payments
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT ISNULL(SUM(AmountPaid), 0) FROM FeePayments
                          WHERE MONTH(PaymentDate) = MONTH(GETDATE()) 
                          AND YEAR(PaymentDate) = YEAR(GETDATE())", conn))
                    {
                        totalIncome += Convert.ToDecimal(cmd.ExecuteScalar());
                    }

                    // Get current month's expenses
                    decimal totalExpenses = 0;
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT ISNULL(SUM(Amount), 0) FROM Expenses 
                          WHERE MONTH(ExpenseDate) = MONTH(GETDATE()) 
                          AND YEAR(ExpenseDate) = YEAR(GETDATE())", conn))
                    {
                        totalExpenses = Convert.ToDecimal(cmd.ExecuteScalar());
                    }

                    // Get active alerts
                    int activeAlerts = 0;
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT COUNT(*) FROM BudgetAlerts 
                          WHERE IsActive = 1 
                          AND CreatedDate >= DATEADD(day, -30, GETDATE())", conn))
                    {
                        activeAlerts = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    // Calculate budget utilization
                    decimal budgetUtilization = 0;
                    using (SqlCommand budgetCmd = new SqlCommand(
                        @"SELECT 
                            ISNULL(SUM(b.BudgetAmount), 0) as TotalBudget,
                            ISNULL(SUM(e.TotalSpent), 0) as TotalSpent
                        FROM Budget b
                        LEFT JOIN (
                            SELECT 
                                Category,
                                ISNULL(SUM(Amount), 0) as TotalSpent
                            FROM Expenses
                            WHERE MONTH(ExpenseDate) = MONTH(GETDATE())
                            AND YEAR(ExpenseDate) = YEAR(GETDATE())
                            GROUP BY Category
                        ) e ON b.Category = e.Category
                        WHERE b.Month = MONTH(GETDATE()) 
                        AND b.Year = YEAR(GETDATE()) 
                        AND b.IsActive = 1", conn))
                    {
                        using (SqlDataReader budgetReader = budgetCmd.ExecuteReader())
                        {
                            if (budgetReader.Read())
                            {
                                decimal totalBudget = Convert.ToDecimal(budgetReader["TotalBudget"]);
                                decimal totalSpent = Convert.ToDecimal(budgetReader["TotalSpent"]);

                                if (totalBudget > 0)
                                    budgetUtilization = (totalSpent / totalBudget) * 100;
                            }
                        }
                    }

                    var data = new
                    {
                        TotalIncome = totalIncome,
                        TotalExpenses = totalExpenses,
                        BudgetUtilization = Math.Round(budgetUtilization, 1),
                        ActiveAlerts = activeAlerts,
                        LastUpdated = DateTime.Now.ToString("HH:mm:ss")
                    };

                    result = js.Serialize(data);
                }
            }
            catch (SqlException ex)
            {
                // Log the SQL error
                System.Diagnostics.Trace.WriteLine("SQL Error in GetRealTimeData: " + ex.Message);

                // Return error information
                var errorData = new
                {
                    Error = true,
                    Message = "Database error occurred while fetching real-time data. Please contact system administrator.",
                    LastUpdated = DateTime.Now.ToString("HH:mm:ss")
                };

                result = js.Serialize(errorData);
            }
            catch (Exception ex)
            {
                // Log the general error
                System.Diagnostics.Trace.WriteLine("Error in GetRealTimeData: " + ex.Message);

                // Return error information
                var errorData = new
                {
                    Error = true,
                    Message = "An error occurred while fetching real-time data: " + ex.Message,
                    LastUpdated = DateTime.Now.ToString("HH:mm:ss")
                };

                result = js.Serialize(errorData);
            }

            return result;
        }

        private void ShowErrorMessage(string message)
        {
            // You can implement a more sophisticated error display mechanism here
            // For now, we'll use a simple alert
            ScriptManager.RegisterStartupScript(this, GetType(), "ErrorAlert", $"alert('{message}');", true);
        }
    }
}