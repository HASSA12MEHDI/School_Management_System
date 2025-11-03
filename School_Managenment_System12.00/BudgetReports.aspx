<%@ Page Title="Budget Reports" Language="C#" MasterPageFile="~/Site2.Master" AutoEventWireup="true" CodeBehind="BudgetReports.aspx.cs" Inherits="School_Managenment_System12._00.BudgetReports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .budget-reports-container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 10px;
            box-sizing: border-box;
        }
        
        /* Alert Styles */
        .alert-critical {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 10px;
            border-left: 4px solid #dc3545;
        }

        .alert-warning {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 10px;
            border-left: 4px solid #ffc107;
        }

        .alert-advisory {
            background: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 10px;
            border-left: 4px solid #17a2b8;
        }

        .alert-item {
            padding: 8px;
            border-left: 3px solid #f39c12;
            background: #fff9e6;
            border-radius: 6px;
            margin-bottom: 8px;
            max-width: 100%;
        }

        .reports-header {
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .reports-title {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 3px;
        }

        .reports-subtitle {
            font-size: 12px;
            opacity: 0.9;
        }

        .metric-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 12px;
            margin-bottom: 12px;
        }

        .metric-card {
            background: white;
            border-radius: 10px;
            padding: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border: none;
            min-height: 110px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .metric-value {
            font-size: 20px;
            font-weight: 700;
            margin: 5px 0;
            line-height: 1.1;
        }

        .metric-label {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: 3px;
        }

        .metric-description {
            font-size: 10px;
            color: #7f8c8d;
            line-height: 1.2;
            margin: 0;
        }

        .metric-icon {
            font-size: 16px;
            margin-bottom: 8px;
            width: 35px;
            height: 35px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Metric Card Colors - Compact */
        .income-card {
            border-left: 3px solid #27ae60;
        }
        .income-card .metric-icon {
            background: rgba(39, 174, 96, 0.1);
            color: #27ae60;
        }
        .income-card .metric-value {
            color: #27ae60;
            font-size: 18px;
        }

        .expense-card {
            border-left: 3px solid #e74c3c;
        }
        .expense-card .metric-icon {
            background: rgba(231, 76, 60, 0.1);
            color: #e74c3c;
        }
        .expense-card .metric-value {
            color: #e74c3c;
            font-size: 18px;
        }

        .budget-card {
            border-left: 3px solid #3498db;
        }
        .budget-card .metric-icon {
            background: rgba(52, 152, 219, 0.1);
            color: #3498db;
        }
        .budget-card .metric-value {
            color: #3498db;
            font-size: 18px;
        }

        .salary-card {
            border-left: 3px solid #9b59b6;
        }
        .salary-card .metric-icon {
            background: rgba(155, 89, 182, 0.1);
            color: #9b59b6;
        }
        .salary-card .metric-value {
            color: #9b59b6;
            font-size: 18px;
        }

        .net-income-card {
            border-left: 3px solid #2ecc71;
        }
        .net-income-card .metric-icon {
            background: rgba(46, 204, 113, 0.1);
            color: #2ecc71;
        }
        .net-income-card .metric-value {
            color: #2ecc71;
            font-size: 18px;
        }

        .remain-budget-card {
            border-left: 3px solid #f39c12;
        }
        .remain-budget-card .metric-icon {
            background: rgba(243, 156, 18, 0.1);
            color: #f39c12;
        }
        .remain-budget-card .metric-value {
            color: #f39c12;
            font-size: 18px;
        }

        .profit-card {
            border-left: 3px solid #e74c3c;
        }
        .profit-card .metric-icon {
            background: rgba(231, 76, 60, 0.1);
            color: #e74c3c;
        }
        .profit-card .metric-value {
            color: #e74c3c;
            font-size: 18px;
        }

        .negative-value {
            color: #e74c3c !important;
            font-weight: bold;
        }

        .budget-note {
            font-size: 9px;
            color: #7f8c8d;
            font-style: italic;
        }

        /* Analysis Section */
        .analysis-section {
            background: white;
            border-radius: 10px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 12px;
        }

        .section-title {
            font-size: 14px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .health-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
        }

        .health-card {
            text-align: center;
            padding: 10px;
            border-radius: 6px;
            background: #f8f9fa;
        }

        .health-value {
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 2px;
        }

        .health-label {
            font-size: 10px;
            color: #6c757d;
        }

        .financial-health-excellent {
            color: #27ae60;
        }

        .financial-health-good {
            color: #3498db;
        }

        .financial-health-fair {
            color: #f39c12;
        }

        .financial-health-poor {
            color: #e74c3c;
        }

        /* Chart Styles */
        .chart-container {
            background: white;
            border-radius: 10px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 12px;
            height: 300px;
        }

        .chart-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 12px;
        }

        .chart-title {
            font-size: 14px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
            text-align: center;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
            justify-content: flex-end;
        }

        .btn-refresh {
            background: #3498db;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn-run-checks {
            background: #27ae60;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            font-size: 12px;
        }

        .table th, .table td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .table th {
            background: #f8f9fa;
            font-weight: 600;
        }

        .table-striped tr:nth-child(even) {
            background: #f8f9fa;
        }

        .concession-highlight {
            background-color: #fff8e1;
            border-left: 3px solid #ffc107;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
        }

        .concession-title {
            font-weight: 600;
            color: #856404;
            margin-bottom: 5px;
        }

        .concession-value {
            font-size: 16px;
            font-weight: 700;
            color: #dc3545;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            font-size: 12px;
            color: #2c3e50;
        }

        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 13px;
        }

        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
        }

        .btn-success {
            background: #27ae60;
            color: white;
        }

        .btn-secondary {
            background: #95a5a6;
            color: white;
        }

        .btn-danger {
            background: #e74c3c;
            color: white;
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 11px;
        }

        @media (max-width: 768px) {
            .metric-row {
                grid-template-columns: 1fr;
            }

            .chart-row {
                grid-template-columns: 1fr;
            }

            .chart-container {
                height: 250px;
            }

            .reports-header {
                padding: 12px;
            }

            .reports-title {
                font-size: 18px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
        }
    </style>

    <div class="budget-reports-container">
        <!-- Year Selection -->
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="form-group">
                    <label for="DdlYear">Select Year:</label>
                    <asp:DropDownList ID="DdlYear" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="DdlYear_SelectedIndexChanged">
                        <asp:ListItem Value="2023">2023</asp:ListItem>
                        <asp:ListItem Value="2024">2024</asp:ListItem>
                        <asp:ListItem Value="2025" Selected="True">2025</asp:ListItem>
                        <asp:ListItem Value="2026">2026</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <asp:Button ID="BtnRefreshReports" runat="server" Text="Refresh Reports" 
                CssClass="btn-refresh" OnClick="BtnRefreshReports_Click" />
            <asp:Button ID="BtnRunBudgetChecks" runat="server" Text="Run Budget Checks" 
                CssClass="btn-run-checks" OnClick="BtnRunBudgetChecks_Click" />
        </div>

        <!-- Reports Header -->
        <div class="reports-header">
            <h1 class="reports-title">
                <i class="fas fa-chart-bar me-2"></i>Budget Reports & Analysis
            </h1>
            <p class="reports-subtitle">Comprehensive financial analysis and budget performance</p>
        </div>

        <div class="reports-grid">
            <!-- First Row - Main Metrics -->
            <div class="metric-row">
                <div class="metric-card income-card">
                    <div class="metric-icon">
                        <i class="fas fa-money-bill-wave"></i>
                    </div>
                    <div class="metric-label">Total Income</div>
                    <div class="metric-value">
                        <asp:Label ID="LblTotalIncome" runat="server" Text="₹0.00"></asp:Label>
                    </div>
                    <p class="metric-description">Income + FeePayment - Concessions</p>
                </div>

                <div class="metric-card expense-card">
                    <div class="metric-icon">
                        <i class="fas fa-receipt"></i>
                    </div>
                    <div class="metric-label">Total Expenses</div>
                    <div class="metric-value">
                        <asp:Label ID="LblTotalExpenses" runat="server" Text="₹0.00"></asp:Label>
                    </div>
                    <p class="metric-description">All monthly expenses</p>
                </div>

                <div class="metric-card budget-card">
                    <div class="metric-icon">
                        <i class="fas fa-wallet"></i>
                    </div>
                    <div class="metric-label">Total Budget</div>
                    <div class="metric-value">
                        <asp:Label ID="LblTotalBudget" runat="server" Text="₹0.00"></asp:Label>
                    </div>
                    <p class="metric-description">
                        <asp:Label ID="LblBudgetNote" runat="server" CssClass="budget-note" Visible="false"></asp:Label>
                    </p>
                </div>

                <div class="metric-card salary-card">
                    <div class="metric-icon">
                        <i class="fas fa-money-check-alt"></i>
                    </div>
                    <div class="metric-label">Total Salaries</div>
                    <div class="metric-value">
                        <asp:Label ID="LblTotalSalaries" runat="server" Text="₹0.00"></asp:Label>
                    </div>
                    <p class="metric-description">Active teachers salaries</p>
                </div>
            </div>

            <!-- Second Row - Calculations -->
            <div class="metric-row">
                <div class="metric-card net-income-card">
                    <div class="metric-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div class="metric-label">Net Income</div>
                    <div class="metric-value">
                        <asp:Label ID="LblNetIncome" runat="server" Text="₹0.00"></asp:Label>
                    </div>
                    <p class="metric-description">Total Income - Total Budget</p>
                </div>

                <div class="metric-card remain-budget-card">
                    <div class="metric-icon">
                        <i class="fas fa-balance-scale"></i>
                    </div>
                    <div class="metric-label">Remain Budget</div>
                    <div class="metric-value">
                        <asp:Label ID="LblRemainBudget" runat="server" Text="₹0.00"></asp:Label>
                    </div>
                    <p class="metric-description">Budget - Expenses - Salaries</p>
                </div>

                <div class="metric-card profit-card">
                    <div class="metric-icon">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <div class="metric-label">Total Profit</div>
                    <div class="metric-value">
                        <asp:Label ID="LblTotalProfit" runat="server" Text="₹0.00"></asp:Label>
                    </div>
                    <p class="metric-description">Net Income + Remain Budget</p>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="chart-row">
                <div class="chart-container">
                    <div class="chart-title">Budget vs Actual Comparison</div>
                    <canvas id="budgetComparisonChart" width="400" height="250"></canvas>
                </div>

                <div class="chart-container">
                    <div class="chart-title">Income Distribution Analysis</div>
                    <canvas id="incomeDistributionChart" width="400" height="250"></canvas>
                </div>
            </div>

            <div class="chart-row">
                <div class="chart-container">
                    <div class="chart-title">Financial Health Indicators</div>
                    <canvas id="financialHealthChart" width="400" height="250"></canvas>
                </div>

                <div class="chart-container">
                    <div class="chart-title">Expense Breakdown</div>
                    <canvas id="expenseBreakdownChart" width="400" height="250"></canvas>
                </div>
            </div>
            <!-- Financial Summary -->
            <div class="metric-row">
                <div class="analysis-section" style="grid-column: 1 / -1;">
                    <h4 class="section-title">
                        <i class="fas fa-heartbeat text-info"></i>Financial Health Summary
                    </h4>
                    <div class="health-grid">
                        <div class="health-card">
                            <div class="health-value">
                                <asp:Label ID="LblFinancialHealth" runat="server" Text="Healthy" CssClass="financial-health-excellent"></asp:Label>
                            </div>
                            <div class="health-label">Status</div>
                        </div>
                        <div class="health-card">
                            <div class="health-value">
                                <asp:Label ID="LblSavings" runat="server" Text="₹0.00"></asp:Label>
                            </div>
                            <div class="health-label">Savings</div>
                        </div>
                        <div class="health-card">
                            <div class="health-value">
                                <asp:Label ID="LblMonthlyAverage" runat="server" Text="₹0.00"></asp:Label>
                            </div>
                            <div class="health-label">Avg Income</div>
                        </div>
                        <div class="health-card">
                            <div class="health-value">
                                <asp:Label ID="LblActiveBudgets" runat="server" Text="0"></asp:Label>
                            </div>
                            <div class="health-label">Active Budgets</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Detailed Breakdown -->
            <div class="metric-row">
                <div class="analysis-section" style="grid-column: 1 / -1;">
                    <h4 class="section-title">
                        <i class="fas fa-list-alt text-primary"></i>Detailed Financial Breakdown
                    </h4>
                    <div style="font-size: 11px; line-height: 1.4;">
                        <div class="row">
                            <div class="col-md-6">
                                <strong>Total Income Calculation:</strong><br />
                                • Income from Income Table:
                                <asp:Label ID="LblIncomeFromTable" runat="server" Text="₹0.00"></asp:Label><br />
                                • Total Fee Payments:
                                <asp:Label ID="LblTotalFeePayment" runat="server" Text="₹0.00"></asp:Label><br />
                                • Total Fee Concessions:
                                <asp:Label ID="LblTotalFeeConcession" runat="server" Text="₹0.00" CssClass="text-danger"></asp:Label><br />
                                • <strong>Net Income:
                                    <asp:Label ID="LblNetIncomeCalc" runat="server" Text="₹0.00"></asp:Label></strong>
                            </div>
                            <div class="col-md-6">
                                <strong>Budget Analysis:</strong><br />
                                • Total Budget:
                                <asp:Label ID="LblBudgetTotal" runat="server" Text="₹0.00"></asp:Label><br />
                                • Total Expenses:
                                <asp:Label ID="LblExpensesTotal" runat="server" Text="₹0.00"></asp:Label><br />
                                • Total Salaries:
                                <asp:Label ID="LblSalariesTotal" runat="server" Text="₹0.00"></asp:Label><br />
                                • <strong>Remain Budget:
                                    <asp:Label ID="LblRemainBudgetCalc" runat="server" Text="₹0.00"></asp:Label></strong>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Fee Concessions Display -->
            <div class="metric-row">
                <div class="analysis-section" style="grid-column: 1 / -1;">
                    <h4 class="section-title">
                        <i class="fas fa-hand-holding-usd text-success"></i>Fee Concessions
                    </h4>
                    
                    <div class="concession-highlight">
                        <div class="concession-title">Total Fee Concessions for <asp:Label ID="LblConcessionYear" runat="server"></asp:Label></div>
                        <div class="concession-value">
                            <asp:Label ID="LblTotalConcessionDisplay" runat="server" Text="₹0.00"></asp:Label>
                        </div>
                        <div class="text-muted">These concessions are automatically subtracted from total income</div>
                    </div>
                    
                    <!-- Display current fee concessions list -->
                    <div class="mt-3">
                        <h5>Current Fee Concessions Details</h5>
                        <asp:GridView ID="GvFeeConcessions" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-striped" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="StudentName" HeaderText="Student" />
                                <asp:BoundField DataField="FeeType" HeaderText="Fee Type" />
                                <asp:BoundField DataField="DiscountDisplay" HeaderText="Discount" />
                                <asp:BoundField DataField="Reason" HeaderText="Reason" />
                                <asp:BoundField DataField="ValidFrom" HeaderText="Valid From" DataFormatString="{0:dd-MM-yyyy}" />
                                <asp:BoundField DataField="ValidTo" HeaderText="Valid To" DataFormatString="{0:dd-MM-yyyy}" />
                            </Columns>
                        </asp:GridView>
                        
                        <asp:Label ID="LblNoConcessions" runat="server" Text="No fee concessions found for this year"
                            CssClass="text-muted text-center d-block" Style="font-size: 12px; padding: 15px;" Visible="false"></asp:Label>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart.js Library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="text/javascript">
        // Initialize all charts when page loads
        document.addEventListener('DOMContentLoaded', function () {
            initializeAllCharts();
        });

        function initializeAllCharts() {
            // Get data from server-side variables (these will be set in code-behind)
            const totalIncome = parseFloat('<%= GetTotalIncomeValue() %>') || 0;
            const totalExpenses = parseFloat('<%= GetTotalExpensesValue() %>') || 0;
            const totalBudget = parseFloat('<%= GetTotalBudgetValue() %>') || 0;
            const totalSalaries = parseFloat('<%= GetTotalSalariesValue() %>') || 0;
            const netIncome = parseFloat('<%= GetNetIncomeValue() %>') || 0;
            const remainBudget = parseFloat('<%= GetRemainBudgetValue() %>') || 0;
            const totalProfit = parseFloat('<%= GetTotalProfitValue() %>') || 0;
            const feeConcessions = parseFloat('<%= GetFeeConcessionsValue() %>') || 0;

            // Initialize all charts
            initializeBudgetComparisonChart(totalIncome, totalExpenses, totalBudget, totalSalaries);
            initializeIncomeDistributionChart(totalIncome, netIncome, remainBudget, totalProfit, feeConcessions);
            initializeFinancialHealthChart(totalBudget, totalExpenses, totalSalaries);
            initializeExpenseBreakdownChart(totalExpenses, totalSalaries);
        }

        function initializeBudgetComparisonChart(income, expenses, budget, salaries) {
            const ctx = document.getElementById('budgetComparisonChart').getContext('2d');

            // Destroy existing chart if it exists
            if (window.budgetComparisonChartInstance) {
                window.budgetComparisonChartInstance.destroy();
            }

            window.budgetComparisonChartInstance = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['Income', 'Expenses', 'Budget', 'Salaries'],
                    datasets: [{
                        label: 'Amount (₹)',
                        data: [income, expenses, budget, salaries],
                        backgroundColor: [
                            'rgba(39, 174, 96, 0.7)',
                            'rgba(231, 76, 60, 0.7)',
                            'rgba(52, 152, 219, 0.7)',
                            'rgba(155, 89, 182, 0.7)'
                        ],
                        borderColor: [
                            'rgba(39, 174, 96, 1)',
                            'rgba(231, 76, 60, 1)',
                            'rgba(52, 152, 219, 1)',
                            'rgba(155, 89, 182, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function (value) {
                                    return '₹' + value.toLocaleString();
                                }
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return '₹' + context.parsed.y.toLocaleString();
                                }
                            }
                        }
                    }
                }
            });
        }

        function initializeIncomeDistributionChart(totalIncome, netIncome, remainBudget, totalProfit, feeConcessions) {
            const ctx = document.getElementById('incomeDistributionChart').getContext('2d');

            // Destroy existing chart if it exists
            if (window.incomeDistributionChartInstance) {
                window.incomeDistributionChartInstance.destroy();
            }

            // Calculate income components
            const incomeFromTable = totalIncome + feeConcessions; // Add back concessions to get original income
            const feePayments = totalIncome - incomeFromTable; // Calculate fee payments

            window.incomeDistributionChartInstance = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Income from Table', 'Fee Payments', 'Fee Concessions', 'Net Income', 'Remain Budget'],
                    datasets: [{
                        data: [incomeFromTable, feePayments, Math.abs(feeConcessions), Math.max(netIncome, 0), Math.max(remainBudget, 0)],
                        backgroundColor: [
                            'rgba(39, 174, 96, 0.7)',
                            'rgba(52, 152, 219, 0.7)',
                            'rgba(231, 76, 60, 0.7)',
                            'rgba(46, 204, 113, 0.7)',
                            'rgba(243, 156, 18, 0.7)'
                        ],
                        borderColor: [
                            'rgba(39, 174, 96, 1)',
                            'rgba(52, 152, 219, 1)',
                            'rgba(231, 76, 60, 1)',
                            'rgba(46, 204, 113, 1)',
                            'rgba(243, 156, 18, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    const label = context.label || '';
                                    const value = context.parsed;
                                    const total = incomeFromTable + feePayments + Math.abs(feeConcessions) + Math.max(netIncome, 0) + Math.max(remainBudget, 0);
                                    const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                                    return `${label}: ₹${value.toLocaleString()} (${percentage}%)`;
                                }
                            }
                        }
                    }
                }
            });
        }

        function initializeFinancialHealthChart(budget, expenses, salaries) {
            const ctx = document.getElementById('financialHealthChart').getContext('2d');

            // Destroy existing chart if it exists
            if (window.financialHealthChartInstance) {
                window.financialHealthChartInstance.destroy();
            }

            const budgetUtilization = budget > 0 ? (expenses / budget) * 100 : 0;
            const salaryRatio = expenses > 0 ? (salaries / expenses) * 100 : 0;
            const remainingBudget = budget - expenses - salaries;

            window.financialHealthChartInstance = new Chart(ctx, {
                type: 'radar',
                data: {
                    labels: ['Budget Utilization', 'Salary Ratio', 'Remaining Budget', 'Expense Control', 'Income Coverage'],
                    datasets: [{
                        label: 'Financial Health',
                        data: [
                            Math.min(budgetUtilization, 100),
                            Math.min(salaryRatio, 100),
                            Math.max(remainingBudget / (budget > 0 ? budget : 1) * 100, 0),
                            80, // Expense Control (assumed)
                            70  // Income Coverage (assumed)
                        ],
                        backgroundColor: 'rgba(52, 152, 219, 0.2)',
                        borderColor: 'rgba(52, 152, 219, 1)',
                        borderWidth: 2,
                        pointBackgroundColor: 'rgba(52, 152, 219, 1)'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        r: {
                            beginAtZero: true,
                            max: 100,
                            ticks: {
                                display: false
                            }
                        }
                    }
                }
            });
        }

        function initializeExpenseBreakdownChart(totalExpenses, salaries) {
            const ctx = document.getElementById('expenseBreakdownChart').getContext('2d');

            // Destroy existing chart if it exists
            if (window.expenseBreakdownChartInstance) {
                window.expenseBreakdownChartInstance.destroy();
            }

            // Calculate other expenses (total expenses minus salaries)
            const otherExpenses = Math.max(totalExpenses - salaries, 0);

            window.expenseBreakdownChartInstance = new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: ['Salaries', 'Other Expenses'],
                    datasets: [{
                        data: [salaries, otherExpenses],
                        backgroundColor: [
                            'rgba(155, 89, 182, 0.7)',
                            'rgba(231, 76, 60, 0.7)'
                        ],
                        borderColor: [
                            'rgba(155, 89, 182, 1)',
                            'rgba(231, 76, 60, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    const label = context.label || '';
                                    const value = context.parsed;
                                    const total = totalExpenses > 0 ? totalExpenses : 1;
                                    const percentage = ((value / total) * 100).toFixed(1);
                                    return `${label}: ₹${value.toLocaleString()} (${percentage}%)`;
                                }
                            }
                        }
                    }
                }
            });
        }
    </script>
</asp:Content>