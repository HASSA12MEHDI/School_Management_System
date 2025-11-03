<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Add_Teachers.aspx.cs" 
    Inherits="School_Managenment_System12._00.Add_Teacher" MasterPageFile="~/Site1.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Prevent page scroll on focus */
        * {
            scroll-behavior: smooth;
        }
        
        .teacher-form-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .form-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .form-header:before {
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
            0% { transform: translate(0, 0) rotate(0deg); }
            100% { transform: translate(-50px, -50px) rotate(360deg); }
        }

        .form-header h1 {
            margin: 0 0 15px 0;
            font-size: 2.8rem;
            font-weight: 800;
            position: relative;
            z-index: 2;
        }

        .form-header p {
            margin: 0;
            font-size: 1.2rem;
            opacity: 0.9;
            position: relative;
            z-index: 2;
        }

        .form-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        @media (max-width: 968px) {
            .form-wrapper {
                grid-template-columns: 1fr;
            }
        }

        .form-section {
            background: white;
            padding: 35px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            border: 1px solid #f0f0f0;
        }

        .section-title {
            font-size: 1.4rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid #667eea;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #667eea;
            font-size: 1.6rem;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #2c3e50;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .required::after {
            content: " *";
            color: #e74c3c;
            font-weight: bold;
        }

        .form-control {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            font-family: inherit;
        }

        .form-control:focus {
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            outline: none;
            /* Remove transform to prevent page jump */
            /* transform: translateY(-2px); */
        }

        .form-control:hover {
            border-color: #adb5bd;
        }

        /* Profile Picture Section */
        .profile-section {
            text-align: center;
            padding: 25px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            border: 2px dashed #dee2e6;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .profile-section:hover {
            border-color: #667eea;
            background: linear-gradient(135deg, #f0f4ff 0%, #e3e9ff 100%);
        }

        .profile-img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid white;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            margin-bottom: 20px;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .profile-img:hover {
            transform: scale(1.05);
            box-shadow: 0 12px 35px rgba(0,0,0,0.2);
        }

        .file-upload {
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .file-upload-label {
            display: inline-block;
            padding: 12px 25px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .file-upload-label:hover {
            /* Remove transform to prevent page jump */
            /* transform: translateY(-2px); */
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .file-upload input[type="file"] {
            position: absolute;
            left: -9999px;
            opacity: 0;
        }

        /* Special Input Styles */
        .input-with-icon {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            font-size: 18px;
        }

        .input-with-icon .form-control {
            padding-left: 50px;
        }

        .salary-input {
            background: linear-gradient(135deg, #f8fff8 0%, #f0fff0 100%);
            border-color: #27ae60;
            font-weight: 600;
            color: #27ae60;
        }

        .salary-input:focus {
            border-color: #219a52;
            box-shadow: 0 0 0 4px rgba(39, 174, 96, 0.1);
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
            border: 2px solid #e9ecef;
        }

        .checkbox-group input[type="checkbox"] {
            width: 20px;
            height: 20px;
            border-radius: 5px;
            border: 2px solid #667eea;
            cursor: pointer;
        }

        .checkbox-group label {
            font-weight: 600;
            color: #2c3e50;
            cursor: pointer;
            margin: 0;
        }

        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #f1f3f4;
        }

        .btn {
            padding: 16px 30px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 700;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            /* Remove transform to prevent page jump */
            /* transform: translateY(0); */
        }

        .btn i {
            font-size: 18px;
        }

        .btn-success {
            background: linear-gradient(135deg, #00b09b, #96c93d);
            color: white;
            box-shadow: 0 6px 20px rgba(0, 176, 155, 0.3);
        }

        .btn-success:hover {
            /* Remove transform to prevent page jump */
            /* transform: translateY(-3px); */
            box-shadow: 0 12px 30px rgba(0, 176, 155, 0.4);
        }

        .btn-primary {
            background: linear-gradient(135deg, #2193b0, #6dd5ed);
            color: white;
            box-shadow: 0 6px 20px rgba(33, 147, 176, 0.3);
        }

        .btn-primary:hover {
            /* Remove transform to prevent page jump */
            /* transform: translateY(-3px); */
            box-shadow: 0 12px 30px rgba(33, 147, 176, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #8e9eab, #eef2f3);
            color: #2c3e50;
            box-shadow: 0 6px 20px rgba(142, 158, 171, 0.3);
        }

        .btn-secondary:hover {
            /* Remove transform to prevent page jump */
            /* transform: translateY(-3px); */
            box-shadow: 0 12px 30px rgba(142, 158, 171, 0.4);
        }

        .btn-warning {
            background: linear-gradient(135deg, #f7971e, #ffd200);
            color: white;
            box-shadow: 0 6px 20px rgba(247, 151, 30, 0.3);
        }

        .btn-warning:hover {
            /* Remove transform to prevent page jump */
            /* transform: translateY(-3px); */
            box-shadow: 0 12px 30px rgba(247, 151, 30, 0.4);
        }

        .alert {
            padding: 20px 25px;
            margin: 20px 0;
            border-radius: 15px;
            font-weight: 600;
            border-left: 5px solid;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            position: relative;
            z-index: 1000;
        }

        .alert-success {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: #2e7d32;
            border-left-color: #4caf50;
        }

        .alert-danger {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            color: #c62828;
            border-left-color: #f44336;
        }

        .alert-info {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1565c0;
            border-left-color: #2196f3;
        }

        .employee-id-section {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            padding: 20px;
            border-radius: 15px;
            border: 2px solid #ffb74d;
            margin-bottom: 25px;
        }

        .employee-id-display {
            font-size: 1.5rem;
            font-weight: 800;
            color: #e65100;
            text-align: center;
            margin: 10px 0;
        }

        .fade-in {
            animation: fadeIn 0.6s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; /* Remove transform to prevent page jump */ /* transform: translateY(20px); */ }
            to { opacity: 1; transform: translateY(0); }
        }

        .slide-in {
            animation: slideIn 0.8s ease-out;
        }

        @keyframes slideIn {
            from { transform: translateX(-100px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        .profile-container {
            position: relative;
            display: inline-block;
        }

        .profile-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 123, 255, 0.7);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
            border-radius: 50%;
            cursor: pointer;
        }

        .profile-container:hover .profile-overlay {
            opacity: 1;
        }

        .profile-overlay i {
            font-size: 2rem;
        }

        @media (max-width: 768px) {
            .form-header {
                padding: 25px 20px;
            }

            .form-header h1 {
                font-size: 2rem;
            }

            .form-section {
                padding: 25px;
            }

            .btn {
                padding: 14px 20px;
                font-size: 14px;
            }

            .profile-img {
                width: 120px;
                height: 120px;
            }
        }

        .glow {
            animation: glow 2s ease-in-out infinite alternate;
        }

        @keyframes glow {
            from { box-shadow: 0 0 10px #667eea, 0 0 20px #667eea, 0 0 30px #667eea; }
            to { box-shadow: 0 0 15px #764ba2, 0 0 25px #764ba2, 0 0 35px #764ba2; }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .upload-status {
            margin-top: 10px;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
        }

        .upload-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .upload-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Prevent scroll on focus */
        .form-control:focus {
            outline: none;
        }

        /* Loading overlay */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Loading Overlay -->
    <div id="loadingOverlay" class="loading-overlay">
        <div class="loading-spinner"></div>
    </div>

    <div class="teacher-form-container">
        <div class="form-header slide-in">
            <h1>👨‍🏫 Add New Teacher</h1>
            <p>Complete the form below to register a new teacher in the system</p>
        </div>

        <asp:Label ID="LblMessage" runat="server" Visible="false" CssClass="alert"></asp:Label>

        <div class="form-wrapper">
            <div class="form-section fade-in">
                <div class="section-title">
                    <i class="fas fa-user-graduate"></i> Personal Information
                </div>

                <div class="employee-id-section">
                    <div class="form-group">
                        <asp:Label runat="server" CssClass="form-label required" Text="🎯 Employee ID"></asp:Label>
                        <div class="employee-id-display">
                            <asp:TextBox ID="TxtEmployeeId" runat="server" CssClass="form-control" ReadOnly="true" 
                                style="text-align: center; font-weight: bold; font-size: 1.3rem; background: transparent; border: none;"></asp:TextBox>
                        </div>
                        <div style="text-align: center; margin-top: 10px;">
                            <asp:Button ID="BtnGenerateId" runat="server" Text="🔄 Generate New ID" 
                                CssClass="btn btn-warning" OnClick="BtnGenerateId_Click" />
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="👤 First Name"></asp:Label>
                    <div class="input-with-icon">
                        <i class="fas fa-user input-icon"></i>
                        <asp:TextBox ID="TxtFirstName" runat="server" CssClass="form-control" 
                            placeholder="Enter first name" MaxLength="50"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="👤 Last Name"></asp:Label>
                    <div class="input-with-icon">
                        <i class="fas fa-user input-icon"></i>
                        <asp:TextBox ID="TxtLastName" runat="server" CssClass="form-control" 
                            placeholder="Enter last name" MaxLength="50"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="📧 Email Address"></asp:Label>
                    <div class="input-with-icon">
                        <i class="fas fa-envelope input-icon"></i>
                        <asp:TextBox ID="TxtEmail" runat="server" CssClass="form-control" TextMode="Email"
                            placeholder="teacher@school.com" MaxLength="100"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="📞 Phone Number"></asp:Label>
                    <div class="input-with-icon">
                        <i class="fas fa-phone input-icon"></i>
                        <asp:TextBox ID="TxtPhone" runat="server" CssClass="form-control" 
                            placeholder="+1 234 567 8900" MaxLength="15"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="form-section fade-in">
                <div class="section-title">
                    <i class="fas fa-briefcase"></i> Professional Information
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="🎓 Qualification"></asp:Label>
                    <asp:DropDownList ID="DdlQualification" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">Select Qualification</asp:ListItem>
                        <asp:ListItem Value="PhD">PhD</asp:ListItem>
                        <asp:ListItem Value="Masters">Masters Degree</asp:ListItem>
                        <asp:ListItem Value="Bachelors">Bachelors Degree</asp:ListItem>
                        <asp:ListItem Value="Diploma">Diploma</asp:ListItem>
                        <asp:ListItem Value="B.Ed">B.Ed</asp:ListItem>
                        <asp:ListItem Value="M.Ed">M.Ed</asp:ListItem>
                        <asp:ListItem Value="Other">Other</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="📊 Experience (Years)"></asp:Label>
                    <div class="input-with-icon">
                        <i class="fas fa-chart-line input-icon"></i>
                        <asp:TextBox ID="TxtExperience" runat="server" CssClass="form-control" TextMode="Number"
                            placeholder="0" Min="0" Max="50"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="💰 Salary"></asp:Label>
                    <div class="input-with-icon">
                        <i class="fas fa-money-bill-wave input-icon"></i>
                        <asp:TextBox ID="TxtSalary" runat="server" CssClass="form-control salary-input" TextMode="Number"
                            placeholder="0.00" step="0.01"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <asp:Label runat="server" CssClass="form-label required" Text="📅 Joining Date"></asp:Label>
                    <div class="input-with-icon">
                        <i class="fas fa-calendar-alt input-icon"></i>
                        <asp:TextBox ID="TxtJoiningDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <div class="checkbox-group">
                        <asp:CheckBox ID="ChkIsActive" runat="server" Checked="true" />
                        <asp:Label runat="server" AssociatedControlID="ChkIsActive" Text="✅ Active Teacher"></asp:Label>
                    </div>
                </div>
            </div>
        </div>

        <div class="form-section fade-in">
            <div class="section-title">
                <i class="fas fa-camera"></i> Profile Picture
            </div>
            
            <div class="profile-section" onclick="document.getElementById('<%= FileProfilePic.ClientID %>').click();">
                <div class="profile-container">
                    <asp:Image ID="ImgProfile" runat="server" CssClass="profile-img" 
                        ImageUrl="~/images/default-teacher.png" />
                    <div class="profile-overlay">
                        <i class="fas fa-camera"></i>
                    </div>
                </div>
                
                <div class="file-upload">
                    <asp:Label runat="server" CssClass="file-upload-label" AssociatedControlID="FileProfilePic">
                        <i class="fas fa-upload"></i> Choose Profile Picture
                    </asp:Label>
                    <asp:FileUpload ID="FileProfilePic" runat="server" 
                        accept=".jpg,.jpeg,.png,.gif" onchange="return previewImage(this);" />
                </div>
                
                <div id="uploadStatus" class="upload-status" style="display: none;"></div>
                
                <div style="margin-top: 15px; font-size: 12px; color: #6c757d;">
                    <i class="fas fa-info-circle"></i> Supported formats: JPG, PNG, GIF | Max size: 2MB
                </div>
            </div>
        </div>

        <div class="action-buttons">
            <asp:Button ID="BtnSave" runat="server" Text="💾 Save Teacher" 
                CssClass="btn btn-success pulse" OnClick="BtnSave_Click" 
                OnClientClick="return validateForm();" />
            <asp:Button ID="BtnSaveAndAdd" runat="server" Text="➕ Save & Add Another" 
                CssClass="btn btn-primary" OnClick="BtnSaveAndAdd_Click" 
                OnClientClick="return validateForm();" />
            <asp:Button ID="BtnClear" runat="server" Text="🗑️ Clear Form" 
                CssClass="btn btn-secondary" OnClick="BtnClear_Click" 
                OnClientClick="return confirmClear();" />
            <asp:Button ID="BtnViewTeachers" runat="server" Text="👥 View All Teachers" 
                CssClass="btn btn-warning" OnClick="BtnViewTeachers_Click" />
        </div>
    </div>

    <script type="text/javascript">
        // Prevent page scroll on focus
        document.addEventListener('DOMContentLoaded', function () {
            // Store current scroll position
            var scrollPosition = 0;

            // Save scroll position before postback
            window.onbeforeunload = function () {
                scrollPosition = window.pageYOffset || document.documentElement.scrollTop;
                sessionStorage.setItem('scrollPosition', scrollPosition);
            };

            // Restore scroll position after postback
            window.addEventListener('load', function () {
                var savedPosition = sessionStorage.getItem('scrollPosition');
                if (savedPosition) {
                    window.scrollTo(0, parseInt(savedPosition));
                    sessionStorage.removeItem('scrollPosition');
                }
            });

            // Prevent scroll on input focus
            var inputs = document.querySelectorAll('input, select, textarea, button');
            inputs.forEach(function (input) {
                input.addEventListener('focus', function (e) {
                    e.preventDefault();
                });
            });
        });

        // Show loading overlay
        function showLoading() {
            document.getElementById('loadingOverlay').style.display = 'flex';
        }

        // Hide loading overlay
        function hideLoading() {
            document.getElementById('loadingOverlay').style.display = 'none';
        }

        // Preview image function
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var file = input.files[0];
                var fileSize = file.size / 1024 / 1024; // MB
                var fileType = file.type;
                var validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];

                // Validate file type
                if (!validTypes.includes(fileType)) {
                    showUploadStatus('Error: Only JPG, PNG, and GIF files are allowed!', 'error');
                    resetFileInput(input);
                    return false;
                }

                // Validate file size
                if (fileSize > 2) {
                    showUploadStatus('Error: File size must be less than 2MB!', 'error');
                    resetFileInput(input);
                    return false;
                }

                var reader = new FileReader();
                reader.onload = function (e) {
                    // Update preview
                    var profileImg = document.getElementById('<%= ImgProfile.ClientID %>');
                    profileImg.src = e.target.result;

                    // Mark as preview
                    profileImg.setAttribute('data-preview', 'true');

                    showUploadStatus('Profile picture selected successfully!', 'success');

                    setTimeout(function () {
                        hideUploadStatus();
                    }, 3000);
                }

                reader.onerror = function () {
                    showUploadStatus('Error reading file!', 'error');
                    resetFileInput(input);
                    return false;
                }

                reader.readAsDataURL(file);
                return true;
            }
            return false;
        }

        // Show upload status
        function showUploadStatus(message, type) {
            var statusDiv = document.getElementById('uploadStatus');
            statusDiv.innerHTML = message;
            statusDiv.className = 'upload-status ' + (type === 'success' ? 'upload-success' : 'upload-error');
            statusDiv.style.display = 'block';
        }

        // Hide upload status
        function hideUploadStatus() {
            var statusDiv = document.getElementById('uploadStatus');
            statusDiv.style.display = 'none';
        }

        // Reset file input
        function resetFileInput(input) {
            input.value = '';
            var profileImg = document.getElementById('<%= ImgProfile.ClientID %>');
            profileImg.src = '<%= ResolveUrl("~/images/default-teacher.png") %>';
            profileImg.removeAttribute('data-preview');
        }

        // Form validation
        function validateForm() {
            var isValid = true;
            var requiredFields = document.querySelectorAll('[class*="required"]');
            var firstError = null;

            // Reset all input styles
            var allInputs = document.querySelectorAll('.form-control');
            allInputs.forEach(function (input) {
                input.style.borderColor = '#e9ecef';
                input.style.background = '#f8f9fa';
            });

            // Validate required fields
            requiredFields.forEach(function (field) {
                var formGroup = field.closest('.form-group');
                if (formGroup) {
                    var input = formGroup.querySelector('input, select');
                    if (input && !input.value.trim()) {
                        isValid = false;
                        input.style.borderColor = '#e74c3c';
                        input.style.background = '#ffebee';
                        
                        if (!firstError) {
                            firstError = input;
                        }
                    }
                }
            });

            // Validate email format
            var emailInput = document.getElementById('<%= TxtEmail.ClientID %>');
            if (emailInput && emailInput.value.trim()) {
                var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailPattern.test(emailInput.value)) {
                    isValid = false;
                    emailInput.style.borderColor = '#e74c3c';
                    emailInput.style.background = '#ffebee';
                    if (!firstError) firstError = emailInput;
                }
            }

            // Validate phone format
            var phoneInput = document.getElementById('<%= TxtPhone.ClientID %>');
            if (phoneInput && phoneInput.value.trim()) {
                var phonePattern = /^[\+]?[0-9\s\-\(\)]{10,}$/;
                if (!phonePattern.test(phoneInput.value)) {
                    isValid = false;
                    phoneInput.style.borderColor = '#e74c3c';
                    phoneInput.style.background = '#ffebee';
                    if (!firstError) firstError = phoneInput;
                }
            }

            if (!isValid) {
                if (firstError) {
                    // Scroll to error without focus to prevent page jump
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
                
                showMessage('Please fill in all required fields correctly!', 'error');
                return false;
            }

            // Show loading
            showLoading();
            
            return true;
        }

        // Show message
        function showMessage(message, type) {
            // Use alert instead of custom message to avoid page manipulation
            alert(message);
        }

        // Confirm clear
        function confirmClear() {
            return confirm('Are you sure you want to clear all form data? This action cannot be undone.');
        }

        // Handle page load events
        window.addEventListener('load', function() {
            // Hide loading overlay
            hideLoading();
            
            // Set joining date to today if empty
            var joiningDate = document.getElementById('<%= TxtJoiningDate.ClientID %>');
            if (joiningDate && !joiningDate.value) {
                var today = new Date();
                var formattedDate = today.toISOString().split('T')[0];
                joiningDate.value = formattedDate;
            }

            // Set focus to first name field without scrolling
            var firstName = document.getElementById('<%= TxtFirstName.ClientID %>');
            if (firstName && !firstName.value) {
                firstName.focus({ preventScroll: true });
            }
        });

        // Prevent form submission on Enter key
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && e.target.tagName !== 'TEXTAREA') {
                e.preventDefault();
                return false;
            }
        });
    </script>
</asp:Content>