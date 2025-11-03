<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Add_Student.aspx.cs" 
    Inherits="School_Managenment_System12._00.Add_Student" MasterPageFile="~/Site1.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Base styles */
        body {
            scroll-behavior: smooth;
        }
        
        .form-container {
            max-width: 100%;
            margin: 0 auto;
            padding: 20px;
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
            position: relative;
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
            background-color: #f9f9f9;
            /* Removed transition to prevent jumping */
        }
        
        .form-control:focus {
            border-color: #4361ee;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
            outline: none;
            background-color: white;
        }
        
        .roll-number-container {
            display: flex;
            gap: 15px;
            align-items: flex-end;
        }
        
        .roll-number-container .form-control {
            flex: 1;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            /* Removed transform transition to prevent jumping */
            white-space: nowrap;
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
            box-shadow: 0 6px 20px rgba(0, 176, 155, 0.4);
        }
        
        .btn-primary {
            background: linear-gradient(to right, #2193b0, #6dd5ed);
            color: white;
            box-shadow: 0 4px 15px rgba(33, 147, 176, 0.3);
        }
        
        .btn-primary:hover {
            box-shadow: 0 6px 20px rgba(33, 147, 176, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(to right, #8e9eab, #eef2f3);
            color: #333;
            box-shadow: 0 4px 15px rgba(142, 158, 171, 0.3);
        }
        
        .btn-secondary:hover {
            box-shadow: 0 6px 20px rgba(142, 158, 171, 0.4);
        }
        
        .btn-danger {
            background: linear-gradient(to right, #ff416c, #ff4b2b);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 65, 108, 0.3);
        }
        
        .btn-danger:hover {
            box-shadow: 0 6px 20px rgba(255, 65, 108, 0.4);
        }
        
        .btn-purple {
            background: linear-gradient(to right, #834d9b, #d04ed6);
            color: white;
            box-shadow: 0 4px 15px rgba(131, 77, 155, 0.3);
        }
        
        .btn-purple:hover {
            box-shadow: 0 6px 20px rgba(131, 77, 155, 0.4);
        }
        
        .action-buttons {
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
        
        .class-section {
            background: #f0f4ff;
            padding: 20px;
            border-radius: 10px;
            margin-top: 10px;
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
        
        .form-header {
            margin-bottom: 30px;
            text-align: center;
        }
        
        .form-header h2 {
            color: #4361ee;
            margin-bottom: 10px;
            font-size: 28px;
        }
        
        .form-header p {
            color: #666;
            font-size: 16px;
        }
        
        /* Fix for mobile devices */
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                grid-template-columns: 1fr;
            }
            
            .roll-number-container {
                flex-direction: column;
                gap: 10px;
            }
            
            .roll-number-container .btn {
                margin-top: 0;
            }
        }
        
        /* Fix for input focus jumping */
        input:focus, select:focus, textarea:focus {
            outline: none;
        }
        
        /* Prevent page scroll on focus */
        .form-control {
            position: relative;
            z-index: 1;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="form-container">
        <div class="form-header">
            <h2><i class="fas fa-user-graduate"></i> Add New Student</h2>
            <p>Complete the form below to register a new student in the system</p>
        </div>
        
        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert"></asp:Label>

        <div class="form-section">
            <div class="section-title">
                <i class="fas fa-user"></i> Personal Information
            </div>
            
            <div class="form-group">
                <div class="roll-number-container">
                    <div style="flex: 1;">
                        <asp:Label runat="server" CssClass="form-label required" Text="Roll Number"></asp:Label>
                        <asp:TextBox ID="txtRollNumber" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                        <span class="field-hint">Click Generate to create a unique roll number</span>
                    </div>
                    <div style="margin-top: 24px;">
                        <asp:Button ID="btnGenerateRollNumber" runat="server" Text="Generate" 
                            CssClass="btn btn-purple" OnClick="BtnGenerateRollNumber_Click" />
                    </div>
                </div>
            </div>
            
            <div class="form-grid">
                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="First Name"></asp:Label>
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="Enter first name"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="Last Name"></asp:Label>
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Enter last name"></asp:TextBox>
                </div>
            </div>
            
            <div class="form-grid">
                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="Email"></asp:Label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="student@example.com"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="Phone Number"></asp:Label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" 
                        MaxLength="11" placeholder="03XXXXXXXXX"
                        onkeypress="return isNumberKey(event)"></asp:TextBox>
                    <span class="field-hint">11-digit number without dashes or spaces</span>
                </div>
            </div>
            
            <div class="form-grid">
                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="Date of Birth"></asp:Label>
                    <asp:TextBox ID="txtDateOfBirth" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="Gender"></asp:Label>
                    <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">Select Gender</asp:ListItem>
                        <asp:ListItem Value="Male">Male</asp:ListItem>
                        <asp:ListItem Value="Female">Female</asp:ListItem>
                        <asp:ListItem Value="Other">Other</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            
            <div class="form-grid">
                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="Blood Group"></asp:Label>
                    <asp:DropDownList ID="ddlBloodGroup" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">Select Blood Group</asp:ListItem>
                        <asp:ListItem Value="A+">A+</asp:ListItem>
                        <asp:ListItem Value="A-">A-</asp:ListItem>
                        <asp:ListItem Value="B+">B+</asp:ListItem>
                        <asp:ListItem Value="B-">B-</asp:ListItem>
                        <asp:ListItem Value="AB+">AB+</asp:ListItem>
                        <asp:ListItem Value="AB-">AB-</asp:ListItem>
                        <asp:ListItem Value="O+">O+</asp:ListItem>
                        <asp:ListItem Value="O-">O-</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="Admission Date"></asp:Label>
                    <asp:TextBox ID="txtAdmissionDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                </div>
            </div>
            
            <div class="form-group">
                <asp:Label runat="server" CssClass="form-label required" Text="Address"></asp:Label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Enter complete address"></asp:TextBox>
            </div>
        </div>

        <div class="form-section">
            <div class="section-title">
                <i class="fas fa-users"></i> Parent Information
            </div>
            
            <div class="form-grid">
                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="Father's Name"></asp:Label>
                    <asp:TextBox ID="txtFatherName" runat="server" CssClass="form-control" placeholder="Enter father's name"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="Mother's Name"></asp:Label>
                    <asp:TextBox ID="txtMotherName" runat="server" CssClass="form-control" placeholder="Enter mother's name"></asp:TextBox>
                </div>
            </div>
            
            <div class="form-group">
                <asp:Label runat="server" CssClass="form-label required" Text="Parent's Phone Number"></asp:Label>
                <asp:TextBox ID="txtParentPhone" runat="server" CssClass="form-control" 
                    MaxLength="11" placeholder="03XXXXXXXXX"
                    onkeypress="return isNumberKey(event)"></asp:TextBox>
                <span class="field-hint">11-digit number without dashes or spaces</span>
            </div>
        </div>

        <div class="form-section">
            <div class="section-title">
                <i class="fas fa-chalkboard-teacher"></i> Class Information
            </div>
            
            <div class="class-section">
                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="Class"></asp:Label>
                    <asp:DropDownList ID="ddlClass" runat="server" CssClass="form-control" 
                        AutoPostBack="true" OnSelectedIndexChanged="DdlClass_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
            </div>
        </div>

        <div class="action-buttons">
            <asp:Button ID="btnSave" runat="server" Text="Save Student" CssClass="btn btn-success" OnClick="BtnSave_Click" />
            <asp:Button ID="btnSaveAndAdd" runat="server" Text="Save & Add Another" CssClass="btn btn-primary" OnClick="BtnSaveAndAdd_Click" />
            <asp:Button ID="btnViewStudents" runat="server" Text="View Students" CssClass="btn btn-secondary" OnClick="BtnViewStudents_Click" PostBackUrl="~/View_Student.aspx" />
            <asp:Button ID="btnQuickClasses" runat="server" Text="Manage Classes" CssClass="btn btn-purple" OnClick="BtnQuickClasses_Click" PostBackUrl="~/Veiw_Classes.aspx" />
        </div>
    </div>

    <script type="text/javascript">
        // Prevent page from jumping when clicking on form elements
        document.addEventListener('DOMContentLoaded', function () {
            // Store current scroll position
            var scrollPosition = window.pageYOffset || document.documentElement.scrollTop;

            // Restore scroll position after postback
            if (document.getElementById('__EVENTTARGET')) {
                window.scrollTo(0, scrollPosition);
            }

            // Set default admission date to today
            var admissionDate = document.getElementById('<%= txtAdmissionDate.ClientID %>');
            if (admissionDate && !admissionDate.value) {
                var today = new Date();
                var formattedDate = today.toISOString().split('T')[0];
                admissionDate.value = formattedDate;
            }

            // Phone number formatting
            var phoneInputs = document.querySelectorAll('input[id*="txtPhone"], input[id*="txtParentPhone"]');
            phoneInputs.forEach(function (input) {
                input.addEventListener('input', function () {
                    formatPhoneNumber(this);
                });
            });
        });

        // Maintain scroll position on postback
        window.addEventListener('beforeunload', function () {
            sessionStorage.setItem('scrollPosition', window.pageYOffset || document.documentElement.scrollTop);
        });

        window.addEventListener('load', function () {
            if (sessionStorage.getItem('scrollPosition')) {
                window.scrollTo(0, parseInt(sessionStorage.getItem('scrollPosition')));
                sessionStorage.removeItem('scrollPosition');
            }
        });

        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;
            return true;
        }

        function formatPhoneNumber(input) {
            var phone = input.value.replace(/\D/g, '');

            if (phone.length > 11) {
                phone = phone.substring(0, 11);
            }

            input.value = phone;
        }

        // Form validation without causing visual changes
        function validateForm() {
            var requiredFields = document.querySelectorAll('.required');
            var isValid = true;
            var firstInvalidField = null;

            requiredFields.forEach(function (field) {
                var input = field.closest('.form-group').querySelector('input, select, textarea');
                if (input && !input.value.trim()) {
                    isValid = false;
                    if (!firstInvalidField) {
                        firstInvalidField = input;
                    }
                }
            });

            if (!isValid && firstInvalidField) {
                // Focus on the first invalid field without scrolling
                firstInvalidField.focus();
                alert('Please fill in all required fields marked with *.');
            }

            return isValid;
        }
    </script>
</asp:Content>