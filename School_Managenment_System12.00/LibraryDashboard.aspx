<%@ Page Title="Library Dashboard" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="LibraryDashboard.aspx.cs" Inherits="School_Managenment_System12._00.LibraryDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .dashboard-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
            color: white;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            transition: transform 0.3s ease;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card.warning {
            background: linear-gradient(135deg, #ecc94b 0%, #d69e2e 100%);
        }

        .stat-card.danger {
            background: linear-gradient(135deg, #e53e3e 0%, #c53030 100%);
        }

        .stat-card.success {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
        }

        .stat-number {
            font-size: 36px;
            font-weight: bold;
            margin: 10px 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .stat-label {
            font-size: 14px;
            opacity: 0.9;
            font-weight: 500;
        }

        .stat-icon {
            font-size: 24px;
            margin-bottom: 10px;
            opacity: 0.8;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .btn-action {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px 25px;
            background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(67, 97, 238, 0.3);
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(67, 97, 238, 0.4);
        }

        .btn-action.success {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            box-shadow: 0 4px 15px rgba(72, 187, 120, 0.3);
        }

        .btn-action.warning {
            background: linear-gradient(135deg, #ecc94b 0%, #d69e2e 100%);
            box-shadow: 0 4px 15px rgba(236, 201, 75, 0.3);
        }

        .recent-section {
            background: #2d3748;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid #4a5568;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .section-title {
            color: #e2e8f0;
            font-size: 20px;
            font-weight: 600;
        }

        .view-all {
            color: #4299e1;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .view-all:hover {
            color: #63b3ed;
        }

        .transaction-grid {
            display: grid;
            gap: 15px;
        }

        .transaction-card {
            background: #4a5568;
            border-radius: 10px;
            padding: 20px;
            border-left: 4px solid #4299e1;
            transition: all 0.3s ease;
        }

        .transaction-card.overdue {
            border-left-color: #e53e3e;
        }

        .transaction-card.returned {
            border-left-color: #48bb78;
        }

        .transaction-card:hover {
            transform: translateX(5px);
            background: #4a5568;
        }

        .transaction-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 10px;
        }

        .book-title {
            color: #e2e8f0;
            font-weight: 600;
            font-size: 16px;
            margin-bottom: 5px;
        }

        .student-name {
            color: #a0aec0;
            font-size: 14px;
        }

        .transaction-dates {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 10px;
            margin-top: 15px;
        }

        .date-item {
            text-align: center;
        }

        .date-label {
            color: #a0aec0;
            font-size: 12px;
            margin-bottom: 5px;
        }

        .date-value {
            color: #e2e8f0;
            font-size: 14px;
            font-weight: 500;
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .status-issued { background: #ecc94b; color: #744210; }
        .status-overdue { background: #fc8181; color: #742a2a; }
        .status-returned { background: #68d391; color: #22543d; }

        .fine-amount {
            color: #e53e3e;
            font-weight: bold;
            font-size: 14px;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #a0aec0;
            font-style: italic;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .quick-action-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px;
            background: #4a5568;
            color: #e2e8f0;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            border: 1px solid #718096;
        }

        .quick-action-btn:hover {
            background: #4361ee;
            color: white;
            border-color: #4361ee;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
 

    <!-- Statistics Cards -->
    <div class="dashboard-stats">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-book"></i>
            </div>
            <div class="stat-number">
                <asp:Label ID="lblTotalBooks" runat="server" Text="0"></asp:Label>
            </div>
            <div class="stat-label">Total Books</div>
        </div>

        <div class="stat-card success">
            <div class="stat-icon">
                <i class="fas fa-book-open"></i>
            </div>
            <div class="stat-number">
                <asp:Label ID="lblAvailableBooks" runat="server" Text="0"></asp:Label>
            </div>
            <div class="stat-label">Available Books</div>
        </div>

        <div class="stat-card warning">
            <div class="stat-icon">
                <i class="fas fa-handshake"></i>
            </div>
            <div class="stat-number">
                <asp:Label ID="lblIssuedBooks" runat="server" Text="0"></asp:Label>
            </div>
            <div class="stat-label">Books Issued</div>
        </div>

        <div class="stat-card danger">
            <div class="stat-icon">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-number">
                <asp:Label ID="lblOverdueBooks" runat="server" Text="0"></asp:Label>
            </div>
            <div class="stat-label">Overdue Books</div>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="action-buttons">
    <asp:Button ID="btnAddBook" runat="server" Text="Add New Book" 
        CssClass="btn-action" OnClick="BtnAddBook_Click" />
    <asp:Button ID="btnBookTransaction" PostBackUrl="~/BookTransactions.aspx" runat="server" Text="Book Transaction" 
        CssClass="btn-action success" />
    <asp:Button ID="btnManageBooks" runat="server" Text="Manage Books" 
        CssClass="btn-action warning" PostBackUrl="~/Books.aspx" />
    <asp:Button ID="btnLibrarySettings" runat="server" Text="Library Settings" 
        CssClass="btn-action warning" PostBackUrl="~/LibrarySettings.aspx" />
</div>

    <!-- Recent Transactions -->
    <div class="recent-section">
        <div class="section-header">
            <div class="section-title">Recent Book Transactions</div>
            <asp:LinkButton ID="lnkViewAllTransactions" runat="server" CssClass="view-all" OnClick="LnkViewAllTransactions_Click">
                View All <i class="fas fa-arrow-right"></i>
            </asp:LinkButton>
        </div>

        <div class="transaction-grid">
            <asp:Repeater ID="rptRecentTransactions" runat="server">
                <ItemTemplate>
                    <div class="transaction-card <%# Eval("Status").ToString().ToLower() %>">
                        <div class="transaction-header">
                            <div style="flex: 1;">
                                <div class="book-title"><%# Eval("BookTitle") %></div>
                                <div class="student-name">Student: <%# Eval("StudentName") %></div>
                            </div>
                            <div>
                                <span class="status-badge status-<%# Eval("Status").ToString().ToLower() %>">
                                    <%# Eval("Status") %>
                                </span>
                                <asp:Label ID="lblFine" runat="server" CssClass="fine-amount" 
                                    Visible='<%# Eval("FineAmount").ToString() != "0.00" %>'
                                    Text='<%# "Fine: $" + Eval("FineAmount", "{0:0.00}") %>'>
                                </asp:Label>
                            </div>
                        </div>
                        
                        <div class="transaction-dates">
                            <div class="date-item">
                                <div class="date-label">Issued Date</div>
                                <div class="date-value"><%# Eval("IssueDate", "{0:MMM dd, yyyy}") %></div>
                            </div>
                            <div class="date-item">
                                <div class="date-label">Due Date</div>
                                <div class="date-value"><%# Eval("DueDate", "{0:MMM dd, yyyy}") %></div>
                            </div>
                            <div class="date-item">
                                <div class="date-label">
                                    <%# Eval("Status").ToString() == "Returned" ? "Returned Date" : "Days Remaining" %>
                                </div>
                                <div class="date-value">
                                    <%# Eval("Status").ToString() == "Returned" ? 
                                         Eval("ReturnDate", "{0:MMM dd, yyyy}") :
                                         GetDaysRemaining(Eval("DueDate")) %>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Label ID="lblNoTransactions" runat="server" Text="No recent transactions found." 
                CssClass="no-data" Visible="false"></asp:Label>
        </div>
    </div>

    <!-- Overdue Books Alert -->
    <asp:Panel ID="pnlOverdueAlert" runat="server" Visible="false" CssClass="recent-section" style="border-left: 4px solid #e53e3e;">
        <div class="section-header">
            <div class="section-title" style="color: #e53e3e;">
                <i class="fas fa-exclamation-triangle"></i>
                Overdue Books Alert
            </div>
        </div>
        <asp:Repeater ID="rptOverdueBooks" runat="server">
            <ItemTemplate>
                <div class="transaction-card overdue">
                    <div class="transaction-header">
                        <div style="flex: 1;">
                            <div class="book-title"><%# Eval("BookTitle") %></div>
                            <div class="student-name">Student: <%# Eval("StudentName") %> | Due: <%# Eval("DueDate", "{0:MMM dd, yyyy}") %></div>
                        </div>
                        <div class="fine-amount">
                            Fine: $<%# Eval("CalculatedFine", "{0:0.00}") %></div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>
</asp:Content>