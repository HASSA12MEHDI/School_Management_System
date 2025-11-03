<%@ Page Title="Book Transactions" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="BookTransactions.aspx.cs" Inherits="School_Managenment_System12._00.BookTransactions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .transactions-container {
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

            .stat-card.danger {
                background: linear-gradient(135deg, #b71c1c 0%, #7f0000 100%);
                border-color: #d32f2f;
            }

            .stat-card.info {
                background: linear-gradient(135deg, #01579b 0%, #00264d 100%);
                border-color: #0277bd;
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

        .btn-transaction {
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

            .btn-transaction:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(46, 125, 50, 0.4);
                background: linear-gradient(135deg, #388e3c 0%, #2e7d32 100%);
            }

            .btn-transaction.secondary {
                background: linear-gradient(135deg, #5d4037 0%, #4e342e 100%);
                box-shadow: 0 4px 15px rgba(93, 64, 55, 0.3);
            }

                .btn-transaction.secondary:hover {
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
            grid-template-columns: 1fr 1fr 1fr auto;
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

        .transactions-grid {
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

        .transaction-card {
            background: #4a5568;
            border-bottom: 1px solid #718096;
            padding: 20px;
            transition: all 0.3s ease;
        }

            .transaction-card:hover {
                background: #556270;
                transform: translateX(5px);
            }

            .transaction-card:last-child {
                border-bottom: none;
            }

        .transaction-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .book-title {
            color: #e2e8f0;
            font-weight: 600;
            font-size: 18px;
            margin-bottom: 5px;
        }

        .student-info {
            color: #a0aec0;
            font-size: 14px;
        }

        .transaction-details {
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

        .transaction-actions {
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

        .btn-return {
            background: #4caf50;
            color: white;
        }

            .btn-return:hover {
                background: #388e3c;
            }

        .btn-renew {
            background: #ff9800;
            color: white;
        }

            .btn-renew:hover {
                background: #f57c00;
            }

        .btn-view {
            background: #2196f3;
            color: white;
        }

            .btn-view:hover {
                background: #1976d2;
            }

        .status-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .status-issued {
            background: #ff9800;
            color: white;
        }

        .status-overdue {
            background: #f44336;
            color: white;
        }

        .status-returned {
            background: #4caf50;
            color: white;
        }

        .fine-amount {
            color: #f44336;
            font-weight: bold;
            font-size: 14px;
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

        /* Additional styles for better UX */
        .quick-result-item {
            background: #374151;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
            border-left: 4px solid #4caf50;
        }

            .quick-result-item:hover {
                background: #4a5568;
                transform: translateX(5px);
                border-left-color: #2e7d32;
            }

        /* Loading states */
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        /* Button states */
        .btn-action:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* Modal improvements */
        .modal-content {
            animation: modalFadeIn 0.3s ease;
        }

        @keyframes modalFadeIn {
            from {
                opacity: 0;
                transform: translate(-50%, -60%);
            }

            to {
                opacity: 1;
                transform: translate(-50%, -50%);
            }
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

        .student-details, .book-details {
            background: #374151;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .detail-row {
            display: flex;
            margin-bottom: 8px;
        }

        .detail-name {
            color: #a0aec0;
            font-weight: 500;
            min-width: 120px;
        }

        .detail-value {
            color: #e2e8f0;
        }

        /* Quick Return Modal Specific Styles */
        .quick-return-form {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .quick-return-input {
            flex: 1;
        }

        .search-results {
            max-height: 300px;
            overflow-y: auto;
            margin-top: 15px;
        }

        .quick-result-item {
            background: #374151;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

            .quick-result-item:hover {
                background: #4a5568;
                transform: translateX(5px);
            }

        /* Fine amount styling */
        .fine-input-group {
            position: relative;
        }

            .fine-input-group:before {
                content: "$";
                position: absolute;
                left: 10px;
                top: 50%;
                transform: translateY(-50%);
                color: #a0aec0;
                font-weight: bold;
            }

            .fine-input-group input {
                padding-left: 25px;
            }

        @media (max-width: 768px) {
            .search-row {
                grid-template-columns: 1fr;
            }

            .transaction-header {
                flex-direction: column;
                gap: 10px;
            }

            .transaction-actions {
                justify-content: flex-start;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .quick-return-form {
                flex-direction: column;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="transactions-container">
        <div class="alert-header">
            <h2 style="color: #e2e8f0; margin-bottom: 10px;">Book Transactions Management</h2>
            <p style="color: #a0aec0; margin: 0;">Manage book issuing, returns, and track transactions</p>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-exchange-alt"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblTotalTransactions" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Total Transactions</div>
            </div>

            <div class="stat-card info">
                <div class="stat-icon">
                    <i class="fas fa-share-square"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblIssuedBooks" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Books Issued</div>
            </div>

            <div class="stat-card warning">
                <div class="stat-icon">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblOverdueBooks" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Overdue Books</div>
            </div>

            <div class="stat-card danger">
                <div class="stat-icon">
                    <i class="fas fa-money-bill-wave"></i>
                </div>
                <div class="stat-number">
                    $<asp:Label ID="lblTotalFines" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Total Fines</div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <asp:Button ID="btnIssueBook" runat="server" Text="+ Issue New Book"
                CssClass="btn-transaction" OnClientClick="openIssueModal(); return false;" />
            <asp:Button ID="btnQuickReturn" runat="server" Text="Quick Return"
                CssClass="btn-transaction secondary" OnClientClick="openQuickReturnModal(); return false;" />
            <asp:Button ID="btnGenerateReport" runat="server" Text="Generate Report"
                CssClass="btn-transaction secondary" OnClick="btnGenerateReport_Click" />
        </div>

        <!-- Search and Filter -->
        <div class="search-filter">
            <div class="search-row">
                <div class="form-group">
                    <label class="form-label">Search</label>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                        placeholder="Search by book, student..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label class="form-label">Status</label>
                    <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                        <asp:ListItem Value="">All Status</asp:ListItem>
                        <asp:ListItem Value="Issued">Issued</asp:ListItem>
                        <asp:ListItem Value="Overdue">Overdue</asp:ListItem>
                        <asp:ListItem Value="Returned">Returned</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label class="form-label">Date Range</label>
                    <asp:DropDownList ID="ddlDateRange" runat="server" CssClass="form-control"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlDateRange_SelectedIndexChanged">
                        <asp:ListItem Value="">All Time</asp:ListItem>
                        <asp:ListItem Value="today">Today</asp:ListItem>
                        <asp:ListItem Value="week">This Week</asp:ListItem>
                        <asp:ListItem Value="month">This Month</asp:ListItem>
                        <asp:ListItem Value="overdue">Overdue Only</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <asp:Button ID="btnClearFilters" runat="server" Text="Clear Filters"
                        CssClass="btn-transaction secondary" OnClick="btnClearFilters_Click" />
                </div>
            </div>
        </div>

        <!-- Transactions Grid -->
        <div class="transactions-grid">
            <div class="grid-header">
                Book Transactions
            </div>

            <asp:Repeater ID="rptTransactions" runat="server" OnItemCommand="rptTransactions_ItemCommand">
                <ItemTemplate>
                    <div class="transaction-card">
                        <div class="transaction-header">
                            <div style="flex: 1;">
                                <div class="book-title"><%# Eval("BookTitle") %></div>
                                <div class="student-info">
                                    Student: <%# Eval("StudentName") %> 
                                    | Class: <%# Eval("ClassName") %>
                                    | Roll #: <%# Eval("RollNumber") %>
                                </div>
                            </div>
                            <div style="text-align: right;">
                                <span class='status-badge status-<%# Eval("Status").ToString().ToLower() %>'>
                                    <%# Eval("Status") %>
                                </span>
                                <asp:Label ID="lblFine" runat="server" CssClass="fine-amount"
                                    Visible='<%# Eval("FineAmount").ToString() != "0.00" %>'
                                    Text='<%# "Fine: $" + Eval("FineAmount", "{0:0.00}") %>'>
                                </asp:Label>
                            </div>
                        </div>

                        <div class="transaction-details">
                            <div class="detail-item">
                                <span class="detail-label">Issue Date</span>
                                <span class="detail-value"><%# Eval("IssueDate", "{0:MMM dd, yyyy}") %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Due Date</span>
                                <span class="detail-value"><%# Eval("DueDate", "{0:MMM dd, yyyy}") %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">
                                    <%# Eval("Status").ToString() == "Returned" ? "Return Date" : "Days Remaining" %>
                                </span>
                                <span class="detail-value">
                                    <%# Eval("Status").ToString() == "Returned" ? 
                                         Eval("ReturnDate", "{0:MMM dd, yyyy}") :
                                         GetDaysRemaining(Eval("DueDate")) %>
                                </span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Issued By</span>
                                <span class="detail-value"><%# Eval("IssuedByName") %></span>
                            </div>
                        </div>

                        <div class="transaction-actions">
                            <asp:LinkButton ID="btnView" runat="server" Text="View Details"
                                CssClass="btn-action btn-view"
                                CommandName="View"
                                CommandArgument='<%# Eval("TransactionId") %>' />

                            <asp:LinkButton ID="btnRenew" runat="server" Text="Renew"
                                CssClass="btn-action btn-renew"
                                CommandName="Renew"
                                CommandArgument='<%# Eval("TransactionId") %>'
                                Visible='<%# Eval("Status").ToString() == "Issued" %>'
                                OnClientClick="return confirm('Are you sure you want to renew this book?');" />

                            <asp:LinkButton ID="btnReturn" runat="server" Text="Return Book"
                                CssClass="btn-action btn-return"
                                CommandName="Return"
                                CommandArgument='<%# Eval("TransactionId") %>'
                                Visible='<%# Eval("Status").ToString() != "Returned" %>'
                                OnClientClick='<%# "openReturnModal(\"" + Eval("TransactionId") + "\", \"" + Eval("BookTitle") + "\", \"" + Eval("StudentName") + "\", \"" + Eval("IssueDate", "{0:yyyy-MM-dd}") + "\", \"" + Eval("DueDate", "{0:yyyy-MM-dd}") + "\"); return false;" %>' />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Label ID="lblNoTransactions" runat="server" Text="No transactions found matching your criteria."
                CssClass="no-data" Visible="false"></asp:Label>
        </div>

        <!-- Pagination -->
        <div class="pagination">
            <asp:Button ID="btnPrev" runat="server" Text="← Previous"
                CssClass="btn-transaction secondary" OnClick="btnPrev_Click" Enabled="false" />
            <span class="page-info">Page
                <asp:Label ID="lblCurrentPage" runat="server" Text="1"></asp:Label>
                of 
                <asp:Label ID="lblTotalPages" runat="server" Text="1"></asp:Label>
            </span>
            <asp:Button ID="btnNext" runat="server" Text="Next →"
                CssClass="btn-transaction secondary" OnClick="btnNext_Click" Enabled="false" />
        </div>
    </div>

    <!-- Issue Book Modal -->
    <div id="issueModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">Issue New Book</div>
                <button type="button" class="close-modal" onclick="closeIssueModal()">×</button>
            </div>
            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group form-full">
                        <label class="form-label">Select Student *</label>
                        <asp:DropDownList ID="ddlStudents" runat="server" CssClass="form-control"
                            AutoPostBack="false" onchange="loadStudentDetails(this.value)">
                            <asp:ListItem Value="">Select Student</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Student Details -->
                    <div id="pnlStudentDetails" class="form-full student-details" style="display: none;">
                        <div class="detail-row">
                            <span class="detail-name">Class:</span>
                            <span class="detail-value" id="lblStudentClassText"></span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-name">Phone:</span>
                            <span class="detail-value" id="lblStudentPhoneText"></span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-name">Issued Books:</span>
                            <span class="detail-value" id="lblIssuedBooksCountText">0</span>
                        </div>
                    </div>

                    <div class="form-group form-full">
                        <label class="form-label">Select Book *</label>
                        <asp:DropDownList ID="ddlBooks" runat="server" CssClass="form-control"
                            AutoPostBack="false" onchange="loadBookDetails(this.value)">
                            <asp:ListItem Value="">Select Book</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Book Details -->
                    <div id="pnlBookDetails" class="form-full book-details" style="display: none;">
                        <div class="detail-row">
                            <span class="detail-name">Author:</span>
                            <span class="detail-value" id="lblBookAuthorText"></span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-name">Available Copies:</span>
                            <span class="detail-value" id="lblAvailableCopiesText"></span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-name">Shelf:</span>
                            <span class="detail-value" id="lblShelfNumberText"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Issue Date *</label>
                        <asp:TextBox ID="txtIssueDate" runat="server" CssClass="form-control"
                            TextMode="Date"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Due Date *</label>
                        <asp:TextBox ID="txtDueDate" runat="server" CssClass="form-control"
                            TextMode="Date"></asp:TextBox>
                    </div>
                </div>

                <div style="display: flex; gap: 10px; margin-top: 25px; justify-content: flex-end;">
                    <asp:Button ID="btnSaveIssue" runat="server" Text="Issue Book"
                        CssClass="btn-transaction" OnClick="btnSaveIssue_Click" OnClientClick="return validateIssueForm();" />
                    <button type="button" class="btn-transaction secondary" onclick="closeIssueModal()">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Return Modal -->
    <div id="quickReturnModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">Quick Return</div>
                <button type="button" class="close-modal" onclick="closeQuickReturnModal()">×</button>
            </div>
            <div class="modal-body">
                <div class="quick-return-form">
                    <div class="form-group quick-return-input">
                        <label class="form-label">Search by Book Title, Student Name, or Roll Number</label>
                        <asp:TextBox ID="txtQuickSearch" runat="server" CssClass="form-control"
                            placeholder="Enter book title, student name, or roll number..."
                            AutoPostBack="true" OnTextChanged="txtQuickSearch_TextChanged"></asp:TextBox>
                    </div>
                </div>

                <asp:Panel ID="pnlQuickResults" runat="server" Visible="false" CssClass="search-results">
                    <asp:Repeater ID="rptQuickResults" runat="server" OnItemCommand="rptQuickResults_ItemCommand">
                        <ItemTemplate>
                            <div class="quick-result-item">
                                <div class="book-title"><%# Eval("BookTitle") %></div>
                                <div class="student-info">
                                    Student: <%# Eval("StudentName") %> | 
                Roll #: <%# Eval("RollNumber") %> | 
                Due: <%# Eval("DueDate", "{0:MMM dd, yyyy}") %>
                                </div>
                                <div class="transaction-actions" style="margin-top: 10px;">
                                    <asp:LinkButton ID="btnQuickReturn" runat="server" Text="Return This Book"
                                        CssClass="btn-action btn-return"
                                        CommandName="QuickReturn"
                                        CommandArgument='<%# Eval("TransactionId") %>'
                                        OnClientClick='<%# "return confirmQuickReturn(\"" + Eval("BookTitle") + "\", \"" + Eval("StudentName") + "\");" %>' />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>

                <asp:Label ID="lblNoQuickResults" runat="server" Text="No books found for return."
                    CssClass="no-data" Visible="false" Style="text-align: center; display: block; padding: 20px;"></asp:Label>
            </div>
        </div>
    </div>

    <!-- Return Book Modal -->
    <div id="returnModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">Return Book</div>
                <button type="button" class="close-modal" onclick="closeReturnModal()">×</button>
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfReturnTransactionId" runat="server" />
                <asp:HiddenField ID="hfReturnDueDateISO" runat="server" />

                <div class="student-details">
                    <div class="detail-row">
                        <span class="detail-name">Book:</span>
                        <span class="detail-value">
                            <asp:Label ID="lblReturnBookTitle" runat="server"></asp:Label></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-name">Student:</span>
                        <span class="detail-value">
                            <asp:Label ID="lblReturnStudentName" runat="server"></asp:Label></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-name">Issue Date:</span>
                        <span class="detail-value">
                            <asp:Label ID="lblReturnIssueDate" runat="server"></asp:Label></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-name">Due Date:</span>
                        <span class="detail-value">
                            <asp:Label ID="lblReturnDueDate" runat="server"></asp:Label></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-name">Days Overdue:</span>
                        <span class="detail-value">
                            <asp:Label ID="lblDaysOverdue" runat="server" Text="0"></asp:Label></span>
                    </div>
                </div>

                <div class="form-grid" style="margin-top: 20px;">
                    <div class="form-group">
                        <label class="form-label">Return Date *</label>
                        <asp:TextBox ID="txtReturnDate" runat="server" CssClass="form-control"
                            TextMode="Date" onchange="calculateFine()"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Fine Amount</label>
                        <div class="fine-input-group">
                            <asp:TextBox ID="txtFineAmount" runat="server" CssClass="form-control"
                                TextMode="Number" step="0.01"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <div style="display: flex; gap: 10px; margin-top: 25px; justify-content: flex-end;">
                    <asp:Button ID="btnSaveReturn" runat="server" Text="Confirm Return"
                        CssClass="btn-transaction" OnClick="btnSaveReturn_Click" OnClientClick="return validateReturnForm();" />
                    <button type="button" class="btn-transaction secondary" onclick="closeReturnModal()">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // Modal Functions
        function openIssueModal() {
            console.log('Opening issue modal');
            document.getElementById('issueModal').style.display = 'block';
            setDefaultDates();

            // Reset form
            document.getElementById('<%= ddlStudents.ClientID %>').selectedIndex = 0;
            document.getElementById('<%= ddlBooks.ClientID %>').selectedIndex = 0;
            document.getElementById('pnlStudentDetails').style.display = 'none';
            document.getElementById('pnlBookDetails').style.display = 'none';
        }

        function closeIssueModal() {
            console.log('Closing issue modal');
            document.getElementById('issueModal').style.display = 'none';
            // Reset form
            document.getElementById('<%= ddlStudents.ClientID %>').selectedIndex = 0;
            document.getElementById('<%= ddlBooks.ClientID %>').selectedIndex = 0;
        }

        function openQuickReturnModal() {
            console.log('Opening quick return modal');
            document.getElementById('quickReturnModal').style.display = 'block';
            // Clear previous results
            var pnlQuickResults = document.getElementById('<%= pnlQuickResults.ClientID %>');
            var lblNoQuickResults = document.getElementById('<%= lblNoQuickResults.ClientID %>');
            var txtQuickSearch = document.getElementById('<%= txtQuickSearch.ClientID %>');

            if (pnlQuickResults) pnlQuickResults.style.display = 'none';
            if (lblNoQuickResults) lblNoQuickResults.style.display = 'none';
            if (txtQuickSearch) {
                txtQuickSearch.value = '';
                txtQuickSearch.focus();
            }
        }

        function closeQuickReturnModal() {
            console.log('Closing quick return modal');
            document.getElementById('quickReturnModal').style.display = 'none';
            // Clear search and results
            var txtQuickSearch = document.getElementById('<%= txtQuickSearch.ClientID %>');
            var pnlQuickResults = document.getElementById('<%= pnlQuickResults.ClientID %>');
            var lblNoQuickResults = document.getElementById('<%= lblNoQuickResults.ClientID %>');

            if (txtQuickSearch) txtQuickSearch.value = '';
            if (pnlQuickResults) pnlQuickResults.style.display = 'none';
            if (lblNoQuickResults) lblNoQuickResults.style.display = 'none';
        }

        function openReturnModal(transactionId, bookTitle, studentName, issueDate, dueDate) {
            console.log('Opening return modal for transaction:', transactionId);
            
            // Set the transaction ID
            document.getElementById('<%= hfReturnTransactionId.ClientID %>').value = transactionId;
            
            // Update display fields
            document.getElementById('<%= lblReturnBookTitle.ClientID %>').textContent = bookTitle;
            document.getElementById('<%= lblReturnStudentName.ClientID %>').textContent = studentName;
            document.getElementById('<%= lblReturnIssueDate.ClientID %>').textContent = formatDisplayDate(issueDate);
            document.getElementById('<%= lblReturnDueDate.ClientID %>').textContent = formatDisplayDate(dueDate);
            
            // Store due date for calculations
            document.getElementById('<%= hfReturnDueDateISO.ClientID %>').value = dueDate;
            
            // Show modal
            document.getElementById('returnModal').style.display = 'block';
            
            // Set return date and calculate fine
            setReturnDate();
        }

        function closeReturnModal() {
            console.log('Closing return modal');
            document.getElementById('returnModal').style.display = 'none';
            // Reset form
            document.getElementById('<%= txtFineAmount.ClientID %>').value = '0.00';
        }

        // Close modal when clicking outside
        window.onclick = function (event) {
            var issueModal = document.getElementById('issueModal');
            var returnModal = document.getElementById('returnModal');
            var quickReturnModal = document.getElementById('quickReturnModal');

            if (event.target == issueModal) {
                closeIssueModal();
            }
            if (event.target == returnModal) {
                closeReturnModal();
            }
            if (event.target == quickReturnModal) {
                closeQuickReturnModal();
            }
        }

        // Form Validation Functions
        function validateIssueForm() {
            var student = document.getElementById('<%= ddlStudents.ClientID %>').value;
            var book = document.getElementById('<%= ddlBooks.ClientID %>').value;
            var issueDate = document.getElementById('<%= txtIssueDate.ClientID %>').value;
            var dueDate = document.getElementById('<%= txtDueDate.ClientID %>').value;

            if (!student) {
                alert('Please select a student.');
                return false;
            }
            if (!book) {
                alert('Please select a book.');
                return false;
            }
            if (!issueDate) {
                alert('Please select an issue date.');
                return false;
            }
            if (!dueDate) {
                alert('Please select a due date.');
                return false;
            }

            // Validate due date is after issue date
            var issue = new Date(issueDate);
            var due = new Date(dueDate);
            if (due <= issue) {
                alert('Due date must be after issue date.');
                return false;
            }

            return confirm('Are you sure you want to issue this book?');
        }

        function validateReturnForm() {
            var returnDate = document.getElementById('<%= txtReturnDate.ClientID %>').value;
            var fineAmount = document.getElementById('<%= txtFineAmount.ClientID %>').value;

            if (!returnDate) {
                alert('Please select a return date.');
                return false;
            }

            // Validate fine amount
            if (!fineAmount || isNaN(parseFloat(fineAmount)) || parseFloat(fineAmount) < 0) {
                alert('Please enter a valid fine amount.');
                document.getElementById('<%= txtFineAmount.ClientID %>').focus();
                return false;
            }

            return confirm('Are you sure you want to return this book?');
        }

        // Date Functions
        function setDefaultDates() {
            try {
                var today = new Date();
                var dueDate = new Date();
                dueDate.setDate(today.getDate() + 14); // 14 days from today
                
                var todayFormatted = today.toISOString().split('T')[0];
                var dueDateFormatted = dueDate.toISOString().split('T')[0];
                
                document.getElementById('<%= txtIssueDate.ClientID %>').value = todayFormatted;
                document.getElementById('<%= txtDueDate.ClientID %>').value = dueDateFormatted;
            } catch (e) {
                console.error('Error setting default dates:', e);
            }
        }

        function setReturnDate() {
            try {
                var today = new Date();
                var todayFormatted = today.toISOString().split('T')[0];
                var txtReturnDate = document.getElementById('<%= txtReturnDate.ClientID %>');
                if (txtReturnDate) {
                    txtReturnDate.value = todayFormatted;
                    // Trigger change event to calculate fine
                    var event = new Event('change');
                    txtReturnDate.dispatchEvent(event);
                }
            } catch (e) {
                console.error('Error setting return date:', e);
            }
        }

        // Fine Calculation - Fixed version
        function calculateFine() {
            try {
                var dueDateISO = document.getElementById('<%= hfReturnDueDateISO.ClientID %>').value;
                var returnDateValue = document.getElementById('<%= txtReturnDate.ClientID %>').value;

                console.log('Due Date ISO:', dueDateISO);
                console.log('Return Date:', returnDateValue);

                if (dueDateISO && returnDateValue) {
                    // Parse dates in local timezone to avoid timezone issues
                    var dueDate = parseDateLocal(dueDateISO);
                    var returnDate = parseDateLocal(returnDateValue);

                    console.log('Due Date parsed:', dueDate);
                    console.log('Return Date parsed:', returnDate);

                    // Calculate difference in days (only count overdue days)
                    var timeDiff = returnDate.getTime() - dueDate.getTime();
                    var daysOverdue = Math.ceil(timeDiff / (1000 * 3600 * 24));

                    console.log('Days Overdue:', daysOverdue);

                    // Only apply fine if actually overdue
                    if (daysOverdue > 0) {
                        var finePerDay = 5; // $5 per day
                        var fineAmount = daysOverdue * finePerDay;
                        console.log('Fine Amount:', fineAmount);
                        document.getElementById('<%= txtFineAmount.ClientID %>').value = fineAmount.toFixed(2);
                        
                        // Update days overdue display
                        document.getElementById('<%= lblDaysOverdue.ClientID %>').textContent = daysOverdue + ' days';
                    } else {
                        console.log('No fine - returned on time or early');
                        document.getElementById('<%= txtFineAmount.ClientID %>').value = '0.00';
                        document.getElementById('<%= lblDaysOverdue.ClientID %>').textContent = '0 days';
                    }
                } else {
                    console.log('Missing dates for fine calculation');
                    document.getElementById('<%= txtFineAmount.ClientID %>').value = '0.00';
                }
            } catch (e) {
                console.error('Error calculating fine:', e);
                document.getElementById('<%= txtFineAmount.ClientID %>').value = '0.00';
            }
        }

        // Helper function to parse dates in local timezone
        function parseDateLocal(dateString) {
            var parts = dateString.split('-');
            return new Date(parts[0], parts[1] - 1, parts[2]); // year, month (0-based), day
        }

        // Helper function to format dates for display
        function formatDisplayDate(dateString) {
            var date = parseDateLocal(dateString);
            return date.toLocaleDateString('en-US', { 
                year: 'numeric', 
                month: 'short', 
                day: 'numeric' 
            });
        }

        // Quick return confirmation
        function confirmQuickReturn(bookTitle, studentName) {
            return confirm('Are you sure you want to return "' + bookTitle + '" issued to ' + studentName + '?');
        }

        // Placeholder functions for student and book details loading
        function loadStudentDetails(studentId) {
            // This would typically make an AJAX call to get student details
            console.log('Loading details for student:', studentId);
            // For now, just show the panel
            if (studentId) {
                document.getElementById('pnlStudentDetails').style.display = 'block';
            } else {
                document.getElementById('pnlStudentDetails').style.display = 'none';
            }
        }

        function loadBookDetails(bookId) {
            // This would typically make an AJAX call to get book details
            console.log('Loading details for book:', bookId);
            // For now, just show the panel
            if (bookId) {
                document.getElementById('pnlBookDetails').style.display = 'block';
            } else {
                document.getElementById('pnlBookDetails').style.display = 'none';
            }
        }

        // Initialize when page loads
        document.addEventListener('DOMContentLoaded', function () {
            console.log('Book transactions page loaded successfully');

            // Add event listener for return date change
            var txtReturnDate = document.getElementById('<%= txtReturnDate.ClientID %>');
            if (txtReturnDate) {
                txtReturnDate.addEventListener('change', calculateFine);
            }

            // Add event listener for quick search enter key
            var txtQuickSearch = document.getElementById('<%= txtQuickSearch.ClientID %>');
            if (txtQuickSearch) {
                txtQuickSearch.addEventListener('keypress', function (e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        __doPostBack('<%= txtQuickSearch.UniqueID %>', '');
                    }
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
            } else {
                notification.style.background = '#f44336';
                notification.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + message;
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