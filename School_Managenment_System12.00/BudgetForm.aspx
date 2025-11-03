<%@ Page Title="Budget Management" Language="C#" MasterPageFile="~/Site2.Master" AutoEventWireup="true" CodeBehind="BudgetForm.aspx.cs" Inherits="SchoolFinancialManagementSystem.BudgetForm" %>

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

        .budget-container {
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

        /* Statistics Cards */
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
            height: 100%;
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

        .stat-card-modern.warning {
            border-left-color: var(--warning);
        }

        .stat-card-modern.danger {
            border-left-color: var(--danger);
        }

        .stat-card-modern.info {
            border-left-color: var(--secondary);
        }

        .stat-icon-modern {
            font-size: 1.8rem;
            margin-bottom: 12px;
            color: var(--primary);
        }

        .stat-card-modern.warning .stat-icon-modern {
            color: var(--warning);
        }

        .stat-card-modern.info .stat-icon-modern {
            color: var(--secondary);
        }

        .stat-card-modern.danger .stat-icon-modern {
            color: var(--danger);
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

        .stat-subtext-modern {
            font-size: 0.75rem;
            color: var(--text);
            margin-top: 6px;
            font-weight: 500;
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

        .btn-modern-warning {
            background: linear-gradient(135deg, var(--warning), #fd7e14);
            border: none;
            border-radius: 12px;
            padding: 14px 30px;
            font-weight: 700;
            color: white;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(255, 165, 0, 0.3);
            cursor: pointer;
        }

        .btn-modern-warning:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(255, 165, 0, 0.4);
            color: white;
        }

        .btn-modern-danger {
            background: linear-gradient(135deg, var(--danger), #c82333);
            border: none;
            border-radius: 12px;
            padding: 14px 30px;
            font-weight: 700;
            color: white;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(220, 53, 69, 0.3);
            cursor: pointer;
        }

        .btn-modern-danger:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(220, 53, 69, 0.4);
            color: white;
        }

        .btn-modern-info {
            background: linear-gradient(135deg, var(--secondary), var(--accent));
            border: none;
            border-radius: 12px;
            padding: 14px 30px;
            font-weight: 700;
            color: white;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(30, 144, 255, 0.3);
            cursor: pointer;
        }

        .btn-modern-info:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(30, 144, 255, 0.4);
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

        /* Budget Categories */
        .budget-categories-modern {
            background: linear-gradient(135deg, #f8f9fa 0%, #e3f2fd 100%);
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 25px;
            border: 2px solid #E3F2FD;
        }

        .category-badge-modern {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            margin: 5px;
            display: inline-block;
            box-shadow: 0 3px 10px rgba(46, 139, 87, 0.2);
            transition: all 0.3s ease;
        }

        .category-badge-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(46, 139, 87, 0.3);
        }

        /* Teacher Section */
        .teacher-section-modern {
            background: linear-gradient(135deg, #e8f5e8 0%, #e3f2fd 100%);
            border-radius: 12px;
            padding: 20px;
            margin-top: 20px;
            border-left: 4px solid var(--primary);
            border: 2px solid #E3F2FD;
        }

        /* Validation Styles */
        .validation-error-modern {
            color: var(--danger);
            font-size: 12px;
            margin-top: 8px;
            display: block;
            font-weight: 600;
        }

        /* Checkbox Styles */
        .checkbox-modern {
            display: flex;
            align-items: center;
            margin-top: 10px;
        }

        .checkbox-label-modern {
            font-size: 14px;
            font-weight: 700;
            color: var(--dark);
            margin-left: 10px;
            cursor: pointer;
        }

        .form-check-input-modern {
            width: 18px;
            height: 18px;
            border: 2px solid #E3F2FD;
            border-radius: 4px;
            cursor: pointer;
        }

        .form-check-input-modern:checked {
            background-color: var(--primary);
            border-color: var(--primary);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .page-header-modern {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .page-title-modern {
                font-size: 1.8rem;
                margin-bottom: 15px;
            }
            
            .card-body-modern {
                padding: 20px;
            }
            
            .stat-value-modern {
                font-size: 1.4rem;
            }
            
            .btn-modern-primary,
            .btn-modern-secondary,
            .btn-modern-warning,
            .btn-modern-danger,
            .btn-modern-info {
                padding: 12px 20px;
                font-size: 13px;
            }
        }

        @media (max-width: 576px) {
            .budget-container {
                padding: 15px 0;
            }
            
            .page-title-modern {
                font-size: 1.6rem;
            }
            
            .stat-card-modern {
                padding: 15px;
            }
            
            .stat-value-modern {
                font-size: 1.3rem;
            }
            
            .budget-categories-modern {
                padding: 20px;
            }
            
            .category-badge-modern {
                padding: 6px 12px;
                font-size: 11px;
                margin: 3px;
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

    <div class="budget-container">
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
                <div>
                    <h1 class="page-title-modern">
                        <i class="fas fa-wallet me-3"></i>Budget Management
                    </h1>
                    <p class="text-muted mb-0">Create and manage school budgets efficiently</p>
                </div>
                <asp:Button ID="BtnViewBudgets" runat="server" CausesValidation="false" Text="📋 View All Budgets" 
                    CssClass="btn-modern-info" OnClick="BtnViewBudgets_Click" />
            </div>

            <!-- Budget Statistics -->
            <div class="row mb-4 fade-in-up">
                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="stat-card-modern">
                        <i class="fas fa-money-bill-wave stat-icon-modern"></i>
                        <div class="stat-value-modern amount-positive">
                            <asp:Label ID="LblTotalBudget" runat="server" Text="Rs9,420,003.70"></asp:Label>
                        </div>
                        <div class="stat-label-modern">Total Budget</div>
                        <div class="stat-subtext-modern">Current fiscal year</div>
                    </div>
                </div>
                
                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="stat-card-modern warning">
                        <i class="fas fa-calendar-alt stat-icon-modern"></i>
                        <div class="stat-value-modern">
                            <asp:Label ID="LblMonthlyBudget" runat="server" Text="Rs7,400,000.85"></asp:Label>
                        </div>
                        <div class="stat-label-modern">This Month</div>
                        <div class="stat-subtext-modern">Current month allocation</div>
                    </div>
                </div>
                
                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="stat-card-modern info">
                        <i class="fas fa-chart-line stat-icon-modern"></i>
                        <div class="stat-value-modern">
                            <asp:Label ID="LblActiveBudgets" runat="server" Text="52"></asp:Label>
                        </div>
                        <div class="stat-label-modern">Active Budgets</div>
                        <div class="stat-subtext-modern">Currently active</div>
                    </div>
                </div>
                
                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="stat-card-modern danger">
                        <i class="fas fa-users stat-icon-modern"></i>
                        <div class="stat-value-modern">
                            <asp:Label ID="LblSalaryBudget" runat="server" Text="Rs2,235,005.75"></asp:Label>
                        </div>
                        <div class="stat-label-modern">Salary Budget</div>
                        <div class="stat-subtext-modern">Teacher salaries</div>
                    </div>
                </div>
            </div>

            <!-- Budget Categories -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="budget-categories-modern">
                        <h5 class="mb-3" style="color: var(--primary); font-weight: 700;">
                            <i class="fas fa-tags me-2"></i>Budget Categories
                        </h5>
                        <div>
                            <span class="category-badge-modern">Academic Expenses</span>
                            <span class="category-badge-modern">Infrastructure</span>
                            <span class="category-badge-modern">Staff Salaries</span>
                            <span class="category-badge-modern">Utilities</span>
                            <span class="category-badge-modern">Sports & Activities</span>
                            <span class="category-badge-modern">Maintenance</span>
                            <span class="category-badge-modern">Administrative</span>
                            <span class="category-badge-modern">Library</span>
                            <span class="category-badge-modern">Laboratory</span>
                            <span class="category-badge-modern">Transportation</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Budget Entry Form -->
            <div class="row">
                <div class="col-12">
                    <div class="modern-card">
                        <div class="card-header-modern">
                            <h5 class="mb-0">
                                <i class="fas fa-plus-circle me-2"></i>
                                <asp:Label ID="LblFormTitle" runat="server" Text="Create New Budget"></asp:Label>
                            </h5>
                        </div>
                        <div class="card-body-modern">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="form-group-modern">
                                        <label class="form-label-modern">Budget Category *</label>
                                        <asp:DropDownList ID="DdlCategory" runat="server" CssClass="form-control-modern">
                                            <asp:ListItem Value="">Select Category</asp:ListItem>
                                            <asp:ListItem Value="Academic Expenses">Academic Expenses</asp:ListItem>
                                            <asp:ListItem Value="Infrastructure">Infrastructure</asp:ListItem>
                                            <asp:ListItem Value="Staff Salaries">Staff Salaries</asp:ListItem>
                                            <asp:ListItem Value="Utilities">Utilities</asp:ListItem>
                                            <asp:ListItem Value="Sports & Activities">Sports & Activities</asp:ListItem>
                                            <asp:ListItem Value="Maintenance">Maintenance</asp:ListItem>
                                            <asp:ListItem Value="Administrative">Administrative</asp:ListItem>
                                            <asp:ListItem Value="Library">Library</asp:ListItem>
                                            <asp:ListItem Value="Laboratory">Laboratory</asp:ListItem>
                                            <asp:ListItem Value="Transportation">Transportation</asp:ListItem>
                                            <asp:ListItem Value="Other">Other</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="ReqCategory" runat="server" 
                                            ControlToValidate="DdlCategory" InitialValue=""
                                            ErrorMessage="Please select budget category" 
                                            CssClass="validation-error-modern" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="form-group-modern">
                                        <label class="form-label-modern">Budget Amount (Rs) *</label>
                                        <asp:TextBox ID="TxtBudgetAmount" runat="server" CssClass="form-control-modern" 
                                            TextMode="Number" step="0.01" placeholder="0.00"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="ReqBudgetAmount" runat="server" 
                                            ControlToValidate="TxtBudgetAmount"
                                            ErrorMessage="Please enter budget amount" 
                                            CssClass="validation-error-modern" Display="Dynamic"></asp:RequiredFieldValidator>
                                        <asp:CompareValidator ID="CmpBudgetAmount" runat="server" 
                                            ControlToValidate="TxtBudgetAmount" Operator="GreaterThan" ValueToCompare="0"
                                            Type="Double" ErrorMessage="Budget amount must be greater than 0" 
                                            CssClass="validation-error-modern" Display="Dynamic"></asp:CompareValidator>
                                    </div>
                                </div>
                                
                                <div class="col-md-4">
                                    <div class="form-group-modern">
                                        <label class="form-label-modern">Month *</label>
                                        <asp:DropDownList ID="DdlMonth" runat="server" CssClass="form-control-modern">
                                            <asp:ListItem Value="">Select Month</asp:ListItem>
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
                                        <asp:RequiredFieldValidator ID="ReqMonth" runat="server" 
                                            ControlToValidate="DdlMonth" InitialValue=""
                                            ErrorMessage="Please select month" 
                                            CssClass="validation-error-modern" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                
                                <div class="col-md-4">
                                    <div class="form-group-modern">
                                        <label class="form-label-modern">Year *</label>
                                        <asp:TextBox ID="TxtYear" runat="server" CssClass="form-control-modern" 
                                            TextMode="Number" placeholder="2024" MaxLength="4"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="ReqYear" runat="server" 
                                            ControlToValidate="TxtYear"
                                            ErrorMessage="Please enter year" 
                                            CssClass="validation-error-modern" Display="Dynamic"></asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="RngYear" runat="server" 
                                            ControlToValidate="TxtYear" MinimumValue="2020" MaximumValue="2030"
                                            Type="Integer" ErrorMessage="Year must be between 2020-2030" 
                                            CssClass="validation-error-modern" Display="Dynamic"></asp:RangeValidator>
                                    </div>
                                </div>
                                
                                <div class="col-md-4">
                                    <div class="form-group-modern">
                                        <label class="form-label-modern">Budget Type</label>
                                        <div class="checkbox-modern">
                                            <asp:CheckBox ID="ChkIsSalaryBudget" runat="server" 
                                                CssClass="form-check-input-modern" AutoPostBack="true" 
                                                OnCheckedChanged="ChkIsSalaryBudget_CheckedChanged" />
                                            <label class="checkbox-label-modern" for="ChkIsSalaryBudget">
                                                Salary Budget
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Teacher Selection (Visible only when Salary Budget is checked) -->
                                <asp:Panel ID="PnlTeacherSelection" runat="server" Visible="false" CssClass="col-12">
                                    <div class="teacher-section-modern">
                                        <h6 class="mb-3" style="color: var(--primary); font-weight: 600;">
                                            <i class="fas fa-chalkboard-teacher me-2"></i>Teacher Information
                                        </h6>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group-modern">
                                                    <label class="form-label-modern">Select Teacher *</label>
                                                    <asp:DropDownList ID="DdlTeacher" runat="server" CssClass="form-control-modern">
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="ReqTeacher" runat="server" 
                                                        ControlToValidate="DdlTeacher" InitialValue=""
                                                        ErrorMessage="Please select teacher" 
                                                        CssClass="validation-error-modern" Display="Dynamic"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>
                                
                                <div class="col-12">
                                    <div class="form-group-modern">
                                        <label class="form-label-modern">Description *</label>
                                        <asp:TextBox ID="TxtDescription" runat="server" CssClass="form-control-modern" 
                                            TextMode="MultiLine" Rows="3" placeholder="Enter budget description..."></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="ReqDescription" runat="server" 
                                            ControlToValidate="TxtDescription"
                                            ErrorMessage="Please enter description" 
                                            CssClass="validation-error-modern" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                
                                <div class="col-12">
                                    <div class="d-flex gap-2 flex-wrap">
                                        <asp:Button ID="BtnSaveBudget" runat="server" Text="💾 Save Budget" 
                                            CssClass="btn-modern-primary" OnClick="BtnSaveBudget_Click" />
                                        <asp:Button ID="BtnClearForm" runat="server" Text="🗑️ Clear Form" 
                                            CssClass="btn-modern-secondary" OnClick="BtnClearForm_Click" />
                                        <asp:Button ID="BtnCancel" runat="server" Text="❌ Cancel" 
                                            CssClass="btn-modern-danger" Visible="false" OnClick="BtnCancel_Click" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Set default year to current year
        document.addEventListener('DOMContentLoaded', function () {
            var currentYear = new Date().getFullYear();
            var yearField = document.getElementById('<%= TxtYear.ClientID %>');
            if (yearField && !yearField.value) {
                yearField.value = currentYear;
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