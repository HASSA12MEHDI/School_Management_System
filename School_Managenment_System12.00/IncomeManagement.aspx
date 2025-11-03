<%@ Page Title="Income Management" Language="C#" MasterPageFile="~/Site2.Master" AutoEventWireup="true" CodeBehind="IncomeManagement.aspx.cs" Inherits="SchoolFinancialManagementSystem.Income" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* Modern Green & Blue Theme */
        :root {
            --primary: #2E8B57;
            --primary-light: #3CB371;
            --primary-dark: #228B22;
            --secondary: #1E90FF;
            --secondary-light: #6495ED;
            --secondary-dark: #0066CC;
            --accent: #00CED1;
            --success: #32CD32;
            --warning: #FFA500;
            --danger: #FF4500;
            --light: #F8F9FA;
            --dark: #2C3E50;
            --text: #5A6C7D;
        }

        .income-container {
            background: linear-gradient(135deg, #f5f7fa 0%, #e3f2fd 100%);
            min-height: calc(100vh - 200px);
            padding: 20px 0;
        }

        /* Modern Cards */
        .modern-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(46, 139, 87, 0.12);
            border: none;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            overflow: hidden;
            margin-bottom: 20px;
        }

        .modern-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 40px rgba(46, 139, 87, 0.2);
        }

        /* Compact Statistics Row */
        .compact-stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 25px;
        }

        .stat-card-modern {
            background: white;
            border-radius: 14px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 6px 20px rgba(30, 144, 255, 0.1);
            transition: all 0.3s ease;
            border-left: 4px solid var(--primary);
            position: relative;
            overflow: hidden;
        }

        .stat-card-modern::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(46, 139, 87, 0.05), rgba(30, 144, 255, 0.05));
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .stat-card-modern:hover::before {
            opacity: 1;
        }

        .stat-card-modern:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(30, 144, 255, 0.15);
        }

        .stat-card-modern:nth-child(2) {
            border-left-color: var(--secondary);
        }

        .stat-card-modern:nth-child(3) {
            border-left-color: var(--accent);
        }

        .stat-card-modern:nth-child(4) {
            border-left-color: var(--success);
        }

        .stat-icon-modern {
            font-size: 1.8rem;
            margin-bottom: 12px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            color: transparent;
        }

        .stat-card-modern:nth-child(2) .stat-icon-modern {
            background: linear-gradient(135deg, var(--secondary), var(--accent));
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            color: transparent;
        }

        .stat-card-modern:nth-child(3) .stat-icon-modern {
            background: linear-gradient(135deg, var(--accent), var(--primary-light));
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            color: transparent;
        }

        .stat-card-modern:nth-child(4) .stat-icon-modern {
            background: linear-gradient(135deg, var(--success), var(--primary));
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            color: transparent;
        }

        .stat-value-modern {
            font-size: 1.6rem;
            font-weight: 800;
            color: var(--dark);
            margin: 8px 0;
            line-height: 1.2;
        }

        .stat-label-modern {
            font-size: 0.8rem;
            color: var(--text);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }

        .stat-trend-modern {
            font-size: 0.75rem;
            color: var(--success);
            margin-top: 6px;
            font-weight: 600;
        }

        /* Card Headers */
        .card-header-modern {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border-radius: 16px 16px 0 0;
            padding: 20px 25px;
            border: none;
            position: relative;
            overflow: hidden;
        }

        .card-header-modern::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
            transform: rotate(45deg);
            animation: shimmer 3s infinite linear;
        }

        @keyframes shimmer {
            0% { transform: rotate(45deg) translateX(-100%); }
            100% { transform: rotate(45deg) translateX(100%); }
        }

        .card-header-modern h5 {
            margin: 0;
            font-weight: 700;
            font-size: 1.3rem;
            position: relative;
            z-index: 1;
        }

        .card-body-modern {
            padding: 25px;
        }

        /* Form Styles */
        .form-group-modern {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-label-modern {
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 8px;
            font-size: 14px;
            display: block;
        }

        .form-control-modern {
            border: 2px solid #E3F2FD;
            border-radius: 12px;
            padding: 14px 16px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: #FAFDFF;
            width: 100%;
            font-weight: 500;
        }

        .form-control-modern:focus {
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 4px rgba(46, 139, 87, 0.1);
            outline: none;
            transform: translateY(-2px);
        }

        /* Buttons */
        .btn-modern-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            border-radius: 12px;
            padding: 14px 30px;
            font-weight: 700;
            color: white;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(46, 139, 87, 0.3);
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .btn-modern-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }

        .btn-modern-primary:hover::before {
            left: 100%;
        }

        .btn-modern-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(46, 139, 87, 0.4);
            color: white;
        }

        .btn-modern-secondary {
            background: transparent;
            border: 2px solid var(--primary);
            border-radius: 12px;
            padding: 14px 30px;
            font-weight: 700;
            color: var(--primary);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-modern-secondary:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(46, 139, 87, 0.2);
        }

        /* Table Styles */
        .table-modern {
            background: white;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 6px 25px rgba(30, 144, 255, 0.1);
            margin-bottom: 0;
            border: none;
        }

        .table-modern thead {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .table-modern thead th {
            border: none;
            padding: 15px 10px;
            font-weight: 700;
            font-size: 12px;
            vertical-align: middle;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }

        .table-modern tbody td {
            padding: 12px 10px;
            border-color: #F0F8FF;
            vertical-align: middle;
            color: var(--text);
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 13px;
        }

        .table-modern tbody tr {
            transition: all 0.3s ease;
        }

        .table-modern tbody tr:hover {
            background-color: #F0F8FF;
            transform: scale(1.01);
        }

        /* Search and Filters */
        .search-container-modern {
            position: relative;
            max-width: 280px;
        }

        .search-container-modern .form-control-modern {
            padding-left: 45px;
            border-radius: 25px;
            border: 2px solid #E3F2FD;
        }

        .search-icon-modern {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--primary);
            z-index: 5;
        }

        .filter-container-modern {
            margin-right: 12px;
        }

        .filter-select-modern {
            border-radius: 25px;
            border: 2px solid #E3F2FD;
            padding: 10px 18px;
            min-width: 160px;
            background: #FAFDFF;
            font-weight: 500;
            font-size: 13px;
        }

        .filter-select-modern:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(46, 139, 87, 0.1);
        }

        /* Action Buttons */
        .action-buttons-modern {
            display: flex;
            gap: 6px;
        }

        .btn-action-modern {
            padding: 8px 12px;
            border-radius: 10px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .btn-edit-modern {
            background: linear-gradient(135deg, var(--secondary), var(--accent));
            color: white;
        }

        .btn-delete-modern {
            background: linear-gradient(135deg, var(--danger), #FF6347);
            color: white;
        }

        .btn-action-modern:hover {
            transform: scale(1.1) rotate(5deg);
            color: white;
            box-shadow: 0 6px 18px rgba(0,0,0,0.15);
        }

        /* Compact Category Badges */
        .category-badge-modern {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            display: inline-block;
            min-width: 60px;
            text-align: center;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .badge-fees {
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            color: white;
        }

        .badge-government {
            background: linear-gradient(135deg, var(--secondary), var(--secondary-light));
            color: white;
        }

        .badge-donations {
            background: linear-gradient(135deg, var(--accent), #20B2AA);
            color: white;
        }

        .badge-other {
            background: linear-gradient(135deg, #9370DB, #BA55D3);
            color: white;
        }

        /* Page Header */
        .page-header-modern {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 3px solid #E3F2FD;
        }

        .page-title-modern {
            color: var(--dark);
            font-weight: 800;
            font-size: 2.2rem;
            position: relative;
            display: inline-block;
        }

        .page-title-modern::after {
            content: '';
            position: absolute;
            bottom: -12px;
            left: 0;
            width: 70px;
            height: 5px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 3px;
        }

        /* Alert Styles */
        .alert-modern {
            border-radius: 14px;
            border: none;
            padding: 18px 25px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 25px;
            backdrop-filter: blur(10px);
        }

        .alert-success {
            background: linear-gradient(135deg, var(--success), #28a745);
            color: white;
        }

        .alert-danger {
            background: linear-gradient(135deg, var(--danger), #dc3545);
            color: white;
        }

        .alert-warning {
            background: linear-gradient(135deg, var(--warning), #ffc107);
            color: white;
        }

        /* Pagination */
        .pagination-modern {
            display: flex;
            padding-left: 0;
            list-style: none;
            border-radius: 12px;
            justify-content: center;
            margin-top: 25px;
        }

        .pagination-modern li {
            margin: 0 4px;
        }

        .pagination-modern li a {
            position: relative;
            display: block;
            padding: 10px 16px;
            line-height: 1.25;
            color: var(--primary);
            background-color: white;
            border: 2px solid #E3F2FD;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 700;
            font-size: 13px;
            transition: all 0.3s ease;
        }

        .pagination-modern li.active a {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border-color: var(--primary);
            box-shadow: 0 4px 15px rgba(46, 139, 87, 0.3);
        }

        .pagination-modern li a:hover {
            color: white;
            background: var(--primary);
            border-color: var(--primary);
            transform: translateY(-2px);
        }

        /* Amount Styling */
        .amount-positive {
            color: var(--primary);
            font-weight: 800;
            font-size: 1.1em;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .compact-stats-row {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .compact-stats-row {
                grid-template-columns: 1fr;
                gap: 12px;
            }
            
            .card-body-modern {
                padding: 20px;
            }
            
            .table-modern {
                font-size: 12px;
            }
            
            .search-container-modern {
                max-width: 100%;
                margin-top: 10px;
            }
            
            .filter-container-modern {
                margin-right: 0;
                margin-bottom: 10px;
            }
            
            .page-title-modern {
                font-size: 1.8rem;
            }
            
            .action-buttons-modern {
                flex-direction: column;
            }
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-in-up {
            animation: fadeInUp 0.8s ease-out;
        }
    </style>

    <div class="income-container">
        <div class="container-fluid">
            <!-- Alert Panel -->
            <asp:Panel ID="pnlAlert" runat="server" CssClass="alert alert-modern alert-dismissible fade show" Visible="false" role="alert">
                <asp:Label ID="lblAlertMessage" runat="server" Text=""></asp:Label>
                <button type="button" class="close text-white" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </asp:Panel>

            <!-- Page Header -->
            <div class="page-header-modern">
                <h1 class="page-title-modern">
                    <i class="fas fa-money-bill-wave mr-3"></i>Income Management
                </h1>
                <div class="text-right">
                    <small class="text-muted d-block">Track and manage all school income sources</small>
                    <small class="text-primary"><asp:Label ID="lblLastUpdate" runat="server" Text="Updated just now"></asp:Label></small>
                </div>
            </div>

            <!-- Compact Statistics Row -->
            <div class="compact-stats-row fade-in-up">
                <div class="stat-card-modern">
                    <i class="fas fa-chart-line stat-icon-modern"></i>
                    <div class="stat-value-modern amount-positive">
                        <asp:Label ID="LblTotalIncome" runat="server" Text="Rs0.00"></asp:Label>
                    </div>
                    <div class="stat-label-modern">Total Income</div>
                    <div class="stat-trend-modern">
                        <i class="fas fa-arrow-up mr-1"></i>10.5% growth
                    </div>
                </div>
                <div class="stat-card-modern">
                    <i class="fas fa-calendar-alt stat-icon-modern"></i>
                    <div class="stat-value-modern amount-positive">
                        <asp:Label ID="LblMonthlyIncome" runat="server" Text="Rs0.00"></asp:Label>
                    </div>
                    <div class="stat-label-modern">This Month</div>
                    <div class="stat-trend-modern">
                        <i class="fas fa-arrow-up mr-1"></i>5.2% growth
                    </div>
                </div>
                <div class="stat-card-modern">
                    <i class="fas fa-receipt stat-icon-modern"></i>
                    <div class="stat-value-modern">
                        <asp:Label ID="LblTransactionCount" runat="server" Text="0"></asp:Label>
                    </div>
                    <div class="stat-label-modern">Transactions</div>
                    <div class="stat-trend-modern">
                        <i class="fas fa-arrow-up mr-1"></i>3.1% growth
                    </div>
                </div>
                <div class="stat-card-modern">
                    <i class="fas fa-chart-bar stat-icon-modern"></i>
                    <div class="stat-value-modern amount-positive">
                        <asp:Label ID="LblAvgIncome" runat="server" Text="Rs0.00"></asp:Label>
                    </div>
                    <div class="stat-label-modern">Average Income</div>
                    <div class="stat-trend-modern">
                        <i class="fas fa-arrow-up mr-1"></i>2.4% growth
                    </div>
                </div>
            </div>

            <div class="row">
                <!-- Income Entry Form -->
                <div class="col-lg-5">
                    <div class="modern-card">
                        <div class="card-header-modern">
                            <h5><i class="fas fa-plus-circle mr-2"></i>Add New Income Record</h5>
                        </div>
                        <div class="card-body-modern">
                            <asp:HiddenField ID="hfIncomeId" runat="server" />
                            
                            <div class="form-group-modern">
                                <label class="form-label-modern">Income Type *</label>
                                <asp:DropDownList ID="DdlIncomeType" runat="server" CssClass="form-control-modern" required>
                                    <asp:ListItem Value="">Select Income Type</asp:ListItem>
                                    <asp:ListItem Value="Tuition Fees">Tuition Fees</asp:ListItem>
                                    <asp:ListItem Value="Admission Fees">Admission Fees</asp:ListItem>
                                    <asp:ListItem Value="Exam Fees">Exam Fees</asp:ListItem>
                                    <asp:ListItem Value="Transport Fees">Transport Fees</asp:ListItem>
                                    <asp:ListItem Value="Book Sales">Book Sales</asp:ListItem>
                                    <asp:ListItem Value="Donations">Donations</asp:ListItem>
                                    <asp:ListItem Value="Grants">Grants</asp:ListItem>
                                    <asp:ListItem Value="Other">Other</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="form-group-modern">
                                <label class="form-label-modern">Amount (Rs) *</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text bg-light border-right-0">Rs</span>
                                    </div>
                                    <asp:TextBox ID="TxtAmount" runat="server" CssClass="form-control-modern border-left-0" 
                                        TextMode="Number" step="0.01" placeholder="0.00" required></asp:TextBox>
                                </div>
                            </div>

                            <div class="form-group-modern">
                                <label class="form-label-modern">Income Date *</label>
                                <asp:TextBox ID="TxtIncomeDate" runat="server" CssClass="form-control-modern" 
                                    TextMode="Date" required></asp:TextBox>
                            </div>

                            <div class="form-group-modern">
                                <label class="form-label-modern">Category *</label>
                                <asp:DropDownList ID="DdlCategory" runat="server" CssClass="form-control-modern" required>
                                    <asp:ListItem Value="">Select Category</asp:ListItem>
                                    <asp:ListItem Value="Student Fees">Student Fees</asp:ListItem>
                                    <asp:ListItem Value="Government Funds">Government Funds</asp:ListItem>
                                    <asp:ListItem Value="Donations">Donations</asp:ListItem>
                                    <asp:ListItem Value="Other Income">Other Income</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="form-group-modern">
                                <label class="form-label-modern">Received From</label>
                                <asp:TextBox ID="TxtReceivedFrom" runat="server" CssClass="form-control-modern" 
                                    placeholder="Student Name, Organization, etc."></asp:TextBox>
                            </div>

                            <div class="form-group-modern">
                                <label class="form-label-modern">Payment Mode *</label>
                                <asp:DropDownList ID="DdlPaymentMode" runat="server" CssClass="form-control-modern" required>
                                    <asp:ListItem Value="">Select Payment Mode</asp:ListItem>
                                    <asp:ListItem Value="Cash">Cash</asp:ListItem>
                                    <asp:ListItem Value="Bank Transfer">Bank Transfer</asp:ListItem>
                                    <asp:ListItem Value="Credit Card">Credit Card</asp:ListItem>
                                    <asp:ListItem Value="Check">Check</asp:ListItem>
                                    <asp:ListItem Value="Online Payment">Online Payment</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="form-group-modern">
                                <label class="form-label-modern">Description</label>
                                <asp:TextBox ID="TxtDescription" runat="server" CssClass="form-control-modern" 
                                    TextMode="MultiLine" Rows="3" placeholder="Additional details about this income..."></asp:TextBox>
                            </div>

                            <div class="form-group-modern pt-2">
                                <asp:Button ID="BtnAddIncome" runat="server" Text="Add Income" 
                                    CssClass="btn-modern-primary btn-block" OnClick="BtnAddIncome_Click" />
                                <asp:Button ID="BtnClear" runat="server" Text="Clear Form" 
                                    CssClass="btn-modern-secondary btn-block mt-2" OnClick="BtnClear_Click" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Income Records -->
                <div class="col-lg-7">
                    <div class="modern-card">
                        <div class="card-header-modern d-flex justify-content-between align-items-center flex-wrap">
                            <h5 class="mb-0"><i class="fas fa-list mr-2"></i>Income Records</h5>
                            <div class="d-flex align-items-center flex-wrap mt-2 mt-md-0">
                                <div class="filter-container-modern">
                                    <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="form-control-modern filter-select-modern">
                                        <asp:ListItem Value="">All Categories</asp:ListItem>
                                        <asp:ListItem Value="Student Fees">Student Fees</asp:ListItem>
                                        <asp:ListItem Value="Government Funds">Government Funds</asp:ListItem>
                                        <asp:ListItem Value="Donations">Donations</asp:ListItem>
                                        <asp:ListItem Value="Other Income">Other Income</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="filter-container-modern">
                                    <asp:DropDownList ID="ddlPaymentFilter" runat="server" CssClass="form-control-modern filter-select-modern">
                                        <asp:ListItem Value="">All Payments</asp:ListItem>
                                        <asp:ListItem Value="Cash">Cash</asp:ListItem>
                                        <asp:ListItem Value="Bank Transfer">Bank Transfer</asp:ListItem>
                                        <asp:ListItem Value="Credit Card">Credit Card</asp:ListItem>
                                        <asp:ListItem Value="Check">Check</asp:ListItem>
                                        <asp:ListItem Value="Online Payment">Online Payment</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="search-container-modern">
                                    <i class="fas fa-search search-icon-modern"></i>
                                    <asp:TextBox ID="TxtSearch" runat="server" CssClass="form-control-modern" 
                                        placeholder="Search income..."></asp:TextBox>
                                </div>
                                <asp:Button ID="BtnExport" runat="server" Text="Export" 
                                    CssClass="btn-modern-primary ml-2" OnClick="BtnExport_Click" />
                            </div>
                        </div>
                        <div class="card-body-modern">
                            <div class="table-responsive">
                                <asp:GridView ID="GvIncome" runat="server" AutoGenerateColumns="False" 
                                    CssClass="table table-modern" 
                                    DataKeyNames="IncomeId" OnRowCommand="GvIncome_RowCommand"
                                    AllowPaging="True" PageSize="8" OnPageIndexChanging="GvIncome_PageIndexChanging"
                                    EmptyDataText="No income records found. Add your first income record above!">
                                    <Columns>
                                        <asp:BoundField DataField="IncomeId" HeaderText="ID">
                                            <ItemStyle Width="50px" Font-Bold="true" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="IncomeType" HeaderText="Type">
                                            <ItemStyle Font-Bold="true" Width="110px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Amount" HeaderText="Amount" 
                                            DataFormatString="Rs{0:N2}">
                                            <ItemStyle Width="85px" Font-Bold="true" CssClass="amount-positive" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="IncomeDate" HeaderText="Date" 
                                            DataFormatString="{0:MM/dd/yyyy}">
                                            <ItemStyle Width="80px" />
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Category">
                                            <ItemTemplate>
                                                <span class='category-badge-modern badge-<%# GetCategoryClass(Eval("Category").ToString()) %>'
                                                      title='<%# Eval("Category") %>'>
                                                    <%# Eval("Category") %>
                                                </span>
                                            </ItemTemplate>
                                            <ItemStyle Width="70px" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ReceivedFrom" HeaderText="From">
                                            <ItemStyle Width="90px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="PaymentMode" HeaderText="Payment">
                                            <ItemStyle Width="80px" />
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Actions">
                                            <ItemTemplate>
                                                <div class="action-buttons-modern">
                                                    <asp:LinkButton ID="BtnEdit" runat="server" CommandName="EditRecord" 
                                                        CommandArgument='<%# Eval("IncomeId") %>' CssClass="btn-action-modern btn-edit-modern" ToolTip="Edit">
                                                        <i class="fas fa-edit"></i>
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="BtnDelete" runat="server" CommandName="DeleteRecord" 
                                                        CommandArgument='<%# Eval("IncomeId") %>' CssClass="btn-action-modern btn-delete-modern" ToolTip="Delete" 
                                                        OnClientClick="return confirm('Are you sure you want to delete this income record?');">
                                                        <i class="fas fa-trash"></i>
                                                    </asp:LinkButton>
                                                </div>
                                            </ItemTemplate>
                                            <ItemStyle Width="65px" />
                                        </asp:TemplateField>
                                    </Columns>
                                    <PagerStyle CssClass="pagination-modern" />
                                    <PagerSettings Mode="NumericFirstLast" />
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Set default date to today
        document.addEventListener('DOMContentLoaded', function () {
            var today = new Date().toISOString().split('T')[0];
            var dateField = document.getElementById('<%= TxtIncomeDate.ClientID %>');
            if (dateField && !dateField.value) {
                dateField.value = today;
            }

            // Add animation to stats cards on scroll
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('fade-in-up');
                    }
                });
            });

            document.querySelectorAll('.stat-card-modern').forEach((el) => {
                observer.observe(el);
            });
        });
    </script>
</asp:Content>