<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Veiw_Classes.aspx.cs" Inherits="School_Managenment_System12._00.Veiw_Classes" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Classes</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
            padding: 25px;
            text-align: center;
        }

        .header h1 {
            margin: 0;
            font-size: 2.5em;
            font-weight: 300;
        }

        .content {
            padding: 30px;
        }

        .search-panel {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            border-left: 5px solid #3498db;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #2c3e50;
        }

        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
            margin: 5px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1f639e);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }

        .btn-success {
            background: linear-gradient(135deg, #27ae60, #219a52);
            color: white;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #219a52, #1e8449);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(39, 174, 96, 0.3);
        }

        .btn-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #c0392b, #a93226);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
        }

        .btn-warning {
            background: linear-gradient(135deg, #f39c12, #e67e22);
            color: white;
        }

        .btn-warning:hover {
            background: linear-gradient(135deg, #e67e22, #d35400);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(243, 156, 18, 0.3);
        }

        .btn-info {
            background: linear-gradient(135deg, #17a2b8, #138496);
            color: white;
        }

        .btn-info:hover {
            background: linear-gradient(135deg, #138496, #117a8b);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(23, 162, 184, 0.3);
        }

        .gridview-container {
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .gridview {
            width: 100%;
            border-collapse: collapse;
        }

        .gridview th {
            background: linear-gradient(135deg, #34495e, #2c3e50);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            border: none;
        }

        .gridview td {
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .gridview tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .gridview tr:hover {
            background-color: #e3f2fd;
            transform: scale(1.01);
            transition: all 0.2s;
        }

        .status-active {
            color: #27ae60;
            font-weight: 600;
        }

        .status-inactive {
            color: #e74c3c;
            font-weight: 600;
        }

        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 12px;
        }

        .message {
            padding: 15px;
            margin: 15px 0;
            border-radius: 8px;
            font-weight: 600;
        }

        .success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .button-group {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }

        .search-row {
            display: flex;
            gap: 15px;
            align-items: end;
            flex-wrap: wrap;
        }

        .search-field {
            flex: 1;
            min-width: 200px;
        }

        @media (max-width: 768px) {
            .search-row {
                flex-direction: column;
            }
            
            .search-field {
                min-width: 100%;
            }
            
            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h1>📚 Class Management</h1>
            </div>
            
            <div class="content">
                <!-- Search Panel -->
                <div class="search-panel">
                    <h3 style="margin-top: 0; color: #2c3e50;">🔍 Search Classes</h3>
                    <div class="search-row">
                        <div class="form-group search-field">
                            <label for="txtSearchClassName">Class Name</label>
                            <asp:TextBox ID="txtSearchClassName" runat="server" CssClass="form-control" 
                                placeholder="Enter class name..."></asp:TextBox>
                        </div>
                        <div class="form-group search-field">
                            <label for="txtSearchSection">Section</label>
                            <asp:TextBox ID="txtSearchSection" runat="server" CssClass="form-control" 
                                placeholder="Enter section..."></asp:TextBox>
                        </div>
                        <div class="form-group search-field">
                            <label for="ddlStatus">Status</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">All Status</asp:ListItem>
                                <asp:ListItem Value="True">Active</asp:ListItem>
                                <asp:ListItem Value="False">Inactive</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <asp:Button ID="btnSearch" runat="server" Text="🔍 Search" CssClass="btn btn-primary" 
                                OnClick="btnSearch_Click" />
                            <asp:Button ID="btnClear" runat="server" Text="🔄 Clear" CssClass="btn btn-warning" 
                                OnClick="btnClear_Click" />
                        </div>
                    </div>
                </div>

                <!-- Message Display -->
                <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

                <!-- GridView -->
                <div class="gridview-container">
                    <asp:GridView ID="gvClasses" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="ClassID" CssClass="gridview"
                        OnRowEditing="gvClasses_RowEditing" 
                        OnRowUpdating="gvClasses_RowUpdating" 
                        OnRowCancelingEdit="gvClasses_RowCancelingEdit"
                        OnRowDeleting="gvClasses_RowDeleting"
                        AllowPaging="True" PageSize="10"
                        OnPageIndexChanging="gvClasses_PageIndexChanging">
                        <Columns>
                            <asp:TemplateField HeaderText="Class ID">
                                <ItemTemplate>
                                    <asp:Label ID="lblClassID" runat="server" Text='<%# Eval("ClassID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Class Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblClassName" runat="server" Text='<%# Eval("ClassName") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtClassName" runat="server" Text='<%# Bind("ClassName") %>' 
                                        CssClass="form-control" Width="90%"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Section">
                                <ItemTemplate>
                                    <asp:Label ID="lblSection" runat="server" Text='<%# Eval("Section") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtSection" runat="server" Text='<%# Bind("Section") %>' 
                                        CssClass="form-control" Width="90%"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Capacity">
                                <ItemTemplate>
                                    <asp:Label ID="lblCapacity" runat="server" Text='<%# Eval("Capacity") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtCapacity" runat="server" Text='<%# Bind("Capacity") %>' 
                                        CssClass="form-control" TextMode="Number" Width="90%"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Academic Year">
                                <ItemTemplate>
                                    <asp:Label ID="lblAcademicYear" runat="server" Text='<%# Eval("AcademicYear") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtAcademicYear" runat="server" Text='<%# Bind("AcademicYear") %>' 
                                        CssClass="form-control" Width="90%"></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <asp:Label ID="lblStatus" runat="server" 
                                        CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "status-active" : "status-inactive" %>'
                                        Text='<%# Convert.ToBoolean(Eval("IsActive")) ? "🟢 Active" : "🔴 Inactive" %>'>
                                    </asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:CheckBox ID="chkIsActive" runat="server" Checked='<%# Bind("IsActive") %>' 
                                        Text="Active" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Created Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblCreatedDate" runat="server" 
                                        Text='<%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="action-buttons">
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" 
                                            CssClass="btn btn-warning btn-sm" Text="✏️ Edit" />
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" 
                                            CssClass="btn btn-danger btn-sm" Text="🗑️ Delete" 
                                            OnClientClick="return confirm('Are you sure you want to delete this class?');" />
                                    </div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <div class="action-buttons">
                                        <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" 
                                            CssClass="btn btn-success btn-sm" Text="💾 Update" />
                                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" 
                                            CssClass="btn btn-warning btn-sm" Text="❌ Cancel" />
                                    </div>
                                </EditItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="gridview-pager" HorizontalAlign="Center" />
                        <EmptyDataTemplate>
                            <div style="text-align: center; padding: 20px; color: #666;">
                                <h3>No classes found</h3>
                                <p>No class records match your search criteria.</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>

                <!-- Action Buttons -->
                <div class="button-group">
                    <asp:Button ID="btnAddNew" runat="server" Text="➕ Add New Class" 
                        CssClass="btn btn-success" OnClick="btnAddNew_Click" />
                    <asp:Button ID="btnBack" runat="server" Text="🏠 Back to Dashboard" 
                        CssClass="btn btn-info" OnClick="btnBack_Click" />
                    <asp:Button ID="btnExport" runat="server" Text="📊 Export to Excel" 
                        CssClass="btn btn-primary" OnClick="btnExport_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>