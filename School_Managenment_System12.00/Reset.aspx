<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reset.aspx.cs" Inherits="School_Managenment_System12._00.Reset" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reset Password - School Management System</title>
    
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
            --warning-color: #f8961e;
            --dark-color: #1d3557;
            --light-color: #f8f9fa;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }
        
        .reset-container {
            width: 100%;
            max-width: 500px;
        }
        
        .reset-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }
        
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
        
        .reset-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .reset-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 20px 20px;
            animation: float 20s linear infinite;
        }
        
        @keyframes float {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .reset-icon {
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 35px;
            backdrop-filter: blur(10px);
            position: relative;
            z-index: 1;
        }
        
        .reset-header h2 {
            margin: 0;
            font-weight: 600;
            position: relative;
            z-index: 1;
        }
        
        .reset-header p {
            margin: 10px 0 0;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }
        
        .reset-body {
            padding: 40px;
        }
        
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        
        .form-label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }
        
        .form-label i {
            margin-right: 8px;
            color: var(--primary-color);
        }
        
        .form-control {
            border-radius: 12px;
            padding: 15px 20px;
            border: 2px solid #e8ecef;
            transition: all 0.3s ease;
            font-size: 14px;
            background: #fafbfc;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(67, 97, 238, 0.15);
            background: white;
            transform: translateY(-2px);
        }
        
        .input-group {
            position: relative;
        }
        
        .password-strength {
            height: 4px;
            background: #e9ecef;
            border-radius: 2px;
            margin-top: 5px;
            overflow: hidden;
        }
        
        .password-strength-bar {
            height: 100%;
            width: 0%;
            border-radius: 2px;
            transition: all 0.3s ease;
        }
        
        .strength-weak { background: #dc3545; width: 25%; }
        .strength-fair { background: #fd7e14; width: 50%; }
        .strength-good { background: #ffc107; width: 75%; }
        .strength-strong { background: #198754; width: 100%; }
        
        .password-requirements {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .requirement {
            display: flex;
            align-items: center;
            margin-bottom: 2px;
        }
        
        .requirement i {
            margin-right: 5px;
            font-size: 10px;
        }
        
        .requirement.met {
            color: #198754;
        }
        
        .requirement.unmet {
            color: #6c757d;
        }
        
        .btn-reset {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            padding: 15px;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            width: 100%;
            font-size: 16px;
            position: relative;
            overflow: hidden;
        }
        
        .btn-reset:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(67, 97, 238, 0.4);
        }
        
        .btn-reset:active {
            transform: translateY(-1px);
        }
        
        .btn-reset::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        
        .btn-reset:hover::before {
            left: 100%;
        }
        
        .reset-footer {
            text-align: center;
            padding: 25px;
            background: var(--light-color);
            border-top: 1px solid #e9ecef;
        }
        
        .reset-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        
        .reset-footer a:hover {
            color: var(--secondary-color);
            text-decoration: underline;
        }
        
        .steps-indicator {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
        }
        
        .step {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 10px;
            font-weight: 600;
            font-size: 14px;
            color: #6c757d;
            position: relative;
        }
        
        .step.active {
            background: var(--primary-color);
            color: white;
        }
        
        .step.completed {
            background: var(--success-color);
            color: white;
        }
        
        .step::before {
            content: '';
            position: absolute;
            top: 50%;
            left: -20px;
            width: 20px;
            height: 2px;
            background: #e9ecef;
        }
        
        .step:first-child::before {
            display: none;
        }
        
        .step.completed::before {
            background: var(--success-color);
        }
        
        @media (max-width: 576px) {
            .reset-body {
                padding: 25px;
            }
            
            .reset-container {
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="reset-container">
            <div class="reset-card">
                <div class="reset-header">
                    <div class="reset-icon">
                        <i class="fas fa-key"></i>
                    </div>
                    <h2>Reset Your Password</h2>
                    <p>Secure your account with a new password</p>
                </div>
                
                <div class="reset-body">
                    <div class="steps-indicator">
                        <div class="step completed">1</div>
                        <div class="step active">2</div>
                        <div class="step">3</div>
                    </div>
                    
                    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-dismissible fade show">
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        <asp:Literal ID="litMessage" runat="server"></asp:Literal>
                    </asp:Panel>
                    
                    <div class="form-group">
                        <label class="form-label" for="txtEmail">
                            <i class="fas fa-envelope"></i>Email Address
                        </label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" 
                            TextMode="Email" placeholder="Enter your registered email address" />
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                            CssClass="text-danger small" Display="Dynamic" ErrorMessage="Email is required" />
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                            CssClass="text-danger small" Display="Dynamic" 
                            ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                            ErrorMessage="Please enter a valid email address" />
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="txtUsername">
                            <i class="fas fa-user"></i>Username
                        </label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" 
                            placeholder="Enter your username" />
                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername"
                            CssClass="text-danger small" Display="Dynamic" ErrorMessage="Username is required" />
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="txtNewPassword">
                            <i class="fas fa-lock"></i>New Password
                        </label>
                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" 
                            CssClass="form-control" placeholder="Enter your new password" />
                        <div class="password-strength">
                            <div id="passwordStrengthBar" class="password-strength-bar"></div>
                        </div>
                        <div class="password-requirements">
                            <div id="reqLength" class="requirement unmet">
                                <i class="fas fa-circle"></i>At least 8 characters
                            </div>
                            <div id="reqUpper" class="requirement unmet">
                                <i class="fas fa-circle"></i>One uppercase letter
                            </div>
                            <div id="reqLower" class="requirement unmet">
                                <i class="fas fa-circle"></i>One lowercase letter
                            </div>
                            <div id="reqNumber" class="requirement unmet">
                                <i class="fas fa-circle"></i>One number
                            </div>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ControlToValidate="txtNewPassword"
                            CssClass="text-danger small" Display="Dynamic" ErrorMessage="New password is required" />
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="txtConfirmPassword">
                            <i class="fas fa-lock"></i>Confirm Password
                        </label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" 
                            CssClass="form-control" placeholder="Confirm your new password" />
                        <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                            CssClass="text-danger small" Display="Dynamic" ErrorMessage="Please confirm your password" />
                        <asp:CompareValidator ID="cvPasswords" runat="server" ControlToValidate="txtConfirmPassword"
                            ControlToCompare="txtNewPassword" CssClass="text-danger small" Display="Dynamic"
                            ErrorMessage="Passwords do not match" />
                    </div>
                    
                    <div class="form-group mt-4">
                        <asp:Button ID="btnReset" runat="server" Text="Reset Password" 
                            CssClass="btn btn-reset" OnClick="BtnReset_Click" />
                    </div>
                </div>
                
                <div class="reset-footer">
                    Remember your password? 
                    <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Login.aspx">
                        <i class="fas fa-arrow-left"></i> Back to Login
                    </asp:HyperLink>
                </div>
            </div>
        </div>
    </form>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const newPassword = document.getElementById('<%= txtNewPassword.ClientID %>');
            const strengthBar = document.getElementById('passwordStrengthBar');
            const requirements = {
                length: document.getElementById('reqLength'),
                upper: document.getElementById('reqUpper'),
                lower: document.getElementById('reqLower'),
                number: document.getElementById('reqNumber')
            };

            if (newPassword) {
                newPassword.addEventListener('input', function () {
                    const password = this.value;
                    let strength = 0;
                    
                    // Check requirements
                    const hasLength = password.length >= 8;
                    const hasUpper = /[A-Z]/.test(password);
                    const hasLower = /[a-z]/.test(password);
                    const hasNumber = /[0-9]/.test(password);
                    
                    // Update requirement indicators
                    updateRequirement(requirements.length, hasLength);
                    updateRequirement(requirements.upper, hasUpper);
                    updateRequirement(requirements.lower, hasLower);
                    updateRequirement(requirements.number, hasNumber);
                    
                    // Calculate strength
                    if (hasLength) strength++;
                    if (hasUpper) strength++;
                    if (hasLower) strength++;
                    if (hasNumber) strength++;
                    
                    // Update strength bar
                    updateStrengthBar(strength);
                });
            }
            
            function updateRequirement(element, met) {
                if (met) {
                    element.classList.remove('unmet');
                    element.classList.add('met');
                    element.querySelector('i').className = 'fas fa-check-circle';
                } else {
                    element.classList.remove('met');
                    element.classList.add('unmet');
                    element.querySelector('i').className = 'fas fa-circle';
                }
            }
            
            function updateStrengthBar(strength) {
                strengthBar.className = 'password-strength-bar';
                
                switch (strength) {
                    case 0:
                        strengthBar.style.width = '0%';
                        break;
                    case 1:
                        strengthBar.classList.add('strength-weak');
                        break;
                    case 2:
                        strengthBar.classList.add('strength-fair');
                        break;
                    case 3:
                        strengthBar.classList.add('strength-good');
                        break;
                    case 4:
                        strengthBar.classList.add('strength-strong');
                        break;
                }
            }
            
            // Auto-hide alert after 5 seconds
            const alert = document.querySelector('.alert');
            if (alert) {
                setTimeout(function () {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            }
        });
    </script>
</body>
</html>