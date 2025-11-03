<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="School_Managenment_System12._00.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .dashboard-header {
            margin-bottom: 30px;
        }

        .welcome-section h1 {
            color: #1d3557;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .date-display {
            color: #666;
            font-size: 16px;
            font-weight: 500;
        }

        /* Statistics Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            border: 1px solid rgba(0,0,0,0.03);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
        }

        .stat-card.students::before { background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%); }
        .stat-card.teachers::before { background: linear-gradient(135deg, #4cc9f0 0%, #4895ef 100%); }
        .stat-card.staff::before { background: linear-gradient(135deg, #f8961e 0%, #f3722c 100%); }
        .stat-card.awards::before { background: linear-gradient(135deg, #43aa8b 0%, #90be6d 100%); }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: white;
            margin-right: 15px;
        }

        .stat-icon.students { background: #4361ee; }
        .stat-icon.teachers { background: #4cc9f0; }
        .stat-icon.staff { background: #f8961e; }
        .stat-icon.awards { background: #43aa8b; }

        .stat-info {
            flex: 1;
        }

        .stat-title {
            font-size: 14px;
            color: #666;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #1d3557;
            line-height: 1;
            margin-bottom: 5px;
        }

        .stat-change {
            font-size: 12px;
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 20px;
            background: #e9ecef;
            color: #495057;
            display: inline-block;
        }

        .stat-change.positive {
            background: #d4edda;
            color: #155724;
        }

        /* Charts Section */
        .charts-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 40px;
        }

        .chart-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            border: 1px solid rgba(0,0,0,0.03);
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .chart-title {
            font-size: 18px;
            font-weight: 700;
            color: #1d3557;
        }

        .chart-subtitle {
            font-size: 14px;
            color: #666;
        }

        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }

        .gender-stats {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
            text-align: center;
        }

        .gender-stat {
            padding: 15px;
        }

        .gender-value {
            font-size: 24px;
            font-weight: 700;
            color: #1d3557;
            display: block;
        }

        .gender-label {
            font-size: 14px;
            color: #666;
            display: block;
        }

        .boys-stat .gender-value { color: #4361ee; }
        .girls-stat .gender-value { color: #f72585; }

        /* Attendance Comparison */
        .attendance-comparison {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-top: 20px;
        }

        .attendance-stat {
            text-align: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 12px;
        }

        .attendance-value {
            font-size: 24px;
            font-weight: 700;
            color: #1d3557;
            display: block;
        }

        .attendance-label {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }

        /* Agenda Section */
        .agenda-section {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            border: 1px solid rgba(0,0,0,0.03);
        }

        .agenda-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .agenda-title {
            font-size: 20px;
            font-weight: 700;
            color: #1d3557;
        }

        .agenda-date {
            color: #666;
            font-weight: 500;
        }

        .agenda-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .agenda-item {
            display: flex;
            align-items: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            border-left: 4px solid #4361ee;
            transition: all 0.3s ease;
        }

        .agenda-item:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }

        .agenda-time {
            min-width: 120px;
            font-weight: 600;
            color: #1d3557;
            font-size: 14px;
        }

        .agenda-task {
            flex: 1;
            font-weight: 500;
            color: #495057;
        }

        .agenda-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-completed {
            background: #d4edda;
            color: #155724;
        }

        .status-inprogress {
            background: #fff3cd;
            color: #856404;
        }

        .status-upcoming {
            background: #d1ecf1;
            color: #0c5460;
        }

        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 30px;
        }

        .action-btn {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 20px;
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            color: #495057;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            text-align: left;
        }

        .action-btn:hover {
            border-color: #4361ee;
            color: #4361ee;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.1);
        }

        .action-btn i {
            font-size: 20px;
            width: 24px;
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .charts-section {
                grid-template-columns: 1fr;
            }
            
            .stat-value {
                font-size: 28px;
            }
        }

        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .gender-stats {
                flex-direction: column;
                gap: 10px;
            }
            
            .attendance-comparison {
                grid-template-columns: 1fr;
            }
            
            .agenda-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .agenda-time {
                min-width: auto;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Dashboard Header -->
    <div class="dashboard-header">
        <div class="welcome-section">
            <h1>Welcome to EduManage Pro</h1>
            <div class="date-display">
                <i class="fas fa-calendar-alt"></i>
                <asp:Label ID="lblTodayDate" runat="server" Text=""></asp:Label>
            </div>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="stats-grid">
        <!-- Students Card -->
        <div class="stat-card students">
            <div class="stat-header">
                <div class="stat-icon students">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <div class="stat-info">
                    <div class="stat-title">Total Students</div>
                    <div class="stat-value">
                        <asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label>
                    </div>
                    <span class="stat-change positive">
                        <asp:Label ID="lblStudentChange" runat="server" Text="+0 this month"></asp:Label>
                    </span>
                </div>
            </div>
        </div>

        <!-- Teachers Card -->
        <div class="stat-card teachers">
            <div class="stat-header">
                <div class="stat-icon teachers">
                    <i class="fas fa-chalkboard-teacher"></i>
                </div>
                <div class="stat-info">
                    <div class="stat-title">Total Teachers</div>
                    <div class="stat-value">
                        <asp:Label ID="lblTotalTeachers" runat="server" Text="0"></asp:Label>
                    </div>
                    <span class="stat-change positive">
                        <asp:Label ID="lblTeacherChange" runat="server" Text="+0 this term"></asp:Label>
                    </span>
                </div>
            </div>
        </div>

        <!-- Staff Card -->
        <div class="stat-card staff">
            <div class="stat-header">
                <div class="stat-icon staff">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-info">
                    <div class="stat-title">Total Staff</div>
                    <div class="stat-value">
                        <asp:Label ID="lblTotalStaff" runat="server" Text="0"></asp:Label>
                    </div>
                    <span class="stat-change positive">
                        <asp:Label ID="lblStaffChange" runat="server" Text="+0 new hires"></asp:Label>
                    </span>
                </div>
            </div>
        </div>

        <!-- Awards Card -->
        <div class="stat-card awards">
            <div class="stat-header">
                <div class="stat-icon awards">
                    <i class="fas fa-trophy"></i>
                </div>
                <div class="stat-info">
                    <div class="stat-title">Annual Awards</div>
                    <div class="stat-value">
                        <asp:Label ID="lblTotalAwards" runat="server" Text="0"></asp:Label>
                    </div>
                    <span class="stat-change positive">
                        <asp:Label ID="lblAwardChange" runat="server" Text="+0 this year"></asp:Label>
                    </span>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts Section -->
    <div class="charts-section">
        <!-- Gender Distribution Chart -->
        <div class="chart-card">
            <div class="chart-header">
                <div>
                    <div class="chart-title">Student Gender Distribution</div>
                    <div class="chart-subtitle">Current academic year</div>
                </div>
            </div>
            <div class="chart-container">
                <canvas id="genderChart"></canvas>
            </div>
            <div class="gender-stats">
                <div class="gender-stat boys-stat">
                    <span class="gender-value">
                        <asp:Label ID="lblBoysCount" runat="server" Text="0"></asp:Label>
                    </span>
                    <span class="gender-label">Boys</span>
                </div>
                <div class="gender-stat girls-stat">
                    <span class="gender-value">
                        <asp:Label ID="lblGirlsCount" runat="server" Text="0"></asp:Label>
                    </span>
                    <span class="gender-label">Girls</span>
                </div>
            </div>
        </div>

        <!-- Attendance Trend Chart -->
        <div class="chart-card">
            <div class="chart-header">
                <div>
                    <div class="chart-title">Attendance Trend</div>
                    <div class="chart-subtitle">Last 5 days overview</div>
                </div>
            </div>
            <div class="chart-container">
                <canvas id="attendanceChart"></canvas>
            </div>
            <div class="attendance-comparison">
                <div class="attendance-stat">
                    <span class="attendance-value">
                        <asp:Label ID="lblThisWeekAttendance" runat="server" Text="0%"></asp:Label>
                    </span>
                    <span class="attendance-label">This Week</span>
                </div>
                <div class="attendance-stat">
                    <span class="attendance-value">
                        <asp:Label ID="lblLastWeekAttendance" runat="server" Text="0%"></asp:Label>
                    </span>
                    <span class="attendance-label">Last Week</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Agenda Section -->
    <div class="agenda-section">
        <div class="agenda-header">
            <div class="agenda-title">Today's Agenda</div>
            <div class="agenda-date">
                <asp:Label ID="lblAgendaDate" runat="server" Text=""></asp:Label>
            </div>
        </div>

        <div class="agenda-list">
            <!-- Dynamic Agenda (visible when data exists) -->
            <asp:Repeater ID="rptAgenda" runat="server" Visible="false">
                <ItemTemplate>
                    <div class="agenda-item">
                        <div class="agenda-time">
                            <i class="fas fa-clock"></i>
                            <%# Eval("Time") %>
                        </div>
                        <div class="agenda-task"><%# Eval("Task") %></div>
                        <div class="agenda-status <%# Eval("StatusClass") %>">
                            <%# Eval("Status") %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <!-- Default Agenda (visible when no dynamic data) -->
            <asp:Panel ID="pnlDefaultAgenda" runat="server" Visible="true">
                <div class="agenda-item">
                    <div class="agenda-time">
                        <i class="fas fa-clock"></i>
                        08:00 - 08:30
                    </div>
                    <div class="agenda-task">Morning Assembly & Flag Ceremony</div>
                    <div class="agenda-status status-completed">Completed</div>
                </div>
                
                <div class="agenda-item">
                    <div class="agenda-time">
                        <i class="fas fa-clock"></i>
                        09:00 - 10:00
                    </div>
                    <div class="agenda-task">Mathematics Class - Grade 10A</div>
                    <div class="agenda-status status-inprogress">In Progress</div>
                </div>
                
                <div class="agenda-item">
                    <div class="agenda-time">
                        <i class="fas fa-clock"></i>
                        10:30 - 11:30
                    </div>
                    <div class="agenda-task">Science Laboratory Session</div>
                    <div class="agenda-status status-upcoming">Upcoming</div>
                </div>
                
                <div class="agenda-item">
                    <div class="agenda-time">
                        <i class="fas fa-clock"></i>
                        12:00 - 13:00
                    </div>
                    <div class="agenda-task">Staff Meeting - Academic Planning</div>
                    <div class="agenda-status status-upcoming">Upcoming</div>
                </div>
                
                <div class="agenda-item">
                    <div class="agenda-time">
                        <i class="fas fa-clock"></i>
                        14:00 - 15:00
                    </div>
                    <div class="agenda-task">Parent-Teacher Conference</div>
                    <div class="agenda-status status-upcoming">Upcoming</div>
                </div>
            </asp:Panel>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <asp:HyperLink ID="lnkMarkAttendance" runat="server" CssClass="action-btn" NavigateUrl="~/Attendance.aspx">
                <i class="fas fa-clipboard-check"></i>
                <span>Mark Attendance</span>
            </asp:HyperLink>
            
            <asp:HyperLink ID="lnkAddStudent" runat="server" CssClass="action-btn" NavigateUrl="~/Add_Student.aspx">
                <i class="fas fa-user-plus"></i>
                <span>Add New Student</span>
            </asp:HyperLink>
            
            <asp:HyperLink ID="lnkAddTeacher" runat="server" CssClass="action-btn" NavigateUrl="~/Add_Teachers.aspx">
                <i class="fas fa-chalkboard-teacher"></i>
                <span>Add Teacher</span>
            </asp:HyperLink>
            
            <asp:HyperLink ID="lnkViewReports" runat="server" CssClass="action-btn" NavigateUrl="~/Reports.aspx">
                <i class="fas fa-chart-bar"></i>
                <span>View Reports</span>
            </asp:HyperLink>
        </div>
    </div>

    <!-- Hidden Fields for Chart Data -->
    <asp:HiddenField ID="hfBoysCount" runat="server" Value="0" />
    <asp:HiddenField ID="hfGirlsCount" runat="server" Value="0" />
    <asp:HiddenField ID="hfAttendanceData" runat="server" Value="0" />

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Initialize charts
            initializeGenderChart();
            initializeAttendanceChart();
        });

        function initializeGenderChart() {
            const boysCount = parseInt(document.getElementById('<%= hfBoysCount.ClientID %>').value) || 0;
            const girlsCount = parseInt(document.getElementById('<%= hfGirlsCount.ClientID %>').value) || 0;
            const totalStudents = parseInt(document.getElementById('<%= lblTotalStudents.ClientID %>').innerText.replace(/,/g, '')) || 0;

            const ctx = document.getElementById('genderChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Boys', 'Girls'],
                    datasets: [{
                        data: [boysCount, girlsCount],
                        backgroundColor: ['#4361ee', '#f72585'],
                        borderWidth: 0,
                        hoverOffset: 15
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '70%',
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true,
                                font: {
                                    size: 12,
                                    weight: '600'
                                }
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    const label = context.label || '';
                                    const value = context.parsed || 0;
                                    const percentage = totalStudents > 0 ? ((value / totalStudents) * 100).toFixed(1) + '%' : '0%';
                                    return `${label}: ${value.toLocaleString()} (${percentage})`;
                                }
                            }
                        }
                    }
                }
            });
        }

        function initializeAttendanceChart() {
            const attendanceData = document.getElementById('<%= hfAttendanceData.ClientID %>').value;
            const dataPoints = attendanceData.split(',').map(Number);
            const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

            const ctx = document.getElementById('attendanceChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Attendance Rate',
                        data: dataPoints,
                        borderColor: '#43aa8b',
                        backgroundColor: 'rgba(67, 170, 139, 0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: '#43aa8b',
                        pointBorderColor: '#ffffff',
                        pointBorderWidth: 2,
                        pointRadius: 6,
                        pointHoverRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: false,
                            min: 80,
                            max: 100,
                            ticks: {
                                callback: function (value) {
                                    return value + '%';
                                },
                                font: {
                                    size: 11,
                                    weight: '600'
                                }
                            },
                            grid: {
                                color: 'rgba(0,0,0,0.05)'
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                font: {
                                    size: 11,
                                    weight: '600'
                                }
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return `Attendance: ${context.parsed.y}%`;
                                }
                            }
                        }
                    }
                }
            });
        }

        // Auto-refresh dashboard every 5 minutes
        setInterval(function () {
            // You can implement auto-refresh here if needed
            // window.location.reload();
        }, 300000);
    </script>
</asp:Content>