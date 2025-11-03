<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Attendance.aspx.cs" 
    Inherits="School_Management_System.Attendance" Title="Mark Attendance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Student Attendance System</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <style>
        /* Global Styles */
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        .attendance-container {
            padding: 20px;
        }

        .content-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            overflow: hidden;
            border: none;
            margin: 0 auto;
        }

        .attendance-header {
            background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
            color: white;
            padding: 30px;
            position: relative;
            overflow: hidden;
        }

        .attendance-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 200%;
            background: rgba(255,255,255,0.1);
            transform: rotate(45deg);
        }

        .attendance-body {
            padding: 30px;
            background: #f8f9fa;
        }

        /* Filter Section */
        .filter-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.08);
            border: 1px solid #e9ecef;
        }

        .summary-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            padding: 20px;
            height: 100%;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            border: none;
        }

        .summary-item {
            text-align: center;
            padding: 10px;
        }

        .summary-number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 5px;
            line-height: 1;
        }

        .summary-label {
            font-size: 0.85rem;
            opacity: 0.9;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Student List Styles */
        .students-container {
            background: white;
            border-radius: 15px;
            padding: 0;
            box-shadow: 0 5px 25px rgba(0,0,0,0.08);
            border: 1px solid #e9ecef;
            overflow: hidden;
        }

        .students-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px 25px;
            border-bottom: 1px solid #dee2e6;
        }

        .students-body {
            padding: 0;
            max-height: 600px;
            overflow-y: auto;
        }

        /* Student Card Styles */
        .student-card {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            margin: 12px;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .student-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            border-color: #4361ee;
        }

        .student-card-body {
            padding: 20px;
        }

        /* Status Styles */
        .status-present { 
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border-left: 4px solid #28a745;
        }
        .status-absent { 
            background: linear-gradient(135deg, #f8d7da 0%, #f1b0b7 100%);
            border-left: 4px solid #dc3545;
        }
        .status-late { 
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border-left: 4px solid #ffc107;
        }
        .status-halfday { 
            background: linear-gradient(135deg, #cce7ff 0%, #99ceff 100%);
            border-left: 4px solid #17a2b8;
        }
        .status-leave { 
            background: linear-gradient(135deg, #e2e3e5 0%, #c6c8ca 100%);
            border-left: 4px solid #6c757d;
        }

        /* Attendance Buttons */
        .attendance-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .attendance-btn {
            min-width: 50px;
            height: 40px;
            border: 2px solid transparent;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            text-transform: uppercase;
        }

        .attendance-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .attendance-btn.active {
            border-color: #4361ee;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.25);
            transform: scale(1.05);
        }

        .btn-present { background: linear-gradient(135deg, #28a745, #20c997); color: white; }
        .btn-absent { background: linear-gradient(135deg, #dc3545, #e83e8c); color: white; }
        .btn-late { background: linear-gradient(135deg, #ffc107, #fd7e14); color: white; }
        .btn-halfday { background: linear-gradient(135deg, #17a2b8, #6f42c1); color: white; }
        .btn-leave { background: linear-gradient(135deg, #6c757d, #495057); color: white; }

        /* Student Info */
        .student-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .student-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #4361ee, #3a0ca3);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 18px;
            flex-shrink: 0;
        }

        .student-details h6 {
            margin: 0;
            font-weight: 600;
            color: #2d3748;
        }

        .student-meta {
            display: flex;
            gap: 15px;
            margin-top: 5px;
        }

        .student-badge {
            background: #f8f9fa;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 500;
            color: #6c757d;
        }

        /* Form Controls */
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #4361ee;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.25);
        }

        .form-label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
            font-size: 14px;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 12px;
            justify-content: center;
            padding: 25px;
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
        }

        .btn-custom {
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .btn-save {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .btn-report {
            background: linear-gradient(135deg, #6c757d, #495057);
            color: white;
        }

        .btn-reset {
            background: white;
            color: #6c757d;
            border-color: #6c757d;
        }

        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        /* Alert Styles */
        #messageAlert {
            position: fixed;
            top: 100px;
            right: 30px;
            z-index: 9999;
            min-width: 300px;
            border-radius: 10px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        /* Loading Spinner */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 9998;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid #4361ee;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .attendance-container {
                padding: 15px;
            }

            .attendance-header {
                padding: 20px;
            }

            .attendance-body {
                padding: 20px;
            }

            .student-card-body {
                padding: 15px;
            }

            .attendance-buttons {
                justify-content: center;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn-custom {
                width: 100%;
            }
        }

        /* Scrollbar Styling */
        .students-body::-webkit-scrollbar {
            width: 6px;
        }

        .students-body::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 3px;
        }

        .students-body::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 3px;
        }

        .students-body::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .student-card {
            animation: fadeInUp 0.5s ease-out;
        }

        /* Navigation Bar */
        .navbar-custom {
            background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
            <div class="container-fluid">
                <a class="navbar-brand" href="#">
                    <i class="fas fa-graduation-cap me-2"></i>School Management System
                </a>
                <div class="navbar-nav ms-auto">
                    <span class="navbar-text me-3">
                        <i class="fas fa-user-circle me-2"></i>
                        <asp:Label ID="LblCurrentUser" runat="server" Text="Guest"></asp:Label>
                    </span>
                    <asp:Button ID="BtnLogout" runat="server" Text="Back DashBoard" CssClass="btn btn-outline-light btn-sm" 
                        OnClick="BtnLogout_Click" />
                </div>
            </div>
        </nav>

        <!-- Alert Notification -->
        <div id="messageAlert" class="alert alert-dismissible fade" role="alert" style="display: none;">
            <div class="d-flex align-items-center">
                <i class="fas fa-bell me-2"></i>
                <span id="alertMessage"></span>
            </div>
            <button type="button" class="btn-close" onclick="hideAlert()"></button>
        </div>

        <!-- Loading Overlay -->
        <div id="loadingOverlay" class="loading-overlay" style="display: none;">
            <div class="loading-spinner"></div>
        </div>

        <div class="attendance-container">
            <div class="content-card">
                <!-- Header Section -->
                <div class="attendance-header">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h2 class="mb-2"><i class="fas fa-calendar-check me-3"></i>Student Attendance System</h2>
                            <p class="mb-0 opacity-75">Mark and manage student attendance with real-time updates</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <div class="text-white">
                                <i class="fas fa-clock me-2"></i>
                                <span id="currentDateTime"></span>
                            </div>
                            <small class="opacity-75">Last updated: <asp:Label ID="LblLastUpdate" runat="server" Text="Just now"></asp:Label></small>
                        </div>
                    </div>
                </div>

                <!-- Main Body -->
                <div class="attendance-body">
                    <!-- Filter Section -->
                    <div class="filter-section">
                        <div class="row g-4">
                            <div class="col-md-3">
                                <label class="form-label"><i class="fas fa-calendar-day me-2"></i>Attendance Date</label>
                                <asp:TextBox ID="TxtAttendanceDate" runat="server" CssClass="form-control" 
                                    TextMode="Date"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label"><i class="fas fa-users me-2"></i>Select Class</label>
                                <asp:DropDownList ID="DdlClass" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <div class="summary-card">
                                    <div class="row g-0 text-center">
                                        <div class="col-3">
                                            <div class="summary-item">
                                                <div class="summary-number text-white"><asp:Label ID="LblTotal" runat="server" Text="0"></asp:Label></div>
                                                <div class="summary-label">Total Students</div>
                                            </div>
                                        </div>
                                        <div class="col-3">
                                            <div class="summary-item">
                                                <div class="summary-number text-success"><asp:Label ID="LblPresent" runat="server" Text="0"></asp:Label></div>
                                                <div class="summary-label">Present</div>
                                            </div>
                                        </div>
                                        <div class="col-3">
                                            <div class="summary-item">
                                                <div class="summary-number text-danger"><asp:Label ID="LblAbsent" runat="server" Text="0"></asp:Label></div>
                                                <div class="summary-label">Absent</div>
                                            </div>
                                        </div>
                                        <div class="col-3">
                                            <div class="summary-item">
                                                <div class="summary-number text-warning"><asp:Label ID="LblOthers" runat="server" Text="0"></asp:Label></div>
                                                <div class="summary-label">Others</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Students List -->
                    <div class="students-container">
                        <div class="students-header">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h4 class="mb-1"><i class="fas fa-list-alt me-2"></i>Students Attendance</h4>
                                    <p class="mb-0 text-muted">
                                        <asp:Label ID="LblClassName" runat="server" Text="Select a class to view students"></asp:Label>
                                    </p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <span class="badge bg-primary fs-6">
                                        <asp:Label ID="LblStudentCount" runat="server" Text="0"></asp:Label> Students
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div class="students-body" id="studentsContainer">
                            <!-- Students will be loaded here via AJAX -->
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <button type="button" id="btnReport" class="btn-custom btn-report">
                                📊 View Reports
                            </button>
                            <button type="button" id="btnSaveAll" class="btn-custom btn-save">
                                💾 Save All Attendance
                            </button>
                            <button type="button" id="btnReset" class="btn-custom btn-reset">
                                🔄 Reset All
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        $(document).ready(function () {
            // Set today's date as default
            var today = new Date();
            var formattedDate = today.toISOString().split('T')[0];
            $('#<%= TxtAttendanceDate.ClientID %>').val(formattedDate);

            // Load classes on page load
            loadClasses();

            // Initialize date time
            updateDateTime();
            setInterval(updateDateTime, 1000);

            // Event handlers
            $('#<%= TxtAttendanceDate.ClientID %>').change(function () {
                if ($('#<%= DdlClass.ClientID %>').val() !== "0") {
                    loadStudents();
                    loadSummary();
                    checkClassAttendance();
                }
            });

            $('#<%= DdlClass.ClientID %>').change(function () {
                if ($(this).val() !== "0") {
                    if (!$('#<%= TxtAttendanceDate.ClientID %>').val()) {
                        $('#<%= TxtAttendanceDate.ClientID %>').val(formattedDate);
                    }
                    loadStudents();
                    loadSummary();
                    checkClassAttendance();
                }
            });

            $('#btnReport').click(function () {
                window.location.href = "Attendance_Reports.aspx";
            });

            $('#btnSaveAll').click(function () {
                saveAllAttendance();
            });

            $('#btnReset').click(function () {
                resetForm();
            });

            // Add click animation to student cards
            $(document).on('click', '.student-card', function () {
                $(this).css('transform', 'scale(0.98)');
                setTimeout(() => {
                    $(this).css('transform', '');
                }, 150);
            });
        });

        function showLoading() {
            $('#loadingOverlay').show();
        }

        function hideLoading() {
            $('#loadingOverlay').hide();
        }

        function showAlert(type, message) {
            var alertDiv = $('#messageAlert');
            var messageSpan = $('#alertMessage');

            // Remove existing alert classes
            alertDiv.removeClass('alert-success alert-info alert-warning alert-danger');

            // Add new alert class
            alertDiv.addClass('alert-' + type);
            alertDiv.addClass('show');

            messageSpan.html(message);
            alertDiv.show();

            // Auto hide after 5 seconds
            setTimeout(function () {
                hideAlert();
            }, 5000);
        }

        function hideAlert() {
            $('#messageAlert').hide();
        }

        function updateDateTime() {
            const now = new Date();
            const options = {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            };
            $('#currentDateTime').text(now.toLocaleDateString('en-US', options));
        }

        function loadClasses() {
            showLoading();
            $.ajax({
                type: "POST",
                url: "Attendance.aspx/LoadClasses",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var classes = response.d;
                    var ddlClass = $('#<%= DdlClass.ClientID %>');
                    ddlClass.empty();
                    ddlClass.append($('<option></option>').val('0').html('-- Select Class --'));

                    $.each(classes, function (index, item) {
                        ddlClass.append($('<option></option>').val(item.ClassID).html(item.ClassName));
                    });

                    hideLoading();
                },
                error: function (xhr, status, error) {
                    showAlert('danger', 'Error loading classes: ' + error);
                    hideLoading();
                }
            });
        }

        function loadStudents() {
            var classId = $('#<%= DdlClass.ClientID %>').val();
            var attendanceDate = $('#<%= TxtAttendanceDate.ClientID %>').val();

            if (classId === "0" || !attendanceDate) {
                $('#studentsContainer').html('<div class="text-center py-5"><i class="fas fa-users fa-4x text-muted mb-3"></i><h4 class="text-muted">No Students Found</h4><p class="text-muted">Please select a class to view students</p></div>');
                $('#<%= LblClassName.ClientID %>').text('Select a class to view students');
                $('#<%= LblStudentCount.ClientID %>').text('0');
                return;
            }

            showLoading();
            $.ajax({
                type: "POST",
                url: "Attendance.aspx/LoadStudents",
                data: JSON.stringify({ classId: classId, attendanceDate: attendanceDate }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var students = response.d;
                    var studentsHtml = '';
                    var className = $('#<%= DdlClass.ClientID %> option:selected').text();

                    $('#<%= LblClassName.ClientID %>').text(' - ' + className);
                    $('#<%= LblStudentCount.ClientID %>').text(students.length);

                    if (students.length === 0) {
                        studentsHtml = '<div class="text-center py-5"><i class="fas fa-users fa-4x text-muted mb-3"></i><h4 class="text-muted">No Students Found</h4><p class="text-muted">There are no students in this class</p></div>';
                    } else {
                        $.each(students, function (index, student) {
                            var statusClass = student.Status !== 'Not Marked' ? 'status-' + student.Status.toLowerCase() : '';
                            var initials = getInitials(student.StudentName);

                            studentsHtml += `
                                <div class="student-card ${statusClass}">
                                    <div class="student-card-body">
                                        <div class="row align-items-center">
                                            <!-- Student Info -->
                                            <div class="col-md-4">
                                                <div class="student-info">
                                                    <div class="student-avatar">${initials}</div>
                                                    <div class="student-details">
                                                        <h6>${student.StudentName}</h6>
                                                        <div class="student-meta">
                                                            <span class="student-badge">
                                                                <i class="fas fa-id-card me-1"></i>ID: ${student.StudentId}
                                                            </span>
                                                            <span class="student-badge">
                                                                <i class="fas fa-sort-numeric-up me-1"></i>Roll: ${student.RollNumber}
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <input type="hidden" id="hfStudentId_${student.StudentId}" value="${student.StudentId}" />
                                                    <input type="hidden" id="hfStatus_${student.StudentId}" value="${student.Status}" />
                                                </div>
                                            </div>

                                            <!-- Attendance Buttons -->
                                            <div class="col-md-5">
                                                <div class="attendance-buttons">
                                                    <button type="button" class="attendance-btn btn-present ${student.Status === 'Present' ? 'active' : ''}" 
                                                        onclick="markAttendance(${student.StudentId}, 'Present')" title="Mark as Present">
                                                        <i class="fas fa-check me-1"></i>P
                                                    </button>
                                                    <button type="button" class="attendance-btn btn-absent ${student.Status === 'Absent' ? 'active' : ''}" 
                                                        onclick="markAttendance(${student.StudentId}, 'Absent')" title="Mark as Absent">
                                                        <i class="fas fa-times me-1"></i>A
                                                    </button>
                                                    <button type="button" class="attendance-btn btn-late ${student.Status === 'Late' ? 'active' : ''}" 
                                                        onclick="markAttendance(${student.StudentId}, 'Late')" title="Mark as Late">
                                                        <i class="fas fa-clock me-1"></i>L
                                                    </button>
                                                    <button type="button" class="attendance-btn btn-halfday ${student.Status === 'HalfDay' ? 'active' : ''}" 
                                                        onclick="markAttendance(${student.StudentId}, 'HalfDay')" title="Mark as Half Day">
                                                        <i class="fas fa-adjust me-1"></i>H
                                                    </button>
                                                    <button type="button" class="attendance-btn btn-leave ${student.Status === 'Leave' ? 'active' : ''}" 
                                                        onclick="markAttendance(${student.StudentId}, 'Leave')" title="Mark as Leave">
                                                        <i class="fas fa-umbrella-beach me-1"></i>LV
                                                    </button>
                                                </div>
                                            </div>

                                            <!-- Remarks -->
                                            <div class="col-md-3">
                                                <input type="text" id="txtRemarks_${student.StudentId}" class="form-control" 
                                                    placeholder="Add remarks..." value="${student.Remarks}" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            `;
                        });
                    }

                    $('#studentsContainer').html(studentsHtml);
                    hideLoading();
                },
                error: function (xhr, status, error) {
                    showAlert('danger', 'Error loading students: ' + error);
                    hideLoading();
                }
            });
        }

        function loadSummary() {
            var classId = $('#<%= DdlClass.ClientID %>').val();
            var attendanceDate = $('#<%= TxtAttendanceDate.ClientID %>').val();

            if (classId === "0" || !attendanceDate) {
                $('#<%= LblTotal.ClientID %>').text('0');
                $('#<%= LblPresent.ClientID %>').text('0');
                $('#<%= LblAbsent.ClientID %>').text('0');
                $('#<%= LblOthers.ClientID %>').text('0');
                return;
            }
            
            $.ajax({
                type: "POST",
                url: "Attendance.aspx/LoadSummary",
                data: JSON.stringify({ classId: classId, attendanceDate: attendanceDate }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    var summary = response.d;
                    $('#<%= LblTotal.ClientID %>').text(summary.Total);
                    $('#<%= LblPresent.ClientID %>').text(summary.Present);
                    $('#<%= LblAbsent.ClientID %>').text(summary.Absent);
                    $('#<%= LblOthers.ClientID %>').text(summary.Others);
                },
                error: function(xhr, status, error) {
                    showAlert('danger', 'Error loading summary: ' + error);
                }
            });
        }
        
        function checkClassAttendance() {
            var classId = $('#<%= DdlClass.ClientID %>').val();
            var attendanceDate = $('#<%= TxtAttendanceDate.ClientID %>').val();
            var className = $('#<%= DdlClass.ClientID %> option:selected').text();
            
            if (classId === "0" || !attendanceDate) {
                return;
            }
            
            $.ajax({
                type: "POST",
                url: "Attendance.aspx/CheckClassAttendance",
                data: JSON.stringify({ classId: classId, attendanceDate: attendanceDate, className: className }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    var result = response.d;
                    if (result.Message) {
                        showAlert(result.Type, result.Message);
                    }
                },
                error: function(xhr, status, error) {
                    showAlert('danger', 'Error checking attendance: ' + error);
                }
            });
        }
        
        function markAttendance(studentId, status) {
            var remarks = $(`#txtRemarks_${studentId}`).val();
            
            showLoading();
            $.ajax({
                type: "POST",
                url: "Attendance.aspx/MarkAttendance",
                data: JSON.stringify({ 
                    studentId: studentId, 
                    status: status, 
                    remarks: remarks,
                    classId: $('#<%= DdlClass.ClientID %>').val(),
                    attendanceDate: $('#<%= TxtAttendanceDate.ClientID %>').val()
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    var result = response.d;
                    if (result.Success) {
                        // Update UI
                        $(`#hfStatus_${studentId}`).val(status);
                        
                        // Update button states
                        $(`#studentsContainer .student-card`).each(function() {
                            if ($(this).find(`#hfStudentId_${studentId}`).length > 0) {
                                // Remove all active classes
                                $(this).find('.attendance-btn').removeClass('active');
                                
                                // Add active class to selected button
                                $(this).find(`.btn-${status.toLowerCase()}`).addClass('active');
                                
                                // Update card status class
                                $(this).removeClass('status-present status-absent status-late status-halfday status-leave');
                                $(this).addClass(`status-${status.toLowerCase()}`);
                            }
                        });
                        
                        // Update summary
                        loadSummary();
                        
                        // Show success message
                        var statusDisplay = status;
                        switch (status) {
                            case "Present": statusDisplay = "Present 🟢"; break;
                            case "Absent": statusDisplay = "Absent 🔴"; break;
                            case "Late": statusDisplay = "Late 🟡"; break;
                            case "HalfDay": statusDisplay = "Half Day 🔵"; break;
                            case "Leave": statusDisplay = "Leave ⚫"; break;
                        }
                        
                        showAlert('success', `Attendance marked as <strong>${statusDisplay}</strong> successfully!`);
                    } else {
                        showAlert('danger', result.Message || 'Error marking attendance');
                    }
                    hideLoading();
                },
                error: function(xhr, status, error) {
                    showAlert('danger', 'Error marking attendance: ' + error);
                    hideLoading();
                }
            });
        }
        
        function saveAllAttendance() {
            var attendanceData = [];
            
            // Collect all student data
            $('#studentsContainer .student-card').each(function() {
                var studentId = $(this).find('[id^="hfStudentId_"]').val();
                var status = $(this).find('[id^="hfStatus_"]').val();
                var remarks = $(this).find('[id^="txtRemarks_"]').val();
                
                if (studentId) {
                    attendanceData.push({
                        StudentId: studentId,
                        Status: status === 'Not Marked' ? 'Present' : status,
                        Remarks: remarks
                    });
                }
            });
            
            if (attendanceData.length === 0) {
                showAlert('warning', 'No students to save');
                return;
            }
            
            showLoading();
            $.ajax({
                type: "POST",
                url: "Attendance.aspx/SaveAllAttendance",
                data: JSON.stringify({ 
                    attendanceData: attendanceData,
                    classId: $('#<%= DdlClass.ClientID %>').val(),
                    attendanceDate: $('#<%= TxtAttendanceDate.ClientID %>').val()
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    var result = response.d;
                    if (result.Success) {
                        showAlert('success', result.Message);
                        loadStudents();
                        loadSummary();
                    } else {
                        showAlert('danger', result.Message || 'Error saving attendance');
                    }
                    hideLoading();
                },
                error: function(xhr, status, error) {
                    showAlert('danger', 'Error saving attendance: ' + error);
                    hideLoading();
                }
            });
        }
        
        function resetForm() {
            $('#<%= TxtAttendanceDate.ClientID %>').val(new Date().toISOString().split('T')[0]);
            $('#<%= DdlClass.ClientID %>').val('0');
            $('#studentsContainer').html('<div class="text-center py-5"><i class="fas fa-users fa-4x text-muted mb-3"></i><h4 class="text-muted">No Students Found</h4><p class="text-muted">Please select a class to view students</p></div>');
            $('#<%= LblClassName.ClientID %>').text('Select a class to view students');
            $('#<%= LblStudentCount.ClientID %>').text('0');
            $('#<%= LblTotal.ClientID %>').text('0');
            $('#<%= LblPresent.ClientID %>').text('0');
            $('#<%= LblAbsent.ClientID %>').text('0');
            $('#<%= LblOthers.ClientID %>').text('0');
        }

        function getInitials(fullName) {
            if (!fullName) return "??";

            var names = fullName.split(' ');
            if (names.length === 1) {
                return names[0].length >= 2 ? names[0].substring(0, 2).toUpperCase() : names[0].toUpperCase();
            }

            return (names[0][0] + names[names.length - 1][0]).toUpperCase();
        }
    </script>
</body>
</html>