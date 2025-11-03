<%@ Page Title="Transaction Manager" Language="C#" MasterPageFile="~/Site2.Master" AutoEventWireup="true" CodeBehind="View_AllTransaction.aspx.cs" Inherits="School_Managenment_System12._00.View_AllTransaction" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        :root {
            --primary: #4361ee;
            --secondary: #3f37c9;
            --success: #4cc9f0;
            --danger: #f72585;
            --warning: #f8961e;
            --info: #4895ef;
            --light: #f8f9fa;
            --dark: #212529;
            --border-radius: 12px;
            --box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            --transition: all 0.3s ease;
        }

        .dashboard-content {
            padding: 0;
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .welcome-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: var(--box-shadow);
            position: relative;
            overflow: hidden;
        }

        .welcome-banner::before {
            content: "";
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 70%);
            animation: pulse 4s ease-in-out infinite;
        }

        @keyframes pulse {
            0% { transform: scale(0.8); opacity: 0.5; }
            50% { transform: scale(1.1); opacity: 0.3; }
            100% { transform: scale(0.8); opacity: 0.5; }
        }

        .welcome-banner h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }

        .welcome-banner p {
            font-size: 1.1rem;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .section-title {
            margin: 30px 0 20px 0;
            position: relative;
        }

        .section-title h2 {
            color: var(--dark);
            font-size: 1.8rem;
            font-weight: 600;
            display: inline-block;
            position: relative;
            padding-bottom: 10px;
        }

        .section-title h2::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 3px;
        }

        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 25px;
            text-align: center;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
        }

        .stat-card.income::before { background: var(--success); }
        .stat-card.expense::before { background: var(--danger); }
        .stat-card.balance::before { background: var(--primary); }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            margin: 15px 0;
        }

        .stat-title {
            font-size: 0.9rem;
            color: #6c757d;
            font-weight: 500;
        }

        .stat-desc {
            font-size: 0.8rem;
            color: #adb5bd;
        }

        .card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 25px;
            margin-bottom: 25px;
            transition: var(--transition);
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
        }

        .card-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-title i {
            font-size: 1.6rem;
        }

        .filter-section {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #495057;
            font-size: 0.85rem;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e1e5ee;
            border-radius: 8px;
            font-size: 0.9rem;
            transition: var(--transition);
            background-color: #f8f9fa;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15);
            background-color: white;
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
        }

        .btn-outline {
            background-color: transparent;
            color: var(--primary);
            border: 1px solid var(--primary);
        }

        .btn-outline:hover {
            background-color: var(--primary);
            color: white;
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success), #3fb9c7);
            color: white;
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger), #e91e63);
            color: white;
        }

        .btn-sm {
            padding: 8px 15px;
            font-size: 0.8rem;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        .table-container {
            overflow-x: auto;
            border-radius: var(--border-radius);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .transaction-grid {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: var(--border-radius);
            overflow: hidden;
        }

        .transaction-grid thead {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
        }

        .transaction-grid th {
            padding: 12px 10px;
            text-align: left;
            font-weight: 600;
            font-size: 0.85rem;
            white-space: nowrap;
        }

        .transaction-grid tbody tr {
            border-bottom: 1px solid #eaeaea;
            transition: var(--transition);
        }

        .transaction-grid tbody tr:hover {
            background-color: #f8f9ff;
        }

        .transaction-grid td {
            padding: 10px;
            font-size: 0.85rem;
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .transaction-grid td.description-cell {
            max-width: 200px;
            position: relative;
        }

        .transaction-grid td.description-cell:hover {
            overflow: visible;
            white-space: normal;
            word-wrap: break-word;
            z-index: 10;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 4px;
            padding: 10px;
            position: absolute;
            left: 0;
            top: 0;
            min-width: 250px;
            max-width: 300px;
        }

        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .badge-expense {
            background-color: rgba(247, 37, 133, 0.15);
            color: var(--danger);
        }

        .badge-income {
            background-color: rgba(76, 201, 240, 0.15);
            color: var(--success);
        }

        .amount-income {
            color: #2ecc71;
            font-weight: 600;
        }

        .amount-expense {
            color: #e74c3c;
            font-weight: 600;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 25px;
            gap: 8px;
        }

        .page-item {
            display: inline-block;
        }

        .page-link {
            padding: 8px 15px;
            border: 1px solid #e1e5ee;
            background-color: white;
            color: var(--primary);
            border-radius: 6px;
            cursor: pointer;
            transition: var(--transition);
            font-size: 0.85rem;
        }

        .page-link:hover {
            background-color: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        .page-link.active {
            background-color: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        .message {
            padding: 10px;
            border-radius: 8px;
            margin-top: 15px;
            font-size: 0.85rem;
        }

        .error-message {
            background-color: #ffe6e6;
            color: #d63031;
            border: 1px solid #ff7675;
        }

        .success-message {
            background-color: #e6f7e6;
            color: #27ae60;
            border: 1px solid #2ecc71;
        }

        .no-records {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-size: 1rem;
        }

        .empty-data {
            text-align: center;
            padding: 20px;
            color: #6c757d;
            font-size: 0.9rem;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            animation: fadeIn 0.3s;
        }

        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 0;
            border-radius: var(--border-radius);
            width: 90%;
            max-width: 600px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            animation: slideIn 0.3s;
        }

        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .modal-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 20px;
            border-radius: var(--border-radius) var(--border-radius) 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h3 {
            margin: 0;
            font-size: 1.3rem;
        }

        .close {
            color: white;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            transition: var(--transition);
        }

        .close:hover {
            opacity: 0.7;
        }

        .modal-body {
            padding: 25px;
        }

        .modal-footer {
            padding: 20px;
            border-top: 1px solid #eaeaea;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: var(--transition);
            font-size: 0.8rem;
        }

        .edit-btn {
            background-color: var(--info);
            color: white;
        }

        .edit-btn:hover {
            background-color: #3a7bd5;
        }

        .delete-btn {
            background-color: var(--danger);
            color: white;
        }

        .delete-btn:hover {
            background-color: #c91e3a;
        }

        @media (max-width: 768px) {
            .filter-section {
                grid-template-columns: 1fr;
            }
            
            .welcome-banner h1 {
                font-size: 2rem;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
            
            .stats-cards {
                grid-template-columns: 1fr;
            }
            
            .modal-content {
                width: 95%;
                margin: 10% auto;
            }
            
            .transaction-grid td {
                font-size: 0.8rem;
                padding: 8px;
            }
            
            .transaction-grid th {
                font-size: 0.8rem;
                padding: 10px 8px;
            }
        }
    </style>

    <div class="dashboard-content">
        <!-- Welcome Banner -->
        <div class="welcome-banner">
            <h1><i class="fas fa-chart-line"></i> Transaction Manager</h1>
            <p>View, edit, and manage your expenses and income in one place</p>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-cards">
            <div class="stat-card income">
                <div class="stat-title">Total Income</div>
                <div class="stat-value amount-income">
                    <asp:Label ID="lblTotalIncome" runat="server" Text="$0.00"></asp:Label>
                </div>
                <div class="stat-desc">Selected period</div>
            </div>
            <div class="stat-card expense">
                <div class="stat-title">Total Expenses</div>
                <div class="stat-value amount-expense">
                    <asp:Label ID="lblTotalExpense" runat="server" Text="$0.00"></asp:Label>
                </div>
                <div class="stat-desc">Selected period</div>
            </div>
            <div class="stat-card balance">
                <div class="stat-title">Current Balance</div>
                <div class="stat-value">
                    <asp:Label ID="lblBalance" runat="server" Text="$0.00"></asp:Label>
                </div>
                <div class="stat-desc">Selected period</div>
            </div>
        </div>

        <!-- Filter Section -->
        <div class="section-title">
            <h2>Filter Transactions</h2>
        </div>
        <div class="card">
            <div class="card-title">
                <i class="fas fa-filter"></i> Filter Options
            </div>
            <div class="filter-section">
                <div class="form-group">
                    <label for="dateFrom">From Date</label>
                    <asp:TextBox ID="dateFrom" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="dateTo">To Date</label>
                    <asp:TextBox ID="dateTo" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="transactionType">Transaction Type</label>
                    <asp:DropDownList ID="transactionType" runat="server" CssClass="form-control">
                        <asp:ListItem Value="all" Text="All Transactions"></asp:ListItem>
                        <asp:ListItem Value="income" Text="Income Only"></asp:ListItem>
                        <asp:ListItem Value="expense" Text="Expense Only"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label for="category">Category</label>
                    <asp:DropDownList ID="category" runat="server" CssClass="form-control">
                        <asp:ListItem Value="all" Text="All Categories"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label for="paymentMode">Payment Mode</label>
                    <asp:DropDownList ID="paymentMode" runat="server" CssClass="form-control">
                        <asp:ListItem Value="all" Text="All Payment Modes"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label for="search">Search Description</label>
                    <asp:TextBox ID="search" runat="server" CssClass="form-control" placeholder="Enter keyword..."></asp:TextBox>
                </div>
            </div>
            <div class="action-buttons">
                <asp:Button ID="btnApplyFilters" runat="server" Text="Apply Filters" 
                    CssClass="btn btn-primary" OnClick="BtnApplyFilters_Click" />
                <asp:Button ID="btnResetFilters" runat="server" Text="Reset Filters" 
                    CssClass="btn btn-outline" OnClick="BtnResetFilters_Click" />
                <asp:Button ID="btnExport" runat="server" Text="Export to Excel" 
                    CssClass="btn btn-outline" OnClick="BtnExport_Click" />
            </div>
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
        </div>

        <!-- Transaction History -->
        <div class="section-title">
            <h2>Transaction History</h2>
        </div>
        <div class="card">
            <div class="card-title">
                <i class="fas fa-list-alt"></i> Transaction Records
            </div>
            
            <asp:Label ID="lblNoRecords" runat="server" Text="No transactions found matching your criteria." 
                CssClass="no-records" Visible="false"></asp:Label>
            
            <div class="table-container">
                <asp:GridView ID="gvTransactions" runat="server" AutoGenerateColumns="False" 
                    CssClass="transaction-grid" AllowPaging="True" PageSize="10" 
                    OnRowDataBound="GvTransactions_RowDataBound" 
                    OnPageIndexChanging="GvTransactions_PageIndexChanging"
                    OnRowCommand="GvTransactions_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <asp:Label ID="lblTransactionType" runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Category" HeaderText="Category" />
                        <asp:TemplateField HeaderText="Description">
                            <ItemTemplate>
                                <div class="description-cell">
                                    <asp:Label ID="lblDescription" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Amount">
                            <ItemTemplate>
                                <asp:Label ID="lblAmount" runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="PaymentMode" HeaderText="Payment Mode" />
                        <asp:BoundField DataField="Party" HeaderText="Party" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CssClass="action-btn edit-btn" 
                                    CommandName="EditTransaction" CommandArgument='<%# Eval("TransactionId") + "|" + Eval("OriginalTable") %>'>
                                    <i class="fas fa-edit"></i> Edit
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CssClass="action-btn delete-btn" 
                                    CommandName="DeleteTransaction" CommandArgument='<%# Eval("TransactionId") + "|" + Eval("OriginalTable") %>'>
                                    <i class="fas fa-trash"></i> Delete
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="pagination" />
                    <EmptyDataTemplate>
                        <div class="empty-data">No transactions found for the selected criteria.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>

    <!-- Edit Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-edit"></i> Edit Transaction</h3>
                <span class="close" onclick="closeEditModal()">&times;</span>
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfEditTransactionId" runat="server" />
                <asp:HiddenField ID="hfEditTable" runat="server" />
                
                <div class="filter-section">
                    <div class="form-group">
                        <label for="txtEditDate">Date</label>
                        <asp:TextBox ID="txtEditDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtEditType">Type</label>
                        <asp:TextBox ID="txtEditType" runat="server" CssClass="form-control" placeholder="Enter transaction type"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtEditAmount">Amount</label>
                        <asp:TextBox ID="txtEditAmount" runat="server" CssClass="form-control" placeholder="Enter amount"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtEditCategory">Category</label>
                        <asp:TextBox ID="txtEditCategory" runat="server" CssClass="form-control" placeholder="Enter category"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtEditDescription">Description</label>
                        <asp:TextBox ID="txtEditDescription" runat="server" CssClass="form-control" placeholder="Enter description"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtEditParty">Party</label>
                        <asp:TextBox ID="txtEditParty" runat="server" CssClass="form-control" placeholder="Enter party name"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="ddlEditPaymentMode">Payment Mode</label>
                        <asp:DropDownList ID="ddlEditPaymentMode" runat="server" CssClass="form-control">
                            <asp:ListItem Value="Cash" Text="Cash"></asp:ListItem>
                            <asp:ListItem Value="Card" Text="Card"></asp:ListItem>
                            <asp:ListItem Value="Cheque" Text="Cheque"></asp:ListItem>
                            <asp:ListItem Value="Online" Text="Online"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnUpdateTransaction" runat="server" Text="Update Transaction" 
                    CssClass="btn btn-success" OnClick="BtnUpdateTransaction_Click" />
                <button type="button" class="btn btn-outline" onclick="closeEditModal()">Cancel</button>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-trash"></i> Confirm Delete</h3>
                <span class="close" onclick="closeDeleteModal()">&times;</span>
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfDeleteTransactionId" runat="server" />
                <asp:HiddenField ID="hfDeleteTable" runat="server" />
                
                <p>Are you sure you want to delete this transaction? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnConfirmDelete" runat="server" Text="Delete" 
                    CssClass="btn btn-danger" OnClick="BtnConfirmDelete_Click" />
                <button type="button" class="btn btn-outline" onclick="closeDeleteModal()">Cancel</button>
            </div>
        </div>
    </div>

    <script>
        function showEditModal() {
            document.getElementById('editModal').style.display = 'block';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        function showDeleteModal() {
            document.getElementById('deleteModal').style.display = 'block';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function (event) {
            const editModal = document.getElementById('editModal');
            const deleteModal = document.getElementById('deleteModal');

            if (event.target == editModal) {
                editModal.style.display = 'none';
            }
            if (event.target == deleteModal) {
                deleteModal.style.display = 'none';
            }
        }

        // Add animation to elements when they come into view
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        // Observe all stat cards
        document.querySelectorAll('.stat-card').forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            observer.observe(card);
        });

        // Observe all cards
        document.querySelectorAll('.card').forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            observer.observe(card);
        });
    </script>
</asp:Content>