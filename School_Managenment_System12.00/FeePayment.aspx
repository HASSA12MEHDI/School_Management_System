<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FeePayment.aspx.cs" 
    Inherits="School_Managenment_System12._00.FeePayment" MasterPageFile="~/Site2.master" 
    Title="Fee Payment Management" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        :root {
            --bg-dark: #0a1a0a;
            --bg-darker: #051405;
            --bg-card: #1a2a1a;
            --bg-input: #2a3a2a;
            --primary: #28a745;
            --primary-hover: #218838;
            --secondary: #6c757d;
            --accent-green: #00ff88;
            --accent-lime: #adff2f;
            --text-light: #ffffff;
            --text-muted: #a8b2a8;
            --border-color: #2a3a2a;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
        }
        
        .fee-payment-container {
            background: linear-gradient(135deg, var(--bg-dark) 0%, var(--bg-darker) 100%);
            min-height: calc(100vh - 120px);
            color: var(--text-light);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: var(--bg-card);
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            padding: 30px;
            border: 1px solid var(--border-color);
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid var(--primary);
            padding-bottom: 20px;
        }
        
        .header h1 {
            color: var(--accent-green);
            margin: 0;
            font-size: 2.5rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: var(--accent-lime);
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .form-control {
            width: 100%;
            padding: 14px;
            background-color: var(--bg-input);
            border: 2px solid var(--border-color);
            border-radius: 8px;
            color: var(--text-light);
            font-size: 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: var(--accent-green);
            outline: none;
            box-shadow: 0 0 0 3px rgba(0, 255, 136, 0.25);
            transform: translateY(-2px);
        }
        
        .row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -12px;
        }
        
        .col-md-6 {
            flex: 0 0 50%;
            padding: 0 12px;
            box-sizing: border-box;
        }
        
        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-right: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            position: relative;
            overflow: hidden;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--accent-green));
            color: #000;
            font-weight: 700;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, var(--accent-green), var(--primary));
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 255, 136, 0.4);
            color: #000;
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, var(--secondary), #5a6268);
            color: white;
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #5a6268, var(--secondary));
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(108, 117, 125, 0.4);
            color: white;
        }
        
        .grid-container {
            margin-top: 40px;
            background: var(--bg-card);
            border-radius: 12px;
            padding: 25px;
            border: 1px solid var(--border-color);
        }
        
        .grid-header {
            color: var(--accent-green);
            margin-bottom: 25px;
            font-size: 1.5rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .grid-header i {
            font-size: 1.3rem;
        }
        
        .grid-view {
            width: 100%;
            background: var(--bg-input);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        
        .grid-view th {
            background: linear-gradient(135deg, #2a3a2a, #1a2a1a);
            color: var(--accent-lime);
            padding: 16px 12px;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid var(--border-color);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.85rem;
        }
        
        .grid-view td {
            padding: 14px 12px;
            border-bottom: 1px solid var(--border-color);
            color: var(--text-light);
            font-size: 0.9rem;
        }
        
        .grid-view tr:hover {
            background: linear-gradient(135deg, rgba(0, 255, 136, 0.1), rgba(40, 167, 69, 0.05));
        }
        
        .alert {
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-weight: 500;
            border: 1px solid transparent;
            position: relative;
            overflow: hidden;
        }
        
        .alert-success {
            background: linear-gradient(135deg, rgba(40, 167, 69, 0.2), rgba(0, 255, 136, 0.1));
            color: var(--accent-green);
            border-color: var(--accent-green);
        }
        
        .alert-danger {
            background: linear-gradient(135deg, rgba(220, 53, 69, 0.2), rgba(255, 0, 0, 0.1));
            color: #ff6b6b;
            border-color: var(--danger-color);
        }
        
        .required::after {
            content: " *";
            color: var(--danger-color);
        }
        
        /* Form Icons */
        .form-icon {
            color: var(--accent-green);
            margin-right: 8px;
        }
        
        /* Section Styling */
        .form-section {
            background: linear-gradient(135deg, rgba(0, 255, 136, 0.05), transparent);
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 25px;
        }
        
        .section-title {
            color: var(--accent-green);
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Button Container */
        .button-container {
            text-align: center;
            margin-top: 30px;
            padding: 25px;
            background: linear-gradient(135deg, rgba(0, 255, 136, 0.05), transparent);
            border: 1px solid var(--border-color);
            border-radius: 10px;
        }
        
        /* Grid Pager */
        .grid-pager {
            background: var(--bg-input);
            padding: 15px;
            text-align: center;
            border-top: 1px solid var(--border-color);
        }
        
        .grid-pager a {
            color: var(--accent-green) !important;
            padding: 8px 16px;
            margin: 0 4px;
            border: 1px solid var(--border-color);
            border-radius: 5px;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .grid-pager a:hover {
            background: var(--accent-green);
            color: #000 !important;
        }
        
        .grid-pager span {
            background: var(--accent-green) !important;
            color: #000 !important;
            padding: 8px 16px;
            margin: 0 4px;
            border: 1px solid var(--accent-green);
            border-radius: 5px;
            font-weight: 600;
        }
        
        @media (max-width: 768px) {
            .col-md-6 {
                flex: 0 0 100%;
            }
            
            .container {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .btn {
                width: 100%;
                margin-bottom: 10px;
                margin-right: 0;
            }
            
            .button-container {
                padding: 20px;
            }
        }
        
        @media (max-width: 480px) {
            .container {
                padding: 15px;
            }
            
            .header h1 {
                font-size: 1.7rem;
            }
            
            .form-section {
                padding: 20px;
            }
            
            .grid-container {
                padding: 20px;
            }
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

        .form-section, .grid-container {
            animation: fadeInUp 0.5s ease-out;
        }
    </style>

    <div class="fee-payment-container">
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-credit-card form-icon"></i>Fee Payment Management System</h1>
            </div>
            
            <!-- Success/Error Messages -->
            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert">
                <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
            </asp:Panel>
            
            <!-- Payment Form Section -->
            <div class="form-section">
                <div class="section-title">
                    <i class="fas fa-money-bill-wave"></i>Payment Information
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required"><i class="fas fa-user-graduate form-icon"></i>Student</label>
                            <asp:DropDownList ID="ddlStudent" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select Student</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required"><i class="fas fa-file-invoice-dollar form-icon"></i>Fee Type</label>
                            <asp:DropDownList ID="ddlFee" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select Fee Type</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required"><i class="fas fa-rupee-sign form-icon"></i>Amount Paid</label>
                            <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" 
                                TextMode="Number" step="0.01" min="0" placeholder="0.00"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required"><i class="fas fa-calendar-alt form-icon"></i>Payment Date</label>
                            <asp:TextBox ID="txtPaymentDate" runat="server" CssClass="form-control" 
                                TextMode="Date"></asp:TextBox>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required"><i class="fas fa-credit-card form-icon"></i>Payment Mode</label>
                            <asp:DropDownList ID="ddlPaymentMode" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select Payment Mode</asp:ListItem>
                                <asp:ListItem Value="Cash">Cash</asp:ListItem>
                                <asp:ListItem Value="Card">Card</asp:ListItem>
                                <asp:ListItem Value="Online">Online</asp:ListItem>
                                <asp:ListItem Value="Cheque">Cheque</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required"><i class="fas fa-receipt form-icon"></i>Transaction ID</label>
                            <asp:TextBox ID="txtTransactionId" runat="server" CssClass="form-control" 
                                MaxLength="100" placeholder="Enter transaction ID"></asp:TextBox>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required"><i class="fas fa-user-check form-icon"></i>Received By</label>
                            <asp:DropDownList ID="ddlReceivedBy" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select User</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-comment form-icon"></i>Remarks</label>
                            <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control" 
                                TextMode="MultiLine" Rows="3" MaxLength="255" placeholder="Additional remarks..."></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Action Buttons -->
            <div class="button-container">
                <asp:Button ID="btnSubmit" runat="server" Text="Submit Payment" 
                    CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear Form" 
                    CssClass="btn btn-secondary" OnClick="btnClear_Click" />
            </div>
            
            <!-- Payment History Grid -->
            <div class="grid-container">
                <div class="grid-header">
                    <i class="fas fa-history"></i>Payment History
                </div>
                <asp:GridView ID="gvPaymentHistory" runat="server" CssClass="grid-view" 
                    AutoGenerateColumns="False" DataKeyNames="PaymentId"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="gvPaymentHistory_PageIndexChanging"
                    EmptyDataText="No payment records found.">
                    <Columns>
                        <asp:BoundField DataField="PaymentId" HeaderText="ID" SortExpression="PaymentId" />
                        <asp:BoundField DataField="StudentName" HeaderText="Student" SortExpression="StudentName" />
                        <asp:BoundField DataField="FeeType" HeaderText="Fee Type" SortExpression="FeeType" />
                        <asp:BoundField DataField="AmountPaid" HeaderText="Amount" SortExpression="AmountPaid" 
                            DataFormatString="₹{0:N2}" />
                        <asp:BoundField DataField="PaymentDate" HeaderText="Date" SortExpression="PaymentDate" 
                            DataFormatString="{0:dd-MMM-yyyy}" />
                        <asp:BoundField DataField="PaymentMode" HeaderText="Mode" SortExpression="PaymentMode" />
                        <asp:BoundField DataField="TransactionId" HeaderText="Transaction ID" SortExpression="TransactionId" />
                        <asp:BoundField DataField="ReceivedByName" HeaderText="Received By" SortExpression="ReceivedByName" />
                        <asp:BoundField DataField="Remarks" HeaderText="Remarks" SortExpression="Remarks" />
                    </Columns>
                    <PagerStyle CssClass="grid-pager" />
                </asp:GridView>
            </div>
        </div>
    </div>

    <script>
        // Add form interactions
        document.addEventListener('DOMContentLoaded', function () {
            // Set today's date as default for payment date
            const today = new Date().toISOString().split('T')[0];
            const paymentDateField = document.getElementById('<%= txtPaymentDate.ClientID %>');
            if (paymentDateField && !paymentDateField.value) {
                paymentDateField.value = today;
            }

            // Add focus effects to form controls
            const formControls = document.querySelectorAll('.form-control');
            formControls.forEach(control => {
                control.addEventListener('focus', function () {
                    this.parentElement.classList.add('focused');
                });

                control.addEventListener('blur', function () {
                    this.parentElement.classList.remove('focused');
                });
            });

            // Add animation to form sections
            const formSections = document.querySelectorAll('.form-section, .grid-container');
            formSections.forEach((section, index) => {
                section.style.animationDelay = `${index * 0.1}s`;
            });
        });
    </script>
</asp:Content>