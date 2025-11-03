<%@ Page Title="Achievements" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Achievements.aspx.cs" Inherits="School_Managenment_System12._00.Achievements" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .achievements-container {
            background: #1a1f2e;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid #2a3a4a;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #0f4d2e 0%, #1a3a29 100%);
            color: white;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 6px 20px rgba(0,0,0,0.3);
            border: 1px solid #2a6d46;
        }

            .stat-card.warning {
                background: linear-gradient(135deg, #5d4037 0%, #3e2723 100%);
                border-color: #8d6e63;
            }

            .stat-card.info {
                background: linear-gradient(135deg, #01579b 0%, #00264d 100%);
                border-color: #0277bd;
            }

            .stat-card.success {
                background: linear-gradient(135deg, #2e7d32 0%, #1b5e20 100%);
                border-color: #4caf50;
            }

        .stat-number {
            font-size: 32px;
            font-weight: bold;
            margin: 10px 0;
            color: #4caf50;
        }

        .stat-label {
            font-size: 14px;
            opacity: 0.9;
            color: #a5d6a7;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .btn-achievement {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 20px;
            background: linear-gradient(135deg, #2e7d32 0%, #1b5e20 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(46, 125, 50, 0.3);
        }

            .btn-achievement:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(46, 125, 50, 0.4);
                background: linear-gradient(135deg, #388e3c 0%, #2e7d32 100%);
            }

            .btn-achievement.secondary {
                background: linear-gradient(135deg, #5d4037 0%, #4e342e 100%);
                box-shadow: 0 4px 15px rgba(93, 64, 55, 0.3);
            }

                .btn-achievement.secondary:hover {
                    background: linear-gradient(135deg, #6d4c41 0%, #5d4037 100%);
                    box-shadow: 0 6px 20px rgba(109, 76, 65, 0.4);
                }

        .search-filter {
            background: #2d3748;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            border: 1px solid #4a5568;
        }

        .search-row {
            display: grid;
            grid-template-columns: 1fr 1fr auto;
            gap: 15px;
            align-items: end;
        }

        .form-group {
            margin-bottom: 0;
        }

        .form-label {
            color: #e2e8f0;
            font-weight: 600;
            margin-bottom: 8px;
            display: block;
            font-size: 14px;
        }

        .form-control {
            background: #4a5568;
            border: 1px solid #718096;
            color: #fff;
            border-radius: 6px;
            padding: 10px 12px;
            width: 100%;
            transition: all 0.3s ease;
        }

            .form-control:focus {
                outline: none;
                border-color: #4caf50;
                box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
            }

        .achievements-grid {
            background: #2d3748;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid #4a5568;
        }

        .grid-header {
            background: linear-gradient(135deg, #2e7d32 0%, #1b5e20 100%);
            padding: 15px 20px;
            color: white;
            font-weight: 600;
        }

        .achievement-card {
            background: #4a5568;
            border-bottom: 1px solid #718096;
            padding: 20px;
            transition: all 0.3s ease;
        }

            .achievement-card:hover {
                background: #556270;
                transform: translateX(5px);
            }

            .achievement-card:last-child {
                border-bottom: none;
            }

        .achievement-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .achievement-title {
            color: #e2e8f0;
            font-weight: 600;
            font-size: 18px;
            margin-bottom: 5px;
        }

        .achievement-description {
            color: #a0aec0;
            font-size: 14px;
            line-height: 1.5;
        }

        .achievement-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
        }

        .detail-label {
            color: #a0aec0;
            font-size: 12px;
            margin-bottom: 5px;
        }

        .detail-value {
            color: #e2e8f0;
            font-size: 14px;
            font-weight: 500;
        }

        .achievement-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-edit {
            background: #2196f3;
            color: white;
        }

            .btn-edit:hover {
                background: #1976d2;
            }

        .btn-delete {
            background: #f44336;
            color: white;
        }

            .btn-delete:hover {
                background: #d32f2f;
            }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #a0aec0;
            font-style: italic;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            padding: 20px;
            background: #2d3748;
            border-top: 1px solid #4a5568;
        }

        .page-info {
            color: #a0aec0;
            font-size: 14px;
        }

        /* Modal Styles */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 1000;
        }

        .modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: #2d3748;
            border-radius: 12px;
            width: 90%;
            max-width: 600px;
            max-height: 90vh;
            overflow-y: auto;
            border: 1px solid #4a5568;
        }

        .modal-header {
            background: linear-gradient(135deg, #2e7d32 0%, #1b5e20 100%);
            padding: 20px;
            border-radius: 12px 12px 0 0;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            font-size: 20px;
            font-weight: 600;
        }

        .close-modal {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
            padding: 0;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-body {
            padding: 25px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-full {
            grid-column: 1 / -1;
        }

        @media (max-width: 768px) {
            .search-row {
                grid-template-columns: 1fr;
            }

            .achievement-header {
                flex-direction: column;
                gap: 10px;
            }

            .achievement-actions {
                justify-content: flex-start;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Add ScriptManager for handling partial postbacks -->
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    
    <div class="achievements-container">
        <div class="alert-header">
            <h2 style="color: #e2e8f0; margin-bottom: 10px;">Achievements Management</h2>
            <p style="color: #a0aec0; margin: 0;">Manage and track school achievements and accomplishments</p>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-trophy"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblTotalAchievements" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Total Achievements</div>
            </div>

            <div class="stat-card info">
                <div class="stat-icon">
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblCurrentYearAchievements" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">This Year</div>
            </div>

            <div class="stat-card success">
                <div class="stat-icon">
                    <i class="fas fa-star"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblRecentAchievements" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Last 30 Days</div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <asp:Button ID="btnAddAchievement" runat="server" Text="+ Add New Achievement"
                CssClass="btn-achievement" OnClientClick="openAddModal(); return false;" />
            <!-- Fixed Generate Report Button - Use LinkButton for better file download handling -->
            <asp:LinkButton ID="btnGenerateReport" runat="server" Text="Generate Report" CssClass="btn-achievement secondary" OnClick="btnGenerateReport_Click" />
        </div>

        <!-- Search and Filter -->
        <div class="search-filter">
            <div class="search-row">
                <div class="form-group">
                    <label class="form-label">Search</label>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                        placeholder="Search by title or description..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label class="form-label">Academic Year</label>
                    <asp:DropDownList ID="ddlYearFilter" runat="server" CssClass="form-control"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlYearFilter_SelectedIndexChanged">
                        <asp:ListItem Value="">All Years</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <asp:Button ID="btnClearFilters" runat="server" Text="Clear Filters"
                        CssClass="btn-achievement secondary" OnClick="btnClearFilters_Click" />
                </div>
            </div>
        </div>

        <!-- Achievements Grid -->
        <div class="achievements-grid">
            <div class="grid-header">
                School Achievements
            </div>

            <asp:Repeater ID="rptAchievements" runat="server" OnItemCommand="rptAchievements_ItemCommand">
                <ItemTemplate>
                    <div class="achievement-card">
                        <div class="achievement-header">
                            <div style="flex: 1;">
                                <div class="achievement-title"><%# Eval("Title") %></div>
                                <div class="achievement-description"><%# Eval("Description") %></div>
                            </div>
                            <div style="text-align: right;">
                                <span class="detail-value" style="color: #4caf50; font-weight: bold;">
                                    <%# Eval("AcademicYear") %>
                                </span>
                            </div>
                        </div>

                        <div class="achievement-details">
                            <div class="detail-item">
                                <span class="detail-label">Achieved Date</span>
                                <span class="detail-value"><%# Eval("AchievedDate", "{0:MMM dd, yyyy}") %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Recorded On</span>
                                <span class="detail-value"><%# Eval("CreatedDate", "{0:MMM dd, yyyy}") %></span>
                            </div>
                        </div>

                        <div class="achievement-actions">
                            <asp:LinkButton ID="btnEdit" CausesValidation="false" runat="server" Text="Edit"
                                CssClass="btn-action btn-edit"
                                CommandName="Edit"
                                CommandArgument='<%# Eval("AchievementId") %>' />

                            <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="false" Text="Delete"
                                CssClass="btn-action btn-delete"
                                CommandName="Delete"
                                CommandArgument='<%# Eval("AchievementId") %>'
                                OnClientClick='<%# "return confirmDelete(\"" + Eval("Title") + "\");" %>' />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Label ID="lblNoAchievements" runat="server" Text="No achievements found matching your criteria."
                CssClass="no-data" Visible="false"></asp:Label>
        </div>

        <!-- Pagination -->
        <div class="pagination">
            <asp:Button ID="btnPrev" runat="server" Text="← Previous"
                CssClass="btn-achievement secondary" OnClick="btnPrev_Click" Enabled="false" />
            <span class="page-info">Page
                <asp:Label ID="lblCurrentPage" runat="server" Text="1"></asp:Label>
                of 
                <asp:Label ID="lblTotalPages" runat="server" Text="1"></asp:Label>
            </span>
            <asp:Button ID="btnNext" runat="server" Text="Next →"
                CssClass="btn-achievement secondary" OnClick="btnNext_Click" Enabled="false" />
        </div>
    </div>

    <!-- Add/Edit Achievement Modal -->
    <div id="achievementModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">
                    <asp:Label ID="lblModalTitle" runat="server" Text="Add New Achievement"></asp:Label>
                </div>
                <button type="button" class="close-modal" onclick="closeAchievementModal()">×</button>
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfAchievementId" runat="server" Value="0" />
                
                <div class="form-grid">
                    <div class="form-group form-full">
                        <label class="form-label">Title *</label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"
                            placeholder="Enter achievement title" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle"
                            ErrorMessage="Title is required" Display="Dynamic" ForeColor="#f44336" Font-Size="12px"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group form-full">
                        <label class="form-label">Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="3" placeholder="Enter achievement description (optional)"
                            MaxLength="255"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Academic Year *</label>
                        <asp:DropDownList ID="ddlAcademicYear" runat="server" CssClass="form-control">
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvAcademicYear" runat="server" ControlToValidate="ddlAcademicYear"
                            ErrorMessage="Academic Year is required" Display="Dynamic" ForeColor="#f44336" Font-Size="12px"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Achieved Date *</label>
                        <asp:TextBox ID="txtAchievedDate" runat="server" CssClass="form-control"
                            TextMode="Date"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAchievedDate" runat="server" ControlToValidate="txtAchievedDate"
                            ErrorMessage="Achieved Date is required" Display="Dynamic" ForeColor="#f44336" Font-Size="12px"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <div style="display: flex; gap: 10px; margin-top: 25px; justify-content: flex-end;">
                    <asp:Button ID="btnSaveAchievement" runat="server" Text="Save Achievement"
                        CssClass="btn-achievement" OnClick="btnSaveAchievement_Click" />
                    <button type="button" class="btn-achievement secondary" onclick="closeAchievementModal()">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // Modal Functions
        function openAddModal() {
            console.log('Opening add achievement modal');
            document.getElementById('achievementModal').style.display = 'block';
            document.getElementById('<%= lblModalTitle.ClientID %>').textContent = 'Add New Achievement';
            document.getElementById('<%= hfAchievementId.ClientID %>').value = '0';

            // Reset form
            document.getElementById('<%= txtTitle.ClientID %>').value = '';
            document.getElementById('<%= txtDescription.ClientID %>').value = '';
            document.getElementById('<%= ddlAcademicYear.ClientID %>').selectedIndex = 0;

            // Set default date to today
            var today = new Date();
            var todayFormatted = today.toISOString().split('T')[0];
            document.getElementById('<%= txtAchievedDate.ClientID %>').value = todayFormatted;
        }

        function openEditModal(achievementId, title, description, academicYear, achievedDate) {
            console.log('Opening edit achievement modal for ID:', achievementId);
            document.getElementById('achievementModal').style.display = 'block';
            document.getElementById('<%= lblModalTitle.ClientID %>').textContent = 'Edit Achievement';
            document.getElementById('<%= hfAchievementId.ClientID %>').value = achievementId;

            // Fill form with existing data
            document.getElementById('<%= txtTitle.ClientID %>').value = title;
            document.getElementById('<%= txtDescription.ClientID %>').value = description;

            // Set academic year
            var ddlAcademicYear = document.getElementById('<%= ddlAcademicYear.ClientID %>');
            for (var i = 0; i < ddlAcademicYear.options.length; i++) {
                if (ddlAcademicYear.options[i].value == academicYear) {
                    ddlAcademicYear.selectedIndex = i;
                    break;
                }
            }

            // Format date for input
            var date = new Date(achievedDate);
            var dateFormatted = date.toISOString().split('T')[0];
            document.getElementById('<%= txtAchievedDate.ClientID %>').value = dateFormatted;
        }

        function closeAchievementModal() {
            console.log('Closing achievement modal');
            document.getElementById('achievementModal').style.display = 'none';

            // Clear validation errors
            var validators = document.querySelectorAll('[id*="rfv"]');
            validators.forEach(function (validator) {
                validator.style.display = 'none';
            });
        }

        // Close modal when clicking outside
        window.onclick = function (event) {
            var modal = document.getElementById('achievementModal');
            if (event.target == modal) {
                closeAchievementModal();
            }
        }

        // Delete confirmation
        function confirmDelete(title) {
            return confirm('Are you sure you want to delete the achievement: "' + title + '"?');
        }

        // Initialize when page loads
        document.addEventListener('DOMContentLoaded', function () {
            console.log('Achievements page loaded successfully');

            // Add click event listener to the Generate Report button
            var generateReportBtn = document.getElementById('<%= btnGenerateReport.ClientID %>');
            if (generateReportBtn) {
                generateReportBtn.addEventListener('click', function () {
                    console.log('Generate Report button clicked');
                    // Show loading indicator
                    showNotification('Generating report, please wait...', 'info');
                });
            }
        });

        // Enhanced notification system
        function showNotification(message, type) {
            // Remove existing notifications
            var existingNotifications = document.querySelectorAll('.custom-notification');
            existingNotifications.forEach(function (notification) {
                notification.remove();
            });

            // Create notification element
            var notification = document.createElement('div');
            notification.className = 'custom-notification';
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 20px;
                border-radius: 5px;
                color: white;
                font-weight: bold;
                z-index: 10000;
                max-width: 400px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.3);
                animation: slideIn 0.3s ease;
                font-family: Arial, sans-serif;
            `;

            if (type === 'success') {
                notification.style.background = '#4caf50';
                notification.innerHTML = '<i class="fas fa-check-circle"></i> ' + message;
            } else if (type === 'error') {
                notification.style.background = '#f44336';
                notification.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + message;
            } else if (type === 'info') {
                notification.style.background = '#2196f3';
                notification.innerHTML = '<i class="fas fa-info-circle"></i> ' + message;
            }

            document.body.appendChild(notification);

            // Remove notification after 5 seconds
            setTimeout(function () {
                if (notification.parentNode) {
                    notification.style.animation = 'slideOut 0.3s ease';
                    setTimeout(function () {
                        if (notification.parentNode) {
                            notification.parentNode.removeChild(notification);
                        }
                    }, 300);
                }
            }, 5000);
        }

        // Add CSS for notifications and animations
        if (!document.querySelector('#notification-styles')) {
            var style = document.createElement('style');
            style.id = 'notification-styles';
            style.textContent = `
                @keyframes slideIn {
                    from { transform: translateX(100%); opacity: 0; }
                    to { transform: translateX(0); opacity: 1; }
                }
                @keyframes slideOut {
                    from { transform: translateX(0); opacity: 1; }
                    to { transform: translateX(100%); opacity: 0; }
                }
                .custom-notification i {
                    margin-right: 8px;
                }
            `;
            document.head.appendChild(style);
        }
    </script>
</asp:Content>