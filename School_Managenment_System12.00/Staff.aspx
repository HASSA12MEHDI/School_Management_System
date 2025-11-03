<%@ Page Title="Staff Management" Language="C#" AutoEventWireup="true" CodeBehind="Staff.aspx.cs" Inherits="School_Managenment_System12._00.Staff" MasterPageFile="~/Site1.Master" %>
<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" 
    Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --dark-bg: #0a1929;
            --dark-surface: #112240;
            --dark-card: #1a365d;
            --accent-green: #00d4aa;
            --accent-green-light: #4fd1c5;
            --accent-green-dark: #0891b2;
            --text-primary: #e2e8f0;
            --text-secondary: #a0aec0;
            --border-dark: #2d3748;
            --danger: #e53e3e;
            --warning: #ed8936;
        }
        
        .staff-container {
            background: var(--dark-bg);
            min-height: 100vh;
            color: var(--text-primary);
            padding: 20px;
        }
        
        .staff-header {
            background: linear-gradient(135deg, var(--dark-surface), var(--dark-card));
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 25px;
            border-left: 5px solid var(--accent-green);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
        }
        
        .staff-header h1 {
            margin: 0;
            font-size: 2.2em;
            color: var(--accent-green);
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .staff-header p {
            color: var(--text-secondary);
            margin: 10px 0 0;
            font-size: 1.1em;
        }
        
        .stats-panel {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: var(--dark-surface);
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            border: 1px solid var(--border-dark);
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            border-color: var(--accent-green);
            box-shadow: 0 6px 12px rgba(0, 212, 170, 0.2);
        }
        
        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            color: var(--accent-green);
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: var(--text-secondary);
            font-weight: 500;
            font-size: 0.9em;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .form-panel {
            background: var(--dark-surface);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid var(--border-dark);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
        }
        
        .form-panel h3 {
            color: var(--accent-green);
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 1.5em;
            border-bottom: 1px solid var(--border-dark);
            padding-bottom: 10px;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text-primary);
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            background: var(--dark-card);
            border: 1px solid var(--border-dark);
            border-radius: 6px;
            color: var(--text-primary);
            font-size: 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: var(--accent-green);
            outline: none;
            box-shadow: 0 0 0 3px rgba(0, 212, 170, 0.2);
        }
        
        .form-control::placeholder {
            color: var(--text-secondary);
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 20px 0;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: var(--accent-green);
        }
        
        .checkbox-group label {
            color: var(--text-primary);
            font-weight: 500;
        }
        
        .btn-group {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 25px;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: var(--accent-green);
            color: var(--dark-bg);
        }
        
        .btn-primary:hover {
            background: var(--accent-green-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 212, 170, 0.3);
        }
        
        .btn-secondary {
            background: var(--dark-card);
            color: var(--text-primary);
            border: 1px solid var(--border-dark);
        }
        
        .btn-secondary:hover {
            background: var(--border-dark);
            transform: translateY(-2px);
        }
        
        .btn-danger {
            background: var(--danger);
            color: white;
        }
        
        .btn-danger:hover {
            background: #c53030;
            transform: translateY(-2px);
        }
        
        .search-box {
            background: var(--dark-surface);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            border: 1px solid var(--border-dark);
        }
        
        .search-container {
            display: flex;
            gap: 15px;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        
        .search-field {
            flex: 1;
            min-width: 250px;
        }
        
        .grid-container {
            margin-top: 30px;
            overflow-x: auto;
        }
        
        .gridview {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid var(--border-dark);
            border-radius: 8px;
            overflow: hidden;
        }
        
        .gridview th {
            background: linear-gradient(to bottom, var(--dark-card), var(--dark-surface));
            color: var(--accent-green);
            padding: 15px;
            text-align: left;
            font-weight: 600;
            border-bottom: 1px solid var(--border-dark);
        }
        
        .gridview td {
            padding: 12px 15px;
            border-bottom: 1px solid var(--border-dark);
            color: var(--text-primary);
        }
        
        .gridview tr {
            background: var(--dark-surface);
            transition: background 0.2s ease;
        }
        
        .gridview tr:nth-child(even) {
            background: var(--dark-card);
        }
        
        .gridview tr:hover {
            background: rgba(0, 212, 170, 0.1);
        }
        
        .status-active {
            color: var(--accent-green);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .status-active:before {
            content: "";
            width: 8px;
            height: 8px;
            background: var(--accent-green);
            border-radius: 50%;
        }
        
        .status-inactive {
            color: var(--text-secondary);
            font-style: italic;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .status-inactive:before {
            content: "";
            width: 8px;
            height: 8px;
            background: var(--text-secondary);
            border-radius: 50%;
        }
        
        .validation-error {
            color: var(--danger);
            font-size: 13px;
            margin-top: 5px;
            display: block;
        }
        
        .pager-style {
            background: var(--dark-surface);
            color: var(--text-primary);
            padding: 15px;
            text-align: center;
            border-top: 1px solid var(--border-dark);
        }
        
        .pager-style a {
            color: var(--accent-green);
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 4px;
            margin: 0 2px;
        }
        
        .pager-style a:hover {
            background: rgba(0, 212, 170, 0.1);
        }
        
        .pager-style span {
            background: var(--accent-green);
            color: var(--dark-bg);
            padding: 5px 10px;
            border-radius: 4px;
            margin: 0 2px;
            font-weight: bold;
        }
        
        .empty-data {
            text-align: center;
            padding: 40px;
            color: var(--text-secondary);
            font-style: italic;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .stats-panel {
                grid-template-columns: 1fr;
            }
            
            .btn-group {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="staff-container">
        <!-- Header Section -->
        <div class="staff-header">
            <h1><i class="fas fa-users"></i> Staff Management</h1>
            <p>Manage your team with our modern dark green themed interface</p>
        </div>
        
        <!-- Statistics Panel -->
        <div class="stats-panel">
            <div class="stat-card">
                <div class="stat-number" runat="server" id="totalStaff">0</div>
                <div class="stat-label">Total Staff</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" runat="server" id="activeStaff">0</div>
                <div class="stat-label">Active Staff</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" runat="server" id="inactiveStaff">0</div>
                <div class="stat-label">Inactive Staff</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" runat="server" id="managerCount">0</div>
                <div class="stat-label">Managers</div>
            </div>
        </div>

        <!-- Staff Form -->
        <div class="form-panel">
            <h3>Staff Information</h3>
            
            <asp:HiddenField ID="hdnStaffId" runat="server" />
            
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">First Name</label>
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" MaxLength="50" placeholder="Enter first name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" 
                        ControlToValidate="txtFirstName" ErrorMessage="First name is required" 
                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Last Name</label>
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" MaxLength="50" placeholder="Enter last name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvLastName" runat="server" 
                        ControlToValidate="txtLastName" ErrorMessage="Last name is required" 
                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label">Position</label>
                <asp:DropDownList ID="ddlPosition" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">Select Position</asp:ListItem>
                    <asp:ListItem Value="Manager">Manager</asp:ListItem>
                    <asp:ListItem Value="Developer">Developer</asp:ListItem>
                    <asp:ListItem Value="Designer">Designer</asp:ListItem>
                    <asp:ListItem Value="Analyst">Analyst</asp:ListItem>
                    <asp:ListItem Value="Administrator">Administrator</asp:ListItem>
                    <asp:ListItem Value="Support">Support</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvPosition" runat="server" 
                    ControlToValidate="ddlPosition" ErrorMessage="Position is required" 
                    CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
            
            <div class="checkbox-group">
                <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                <label for="<%= chkIsActive.ClientID %>">Active Staff Member</label>
            </div>
            
            <div class="btn-group">
                <asp:Button ID="btnSave" runat="server" Text="Save Staff" CssClass="btn btn-primary" 
                    OnClick="btnSave_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary" 
                    OnClick="btnCancel_Click" CausesValidation="false" />
                <asp:Button ID="btnClear" runat="server" Text="Clear Form" CssClass="btn btn-secondary" 
                    OnClick="btnClear_Click" CausesValidation="false" />
            </div>
        </div>

        <!-- Search Panel -->
        <div class="search-box">
            <div class="search-container">
                <div class="search-field">
                    <label class="form-label">Search Staff</label>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" 
                        placeholder="Search by name or position..."></asp:TextBox>
                </div>
                <div>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" 
                        OnClick="btnSearch_Click" />
                    <asp:Button ID="btnShowAll" runat="server" Text="Show All" CssClass="btn btn-secondary" 
                        OnClick="btnShowAll_Click" />
                </div>
            </div>
        </div>

        <!-- Staff GridView -->
        <div class="grid-container">
            <asp:GridView ID="gvStaff" runat="server" AutoGenerateColumns="False" 
                CssClass="gridview" DataKeyNames="StaffId" 
                OnRowEditing="gvStaff_RowEditing" OnRowDeleting="gvStaff_RowDeleting"
                EmptyDataText="No staff members found." AllowPaging="True" 
                PageSize="10" OnPageIndexChanging="gvStaff_PageIndexChanging"
                PagerStyle-CssClass="pager-style" OnSelectedIndexChanged="gvStaff_SelectedIndexChanged">
                <Columns>
                    <asp:BoundField DataField="StaffId" HeaderText="ID" ReadOnly="True" />
                    <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                    <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                    <asp:BoundField DataField="Position" HeaderText="Position" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" 
                                CssClass='<%# (bool)Eval("IsActive") ? "status-active" : "status-inactive" %>'
                                Text='<%# (bool)Eval("IsActive") ? "Active" : "Inactive" %>'>
                            </asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="CreatedDate" HeaderText="Created Date" 
                        DataFormatString="{0:MM/dd/yyyy}" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnEdit" runat="server" CausesValidation="false" Text="Edit" CssClass="btn btn-secondary" 
                                CommandName="Edit" />
                            <asp:Button ID="btnDelete" runat="server" CausesValidation="false" Text="Delete" CssClass="btn btn-danger" 
                                CommandName="Delete" 
                                OnClientClick="return confirm('Are you sure you want to delete this staff member?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataRowStyle CssClass="empty-data" />
            </asp:GridView>
        </div>
    </div>
    
    <script>
        // Add icons to buttons
        document.addEventListener('DOMContentLoaded', function() {
            // Save button
            const saveBtn = document.getElementById('<%= btnSave.ClientID %>');
            if (saveBtn) {
                saveBtn.innerHTML = '<i class="fas fa-save"></i> ' + saveBtn.textContent;
            }
            
            // Cancel button
            const cancelBtn = document.getElementById('<%= btnCancel.ClientID %>');
            if (cancelBtn) {
                cancelBtn.innerHTML = '<i class="fas fa-times"></i> ' + cancelBtn.textContent;
            }
            
            // Clear button
            const clearBtn = document.getElementById('<%= btnClear.ClientID %>');
            if (clearBtn) {
                clearBtn.innerHTML = '<i class="fas fa-eraser"></i> ' + clearBtn.textContent;
            }
            
            // Search button
            const searchBtn = document.getElementById('<%= btnSearch.ClientID %>');
            if (searchBtn) {
                searchBtn.innerHTML = '<i class="fas fa-search"></i> ' + searchBtn.textContent;
            }
            
            // Show All button
            const showAllBtn = document.getElementById('<%= btnShowAll.ClientID %>');
            if (showAllBtn) {
                showAllBtn.innerHTML = '<i class="fas fa-list"></i> ' + showAllBtn.textContent;
            }
            
            // Add icons to gridview buttons
            const editButtons = document.querySelectorAll('#<%= gvStaff.ClientID %> .btn-secondary');
            editButtons.forEach(btn => {
                if (btn.textContent.trim() === 'Edit') {
                    btn.innerHTML = '<i class="fas fa-edit"></i> Edit';
                }
            });
            
            const deleteButtons = document.querySelectorAll('#<%= gvStaff.ClientID %> .btn-danger');
            deleteButtons.forEach(btn => {
                if (btn.textContent.trim() === 'Delete') {
                    btn.innerHTML = '<i class="fas fa-trash"></i> Delete';
                }
            });
        });
    </script>
</asp:Content>