<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Attendance_Reports.aspx.cs" Inherits="School_Managenment_System12._00.Attendance_Reports" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Attendance Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <style>
        .report-card {
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            border: none;
            margin-bottom: 20px;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
        }
        .chart-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .attendance-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
        }
        .attendance-table td {
            vertical-align: middle;
            padding: 12px 8px;
        }
        .btn-export {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            color: white;
            transition: all 0.3s ease;
        }
        .btn-logout {
            background: linear-gradient(135deg, #dc3545, #e83e8c);
            border: none;
            color: white;
            transition: all 0.3s ease;
        }
        .btn-export:hover, .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
        }
        .badge {
            font-size: 12px;
            padding: 6px 12px;
            border-radius: 20px;
        }
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        .btn-outline-secondary:hover {
            transform: translateY(-2px);
        }
        .header-buttons {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
    </style>
</head>
<body style="background-color: #f8f9fa;">
    <form id="form1" runat="server">
        <div class="container-fluid py-4">
            <!-- Header -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card report-card bg-primary text-white">
                        <div class="card-body py-4">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h2 class="mb-2"><i class="fas fa-chart-bar me-3"></i>Attendance Reports</h2>
                                    <p class="mb-0 opacity-75">View and analyze attendance data by date and class</p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <div class="header-buttons">
                                        <asp:Button ID="btnExport" runat="server" Text="📊 Export to Excel" 
                                            CssClass="btn btn-light btn-export fw-bold px-4 py-2" OnClick="btnExport_Click" />
                                        <asp:Button ID="btnLogout" runat="server" Text="🚪Back Dashboard" 
                                            CssClass="btn btn-light btn-logout fw-bold px-4 py-2" OnClick="btnLogout_Click" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filters -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card report-card h-100">
                        <div class="card-body">
                            <label class="form-label fw-bold text-primary mb-2">
                                <i class="fas fa-calendar-day me-2"></i>Start Date
                            </label>
                            <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control form-control-lg datepicker" 
                                placeholder="Select start date"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card report-card h-100">
                        <div class="card-body">
                            <label class="form-label fw-bold text-primary mb-2">
                                <i class="fas fa-calendar-day me-2"></i>End Date
                            </label>
                            <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control form-control-lg datepicker" 
                                placeholder="Select end date"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card report-card h-100">
                        <div class="card-body">
                            <label class="form-label fw-bold text-primary mb-2">
                                <i class="fas fa-users me-2"></i>Class
                            </label>
                            <asp:DropDownList ID="ddlClass" runat="server" CssClass="form-control form-control-lg">
                                <asp:ListItem Value="0">All Classes</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card report-card h-100">
                        <div class="card-body">
                            <label class="form-label fw-bold text-primary mb-2">
                                <i class="fas fa-filter me-2"></i>Status
                            </label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control form-control-lg">
                                <asp:ListItem Value="">All Status</asp:ListItem>
                                <asp:ListItem Value="Present">✅ Present</asp:ListItem>
                                <asp:ListItem Value="Absent">❌ Absent</asp:ListItem>
                                <asp:ListItem Value="Late">⏰ Late</asp:ListItem>
                                <asp:ListItem Value="HalfDay">🕛 Half Day</asp:ListItem>
                                <asp:ListItem Value="Leave">🏠 Leave</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="row mb-4">
                <div class="col-12 text-center">
                    <asp:Button ID="btnGenerate" runat="server" Text="🚀 Generate Report" 
                        CssClass="btn btn-primary btn-lg px-5 py-3 fw-bold me-3" OnClick="btnGenerate_Click" />
                    <asp:Button ID="btnReset" runat="server" Text="🔄 Reset Filters" 
                        CssClass="btn btn-outline-secondary btn-lg px-5 py-3 fw-bold" OnClick="btnReset_Click" />
                </div>
            </div>

            <!-- Statistics -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stat-card h-100">
                        <div class="stat-icon mb-3">
                            <i class="fas fa-database fa-2x opacity-75"></i>
                        </div>
                        <h3 class="fw-bold"><asp:Label ID="lblTotalRecords" runat="server" Text="0"></asp:Label></h3>
                        <p class="mb-0 opacity-75">Total Records</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card h-100" style="background: linear-gradient(135deg, #28a745, #20c997);">
                        <div class="stat-icon mb-3">
                            <i class="fas fa-check-circle fa-2x opacity-75"></i>
                        </div>
                        <h3 class="fw-bold"><asp:Label ID="lblPresentCount" runat="server" Text="0"></asp:Label></h3>
                        <p class="mb-0 opacity-75">Present</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card h-100" style="background: linear-gradient(135deg, #dc3545, #e83e8c);">
                        <div class="stat-icon mb-3">
                            <i class="fas fa-times-circle fa-2x opacity-75"></i>
                        </div>
                        <h3 class="fw-bold"><asp:Label ID="lblAbsentCount" runat="server" Text="0"></asp:Label></h3>
                        <p class="mb-0 opacity-75">Absent</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card h-100" style="background: linear-gradient(135deg, #ffc107, #fd7e14);">
                        <div class="stat-icon mb-3">
                            <i class="fas fa-clock fa-2x opacity-75"></i>
                        </div>
                        <h3 class="fw-bold"><asp:Label ID="lblOtherCount" runat="server" Text="0"></asp:Label></h3>
                        <p class="mb-0 opacity-75">Other</p>
                    </div>
                </div>
            </div>

            <!-- Reports Grid -->
            <div class="row">
                <div class="col-12">
                    <div class="card report-card">
                        <div class="card-header bg-white py-3">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <h5 class="card-title mb-0 text-primary">
                                        <i class="fas fa-list-alt me-2"></i>
                                        Attendance Details
                                    </h5>
                                </div>
                                <div class="col-md-6 text-end">
                                    <span class="badge bg-primary fs-6">
                                        <asp:Label ID="lblRecordCount" runat="server" Text="0 records"></asp:Label>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <asp:GridView ID="gvAttendance" runat="server" CssClass="table table-hover attendance-table mb-0" 
                                    AutoGenerateColumns="false" EmptyDataText="No attendance records found for the selected criteria." 
                                    ShowHeader="true" GridLines="None">
                                    <HeaderStyle CssClass="table-primary" />
                                    <RowStyle CssClass="border-bottom" />
                                    <EmptyDataRowStyle CssClass="text-center py-5" />
                                    <Columns>
                                        <asp:BoundField DataField="AttendanceDate" HeaderText="📅 Date" DataFormatString="{0:dd-MMM-yyyy}" 
                                            ItemStyle-Width="120px" HeaderStyle-Width="120px" />
                                        <asp:BoundField DataField="StudentName" HeaderText="👤 Student Name" 
                                            ItemStyle-Width="200px" HeaderStyle-Width="200px" />
                                        <asp:BoundField DataField="RollNumber" HeaderText="🔢 Roll No" 
                                            ItemStyle-Width="100px" HeaderStyle-Width="100px" />
                                        <asp:BoundField DataField="ClassName" HeaderText="🏫 Class" 
                                            ItemStyle-Width="120px" HeaderStyle-Width="120px" />
                                        <asp:TemplateField HeaderText="📊 Status" ItemStyle-Width="120px" HeaderStyle-Width="120px">
                                            <ItemTemplate>
                                                <span class='badge bg-<%# GetStatusBadge(Eval("Status").ToString()) %>'>
                                                    <%# GetStatusDisplay(Eval("Status").ToString()) %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="Remarks" HeaderText="💬 Remarks" 
                                            ItemStyle-Width="150px" HeaderStyle-Width="150px" />
                                        <asp:BoundField DataField="MarkedByName" HeaderText="✍️ Marked By" 
                                            ItemStyle-Width="150px" HeaderStyle-Width="150px" />
                                        <asp:BoundField DataField="MarkedAt" HeaderText="⏰ Marked At" DataFormatString="{0:dd-MMM-yyyy HH:mm}" 
                                            ItemStyle-Width="150px" HeaderStyle-Width="150px" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                        <div class="card-footer bg-white py-3">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <asp:Button ID="Button1" runat="server" Text="← Back to Dashboard"  
                                        CssClass="btn btn-outline-primary px-4" OnClick="Button1_Click" />
                                </div>
                                <div class="col-md-6 text-end">
                                    <small class="text-muted">
                                        <i class="fas fa-info-circle me-1"></i>
                                        Last updated: <%= DateTime.Now.ToString("dd-MMM-yyyy HH:mm") %>
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
    <script>
        $(document).ready(function () {
            $('.datepicker').datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayHighlight: true,
                orientation: "bottom auto"
            });

            // Set today's date as default
            $('#<%= txtStartDate.ClientID %>').datepicker('setDate', new Date());
            $('#<%= txtEndDate.ClientID %>').datepicker('setDate', new Date());

            // Add smooth scrolling
            $('a[href*="#"]').on('click', function (e) {
                e.preventDefault();
                $('html, body').animate({
                    scrollTop: $($(this).attr('href')).offset().top - 100
                }, 500);
            });
        });

        // Show loading indicator
        function showLoading() {
            $('body').append('<div class="loading-overlay"><div class="spinner-border text-primary"></div></div>');
        }

        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function () {
            const cards = document.querySelectorAll('.report-card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', function () {
                    this.style.transform = 'translateY(-5px)';
                    this.style.transition = 'all 0.3s ease';
                });
                card.addEventListener('mouseleave', function () {
                    this.style.transform = 'translateY(0)';
                });
            });
        });
    </script>

    <style>
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }
        .table-hover tbody tr:hover {
            background-color: rgba(102, 126, 234, 0.1) !important;
            transform: scale(1.01);
            transition: all 0.2s ease;
        }
        .card {
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
    </style>
</body>
</html>