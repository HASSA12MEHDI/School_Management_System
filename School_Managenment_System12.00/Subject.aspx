<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Subject.aspx.cs" 
    Inherits="School_Managenment_System12._00.Subjects" MasterPageFile="~/Site1.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .subjects-container {
            max-width: 100%;
            margin: 0 auto;
        }

        .page-header {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 20px;
        }

        .header-content h1 {
            color: #4361ee;
            margin-bottom: 5px;
            font-size: 28px;
        }

        .header-content p {
            color: #666;
            font-size: 16px;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        /* Form Styles */
        .form-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
            border: 1px solid rgba(0,0,0,0.05);
        }

        .form-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eaeaea;
        }

        .section-title {
            font-size: 20px;
            color: #4361ee;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 10px;
            font-size: 22px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
            font-size: 14px;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s;
            background-color: #f9f9f9;
        }

        .form-control:focus {
            border-color: #4361ee;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
            outline: none;
            background-color: white;
        }

        .textarea-control {
            min-height: 100px;
            resize: vertical;
        }

        /* Button Styles */
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn i {
            font-size: 16px;
        }

        .btn-success {
            background: linear-gradient(to right, #00b09b, #96c93d);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 176, 155, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 176, 155, 0.4);
        }

        .btn-primary {
            background: linear-gradient(to right, #2193b0, #6dd5ed);
            color: white;
            box-shadow: 0 4px 15px rgba(33, 147, 176, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(33, 147, 176, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(to right, #8e9eab, #eef2f3);
            color: #333;
            box-shadow: 0 4px 15px rgba(142, 158, 171, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(142, 158, 171, 0.4);
        }

        .btn-danger {
            background: linear-gradient(to right, #ff416c, #ff4b2b);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 65, 108, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 65, 108, 0.4);
        }

        .btn-warning {
            background: linear-gradient(to right, #f7971e, #ffd200);
            color: white;
            box-shadow: 0 4px 15px rgba(247, 151, 30, 0.3);
        }

        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(247, 151, 30, 0.4);
        }

        .action-buttons-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 30px;
        }

       
        .alert {
            padding: 15px;
            margin: 15px 0;
            border-radius: 8px;
            font-weight: 500;
        }

        .alert-success {
            background: #e8f5e9;
            color: #2e7d32;
            border-left: 4px solid #4caf50;
        }

        .alert-danger {
            background: #ffebee;
            color: #c62828;
            border-left: 4px solid #f44336;
        }

        .alert-info {
            background: #e3f2fd;
            color: #1565c0;
            border-left: 4px solid #2196f3;
        }

      
        .required::after {
            content: " *";
            color: #e74c3c;
        }

        .field-hint {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            display: block;
        }

       
        .subjects-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .subjects-grid th {
            background: #4361ee;
            color: white;
            padding: 12px 8px;
            text-align: left;
            font-weight: bold;
            border: 1px solid #3a56d4;
        }

        .subjects-grid td {
            padding: 10px 8px;
            border: 1px solid #ddd;
            color: #333;
        }

        .subjects-grid tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .subjects-grid tr:hover {
            background-color: #e8f4fc;
            transition: background-color 0.3s;
        }

        .action-column {
            text-align: center;
            width: 120px;
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 12px;
            margin: 2px;
        }

       
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons-grid {
                grid-template-columns: 1fr;
            }

            .page-header {
                flex-direction: column;
                text-align: center;
            }

            .action-buttons {
                justify-content: center;
            }

            .form-container {
                padding: 20px;
            }

            .subjects-grid {
                font-size: 14px;
            }
        }

        /* Status Indicator */
        .status-active {
            color: #28a745;
            font-weight: bold;
        }

        .status-inactive {
            color: #dc3545;
            font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="subjects-container">
        
        <div class="page-header">
            <div class="header-content">
                <h1><i class="fas fa-book"></i> Subject Management</h1>
                <p>Add and manage academic subjects</p>
            </div>
            <div class="action-buttons">
                <asp:Button ID="BtnAddNew" runat="server" Text="Add New Subject" 
                    CssClass="btn btn-primary" OnClick="BtnAddNew_Click" />
                <asp:Button ID="BtnViewAll" runat="server" Text="View All Subjects" 
                    CssClass="btn btn-secondary" OnClick="BtnViewAll_Click" />
                <asp:Button ID="BtnExport" runat="server" Text="Export Data" 
                    CssClass="btn btn-success" OnClick="BtnExport_Click" />
            </div>
        </div>

        
        <asp:Label ID="LblMessage" runat="server" Visible="false" CssClass="alert"></asp:Label>

        
        <div class="form-container" id="SubjectForm" runat="server">
            <div class="form-section">
                <div class="section-title">
                    <i class="fas fa-info-circle"></i> Basic Information
                </div>
                
                <div class="form-grid">
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label required" Text="Subject Name"></asp:Label>
                        <asp:TextBox ID="TxtSubjectName" runat="server" CssClass="form-control" 
                            placeholder="Enter subject name" MaxLength="100"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label required" Text="Subject Code"></asp:Label>
                        <asp:TextBox ID="TxtSubjectCode" runat="server" CssClass="form-control" 
                            placeholder="e.g., MATH-101" MaxLength="20"></asp:TextBox>
                        <span class="field-hint">Unique code for the subject</span>
                    </div>
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label" Text="Description"></asp:Label>
                    <asp:TextBox ID="TxtDescription" runat="server" CssClass="form-control textarea-control" 
                        TextMode="MultiLine" placeholder="Enter subject description" MaxLength="255"></asp:TextBox>
                </div>
            </div>

            
            <div class="form-section">
                <div class="section-title">
                    <i class="fas fa-link"></i> Class Information
                </div>
                
                <div class="form-grid">
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label required" Text="Class"></asp:Label>
                        <asp:DropDownList ID="DdlClass" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">Select Class</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="form-group">
                    <asp:CheckBox ID="ChkIsActive" runat="server" Text=" Active Subject" 
                        CssClass="form-checkbox" Checked="true" />
                    <span class="field-hint">Uncheck to make subject inactive</span>
                </div>
            </div>

            
            <div class="action-buttons-grid">
                <asp:Button ID="BtnSave" runat="server" Text="Save Subject" 
                    CssClass="btn btn-success" OnClick="BtnSave_Click" />
                <asp:Button ID="BtnUpdate" runat="server" Text="Update Subject" 
                    CssClass="btn btn-warning" OnClick="BtnUpdate_Click" Visible="false" />
                <asp:Button ID="BtnClear" runat="server" Text="Clear Form" 
                    CssClass="btn btn-secondary" OnClick="BtnClear_Click" />
                <asp:Button ID="BtnCancel" runat="server" Text="Cancel" 
                    CssClass="btn btn-danger" OnClick="BtnCancel_Click" Visible="false" />
            </div>
        </div>


        <div class="form-container">
            <div class="section-title">
                <i class="fas fa-list"></i> All Subjects
            </div>
            
            <asp:GridView ID="GvSubjects" runat="server" 
                CssClass="subjects-grid"
                AutoGenerateColumns="False"
                DataKeyNames="SubjectId"
                OnRowEditing="GvSubjects_RowEditing"
                OnRowDeleting="GvSubjects_RowDeleting"
                OnRowDataBound="GvSubjects_RowDataBound"
                EmptyDataText="No subjects found.">
                <Columns>
                    <asp:BoundField DataField="SubjectId" HeaderText="ID" ItemStyle-Width="60px" />
                    <asp:BoundField DataField="SubjectName" HeaderText="Subject Name" />
                    <asp:BoundField DataField="SubjectCode" HeaderText="Subject Code" />
                    <asp:BoundField DataField="Description" HeaderText="Description" />
                    <asp:BoundField DataField="ClassName" HeaderText="Class" />
                    
                    <asp:TemplateField HeaderText="Status" ItemStyle-Width="80px">
                        <ItemTemplate>
                            <asp:Label ID="LblStatus" runat="server" 
                                CssClass='<%# Eval("IsActive").ToString() == "True" ? "status-active" : "status-inactive" %>'
                                Text='<%# Eval("IsActive").ToString() == "True" ? "Active" : "Inactive" %>'>
                            </asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="action-column">
                        <ItemTemplate>
                            <asp:Button ID="BtnEdit" runat="server" Text="Edit" 
                                CssClass="btn btn-sm btn-primary" CommandName="Edit" />
                            <asp:Button ID="BtnDelete" runat="server" Text="Delete" 
                                CssClass="btn btn-sm btn-danger" CommandName="Delete" 
                                OnClientClick="return confirm('Are you sure you want to delete this subject?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>


    <script type="text/javascript">
        
        function validateForm() {
            var requiredFields = document.querySelectorAll('.required');
            var isValid = true;

            requiredFields.forEach(function (field) {
                var input = field.closest('.form-group').querySelector('input, select');
                if (input && !input.value) {
                    isValid = false;
                    input.style.borderColor = '#e74c3c';
                } else if (input) {
                    input.style.borderColor = '#ddd';
                }
            });

            return isValid;
        }

        
        document.addEventListener('DOMContentLoaded', function () {
            var form = document.getElementById('<%= SubjectForm.ClientID %>');
            if (form) {
                form.addEventListener('submit', function (e) {
                    if (!validateForm()) {
                        e.preventDefault();
                        alert('Please fill in all required fields marked with *.');
                    }
                });
            }
        });

        
        function generateSubjectCode() {
            var subjectName = document.getElementById('<%= TxtSubjectName.ClientID %>');
            var subjectCode = document.getElementById('<%= TxtSubjectCode.ClientID %>');
            
            if (subjectName && subjectCode && !subjectCode.value) {
                var name = subjectName.value.trim();
                if (name.length > 0) {
                    // Generate code: first 3-4 letters of each word, uppercase
                    var words = name.split(' ');
                    var code = '';
                    for (var i = 0; i < Math.min(words.length, 2); i++) {
                        if (words[i].length > 0) {
                            code += words[i].substring(0, Math.min(4, words[i].length)).toUpperCase();
                        }
                    }
                    subjectCode.value = code + '-101';
                }
            }
        }

        
        document.addEventListener('DOMContentLoaded', function () {
            var subjectName = document.getElementById('<%= TxtSubjectName.ClientID %>');
            if (subjectName) {
                subjectName.addEventListener('blur', generateSubjectCode);
            }
        });
    </script>
</asp:Content>