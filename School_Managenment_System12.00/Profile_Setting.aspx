<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Profile_Setting.aspx.cs" Inherits="School_Managenment_System12._00.Profile_Setting" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .profile-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #007bff;
            padding-bottom: 20px;
        }
        .profile-picture {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid #007bff;
            margin-bottom: 20px;
        }
        .profile-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .info-group {
            margin-bottom: 15px;
        }
        .label {
            font-weight: bold;
            color: #555;
            display: block;
            margin-bottom: 5px;
        }
        .value {
            padding: 10px;
            background: #f8f9fa;
            border-radius: 5px;
            border-left: 4px solid #007bff;
        }
        .full-width {
            grid-column: 1 / -1;
        }
        .message {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            text-align: center;
        }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        .btn-edit, .btn-save, .btn-cancel {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 5px;
        }
        .btn-edit { background: #007bff; color: white; }
        .btn-save { background: #28a745; color: white; }
        .btn-cancel { background: #6c757d; color: white; }
        .btn-edit:hover { background: #0056b3; }
        .btn-save:hover { background: #218838; }
        .btn-cancel:hover { background: #545b62; }
        .edit-form {
            display: none;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .button-group {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="profile-container">
            <div class="profile-header">
                <asp:Image ID="imgProfile" runat="server" CssClass="profile-picture" 
                    ImageUrl="~/images/default.png" />
                <h1>User Profile</h1>
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false" />

            <div id="viewMode">
                <div class="profile-info">
                    <div class="info-group">
                        <span class="label">User ID:</span>
                        <asp:Label ID="lblUserId" runat="server" CssClass="value" />
                    </div>
                    
                    <div class="info-group">
                        <span class="label">Username:</span>
                        <asp:Label ID="lblUsername" runat="server" CssClass="value" />
                    </div>
                    
                    <div class="info-group">
                        <span class="label">Email:</span>
                        <asp:Label ID="lblEmail" runat="server" CssClass="value" />
                    </div>
                    
                    <div class="info-group">
                        <span class="label">Role:</span>
                        <asp:Label ID="lblRole" runat="server" CssClass="value" />
                    </div>
                    
                    <div class="info-group">
                        <span class="label">First Name:</span>
                        <asp:Label ID="lblFirstName" runat="server" CssClass="value" />
                    </div>
                    
                    <div class="info-group">
                        <span class="label">Last Name:</span>
                        <asp:Label ID="lblLastName" runat="server" CssClass="value" />
                    </div>
                    
                    <div class="info-group">
                        <span class="label">Phone:</span>
                        <asp:Label ID="lblPhone" runat="server" CssClass="value" Text="Not provided" />
                    </div>
                    
                    <div class="info-group">
                        <span class="label">Account Status:</span>
                        <asp:Label ID="lblStatus" runat="server" CssClass="value" />
                    </div>
                    
                    <div class="info-group full-width">
                        <span class="label">Member Since:</span>
                        <asp:Label ID="lblCreatedDate" runat="server" CssClass="value" />
                    </div>
                    
                    <div class="info-group full-width">
                        <span class="label">Last Login:</span>
                        <asp:Label ID="lblLastLogin" runat="server" CssClass="value" Text="Never" />
                    </div>
                </div>

                <div class="button-group">
                    <asp:Button ID="btnEdit" runat="server" Text="Edit Profile" 
                        CssClass="btn-edit" OnClick="btnEdit_Click" />
                    <asp:Button ID="btnBack" runat="server" Text="Back to Dashboard" 
                        CssClass="btn-cancel" OnClick="btnBack_Click" />
                </div>
            </div>

            
            <div id="editMode" runat="server" class="edit-form">
                <h3>Edit Profile</h3>
                
                <div class="form-group">
                    <span class="label">First Name:</span>
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" 
                        placeholder="Enter first name" />
                    <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" 
                        ControlToValidate="txtFirstName" ErrorMessage="First name is required" 
                        Display="Dynamic" ForeColor="Red" />
                </div>

                <div class="form-group">
                    <span class="label">Last Name:</span>
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" 
                        placeholder="Enter last name" />
                    <asp:RequiredFieldValidator ID="rfvLastName" runat="server" 
                        ControlToValidate="txtLastName" ErrorMessage="Last name is required" 
                        Display="Dynamic" ForeColor="Red" />
                </div>

                <div class="form-group">
                    <span class="label">Email:</span>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" 
                        placeholder="Enter email" TextMode="Email" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                        ControlToValidate="txtEmail" ErrorMessage="Email is required" 
                        Display="Dynamic" ForeColor="Red" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                        ControlToValidate="txtEmail" ErrorMessage="Invalid email format" 
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                        Display="Dynamic" ForeColor="Red" />
                </div>

                <div class="form-group">
                    <span class="label">Phone:</span>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" 
                        placeholder="Enter phone number" />
                </div>

                <div class="form-group">
                    <span class="label">Profile Picture:</span>
                    <asp:FileUpload ID="fileProfile" runat="server" CssClass="form-control" />
                    <small>Max file size: 2MB (JPG, PNG, GIF)</small>
                </div>

                <div class="form-group">
                    <span class="label">Change Password:</span>
                    <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" 
                        placeholder="Enter new password (optional)" TextMode="Password" />
                    <small>Leave blank to keep current password</small>
                </div>

                <div class="button-group">
                    <asp:Button ID="btnSave" runat="server" Text="Save Changes" 
                        CssClass="btn-save" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                        CssClass="btn-cancel" OnClick="btnCancel_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>