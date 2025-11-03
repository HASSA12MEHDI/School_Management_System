<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Teacher_Add.aspx.cs" 
    Inherits="School_Management_System.Teacher_Add" MasterPageFile="~/Site1.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .teachers-management-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        /* Modern Glassmorphism Header */
        .page-header {
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header-content h1 {
            margin: 0 0 10px 0;
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-text-fill-color: transparent;
        }

        .header-content p {
            margin: 0;
            font-size: 1.1rem;
            color: #6c757d;
        }

        /* Modern Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .btn-modern {
            padding: 12px 25px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 700;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            min-width: 140px;
            position: relative;
            overflow: hidden;
        }

        .btn-modern::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn-modern:hover::before {
            left: 100%;
        }

        .btn-primary-modern {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-primary-modern:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
        }

        .btn-success-modern {
            background: linear-gradient(135deg, #00b09b 0%, #96c93d 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 176, 155, 0.4);
        }

        .btn-success-modern:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 176, 155, 0.6);
        }

        .btn-info-modern {
            background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(23, 162, 184, 0.4);
        }

        .btn-info-modern:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(23, 162, 184, 0.6);
        }

        .teachers-grid-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .teachers-grid-wrapper {
            width: 100%;
            overflow-x: auto;
            overflow-y: hidden;
        }

        .modern-grid {
            width: 100%;
            min-width: 1300px;
            border-collapse: separate;
            border-spacing: 0;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .modern-grid th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 18px 15px;
            text-align: left;
            font-weight: 700;
            font-size: 14px;
            border: none;
            position: sticky;
            top: 0;
            white-space: nowrap;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 3px solid rgba(255,255,255,0.3);
        }

        .modern-grid td {
            padding: 16px 15px;
            border-bottom: 1px solid rgba(241, 243, 244, 0.8);
            color: #2c3e50;
            font-size: 13px;
            transition: all 0.3s ease;
            white-space: nowrap;
            background: white;
            position: relative;
        }

        .modern-grid tr:hover td {
            background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);
            transform: scale(1.01);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.1);
        }

        /* Enhanced Profile Image */
        .profile-img-modern {
            width: 55px;
            height: 55px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #667eea;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            transition: all 0.4s ease;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .profile-img-modern:hover {
            transform: scale(1.15) rotate(5deg);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
        }

        /* Enhanced Status Styles */
        .status-badge {
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 12px;
            font-weight: 700;
            display: inline-block;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-active {
            background: linear-gradient(135deg, #00b09b, #96c93d);
            color: white;
        }

        .status-inactive {
            background: linear-gradient(135deg, #ff416c, #ff4b2b);
            color: white;
        }

        /* Salary Styling */
        .salary-amount {
            font-weight: 800;
            color: #27ae60;
            font-size: 14px;
            background: linear-gradient(135deg, #e8f5e9, #f1f8e9);
            padding: 8px 12px;
            border-radius: 10px;
            display: inline-block;
            box-shadow: 0 2px 8px rgba(39, 174, 96, 0.2);
        }

        /* Modern Action Buttons */
        .action-buttons-modern {
            display: flex;
            gap: 8px;
            justify-content: center;
            flex-wrap: nowrap;
        }

        .btn-action-modern {
            padding: 8px 14px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 700;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            min-width: 35px;
            justify-content: center;
            color: white;
            box-shadow: 0 3px 8px rgba(0,0,0,0.2);
        }

        .btn-edit-modern {
            background: linear-gradient(135deg, #f7971e, #ffd200);
        }

        .btn-edit-modern:hover {
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 6px 15px rgba(247, 151, 30, 0.4);
        }

        .btn-delete-modern {
            background: linear-gradient(135deg, #ff416c, #ff4b2b);
        }

        .btn-delete-modern:hover {
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 6px 15px rgba(255, 65, 108, 0.4);
        }

        .btn-view-modern {
            background: linear-gradient(135deg, #2193b0, #6dd5ed);
        }

        .btn-view-modern:hover {
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 6px 15px rgba(33, 147, 176, 0.4);
        }

        /* Alert Styles */
        .alert {
            padding: 15px;
            margin: 15px 0;
            border-radius: 10px;
            font-weight: 600;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .alert-warning {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        /* Custom Scrollbar */
        .teachers-grid-wrapper::-webkit-scrollbar {
            height: 10px;
        }

        .teachers-grid-wrapper::-webkit-scrollbar-track {
            background: rgba(241, 241, 241, 0.8);
            border-radius: 8px;
        }

        .teachers-grid-wrapper::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        .teachers-grid-wrapper::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(135deg, #764ba2, #667eea);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .teachers-management-container {
                padding: 15px;
            }
            
            .page-header {
                padding: 20px;
            }

            .header-content h1 {
                font-size: 2rem;
            }

            .modern-grid {
                min-width: 1100px;
            }
            
            .btn-modern {
                padding: 10px 20px;
                font-size: 13px;
                min-width: 120px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="teachers-management-container">
      
        <div class="page-header">
            <div class="header-content">
                <h1>🏫 Teacher Management System</h1>
                <p>Comprehensive overview and management of teaching staff</p>
                <div class="action-buttons">
                    <asp:Button ID="BtnAddTeacher" PostBackUrl="~/Add_Teachers.aspx" runat="server" Text="➕ Add New Teacher" 
                        CssClass="btn-modern btn-success-modern" OnClick="BtnAddTeacher_Click" />
                    <asp:Button ID="BtnExportExcel" runat="server" Text="📊 Export to Excel" 
                        CssClass="btn-modern btn-primary-modern" OnClick="BtnExportExcel_Click" />
                    <asp:Button ID="BtnRefresh" runat="server" Text="🔄 Refresh Data" 
                        CssClass="btn-modern btn-info-modern" OnClick="BtnRefresh_Click" />
                </div>
            </div>
        </div>

        <asp:Panel ID="PnlMessage" runat="server" Visible="false" CssClass="alert">
            <asp:Label ID="LblMessage" runat="server" Text=""></asp:Label>
        </asp:Panel>

       
        <div class="teachers-grid-container">
            <div class="teachers-grid-wrapper">
            <asp:GridView ID="GvTeachers" runat="server" 
    CssClass="modern-grid"
    AutoGenerateColumns="False" 
    AllowPaging="True" 
    PageSize="10"
    OnPageIndexChanging="GvTeachers_PageIndexChanging"
    OnRowEditing="GvTeachers_RowEditing"
    OnRowUpdating="GvTeachers_RowUpdating"
    OnRowCancelingEdit="GvTeachers_RowCancelingEdit"
    OnRowDeleting="GvTeachers_RowDeleting"
    OnRowDataBound="GvTeachers_RowDataBound"
    DataKeyNames="TeacherId"
    EmptyDataText="No teacher records found.">
    
    <Columns>
        
        <asp:TemplateField HeaderText="🖼️ Profile" ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
            <ItemTemplate>
                <asp:Image ID="ImgProfile" runat="server" 
                    ImageUrl='<%# GetProfileImage(Eval("profilepic")) %>'
                    CssClass="profile-img-modern" 
                    AlternateText="Profile Picture"
                    onerror="this.src='images/default-teacher.png';" />
            </ItemTemplate>
            <EditItemTemplate>
                <div style="text-align: center;">
                    
                    <asp:Image ID="ImgCurrentProfile" runat="server" 
                        ImageUrl='<%# GetProfileImage(Eval("profilepic")) %>'
                        CssClass="profile-img-modern" 
                        AlternateText="Current Profile"
                        onerror="this.src='images/default-teacher.png';"
                        style="margin-bottom: 10px;" />
                    <br />
                    
                    
                    <asp:FileUpload ID="FileUploadProfile" runat="server" 
                        CssClass="form-control" 
                        accept=".jpg,.jpeg,.png,.gif"
                        ToolTip="Select new profile picture" />
                    

                    <asp:HiddenField ID="HdnCurrentProfilePic" runat="server" 
                        Value='<%# Eval("profilepic") %>' />
                        
                    <small style="display: block; margin-top: 5px; color: #666;">
                        Max: 2MB (JPG, PNG, GIF)
                    </small>
                </div>
            </EditItemTemplate>
        </asp:TemplateField>
        
    
        <asp:TemplateField HeaderText="🆔 Employee ID" ItemStyle-Width="130px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
            <ItemTemplate>
                <%# Eval("EmployeeId") %>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="TxtEmployeeId" runat="server" Text='<%# Bind("EmployeeId") %>' 
                    CssClass="form-control" Width="120px"></asp:TextBox>
            </EditItemTemplate>
        </asp:TemplateField>
        
      
        <asp:TemplateField HeaderText="👤 Teacher Name" ItemStyle-Width="180px" HeaderStyle-HorizontalAlign="Center">
            <ItemTemplate>
                <div style="font-weight: 700; color: #2c3e50; font-size: 14px;">
                    <%# Eval("FirstName") %> <%# Eval("LastName") %>
                </div>
                <div style="font-size: 12px; color: #7f8c8d; margin-top: 4px;">
                    ID: <%# Eval("TeacherId") %>
                </div>
            </ItemTemplate>
            <EditItemTemplate>
                <div style="display: flex; flex-direction: column; gap: 5px;">
                    <asp:TextBox ID="TxtFirstName" runat="server" Text='<%# Bind("FirstName") %>' 
                        CssClass="form-control" Placeholder="First Name" Width="160px"></asp:TextBox>
                    <asp:TextBox ID="TxtLastName" runat="server" Text='<%# Bind("LastName") %>' 
                        CssClass="form-control" Placeholder="Last Name" Width="160px"></asp:TextBox>
                </div>
            </EditItemTemplate>
        </asp:TemplateField>
        
      
        <asp:TemplateField HeaderText="📞 Contact Info" ItemStyle-Width="200px" HeaderStyle-HorizontalAlign="Center">
            <ItemTemplate>
                <div style="font-size: 13px; line-height: 1.5;">
                    <div style="margin-bottom: 6px;">
                        <i class="fas fa-envelope" style="color: #667eea; margin-right: 6px;"></i> 
                        <%# Eval("Email") %>
                    </div>
                    <div>
                        <i class="fas fa-phone" style="color: #28a745; margin-right: 6px;"></i> 
                        <%# Eval("Phone") %>
                    </div>
                </div>
            </ItemTemplate>
            <EditItemTemplate>
                <div style="display: flex; flex-direction: column; gap: 5px;">
                    <asp:TextBox ID="TxtEmail" runat="server" Text='<%# Bind("Email") %>' 
                        CssClass="form-control" Width="180px" TextMode="Email" Placeholder="Email"></asp:TextBox>
                    <asp:TextBox ID="TxtPhone" runat="server" Text='<%# Bind("Phone") %>' 
                        CssClass="form-control" Width="180px" Placeholder="Phone"></asp:TextBox>
                </div>
            </EditItemTemplate>
        </asp:TemplateField>
        
        
        <asp:TemplateField HeaderText="🎓 Professional Details" ItemStyle-Width="220px" HeaderStyle-HorizontalAlign="Center">
            <ItemTemplate>
                <div style="font-size: 13px; line-height: 1.5;">
                    <div style="margin-bottom: 4px;">
                        <strong>Qualification:</strong> <%# Eval("Qualification") %>
                    </div>
                    <div>
                        <strong>Experience:</strong> <%# Eval("Experience") %> years
                    </div>
                </div>
            </ItemTemplate>
            <EditItemTemplate>
                <div style="display: flex; flex-direction: column; gap: 5px;">
                    <asp:TextBox ID="TxtQualification" runat="server" Text='<%# Bind("Qualification") %>' 
                        CssClass="form-control" Width="200px" Placeholder="Qualification"></asp:TextBox>
                    <asp:TextBox ID="TxtExperience" runat="server" Text='<%# Bind("Experience") %>' 
                        CssClass="form-control" Width="200px" TextMode="Number" Placeholder="Experience Years"></asp:TextBox>
                </div>
            </EditItemTemplate>
        </asp:TemplateField>
        

        <asp:TemplateField HeaderText="💰 Monthly Salary" ItemStyle-Width="130px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
            <ItemTemplate>
                <div class="salary-amount">
                    ₹<%# FormatSalary(Eval("Salary")) %></div>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="TxtSalary" runat="server" Text='<%# Bind("Salary", "{0:F2}") %>' 
                    CssClass="form-control" Width="120px" TextMode="Number" step="0.01" Placeholder="Salary"></asp:TextBox>
            </EditItemTemplate>
        </asp:TemplateField>
        
       
        <asp:TemplateField HeaderText="📅 Joining Date" ItemStyle-Width="140px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
            <ItemTemplate>
                <div style="font-weight: 600; color: #2c3e50; font-size: 13px; padding: 8px; background: linear-gradient(135deg, #f0f8ff, #e3f2fd); border-radius: 8px;">
                    <%# FormatDate(Eval("JoiningDate")) %>
                </div>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="TxtJoiningDate" runat="server" Text='<%# Bind("JoiningDate", "{0:yyyy-MM-dd}") %>' 
                    CssClass="form-control" Width="130px" TextMode="Date"></asp:TextBox>
            </EditItemTemplate>
        </asp:TemplateField>
        
        
        <asp:TemplateField HeaderText="📊 Status" ItemStyle-Width="110px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
            <ItemTemplate>
                <span class='<%# GetStatusClass(Eval("IsActive")) %> status-badge'>
                    <%# GetStatusText(Eval("IsActive")) %>
                </span>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:CheckBox ID="ChkIsActive" runat="server" Checked='<%# Bind("IsActive") %>' 
                    Text="Active" CssClass="form-check-input" />
            </EditItemTemplate>
        </asp:TemplateField>
        
        
        <asp:TemplateField HeaderText="⚡ Actions" ItemStyle-Width="210px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
            <ItemTemplate>
                <div class="action-buttons-modern">
                    <asp:LinkButton ID="BtnEdit" runat="server" 
                        CommandName="Edit" 
                        CssClass="btn-action-modern btn-edit-modern"
                        ToolTip="Edit Teacher">
                        <i class="fas fa-edit"></i> Edit
                    </asp:LinkButton>
                    
                    <asp:LinkButton ID="BtnDelete" runat="server" 
                        CommandName="Delete" 
                        CssClass="btn-action-modern btn-delete-modern"
                        ToolTip="Delete Teacher"
                        OnClientClick='<%# "return confirm(\"Are you sure you want to delete teacher: " + Eval("FirstName") + " " + Eval("LastName") + "?\");" %>'>
                        <i class="fas fa-trash"></i> Delete
                    </asp:LinkButton>

                    <asp:LinkButton ID="BtnView" runat="server" 
                        CommandName="View" 
                        CssClass="btn-action-modern btn-view-modern"
                        ToolTip="View Details"
                        CommandArgument='<%# Container.DataItemIndex %>'>
                        <i class="fas fa-eye"></i> View
                    </asp:LinkButton>
                </div>
            </ItemTemplate>
            <EditItemTemplate>
                <div class="action-buttons-modern">
                    <asp:LinkButton ID="BtnUpdate" runat="server" 
                        CommandName="Update" 
                        CssClass="btn-action-modern" 
                        style="background: linear-gradient(135deg, #28a745, #20c997); color: white;"
                        ToolTip="Update Changes">
                        <i class="fas fa-save"></i> Update
                    </asp:LinkButton>
                    
                    <asp:LinkButton ID="BtnCancel" runat="server" 
                        CommandName="Cancel" 
                        CssClass="btn-action-modern" 
                        style="background: linear-gradient(135deg, #6c757d, #868e96); color: white;"
                        ToolTip="Cancel Edit">
                        <i class="fas fa-times"></i> Cancel
                    </asp:LinkButton>
                </div>
            </EditItemTemplate>
        </asp:TemplateField>
    </Columns>
    
    <PagerStyle CssClass="grid-pager" HorizontalAlign="Center" />
    
    <EmptyDataTemplate>
        <div style="text-align: center; padding: 60px 20px; color: #7f8c8d;">
            <i class="fas fa-users" style="font-size: 4rem; margin-bottom: 20px; color: #bdc3c7;"></i>
            <h3 style="margin: 0 0 10px 0; font-size: 1.5rem; color: #7f8c8d;">No Teachers Found</h3>
            <p style="margin: 0; font-size: 1rem;">No teacher records match your search criteria.</p>
        </div>
    </EmptyDataTemplate>
</asp:GridView>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function handleImageError(img) {
            img.src = 'images/default-teacher.png';
            img.onerror = null;
        }

        document.addEventListener('DOMContentLoaded', function () {
            const images = document.querySelectorAll('.profile-img-modern');
            images.forEach(function (img) {
                img.onerror = function () {
                    handleImageError(this);
                };
            });
        });
    </script>
</asp:Content>