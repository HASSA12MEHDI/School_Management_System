<%@ Page Title="Budget Alerts - Financial Monitoring" Language="C#" MasterPageFile="~/Site2.master" AutoEventWireup="true"
    CodeBehind="BudgetAlerts.aspx.cs" Inherits="SchoolFinancialManagementSystem.BudgetAlerts" MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        .alerts-page {
            background: #f8f9fa;
            color: #333;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            padding: 20px 0;
        }

        .alert-summary-card {
            background: white;
            border-radius: 12px;
            padding: 25px 20px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border: 1px solid #e0e0e0;
            transition: all 0.3s ease;
            height: 100%;
            position: relative;
            overflow: hidden;
        }

        .alert-summary-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
        }

        .alert-summary-card.critical::before {
            background: linear-gradient(90deg, #d32f2f 0%, #ff6b6b 100%);
        }

        .alert-summary-card.warning::before {
            background: linear-gradient(90deg, #ff9100 0%, #ffb142 100%);
        }

        .alert-summary-card.info::before {
            background: linear-gradient(90deg, #00bfa5 0%, #00d9d9 100%);
        }

        .alert-summary-card.total::before {
            background: linear-gradient(90deg, #7c4dff 0%, #b388ff 100%);
        }

        .alert-summary-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .alert-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
        }

        .alert-summary-card.critical .alert-icon {
            color: #d32f2f;
        }

        .alert-summary-card.warning .alert-icon {
            color: #ff9100;
        }

        .alert-summary-card.info .alert-icon {
            color: #00bfa5;
        }

        .alert-summary-card.total .alert-icon {
            color: #7c4dff;
        }

        .alert-label {
            color: #666;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 12px;
            font-weight: 600;
        }

        .alert-value {
            font-size: 2.2rem;
            font-weight: 800;
            color: #333;
            margin: 10px 0;
        }

        .alerts-container {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid #e0e0e0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        .alerts-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #00bfa5 0%, #7c4dff 100%);
        }

        .section-title {
            color: #2c3e50;
            font-weight: 700;
            margin-bottom: 25px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            border-bottom: 2px solid #3498db;
            padding-bottom: 15px;
            font-size: 1.3rem;
        }

        .alert-item {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 16px;
            border-left: 6px solid;
            transition: all 0.3s ease;
            border: 1px solid #e0e0e0;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .alert-item.critical {
            border-left-color: #d32f2f;
            background: linear-gradient(145deg, rgba(211, 47, 47, 0.05) 0%, white 100%);
        }

        .alert-item.warning {
            border-left-color: #ff9100;
            background: linear-gradient(145deg, rgba(255, 145, 0, 0.05) 0%, white 100%);
        }

        .alert-item.info {
            border-left-color: #00bfa5;
            background: linear-gradient(145deg, rgba(0, 191, 165, 0.05) 0%, white 100%);
        }

        .alert-item:hover {
            transform: translateX(5px) translateY(-2px);
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.12);
        }

        .alert-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .alert-type {
            padding: 6px 16px;
            border-radius: 25px;
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        }

        .alert-type.critical {
            background: #d32f2f;
            color: white;
        }

        .alert-type.warning {
            background: #ff9100;
            color: white;
        }

        .alert-type.info {
            background: #00bfa5;
            color: white;
        }

        .alert-date {
            color: #666;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .alert-message {
            color: #333;
            font-size: 0.95rem;
            line-height: 1.5;
            margin-bottom: 12px;
            font-weight: 500;
        }

        .alert-details {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-top: 12px;
            font-size: 0.85rem;
            border: 1px solid #e0e0e0;
        }

        .alert-detail-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 6px;
            padding: 4px 0;
        }

        .alert-detail-label {
            color: #666;
            font-weight: 600;
        }

        .alert-detail-value {
            color: #333;
            font-weight: 700;
        }

        .filter-container {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid #e0e0e0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        .filter-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #7c4dff 0%, #00bfa5 100%);
        }

        .form-group-enhanced {
            margin-bottom: 20px;
        }

        .form-label-enhanced {
            color: #333;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 0.9rem;
            display: block;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .form-control-enhanced, .form-select-enhanced {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 12px 16px;
            background: white;
            color: #333;
            transition: all 0.3s ease;
            font-size: 0.9rem;
            font-weight: 500;
            width: 100%;
        }

        .form-control-enhanced:focus, .form-select-enhanced:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .btn-gold {
            background: linear-gradient(135deg, #00bfa5 0%, #7c4dff 100%);
            border: none;
            border-radius: 8px;
            padding: 14px 28px;
            font-weight: 700;
            color: white;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.9rem;
        }

        .btn-gold:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(0, 191, 165, 0.3);
        }

        .btn-outline-gold {
            border-radius: 8px;
            padding: 12px 24px;
            font-weight: 700;
            background: transparent;
            border: 2px solid #00bfa5;
            color: #00bfa5;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.9rem;
        }

        .btn-outline-gold:hover {
            background: #00bfa5;
            color: white;
        }

        .btn-action {
            border-radius: 6px;
            padding: 8px 16px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            min-width: 80px;
            text-align: center;
            display: inline-block;
            margin: 4px;
            cursor: pointer;
            text-decoration: none;
            border: none;
            transition: all 0.3s ease;
        }

        .btn-dismiss {
            background: #00bfa5;
            color: white;
        }

        .btn-dismiss:hover {
            background: #009688;
        }

        .btn-view {
            background: #7c4dff;
            color: white;
        }

        .btn-view:hover {
            background: #651fff;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px 15px;
            text-align: center;
            border: 1px solid #e0e0e0;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
        }

        .stat-label {
            color: #666;
            font-size: 0.8rem;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 800;
            color: #333;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .priority-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 8px;
        }

        .priority-critical {
            background: #d32f2f;
        }

        .priority-warning {
            background: #ff9100;
        }

        .priority-info {
            background: #00bfa5;
        }

        .alert-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            flex-wrap: wrap;
        }

        .risk-meter {
            height: 10px;
            background: #e0e0e0;
            border-radius: 5px;
            margin: 12px 0;
            overflow: hidden;
            border: 1px solid #ddd;
        }

        .risk-level {
            height: 100%;
            border-radius: 5px;
            transition: width 0.5s ease;
        }

        .risk-high {
            background: linear-gradient(90deg, #d32f2f 0%, #ff6b6b 100%);
        }

        .risk-medium {
            background: linear-gradient(90deg, #ff9100 0%, #ffb142 100%);
        }

        .risk-low {
            background: linear-gradient(90deg, #00bfa5 0%, #00d9d9 100%);
        }

        .badge {
            border-radius: 6px;
            padding: 8px 16px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.75rem;
        }

        .badge-critical {
            background: #d32f2f;
            color: white;
        }

        .badge-warning {
            background: #ff9100;
            color: white;
        }

        .badge-info {
            background: #00bfa5;
            color: white;
        }

        .alert-critical {
            color: #d32f2f;
        }

        .alert-warning {
            color: #ff9100;
        }

        .alert-info {
            color: #00bfa5;
        }

        .financial-analysis {
            background: #e3f2fd;
            border-radius: 8px;
            padding: 15px;
            margin-top: 12px;
            border-left: 4px solid #2196f3;
        }

        .analysis-title {
            font-weight: 700;
            color: #1976d2;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }

        .analysis-content {
            font-size: 0.85rem;
            line-height: 1.4;
            color: #333;
        }

        .impact-level {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 700;
            margin-left: 8px;
        }

        .impact-high {
            background: #ffebee;
            color: #d32f2f;
        }

        .impact-medium {
            background: #fff3e0;
            color: #ff9100;
        }

        .impact-low {
            background: #e8f5e8;
            color: #00bfa5;
        }

        @media (max-width: 768px) {
            .alert-value {
                font-size: 1.6rem;
            }

            .alert-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>

    <div class="alerts-page">
        <div class="container-fluid">
            <!-- Alert Notification Panel -->
            <asp:Panel ID="pnlAlert" runat="server" CssClass="alert alert-dismissible fade show" Visible="false" role="alert">
                <asp:Label ID="lblAlertMessage" runat="server" Text=""></asp:Label>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </asp:Panel>

            <!-- Page Header -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="page-header">
                        <h1 class="h2 mb-2"><i class="fas fa-exclamation-triangle text-warning me-3"></i>Budget Alerts & Monitoring</h1>
                        <p class="text-muted">Real-time financial risk detection and budget oversight with detailed analysis</p>
                    </div>
                </div>
            </div>

            <!-- Alert Summary Cards -->
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="alert-summary-card critical">
                        <div class="alert-icon">
                            <i class="fas fa-fire"></i>
                        </div>
                        <div class="alert-label">Critical Alerts</div>
                        <div class="alert-value">
                            <asp:Label ID="lblCriticalCount" runat="server" Text="0"></asp:Label>
                        </div>
                        <small class="text-muted">Urgent Attention Required</small>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="alert-summary-card warning">
                        <div class="alert-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <div class="alert-label">Warning Alerts</div>
                        <div class="alert-value">
                            <asp:Label ID="lblWarningCount" runat="server" Text="0"></asp:Label>
                        </div>
                        <small class="text-muted">Monitor Closely</small>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="alert-summary-card info">
                        <div class="alert-icon">
                            <i class="fas fa-info-circle"></i>
                        </div>
                        <div class="alert-label">Info Alerts</div>
                        <div class="alert-value">
                            <asp:Label ID="lblInfoCount" runat="server" Text="0"></asp:Label>
                        </div>
                        <small class="text-muted">For Your Information</small>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="alert-summary-card total">
                        <div class="alert-icon">
                            <i class="fas fa-bell"></i>
                        </div>
                        <div class="alert-label">Total Alerts</div>
                        <div class="alert-value">
                            <asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label>
                        </div>
                        <small class="text-muted">Active Alerts</small>
                    </div>
                </div>
            </div>

            <!-- Alert Filters -->
            <div class="filter-container">
                <h3 class="section-title"><i class="fas fa-filter me-2"></i>Filter Alerts</h3>
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group-enhanced">
                            <label class="form-label-enhanced">Alert Type</label>
                            <asp:DropDownList ID="ddlAlertType" runat="server" CssClass="form-select-enhanced" AutoPostBack="true" OnSelectedIndexChanged="FilterAlerts">
                                <asp:ListItem Value="">All Types</asp:ListItem>
                                <asp:ListItem Value="Critical">Critical</asp:ListItem>
                                <asp:ListItem Value="Warning">Warning</asp:ListItem>
                                <asp:ListItem Value="Info">Info</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group-enhanced">
                            <label class="form-label-enhanced">Status</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select-enhanced" AutoPostBack="true" OnSelectedIndexChanged="FilterAlerts">
                                <asp:ListItem Value="Active">Active</asp:ListItem>
                                <asp:ListItem Value="Dismissed">Dismissed</asp:ListItem>
                                <asp:ListItem Value="">All Status</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group-enhanced">
                            <label class="form-label-enhanced">Date Range</label>
                            <asp:DropDownList ID="ddlDateRange" runat="server" CssClass="form-select-enhanced" AutoPostBack="true" OnSelectedIndexChanged="FilterAlerts">
                                <asp:ListItem Value="7">Last 7 Days</asp:ListItem>
                                <asp:ListItem Value="30" Selected="True">Last 30 Days</asp:ListItem>
                                <asp:ListItem Value="90">Last 90 Days</asp:ListItem>
                                <asp:ListItem Value="365">Last Year</asp:ListItem>
                                <asp:ListItem Value="0">All Time</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group-enhanced">
                            <label class="form-label-enhanced">Actions</label>
                            <div class="d-flex gap-2">
                                <asp:Button ID="btnRunChecks" runat="server" Text="Run Checks"
                                    CssClass="btn btn-gold flex-fill" OnClick="BtnRunChecks_Click" />
                                <asp:Button ID="btnDismissAll" runat="server" Text="Dismiss All"
                                    CssClass="btn btn-outline-gold flex-fill" OnClick="BtnDismissAll_Click"
                                    OnClientClick="return confirm('Are you sure you want to dismiss all active alerts?');" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Statistics -->
            <div class="alerts-container">
                <h3 class="section-title"><i class="fas fa-chart-bar me-2"></i>Alert Statistics</h3>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-label">Budget Overruns</div>
                        <div class="stat-value">
                            <asp:Label ID="lblBudgetOverruns" runat="server" Text="0"></asp:Label>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Categories at Risk</div>
                        <div class="stat-value">
                            <asp:Label ID="lblCategoriesAtRisk" runat="server" Text="0"></asp:Label>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Avg. Exceed %</div>
                        <div class="stat-value">
                            <asp:Label ID="lblAvgExceedPercent" runat="server" Text="0%"></asp:Label>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Total Overrun Amount</div>
                        <div class="stat-value">
                            <asp:Label ID="lblTotalOverrun" runat="server" Text="₹0"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Alerts List -->
            <div class="alerts-container">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="section-title mb-0"><i class="fas fa-list me-2"></i>Budget Alerts</h3>
                    <span class="badge badge-warning">
                        <asp:Label ID="lblActiveAlertsCount" runat="server" Text="0"></asp:Label>
                        Active Alerts
                    </span>
                </div>

                <!-- Critical Alerts -->
                <asp:Panel ID="pnlCriticalAlerts" runat="server" Visible="false">
                    <h5 class="alert-critical mb-3">
                        <i class="fas fa-fire me-2"></i>Critical Priority
                        <span class="badge badge-critical ms-2">
                            <asp:Label ID="lblCriticalBadgeCount" runat="server" Text="0"></asp:Label>
                        </span>
                    </h5>
                    <asp:Repeater ID="rptCriticalAlerts" runat="server" OnItemCommand="RptAlert_ItemCommand">
                        <ItemTemplate>
                            <div class="alert-item critical">
                                <div class="alert-header">
                                    <div>
                                        <span class="alert-type critical">
                                            <span class="priority-indicator priority-critical"></span>
                                            CRITICAL
                                        </span>
                                        <span class="alert-date ms-2">
                                            <i class="fas fa-clock me-1"></i>
                                            <%# FormatDate(Eval("CreatedDate")) %>
                                        </span>
                                    </div>
                                </div>
                                <div class="alert-message">
                                    <strong><%# Eval("Category") %>:</strong> <%# Eval("AlertMessage") %>
                                </div>
                                
                                <!-- Financial Impact Analysis -->
                                <div class="financial-analysis">
                                    <div class="analysis-title">
                                        <i class="fas fa-chart-line me-2"></i>Financial Impact Analysis
                                        <span class="impact-level impact-high">HIGH IMPACT</span>
                                    </div>
                                    <div class="analysis-content">
                                        <strong>Immediate Action Required:</strong> This alert indicates severe budget deviation that requires immediate corrective measures. 
                                        The overrun of ₹<%# FormatAmount(Eval("ExceededBy")) %> represents a significant financial risk to the institution's operational stability.
                                    </div>
                                </div>

                                <div class="alert-details">
                                    <div class="alert-detail-item">
                                        <span class="alert-detail-label">Budget Amount:</span>
                                        <span class="alert-detail-value">₹ <%# FormatAmount(Eval("BudgetAmount")) %></span>
                                    </div>
                                    <div class="alert-detail-item">
                                        <span class="alert-detail-label">Exceeded By:</span>
                                        <span class="alert-detail-value alert-critical">₹ <%# FormatAmount(Eval("ExceededBy")) %></span>
                                    </div>
                                    <div class="alert-detail-item">
                                        <span class="alert-detail-label">Overrun Percentage:</span>
                                        <span class="alert-detail-value alert-critical"><%# GetOverrunPercentage(Eval("ExceededBy"), Eval("BudgetAmount")) %>%</span>
                                    </div>
                                    <div class="alert-detail-item">
                                        <span class="alert-detail-label">Risk Level:</span>
                                        <span class="alert-detail-value alert-critical">SEVERE</span>
                                    </div>
                                </div>

                                <div class="risk-meter">
                                    <div class='<%# GetRiskLevelClass(Eval("ExceededBy"), Eval("BudgetAmount")) %>' style='width: <%# GetRiskWidth(Eval("ExceededBy"), Eval("BudgetAmount")) %>%;'></div>
                                </div>

                                <div class="alert-actions">
                                    <asp:LinkButton ID="btnDismiss" runat="server" CommandName="Dismiss" CommandArgument='<%# Eval("AlertId") %>'
                                        CssClass="btn-action btn-dismiss" Text="Dismiss"
                                        OnClientClick="return confirm('Are you sure you want to dismiss this critical alert?');" />
                                    <asp:LinkButton ID="btnViewDetails" runat="server" CommandName="ViewDetails" CommandArgument='<%# Eval("AlertId") %>'
                                        CssClass="btn-action btn-view" Text="View Details" />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>

                <!-- Warning Alerts -->
                <asp:Panel ID="pnlWarningAlerts" runat="server" Visible="false">
                    <h5 class="alert-warning mb-3 mt-4">
                        <i class="fas fa-exclamation-triangle me-2"></i>Warning Priority
                        <span class="badge badge-warning ms-2">
                            <asp:Label ID="lblWarningBadgeCount" runat="server" Text="0"></asp:Label>
                        </span>
                    </h5>
                    <asp:Repeater ID="rptWarningAlerts" runat="server" OnItemCommand="RptAlert_ItemCommand">
                        <ItemTemplate>
                            <div class="alert-item warning">
                                <div class="alert-header">
                                    <div>
                                        <span class="alert-type warning">
                                            <span class="priority-indicator priority-warning"></span>
                                            WARNING
                                        </span>
                                        <span class="alert-date ms-2">
                                            <i class="fas fa-clock me-1"></i>
                                            <%# FormatDate(Eval("CreatedDate")) %>
                                        </span>
                                    </div>
                                </div>
                                <div class="alert-message">
                                    <strong><%# Eval("Category") %>:</strong> <%# Eval("AlertMessage") %>
                                </div>

                                <!-- Financial Impact Analysis -->
                                <div class="financial-analysis">
                                    <div class="analysis-title">
                                        <i class="fas fa-chart-line me-2"></i>Financial Impact Analysis
                                        <span class="impact-level impact-medium">MEDIUM IMPACT</span>
                                    </div>
                                    <div class="analysis-content">
                                        <strong>Monitoring Required:</strong> This alert indicates budget deviation that requires close monitoring. 
                                        The overrun of ₹<%# FormatAmount(Eval("ExceededBy")) %> should be addressed promptly to prevent escalation to critical levels.
                                    </div>
                                </div>

                                <div class="alert-details">
                                    <div class="alert-detail-item">
                                        <span class="alert-detail-label">Budget Amount:</span>
                                        <span class="alert-detail-value">₹ <%# FormatAmount(Eval("BudgetAmount")) %></span>
                                    </div>
                                    <div class="alert-detail-item">
                                        <span class="alert-detail-label">Exceeded By:</span>
                                        <span class="alert-detail-value alert-warning">₹ <%# FormatAmount(Eval("ExceededBy")) %></span>
                                    </div>
                                    <div class="alert-detail-item">
                                        <span class="alert-detail-label">Overrun Percentage:</span>
                                        <span class="alert-detail-value alert-warning"><%# GetOverrunPercentage(Eval("ExceededBy"), Eval("BudgetAmount")) %>%</span>
                                    </div>
                                    <div class="alert-detail-item">
                                        <span class="alert-detail-label">Risk Level:</span>
                                        <span class="alert-detail-value alert-warning">ELEVATED</span>
                                    </div>
                                </div>

                                <div class="risk-meter">
                                    <div class='<%# GetRiskLevelClass(Eval("ExceededBy"), Eval("BudgetAmount")) %>' style='width: <%# GetRiskWidth(Eval("ExceededBy"), Eval("BudgetAmount")) %>%;'></div>
                                </div>

                                <div class="alert-actions">
                                    <asp:LinkButton ID="btnDismissWarning" runat="server" CommandName="Dismiss" CommandArgument='<%# Eval("AlertId") %>'
                                        CssClass="btn-action btn-dismiss" Text="Dismiss" />
                                    <asp:LinkButton ID="btnViewDetailsWarning" runat="server" CommandName="ViewDetails" CommandArgument='<%# Eval("AlertId") %>'
                                        CssClass="btn-action btn-view" Text="View Details" />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>

                <!-- Info Alerts -->
                <asp:Panel ID="pnlInfoAlerts" runat="server" Visible="false">
                    <h5 class="alert-info mb-3 mt-4">
                        <i class="fas fa-info-circle me-2"></i>Information
                        <span class="badge badge-info ms-2">
                            <asp:Label ID="lblInfoBadgeCount" runat="server" Text="0"></asp:Label>
                        </span>
                    </h5>
                    <asp:Repeater ID="rptInfoAlerts" runat="server" OnItemCommand="RptAlert_ItemCommand">
                        <ItemTemplate>
                            <div class="alert-item info">
                                <div class="alert-header">
                                    <div>
                                        <span class="alert-type info">
                                            <span class="priority-indicator priority-info"></span>
                                            INFO
                                        </span>
                                        <span class="alert-date ms-2">
                                            <i class="fas fa-clock me-1"></i>
                                            <%# FormatDate(Eval("CreatedDate")) %>
                                        </span>
                                    </div>
                                </div>
                                <div class="alert-message">
                                    <strong><%# Eval("Category") %>:</strong> <%# Eval("AlertMessage") %>
                                </div>

                                <!-- Financial Impact Analysis -->
                                <div class="financial-analysis">
                                    <div class="analysis-title">
                                        <i class="fas fa-chart-line me-2"></i>Financial Impact Analysis
                                        <span class="impact-level impact-low">LOW IMPACT</span>
                                    </div>
                                    <div class="analysis-content">
                                        <strong>Informational Notice:</strong> This alert provides important budget information for awareness. 
                                        No immediate action required, but this information may be useful for future budget planning and trend analysis.
                                    </div>
                                </div>

                                <div class="alert-actions">
                                    <asp:LinkButton ID="btnDismissInfo" runat="server" CommandName="Dismiss" CommandArgument='<%# Eval("AlertId") %>'
                                        CssClass="btn-action btn-dismiss" Text="Dismiss" />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>

                <!-- Empty State -->
                <asp:Panel ID="pnlNoAlerts" runat="server" Visible="false" CssClass="empty-state">
                    <i class="fas fa-check-circle text-success" style="font-size: 4rem; margin-bottom: 20px;"></i>
                    <h4 style="color: #333; margin-bottom: 10px;">No Active Alerts</h4>
                    <p style="font-size: 1rem; margin-bottom: 25px;">All budget categories are within their allocated limits. Great job!</p>
                    <asp:Button ID="btnCheckNow" runat="server" Text="Run Budget Check"
                        CssClass="btn btn-gold mt-3" OnClick="BtnRunChecks_Click" />
                </asp:Panel>
            </div>

            <!-- Dismissed Alerts Section -->
            <asp:Panel ID="pnlDismissedAlerts" runat="server" Visible="false" CssClass="alerts-container">
                <h3 class="section-title"><i class="fas fa-history me-2"></i>Recently Dismissed Alerts</h3>
                <asp:Repeater ID="rptDismissedAlerts" runat="server">
                    <ItemTemplate>
                        <div class="alert-item" style="opacity: 0.7; border-left-color: #999;">
                            <div class="alert-header">
                                <div>
                                    <span class="alert-type" style="background: #999;">
                                        <%# Eval("AlertType") %>
                                    </span>
                                    <span class="alert-date ms-2">
                                        <i class="fas fa-clock me-1"></i>
                                        <%# FormatDate(Eval("CreatedDate")) %>
                                    </span>
                                </div>
                            </div>
                            <div class="alert-message">
                                <strong><%# Eval("Category") %>:</strong> <%# Eval("AlertMessage") %>
                            </div>
                            <div class="alert-details">
                                <div class="alert-detail-item">
                                    <span class="alert-detail-label">Budget Amount:</span>
                                    <span class="alert-detail-value">₹ <%# FormatAmount(Eval("BudgetAmount")) %></span>
                                </div>
                                <div class="alert-detail-item">
                                    <span class="alert-detail-label">Exceeded By:</span>
                                    <span class="alert-detail-value">₹ <%# FormatAmount(Eval("ExceededBy")) %></span>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

    <script type="text/javascript">
        function confirmDismissAll() {
            return confirm('Are you sure you want to dismiss all active alerts? This action cannot be undone.');
        }

        function confirmCriticalDismiss() {
            return confirm('This is a CRITICAL alert. Are you absolutely sure you want to dismiss it?');
        }

        document.addEventListener('DOMContentLoaded', function () {
            // Auto-hide alerts after 7 seconds
            setTimeout(function () {
                var alerts = document.querySelectorAll('.alert');
                alerts.forEach(function (alert) {
                    var bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 7000);
        });
    </script>
</asp:Content>