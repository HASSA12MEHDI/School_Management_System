<%@ Page Title="Expenses Management" Language="C#" MasterPageFile="~/Site2.Master" AutoEventWireup="true" CodeBehind="Expenses.aspx.cs" Inherits="School_Managenment_System12._00.Expenses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* Modern Compact Theme */
        :root {
            --primary: #667eea;
            --primary-dark: #5a6fd8;
            --secondary: #764ba2;
            --accent: #f093fb;
            --success: #4cd964;
            --warning: #ff9500;
            --danger: #ff3b30;
            --light: #f8f9fa;
            --dark: #2c3e50;
            --text: #5a6c7d;
        }

        .expenses-container {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: calc(100vh - 200px);
            padding: 20px 0;
        }

        /* Compact Stats Row */
        .compact-stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 25px;
        }

        .compact-stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border-left: 4px solid var(--primary);
            position: relative;
            overflow: hidden;
        }

        .compact-stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
        }

        .compact-stat-card:nth-child(2) {
            border-left-color: #ff6b6b;
        }

        .compact-stat-card:nth-child(3) {
            border-left-color: #4cd964;
        }

        .compact-stat-card:nth-child(4) {
            border-left-color: #ffa726;
        }

        .stat-icon-compact {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: var(--primary);
        }

        .compact-stat-card:nth-child(2) .stat-icon-compact {
            color: #ff6b6b;
        }

        .compact-stat-card:nth-child(3) .stat-icon-compact {
            color: #4cd964;
        }

        .compact-stat-card:nth-child(4) .stat-icon-compact {
            color: #ffa726;
        }

        .stat-value-compact {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--dark);
            margin: 5px 0;
            line-height: 1.2;
        }

        .stat-label-compact {
            font-size: 0.75rem;
            color: var(--text);
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .amount-negative {
            color: var(--danger);
            font-weight: bold;
        }

        /* Modern Cards */
        .modern-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            border: none;
            transition: all 0.3s ease;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .modern-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.15);
        }

        .card-header-modern {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border-radius: 16px 16px 0 0;
            padding: 20px 25px;
            border: none;
            position: relative;
        }

        .card-header-modern h5 {
            margin: 0;
            font-weight: 600;
            font-size: 1.2rem;
        }

        .card-body-modern {
            padding: 25px;
        }

        /* Form Styles */
        .form-group-compact {
            margin-bottom: 1.2rem;
            position: relative;
        }

        .form-label-compact {
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 6px;
            font-size: 13px;
            display: block;
        }

        .form-control-modern {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            width: 100%;
            font-weight: 500;
        }

        .form-control-modern:focus {
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            outline: none;
        }

        /* Buttons */
        .btn-modern-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            border-radius: 10px;
            padding: 12px 25px;
            font-weight: 600;
            color: white;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            cursor: pointer;
        }

        .btn-modern-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
            color: white;
        }

        .btn-modern-secondary {
            background: transparent;
            border: 2px solid var(--primary);
            border-radius: 10px;
            padding: 12px 25px;
            font-weight: 600;
            color: var(--primary);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-modern-secondary:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
        }

        /* Table Styles */
        .table-modern {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 0;
            border: none;
        }

        .table-modern thead {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .table-modern thead th {
            border: none;
            padding: 15px 12px;
            font-weight: 600;
            font-size: 13px;
            vertical-align: middle;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table-modern tbody td {
            padding: 12px;
            border-color: #f8f9fa;
            vertical-align: middle;
            color: var(--text);
            font-weight: 500;
            font-size: 13px;
        }

        .table-modern tbody tr {
            transition: all 0.3s ease;
        }

        .table-modern tbody tr:hover {
            background-color: #f8f9fa;
        }

        /* Search and Filters */
        .search-container-modern {
            position: relative;
            max-width: 250px;
        }

        .search-container-modern .form-control-modern {
            padding-left: 40px;
            border-radius: 20px;
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
            margin-right: 10px;
        }

        .filter-select-modern {
            border-radius: 20px;
            border: 2px solid #e9ecef;
            padding: 8px 15px;
            min-width: 140px;
            background: #f8f9fa;
            font-size: 13px;
            font-weight: 500;
        }

        /* Action Buttons */
        .action-buttons-modern {
            display: flex;
            gap: 5px;
        }

        .btn-action-modern {
            padding: 6px 10px;
            border-radius: 8px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 12px;
        }

        .btn-edit-modern {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }

        .btn-delete-modern {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }

        .btn-action-modern:hover {
            transform: scale(1.1);
            color: white;
        }

        /* Category Badges */
        .category-badge-modern {
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-salary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .badge-utilities {
            background: linear-gradient(135deg, #f093fb, #f5576c);
            color: white;
        }

        .badge-maintenance {
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            color: white;
        }

        .badge-supplies {
            background: linear-gradient(135deg, #43e97b, #38f9d7);
            color: white;
        }

        .badge-transportation {
            background: linear-gradient(135deg, #fa709a, #fee140);
            color: white;
        }

        .badge-events {
            background: linear-gradient(135deg, #a8edea, #fed6e3);
            color: #333;
        }

        .badge-other {
            background: linear-gradient(135deg, #d4fc79, #96e6a1);
            color: #333;
        }

        /* Page Header */
        .page-header-modern {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e9ecef;
        }

        .page-title-modern {
            color: var(--dark);
            font-weight: 700;
            font-size: 1.8rem;
            position: relative;
            display: inline-block;
        }

        .page-title-modern::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 50px;
            height: 3px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 2px;
        }

        /* Alert Styles */
        .alert-modern {
            border-radius: 12px;
            border: none;
            padding: 15px 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .alert-success {
            background: linear-gradient(135deg, #4cd964, #2ecc71);
            color: white;
        }

        .alert-danger {
            background: linear-gradient(135deg, #ff3b30, #e74c3c);
            color: white;
        }

        .alert-warning {
            background: linear-gradient(135deg, #ff9500, #f39c12);
            color: white;
        }

        /* Pagination */
        .pagination-modern {
            display: flex;
            padding-left: 0;
            list-style: none;
            border-radius: 10px;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination-modern li {
            margin: 0 3px;
        }

        .pagination-modern li a {
            position: relative;
            display: block;
            padding: 8px 14px;
            line-height: 1.25;
            color: var(--primary);
            background-color: white;
            border: 2px solid #e9ecef;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            transition: all 0.3s ease;
        }

        .pagination-modern li.active a {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border-color: var(--primary);
        }

        .pagination-modern li a:hover {
            color: white;
            background: var(--primary);
            border-color: var(--primary);
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
                gap: 10px;
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
                font-size: 1.5rem;
            }
            
            .action-buttons-modern {
                flex-direction: column;
            }
        }

        /* Animation */
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

        .fade-in-up {
            animation: fadeInUp 0.6s ease-out;
        }
    </style>

    <div class="expenses-container">
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
                    <i class="fas fa-receipt mr-2"></i>Expenses Management
                </h1>
                <div class="text-right">
                    <small class="text-muted d-block">Track and manage all school expenses</small>
                    <small class="text-primary"><asp:Label ID="lblLastUpdate" runat="server" Text="Updated just now"></asp:Label></small>
                </div>
            </div>

            <!-- Compact Statistics Row -->
            <div class="compact-stats-row fade-in-up">
                <div class="compact-stat-card">
                    <i class="fas fa-chart-line stat-icon-compact"></i>
                    <div class="stat-value-compact amount-negative">
                        <asp:Label ID="lblTotalExpenses" runat="server" Text="$0.00"></asp:Label>
                    </div>
                    <div class="stat-label-compact">Total Expenses</div>
                </div>
                <div class="compact-stat-card">
                    <i class="fas fa-calendar-alt stat-icon-compact"></i>
                    <div class="stat-value-compact amount-negative">
                        <asp:Label ID="lblThisMonth" runat="server" Text="$0.00"></asp:Label>
                    </div>
                    <div class="stat-label-compact">This Month</div>
                </div>
                <div class="compact-stat-card">
                    <i class="fas fa-clock stat-icon-compact"></i>
                    <div class="stat-value-compact amount-negative">
                        <asp:Label ID="lblToday" runat="server" Text="$0.00"></asp:Label>
                    </div>
                    <div class="stat-label-compact">Today</div>
                </div>
                <div class="compact-stat-card">
                    <i class="fas fa-tags stat-icon-compact"></i>
                    <div class="stat-value-compact">
                        <asp:Label ID="lblCategories" runat="server" Text="0"></asp:Label>
                    </div>
                    <div class="stat-label-compact">Categories</div>
                </div>
            </div>

            <div class="row">
                <!-- Expenses Form -->
                <div class="col-lg-4">
                    <div class="modern-card">
                        <div class="card-header-modern">
                            <h5><i class="fas fa-plus-circle mr-2"></i><asp:Label ID="lblFormTitle" runat="server" Text="Add New Expense"></asp:Label></h5>
                        </div>
                        <div class="card-body-modern">
                            <asp:HiddenField ID="hfExpenseId" runat="server" />
                            
                            <div class="form-group-compact">
                                <label class="form-label-compact">Expense Type *</label>
                                <asp:TextBox ID="txtExpenseType" runat="server" CssClass="form-control-modern" 
                                    placeholder="Enter expense type" required="required"></asp:TextBox>
                            </div>

                            <div class="form-group-compact">
                                <label class="form-label-compact">Amount *</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text bg-light border-right-0">$</span>
                                    </div>
                                    <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control-modern border-left-0" 
                                        placeholder="0.00" TextMode="Number" step="0.01" required="required"></asp:TextBox>
                                </div>
                            </div>

                            <div class="form-group-compact">
                                <label class="form-label-compact">Expense Date *</label>
                                <asp:TextBox ID="txtExpenseDate" runat="server" CssClass="form-control-modern" 
                                    TextMode="Date" required="required"></asp:TextBox>
                            </div>

                            <div class="form-group-compact">
                                <label class="form-label-compact">Category *</label>
                                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control-modern" required="required">
                                    <asp:ListItem Value="">Select Category</asp:ListItem>
                                    <asp:ListItem Value="Salary">Salary</asp:ListItem>
                                    <asp:ListItem Value="Utilities">Utilities</asp:ListItem>
                                    <asp:ListItem Value="Maintenance">Maintenance</asp:ListItem>
                                    <asp:ListItem Value="Supplies">Supplies</asp:ListItem>
                                    <asp:ListItem Value="Transportation">Transportation</asp:ListItem>
                                    <asp:ListItem Value="Events">Events</asp:ListItem>
                                    <asp:ListItem Value="Other">Other</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="form-group-compact">
                                <label class="form-label-compact">Description</label>
                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control-modern" 
                                    TextMode="MultiLine" Rows="2" placeholder="Enter expense description..."></asp:TextBox>
                            </div>

                            <div class="form-group-compact">
                                <label class="form-label-compact">Paid To</label>
                                <asp:TextBox ID="txtPaidTo" runat="server" CssClass="form-control-modern" 
                                    placeholder="Person or company paid to"></asp:TextBox>
                            </div>

                            <div class="form-group-compact">
                                <label class="form-label-compact">Payment Mode *</label>
                                <asp:DropDownList ID="ddlPaymentMode" runat="server" CssClass="form-control-modern" required="required">
                                    <asp:ListItem Value="">Select Payment Mode</asp:ListItem>
                                    <asp:ListItem Value="Cash">Cash</asp:ListItem>
                                    <asp:ListItem Value="Bank Transfer">Bank Transfer</asp:ListItem>
                                    <asp:ListItem Value="Cheque">Cheque</asp:ListItem>
                                    <asp:ListItem Value="Card">Card</asp:ListItem>
                                    <asp:ListItem Value="Online">Online</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="form-group-compact pt-2">
                                <asp:Button ID="btnSave" runat="server" Text="Save Expense" 
                                    CssClass="btn-modern-primary btn-block" OnClick="btnSave_Click" />
                                <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                                    CssClass="btn-modern-secondary btn-block mt-2" OnClick="btnCancel_Click" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Expenses List -->
                <div class="col-lg-8">
                    <div class="modern-card">
                        <div class="card-header-modern d-flex justify-content-between align-items-center flex-wrap">
                            <h5 class="mb-0"><i class="fas fa-list mr-2"></i>Expenses Overview</h5>
                            <div class="d-flex align-items-center flex-wrap mt-2 mt-md-0">
                                <div class="filter-container-modern">
                                    <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="form-control-modern filter-select-modern" 
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlCategoryFilter_SelectedIndexChanged">
                                        <asp:ListItem Value="">All Categories</asp:ListItem>
                                        <asp:ListItem Value="Salary">Salary</asp:ListItem>
                                        <asp:ListItem Value="Utilities">Utilities</asp:ListItem>
                                        <asp:ListItem Value="Maintenance">Maintenance</asp:ListItem>
                                        <asp:ListItem Value="Supplies">Supplies</asp:ListItem>
                                        <asp:ListItem Value="Transportation">Transportation</asp:ListItem>
                                        <asp:ListItem Value="Events">Events</asp:ListItem>
                                        <asp:ListItem Value="Other">Other</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="filter-container-modern">
                                    <asp:DropDownList ID="ddlPaymentFilter" runat="server" CssClass="form-control-modern filter-select-modern" 
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlPaymentFilter_SelectedIndexChanged">
                                        <asp:ListItem Value="">All Payments</asp:ListItem>
                                        <asp:ListItem Value="Cash">Cash</asp:ListItem>
                                        <asp:ListItem Value="Bank Transfer">Bank Transfer</asp:ListItem>
                                        <asp:ListItem Value="Cheque">Cheque</asp:ListItem>
                                        <asp:ListItem Value="Card">Card</asp:ListItem>
                                        <asp:ListItem Value="Online">Online</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="search-container-modern">
                                    <i class="fas fa-search search-icon-modern"></i>
                                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control-modern" 
                                        placeholder="Search expenses..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                                </div>
                                <asp:Button ID="btnExport" runat="server"  Text="Export" 
                                    CssClass="btn-modern-primary ml-2" CausesValidation="false" OnClick="btnExport_Click" />
                            </div>
                        </div>
                        <div class="card-body-modern">
                            <div class="table-responsive">
                                <asp:GridView ID="gvExpenses" runat="server" AutoGenerateColumns="False" 
                                    CssClass="table table-modern" 
                                    DataKeyNames="ExpenseId" OnRowEditing="gvExpenses_RowEditing" 
                                    OnRowDeleting="gvExpenses_RowDeleting" OnRowDataBound="gvExpenses_RowDataBound"
                                    AllowPaging="True" PageSize="8" OnPageIndexChanging="gvExpenses_PageIndexChanging"
                                    EmptyDataText="No expenses found. Start by adding your first expense above.">
                                    <Columns>
                                        <asp:BoundField DataField="ExpenseId" HeaderText="ID">
                                            <ItemStyle Width="60px" Font-Bold="true" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ExpenseType" HeaderText="Type">
                                            <ItemStyle Font-Bold="true" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Amount" HeaderText="Amount" 
                                            DataFormatString="{0:C}">
                                            <ItemStyle Width="100px" Font-Bold="true" CssClass="amount-negative" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ExpenseDate" HeaderText="Date" 
                                            DataFormatString="{0:MMM dd, yyyy}">
                                            <ItemStyle Width="100px" />
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Category">
                                            <ItemTemplate>
                                                <span class='category-badge-modern badge-<%# Eval("Category").ToString().ToLower() %>'>
                                                    <%# Eval("Category") %>
                                                </span>
                                            </ItemTemplate>
                                            <ItemStyle Width="100px" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="Description" HeaderText="Description">
                                            <ItemStyle Width="150px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="PaidTo" HeaderText="Paid To">
                                            <ItemStyle Width="100px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="PaymentMode" HeaderText="Payment Mode">
                                            <ItemStyle Width="100px" />
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Actions">
                                            <ItemTemplate>
                                                <div class="action-buttons-modern">
                                                    <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" 
                                                        CssClass="btn-action-modern btn-edit-modern" ToolTip="Edit Expense">
                                                        <i class="fas fa-edit"></i>
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" 
                                                        CssClass="btn-action-modern btn-delete-modern" ToolTip="Delete Expense">
                                                        <i class="fas fa-trash"></i>
                                                    </asp:LinkButton>
                                                </div>
                                            </ItemTemplate>
                                            <ItemStyle Width="80px" />
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
            var dateField = document.getElementById('<%= txtExpenseDate.ClientID %>');
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

            document.querySelectorAll('.compact-stat-card').forEach((el) => {
                observer.observe(el);
            });
        });
    </script>
</asp:Content>