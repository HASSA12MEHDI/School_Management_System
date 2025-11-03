<%@ Page Title="Financial Dashboard" Language="C#" MasterPageFile="~/Site2.Master" AutoEventWireup="true" CodeBehind="FinanceDashboard.aspx.cs" Inherits="SchoolFinancialManagementSystem.FinanceDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        :root {
            --primary: #4a69bd;
            --secondary: #6c5ce7;
            --accent: #00b894;
            --danger: #d63031;
            --warning: #fdcb6e;
            --dark: #2d3436;
            --light: #dfe6e9;
            --light-gray: #f5f6fa;
            --gradient-1: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --gradient-2: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --gradient-3: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --gradient-4: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            --gradient-5: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            --gradient-6: linear-gradient(135deg, #30cfd0 0%, #330867 100%);
            --shadow-sm: 0 2px 4px rgba(0,0,0,0.1);
            --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
            --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
            --shadow-xl: 0 20px 25px rgba(0,0,0,0.1);
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--dark);
        }

        .dashboard-content {
            padding: 0;
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .welcome-banner {
            background: var(--gradient-1);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: var(--shadow-lg);
            position: relative;
            overflow: hidden;
        }

        .welcome-banner::before {
            content: "";
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 70%);
            animation: pulse 4s ease-in-out infinite;
        }

        @keyframes pulse {
            0% { transform: scale(0.8); opacity: 0.5; }
            50% { transform: scale(1.1); opacity: 0.3; }
            100% { transform: scale(0.8); opacity: 0.5; }
        }

        .welcome-banner h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }

        .welcome-banner p {
            font-size: 1.1rem;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .section-title {
            margin: 30px 0 20px 0;
            position: relative;
        }

        .section-title h2 {
            color: var(--dark);
            font-size: 1.8rem;
            font-weight: 600;
            display: inline-block;
            position: relative;
            padding-bottom: 10px;
        }

        .section-title h2::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: var(--gradient-1);
            border-radius: 3px;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: var(--shadow-md);
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: var(--gradient-1);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
        }

        .stat-card.income::before { background: var(--gradient-4); }
        .stat-card.expenses::before { background: var(--gradient-2); }
        .stat-card.budget::before { background: var(--gradient-3); }
        .stat-card.alerts::before { background: var(--gradient-5); }

        .stat-icon {
            width: 70px;
            height: 70px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            font-size: 1.8rem;
            color: white;
        }

        .stat-card.income .stat-icon { background: var(--gradient-4); }
        .stat-card.expenses .stat-icon { background: var(--gradient-2); }
        .stat-card.budget .stat-icon { background: var(--gradient-3); }
        .stat-card.alerts .stat-icon { background: var(--gradient-5); }

        .stat-info h3 {
            font-size: 0.9rem;
            color: #636e72;
            margin-bottom: 5px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        .stat-info p {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 5px;
        }

        .stat-info small {
            font-size: 0.85rem;
            display: flex;
            align-items: center;
        }

        .button-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .action-button {
            background: white;
            border-radius: 12px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            color: var(--dark);
            box-shadow: var(--shadow-md);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .action-button::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: var(--gradient-1);
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: 0;
        }

        .action-button:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
            color: white;
        }

        .action-button:hover::before {
            opacity: 1;
        }

        .action-button i {
            font-size: 2rem;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }

        .action-button span {
            font-weight: 600;
            position: relative;
            z-index: 1;
        }

        .charts-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin: 30px 0;
        }

        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: var(--shadow-md);
            transition: all 0.3s ease;
            height: 350px;
            display: flex;
            flex-direction: column;
        }

        .chart-container:hover {
            box-shadow: var(--shadow-xl);
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--light-gray);
        }

        .chart-header h3 {
            color: var(--dark);
            font-size: 1.2rem;
            font-weight: 600;
        }

        .chart-header select {
            padding: 6px 12px;
            border: 1px solid var(--light);
            border-radius: 8px;
            background: white;
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }

        .chart-header select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(74, 105, 189, 0.1);
        }

        .chart-wrapper {
            flex: 1;
            position: relative;
            width: 100%;
        }

        .tables-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin: 30px 0;
        }

        .table-container {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: var(--shadow-md);
            transition: all 0.3s ease;
        }

        .table-container:hover {
            box-shadow: var(--shadow-xl);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid var(--light-gray);
        }

        .table-header h3 {
            color: var(--dark);
            font-size: 1.3rem;
            font-weight: 600;
        }

        .btn-view-all {
            background: var(--gradient-1);
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
        }

        .btn-view-all:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            text-decoration: none;
            color: white;
        }

        .btn-view-all i {
            margin-left: 8px;
            transition: transform 0.3s ease;
        }

        .btn-view-all:hover i {
            transform: translateX(3px);
        }

        .financial-table {
            width: 100%;
            border-collapse: collapse;
        }

        .financial-table th {
            text-align: left;
            padding: 15px;
            background-color: var(--light-gray);
            color: var(--dark);
            font-weight: 600;
            border-bottom: 2px solid var(--light);
            font-size: 0.9rem;
            letter-spacing: 0.5px;
        }

        .financial-table td {
            padding: 15px;
            border-bottom: 1px solid var(--light-gray);
            font-size: 0.95rem;
        }

        .financial-table tr:hover {
            background-color: rgba(74, 105, 189, 0.05);
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }

        .status-income {
            background-color: rgba(0, 184, 148, 0.15);
            color: var(--accent);
        }

        .status-expense {
            background-color: rgba(214, 48, 49, 0.15);
            color: var(--danger);
        }

        .status-warning {
            background-color: rgba(253, 203, 110, 0.15);
            color: var(--warning);
        }

        .status-danger {
            background-color: rgba(214, 48, 49, 0.15);
            color: var(--danger);
        }

        .trend-up {
            color: var(--accent);
            display: flex;
            align-items: center;
        }

        .trend-down {
            color: var(--danger);
            display: flex;
            align-items: center;
        }

        .trend-up::before, .trend-down::before {
            content: "";
            display: inline-block;
            width: 0;
            height: 0;
            margin-right: 5px;
            border-left: 5px solid transparent;
            border-right: 5px solid transparent;
        }

        .trend-up::before {
            border-bottom: 8px solid currentColor;
        }

        .trend-down::before {
            border-top: 8px solid currentColor;
        }

        .real-time-indicator {
            display: inline-flex;
            align-items: center;
            font-size: 0.8rem;
            color: var(--accent);
            margin-left: 10px;
        }

        .real-time-indicator .pulse {
            display: inline-block;
            width: 8px;
            height: 8px;
            background-color: var(--accent);
            border-radius: 50%;
            margin-right: 5px;
            animation: pulse-dot 1.5s infinite;
        }

        @keyframes pulse-dot {
            0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(0, 184, 148, 0.7); }
            70% { transform: scale(1); box-shadow: 0 0 0 5px rgba(0, 184, 148, 0); }
            100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(0, 184, 148, 0); }
        }

        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .summary-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: var(--shadow-md);
            text-align: center;
            transition: all 0.3s ease;
        }

        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
        }

        .summary-card h4 {
            color: var(--dark);
            font-size: 1rem;
            margin-bottom: 10px;
        }

        .summary-card .value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
        }

        .update-indicator {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 10px;
            height: 10px;
            background-color: var(--accent);
            border-radius: 50%;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .update-indicator.active {
            opacity: 1;
            animation: pulse-dot 1.5s infinite;
        }

        @media (max-width: 992px) {
            .charts-section {
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            }
            .tables-section {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .chart-header,
            .table-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .financial-table {
                font-size: 0.9rem;
            }
            
            .financial-table th,
            .financial-table td {
                padding: 10px;
            }

            .welcome-banner h1 {
                font-size: 2rem;
            }

            .stats-container {
                grid-template-columns: 1fr;
            }

            .button-grid {
                grid-template-columns: 1fr;
            }
            
            .chart-container {
                height: 300px;
            }
        }

        /* Loading animation */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 10px;
        }

        ::-webkit-scrollbar-track {
            background: var(--light-gray);
        }

        ::-webkit-scrollbar-thumb {
            background: var(--gradient-1);
            border-radius: 5px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: var(--primary);
        }
    </style>

    <div class="dashboard-content">
        <!-- Welcome Banner -->
        <div class="welcome-banner">
            <h1>Financial Dashboard
                <span class="real-time-indicator">
                    <span class="pulse"></span>
                    Live
                </span>
            </h1>
            <p>Welcome to your financial management center. Here's an overview of your finances.</p>
        </div>

        <!-- Stats Cards -->
        <div class="stats-container">
            <div class="stat-card income">
                <div class="stat-icon">
                    <i class="fas fa-money-bill-wave"></i>
                </div>
                <div class="stat-info">
                    <h3>TOTAL INCOME</h3>
                    <p><asp:Label ID="lblTotalIncome" runat="server" Text="$0.00"></asp:Label></p>
                    <small><asp:Label ID="lblIncomeTrend" runat="server" Text="0% from last month" CssClass="trend-up"></asp:Label></small>
                </div>
                <div class="update-indicator" id="incomeUpdateIndicator"></div>
            </div>
            
            <div class="stat-card expenses">
                <div class="stat-icon">
                    <i class="fas fa-receipt"></i>
                </div>
                <div class="stat-info">
                    <h3>TOTAL EXPENSES</h3>
                    <p><asp:Label ID="lblTotalExpenses" runat="server" Text="$0.00"></asp:Label></p>
                    <small><asp:Label ID="lblExpenseTrend" runat="server" Text="0% from last month" CssClass="trend-up"></asp:Label></small>
                </div>
                <div class="update-indicator" id="expenseUpdateIndicator"></div>
            </div>
            
            <div class="stat-card budget">
                <div class="stat-icon">
                    <i class="fas fa-chart-pie"></i>
                </div>
                <div class="stat-info">
                    <h3>BUDGET UTILIZATION</h3>
                    <p><asp:Label ID="lblBudgetUtilization" runat="server" Text="0%"></asp:Label></p>
                    <small><asp:Label ID="lblBudgetStatus" runat="server" Text="On track"></asp:Label></small>
                </div>
                <div class="update-indicator" id="budgetUpdateIndicator"></div>
            </div>
            
            <div class="stat-card alerts">
                <div class="stat-icon">
                    <i class="fas fa-bell"></i>
                </div>
                <div class="stat-info">
                    <h3>ACTIVE ALERTS</h3>
                    <p><asp:Label ID="lblActiveAlerts" runat="server" Text="0"></asp:Label></p>
                    <small><asp:Label ID="lblAlertsStatus" runat="server" Text="No critical alerts"></asp:Label></small>
                </div>
                <div class="update-indicator" id="alertsUpdateIndicator"></div>
            </div>
        </div>

        <!-- Summary Cards -->
        <div class="summary-cards">
            <div class="summary-card">
                <h4>Current Balance</h4>
                <div class="value" id="currentBalance">$0.00</div>
            </div>
            <div class="summary-card">
                <h4>Monthly Savings</h4>
                <div class="value" id="monthlySavings">$0.00</div>
            </div>
            <div class="summary-card">
                <h4>Year-to-Date Income</h4>
                <div class="value" id="ytdIncome">$0.00</div>
            </div>
            <div class="summary-card">
                <h4>Year-to-Date Expenses</h4>
                <div class="value" id="ytdExpenses">$0.00</div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="section-title">
            <h2>Quick Actions</h2>
        </div>
        <div class="button-grid">
            <asp:LinkButton ID="btnAddIncome" runat="server" CssClass="action-button" OnClick="btnAddIncome_Click">
                <i class="fas fa-plus-circle"></i>
                <span>Add Income</span>
            </asp:LinkButton>
            
            <asp:LinkButton ID="btnAddExpense" runat="server" CssClass="action-button" OnClick="btnAddExpense_Click">
                <i class="fas fa-minus-circle"></i>
                <span>Add Expense</span>
            </asp:LinkButton>
            
            <asp:LinkButton ID="btnCreateBudget" runat="server" CssClass="action-button" OnClick="btnCreateBudget_Click">
                <i class="fas fa-edit"></i>
                <span>Create Budget</span>
            </asp:LinkButton>
            
            <asp:LinkButton ID="btnViewReports" runat="server" CssClass="action-button" OnClick="btnViewReports_Click">
                <i class="fas fa-chart-bar"></i>
                <span>View Reports</span>
            </asp:LinkButton>
        </div>

        <!-- Charts Section -->
        <div class="section-title">
            <h2>Financial Analytics</h2>
        </div>
        <div class="charts-section">
            <div class="chart-container">
                <div class="chart-header">
                    <h3>Income vs Expenses Trend</h3>
                    <asp:DropDownList ID="ddlChartPeriod" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlChartPeriod_SelectedIndexChanged">
                        <asp:ListItem Text="Last 6 Months" Value="6"></asp:ListItem>
                        <asp:ListItem Text="Last Year" Value="12"></asp:ListItem>
                        <asp:ListItem Text="Last 2 Years" Value="24"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="chart-wrapper">
                    <canvas id="incomeExpenseChart"></canvas>
                </div>
            </div>
            
            <div class="chart-container">
                <div class="chart-header">
                    <h3>Expense Distribution</h3>
                    <asp:DropDownList ID="ddlExpensePeriod" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlExpensePeriod_SelectedIndexChanged">
                        <asp:ListItem Text="Current Month" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Last Month" Value="2"></asp:ListItem>
                        <asp:ListItem Text="This Quarter" Value="3"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="chart-wrapper">
                    <canvas id="expenseDistributionChart"></canvas>
                </div>
            </div>
            
            <div class="chart-container">
                <div class="chart-header">
                    <h3>Income Sources</h3>
                    <asp:DropDownList ID="ddlIncomePeriod" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlIncomePeriod_SelectedIndexChanged">
                        <asp:ListItem Text="Current Month" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Last Month" Value="2"></asp:ListItem>
                        <asp:ListItem Text="This Quarter" Value="3"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="chart-wrapper">
                    <canvas id="incomeSourcesChart"></canvas>
                </div>
            </div>
            
            <div class="chart-container">
                <div class="chart-header">
                    <h3>Yearly Overview</h3>
                    <asp:DropDownList ID="ddlYearlyPeriod" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlYearlyPeriod_SelectedIndexChanged">
                        <asp:ListItem Text="Last 5 Years" Value="5"></asp:ListItem>
                        <asp:ListItem Text="Last 3 Years" Value="3"></asp:ListItem>
                        <asp:ListItem Text="Current Year" Value="1"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="chart-wrapper">
                    <canvas id="yearlyOverviewChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Data Tables Section -->
        <div class="section-title">
            <h2>Recent Activity</h2>
        </div>
        <div class="tables-section">
            <div class="table-container">
                <div class="table-header">
                    <h3>Recent Transactions</h3>
                    <asp:LinkButton ID="btnViewAllTransactions" runat="server" CssClass="btn-view-all" OnClick="btnViewAllTransactions_Click">
                        View All <i class="fas fa-arrow-right"></i>
                    </asp:LinkButton>
                </div>
                <asp:GridView ID="gvRecentTransactions" runat="server" AutoGenerateColumns="False" 
                    CssClass="financial-table" GridLines="None" ShowHeader="true">
                    <Columns>
                        <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:BoundField DataField="Category" HeaderText="Category" />
                        <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" />
                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <span class='status-badge <%# Eval("Type").ToString() == "Income" ? "status-income" : "status-expense" %>'>
                                    <%# Eval("Type") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            
            <div class="table-container">
                <div class="table-header">
                    <h3>Budget Alerts</h3>
                    <asp:LinkButton ID="btnViewAllAlerts" runat="server" CssClass="btn-view-all" OnClick="btnViewAllAlerts_Click">
                        View All <i class="fas fa-arrow-right"></i>
                    </asp:LinkButton>
                </div>
                <asp:GridView ID="gvBudgetAlerts" runat="server" AutoGenerateColumns="False" 
                    CssClass="financial-table" GridLines="None" ShowHeader="true">
                    <Columns>
                        <asp:BoundField DataField="Category" HeaderText="Category" />
                        <asp:BoundField DataField="BudgetAmount" HeaderText="Budget" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="ActualAmount" HeaderText="Actual" DataFormatString="{0:C}" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='status-badge <%# GetAlertStatusClass(Eval("Status").ToString()) %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <!-- Hidden fields to store data for charts -->
    <asp:HiddenField ID="hfExpenseCategories" runat="server" />
    <asp:HiddenField ID="hfExpenseAmounts" runat="server" />
    <asp:HiddenField ID="hfIncomeCategories" runat="server" />
    <asp:HiddenField ID="hfIncomeAmounts" runat="server" />
    <asp:HiddenField ID="hfMonthlyLabels" runat="server" />
    <asp:HiddenField ID="hfMonthlyIncome" runat="server" />
    <asp:HiddenField ID="hfMonthlyExpense" runat="server" />
    <asp:HiddenField ID="hfYearlyLabels" runat="server" />
    <asp:HiddenField ID="hfYearlyIncome" runat="server" />
    <asp:HiddenField ID="hfYearlyExpense" runat="server" />

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Initialize charts
            initializeCharts();

            // Add animations to elements when they come into view
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);

            // Observe all stat cards
            document.querySelectorAll('.stat-card').forEach(card => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                observer.observe(card);
            });

            // Observe all action buttons
            document.querySelectorAll('.action-button').forEach(button => {
                button.style.opacity = '0';
                button.style.transform = 'translateY(20px)';
                button.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                observer.observe(button);
            });

            // Observe all summary cards
            document.querySelectorAll('.summary-card').forEach(card => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                observer.observe(card);
            });

            // Start real-time updates
            startRealTimeUpdates();

            // Calculate summary values
            calculateSummaryValues();
        });

        // Global chart variables
        let incomeExpenseChart, expenseDistributionChart, incomeSourcesChart, yearlyOverviewChart;

        function initializeCharts() {
            // Income vs Expenses Chart
            const incomeExpenseCtx = document.getElementById('incomeExpenseChart').getContext('2d');
            const monthlyLabels = JSON.parse(document.getElementById('<%= hfMonthlyLabels.ClientID %>').value || '[]');
            const monthlyIncome = JSON.parse(document.getElementById('<%= hfMonthlyIncome.ClientID %>').value || '[]');
            const monthlyExpense = JSON.parse(document.getElementById('<%= hfMonthlyExpense.ClientID %>').value || '[]');

            incomeExpenseChart = new Chart(incomeExpenseCtx, {
                type: 'line',
                data: {
                    labels: monthlyLabels,
                    datasets: [
                        {
                            label: 'Income',
                            data: monthlyIncome,
                            borderColor: '#00b894',
                            backgroundColor: 'rgba(0, 184, 148, 0.1)',
                            tension: 0.4,
                            fill: true,
                            pointBackgroundColor: '#00b894',
                            pointBorderColor: '#fff',
                            pointRadius: 4,
                            pointHoverRadius: 6
                        },
                        {
                            label: 'Expenses',
                            data: monthlyExpense,
                            borderColor: '#d63031',
                            backgroundColor: 'rgba(214, 48, 49, 0.1)',
                            tension: 0.4,
                            fill: true,
                            pointBackgroundColor: '#d63031',
                            pointBorderColor: '#fff',
                            pointRadius: 4,
                            pointHoverRadius: 6
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                usePointStyle: true,
                                padding: 10,
                                boxWidth: 8,
                                font: {
                                    size: 11
                                }
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(255, 255, 255, 0.9)',
                            titleColor: '#2d3436',
                            bodyColor: '#636e72',
                            borderColor: '#dfe6e9',
                            borderWidth: 1,
                            padding: 10,
                            displayColors: true,
                            callbacks: {
                                label: function (context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed.y !== null) {
                                        label += new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(context.parsed.y);
                                    }
                                    return label;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0, 0, 0, 0.05)'
                            },
                            ticks: {
                                callback: function (value) {
                                    return '$' + value.toLocaleString();
                                },
                                font: {
                                    size: 10
                                }
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                font: {
                                    size: 10
                                }
                            }
                        }
                    }
                }
            });

            // Expense Distribution Chart
            const expenseDistributionCtx = document.getElementById('expenseDistributionChart').getContext('2d');
            const expenseCategories = JSON.parse(document.getElementById('<%= hfExpenseCategories.ClientID %>').value || '[]');
            const expenseAmounts = JSON.parse(document.getElementById('<%= hfExpenseAmounts.ClientID %>').value || '[]');

            expenseDistributionChart = new Chart(expenseDistributionCtx, {
                type: 'doughnut',
                data: {
                    labels: expenseCategories,
                    datasets: [{
                        data: expenseAmounts,
                        backgroundColor: [
                            '#4a69bd',
                            '#6c5ce7',
                            '#00b894',
                            '#fdcb6e',
                            '#d63031',
                            '#636e72'
                        ],
                        borderWidth: 2,
                        borderColor: '#fff',
                        hoverOffset: 10
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 10,
                                usePointStyle: true,
                                boxWidth: 8,
                                font: {
                                    size: 11
                                }
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(255, 255, 255, 0.9)',
                            titleColor: '#2d3436',
                            bodyColor: '#636e72',
                            borderColor: '#dfe6e9',
                            borderWidth: 1,
                            padding: 10,
                            callbacks: {
                                label: function (context) {
                                    let label = context.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed !== null) {
                                        label += new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(context.parsed);
                                    }
                                    return label;
                                }
                            }
                        }
                    },
                    cutout: '60%'
                }
            });

            // Income Sources Chart
            const incomeSourcesCtx = document.getElementById('incomeSourcesChart').getContext('2d');
            const incomeCategories = JSON.parse(document.getElementById('<%= hfIncomeCategories.ClientID %>').value || '[]');
            const incomeAmounts = JSON.parse(document.getElementById('<%= hfIncomeAmounts.ClientID %>').value || '[]');

            incomeSourcesChart = new Chart(incomeSourcesCtx, {
                type: 'pie',
                data: {
                    labels: incomeCategories,
                    datasets: [{
                        data: incomeAmounts,
                        backgroundColor: [
                            '#00b894',
                            '#00cec9',
                            '#55efc4',
                            '#81ecec',
                            '#74b9ff'
                        ],
                        borderWidth: 2,
                        borderColor: '#fff',
                        hoverOffset: 10
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 10,
                                usePointStyle: true,
                                boxWidth: 8,
                                font: {
                                    size: 11
                                }
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(255, 255, 255, 0.9)',
                            titleColor: '#2d3436',
                            bodyColor: '#636e72',
                            borderColor: '#dfe6e9',
                            borderWidth: 1,
                            padding: 10,
                            callbacks: {
                                label: function (context) {
                                    let label = context.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed !== null) {
                                        label += new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(context.parsed);
                                    }
                                    return label;
                                }
                            }
                        }
                    }
                }
            });

            // Yearly Overview Chart
            const yearlyOverviewCtx = document.getElementById('yearlyOverviewChart').getContext('2d');
            const yearlyLabels = JSON.parse(document.getElementById('<%= hfYearlyLabels.ClientID %>').value || '[]');
            const yearlyIncome = JSON.parse(document.getElementById('<%= hfYearlyIncome.ClientID %>').value || '[]');
            const yearlyExpense = JSON.parse(document.getElementById('<%= hfYearlyExpense.ClientID %>').value || '[]');

            yearlyOverviewChart = new Chart(yearlyOverviewCtx, {
                type: 'bar',
                data: {
                    labels: yearlyLabels,
                    datasets: [
                        {
                            label: 'Income',
                            data: yearlyIncome,
                            backgroundColor: 'rgba(0, 184, 148, 0.7)',
                            borderColor: '#00b894',
                            borderWidth: 1
                        },
                        {
                            label: 'Expenses',
                            data: yearlyExpense,
                            backgroundColor: 'rgba(214, 48, 49, 0.7)',
                            borderColor: '#d63031',
                            borderWidth: 1
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                usePointStyle: true,
                                padding: 10,
                                boxWidth: 8,
                                font: {
                                    size: 11
                                }
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(255, 255, 255, 0.9)',
                            titleColor: '#2d3436',
                            bodyColor: '#636e72',
                            borderColor: '#dfe6e9',
                            borderWidth: 1,
                            padding: 10,
                            displayColors: true,
                            callbacks: {
                                label: function (context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed.y !== null) {
                                        label += new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(context.parsed.y);
                                    }
                                    return label;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0, 0, 0, 0.05)'
                            },
                            ticks: {
                                callback: function (value) {
                                    return '$' + value.toLocaleString();
                                },
                                font: {
                                    size: 10
                                }
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                font: {
                                    size: 10
                                }
                            }
                        }
                    }
                }
            });
        }

        // Function to update charts after postback
        function updateCharts() {
            // Update Income vs Expenses Chart
            const monthlyLabels = JSON.parse(document.getElementById('<%= hfMonthlyLabels.ClientID %>').value || '[]');
            const monthlyIncome = JSON.parse(document.getElementById('<%= hfMonthlyIncome.ClientID %>').value || '[]');
            const monthlyExpense = JSON.parse(document.getElementById('<%= hfMonthlyExpense.ClientID %>').value || '[]');
            
            incomeExpenseChart.data.labels = monthlyLabels;
            incomeExpenseChart.data.datasets[0].data = monthlyIncome;
            incomeExpenseChart.data.datasets[1].data = monthlyExpense;
            incomeExpenseChart.update();
            
            // Update Yearly Overview Chart
            const yearlyLabels = JSON.parse(document.getElementById('<%= hfYearlyLabels.ClientID %>').value || '[]');
            const yearlyIncome = JSON.parse(document.getElementById('<%= hfYearlyIncome.ClientID %>').value || '[]');
            const yearlyExpense = JSON.parse(document.getElementById('<%= hfYearlyExpense.ClientID %>').value || '[]');
            
            yearlyOverviewChart.data.labels = yearlyLabels;
            yearlyOverviewChart.data.datasets[0].data = yearlyIncome;
            yearlyOverviewChart.data.datasets[1].data = yearlyExpense;
            yearlyOverviewChart.update();
        }
        
        // Function to update expense distribution chart
        function updateExpenseChart() {
            const expenseCategories = JSON.parse(document.getElementById('<%= hfExpenseCategories.ClientID %>').value || '[]');
            const expenseAmounts = JSON.parse(document.getElementById('<%= hfExpenseAmounts.ClientID %>').value || '[]');
            
            expenseDistributionChart.data.labels = expenseCategories;
            expenseDistributionChart.data.datasets[0].data = expenseAmounts;
            expenseDistributionChart.update();
        }
        
        // Function to update income sources chart
        function updateIncomeChart() {
            const incomeCategories = JSON.parse(document.getElementById('<%= hfIncomeCategories.ClientID %>').value || '[]');
            const incomeAmounts = JSON.parse(document.getElementById('<%= hfIncomeAmounts.ClientID %>').value || '[]');
            
            incomeSourcesChart.data.labels = incomeCategories;
            incomeSourcesChart.data.datasets[0].data = incomeAmounts;
            incomeSourcesChart.update();
        }
        
        // Function to update yearly overview chart
        function updateYearlyChart() {
            const yearlyLabels = JSON.parse(document.getElementById('<%= hfYearlyLabels.ClientID %>').value || '[]');
            const yearlyIncome = JSON.parse(document.getElementById('<%= hfYearlyIncome.ClientID %>').value || '[]');
            const yearlyExpense = JSON.parse(document.getElementById('<%= hfYearlyExpense.ClientID %>').value || '[]');
            
            yearlyOverviewChart.data.labels = yearlyLabels;
            yearlyOverviewChart.data.datasets[0].data = yearlyIncome;
            yearlyOverviewChart.data.datasets[1].data = yearlyExpense;
            yearlyOverviewChart.update();
        }
        
        function calculateSummaryValues() {
            // Get current values from the page
            const totalIncomeText = document.getElementById('<%= lblTotalIncome.ClientID %>').innerText;
            const totalExpensesText = document.getElementById('<%= lblTotalExpenses.ClientID %>').innerText;

            // Parse currency values
            const totalIncome = parseFloat(totalIncomeText.replace(/[^0-9.-]+/g, ''));
            const totalExpenses = parseFloat(totalExpensesText.replace(/[^0-9.-]+/g, ''));

            // Calculate current balance
            const currentBalance = totalIncome - totalExpenses;
            document.getElementById('currentBalance').innerText = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(currentBalance);

            // Calculate monthly savings
            document.getElementById('monthlySavings').innerText = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(currentBalance);

            // Calculate YTD values (simplified - in a real app, these would come from the database)
            const ytdIncome = totalIncome * 12; // Simplified calculation
            const ytdExpenses = totalExpenses * 12; // Simplified calculation

            document.getElementById('ytdIncome').innerText = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(ytdIncome);
            document.getElementById('ytdExpenses').innerText = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(ytdExpenses);
        }

        function startRealTimeUpdates() {
            // Update the dashboard every 30 seconds
            setInterval(function () {
                // Make an AJAX call to get the latest data
                fetchRealTimeData();
            }, 30000); // Update every 30 seconds
        }

        function fetchRealTimeData() {
            // Create an AJAX request to the WebMethod
            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'FinanceDashboard.aspx/GetRealTimeData', true);
            xhr.setRequestHeader('Content-Type', 'application/json; charset=utf-8');
            xhr.setRequestHeader('Accept', 'application/json, text/javascript, */*; q=0.01');
            
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.d) {
                                const data = JSON.parse(response.d);
                                
                                // Check if there's an error
                                if (data.Error) {
                                    console.error('Error fetching real-time data:', data.Message);
                                    return;
                                }
                                
                                // Update the dashboard with real data
                                updateDashboardWithRealData(data);
                            }
                        } catch (e) {
                            console.error('Error parsing response:', e);
                        }
                    } else {
                        console.error('Request failed with status:', xhr.status);
                    }
                }
            };
            
            xhr.send(JSON.stringify({}));
        }

        function updateDashboardWithRealData(data) {
            // Update the real-time indicator
            const realTimeIndicator = document.querySelector('.real-time-indicator');
            if (realTimeIndicator) {
                realTimeIndicator.innerHTML = `<span class="pulse"></span>Live - Last updated: ${data.LastUpdated}`;
            }
            
            // Get current values
            const totalIncomeElement = document.getElementById('<%= lblTotalIncome.ClientID %>');
            const totalExpensesElement = document.getElementById('<%= lblTotalExpenses.ClientID %>');
            const budgetUtilizationElement = document.getElementById('<%= lblBudgetUtilization.ClientID %>');
            const activeAlertsElement = document.getElementById('<%= lblActiveAlerts.ClientID %>');

            // Parse current values
            const currentIncome = parseFloat(totalIncomeElement.innerText.replace(/[^0-9.-]+/g, ''));
            const currentExpenses = parseFloat(totalExpensesElement.innerText.replace(/[^0-9.-]+/g, ''));

            // Update values with animation if they changed
            if (currentIncome !== data.TotalIncome) {
                animateValue(totalIncomeElement, currentIncome, data.TotalIncome, 1000);
                showUpdateIndicator('incomeUpdateIndicator');
            }

            if (currentExpenses !== data.TotalExpenses) {
                animateValue(totalExpensesElement, currentExpenses, data.TotalExpenses, 1000);
                showUpdateIndicator('expenseUpdateIndicator');
            }

            // Update budget utilization
            const currentBudget = parseFloat(budgetUtilizationElement.innerText.replace(/[^0-9.-]+/g, ''));
            if (currentBudget !== data.BudgetUtilization) {
                budgetUtilizationElement.innerText = data.BudgetUtilization + '%';
                showUpdateIndicator('budgetUpdateIndicator');
            }

            // Update active alerts
            const currentAlerts = parseInt(activeAlertsElement.innerText);
            if (currentAlerts !== data.ActiveAlerts) {
                activeAlertsElement.innerText = data.ActiveAlerts;
                showUpdateIndicator('alertsUpdateIndicator');
            }

            // Recalculate summary values
            calculateSummaryValues();
        }

        function showUpdateIndicator(indicatorId) {
            const indicator = document.getElementById(indicatorId);
            if (indicator) {
                indicator.classList.add('active');
                setTimeout(() => {
                    indicator.classList.remove('active');
                }, 3000);
            }
        }

        function animateValue(element, start, end, duration) {
            const range = end - start;
            const increment = range / (duration / 16); // 60fps
            let current = start;

            const timer = setInterval(function () {
                current += increment;
                if ((increment > 0 && current >= end) || (increment < 0 && current <= end)) {
                    current = end;
                    clearInterval(timer);
                }

                element.innerText = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(current);
            }, 16);
        }
    </script>
</asp:Content>