<%@ Page Title="Book Categories" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="BookCategories.aspx.cs" Inherits="School_Managenment_System12._00.BookCategories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Dark Black Green Red Theme */
        .categories-container {
            background: #0a0a0a;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid #1a1a1a;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: white;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 6px 20px rgba(0,0,0,0.3);
            border: 1px solid #333;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 3px;
                background: linear-gradient(90deg, #4CAF50, #45a049);
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(76, 175, 80, 0.2);
                border-color: #4CAF50;
            }

            .stat-card.warning::before {
                background: linear-gradient(90deg, #FF9800, #F57C00);
            }

            .stat-card.danger::before {
                background: linear-gradient(90deg, #f44336, #d32f2f);
            }

            .stat-card.info::before {
                background: linear-gradient(90deg, #2196F3, #1976D2);
            }

        .stat-icon {
            font-size: 24px;
            margin-bottom: 10px;
            color: #4CAF50;
        }

        .stat-card.warning .stat-icon {
            color: #FF9800;
        }

        .stat-card.danger .stat-icon {
            color: #f44336;
        }

        .stat-card.info .stat-icon {
            color: #2196F3;
        }

        .stat-number {
            font-size: 32px;
            font-weight: bold;
            margin: 10px 0;
            color: #ffffff;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .stat-label {
            font-size: 14px;
            color: #b0b0b0;
            font-weight: 500;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .btn-add-category {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 20px;
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
            font-family: inherit;
        }

            .btn-add-category:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4);
                background: linear-gradient(135deg, #4CAF50 0%, #388E3C 100%);
            }

        .btn-category {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 20px;
            background: linear-gradient(135deg, #2d2d2d 0%, #1a1a1a 100%);
            color: white;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 1px solid #333;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            font-family: inherit;
        }

            .btn-category:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.3);
                border-color: #4CAF50;
                background: linear-gradient(135deg, #333 0%, #2d2d2d 100%);
            }

            .btn-category.secondary {
                background: linear-gradient(135deg, #f44336 0%, #d32f2f 100%);
                border: 1px solid #f44336;
            }

                .btn-category.secondary:hover {
                    background: linear-gradient(135deg, #f44336 0%, #c62828 100%);
                    box-shadow: 0 6px 20px rgba(244, 67, 54, 0.4);
                }

        .search-filter {
            background: #1a1a1a;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            border: 1px solid #333;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .search-row {
            display: grid;
            grid-template-columns: 2fr 1fr auto;
            gap: 15px;
            align-items: end;
        }

        .form-group {
            margin-bottom: 0;
        }

        .form-label {
            color: #e0e0e0;
            font-weight: 600;
            margin-bottom: 8px;
            display: block;
            font-size: 14px;
        }

        .form-control {
            background: #2d2d2d;
            border: 1px solid #404040;
            color: #ffffff;
            border-radius: 6px;
            padding: 10px 12px;
            width: 100%;
            transition: all 0.3s ease;
            font-family: inherit;
            font-size: 14px;
            box-sizing: border-box;
        }

            .form-control:focus {
                outline: none;
                border-color: #4CAF50;
                box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
                background: #333;
            }

            .form-control::placeholder {
                color: #888;
            }

        .categories-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .category-card {
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            border-radius: 12px;
            padding: 25px;
            border: 1px solid #333;
            transition: all 0.3s ease;
            position: relative;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            overflow: hidden;
        }

            .category-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 3px;
                background: linear-gradient(90deg, #4CAF50, #45a049);
                transform: scaleX(0);
                transition: transform 0.3s ease;
            }

            .category-card:hover::before {
                transform: scaleX(1);
            }

            .category-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.4);
                border-color: #4CAF50;
            }

            .category-card.inactive {
                opacity: 0.6;
                background: linear-gradient(135deg, #1a1a1a 0%, #252525 100%);
            }

                .category-card.inactive::before {
                    background: linear-gradient(90deg, #666, #888);
                }

        .category-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .category-name {
            color: #ffffff;
            font-weight: 600;
            font-size: 18px;
            margin-bottom: 8px;
        }

        .category-description {
            color: #b0b0b0;
            font-size: 14px;
            line-height: 1.5;
        }

        .category-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            margin: 15px 0;
            padding: 15px;
            background: rgba(255,255,255,0.05);
            border-radius: 8px;
            border: 1px solid #333;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number-small {
            font-size: 18px;
            font-weight: bold;
            color: #4CAF50;
            display: block;
        }

        .stat-label-small {
            font-size: 12px;
            color: #b0b0b0;
        }

        .category-actions {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
            margin-top: 15px;
        }

        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #333;
            color: white;
            border: 1px solid #444;
            font-family: inherit;
        }

            .btn-action:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.3);
            }

        .btn-edit {
            background: linear-gradient(135deg, #4CAF50, #45a049);
            border-color: #4CAF50;
        }

            .btn-edit:hover {
                background: linear-gradient(135deg, #45a049, #4CAF50);
            }

        .btn-delete {
            background: linear-gradient(135deg, #f44336, #d32f2f);
            border-color: #f44336;
        }

            .btn-delete:hover {
                background: linear-gradient(135deg, #d32f2f, #f44336);
            }

        .btn-toggle {
            background: linear-gradient(135deg, #FF9800, #F57C00);
            border-color: #FF9800;
        }

            .btn-toggle:hover {
                background: linear-gradient(135deg, #F57C00, #FF9800);
            }

        .status-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
            border: 1px solid transparent;
        }

        .status-active {
            background: linear-gradient(135deg, #4CAF50, #45a049);
            color: white;
            border-color: #4CAF50;
        }

        .status-inactive {
            background: linear-gradient(135deg, #f44336, #d32f2f);
            color: white;
            border-color: #f44336;
        }

        .category-meta {
            color: #888;
            font-size: 12px;
            margin-top: 10px;
            border-top: 1px solid #333;
            padding-top: 10px;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
            grid-column: 1 / -1;
            background: #1a1a1a;
            border-radius: 10px;
            border: 1px solid #333;
        }

        /* Modal Styles - FIXED */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            backdrop-filter: blur(5px);
            z-index: 10000;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.show {
            display: flex;
        }

        .modal-content {
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            border-radius: 15px;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            border: 1px solid #333;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
            position: relative;
            z-index: 10001;
        }

        .modal-header {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            padding: 20px;
            border-radius: 15px 15px 0 0;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #333;
        }

        .modal-title {
            font-size: 20px;
            font-weight: 600;
            margin: 0;
        }

        .close-modal {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
            padding: 0;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            border-radius: 50%;
            font-family: inherit;
        }

            .close-modal:hover {
                background: rgba(255, 255, 255, 0.2);
                transform: rotate(90deg);
            }

        .modal-body {
            padding: 25px;
            background: transparent;
            color: #ffffff;
        }

        .form-grid {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .form-group-full {
            width: 100%;
        }

        .switch-container {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 0;
        }

        .switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 24px;
        }

            .switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #333;
            transition: .4s;
            border-radius: 24px;
            border: 1px solid #444;
        }

            .slider:before {
                position: absolute;
                content: "";
                height: 16px;
                width: 16px;
                left: 4px;
                bottom: 3px;
                background-color: white;
                transition: .4s;
                border-radius: 50%;
            }

        input:checked + .slider {
            background-color: #4CAF50;
            border-color: #4CAF50;
        }

            input:checked + .slider:before {
                transform: translateX(26px);
            }

        .switch-label {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #e0e0e0;
            font-weight: 500;
            cursor: pointer;
            margin: 0;
        }

        .validation-error {
            color: #f44336;
            font-size: 12px;
            margin-top: 5px;
            display: block;
            font-weight: 500;
        }

        .error-message {
            background: linear-gradient(135deg, #f44336, #d32f2f);
            color: white;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            display: none;
            border: 1px solid #f44336;
            box-shadow: 0 4px 15px rgba(244, 67, 54, 0.3);
        }

        .success-message {
            background: linear-gradient(135deg, #4CAF50, #45a049);
            color: white;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            display: none;
            border: 1px solid #4CAF50;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }

        .modal-actions {
            display: flex;
            gap: 10px;
            margin-top: 25px;
            justify-content: flex-end;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .search-row {
                grid-template-columns: 1fr;
            }

            .categories-grid {
                grid-template-columns: 1fr;
            }

            .category-header {
                flex-direction: column;
                gap: 10px;
            }

            .category-actions {
                justify-content: flex-start;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn-add-category, .btn-category {
                justify-content: center;
            }

            .modal-content {
                width: 95%;
                max-width: 95%;
                margin: 20px;
            }

            .modal-actions {
                flex-direction: column;
            }
        }

        /* Scrollbar Styling */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: #1a1a1a;
        }

        ::-webkit-scrollbar-thumb {
            background: #4CAF50;
            border-radius: 4px;
        }

            ::-webkit-scrollbar-thumb:hover {
                background: #45a049;
            }

        /* Ensure form elements are visible and functional */
        textarea.form-control {
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
        }

        input[type="text"], textarea {
            font-family: inherit;
            font-size: 14px;
        }

        input[type="checkbox"] {
            margin: 0;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="categories-container">
        <!-- Error and Success Messages -->
        <div id="errorMessage" class="error-message" runat="server" style="display: none;"></div>
        <div id="successMessage" class="success-message" runat="server" style="display: none;"></div>

        <div class="alert-header">
            <h2 style="color: #ffffff; margin-bottom: 10px; font-weight: 700; text-shadow: 0 2px 4px rgba(0,0,0,0.5);">
                <i class="fas fa-tags" style="color: #4CAF50; margin-right: 10px;"></i>
                Book Categories Management
            </h2>
            <p style="color: #b0b0b0; margin: 0; font-size: 16px;">
                Organize and manage book categories for better library organization
            </p>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-tags"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblTotalCategories" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Total Categories</div>
            </div>

            <div class="stat-card info">
                <div class="stat-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblActiveCategories" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Active Categories</div>
            </div>

            <div class="stat-card warning">
                <div class="stat-icon">
                    <i class="fas fa-pause-circle"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblInactiveCategories" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Inactive Categories</div>
            </div>

            <div class="stat-card danger">
                <div class="stat-icon">
                    <i class="fas fa-book"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblTotalBooks" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Total Books</div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <button type="button" id="btnOpenModal" class="btn-add-category" onclick="openModal()">
                <i class="fas fa-plus"></i> Add New Category
            </button>
            <asp:Button ID="btnExportCategories" runat="server" Text="Export Categories"
                CssClass="btn-category secondary" OnClick="BtnExportCategories_Click" CausesValidation="false" />
            <asp:Button ID="btnRefresh" runat="server" Text="Refresh Data"
                CssClass="btn-category" OnClick="BtnRefresh_Click" CausesValidation="false" />
        </div>

        <!-- Search and Filter -->
        <div class="search-filter">
            <div class="search-row">
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-search" style="margin-right: 5px;"></i>
                        Search Categories
                    </label>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                        placeholder="Search by category name or description..." AutoPostBack="true" OnTextChanged="TxtSearch_TextChanged" CausesValidation="false"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-filter" style="margin-right: 5px;"></i>
                        Status Filter
                    </label>
                    <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control"
                        AutoPostBack="true" OnSelectedIndexChanged="DdlStatusFilter_SelectedIndexChanged" CausesValidation="false">
                        <asp:ListItem Value="">All Status</asp:ListItem>
                        <asp:ListItem Value="Active">Active</asp:ListItem>
                        <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <asp:Button ID="btnClearFilters" runat="server" Text="Clear Filters"
                        CssClass="btn-category secondary" OnClick="BtnClearFilters_Click" CausesValidation="false" />
                </div>
            </div>
        </div>

        <!-- Categories Grid -->
        <div class="categories-grid">
            <asp:Repeater ID="rptCategories" runat="server" OnItemCommand="RptCategories_ItemCommand">
                <ItemTemplate>
                    <div class="category-card <%# Eval("IsActive").ToString() == "False" ? "inactive" : "" %>">
                        <div class="category-header">
                            <div style="flex: 1;">
                                <div class="category-name">
                                    <i class="fas fa-folder" style="color: #4CAF50; margin-right: 8px;"></i>
                                    <%# Eval("CategoryName") %>
                                </div>
                                <div class="category-description"><%# Eval("Description") %></div>
                            </div>
                            <div>
                                <span class='status-badge <%# Eval("IsActive").ToString() == "True" ? "status-active" : "status-inactive" %>'>
                                    <%# Eval("IsActive").ToString() == "True" ? "Active" : "Inactive" %>
                                </span>
                            </div>
                        </div>

                        <div class="category-stats">
                            <div class="stat-item">
                                <span class="stat-number-small"><%# Eval("BookCount") %></span>
                                <span class="stat-label-small">Total Books</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number-small"><%# Eval("AvailableBooks") %></span>
                                <span class="stat-label-small">Available</span>
                            </div>
                        </div>

                        <div class="category-meta">
                            <i class="far fa-calendar" style="margin-right: 5px;"></i>
                            Created: <%# Eval("CreatedDate", "{0:MMM dd, yyyy}") %>
                        </div>

                        <div class="category-actions">
                            <asp:Button ID="btnEdit" runat="server" Text="Edit"
                                CssClass="btn-action btn-edit"
                                CommandName="Edit"
                                CommandArgument='<%# Eval("CategoryId") %>'
                                CausesValidation="false" />

                            <asp:Button ID="btnToggle" runat="server" Text='<%# Eval("IsActive").ToString() == "True" ? "Deactivate" : "Activate" %>'
                                CssClass="btn-action btn-toggle"
                                CommandName="Toggle"
                                CommandArgument='<%# Eval("CategoryId") %>'
                                OnClientClick='<%# Eval("IsActive").ToString() == "True" ? "return confirm(\"Are you sure you want to deactivate this category?\");" : "return confirm(\"Are you sure you want to activate this category?\");" %>'
                                CausesValidation="false" />

                            <asp:Button ID="btnDelete" runat="server" Text="Delete"
                                CssClass="btn-action btn-delete"
                                CommandName="Delete"
                                CommandArgument='<%# Eval("CategoryId") %>'
                                OnClientClick="return confirm('Are you sure you want to delete this category? This action cannot be undone.');"
                                Visible='<%# Convert.ToInt32(Eval("BookCount")) == 0 %>'
                                CausesValidation="false" />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Label ID="lblNoCategories" runat="server" Text="No categories found matching your criteria."
                CssClass="no-data" Visible="false"></asp:Label>
        </div>
    </div>

    <!-- Add/Edit Category Modal -->
    <div id="categoryModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title" id="modalTitle">Add New Category</div>
                <button type="button" class="close-modal" onclick="closeModal()">×</button>
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfCategoryId" runat="server" Value="0" />
                
                <div class="form-grid">
                    <div class="form-group-full">
                        <label class="form-label">
                            <i class="fas fa-heading" style="margin-right: 8px;"></i>
                            Category Name *
                        </label>
                        <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control" 
                            placeholder="Enter category name" MaxLength="100"></asp:TextBox>
                        <span id="categoryNameError" class="validation-error" style="display: none;">Category name is required</span>
                    </div>
                    
                    <div class="form-group-full">
                        <label class="form-label">
                            <i class="fas fa-align-left" style="margin-right: 8px;"></i>
                            Description
                        </label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" 
                            TextMode="MultiLine" Rows="4" placeholder="Enter category description (optional)" 
                            MaxLength="500"></asp:TextBox>
                    </div>
                    
                    <div class="form-group-full">
                        <div class="switch-container">
                            <label class="switch">
                                <asp:CheckBox ID="cbIsActive" runat="server" Checked="true" />
                                <span class="slider"></span>
                            </label>
                            <span class="switch-label">
                                <i class="fas fa-power-off" style="margin-right: 8px;"></i>
                                Active Category
                            </span>
                        </div>
                        <small style="color: #888; display: block; margin-top: 5px;">
                            Inactive categories won't be available for new books
                        </small>
                    </div>
                </div>
                
                <div class="modal-actions">
                    <asp:Button ID="btnSaveCategory" runat="server" Text="Save Category" 
                        CssClass="btn-add-category" OnClick="BtnSaveCategory_Click" 
                        OnClientClick="return validateModalForm();" />
                    <button type="button" class="btn-category secondary" onclick="closeModal()">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // Modal functions
        function openModal() {
            console.log('Opening modal...');
            var modal = document.getElementById('categoryModal');
            if (modal) {
                modal.classList.add('show');
                document.body.style.overflow = 'hidden';
                
                // Set title for add mode
                document.getElementById('modalTitle').innerText = 'Add New Category';
                
                // Clear previous data
                document.getElementById('<%= txtCategoryName.ClientID %>').value = '';
                document.getElementById('<%= txtDescription.ClientID %>').value = '';
                document.getElementById('<%= cbIsActive.ClientID %>').checked = true;
                document.getElementById('<%= hfCategoryId.ClientID %>').value = '0';
                
                // Clear validation
                clearValidation();
                
                // Focus on first input
                setTimeout(function () {
                    var categoryName = document.getElementById('<%= txtCategoryName.ClientID %>');
                    if (categoryName) {
                        categoryName.focus();
                    }
                }, 300);
            }
        }

        function openEditModal(categoryId, categoryName, description, isActive) {
            console.log('Opening edit modal for category:', categoryId);
            var modal = document.getElementById('categoryModal');
            if (modal) {
                modal.classList.add('show');
                document.body.style.overflow = 'hidden';
                
                // Set title for edit mode
                document.getElementById('modalTitle').innerText = 'Edit Category';
                
                // Populate form data
                document.getElementById('<%= hfCategoryId.ClientID %>').value = categoryId;
                document.getElementById('<%= txtCategoryName.ClientID %>').value = categoryName;
                document.getElementById('<%= txtDescription.ClientID %>').value = description;
                document.getElementById('<%= cbIsActive.ClientID %>').checked = isActive;
                
                // Clear validation
                clearValidation();
                
                // Focus on first input
                setTimeout(function () {
                    var categoryNameField = document.getElementById('<%= txtCategoryName.ClientID %>');
                    if (categoryNameField) {
                        categoryNameField.focus();
                    }
                }, 300);
            }
        }

        function closeModal() {
            console.log('Closing modal...');
            var modal = document.getElementById('categoryModal');
            if (modal) {
                modal.classList.remove('show');
                document.body.style.overflow = '';
                clearValidation();
            }
        }

        function clearValidation() {
            var errorSpans = document.querySelectorAll('.validation-error');
            errorSpans.forEach(function(span) {
                span.style.display = 'none';
            });
            
            var inputs = document.querySelectorAll('.form-control');
            inputs.forEach(function(input) {
                input.classList.remove('error');
            });
        }

        function validateModalForm() {
            var categoryName = document.getElementById('<%= txtCategoryName.ClientID %>');
            var categoryNameValue = categoryName ? categoryName.value.trim() : '';

            clearValidation();

            if (!categoryNameValue) {
                var errorElement = document.getElementById('categoryNameError');
                if (errorElement) {
                    errorElement.style.display = 'block';
                }
                if (categoryName) {
                    categoryName.classList.add('error');
                    categoryName.focus();
                }
                return false;
            }

            // Check for minimum length
            if (categoryNameValue.length < 2) {
                var errorElement = document.getElementById('categoryNameError');
                if (errorElement) {
                    errorElement.innerText = 'Category name must be at least 2 characters long';
                    errorElement.style.display = 'block';
                }
                if (categoryName) {
                    categoryName.classList.add('error');
                    categoryName.focus();
                }
                return false;
            }

            return true;
        }

        // Event listeners
        document.addEventListener('DOMContentLoaded', function() {
            // Close modal when clicking outside
            document.getElementById('categoryModal').addEventListener('click', function(e) {
                if (e.target === this) {
                    closeModal();
                }
            });
            
            // Close modal with Escape key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    closeModal();
                }
            });
            
            // Real-time validation
            var categoryNameInput = document.getElementById('<%= txtCategoryName.ClientID %>');
            if (categoryNameInput) {
                categoryNameInput.addEventListener('input', function() {
                    if (this.value.trim()) {
                        this.classList.remove('error');
                        var errorElement = document.getElementById('categoryNameError');
                        if (errorElement) {
                            errorElement.style.display = 'none';
                        }
                    }
                });
            }

            // Prevent form submission on Enter key in modal
            var modalForm = document.querySelector('#categoryModal');
            if (modalForm) {
                modalForm.addEventListener('keydown', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        return false;
                    }
                });
            }
        });

        // Function to show error from server-side
        function showServerError(message) {
            var errorDiv = document.getElementById('<%= errorMessage.ClientID %>');
            if (errorDiv) {
                errorDiv.innerHTML = '<i class="fas fa-exclamation-triangle" style="margin-right: 8px;"></i>' + message;
                errorDiv.style.display = 'block';
                errorDiv.scrollIntoView({ behavior: 'smooth', block: 'start' });
                
                // Auto-hide after 5 seconds
                setTimeout(function() {
                    errorDiv.style.display = 'none';
                }, 5000);
            }
        }

        // Function to show success from server-side
        function showServerSuccess(message) {
            var successDiv = document.getElementById('<%= successMessage.ClientID %>');
            if (successDiv) {
                successDiv.innerHTML = '<i class="fas fa-check-circle" style="margin-right: 8px;"></i>' + message;
                successDiv.style.display = 'block';
                successDiv.scrollIntoView({ behavior: 'smooth', block: 'start' });

                // Auto-hide after 5 seconds
                setTimeout(function () {
                    successDiv.style.display = 'none';
                }, 5000);
            }
        }
    </script>
</asp:Content>