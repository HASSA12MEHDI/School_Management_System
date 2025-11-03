<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="New_User.aspx.cs" Inherits="School_Managenment_System12._00.New_User" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Registration - School System</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3a0ca3;
            --success-color: #4cc9f0;
            --danger-color: #f72585;
            --light-color: #f8f9fa;
            --dark-color: #1d3557;
            --border-radius: 12px;
            --box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }
        
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .registration-container {
            width: 100%;
            max-width: 900px;
        }
        
        .registration-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .registration-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .registration-header h1 {
            margin: 0;
            font-size: 32px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }
        
        .registration-header p {
            margin: 10px 0 0;
            opacity: 0.9;
            font-size: 16px;
        }
        
        .registration-body {
            padding: 40px;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .profile-section {
            grid-column: 1 / -1;
            display: grid;
            grid-template-columns: 200px 1fr;
            gap: 30px;
            align-items: start;
        }
        
        .full-width {
            grid-column: 1 / -1;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--dark-color);
        }
        
        .form-label i {
            color: var(--primary-color);
            font-size: 14px;
        }
        
        .form-control {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e8ecef;
            border-radius: var(--border-radius);
            font-size: 15px;
            transition: all 0.3s ease;
            background: #fafbfc;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(67, 97, 238, 0.15);
            background: white;
        }
        
        .input-group {
            position: relative;
            display: flex;
            align-items: center;
        }
        
        .input-group-text {
            background: #f8f9fa;
            border: 2px solid #e8ecef;
            border-right: none;
            padding: 14px 16px;
            border-radius: var(--border-radius) 0 0 var(--border-radius);
            color: #6c757d;
        }
        
        .input-group .form-control {
            border-left: none;
            border-radius: 0 var(--border-radius) var(--border-radius) 0;
        }
        
        .validation-container {
            height: 22px;
            margin-top: 5px;
        }
        
        .validator {
            color: var(--danger-color);
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-size: 15px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            box-shadow: 0 4px 15px rgba(67, 97, 238, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(67, 97, 238, 0.4);
        }
        
        .btn-outline {
            background: transparent;
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
        }
        
        .btn-outline:hover {
            background: var(--primary-color);
            color: white;
        }
        
        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 30px;
            justify-content: center;
        }
        
        .alert {
            padding: 16px 20px;
            border-radius: var(--border-radius);
            margin-bottom: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
            border: none;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        .alert-success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
        }
        
        .alert-info {
            background: linear-gradient(135deg, #d1ecf1, #c6e9f0);
            color: #0c5460;
        }
        
        .login-link {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e8ecef;
        }
        
        /* Profile Picture Styles */
        .profile-picture-container {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: var(--border-radius);
            border: 2px dashed #dee2e6;
        }
        
        .profile-picture-preview {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--primary-color);
            margin-bottom: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .profile-placeholder {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 48px;
            margin: 0 auto 15px;
            border: 4px solid var(--primary-color);
        }
        
        .file-upload-container {
            position: relative;
            display: inline-block;
        }
        
        .file-upload-label {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
            font-size: 14px;
        }
        
        .file-upload-label:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
        }
        
        .file-input {
            position: absolute;
            left: -9999px;
        }
        
        .file-info {
            font-size: 12px;
            color: #6c757d;
            margin-top: 8px;
        }
        
        .remove-image {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 8px 15px;
            background: var(--danger-color);
            color: white;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            margin-top: 10px;
            transition: all 0.3s ease;
        }
        
        .remove-image:hover {
            background: #d0006f;
        }
        
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .profile-section {
                grid-template-columns: 1fr;
                text-align: center;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .registration-body {
                padding: 25px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="registration-container">
            <div class="registration-card">
                <div class="registration-header">
                    <h1>
                        <i class="fas fa-user-plus"></i>
                        Create New Account
                    </h1>
                    <p>Join our school management system</p>
                </div>
                
                <div class="registration-body">
                    <!-- Success/Error Messages -->
                    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-dismissible fade show">
                        <button type="button" class="btn-close" onclick="closeAlert()"></button>
                        <asp:Literal ID="litMessage" runat="server"></asp:Literal>
                    </asp:Panel>
                    
                    <!-- User Registration Form -->
                    <div class="form-grid">
                        <!-- Profile Picture Section -->
                        <div class="profile-section full-width">
                            <div class="profile-picture-container">
                                <asp:Image ID="imgProfilePreview" runat="server" CssClass="profile-picture-preview" Visible="false" />
                                <div id="profilePlaceholder" class="profile-placeholder" runat="server">
                                    <i class="fas fa-user"></i>
                                </div>
                                
                                <div class="file-upload-container">
                                    <label for="fileProfilePicture" class="file-upload-label">
                                        <i class="fas fa-camera"></i>
                                        Choose Photo
                                    </label>
                                    <asp:FileUpload ID="fileProfilePicture" runat="server" CssClass="file-input" onchange="previewImage(this)" />
                                </div>
                                
                                <div class="file-info">
                                    <i class="fas fa-info-circle"></i>
                                    Max size: 2MB • JPG, PNG, GIF
                                </div>
                                
                                <asp:Button ID="btnRemoveImage" runat="server" Text="Remove Image" CssClass="remove-image" 
                                    OnClick="BtnRemoveImage_Click" Visible="false" />
                                
                                <asp:HiddenField ID="hdnExistingPicture" runat="server" />
                                <asp:HiddenField ID="hdnHasNewImage" runat="server" Value="false" />
                            </div>
                            
                            <div>
                                <h4 style="color: var(--primary-color); margin-bottom: 15px;">
                                    <i class="fas fa-id-card"></i>
                                    Profile Information
                                </h4>
                                <p style="color: #6c757d; line-height: 1.6;">
                                    Add a profile picture to make your account more recognizable. 
                                    This will help teachers and administrators identify you easily.
                                </p>
                            </div>
                        </div>
                        
                        <!-- Username -->
                        <div class="form-group">
                            <label class="form-label" for="txtUsername">
                                <i class="fas fa-user"></i>Username *
                            </label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter username" 
                                    onblur="checkUsernameAvailability()" />
                            </div>
                            <div class="validation-container">
                                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                                    ControlToValidate="txtUsername" ErrorMessage="Username is required" 
                                    CssClass="validator" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revUsername" runat="server" 
                                    ControlToValidate="txtUsername" ErrorMessage="3-50 alphanumeric characters" 
                                    ValidationExpression="^[a-zA-Z0-9_]{3,50}$" CssClass="validator" Display="Dynamic" />
                                <span id="usernameAvailability" class="validator" style="display: none;"></span>
                            </div>
                        </div>
                        
                        <!-- Email -->
                        <div class="form-group">
                            <label class="form-label" for="txtEmail">
                                <i class="fas fa-envelope"></i>Email Address *
                            </label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="Enter email address" 
                                    onblur="checkEmailAvailability()" />
                            </div>
                            <div class="validation-container">
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                                    ControlToValidate="txtEmail" ErrorMessage="Email is required" 
                                    CssClass="validator" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                                    ControlToValidate="txtEmail" ErrorMessage="Invalid email format" 
                                    ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" 
                                    CssClass="validator" Display="Dynamic" />
                                <span id="emailAvailability" class="validator" style="display: none;"></span>
                            </div>
                        </div>
                        
                        <!-- Password -->
                        <div class="form-group">
                            <label class="form-label" for="txtPassword">
                                <i class="fas fa-lock"></i>Password *
                            </label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter password" 
                                    onkeyup="checkPasswordStrength()" />
                            </div>
                            <div class="validation-container">
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                                    ControlToValidate="txtPassword" ErrorMessage="Password is required" 
                                    CssClass="validator" Display="Dynamic" />
                                <asp:CustomValidator ID="cvPassword" runat="server" 
                                    ControlToValidate="txtPassword" ErrorMessage="Minimum 6 characters required" 
                                    ClientValidationFunction="validatePassword" CssClass="validator" Display="Dynamic" 
                                    OnServerValidate="CvPassword_ServerValidate" />
                                <div id="passwordStrength" style="font-size: 12px; margin-top: 5px;"></div>
                            </div>
                        </div>
                        
                        <!-- Confirm Password -->
                        <div class="form-group">
                            <label class="form-label" for="txtConfirmPassword">
                                <i class="fas fa-lock"></i>Confirm Password *
                            </label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Confirm password" 
                                    onkeyup="checkPasswordMatch()" />
                            </div>
                            <div class="validation-container">
                                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
                                    ControlToValidate="txtConfirmPassword" ErrorMessage="Please confirm password" 
                                    CssClass="validator" Display="Dynamic" />
                                <asp:CompareValidator ID="cvConfirmPassword" runat="server" 
                                    ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" 
                                    ErrorMessage="Passwords do not match" CssClass="validator" Display="Dynamic" />
                                <div id="passwordMatch" style="font-size: 12px; margin-top: 5px;"></div>
                            </div>
                        </div>
                        
                        <!-- First Name -->
                        <div class="form-group">
                            <label class="form-label" for="txtFirstName">
                                <i class="fas fa-signature"></i>First Name *
                            </label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="Enter first name" />
                            </div>
                            <div class="validation-container">
                                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" 
                                    ControlToValidate="txtFirstName" ErrorMessage="First name is required" 
                                    CssClass="validator" Display="Dynamic" />
                            </div>
                        </div>
                        
                        <!-- Last Name -->
                        <div class="form-group">
                            <label class="form-label" for="txtLastName">
                                <i class="fas fa-signature"></i>Last Name *
                            </label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Enter last name" />
                            </div>
                            <div class="validation-container">
                                <asp:RequiredFieldValidator ID="rfvLastName" runat="server" 
                                    ControlToValidate="txtLastName" ErrorMessage="Last name is required" 
                                    CssClass="validator" Display="Dynamic" />
                            </div>
                        </div>
                        
                        <!-- Phone -->
                        <div class="form-group">
                            <label class="form-label" for="txtPhone">
                                <i class="fas fa-phone"></i>Phone Number
                            </label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Enter phone number" />
                            </div>
                            <div class="validation-container">
                                <asp:RegularExpressionValidator ID="revPhone" runat="server" 
                                    ControlToValidate="txtPhone" ErrorMessage="Invalid phone number format" 
                                    ValidationExpression="^[0-9+\-\s()]{10,15}$" CssClass="validator" Display="Dynamic" />
                            </div>
                        </div>
                        
                        <!-- Role -->
                        <div class="form-group">
                            <label class="form-label" for="ddlRole">
                                <i class="fas fa-user-tag"></i>User Role *
                            </label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-tag"></i></span>
                                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="--Select Role--" Value="" />
                                    <asp:ListItem Text="Student" Value="Student" />
                                    <asp:ListItem Text="Parent" Value="Parent" />
                                    <asp:ListItem Text="Teacher" Value="Teacher" />
                                </asp:DropDownList>
                            </div>
                            <div class="validation-container">
                                <asp:RequiredFieldValidator ID="rfvRole" runat="server" 
                                    ControlToValidate="ddlRole" ErrorMessage="Role is required" 
                                    CssClass="validator" Display="Dynamic" InitialValue="" />
                            </div>
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="button-group">
                        <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn btn-primary" OnClick="BtnRegister_Click" />
                        <asp:Button ID="btnReset" runat="server" Text="Reset Form" CssClass="btn btn-outline" OnClick="BtnReset_Click" />
                    </div>
                    
                    <!-- Login Link -->
                    <div class="login-link">
                        <p>Already have an account? 
                            <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="Login.aspx" CssClass="text-decoration-none fw-bold">
                                Sign In Here
                            </asp:HyperLink>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script type="text/javascript">
        function previewImage(input) {
            if (input.files && input.files[0]) {
                // Check file size (max 2MB)
                if (input.files[0].size > 2 * 1024 * 1024) {
                    alert('File size must be less than 2MB');
                    input.value = '';
                    return;
                }

                // Check file type
                var validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
                if (!validTypes.includes(input.files[0].type)) {
                    alert('Please select a valid image file (JPG, PNG, GIF)');
                    input.value = '';
                    return;
                }

                var reader = new FileReader();
                reader.onload = function (e) {
                    var imgPreview = document.getElementById('<%= imgProfilePreview.ClientID %>');
                    var profilePlaceholder = document.getElementById('profilePlaceholder');
                    var btnRemove = document.getElementById('<%= btnRemoveImage.ClientID %>');
                    var hdnHasNewImage = document.getElementById('<%= hdnHasNewImage.ClientID %>');

                    if (imgPreview) {
                        imgPreview.src = e.target.result;
                        imgPreview.style.display = 'block';
                    }
                    if (profilePlaceholder) {
                        profilePlaceholder.style.display = 'none';
                    }
                    if (btnRemove) {
                        btnRemove.style.display = 'inline-flex';
                    }
                    if (hdnHasNewImage) {
                        hdnHasNewImage.value = 'true';
                    }
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        function checkUsernameAvailability() {
            var username = document.getElementById('<%= txtUsername.ClientID %>').value;
            var availabilitySpan = document.getElementById('usernameAvailability');

            if (username.length >= 3) {
                // Simulate AJAX call - in real implementation, call a web method
                setTimeout(function () {
                    // This would be replaced with actual AJAX call to check username
                    availabilitySpan.style.display = 'block';
                    availabilitySpan.innerHTML = '<i class="fas fa-sync fa-spin"></i> Checking availability...';

                    setTimeout(function () {
                        // Mock response - replace with actual server response
                        availabilitySpan.innerHTML = '<i class="fas fa-check"></i> Username is available!';
                        availabilitySpan.style.color = 'green';
                    }, 1000);
                }, 500);
            }
        }

        function checkEmailAvailability() {
            var email = document.getElementById('<%= txtEmail.ClientID %>').value;
            var availabilitySpan = document.getElementById('emailAvailability');
            
            if (email.includes('@')) {
                availabilitySpan.style.display = 'block';
                availabilitySpan.innerHTML = '<i class="fas fa-sync fa-spin"></i> Checking email...';
                
                setTimeout(function() {
                    // Mock response - replace with actual server response
                    availabilitySpan.innerHTML = '<i class="fas fa-check"></i> Email is available!';
                    availabilitySpan.style.color = 'green';
                }, 1000);
            }
        }

        function checkPasswordStrength() {
            var password = document.getElementById('<%= txtPassword.ClientID %>').value;
            var strengthDiv = document.getElementById('passwordStrength');
            
            if (password.length === 0) {
                strengthDiv.innerHTML = '';
                return;
            }
            
            var strength = 'Weak';
            var color = 'red';
            
            if (password.length >= 8) {
                strength = 'Medium';
                color = 'orange';
            }
            if (password.length >= 10 && /[A-Z]/.test(password) && /[0-9]/.test(password)) {
                strength = 'Strong';
                color = 'green';
            }
            
            strengthDiv.innerHTML = '<i class="fas fa-lock" style="color: ' + color + '"></i> Password strength: <span style="color: ' + color + '; font-weight: bold;">' + strength + '</span>';
        }

        function checkPasswordMatch() {
            var password = document.getElementById('<%= txtPassword.ClientID %>').value;
            var confirmPassword = document.getElementById('<%= txtConfirmPassword.ClientID %>').value;
            var matchDiv = document.getElementById('passwordMatch');
            
            if (confirmPassword.length === 0) {
                matchDiv.innerHTML = '';
                return;
            }
            
            if (password === confirmPassword) {
                matchDiv.innerHTML = '<i class="fas fa-check" style="color: green"></i> Passwords match!';
            } else {
                matchDiv.innerHTML = '<i class="fas fa-times" style="color: red"></i> Passwords do not match!';
            }
        }

        function validatePassword(source, arguments) {
            var password = arguments.Value;
            arguments.IsValid = (password.length >= 6);
        }

        function closeAlert() {
            var alert = document.querySelector('.alert');
            if (alert) {
                alert.style.display = 'none';
            }
        }

        // Set focus to first field
        document.addEventListener('DOMContentLoaded', function() {
            var usernameField = document.getElementById('<%= txtUsername.ClientID %>');
            if (usernameField) {
                usernameField.focus();
            }
        });

        // Auto-hide alert after 5 seconds
        setTimeout(function () {
            closeAlert();
        }, 5000);
    </script>
</body>
</html>