<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="View_Student.aspx.cs" 
    Inherits="School_Managenment_System12._00.View_Student" MasterPageFile="~/Site1.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .action-buttons { margin-bottom:20px; text-align:right; }
        .student-grid { width:100%; border-collapse:collapse; margin-top:20px; }
        .student-grid th { background:#3498db; color:white; padding:12px 8px; text-align:left; }
        .student-grid td { padding:10px 8px; border:1px solid #ddd; }
        .student-grid tr:nth-child(even) { background:#f8f9fa; }
        .student-grid tr:hover { background:#e8f4fc; }
        .status-active { color:#27ae60; font-weight:bold; }
        .status-inactive { color:#e74c3c; font-weight:bold; }
        .btn-view { background:#2ecc71; color:white; border:none; padding:5px 12px; border-radius:4px; cursor:pointer; margin:2px; }
        .btn-edit { background:#3498db; color:white; border:none; padding:5px 12px; border-radius:4px; cursor:pointer; margin:2px; }
        .btn-delete { background:#e74c3c; color:white; border:none; padding:5px 12px; border-radius:4px; cursor:pointer; margin:2px; }
        .btn-report { background:#9b59b6; color:white; border:none; padding:10px 20px; border-radius:4px; cursor:pointer; margin-left:10px; }
        .filter-section { display:grid; grid-template-columns:repeat(auto-fit, minmax(250px, 1fr)); gap:20px; margin-bottom:25px; padding:25px; background:#f8f9fa; border-radius:12px; box-shadow:0 4px 6px rgba(0,0,0,0.05); }
        .page-header { text-align:center; color:#2c3e50; margin-bottom:30px; padding-bottom:15px; border-bottom:2px solid #3498db; }
        
        /* Enhanced Filter Controls */
        .filter-group { position:relative; }
        .filter-group label { display:block; margin-bottom:8px; font-weight:600; color:#2c3e50; font-size:14px; }
        .filter-group .form-control { 
            width:100%; 
            padding:12px 15px 12px 40px; 
            border:2px solid #e1e8ed; 
            border-radius:8px; 
            font-size:14px; 
            transition:all 0.3s ease;
            background-color:#fff;
            box-sizing:border-box;
        }
        .filter-group .form-control:focus { 
            border-color:#3498db; 
            outline:none; 
            box-shadow:0 0 0 3px rgba(52, 152, 219, 0.2);
        }
        .filter-icon { 
            position:absolute; 
            left:12px; 
            top:42px; 
            color:#7f8c8d; 
            z-index:1;
        }
        .filter-buttons { 
            display:flex; 
            gap:10px; 
            align-self:flex-end; 
            margin-top:24px;
        }
        .filter-buttons .btn { 
            padding:12px 20px; 
            border-radius:8px; 
            font-weight:600;
            transition:all 0.3s ease;
            border:none;
            cursor:pointer;
        }
        .filter-buttons .btn:hover { 
            transform:translateY(-2px);
            box-shadow:0 4px 8px rgba(0,0,0,0.1);
        }
        .btn-apply { 
            background:#3498db; 
            color:white; 
        }
        .btn-clear { 
            background:#e74c3c; 
            color:white; 
        }
        
        /* Enhanced Action Buttons */
        .action-buttons { 
            display:flex; 
            justify-content:space-between; 
            margin-bottom:25px;
        }
        .action-buttons .btn-report { 
            padding:12px 24px; 
            font-weight:600;
            transition:all 0.3s ease;
        }
        .action-buttons .btn-report:hover { 
            transform:translateY(-2px);
            box-shadow:0 4px 8px rgba(155, 89, 182, 0.3);
        }
        
        /* Enhanced GridView */
        .student-grid { 
            border-radius:8px; 
            overflow:hidden; 
            box-shadow:0 4px 6px rgba(0,0,0,0.05);
        }
        .student-grid th { 
            background:#2c3e50; 
            color:white; 
            padding:15px 12px; 
            text-align:left; 
            font-weight:600;
        }
        .student-grid td { 
            padding:12px; 
            border:1px solid #e1e8ed; 
        }
        .student-grid tr:nth-child(even) { 
            background:#f8f9fa; 
        }
        .student-grid tr:hover { 
            background:#e8f4fc; 
        }
        
        /* Message Panel */
        .message-panel {
            padding:15px;
            border-radius:8px;
            margin-top:20px;
            display:flex;
            align-items:center;
            gap:10px;
        }
        .message-success {
            background-color:#d4edda;
            color:#155724;
            border:1px solid #c3e6cb;
        }
        .message-error {
            background-color:#f8d7da;
            color:#721c24;
            border:1px solid #f5c6cb;
        }
        .message-info {
            background-color:#d1ecf1;
            color:#0c5460;
            border:1px solid #bee5eb;
        }
        
        /* Confirmation Dialog */
        .confirmation-dialog {
            position:fixed;
            top:50%;
            left:50%;
            transform:translate(-50%, -50%);
            background-color:white;
            padding:25px;
            border-radius:12px;
            box-shadow:0 10px 25px rgba(0,0,0,0.2);
            z-index:1000;
            min-width:350px;
            text-align:center;
        }
        .confirmation-dialog h3 {
            margin-top:0;
            color:#2c3e50;
        }
        .confirmation-dialog p {
            margin-bottom:20px;
            color:#7f8c8d;
        }
        .confirmation-buttons {
            display:flex;
            gap:10px;
            justify-content:center;
        }
        .overlay {
            position:fixed;
            top:0;
            left:0;
            width:100%;
            height:100%;
            background-color:rgba(0,0,0,0.5);
            z-index:999;
        }
    </style>
    
    <script type="text/javascript">
        function confirmDelete() {
            return confirm("Are you sure you want to delete this student?");
        }

        // Add icon to search input
        document.addEventListener('DOMContentLoaded', function () {
            // This would be better implemented with a server control, but for demonstration
            var searchInput = document.getElementById('<%= txtSearchName.ClientID %>');
            if (searchInput) {
                searchInput.placeholder = "🔍 Enter student name...";
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <h1>📚 Student Records</h1>
        <p>Manage and view all student information</p>
    </div>
    
    <!-- Filter Section -->
    <div class="filter-section">
        <div class="filter-group">
            <label for="txtSearchName">Search by Name</label>
            <span class="filter-icon">🔍</span>
            <asp:TextBox ID="txtSearchName" runat="server" CssClass="form-control" placeholder="Enter student name..."></asp:TextBox>
        </div>
        <div class="filter-group">
            <label for="ddlClassFilter">Class</label>
            <span class="filter-icon">📚</span>
            <asp:DropDownList ID="ddlClassFilter" runat="server" CssClass="form-control">
                <asp:ListItem Value="">All Classes</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="filter-group">
            <label for="ddlStatusFilter">Status</label>
            <span class="filter-icon">📊</span>
            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control">
                <asp:ListItem Value="all">All Status</asp:ListItem>
                <asp:ListItem Value="true">Active</asp:ListItem>
                <asp:ListItem Value="false">Inactive</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="filter-buttons">
            <asp:Button ID="btnApplyFilter" runat="server" Text="Apply Filters" CssClass="btn btn-apply" OnClick="BtnApplyFilter_Click" />
            <asp:Button ID="btnClearFilter" runat="server" Text="Clear Filters" CssClass="btn btn-clear" OnClick="BtnClearFilter_Click" />
        </div>
    </div>

    <div class="action-buttons">
        <div></div> <!-- Empty div for spacing -->
        <div>
            <asp:Button ID="btnAddStudent" runat="server" Text="➕ Add New Student" CssClass="btn-report" PostBackUrl="~/Add_Student.aspx" />
            <asp:Button ID="btnSaveReport" runat="server" Text="📊 Generate Report" CssClass="btn-report" OnClick="BtnSaveReport_Click" />
        </div>
    </div>

    <!-- Confirmation Dialog -->
    <div class="overlay" id="deleteOverlay" runat="server" style="display:none;"></div>
    <div class="confirmation-dialog" id="deleteConfirmation" runat="server" style="display:none;">
        <h3>Confirm Delete</h3>
        <p>Are you sure you want to delete this student record?</p>
        <div class="confirmation-buttons">
            <asp:Button ID="btnConfirmDelete" runat="server" Text="Yes, Delete" CssClass="btn-delete" OnClick="BtnConfirmDelete_Click" />
            <asp:Button ID="btnCancelDelete" runat="server" Text="Cancel" CssClass="btn-edit" OnClick="BtnCancelDelete_Click" />
        </div>
        <asp:HiddenField ID="hdnStudentToDelete" runat="server" />
    </div>
    
    <!-- Student GridView -->
    <asp:GridView ID="gvStudents" runat="server" CssClass="student-grid" AutoGenerateColumns="False" 
        AllowPaging="True" PageSize="10" DataKeyNames="StudentId"
        OnPageIndexChanging="GvStudents_PageIndexChanging" OnRowEditing="GvStudents_RowEditing"
        OnRowCancelingEdit="GvStudents_RowCancelingEdit" OnRowUpdating="GvStudents_RowUpdating"
        OnRowDataBound="GvStudents_RowDataBound">
        
        <Columns>
            <asp:BoundField DataField="RollNumber" HeaderText="Roll No" ReadOnly="true" />
            <asp:TemplateField HeaderText="First Name">
                <ItemTemplate><asp:Label ID="lblFirstName" runat="server" Text='<%# Eval("FirstName") %>'></asp:Label></ItemTemplate>
                <EditItemTemplate><asp:TextBox ID="txtFirstName" runat="server" Text='<%# Bind("FirstName") %>' Width="90%"></asp:TextBox></EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Last Name">
                <ItemTemplate><asp:Label ID="lblLastName" runat="server" Text='<%# Eval("LastName") %>'></asp:Label></ItemTemplate>
                <EditItemTemplate><asp:TextBox ID="txtLastName" runat="server" Text='<%# Bind("LastName") %>' Width="90%"></asp:TextBox></EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Email">
                <ItemTemplate><asp:Label ID="lblEmail" runat="server" Text='<%# Eval("Email") %>'></asp:Label></ItemTemplate>
                <EditItemTemplate><asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>' Width="90%"></asp:TextBox></EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Phone">
                <ItemTemplate><asp:Label ID="lblPhone" runat="server" Text='<%# Eval("Phone") %>'></asp:Label></ItemTemplate>
                <EditItemTemplate><asp:TextBox ID="txtPhone" runat="server" Text='<%# Bind("Phone") %>' Width="90%"></asp:TextBox></EditItemTemplate>
            </asp:TemplateField>
            
            <asp:TemplateField HeaderText="Class">
                <ItemTemplate><asp:Label ID="lblClassName" runat="server" Text='<%# Eval("ClassId") %>'></asp:Label></ItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList ID="ddlClass" runat="server">
                        <asp:ListItem Value="1">Class 1</asp:ListItem>
                        <asp:ListItem Value="2">Class 2</asp:ListItem>
                        <asp:ListItem Value="3">Class 3</asp:ListItem>
                        <asp:ListItem Value="4">Class 4</asp:ListItem>
                        <asp:ListItem Value="5">Class 5</asp:ListItem>
                        <asp:ListItem Value="6">Class 6</asp:ListItem>
                        <asp:ListItem Value="7">Class 7</asp:ListItem>
                        <asp:ListItem Value="8">Class 8</asp:ListItem>
                        <asp:ListItem Value="9">Class 9</asp:ListItem>
                        <asp:ListItem Value="10">Class 10</asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
            </asp:TemplateField>
            
            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "status-active" : "status-inactive" %>'>
                        <%# Convert.ToBoolean(Eval("IsActive")) ? "✓ Active" : "✗ Inactive" %>
                    </span>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox ID="chkIsActive" runat="server" Checked='<%# Bind("IsActive") %>' Text="Active" />
                </EditItemTemplate>
            </asp:TemplateField>
            
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnView" runat="server" Text="View" CssClass="btn-view" 
                        CommandArgument='<%# Eval("StudentId") %>' OnClick="BtnView_Click" />
                    <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="btn-edit" CommandName="Edit" />
                    <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn-delete" 
                        CommandArgument='<%# Eval("StudentId") %>' OnClick="BtnDelete_Click" 
                        OnClientClick="return confirmDelete();" />
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn-view" CommandName="Update" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-delete" CommandName="Cancel" />
                </EditItemTemplate>
            </asp:TemplateField>
        </Columns>
        
        <EmptyDataTemplate>
            <div style="text-align:center; padding:20px; color:#7f8c8d;">No student records found.</div>
        </EmptyDataTemplate>
    </asp:GridView>

    <!-- Message Panel -->
    <asp:Panel ID="pnlMessage" runat="server" CssClass="message-panel" Visible="false">
        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
    </asp:Panel>
</asp:Content>