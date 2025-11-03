<%@ Page Title="View Budgets" Language="C#" MasterPageFile="~/Site2.Master" AutoEventWireup="true" CodeBehind="ViewBudgets.aspx.cs" Inherits="SchoolFinancialManagementSystem.ViewBudgets" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* Modern color scheme and base styles */
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --success-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --warning-gradient: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            --accent-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            --info-gradient: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            --dark-gradient: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            --light-bg: #f8f9fa;
            --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            --hover-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
            --text-dark: #2c3e50;
            --text-light: #6c757d;
        }

        .budgets-container {
            width: 100%;
            max-width: 100%;
            overflow-x: hidden;
            background: linear-gradient(135deg, #f5f7fa 0%, #e4edf5 100%);
            padding: 20px;
            margin: 0;
            min-height: 100vh;
        }

        * {
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container-fluid {
            padding-left: 0;
            padding-right: 0;
            margin-left: 0;
            margin-right: 0;
        }

        .row {
            margin-left: 0;
            margin-right: 0;
        }

        .col-12, .col-md-3, .col-md-2, .col-md-1, .col-sm-6 {
            padding-left: 10px;
            padding-right: 10px;
        }

        /* Enhanced Page Title - FIXED VISIBILITY */
        .page-title {
            font-size: 1.8rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            color: #2c3e50;
            line-height: 1.2;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            background: none !important;
            -webkit-background-clip: initial !important;
            -webkit-text-fill-color: initial !important;
        }

        .page-subtitle {
            font-size: 0.9rem;
            line-height: 1.4;
            color: var(--text-light);
            max-width: 600px;
        }

        /* Enhanced Card Header */
        .card-header {
            background: var(--dark-gradient);
            color: white;
            border-radius: 12px 12px 0 0;
            font-weight: 600;
            border: none;
            padding: 15px 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .card-header h5 {
            font-size: 1.1rem;
            margin-bottom: 0;
            line-height: 1.2;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            display: flex;
            align-items: center;
        }

        /* Enhanced Buttons */
        .btn {
            font-size: 0.85rem;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            border: none;
            transition: all 0.3s ease;
            white-space: nowrap;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-success {
            background: var(--success-gradient);
            color: white;
        }

        .btn-info {
            background: var(--info-gradient);
            color: var(--text-dark);
        }

        .btn-outline-warning {
            border: 1px solid #ff9a3d;
            color: #ff9a3d;
            background: transparent;
        }

        .btn-outline-danger {
            border: 1px solid #ff6b6b;
            color: #ff6b6b;
            background: transparent;
        }

        .btn-outline-success {
            border: 1px solid #1dd1a1;
            color: #1dd1a1;
            background: transparent;
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: var(--hover-shadow);
        }

        /* Enhanced Badges */
        .badge-salary, .badge-regular, .badge-inactive {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
            white-space: nowrap;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .badge-salary {
            background: var(--accent-gradient);
            color: white;
        }

        .badge-regular {
            background: var(--success-gradient);
            color: white;
        }

        .badge-inactive {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
        }

        /* Enhanced Table Styles */
        .table-container {
            width: 100%;
            overflow-x: auto;
            border-radius: 0 0 12px 12px;
            box-shadow: var(--card-shadow);
        }

        .table {
            width: 100%;
            min-width: 900px;
            margin-bottom: 0;
            font-size: 0.85rem;
            border-collapse: separate;
            border-spacing: 0;
        }

        .table th {
            background: var(--dark-gradient) !important;
            color: white;
            border: none;
            padding: 12px 10px;
            font-weight: 600;
            white-space: nowrap;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .table td {
            vertical-align: middle;
            padding: 12px 10px;
            border-bottom: 1px solid #e9ecef;
            line-height: 1.3;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 180px;
            background: white;
            transition: all 0.2s ease;
        }

        .table-hover tbody tr:hover td {
            background: #f1f9ff;
            transform: scale(1.01);
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .amount-positive {
            color: #1dd1a1;
            font-weight: 700;
            font-size: 0.9rem;
        }

        /* Enhanced Search and Filter Styles */
        .search-box {
            position: relative;
            width: 100%;
        }

        .search-box .form-control {
            padding-left: 40px;
            padding-right: 40px;
            border-radius: 10px;
            border: 1px solid #e0e6ed;
            font-size: 0.8rem;
            height: 38px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }

        .search-box .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #667eea;
            z-index: 5;
            font-size: 0.8rem;
        }

        .filters-section {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 1.5rem;
            border: none;
            box-shadow: var(--card-shadow);
        }

        .filter-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            white-space: nowrap;
            line-height: 1.2;
        }

        .form-select, .form-control {
            font-size: 0.8rem;
            border-radius: 8px;
            height: 38px;
            padding: 0.4rem 0.75rem;
            border: 1px solid #e0e6ed;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }

        .form-select:focus, .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .card {
            border: none;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
            width: 100%;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: var(--hover-shadow);
        }

        .pagination {
            margin-bottom: 0;
            font-size: 0.85rem;
        }

        .btn-group-sm > .btn {
            padding: 0.3rem 0.6rem;
            font-size: 0.75rem;
        }

        /* Enhanced Stats Cards */
        .stats-card {
            background: white;
            border-radius: 12px;
            padding: 20px 15px;
            box-shadow: var(--card-shadow);
            border-top: 4px solid;
            margin-bottom: 15px;
            height: 100%;
            min-height: 100px;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 100%);
            z-index: 1;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--hover-shadow);
        }

        .stats-card:nth-child(1) {
            border-top-color: #667eea;
        }

        .stats-card:nth-child(2) {
            border-top-color: #1dd1a1;
        }

        .stats-card:nth-child(3) {
            border-top-color: #ff9a3d;
        }

        .stats-card:nth-child(4) {
            border-top-color: #ff6b6b;
        }

        .stats-value {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-dark);
            line-height: 1.2;
            word-break: break-word;
            margin-bottom: 5px;
            position: relative;
            z-index: 2;
        }

        .stats-label {
            font-size: 0.75rem;
            color: var(--text-light);
            line-height: 1.2;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            font-weight: 600;
            position: relative;
            z-index: 2;
        }

        /* Text truncation for table cells */
        .text-truncate {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 150px;
        }

        /* Enhanced Export button */
        .export-btn {
            height: 38px;
            white-space: nowrap;
            font-size: 0.8rem;
            width: 100%;
            background: var(--secondary-gradient);
            color: white;
            font-weight: 700;
        }

        /* Enhanced Filter grid layout */
        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 15px;
            align-items: end;
        }

        /* Action buttons in table */
        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .action-btn {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        /* Export Status Message */
        .export-status {
            margin-top: 10px;
            padding: 10px;
            border-radius: 5px;
            font-size: 0.8rem;
            display: none;
        }

        .export-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .export-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Mobile responsiveness */
        @media (max-width: 768px) {
            .budgets-container {
                padding: 15px;
            }
            
            .page-title {
                font-size: 1.5rem;
            }
            
            .btn {
                padding: 0.45rem 0.9rem;
                font-size: 0.8rem;
            }
            
            .filters-grid {
                grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
                gap: 12px;
            }
            
            .stats-value {
                font-size: 1.3rem;
            }
            
            .stats-label {
                font-size: 0.7rem;
            }
            
            .table {
                min-width: 800px;
                font-size: 0.8rem;
            }
            
            .stats-card {
                padding: 15px 12px;
                min-height: 90px;
            }
        }

        @media (max-width: 576px) {
            .budgets-container {
                padding: 10px;
            }
            
            .page-title {
                font-size: 1.3rem;
            }
            
            .filters-section {
                padding: 15px;
            }
            
            .table td, .table th {
                padding: 10px 8px;
                font-size: 0.75rem;
            }
            
            .stats-card {
                padding: 12px 10px;
                min-height: 85px;
            }
            
            .stats-value {
                font-size: 1.1rem;
            }
            
            .filters-grid {
                grid-template-columns: 1fr;
            }
            
            .table {
                min-width: 700px;
            }
        }

        /* Extra small devices */
        @media (max-width: 400px) {
            .page-title {
                font-size: 1.1rem;
            }
            
            .btn {
                padding: 0.4rem 0.8rem;
                font-size: 0.75rem;
            }
            
            .table td, .table th {
                padding: 8px 6px;
                font-size: 0.7rem;
            }
            
            .stats-value {
                font-size: 1rem;
            }
            
            .filters-grid {
                gap: 10px;
            }
        }

        /* Ensure no horizontal scroll on body */
        body {
            overflow-x: hidden;
            background: #f5f7fa;
        }

        /* Animation for page load */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .budgets-container > .row {
            animation: fadeInUp 0.5s ease-out;
        }

        /* Custom scrollbar */
        .table-container::-webkit-scrollbar {
            height: 8px;
        }

        .table-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        .table-container::-webkit-scrollbar-thumb {
            background: var(--primary-gradient);
            border-radius: 10px;
        }

        .table-container::-webkit-scrollbar-thumb:hover {
            background: var(--secondary-gradient);
        }

        /* Fix for ASP.NET button rendering */
        .btn input[type="submit"], .btn input[type="button"] {
            background: none;
            border: none;
            color: inherit;
            font: inherit;
            cursor: pointer;
            width: 100%;
            height: 100%;
            padding: 0;
            margin: 0;
        }

        /* Additional fix for page header visibility */
        .page-header-row {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 1.5rem;
            box-shadow: var(--card-shadow);
            border-left: 4px solid #667eea;
        }
    </style>

    <div class="container-fluid budgets-container">
        <!-- Page Header - FIXED VISIBILITY -->
        <div class="row mb-4 page-header-row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center flex-wrap">
                    <div class="flex-grow-1 me-2" style="min-width: 0;">
                        <h2 class="page-title">
                            <i class="fas fa-chart-pie me-2"></i>Budget Management
                        </h2>
                        <p class="text-muted mb-0 page-subtitle">Monitor, analyze, and manage all school budgets in one centralized dashboard</p>
                    </div>
                    <asp:Button ID="BtnCreateNew" runat="server" Text="➕ Create New Budget" 
                        CssClass="btn btn-success flex-shrink-0 mt-2 mt-sm-0" OnClick="BtnCreateNew_Click" 
                        OnClientClick="return handleCreateBudgetClick(this);" />
                </div>
            </div>
        </div>

        <!-- Summary Stats -->
        <div class="row mb-4">
            <div class="col-md-3 col-sm-6">
                <div class="stats-card">
                    <div class="stats-value">
                        <asp:Label ID="LblTotalBudgets" runat="server" Text="52"></asp:Label>
                    </div>
                    <div class="stats-label">Total Budgets</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stats-card">
                    <div class="stats-value">
                        <asp:Label ID="LblActiveBudgets" runat="server" Text="42"></asp:Label>
                    </div>
                    <div class="stats-label">Active Budgets</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stats-card">
                    <div class="stats-value">
                        <asp:Label ID="LblSalaryBudgets" runat="server" Text="18"></asp:Label>
                    </div>
                    <div class="stats-label">Salary Budgets</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stats-card">
                    <div class="stats-value">
                        <asp:Label ID="LblTotalAmount" runat="server" Text="Rs9,420,003.70"></asp:Label>
                    </div>
                    <div class="stats-label">Total Amount</div>
                </div>
            </div>
        </div>

        <!-- Filters Section -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="filters-section">
                    <div class="filters-grid">
                        <div>
                            <div class="filter-label">Search Budgets</div>
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <asp:TextBox ID="TxtSearch" runat="server" CssClass="form-control form-control-sm" 
                                    placeholder="Search by category, description..." AutoPostBack="true" 
                                    OnTextChanged="TxtSearch_TextChanged"></asp:TextBox>
                            </div>
                        </div>
                        <div>
                            <div class="filter-label">Year</div>
                            <asp:DropDownList ID="DdlYearFilter" runat="server" CssClass="form-select form-select-sm" 
                                AutoPostBack="true" OnSelectedIndexChanged="DdlYearFilter_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div>
                            <div class="filter-label">Month</div>
                            <asp:DropDownList ID="DdlMonthFilter" runat="server" CssClass="form-select form-select-sm" 
                                AutoPostBack="true" OnSelectedIndexChanged="DdlMonthFilter_SelectedIndexChanged">
                                <asp:ListItem Value="">All Months</asp:ListItem>
                                <asp:ListItem Value="1">January</asp:ListItem>
                                <asp:ListItem Value="2">February</asp:ListItem>
                                <asp:ListItem Value="3">March</asp:ListItem>
                                <asp:ListItem Value="4">April</asp:ListItem>
                                <asp:ListItem Value="5">May</asp:ListItem>
                                <asp:ListItem Value="6">June</asp:ListItem>
                                <asp:ListItem Value="7">July</asp:ListItem>
                                <asp:ListItem Value="8">August</asp:ListItem>
                                <asp:ListItem Value="9">September</asp:ListItem>
                                <asp:ListItem Value="10">October</asp:ListItem>
                                <asp:ListItem Value="11">November</asp:ListItem>
                                <asp:ListItem Value="12">December</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div>
                            <div class="filter-label">Budget Type</div>
                            <asp:DropDownList ID="DdlTypeFilter" runat="server" CssClass="form-select form-select-sm" 
                                AutoPostBack="true" OnSelectedIndexChanged="DdlTypeFilter_SelectedIndexChanged">
                                <asp:ListItem Value="">All Types</asp:ListItem>
                                <asp:ListItem Value="Salary">Salary</asp:ListItem>
                                <asp:ListItem Value="Regular">Regular</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div>
                            <div class="filter-label">Status</div>
                            <asp:DropDownList ID="DdlStatusFilter" runat="server" CssClass="form-select form-select-sm" 
                                AutoPostBack="true" OnSelectedIndexChanged="DdlStatusFilter_SelectedIndexChanged">
                                <asp:ListItem Value="">All Status</asp:ListItem>
                                <asp:ListItem Value="Active">Active</asp:ListItem>
                                <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                     
                    </div>
                    <!-- Export Status Message -->
                    <div id="exportStatus" class="export-status" runat="server"></div>
                </div>
            </div>
        </div>

        <!-- Budgets Grid -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-table me-2"></i>Budget Records
                            <asp:Label ID="LblRecordCount" runat="server" CssClass="badge bg-light text-dark ms-2" style="font-size: 0.7rem;"></asp:Label>
                        </h5>
                        <div>
                            <asp:Label ID="LblGridTotalAmount" runat="server" CssClass="text-white fw-bold" style="font-size: 0.85rem;"></asp:Label>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-container">
                            <asp:GridView ID="GvBudgets" runat="server" AutoGenerateColumns="False" 
                                CssClass="table table-hover table-striped mb-0"
                                EmptyDataText="No budget records found." 
                                DataKeyNames="BudgetId" AllowPaging="True" PageSize="15" 
                                OnPageIndexChanging="GvBudgets_PageIndexChanging"
                                OnRowCommand="GvBudgets_RowCommand"
                                OnRowDataBound="GvBudgets_RowDataBound">
                                <Columns>
                                    <asp:BoundField DataField="BudgetId" HeaderText="ID" ItemStyle-Width="60px" />
                                    <asp:BoundField DataField="Category" HeaderText="Category" ItemStyle-CssClass="text-truncate" />
                                    <asp:BoundField DataField="BudgetAmount" HeaderText="Amount" DataFormatString="Rs{0:N2}" 
                                        ItemStyle-CssClass="amount-positive" />
                                    <asp:TemplateField HeaderText="Period">
                                        <ItemTemplate>
                                            <%# GetMonthName(Eval("Month").ToString()) %> <%# Eval("Year") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Description" HeaderText="Description" 
                                        ItemStyle-CssClass="text-truncate" />
                                    <asp:TemplateField HeaderText="Type">
                                        <ItemTemplate>
                                            <span class='<%# Convert.ToBoolean(Eval("IsSalaryBudget")) ? "badge-salary" : "badge-regular" %>'>
                                                <%# Convert.ToBoolean(Eval("IsSalaryBudget")) ? "Salary" : "Regular" %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Teacher" ItemStyle-CssClass="text-truncate">
                                        <ItemTemplate>
                                            <%# GetTeacherName(Eval("TeacherId")) %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge-regular" : "badge-inactive" %>'>
                                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="CreatedDate" HeaderText="Created" DataFormatString="{0:MMM dd, yyyy}" />
                                    <asp:TemplateField HeaderText="Actions" ItemStyle-Width="140px">
                                        <ItemTemplate>
                                            <div class="action-buttons">
                                                <asp:LinkButton ID="BtnEdit" runat="server" CommandName="EditBudget" 
                                                    CommandArgument='<%# Eval("BudgetId") %>' CssClass="btn btn-outline-warning action-btn"
                                                    ToolTip="Edit Budget">
                                                    <i class="fas fa-edit"></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="BtnToggle" runat="server" CommandName="ToggleStatus" 
                                                    CommandArgument='<%# Eval("BudgetId") %>' CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "btn btn-outline-danger action-btn" : "btn btn-outline-success action-btn" %>'
                                                    ToolTip='<%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate" : "Activate" %>'
                                                    OnClientClick='<%# Convert.ToBoolean(Eval("IsActive")) ? "return confirm(\"Are you sure you want to deactivate this budget?\")" : "return confirm(\"Are you sure you want to activate this budget?\")" %>'>
                                                    <i class='<%# Convert.ToBoolean(Eval("IsActive")) ? "fas fa-times" : "fas fa-check" %>'></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="BtnDelete" runat="server" CommandName="DeleteBudget" 
                                                    CommandArgument='<%# Eval("BudgetId") %>' CssClass="btn btn-outline-danger action-btn"
                                                    ToolTip="Delete Budget" 
                                                    OnClientClick="return confirm('Are you sure you want to permanently delete this budget?');">
                                                    <i class="fas fa-trash"></i>
                                                </asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <PagerStyle CssClass="pagination justify-content-center mt-3" />
                                <HeaderStyle CssClass="table-primary" />
                                <EmptyDataRowStyle CssClass="text-center p-4" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Enhanced JavaScript for interactive elements
        document.addEventListener('DOMContentLoaded', function() {
            // Ensure body doesn't have horizontal scroll
            document.body.style.overflowX = 'hidden';
            
            // Reset any container margins/padding that might cause overflow
            var containers = document.querySelectorAll('.container-fluid, .budgets-container');
            containers.forEach(function(container) {
                container.style.maxWidth = '100%';
                container.style.overflowX = 'hidden';
            });

            // Add search box clear button
            var searchBox = document.getElementById('<%= TxtSearch.ClientID %>');
            if (searchBox) {
                var clearButton = document.createElement('span');
                clearButton.innerHTML = '<i class="fas fa-times"></i>';
                clearButton.style.position = 'absolute';
                clearButton.style.right = '12px';
                clearButton.style.top = '50%';
                clearButton.style.transform = 'translateY(-50%)';
                clearButton.style.cursor = 'pointer';
                clearButton.style.color = '#6c757d';
                clearButton.style.display = searchBox.value ? 'block' : 'none';
                clearButton.style.fontSize = '0.8rem';
                clearButton.style.zIndex = '10';
                clearButton.style.transition = 'color 0.3s ease';
                
                clearButton.addEventListener('mouseenter', function() {
                    this.style.color = '#e74c3c';
                });
                
                clearButton.addEventListener('mouseleave', function() {
                    this.style.color = '#6c757d';
                });
                
                clearButton.addEventListener('click', function() {
                    searchBox.value = '';
                    clearButton.style.display = 'none';
                    // Trigger the search change event to refresh results
                    if (typeof __doPostBack == 'function') {
                        __doPostBack('<%= TxtSearch.UniqueID %>', '');
                    }
                });

                searchBox.parentNode.style.position = 'relative';
                searchBox.parentNode.appendChild(clearButton);

                searchBox.addEventListener('input', function () {
                    clearButton.style.display = this.value ? 'block' : 'none';
                });
            }

            // Add animation to stats cards on scroll
            function animateOnScroll() {
                var statsCards = document.querySelectorAll('.stats-card');
                statsCards.forEach(function (card, index) {
                    var cardPosition = card.getBoundingClientRect().top;
                    var screenPosition = window.innerHeight / 1.2;

                    if (cardPosition < screenPosition) {
                        card.style.animationDelay = (index * 0.1) + 's';
                        card.style.animation = 'fadeInUp 0.5s ease-out forwards';
                    }
                });
            }

            window.addEventListener('scroll', animateOnScroll);
            animateOnScroll(); // Run once on page load
        });

        // Additional check on window resize
        window.addEventListener('resize', function () {
            document.body.style.overflowX = 'hidden';
        });

        // Custom button click handlers that don't interfere with postback
        function handleCreateBudgetClick(button) {
            // Simply allow the natural postback to occur
            // The server-side event handler will handle the redirect
            console.log('Create Budget button clicked');
            return true; // Allow postback
        }

        function handleExportClick(button) {
            // Show loading state but don't prevent the postback
            var originalText = button.innerHTML;
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Exporting...';
            button.disabled = true;

            // Re-enable after 5 seconds in case of error
            setTimeout(function () {
                button.innerHTML = originalText;
                button.disabled = false;
            }, 5000);

            console.log('Export button clicked');
            return true; // Allow postback
        }

        // Add ripple effect to buttons (excluding form buttons)
        document.addEventListener('click', function (e) {
            var btn = e.target.classList.contains('btn') ? e.target : e.target.closest('.btn');
            if (btn && !btn.id.includes('BtnCreateNew') && !btn.id.includes('BtnExport')) {
                var ripple = document.createElement('span');
                var d = Math.max(btn.offsetWidth, btn.offsetHeight);
                var style = ripple.style;

                style.width = style.height = d + 'px';
                var rect = btn.getBoundingClientRect();
                style.left = (e.clientX - rect.left - d / 2) + 'px';
                style.top = (e.clientY - rect.top - d / 2) + 'px';
                style.position = 'absolute';
                style.borderRadius = '50%';
                style.background = 'rgba(255, 255, 255, 0.7)';
                style.animation = 'ripple 0.6s linear';
                style.transform = 'scale(0)';

                btn.style.position = 'relative';
                btn.style.overflow = 'hidden';
                btn.appendChild(ripple);

                setTimeout(function () {
                    ripple.remove();
                }, 600);
            }
        });

        // Add ripple animation to CSS
        var style = document.createElement('style');
        style.textContent = '@keyframes ripple { to { transform: scale(4); opacity: 0; } }';
        document.head.appendChild(style);
    </script>
</asp:Content>