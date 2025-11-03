<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FeeConcessions.aspx.cs" Inherits="School_Managenment_System12._00.FeeConcessions" MasterPageFile="~/Site2.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <title>Fee Concessions - School Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        :root {
            --primary: #6366f1;
            --secondary: #8b5cf6;
            --success: #10b981;
            --info: #3b82f6;
            --warning: #f59e0b;
            --danger: #ef4444;
            --dark: #1e293b;
            --light: #f8fafc;
            --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
            --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --gradient-success: linear-gradient(135deg, #10b981 0%, #059669 100%);
            --gradient-info: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            --gradient-warning: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            --gradient-danger: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        .fee-concessions-management {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            min-height: calc(100vh - 140px);
            padding: 20px 0;
        }

        .concessions-container {
            max-width: 1600px;
            margin: 0 auto;
            padding: 20px;
        }

        .concessions-header {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
        }

        .concessions-header::after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 50%;
            transform: translateX(-50%);
            width: 150px;
            height: 4px;
            background: var(--gradient-primary);
            border-radius: 2px;
        }

        .concessions-title {
            font-size: 42px;
            font-weight: 800;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
            text-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
            display: inline-block;
        }

        .concessions-subtitle {
            font-size: 18px;
            color: #64748b;
            font-weight: 500;
            opacity: 0.9;
        }

        .alert {
            padding: 18px 24px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 15px;
            border: none;
            backdrop-filter: blur(10px);
            font-size: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            transition: var(--transition);
            transform: translateY(-10px);
            opacity: 0;
            max-height: 0;
            overflow: hidden;
        }

        .alert.show {
            transform: translateY(0);
            opacity: 1;
            max-height: 200px;
            animation: slideIn 0.5s ease;
        }

        @keyframes slideIn {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .alert-success {
            background: var(--gradient-success);
            color: white;
        }

        .alert-danger {
            background: var(--gradient-danger);
            color: white;
        }

        .alert-warning {
            background: var(--gradient-warning);
            color: white;
        }

        .alert-info {
            background: var(--gradient-info);
            color: white;
        }

        .alert-icon {
            font-size: 24px;
            flex-shrink: 0;
        }

        .alert-content {
            flex: 1;
        }

        .alert-close {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            font-size: 18px;
            cursor: pointer;
            padding: 8px;
            border-radius: 50%;
            transition: var(--transition);
            flex-shrink: 0;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .alert-close:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: scale(1.1);
        }

        .hidden {
            display: none !important;
        }

        .concessions-content {
            display: grid;
            grid-template-columns: 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .form-section, .data-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: var(--card-shadow);
            border: 1px solid rgba(226, 232, 240, 0.8);
            transition: var(--transition);
        }

        .form-section:hover, .data-section:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }

        .section-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 25px;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            padding-bottom: 15px;
            border-bottom: 2px solid #e2e8f0;
        }

        .section-title i {
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 22px;
        }

        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            text-align: center;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: var(--gradient-primary);
        }

        .stat-card:nth-child(2)::before {
            background: var(--gradient-success);
        }

        .stat-card:nth-child(3)::before {
            background: var(--gradient-warning);
        }

        .stat-card:nth-child(4)::before {
            background: var(--gradient-info);
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }

        .stat-value {
            font-size: 36px;
            font-weight: 800;
            color: var(--primary);
            margin-bottom: 10px;
        }

        .stat-card:nth-child(2) .stat-value {
            color: var(--success);
        }

        .stat-card:nth-child(3) .stat-value {
            color: var(--warning);
        }

        .stat-card:nth-child(4) .stat-value {
            color: var(--info);
        }

        .stat-label {
            font-size: 14px;
            color: #64748b;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark);
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            background: #f8fafc;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            color: var(--dark);
            font-size: 15px;
            transition: var(--transition);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
            transform: translateY(-2px);
        }

        .form-control::placeholder {
            color: #94a3b8;
        }

        .btn-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-top: 25px;
        }

        .btn {
            padding: 14px 20px;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            font-size: 15px;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: white;
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(99, 102, 241, 0.4);
        }

        .btn-secondary {
            background: #f1f5f9;
            color: var(--dark);
            border: 2px solid #e2e8f0;
        }

        .btn-secondary:hover {
            background: #e2e8f0;
            transform: translateY(-3px);
        }

        .btn-danger {
            background: var(--gradient-danger);
            color: white;
            box-shadow: 0 8px 20px rgba(239, 68, 68, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(239, 68, 68, 0.4);
        }

        .btn-info {
            background: var(--gradient-info);
            color: white;
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
        }

        .btn-info:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(59, 130, 246, 0.4);
        }

        .btn-sm {
            padding: 8px 12px;
            font-size: 13px;
        }

        .data-table-container {
            overflow-x: auto;
            border-radius: 12px;
            background: white;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
        }

        .data-table th {
            background: var(--gradient-primary);
            color: white;
            padding: 16px 12px;
            text-align: left;
            font-weight: 700;
            font-size: 14px;
            border: none;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .data-table td {
            padding: 14px 12px;
            border-bottom: 1px solid #f1f5f9;
            color: var(--dark);
            font-size: 14px;
        }

        .data-table tr:hover {
            background: rgba(99, 102, 241, 0.05);
            transition: var(--transition);
        }

        .data-table tr:last-child td {
            border-bottom: none;
        }

        .amount-cell {
            font-weight: 700;
            color: var(--warning);
            font-size: 14px;
        }

        .actions-cell {
            display: flex;
            gap: 8px;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-align: center;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-active {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .status-inactive {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
        }

        .status-expired {
            background: rgba(148, 163, 184, 0.1);
            color: #64748b;
        }

        .search-filter {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr auto;
            gap: 15px;
            margin-bottom: 25px;
            align-items: end;
        }

        .search-box {
            position: relative;
        }

        .search-box i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            z-index: 2;
            font-size: 16px;
        }

        .search-box .form-control {
            padding-left: 45px;
        }

        .discount-input {
            position: relative;
        }

        .discount-input.percent::after {
            content: '%';
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-weight: 600;
            z-index: 2;
        }

        .discount-input.amount::before {
            content: 'Rs';
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-weight: 600;
            z-index: 2;
        }

        .discount-input.amount .form-control {
            padding-left: 45px;
        }

        .discount-input.percent .form-control {
            padding-right: 45px;
        }

        .form-check {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 15px;
        }

        .form-check-input {
            width: 20px;
            height: 20px;
        }

        .form-check-label {
            font-size: 15px;
            color: var(--dark);
            font-weight: 500;
        }

        .text-danger {
            color: var(--danger);
            font-size: 13px;
            font-weight: 600;
            margin-top: 5px;
            display: block;
        }

        .compact-table {
            font-size: 13px;
            min-width: 700px;
        }

        .compact-header th {
            padding: 12px 8px;
            font-size: 12px;
            font-weight: 600;
            background: var(--gradient-primary);
        }

        .compact-cell {
            padding: 10px 8px;
            font-size: 12px;
            line-height: 1.4;
            color: var(--dark);
        }

        .compact-row:hover, .compact-alt-row:hover {
            background: rgba(99, 102, 241, 0.05);
        }

        .compact-amount {
            font-size: 12px;
            font-weight: 600;
        }

        .compact-tag {
            padding: 4px 8px;
            font-size: 10px;
            border-radius: 12px;
        }

        .compact-actions {
            gap: 5px;
        }

        .btn-xs {
            padding: 6px 8px;
            font-size: 11px;
            min-width: 28px;
            height: 28px;
        }

        .btn-xs i {
            font-size: 10px;
        }

        .compact-pager {
            font-size: 12px;
            padding: 8px;
            color: var(--dark);
        }

        .compact-pager a {
            padding: 4px 8px;
            margin: 0 2px;
            color: var(--dark);
            text-decoration: none;
            border-radius: 4px;
        }

        .compact-pager a:hover {
            background: rgba(99, 102, 241, 0.1);
        }

        .data-table-container {
            max-height: 400px;
            overflow-y: auto;
        }

        @media (max-width: 1200px) {
            .concessions-content {
                grid-template-columns: 1fr;
            }
            .search-filter {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 768px) {
            .concessions-container {
                padding: 15px;
            }
            .concessions-title {
                font-size: 32px;
            }
            .search-filter {
                grid-template-columns: 1fr;
            }
            .form-row {
                grid-template-columns: 1fr;
            }
            .btn-group {
                grid-template-columns: 1fr;
            }
            .stats-cards {
                grid-template-columns: 1fr 1fr;
            }
            .form-section, .data-section {
                padding: 20px;
            }
            .alert {
                padding: 15px 20px;
                font-size: 14px;
            }
        }

        @media (max-width: 576px) {
            .stats-cards {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <div class="fee-concessions-management">
        <div class="concessions-container">
            <div class="concessions-header">
                <h1 class="concessions-title">Fee Concessions Management</h1>
                <p class="concessions-subtitle">Manage fee discounts and concessions for students</p>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-value">
                        <asp:Label ID="lblTotalConcessions" runat="server" Text="24"></asp:Label>
                    </div>
                    <div class="stat-label">Total Concessions</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <asp:Label ID="lblActiveConcessions" runat="server" Text="18"></asp:Label>
                    </div>
                    <div class="stat-label">Active Concessions</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <asp:Label ID="lblTotalDiscount" runat="server" Text="Rs 42,500"></asp:Label>
                    </div>
                    <div class="stat-label">Total Discount</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <asp:Label ID="lblExpiringSoon" runat="server" Text="3"></asp:Label>
                    </div>
                    <div class="stat-label">Expiring Soon</div>
                </div>
            </div>

            <!-- Enhanced Alert Messages -->
            <div id="alertContainer">
                <asp:Panel ID="pnlAlertSuccess" runat="server" CssClass="alert alert-success hidden">
                    <i class="fas fa-check-circle alert-icon"></i>
                    <div class="alert-content">
                        <asp:Label ID="lblAlertSuccessMessage" runat="server" Text=""></asp:Label>
                    </div>
                    <button type="button" class="alert-close" onclick="hideAlert(this)">
                        <i class="fas fa-times"></i>
                    </button>
                </asp:Panel>

                <asp:Panel ID="pnlAlertError" runat="server" CssClass="alert alert-danger hidden">
                    <i class="fas fa-exclamation-circle alert-icon"></i>
                    <div class="alert-content">
                        <asp:Label ID="lblAlertErrorMessage" runat="server" Text=""></asp:Label>
                    </div>
                    <button type="button" class="alert-close" onclick="hideAlert(this)">
                        <i class="fas fa-times"></i>
                    </button>
                </asp:Panel>

                <asp:Panel ID="pnlAlertWarning" runat="server" CssClass="alert alert-warning hidden">
                    <i class="fas fa-exclamation-triangle alert-icon"></i>
                    <div class="alert-content">
                        <asp:Label ID="lblAlertWarningMessage" runat="server" Text=""></asp:Label>
                    </div>
                    <button type="button" class="alert-close" onclick="hideAlert(this)">
                        <i class="fas fa-times"></i>
                    </button>
                </asp:Panel>

                <asp:Panel ID="pnlAlertInfo" runat="server" CssClass="alert alert-info hidden">
                    <i class="fas fa-info-circle alert-icon"></i>
                    <div class="alert-content">
                        <asp:Label ID="lblAlertInfoMessage" runat="server" Text=""></asp:Label>
                    </div>
                    <button type="button" class="alert-close" onclick="hideAlert(this)">
                        <i class="fas fa-times"></i>
                    </button>
                </asp:Panel>
            </div>

            <div class="concessions-content">
                <!-- Form Section -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-plus-circle"></i>
                        <asp:Label ID="lblFormTitle" runat="server" Text="Add New Concession"></asp:Label>
                    </div>

                    <asp:HiddenField ID="hfConcessionId" runat="server" />

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Student</label>
                            <asp:DropDownList ID="ddlStudent" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select Student</asp:ListItem>
                                <asp:ListItem Value="1">Ali Ahmed - Grade 10</asp:ListItem>
                                <asp:ListItem Value="2">Sara Khan - Grade 9</asp:ListItem>
                                <asp:ListItem Value="3">Mohammad Hassan - Grade 11</asp:ListItem>
                                <asp:ListItem Value="4">Fatima Raza - Grade 8</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvStudent" runat="server" ControlToValidate="ddlStudent"
                                ErrorMessage="Student is required" Display="Dynamic" CssClass="text-danger" InitialValue="">
                            </asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Fee Type</label>
                            <asp:DropDownList ID="ddlFee" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select Fee Type</asp:ListItem>
                                <asp:ListItem Value="Tuition">Tuition Fee</asp:ListItem>
                                <asp:ListItem Value="Transport">Transport Fee</asp:ListItem>
                                <asp:ListItem Value="Examination">Examination Fee</asp:ListItem>
                                <asp:ListItem Value="Library">Library Fee</asp:ListItem>
                                <asp:ListItem Value="Sports">Sports Fee</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvFee" runat="server" ControlToValidate="ddlFee"
                                ErrorMessage="Fee type is required" Display="Dynamic" CssClass="text-danger" InitialValue="">
                            </asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Concession Type</label>
                            <asp:DropDownList ID="ddlConcessionType" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select Type</asp:ListItem>
                                <asp:ListItem Value="Percentage">Percentage Discount</asp:ListItem>
                                <asp:ListItem Value="Fixed">Fixed Amount</asp:ListItem>
                                <asp:ListItem Value="Full Waiver">Full Waiver</asp:ListItem>
                                <asp:ListItem Value="Partial">Partial Waiver</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvConcessionType" runat="server" ControlToValidate="ddlConcessionType"
                                ErrorMessage="Concession type is required" Display="Dynamic" CssClass="text-danger" InitialValue="">
                            </asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Approved By</label>
                            <asp:DropDownList ID="ddlApprovedBy" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select Approver</asp:ListItem>
                                <asp:ListItem Value="1">Principal</asp:ListItem>
                                <asp:ListItem Value="2">Vice Principal</asp:ListItem>
                                <asp:ListItem Value="3">Finance Manager</asp:ListItem>
                                <asp:ListItem Value="4">Head of Department</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvApprovedBy" runat="server" ControlToValidate="ddlApprovedBy"
                                ErrorMessage="Approver is required" Display="Dynamic" CssClass="text-danger" InitialValue="">
                            </asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Discount Percentage</label>
                            <div class="discount-input percent">
                                <asp:TextBox ID="txtDiscountPercent" runat="server" CssClass="form-control"
                                    placeholder="0.00" TextMode="Number" step="0.01"></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Discount Amount</label>
                            <div class="discount-input amount">
                                <asp:TextBox ID="txtDiscountAmount" runat="server" CssClass="form-control"
                                    placeholder="0.00" TextMode="Number" step="0.01"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <asp:CustomValidator ID="cvDiscount" runat="server"
                        ControlToValidate="txtDiscountPercent"
                        OnServerValidate="CvDiscount_ServerValidate"
                        ErrorMessage="Please fill only one discount field (Percentage or Amount)"
                        Display="Dynamic" CssClass="text-danger">
                    </asp:CustomValidator>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Valid From</label>
                            <asp:TextBox ID="txtValidFrom" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvValidFrom" runat="server" ControlToValidate="txtValidFrom"
                                ErrorMessage="Valid from date is required" Display="Dynamic" CssClass="text-danger">
                            </asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Valid To</label>
                            <asp:TextBox ID="txtValidTo" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvValidTo" runat="server" ControlToValidate="txtValidTo"
                                ErrorMessage="Valid to date is required" Display="Dynamic" CssClass="text-danger">
                            </asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Reason</label>
                        <asp:TextBox ID="txtReason" runat="server" CssClass="form-control"
                            placeholder="Enter reason for concession" TextMode="MultiLine" Rows="2"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvReason" runat="server" ControlToValidate="txtReason"
                            ErrorMessage="Reason is required" Display="Dynamic" CssClass="text-danger">
                        </asp:RequiredFieldValidator>
                    </div>

                    <div class="form-check">
                        <asp:CheckBox ID="cbIsActive" runat="server" CssClass="form-check-input" Checked="true" />
                        <label class="form-check-label" for="<%= cbIsActive.ClientID %>">Active Concession</label>
                    </div>

                    <div class="btn-group">
                        <asp:Button ID="btnSave" runat="server" Text="Save Concession" CssClass="btn btn-primary"
                            OnClick="BtnSave_Click" OnClientClick="return validateForm();" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary"
                            OnClick="BtnCancel_Click" CausesValidation="false" />
                        <asp:Button ID="btnTestAlerts" runat="server" Text="Test Alerts" CssClass="btn btn-info"
                            OnClientClick="testAlerts(); return false;" CausesValidation="false" />
                    </div>
                </div>

                <!-- Data Section -->
                <div class="data-section">
                    <div class="section-title">
                        <i class="fas fa-receipt"></i>
                        Concession Records
                    </div>

                    <!-- Search and Filter -->
                    <div class="search-filter">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                                placeholder="Search concessions..." AutoPostBack="true" OnTextChanged="TxtSearch_TextChanged"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <asp:DropDownList ID="ddlTypeFilter" runat="server" CssClass="form-control"
                                AutoPostBack="true" OnSelectedIndexChanged="DdlTypeFilter_SelectedIndexChanged">
                                <asp:ListItem Value="">All Types</asp:ListItem>
                                <asp:ListItem Value="Percentage">Percentage</asp:ListItem>
                                <asp:ListItem Value="Fixed">Fixed Amount</asp:ListItem>
                                <asp:ListItem Value="Full Waiver">Full Waiver</asp:ListItem>
                                <asp:ListItem Value="Partial">Partial Waiver</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="form-group">
                            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control"
                                AutoPostBack="true" OnSelectedIndexChanged="DdlStatusFilter_SelectedIndexChanged">
                                <asp:ListItem Value="">All Status</asp:ListItem>
                                <asp:ListItem Value="Active">Active</asp:ListItem>
                                <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                                <asp:ListItem Value="Expired">Expired</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <asp:Button ID="btnExport" runat="server" Text="Export" CssClass="btn btn-secondary"
                            OnClick="BtnExport_Click" CausesValidation="false" />
                    </div>

                    <!-- Concessions GridView -->
                    <div class="data-table-container">
                        <asp:GridView ID="gvConcessions" runat="server" CssClass="data-table compact-table" AutoGenerateColumns="False"
                            DataKeyNames="ConcessionId" OnRowEditing="GvConcessions_RowEditing" OnRowDeleting="GvConcessions_RowDeleting"
                            EmptyDataText="No concession records found." OnRowDataBound="GvConcessions_RowDataBound"
                            AllowPaging="True" PageSize="8" OnPageIndexChanging="GvConcessions_PageIndexChanging"
                            ShowHeaderWhenEmpty="True" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="ConcessionId" HeaderText="ID" ItemStyle-Width="50px" ItemStyle-CssClass="compact-cell" />
                                <asp:BoundField DataField="StudentName" HeaderText="Student" ItemStyle-Width="120px" ItemStyle-CssClass="compact-cell" />
                                <asp:BoundField DataField="FeeType" HeaderText="Fee Type" ItemStyle-Width="90px" ItemStyle-CssClass="compact-cell" />
                                <asp:BoundField DataField="ConcessionType" HeaderText="Type" ItemStyle-Width="80px" ItemStyle-CssClass="compact-cell" />
                                <asp:TemplateField HeaderText="Discount" ItemStyle-Width="80px" ItemStyle-CssClass="compact-cell">
                                    <ItemTemplate>
                                        <span class="amount-cell compact-amount">
                                            <%# GetDiscountDisplay(Eval("DiscountPercent"), Eval("DiscountAmount")) %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ValidFrom" HeaderText="Valid From" DataFormatString="{0:MM/dd/yyyy}"
                                    ItemStyle-Width="80px" ItemStyle-CssClass="compact-cell" />
                                <asp:BoundField DataField="ValidTo" HeaderText="Valid To" DataFormatString="{0:MM/dd/yyyy}"
                                    ItemStyle-Width="80px" ItemStyle-CssClass="compact-cell" />
                                <asp:TemplateField HeaderText="Status" ItemStyle-Width="70px" ItemStyle-CssClass="compact-cell">
                                    <ItemTemplate>
                                        <span class='status-badge <%# GetStatusClass(Eval("IsActive"), Eval("ValidTo")) %> compact-tag'>
                                            <%# GetStatusText(Eval("IsActive"), Eval("ValidTo")) %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ApprovedByName" HeaderText="Approved By" ItemStyle-Width="100px" ItemStyle-CssClass="compact-cell" />
                                <asp:TemplateField HeaderText="Actions" ItemStyle-Width="60px" ItemStyle-CssClass="compact-cell">
                                    <ItemTemplate>
                                        <div class="actions-cell compact-actions">
                                            <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn btn-secondary btn-xs"
                                                CommandName="Edit" ToolTip="Edit Concession">
                                                <i class="fas fa-edit"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-danger btn-xs"
                                                CommandName="Delete" ToolTip="Delete Concession">
                                                <i class="fas fa-trash"></i>
                                            </asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="compact-pager" />
                            <HeaderStyle CssClass="compact-header" />
                            <RowStyle CssClass="compact-row" />
                            <AlternatingRowStyle CssClass="compact-alt-row" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Store control IDs in variables for easier access
        var pnlAlertSuccessId = '<%= pnlAlertSuccess.ClientID %>';
        var pnlAlertErrorId = '<%= pnlAlertError.ClientID %>';
        var pnlAlertWarningId = '<%= pnlAlertWarning.ClientID %>';
        var pnlAlertInfoId = '<%= pnlAlertInfo.ClientID %>';
        var lblAlertSuccessMessageId = '<%= lblAlertSuccessMessage.ClientID %>';
        var lblAlertErrorMessageId = '<%= lblAlertErrorMessage.ClientID %>';
        var lblAlertWarningMessageId = '<%= lblAlertWarningMessage.ClientID %>';
        var lblAlertInfoMessageId = '<%= lblAlertInfoMessage.ClientID %>';

        // Alert management functions
        function showAlert(type, message) {
            // Hide all alerts first
            hideAllAlerts();

            // Show the specific alert
            var alertElement, messageLabel;

            switch (type) {
                case 'Success':
                    alertElement = document.getElementById(pnlAlertSuccessId);
                    messageLabel = document.getElementById(lblAlertSuccessMessageId);
                    break;
                case 'Error':
                    alertElement = document.getElementById(pnlAlertErrorId);
                    messageLabel = document.getElementById(lblAlertErrorMessageId);
                    break;
                case 'Warning':
                    alertElement = document.getElementById(pnlAlertWarningId);
                    messageLabel = document.getElementById(lblAlertWarningMessageId);
                    break;
                case 'Info':
                    alertElement = document.getElementById(pnlAlertInfoId);
                    messageLabel = document.getElementById(lblAlertInfoMessageId);
                    break;
            }

            if (alertElement && messageLabel) {
                messageLabel.textContent = message;
                alertElement.classList.remove('hidden');
                setTimeout(function () {
                    alertElement.classList.add('show');
                }, 10);

                // Auto-hide after 5 seconds for success/info, 8 seconds for warning, 10 seconds for error
                var autoHideTime = type === 'Success' ? 5000 : type === 'Info' ? 5000 : type === 'Warning' ? 8000 : 10000;
                setTimeout(function () {
                    if (alertElement.classList.contains('show')) {
                        hideAlert(alertElement.querySelector('.alert-close'));
                    }
                }, autoHideTime);
            }
        }

        function hideAlert(closeButton) {
            var alertElement = closeButton.closest('.alert');
            alertElement.classList.remove('show');
            setTimeout(function () {
                alertElement.classList.add('hidden');
            }, 400);
        }

        function hideAllAlerts() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function (alert) {
                alert.classList.remove('show');
                setTimeout(function () {
                    alert.classList.add('hidden');
                }, 10);
            });
        }

        // Test function to demonstrate alerts
        function testAlerts() {
            showAlert('Success', 'Concession saved successfully! The record has been updated in the database.');
            setTimeout(function () {
                showAlert('Error', 'Failed to save concession. Please check all required fields and try again.');
            }, 1500);
            setTimeout(function () {
                showAlert('Warning', 'This concession will expire in 7 days. Consider renewing it soon.');
            }, 3000);
            setTimeout(function () {
                showAlert('Info', 'New concession policy has been implemented. Please review the updated guidelines.');
            }, 4500);
        }

        // Form validation
        function validateForm() {
            var student = document.getElementById('<%= ddlStudent.ClientID %>');
            var feeType = document.getElementById('<%= ddlFee.ClientID %>');
            var concessionType = document.getElementById('<%= ddlConcessionType.ClientID %>');
            var validFrom = document.getElementById('<%= txtValidFrom.ClientID %>');
            var validTo = document.getElementById('<%= txtValidTo.ClientID %>');
            var reason = document.getElementById('<%= txtReason.ClientID %>');

            if (student.value === '') {
                showAlert('Error', 'Please select a student.');
                student.focus();
                return false;
            }

            if (feeType.value === '') {
                showAlert('Error', 'Please select a fee type.');
                feeType.focus();
                return false;
            }

            if (concessionType.value === '') {
                showAlert('Error', 'Please select a concession type.');
                concessionType.focus();
                return false;
            }

            if (validFrom.value === '') {
                showAlert('Error', 'Please select a valid from date.');
                validFrom.focus();
                return false;
            }

            if (validTo.value === '') {
                showAlert('Error', 'Please select a valid to date.');
                validTo.focus();
                return false;
            }

            if (reason.value.trim() === '') {
                showAlert('Error', 'Please enter a reason for the concession.');
                reason.focus();
                return false;
            }

            // Check if valid to date is after valid from date
            var fromDate = new Date(validFrom.value);
            var toDate = new Date(validTo.value);
            if (toDate <= fromDate) {
                showAlert('Error', 'Valid to date must be after valid from date.');
                validTo.focus();
                return false;
            }

            showAlert('Success', 'Form validation successful! Saving concession...');
            return true;
        }

        // Set default dates on page load
        document.addEventListener('DOMContentLoaded', function () {
            var validFromField = document.getElementById('<%= txtValidFrom.ClientID %>');
            var validToField = document.getElementById('<%= txtValidTo.ClientID %>');

            if (validFromField && !validFromField.value) {
                var today = new Date();
                var dd = String(today.getDate()).padStart(2, '0');
                var mm = String(today.getMonth() + 1).padStart(2, '0');
                var yyyy = today.getFullYear();
                validFromField.value = yyyy + '-' + mm + '-' + dd;
            }

            if (validToField && !validToField.value) {
                var nextYear = new Date();
                nextYear.setFullYear(nextYear.getFullYear() + 1);
                var dd = String(nextYear.getDate()).padStart(2, '0');
                var mm = String(nextYear.getMonth() + 1).padStart(2, '0');
                var yyyy = nextYear.getFullYear();
                validToField.value = yyyy + '-' + mm + '-' + dd;
            }

            // Toggle discount fields based on concession type
            var concessionType = document.getElementById('<%= ddlConcessionType.ClientID %>');
            var discountPercent = document.getElementById('<%= txtDiscountPercent.ClientID %>');
            var discountAmount = document.getElementById('<%= txtDiscountAmount.ClientID %>');

            if (concessionType) {
                concessionType.addEventListener('change', function () {
                    switch (this.value) {
                        case 'Percentage':
                            discountPercent.disabled = false;
                            discountAmount.disabled = true;
                            discountAmount.value = '';
                            break;
                        case 'Fixed':
                            discountPercent.disabled = true;
                            discountAmount.disabled = false;
                            discountPercent.value = '';
                            break;
                        case 'Full Waiver':
                            discountPercent.disabled = true;
                            discountAmount.disabled = true;
                            discountPercent.value = '100';
                            discountAmount.value = '';
                            break;
                        default:
                            discountPercent.disabled = false;
                            discountAmount.disabled = false;
                    }
                });

                // Trigger change on page load
                concessionType.dispatchEvent(new Event('change'));
            }

            // Auto-hide any alerts after page load (for demo purposes)
            setTimeout(function () {
                hideAllAlerts();
            }, 8000);
        });

        // Server-side alert display function (call this from code-behind)
        function showServerAlert(type, message) {
            showAlert(type, message);
        }
    </script>
</asp:Content>