<%@ Page Title="Books Management" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Books.aspx.cs" Inherits="School_Managenment_System12._00.Books" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .books-container {
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

        .btn-book {
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

        .btn-book:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(46, 125, 50, 0.4);
            background: linear-gradient(135deg, #388e3c 0%, #2e7d32 100%);
        }

        .btn-book.secondary {
            background: linear-gradient(135deg, #5d4037 0%, #4e342e 100%);
            box-shadow: 0 4px 15px rgba(93, 64, 55, 0.3);
        }

        .btn-book.secondary:hover {
            background: linear-gradient(135deg, #6d4c41 0%, #5d4037 100%);
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
            grid-template-columns: 2fr 1fr 1fr auto;
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

        .books-grid {
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

        .book-card {
            background: #4a5568;
            border-bottom: 1px solid #718096;
            padding: 20px;
            transition: all 0.3s ease;
        }

        .book-card:hover {
            background: #556270;
            transform: translateX(5px);
        }

        .book-card:last-child {
            border-bottom: none;
        }

        .book-header {
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

        .book-author {
            color: #a0aec0;
            font-size: 14px;
        }

        .book-details {
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

        .book-actions {
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
            background: #ff9800;
            color: white;
        }

        .btn-edit:hover {
            background: #f57c00;
        }

        .btn-delete {
            background: #f44336;
            color: white;
        }

        .btn-delete:hover {
            background: #d32f2f;
        }

        .availability-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .available {
            background: #4caf50;
            color: white;
        }

        .unavailable {
            background: #f44336;
            color: white;
        }

        .low-stock {
            background: #ff9800;
            color: white;
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
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            z-index: 1001;
            display: none;
        }

        .notification.success {
            background: #4caf50;
        }

        .notification.error {
            background: #f44336;
        }

        @media (max-width: 768px) {
            .search-row {
                grid-template-columns: 1fr;
            }
            
            .book-header {
                flex-direction: column;
                gap: 10px;
            }
            
            .book-actions {
                justify-content: flex-start;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Notification Container -->
    <div id="notification" class="notification" style="display: none;"></div>

    <div class="books-container">
        <div class="alert-header">
            <h2 style="color: #e2e8f0; margin-bottom: 10px;">Books Management</h2>
            <p style="color: #a0aec0; margin: 0;">Manage library books, track availability, and handle inventory</p>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-book"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblTotalBooks" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Total Books</div>
            </div>

            <div class="stat-card info">
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
                    <i class="fas fa-exchange-alt"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblIssuedBooks" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Books Issued</div>
            </div>

            <div class="stat-card danger">
                <div class="stat-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblLowStockBooks" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-label">Low Stock</div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <asp:Button ID="btnAddBook" runat="server" Text="+ Add New Book" 
                CssClass="btn-book" OnClientClick="openAddModal(); return false;" />
            <asp:Button ID="btnImportBooks" runat="server" Text="Import Books" 
                CssClass="btn-book secondary" OnClick="btnImportBooks_Click" CausesValidation="false" />
            <asp:Button ID="btnExportBooks" runat="server" Text="Export Books" 
                CssClass="btn-book secondary" OnClick="btnExportBooks_Click" CausesValidation="false" />
        </div>

        <!-- Search and Filter -->
        <div class="search-filter">
            <div class="search-row">
                <div class="form-group">
                    <label class="form-label">Search Books</label>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" 
                        placeholder="Search by title, author, ISBN..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Category</label>
                    <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="form-control" 
                        AutoPostBack="true" OnSelectedIndexChanged="ddlCategoryFilter_SelectedIndexChanged">
                        <asp:ListItem Value="">All Categories</asp:ListItem>
                    </asp:DropDownList>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Availability</label>
                    <asp:DropDownList ID="ddlAvailabilityFilter" runat="server" CssClass="form-control" 
                        AutoPostBack="true" OnSelectedIndexChanged="ddlAvailabilityFilter_SelectedIndexChanged">
                        <asp:ListItem Value="">All</asp:ListItem>
                        <asp:ListItem Value="Available">Available</asp:ListItem>
                        <asp:ListItem Value="Unavailable">Unavailable</asp:ListItem>
                        <asp:ListItem Value="LowStock">Low Stock</asp:ListItem>
                    </asp:DropDownList>
                </div>
                
                <div class="form-group">
                    <asp:Button ID="btnClearFilters" runat="server" Text="Clear Filters" 
                        CssClass="btn-book secondary" OnClick="btnClearFilters_Click" CausesValidation="false" />
                </div>
            </div>
        </div>

        <!-- Books Grid -->
        <div class="books-grid">
            <div class="grid-header">
                Library Books
            </div>

            <asp:Repeater ID="rptBooks" runat="server" OnItemCommand="rptBooks_ItemCommand">
                <ItemTemplate>
                    <div class="book-card">
                        <div class="book-header">
                            <div style="flex: 1;">
                                <div class="book-title"><%# Eval("BookTitle") %></div>
                                <div class="book-author">by <%# Eval("Author") %></div>
                            </div>
                            <div>
                                <span class='availability-badge <%# GetAvailabilityClass(Eval("AvailableCopies"), Eval("TotalCopies")) %>'>
                                    <%# GetAvailabilityText(Eval("AvailableCopies"), Eval("TotalCopies")) %>
                                </span>
                            </div>
                        </div>
                        
                        <div class="book-details">
                            <div class="detail-item">
                                <span class="detail-label">ISBN</span>
                                <span class="detail-value"><%# Eval("ISBN") %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Publisher</span>
                                <span class="detail-value"><%# Eval("Publisher") %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Edition</span>
                                <span class="detail-value"><%# Eval("Edition") %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Category</span>
                                <span class="detail-value"><%# Eval("Category") %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Shelf</span>
                                <span class="detail-value"><%# Eval("ShelfNumber") %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Copies</span>
                                <span class="detail-value"><%# Eval("AvailableCopies") %>/<%# Eval("TotalCopies") %></span>
                            </div>
                        </div>
                        
                        <div class="book-actions">
                            <asp:Button ID="btnEdit" runat="server" Text="Edit" 
                                CssClass="btn-action btn-edit" 
                                CommandName="Edit" 
                                CommandArgument='<%# Eval("BookId") %>' CausesValidation="false" />
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" 
                                CssClass="btn-action btn-delete" 
                                CommandName="Delete" 
                                CommandArgument='<%# Eval("BookId") %>'
                                OnClientClick="return confirm('Are you sure you want to delete this book?');" CausesValidation="false" />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Label ID="lblNoBooks" runat="server" Text="No books found matching your criteria." 
                CssClass="no-data" Visible="false"></asp:Label>
        </div>

        <!-- Pagination -->
        <div class="pagination">
            <asp:Button ID="btnPrev" runat="server" Text="← Previous" 
                CssClass="btn-book secondary" OnClick="btnPrev_Click" Enabled="false" CausesValidation="false" />
            <span class="page-info">
                Page <asp:Label ID="lblCurrentPage" runat="server" Text="1"></asp:Label> of 
                <asp:Label ID="lblTotalPages" runat="server" Text="1"></asp:Label>
            </span>
            <asp:Button ID="btnNext" runat="server" Text="Next →" 
                CssClass="btn-book secondary" OnClick="btnNext_Click" Enabled="false" CausesValidation="false" />
        </div>
    </div>

    <!-- Add/Edit Book Modal -->
    <div id="bookModal" class="modal-overlay" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title" id="lblModalTitle">Add New Book</div>
                <button type="button" class="close-modal" onclick="closeModal()">×</button>
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfBookId" runat="server" Value="0" />
                
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Book Title *</label>
                        <asp:TextBox ID="txtBookTitle" runat="server" CssClass="form-control" 
                            placeholder="Enter book title" MaxLength="200"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvBookTitle" runat="server" 
                            ControlToValidate="txtBookTitle" ErrorMessage="Book title is required" 
                            Display="Dynamic" ForeColor="#ff6b6b" Font-Size="12px"></asp:RequiredFieldValidator>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Author *</label>
                        <asp:TextBox ID="txtAuthor" runat="server" CssClass="form-control" 
                            placeholder="Enter author name" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAuthor" runat="server" 
                            ControlToValidate="txtAuthor" ErrorMessage="Author is required" 
                            Display="Dynamic" ForeColor="#ff6b6b" Font-Size="12px"></asp:RequiredFieldValidator>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">ISBN *</label>
                        <asp:TextBox ID="txtISBN" runat="server" CssClass="form-control" 
                            placeholder="Enter ISBN" MaxLength="20"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvISBN" runat="server" 
                            ControlToValidate="txtISBN" ErrorMessage="ISBN is required" 
                            Display="Dynamic" ForeColor="#ff6b6b" Font-Size="12px"></asp:RequiredFieldValidator>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Publisher *</label>
                        <asp:TextBox ID="txtPublisher" runat="server" CssClass="form-control" 
                            placeholder="Enter publisher" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPublisher" runat="server" 
                            ControlToValidate="txtPublisher" ErrorMessage="Publisher is required" 
                            Display="Dynamic" ForeColor="#ff6b6b" Font-Size="12px"></asp:RequiredFieldValidator>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Edition *</label>
                        <asp:TextBox ID="txtEdition" runat="server" CssClass="form-control" 
                            placeholder="e.g., 1st, 2nd, 3rd" MaxLength="50"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEdition" runat="server" 
                            ControlToValidate="txtEdition" ErrorMessage="Edition is required" 
                            Display="Dynamic" ForeColor="#ff6b6b" Font-Size="12px"></asp:RequiredFieldValidator>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Category *</label>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">Select Category</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvCategory" runat="server" 
                            ControlToValidate="ddlCategory" ErrorMessage="Category is required" 
                            Display="Dynamic" ForeColor="#ff6b6b" Font-Size="12px"></asp:RequiredFieldValidator>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Total Copies *</label>
                        <asp:TextBox ID="txtTotalCopies" runat="server" CssClass="form-control" 
                            TextMode="Number" min="1" Value="1"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvTotalCopies" runat="server" 
                            ControlToValidate="txtTotalCopies" ErrorMessage="Total copies is required" 
                            Display="Dynamic" ForeColor="#ff6b6b" Font-Size="12px"></asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="cvTotalCopies" runat="server" 
                            ControlToValidate="txtTotalCopies" Operator="DataTypeCheck" Type="Integer"
                            ErrorMessage="Must be a valid number" Display="Dynamic" ForeColor="#ff6b6b" Font-Size="12px"></asp:CompareValidator>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Available Copies *</label>
                        <asp:TextBox ID="txtAvailableCopies" runat="server" CssClass="form-control" 
                            TextMode="Number" min="0" Value="1"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAvailableCopies" runat="server" 
                            ControlToValidate="txtAvailableCopies" ErrorMessage="Available copies is required" 
                            Display="Dynamic" ForeColor="#ff6b6b" Font-Size="12px"></asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="cvAvailableCopies" runat="server" 
                            ControlToValidate="txtAvailableCopies" Operator="DataTypeCheck" Type="Integer"
                            ErrorMessage="Must be a valid number" Display="Dynamic" ForeColor="#ff6b6b" Font-Size="12px"></asp:CompareValidator>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Shelf Number *</label>
                        <asp:TextBox ID="txtShelfNumber" runat="server" CssClass="form-control" 
                            placeholder="e.g., CS-001" MaxLength="20"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvShelfNumber" runat="server" 
                            ControlToValidate="txtShelfNumber" ErrorMessage="Shelf number is required" 
                            Display="Dynamic" ForeColor="#ff6b6b" Font-Size="12px"></asp:RequiredFieldValidator>
                    </div>
                </div>
                
                <div style="display: flex; gap: 10px; margin-top: 25px; justify-content: flex-end;">
                    <asp:Button ID="btnSaveBook" runat="server" Text="Save Book" 
                        CssClass="btn-book" OnClick="btnSaveBook_Click" OnClientClick="return validateForm();" />
                    <button type="button" class="btn-book secondary" onclick="closeModal()">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // Global functions for modal management
        function openAddModal() {
            console.log('Opening add modal...');
            
            // Reset form for new book
            document.getElementById('<%= hfBookId.ClientID %>').value = "0";
            document.getElementById('<%= txtBookTitle.ClientID %>').value = "";
            document.getElementById('<%= txtAuthor.ClientID %>').value = "";
            document.getElementById('<%= txtISBN.ClientID %>').value = "";
            document.getElementById('<%= txtPublisher.ClientID %>').value = "";
            document.getElementById('<%= txtEdition.ClientID %>').value = "";
            if (document.getElementById('<%= ddlCategory.ClientID %>')) {
                document.getElementById('<%= ddlCategory.ClientID %>').selectedIndex = 0;
            }
            document.getElementById('<%= txtTotalCopies.ClientID %>').value = "1";
            document.getElementById('<%= txtAvailableCopies.ClientID %>').value = "1";
            document.getElementById('<%= txtShelfNumber.ClientID %>').value = "";
            document.getElementById('lblModalTitle').innerText = "Add New Book";
            
            // Clear validation errors
            var validators = document.querySelectorAll('[id*="rfv"], [id*="cv"]');
            validators.forEach(function(validator) {
                validator.style.display = 'none';
            });
            
            // Show modal
            var modal = document.getElementById('bookModal');
            if (modal) {
                modal.style.display = 'block';
                console.log('Add modal displayed');
            } else {
                console.error('Modal element not found');
            }
        }

        function openEditModal(bookId) {
            console.log('Opening edit modal for book ID: ' + bookId);
            // This function will be called from server-side when editing
            var modal = document.getElementById('bookModal');
            if (modal) {
                modal.style.display = 'block';
                console.log('Edit modal displayed');
            }
        }

        function closeModal() {
            console.log('Closing modal...');
            var modal = document.getElementById('bookModal');
            if (modal) {
                modal.style.display = 'none';
                console.log('Modal hidden');
            }
        }

        function validateForm() {
            console.log('Validating form...');
            var totalCopies = parseInt(document.getElementById('<%= txtTotalCopies.ClientID %>').value);
            var availableCopies = parseInt(document.getElementById('<%= txtAvailableCopies.ClientID %>').value);

            if (isNaN(totalCopies) || isNaN(availableCopies)) {
                alert('Please enter valid numbers for copies');
                return false;
            }

            if (availableCopies > totalCopies) {
                alert('Available copies cannot be greater than total copies');
                return false;
            }

            if (totalCopies < 1) {
                alert('Total copies must be at least 1');
                return false;
            }

            if (availableCopies < 0) {
                alert('Available copies cannot be negative');
                return false;
            }

            return true;
        }

        function showNotification(message, type) {
            var notification = document.getElementById('notification');
            if (notification) {
                notification.textContent = message;
                notification.className = 'notification ' + type;
                notification.style.display = 'block';

                setTimeout(function () {
                    notification.style.display = 'none';
                }, 5000);
            }
        }

        // Close modal when clicking outside
        window.onclick = function (event) {
            var modal = document.getElementById('bookModal');
            if (event.target == modal) {
                closeModal();
            }
        }

        // Add event listener for Enter key in search box
        var searchBox = document.getElementById('<%= txtSearch.ClientID %>');
        if (searchBox) {
            searchBox.addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    __doPostBack('<%= txtSearch.UniqueID %>', '');
                }
            });
        }

        // Make functions globally available
        window.openAddModal = openAddModal;
        window.openEditModal = openEditModal;
        window.closeModal = closeModal;
        window.validateForm = validateForm;
        window.showNotification = showNotification;
    </script>
</asp:Content>