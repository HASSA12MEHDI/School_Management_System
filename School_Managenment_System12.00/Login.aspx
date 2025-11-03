<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="School_Managenment_System12._00.Login" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>School Management System - Login</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <!-- Custom CSS -->
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3a0ca3;
            --success-color: #4cc9f0;
            --warning-color: #f72585;
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
        
        .login-container {
            width: 100%;
            max-width: 400px;
        }
        
        .login-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }
        
        .login-header {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 25px;
            text-align: center;
        }
        
        .login-header h2 {
            margin: 0;
            font-weight: 600;
        }
        
        .login-header p {
            margin: 5px 0 0;
            opacity: 0.8;
        }
        
        .login-body {
            padding: 30px;
        }
        
        .form-control {
            border-radius: 10px;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(67, 97, 238, 0.25);
        }
        
        .input-group-text {
            background: var(--light-color);
            border: 1px solid #e0e0e0;
            border-radius: 10px;
        }
        
        .btn-login {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            padding: 12px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s;
            width: 100%;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.4);
        }
        
        .login-footer {
            text-align: center;
            padding: 20px;
            background: var(--light-color);
            border-top: 1px solid #ddd;
        }
        
        .alert-message {
            border-radius: 10px;
            padding: 12px 15px;
        }
        
        .role-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            margin: 5px 2px;
            background: var(--light-color);
        }
        
        .password-toggle {
            cursor: pointer;
            transition: color 0.3s;
        }
        
        .password-toggle:hover {
            color: var(--primary-color);
        }
        
        .school-logo {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .school-logo i {
            font-size: 40px;
            color: var(--primary-color);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="login-card">
                <div class="login-header">
                    <div class="school-logo">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                    <h2>School Management System</h2>
                    <p>Please login to your account</p>
                </div>
                
                <div class="login-body">
                    <div class="mb-3">
                        <label for="txtUsername" class="form-label">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" 
                                placeholder="Enter your email" TextMode="Email"></asp:TextBox>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="txtPassword" class="form-label">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" 
                                placeholder="Enter your password" TextMode="Password"></asp:TextBox>
                            <span class="input-group-text password-toggle" id="togglePassword">
                                <i class="fas fa-eye"></i>
                            </span>
                        </div>
                    </div>
                    
                    <div class="mb-3 form-check">
                        <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label" for="chkRememberMe">Remember me</label>
                        <asp:HyperLink ID="lnkreset" runat="server" NavigateUrl="reset.aspx" CssClass="float-end">
                            Forgot Password?
                        </asp:HyperLink>
                    </div>
                    
                    <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-danger d-none"></asp:Label>
                    
                    <div class="d-grid gap-2 mb-3">
                        <asp:Button ID="btnLogin" runat="server" Text="Sign In" 
                            CssClass="btn btn-login" OnClick="btnLogin_Click" />
                    </div>
                    
                    <div class="text-center mt-3">
                        <p>Don't have an account? 
                            <asp:HyperLink ID="lnkCreateAccount" runat="server" NavigateUrl="New_User.aspx">
                                Create one here
                            </asp:HyperLink>
                        </p>
                    </div>
                    
                    <div class="mt-4">
                        <p class="text-center mb-2">Demo Accounts:</p>
                        <div class="d-flex flex-wrap justify-content-center">
                            <span class="role-badge">Admin: admin@school.com</span>
                            <span class="role-badge">Teacher: teacher@school.com</span>
                            <span class="role-badge">Student: student@school.com</span>
                            <span class="role-badge">Parent: parent@school.com</span>
                        </div>
                        <p class="text-center mt-2 small">Password: School123!</p>
                    </div>
                </div>
                
                <div class="login-footer">
                    <p class="mb-0">&copy; 2023 School Management System. All rights reserved.</p>
                </div>
            </div>
        </div>
    </form>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Password visibility toggle
            const togglePassword = document.getElementById('togglePassword');
            const password = document.getElementById('<%= txtPassword.ClientID %>');
            
            if (togglePassword && password) {
                togglePassword.addEventListener('click', function () {
                    const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                    password.setAttribute('type', type);
                    const icon = togglePassword.querySelector('i');
                    icon.classList.toggle('fa-eye');
                    icon.classList.toggle('fa-eye-slash');
                });
            }

            // Auto-hide message after 5 seconds
            const message = document.getElementById('<%= lblMessage.ClientID %>');
            if (message && !message.classList.contains('d-none')) {
                setTimeout(function () {
                    message.classList.add('d-none');
                }, 5000);
            }
        });
    </script>
</body>
</html>