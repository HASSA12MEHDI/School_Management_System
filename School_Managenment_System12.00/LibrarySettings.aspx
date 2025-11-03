<%@ Page Title="Library Settings" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="LibrarySettings.aspx.cs" Inherits="School_Managenment_System12._00.LibrarySettings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .settings-container {
            background: #1a1f2e;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid #2a3a4a;
        }

        .settings-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .settings-group {
            background: #2d3748;
            border-radius: 12px;
            padding: 25px;
            border: 1px solid #4a5568;
        }

        .group-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #4a5568;
        }

        .group-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #2e7d32 0%, #1b5e20 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
        }

        .group-title {
            color: #e2e8f0;
            font-weight: 600;
            font-size: 18px;
        }

        .group-description {
            color: #a0aec0;
            font-size: 14px;
            margin-top: 5px;
        }

        .setting-item {
            background: #374151;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            border: 1px solid #4a5568;
            transition: all 0.3s ease;
        }

        .setting-item:hover {
            border-color: #4caf50;
            transform: translateX(5px);
        }

        .setting-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
        }

        .setting-name {
            color: #e2e8f0;
            font-weight: 600;
            font-size: 16px;
            margin-bottom: 5px;
        }

        .setting-description {
            color: #a0aec0;
            font-size: 13px;
            line-height: 1.4;
        }

        .setting-controls {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .form-control {
            background: #4a5568;
            border: 1px solid #718096;
            color: #fff;
            border-radius: 6px;
            padding: 8px 12px;
            width: 100%;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #4caf50;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
        }

        .form-control-small {
            width: 120px;
        }

        .form-control-medium {
            width: 200px;
        }

        .btn-settings {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: linear-gradient(135deg, #2e7d32 0%, #1b5e20 100%);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 13px;
        }

        .btn-settings:hover {
            background: linear-gradient(135deg, #388e3c 0%, #2e7d32 100%);
            transform: translateY(-1px);
        }

        .btn-settings.secondary {
            background: linear-gradient(135deg, #5d4037 0%, #4e342e 100%);
        }

        .btn-settings.secondary:hover {
            background: linear-gradient(135deg, #6d4c41 0%, #5d4037 100%);
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #4a5568;
            justify-content: flex-end;
        }

        .no-settings {
            text-align: center;
            padding: 40px;
            color: #a0aec0;
            font-style: italic;
            grid-column: 1 / -1;
        }

        .setting-value-display {
            color: #4caf50;
            font-weight: 500;
            font-size: 14px;
            background: rgba(76, 175, 80, 0.1);
            padding: 4px 8px;
            border-radius: 4px;
            border: 1px solid rgba(76, 175, 80, 0.3);
        }

        .validation-message {
            color: #f44336;
            font-size: 12px;
            margin-top: 5px;
            display: block;
        }

        .success-message {
            background: linear-gradient(135deg, #2e7d32 0%, #1b5e20 100%);
            color: white;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-box {
            background: #1e3a5f;
            border: 1px solid #3b82f6;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
        }

        .info-title {
            color: #3b82f6;
            font-weight: 600;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-content {
            color: #a0aec0;
            font-size: 14px;
            line-height: 1.5;
        }

        .danger-zone {
            background: #7f1d1d;
            border: 1px solid #dc2626;
            border-radius: 8px;
            padding: 25px;
            margin-top: 30px;
        }

        .danger-title {
            color: #dc2626;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        @media (max-width: 768px) {
            .settings-grid {
                grid-template-columns: 1fr;
            }
            
            .setting-header {
                flex-direction: column;
                gap: 10px;
            }
            
            .setting-controls {
                width: 100%;
                justify-content: flex-start;
            }
            
            .form-control-small, .form-control-medium {
                width: 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="settings-container">
        <div class="alert-header">
            <h2 style="color: #e2e8f0; margin-bottom: 10px;">Library Settings</h2>
            <p style="color: #a0aec0; margin: 0;">Configure library system settings and preferences</p>
        </div>

        <!-- Success Message -->
        <asp:Panel ID="pnlSuccess" runat="server" CssClass="success-message" Visible="false">
            <i class="fas fa-check-circle"></i>
            <asp:Label ID="lblSuccessMessage" runat="server" Text="Settings updated successfully!"></asp:Label>
        </asp:Panel>

        <!-- Information Box -->
        <div class="info-box">
            <div class="info-title">
                <i class="fas fa-info-circle"></i>
                Library Settings Information
            </div>
            <div class="info-content">
                Configure your library system settings below. These settings control various aspects of library operations 
                including book issuing policies, fine calculations, and system behavior. Changes are applied immediately.
            </div>
        </div>

        <!-- Settings Form -->
        <asp:Panel ID="pnlSettings" runat="server">
            <div class="settings-grid">
                <!-- Book Issuing Settings -->
                <div class="settings-group">
                    <div class="group-header">
                        <div class="group-icon">
                            <i class="fas fa-share-square"></i>
                        </div>
                        <div>
                            <div class="group-title">Book Issuing Settings</div>
                            <div class="group-description">Configure book issuing policies and limits</div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-header">
                            <div style="flex: 1;">
                                <div class="setting-name">Issue Duration (Days)</div>
                                <div class="setting-description">Number of days a book can be issued to a student</div>
                            </div>
                            <div class="setting-controls">
                                <asp:TextBox ID="txtIssueDuration" runat="server" CssClass="form-control form-control-small" 
                                    TextMode="Number" min="1" max="30" placeholder="14"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvIssueDuration" runat="server" 
                                    ControlToValidate="txtIssueDuration" ErrorMessage="Required" 
                                    CssClass="validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rvIssueDuration" runat="server" 
                                    ControlToValidate="txtIssueDuration" Type="Integer" MinimumValue="1" MaximumValue="30"
                                    ErrorMessage="Must be 1-30 days" CssClass="validation-message" Display="Dynamic"></asp:RangeValidator>
                            </div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-header">
                            <div style="flex: 1;">
                                <div class="setting-name">Maximum Books Per Student</div>
                                <div class="setting-description">Maximum number of books a student can borrow at once</div>
                            </div>
                            <div class="setting-controls">
                                <asp:TextBox ID="txtMaxBooks" runat="server" CssClass="form-control form-control-small" 
                                    TextMode="Number" min="1" max="10" placeholder="3"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvMaxBooks" runat="server" 
                                    ControlToValidate="txtMaxBooks" ErrorMessage="Required" 
                                    CssClass="validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rvMaxBooks" runat="server" 
                                    ControlToValidate="txtMaxBooks" Type="Integer" MinimumValue="1" MaximumValue="10"
                                    ErrorMessage="Must be 1-10" CssClass="validation-message" Display="Dynamic"></asp:RangeValidator>
                            </div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-header">
                            <div style="flex: 1;">
                                <div class="setting-name">Renewal Period (Days)</div>
                                <div class="setting-description">Number of days to extend when renewing a book</div>
                            </div>
                            <div class="setting-controls">
                                <asp:TextBox ID="txtRenewalDays" runat="server" CssClass="form-control form-control-small" 
                                    TextMode="Number" min="1" max="30" placeholder="7"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvRenewalDays" runat="server" 
                                    ControlToValidate="txtRenewalDays" ErrorMessage="Required" 
                                    CssClass="validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rvRenewalDays" runat="server" 
                                    ControlToValidate="txtRenewalDays" Type="Integer" MinimumValue="1" MaximumValue="30"
                                    ErrorMessage="Must be 1-30 days" CssClass="validation-message" Display="Dynamic"></asp:RangeValidator>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Fine & Penalty Settings -->
                <div class="settings-group">
                    <div class="group-header">
                        <div class="group-icon">
                            <i class="fas fa-money-bill-wave"></i>
                        </div>
                        <div>
                            <div class="group-title">Fine & Penalty Settings</div>
                            <div class="group-description">Configure fine calculation and penalty policies</div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-header">
                            <div style="flex: 1;">
                                <div class="setting-name">Fine Amount Per Day</div>
                                <div class="setting-description">Daily fine amount for overdue books (in currency)</div>
                            </div>
                            <div class="setting-controls">
                                <asp:TextBox ID="txtFinePerDay" runat="server" CssClass="form-control form-control-small" 
                                    TextMode="Number" step="0.01" min="0" max="20" placeholder="5.00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvFinePerDay" runat="server" 
                                    ControlToValidate="txtFinePerDay" ErrorMessage="Required" 
                                    CssClass="validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rvFinePerDay" runat="server" 
                                    ControlToValidate="txtFinePerDay" Type="Double" MinimumValue="0" MaximumValue="20"
                                    ErrorMessage="Must be $0-20" CssClass="validation-message" Display="Dynamic"></asp:RangeValidator>
                            </div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-header">
                            <div style="flex: 1;">
                                <div class="setting-name">Grace Period (Days)</div>
                                <div class="setting-description">Days after due date before fines start accumulating</div>
                            </div>
                            <div class="setting-controls">
                                <asp:TextBox ID="txtGracePeriod" runat="server" CssClass="form-control form-control-small" 
                                    TextMode="Number" min="0" max="7" placeholder="0"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvGracePeriod" runat="server" 
                                    ControlToValidate="txtGracePeriod" ErrorMessage="Required" 
                                    CssClass="validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rvGracePeriod" runat="server" 
                                    ControlToValidate="txtGracePeriod" Type="Integer" MinimumValue="0" MaximumValue="7"
                                    ErrorMessage="Must be 0-7 days" CssClass="validation-message" Display="Dynamic"></asp:RangeValidator>
                            </div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-header">
                            <div style="flex: 1;">
                                <div class="setting-name">Maximum Fine Amount</div>
                                <div class="setting-description">Maximum fine that can be charged for a single book</div>
                            </div>
                            <div class="setting-controls">
                                <asp:TextBox ID="txtMaxFine" runat="server" CssClass="form-control form-control-small" 
                                    TextMode="Number" step="0.01" min="0" max="100" placeholder="50.00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvMaxFine" runat="server" 
                                    ControlToValidate="txtMaxFine" ErrorMessage="Required" 
                                    CssClass="validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rvMaxFine" runat="server" 
                                    ControlToValidate="txtMaxFine" Type="Double" MinimumValue="0" MaximumValue="100"
                                    ErrorMessage="Must be $0-100" CssClass="validation-message" Display="Dynamic"></asp:RangeValidator>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Library Information -->
                <div class="settings-group">
                    <div class="group-header">
                        <div class="group-icon">
                            <i class="fas fa-building"></i>
                        </div>
                        <div>
                            <div class="group-title">Library Information</div>
                            <div class="group-description">Basic library information and identification</div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-header">
                            <div style="flex: 1;">
                                <div class="setting-name">Library Name</div>
                                <div class="setting-description">Official name of the library</div>
                            </div>
                            <div class="setting-controls">
                                <asp:TextBox ID="txtLibraryName" runat="server" CssClass="form-control form-control-medium" 
                                    MaxLength="100" placeholder="School Library"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvLibraryName" runat="server" 
                                    ControlToValidate="txtLibraryName" ErrorMessage="Required" 
                                    CssClass="validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-header">
                            <div style="flex: 1;">
                                <div class="setting-name">Academic Year</div>
                                <div class="setting-description">Current academic year for record keeping</div>
                            </div>
                            <div class="setting-controls">
                                <asp:TextBox ID="txtAcademicYear" runat="server" CssClass="form-control form-control-medium" 
                                    MaxLength="20" placeholder="2024-2025"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvAcademicYear" runat="server" 
                                    ControlToValidate="txtAcademicYear" ErrorMessage="Required" 
                                    CssClass="validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-header">
                            <div style="flex: 1;">
                                <div class="setting-name">Library Contact Email</div>
                                <div class="setting-description">Email address for library communications</div>
                            </div>
                            <div class="setting-controls">
                                <asp:TextBox ID="txtContactEmail" runat="server" CssClass="form-control form-control-medium" 
                                    TextMode="Email" MaxLength="100" placeholder="library@school.edu"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="revContactEmail" runat="server" 
                                    ControlToValidate="txtContactEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                    ErrorMessage="Invalid email" CssClass="validation-message" Display="Dynamic"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Operational Settings -->
                <div class="settings-group">
                    <div class="group-header">
                        <div class="group-icon">
                            <i class="fas fa-cog"></i>
                        </div>
                        <div>
                            <div class="group-title">Operational Settings</div>
                            <div class="group-description">System behavior and operational preferences</div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-header">
                            <div style="flex: 1;">
                                <div class="setting-name">Issue Time</div>
                                <div class="setting-description">Default time for book issuing operations</div>
                            </div>
                            <div class="setting-controls">
                                <asp:TextBox ID="txtIssueTime" runat="server" CssClass="form-control form-control-small" 
                                    TextMode="Time" placeholder="08:00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvIssueTime" runat="server" 
                                    ControlToValidate="txtIssueTime" ErrorMessage="Required" 
                                    CssClass="validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-header">
                            <div style="flex: 1;">
                                <div class="setting-name">Return Time</div>
                                <div class="setting-description">Default time for book return operations</div>
                            </div>
                            <div class="setting-controls">
                                <asp:TextBox ID="txtReturnTime" runat="server" CssClass="form-control form-control-small" 
                                    TextMode="Time" placeholder="14:00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvReturnTime" runat="server" 
                                    ControlToValidate="txtReturnTime" ErrorMessage="Required" 
                                    CssClass="validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-header">
                            <div style="flex: 1;">
                                <div class="setting-name">Auto Renewal Allowed</div>
                                <div class="setting-description">Allow automatic renewal of books if no requests</div>
                            </div>
                            <div class="setting-controls">
                                <asp:CheckBox ID="cbAutoRenewal" runat="server" CssClass="form-control" />
                            </div>
                        </div>
                    </div>

                    <div class="setting-item">
                        <div class="setting-header">
                            <div style="flex: 1;">
                                <div class="setting-name">Send Overdue Notifications</div>
                                <div class="setting-description">Automatically send notifications for overdue books</div>
                            </div>
                            <div class="setting-controls">
                                <asp:CheckBox ID="cbSendNotifications" runat="server" CssClass="form-control" Checked="true" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <asp:Button ID="btnSaveSettings" runat="server" Text="Save All Settings" 
                    CssClass="btn-settings" OnClick="btnSaveSettings_Click" />
                <asp:Button ID="btnResetDefaults" runat="server" Text="Reset to Defaults" 
                    CssClass="btn-settings secondary" OnClick="btnResetDefaults_Click" 
                    OnClientClick="return confirm('Are you sure you want to reset all settings to default values?');" />
            </div>
        </asp:Panel>

        <!-- Danger Zone -->
        <div class="danger-zone">
            <div class="danger-title">
                <i class="fas fa-exclamation-triangle"></i>
                Danger Zone
            </div>
            <div class="info-content">
                <p>These actions are irreversible. Please proceed with caution.</p>
                <div style="display: flex; gap: 10px; margin-top: 15px;">
                    <asp:Button ID="btnClearAllData" runat="server" Text="Clear All Transaction Data" 
                        CssClass="btn-settings" 
                        Style="background: linear-gradient(135deg, #dc2626 0%, #7f1d1d 100%);" 
                        OnClientClick="return confirm('WARNING: This will permanently delete all book transaction records. This action cannot be undone. Are you absolutely sure?');" 
                        OnClick="btnClearAllData_Click" />
                    
                    <asp:Button ID="btnResetAllSettings" runat="server" Text="Reset Entire System" 
                        CssClass="btn-settings secondary" 
                        Style="background: linear-gradient(135deg, #ea580c 0%, #9a3412 100%);" 
                        OnClientClick="return confirm('WARNING: This will reset ALL system settings and configurations. This action cannot be undone. Are you absolutely sure?');" 
                        OnClick="btnResetAllSettings_Click" />
                </div>
            </div>
        </div>

        <!-- No Settings Message -->
        <asp:Label ID="lblNoSettings" runat="server" Text="No library settings found. Default settings will be used." 
            CssClass="no-settings" Visible="false"></asp:Label>
    </div>

    <script type="text/javascript">
        // Auto-format time inputs
        function formatTimeInput(input) {
            if (input.value.length === 4 && input.value.indexOf(':') === -1) {
                input.value = input.value.substring(0, 2) + ':' + input.value.substring(2);
            }
        }

        // Add input event listeners for time fields
        document.getElementById('<%= txtIssueTime.ClientID %>').addEventListener('input', function() {
            formatTimeInput(this);
        });

        document.getElementById('<%= txtReturnTime.ClientID %>').addEventListener('input', function() {
            formatTimeInput(this);
        });

        // Validate settings before submission
        function validateSettings() {
            var issueDuration = document.getElementById('<%= txtIssueDuration.ClientID %>');
            var maxBooks = document.getElementById('<%= txtMaxBooks.ClientID %>');
            var finePerDay = document.getElementById('<%= txtFinePerDay.ClientID %>');

            if (parseInt(issueDuration.value) < 1) {
                alert('Issue duration must be at least 1 day');
                issueDuration.focus();
                return false;
            }

            if (parseInt(maxBooks.value) < 1) {
                alert('Maximum books per student must be at least 1');
                maxBooks.focus();
                return false;
            }

            if (parseFloat(finePerDay.value) < 0) {
                alert('Fine per day cannot be negative');
                finePerDay.focus();
                return false;
            }

            return true;
        }

        // Attach validation to save button
        document.getElementById('<%= btnSaveSettings.ClientID %>').onclick = function () {
            return validateSettings();
        };
    </script>
</asp:Content>