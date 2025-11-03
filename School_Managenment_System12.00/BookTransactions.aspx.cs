using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class BookTransactions : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
        private int pageSize = 10;
        private int currentPage = 1;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadPageTitle();
                LoadStatistics();
                LoadStudents();
                LoadBooks();
                LoadTransactions();

                // Set default dates
                txtIssueDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtDueDate.Text = DateTime.Now.AddDays(14).ToString("yyyy-MM-dd");
                txtReturnDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            }
        }

        private void LoadPageTitle()
        {
            if (Master != null)
            {
                Label lblPageTitle = (Label)Master.FindControl("lblPageTitle");
                if (lblPageTitle != null)
                {
                    lblPageTitle.Text = "Book Transactions";
                }
            }
        }

        private void LoadStatistics()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Total Transactions
                    string totalQuery = "SELECT COUNT(*) FROM BookTransactions";
                    SqlCommand totalCmd = new SqlCommand(totalQuery, conn);
                    lblTotalTransactions.Text = totalCmd.ExecuteScalar().ToString();

                    // Issued Books
                    string issuedQuery = "SELECT COUNT(*) FROM BookTransactions WHERE ReturnDate IS NULL";
                    SqlCommand issuedCmd = new SqlCommand(issuedQuery, conn);
                    lblIssuedBooks.Text = issuedCmd.ExecuteScalar().ToString();

                    // Overdue Books
                    string overdueQuery = @"SELECT COUNT(*) FROM BookTransactions 
                                          WHERE ReturnDate IS NULL AND DueDate < GETDATE()";
                    SqlCommand overdueCmd = new SqlCommand(overdueQuery, conn);
                    lblOverdueBooks.Text = overdueCmd.ExecuteScalar().ToString();

                    // Total Fines
                    string finesQuery = "SELECT ISNULL(SUM(FineAmount), 0) FROM BookTransactions WHERE FineAmount > 0";
                    SqlCommand finesCmd = new SqlCommand(finesQuery, conn);
                    lblTotalFines.Text = finesCmd.ExecuteScalar().ToString();
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading statistics: " + ex.Message);
            }
        }

        private void LoadStudents()
        {
            try
            {
                string query = @"SELECT s.StudentId, s.RollNumber, s.FirstName + ' ' + s.LastName as StudentName,
                                c.ClassName + ' ' + c.Section as ClassName, s.Phone
                                FROM Students s
                                INNER JOIN Classes c ON s.ClassId = c.ClassID
                                WHERE s.IsActive = 1
                                ORDER BY s.FirstName, s.LastName";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        ddlStudents.DataSource = dt;
                        ddlStudents.DataTextField = "StudentName";
                        ddlStudents.DataValueField = "StudentId";
                        ddlStudents.DataBind();
                        ddlStudents.Items.Insert(0, new ListItem("Select Student", ""));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading students: " + ex.Message);
            }
        }

        private void LoadBooks()
        {
            try
            {
                string query = @"SELECT BookId, BookTitle, Author, AvailableCopies, ShelfNumber
                                FROM Books 
                                WHERE IsActive = 1 AND AvailableCopies > 0
                                ORDER BY BookTitle";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        ddlBooks.DataSource = dt;
                        ddlBooks.DataTextField = "BookTitle";
                        ddlBooks.DataValueField = "BookId";
                        ddlBooks.DataBind();
                        ddlBooks.Items.Insert(0, new ListItem("Select Book", ""));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading books: " + ex.Message);
            }
        }

        private void LoadTransactions()
        {
            try
            {
                string query = @"SELECT bt.TransactionId, b.BookTitle, 
                                s.FirstName + ' ' + s.LastName as StudentName,
                                s.RollNumber, c.ClassName, 
                                bt.IssueDate, bt.DueDate, bt.ReturnDate,
                                CASE 
                                    WHEN bt.ReturnDate IS NOT NULL THEN 'Returned'
                                    WHEN bt.DueDate < GETDATE() THEN 'Overdue'
                                    ELSE 'Issued'
                                END as Status,
                                bt.FineAmount,
                                u.FirstName + ' ' + u.LastName as IssuedByName
                                FROM BookTransactions bt
                                INNER JOIN Books b ON bt.BookId = b.BookId
                                INNER JOIN Students s ON bt.StudentId = s.StudentId
                                INNER JOIN Classes c ON s.ClassId = c.ClassID
                                LEFT JOIN Users u ON bt.IssuedBy = u.UserId
                                WHERE 1=1";

                // Apply filters
                if (!string.IsNullOrEmpty(txtSearch.Text))
                {
                    query += " AND (b.BookTitle LIKE @Search OR s.FirstName + ' ' + s.LastName LIKE @Search OR s.RollNumber LIKE @Search)";
                }

                if (!string.IsNullOrEmpty(ddlStatusFilter.SelectedValue))
                {
                    if (ddlStatusFilter.SelectedValue == "Issued")
                    {
                        query += " AND bt.ReturnDate IS NULL AND bt.DueDate >= GETDATE()";
                    }
                    else if (ddlStatusFilter.SelectedValue == "Overdue")
                    {
                        query += " AND bt.ReturnDate IS NULL AND bt.DueDate < GETDATE()";
                    }
                    else if (ddlStatusFilter.SelectedValue == "Returned")
                    {
                        query += " AND bt.ReturnDate IS NOT NULL";
                    }
                }

                if (!string.IsNullOrEmpty(ddlDateRange.SelectedValue))
                {
                    switch (ddlDateRange.SelectedValue)
                    {
                        case "today":
                            query += " AND CAST(bt.IssueDate AS DATE) = CAST(GETDATE() AS DATE)";
                            break;
                        case "week":
                            query += " AND bt.IssueDate >= DATEADD(day, -7, GETDATE())";
                            break;
                        case "month":
                            query += " AND bt.IssueDate >= DATEADD(month, -1, GETDATE())";
                            break;
                        case "overdue":
                            query += " AND bt.DueDate < GETDATE() AND bt.ReturnDate IS NULL";
                            break;
                    }
                }

                query += " ORDER BY bt.IssueDate DESC";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(txtSearch.Text))
                        {
                            cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text + "%");
                        }

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        // Implement simple pagination
                        int totalRecords = dt.Rows.Count;
                        int totalPages = (int)Math.Ceiling((double)totalRecords / pageSize);

                        lblTotalPages.Text = totalPages.ToString();
                        lblCurrentPage.Text = currentPage.ToString();

                        // Enable/disable pagination buttons
                        btnPrev.Enabled = currentPage > 1;
                        btnNext.Enabled = currentPage < totalPages;

                        if (totalRecords > 0)
                        {
                            // Get current page data
                            DataTable pagedDt = dt.Clone();
                            int startIndex = (currentPage - 1) * pageSize;
                            int endIndex = Math.Min(startIndex + pageSize, totalRecords);

                            for (int i = startIndex; i < endIndex; i++)
                            {
                                pagedDt.ImportRow(dt.Rows[i]);
                            }

                            rptTransactions.DataSource = pagedDt;
                            rptTransactions.DataBind();
                            lblNoTransactions.Visible = false;
                        }
                        else
                        {
                            rptTransactions.DataSource = null;
                            rptTransactions.DataBind();
                            lblNoTransactions.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading transactions: " + ex.Message);
            }
        }

        // WebMethod for loading student details via AJAX
        [WebMethod]
        public static object GetStudentDetails(int studentId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

                string query = @"SELECT s.Phone, c.ClassName + ' ' + c.Section as ClassName,
                                (SELECT COUNT(*) FROM BookTransactions 
                                 WHERE StudentId = @StudentId AND ReturnDate IS NULL) as IssuedBooksCount
                                FROM Students s
                                INNER JOIN Classes c ON s.ClassId = c.ClassID
                                WHERE s.StudentId = @StudentId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentId", studentId);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            var studentDetails = new
                            {
                                ClassName = reader["ClassName"].ToString(),
                                Phone = reader["Phone"].ToString(),
                                IssuedBooksCount = reader["IssuedBooksCount"].ToString()
                            };

                            reader.Close();
                            return new { success = true, data = studentDetails };
                        }
                        reader.Close();
                    }
                }

                return new { success = false, error = "Student not found" };
            }
            catch (Exception ex)
            {
                return new { success = false, error = ex.Message };
            }
        }

        // WebMethod for loading book details via AJAX
        [WebMethod]
        public static object GetBookDetails(int bookId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

                string query = "SELECT Author, AvailableCopies, ShelfNumber FROM Books WHERE BookId = @BookId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@BookId", bookId);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            var bookDetails = new
                            {
                                Author = reader["Author"].ToString(),
                                AvailableCopies = reader["AvailableCopies"].ToString(),
                                ShelfNumber = reader["ShelfNumber"].ToString()
                            };

                            reader.Close();
                            return new { success = true, data = bookDetails };
                        }
                        reader.Close();
                    }
                }

                return new { success = false, error = "Book not found" };
            }
            catch (Exception ex)
            {
                return new { success = false, error = ex.Message };
            }
        }

        protected void btnSaveIssue_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(ddlStudents.SelectedValue) || string.IsNullOrEmpty(ddlBooks.SelectedValue))
                {
                    ShowErrorMessage("Please select both student and book.");
                    return;
                }

                int studentId = int.Parse(ddlStudents.SelectedValue);
                int bookId = int.Parse(ddlBooks.SelectedValue);
                DateTime issueDate = DateTime.Parse(txtIssueDate.Text);
                DateTime dueDate = DateTime.Parse(txtDueDate.Text);

                // Validate available copies
                if (!IsBookAvailable(bookId))
                {
                    ShowErrorMessage("Selected book is no longer available");
                    return;
                }

                // Validate student doesn't have too many books
                if (GetStudentIssuedBooksCount(studentId) >= 3) // Max 3 books per student
                {
                    ShowErrorMessage("Student has reached the maximum limit of issued books");
                    return;
                }

                // Insert transaction
                string query = @"INSERT INTO BookTransactions (BookId, StudentId, IssueDate, DueDate, Status, IssuedBy, FineAmount)
                               VALUES (@BookId, @StudentId, @IssueDate, @DueDate, 'Issued', @IssuedBy, 0)";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@BookId", bookId);
                        cmd.Parameters.AddWithValue("@StudentId", studentId);
                        cmd.Parameters.AddWithValue("@IssueDate", issueDate);
                        cmd.Parameters.AddWithValue("@DueDate", dueDate);
                        cmd.Parameters.AddWithValue("@IssuedBy", Session["UserId"]);

                        conn.Open();
                        int result = cmd.ExecuteNonQuery();

                        if (result > 0)
                        {
                            // Update book available copies
                            UpdateBookCopies(bookId, -1);

                            LoadTransactions();
                            LoadStatistics();
                            LoadBooks(); // Refresh available books

                            // Close modal and show success message
                            ScriptManager.RegisterStartupScript(this, GetType(), "CloseIssueModal", "closeIssueModal();", true);
                            ShowSuccessMessage("Book issued successfully!");
                        }
                        else
                        {
                            ShowErrorMessage("Failed to issue book. Please try again.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error issuing book: " + ex.Message);
            }
        }

        private bool IsBookAvailable(int bookId)
        {
            string query = "SELECT AvailableCopies FROM Books WHERE BookId = @BookId";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@BookId", bookId);
                    conn.Open();
                    int availableCopies = (int)cmd.ExecuteScalar();
                    return availableCopies > 0;
                }
            }
        }

        private int GetStudentIssuedBooksCount(int studentId)
        {
            string query = "SELECT COUNT(*) FROM BookTransactions WHERE StudentId = @StudentId AND ReturnDate IS NULL";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    conn.Open();
                    return (int)cmd.ExecuteScalar();
                }
            }
        }

        private void UpdateBookCopies(int bookId, int change)
        {
            string query = "UPDATE Books SET AvailableCopies = AvailableCopies + @Change WHERE BookId = @BookId";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Change", change);
                    cmd.Parameters.AddWithValue("@BookId", bookId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void rptTransactions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                int transactionId = Convert.ToInt32(e.CommandArgument);

                if (e.CommandName == "Return")
                {
                    LoadTransactionForReturn(transactionId);
                }
                else if (e.CommandName == "Renew")
                {
                    RenewBook(transactionId);
                }
                else if (e.CommandName == "View")
                {
                    ShowTransactionDetails(transactionId);
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error processing command: " + ex.Message);
            }
        }

        private void LoadTransactionForReturn(int transactionId)
        {
            try
            {
                string query = @"SELECT bt.TransactionId, b.BookTitle, 
                        s.FirstName + ' ' + s.LastName as StudentName,
                        bt.IssueDate, bt.DueDate, bt.FineAmount, bt.BookId
                        FROM BookTransactions bt
                        INNER JOIN Books b ON bt.BookId = b.BookId
                        INNER JOIN Students s ON bt.StudentId = s.StudentId
                        WHERE bt.TransactionId = @TransactionId AND bt.ReturnDate IS NULL";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TransactionId", transactionId);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            hfReturnTransactionId.Value = reader["TransactionId"].ToString();
                            lblReturnBookTitle.Text = reader["BookTitle"].ToString();
                            lblReturnStudentName.Text = reader["StudentName"].ToString();
                            lblReturnIssueDate.Text = Convert.ToDateTime(reader["IssueDate"]).ToString("MMM dd, yyyy");
                            lblReturnDueDate.Text = Convert.ToDateTime(reader["DueDate"]).ToString("MMM dd, yyyy");

                            // Set ISO date for JavaScript calculation
                            DateTime dueDate = Convert.ToDateTime(reader["DueDate"]);
                            hfReturnDueDateISO.Value = dueDate.ToString("yyyy-MM-dd");

                            // Calculate days overdue
                            int daysOverdue = (DateTime.Today - dueDate).Days;
                            lblDaysOverdue.Text = daysOverdue > 0 ? daysOverdue.ToString() : "0";

                            // Calculate fine
                            decimal fineAmount = daysOverdue > 0 ? daysOverdue * 5 : 0; // $5 per day
                            txtFineAmount.Text = fineAmount.ToString("0.00");

                            // Store book ID for updating copies
                            ViewState["ReturnBookId"] = reader["BookId"];

                            // Debug information
                            System.Diagnostics.Debug.WriteLine($"LoadTransactionForReturn - TransactionId: {transactionId}, BookId: {reader["BookId"]}");

                            // SUCCESS: Register script to open return modal
                            ScriptManager.RegisterStartupScript(this, GetType(), "OpenReturnModal",
                                "setTimeout(function() { openReturnModal(); }, 100);", true);
                        }
                        else
                        {
                            ShowErrorMessage("Transaction not found or book already returned.");
                            return;
                        }
                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading transaction for return: " + ex.Message);
            }
        }

        protected void btnSaveReturn_Click(object sender, EventArgs e)
        {
            try
            {
                // Debug information
                System.Diagnostics.Debug.WriteLine($"btnSaveReturn_Click started - hfReturnTransactionId: {hfReturnTransactionId.Value}");

                if (string.IsNullOrEmpty(hfReturnTransactionId.Value))
                {
                    ShowErrorMessage("No transaction selected for return.");
                    return;
                }

                int transactionId = int.Parse(hfReturnTransactionId.Value);
                DateTime returnDate = DateTime.Parse(txtReturnDate.Text);
                decimal fineAmount = decimal.Parse(string.IsNullOrEmpty(txtFineAmount.Text) ? "0" : txtFineAmount.Text);

                // Get book ID from ViewState
                int bookId = ViewState["ReturnBookId"] != null ? (int)ViewState["ReturnBookId"] : 0;

                System.Diagnostics.Debug.WriteLine($"BookId from ViewState: {bookId}");

                if (bookId == 0)
                {
                    // Fallback: get book ID from database
                    string getBookQuery = "SELECT BookId FROM BookTransactions WHERE TransactionId = @TransactionId";
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand(getBookQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@TransactionId", transactionId);
                            conn.Open();
                            bookId = (int)cmd.ExecuteScalar();
                            System.Diagnostics.Debug.WriteLine($"BookId from database: {bookId}");
                        }
                    }
                }

                if (bookId == 0)
                {
                    ShowErrorMessage("Could not find book ID for this transaction.");
                    return;
                }

                // Update transaction - REMOVED ConditionNotes parameter
                string updateQuery = @"UPDATE BookTransactions 
                             SET ReturnDate = @ReturnDate, 
                                 FineAmount = @FineAmount,
                                 Status = 'Returned'
                             WHERE TransactionId = @TransactionId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@ReturnDate", returnDate);
                        cmd.Parameters.AddWithValue("@FineAmount", fineAmount);
                        cmd.Parameters.AddWithValue("@TransactionId", transactionId);

                        conn.Open();
                        int result = cmd.ExecuteNonQuery();

                        System.Diagnostics.Debug.WriteLine($"Database update result: {result}");

                        if (result > 0)
                        {
                            // Update book available copies
                            UpdateBookCopies(bookId, 1);

                            LoadTransactions();
                            LoadStatistics();
                            LoadBooks(); // Refresh available books

                            // Clear ViewState
                            ViewState["ReturnBookId"] = null;

                            // Close modal and show success message
                            ScriptManager.RegisterStartupScript(this, GetType(), "CloseReturnModal",
                                "setTimeout(function() { closeReturnModal(); }, 100);", true);
                            ShowSuccessMessage("Book returned successfully!");
                        }
                        else
                        {
                            ShowErrorMessage("Failed to return book. Please try again.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnSaveReturn_Click: {ex.Message}");
                ShowErrorMessage("Error returning book: " + ex.Message);
            }
        }

        private void RenewBook(int transactionId)
        {
            try
            {
                // Renew for 14 more days
                string query = @"UPDATE BookTransactions 
                               SET DueDate = DATEADD(day, 14, DueDate)
                               WHERE TransactionId = @TransactionId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TransactionId", transactionId);
                        conn.Open();
                        int result = cmd.ExecuteNonQuery();

                        if (result > 0)
                        {
                            LoadTransactions();
                            ShowSuccessMessage("Book renewed successfully for 14 more days!");
                        }
                        else
                        {
                            ShowErrorMessage("Failed to renew book. Please try again.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error renewing book: " + ex.Message);
            }
        }

        private void ShowTransactionDetails(int transactionId)
        {
            try
            {
                string query = @"SELECT bt.*, b.BookTitle, b.Author, 
                                s.FirstName + ' ' + s.LastName as StudentName,
                                s.RollNumber, c.ClassName,
                                u.FirstName + ' ' + u.LastName as IssuedByName
                                FROM BookTransactions bt
                                INNER JOIN Books b ON bt.BookId = b.BookId
                                INNER JOIN Students s ON bt.StudentId = s.StudentId
                                INNER JOIN Classes c ON s.ClassId = c.ClassID
                                LEFT JOIN Users u ON bt.IssuedBy = u.UserId
                                WHERE bt.TransactionId = @TransactionId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TransactionId", transactionId);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            string details = $"Book: {reader["BookTitle"]}\n" +
                                           $"Author: {reader["Author"]}\n" +
                                           $"Student: {reader["StudentName"]}\n" +
                                           $"Class: {reader["ClassName"]}\n" +
                                           $"Roll #: {reader["RollNumber"]}\n" +
                                           $"Issue Date: {Convert.ToDateTime(reader["IssueDate"]):MMM dd, yyyy}\n" +
                                           $"Due Date: {Convert.ToDateTime(reader["DueDate"]):MMM dd, yyyy}\n" +
                                           $"Issued By: {reader["IssuedByName"]}";

                            if (reader["ReturnDate"] != DBNull.Value)
                            {
                                details += $"\nReturn Date: {Convert.ToDateTime(reader["ReturnDate"]):MMM dd, yyyy}";
                            }

                            if (Convert.ToDecimal(reader["FineAmount"]) > 0)
                            {
                                details += $"\nFine Amount: ${Convert.ToDecimal(reader["FineAmount"]):0.00}";
                            }

                            ShowSuccessMessage("Transaction Details:\n\n" + details);
                        }
                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading transaction details: " + ex.Message);
            }
        }

        // Quick Return functionality
        protected void txtQuickSearch_TextChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtQuickSearch.Text))
            {
                SearchBooksForReturn();
            }
            else
            {
                pnlQuickResults.Visible = false;
                lblNoQuickResults.Visible = false;
            }
        }

        private void SearchBooksForReturn()
        {
            try
            {
                string query = @"SELECT bt.TransactionId, b.BookTitle, 
                        s.FirstName + ' ' + s.LastName as StudentName,
                        s.RollNumber, bt.DueDate, bt.BookId
                        FROM BookTransactions bt
                        INNER JOIN Books b ON bt.BookId = b.BookId
                        INNER JOIN Students s ON bt.StudentId = s.StudentId
                        WHERE bt.ReturnDate IS NULL 
                        AND (b.BookTitle LIKE @Search 
                             OR s.FirstName + ' ' + s.LastName LIKE @Search 
                             OR s.RollNumber LIKE @Search)";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Search", "%" + txtQuickSearch.Text + "%");
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptQuickResults.DataSource = dt;
                            rptQuickResults.DataBind();
                            pnlQuickResults.Visible = true;
                            lblNoQuickResults.Visible = false;

                            // Open modal if results found
                            ScriptManager.RegisterStartupScript(this, GetType(), "OpenQuickReturnModal",
                                "setTimeout(function() { openQuickReturnModal(); }, 100);", true);
                        }
                        else
                        {
                            pnlQuickResults.Visible = false;
                            lblNoQuickResults.Visible = true;
                            ScriptManager.RegisterStartupScript(this, GetType(), "OpenQuickReturnModal",
                                "setTimeout(function() { openQuickReturnModal(); }, 100);", true);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error searching books: " + ex.Message);
            }
        }

        protected void rptQuickResults_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "QuickReturn")
            {
                int transactionId = Convert.ToInt32(e.CommandArgument);
                ProcessQuickReturn(transactionId);
            }
        }

        private void ProcessQuickReturn(int transactionId)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine($"ProcessQuickReturn started - TransactionId: {transactionId}");

                // Get book ID from transaction
                string getBookQuery = "SELECT BookId FROM BookTransactions WHERE TransactionId = @TransactionId";
                int bookId = 0;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(getBookQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@TransactionId", transactionId);
                        conn.Open();
                        bookId = (int)cmd.ExecuteScalar();
                        System.Diagnostics.Debug.WriteLine($"QuickReturn - BookId: {bookId}");
                    }
                }

                // Calculate fine
                string getDueDateQuery = "SELECT DueDate FROM BookTransactions WHERE TransactionId = @TransactionId";
                DateTime dueDate = DateTime.Now;
                decimal fineAmount = 0;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(getDueDateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@TransactionId", transactionId);
                        conn.Open();
                        dueDate = (DateTime)cmd.ExecuteScalar();
                    }
                }

                int daysOverdue = (DateTime.Today - dueDate).Days;
                fineAmount = daysOverdue > 0 ? daysOverdue * 5 : 0;

                // Update transaction - REMOVED ConditionNotes parameter
                string updateQuery = @"UPDATE BookTransactions 
                             SET ReturnDate = GETDATE(), 
                                 FineAmount = @FineAmount,
                                 Status = 'Returned'
                             WHERE TransactionId = @TransactionId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@FineAmount", fineAmount);
                        cmd.Parameters.AddWithValue("@TransactionId", transactionId);
                        conn.Open();
                        int result = cmd.ExecuteNonQuery();

                        System.Diagnostics.Debug.WriteLine($"QuickReturn database update result: {result}");

                        if (result > 0)
                        {
                            // Update book available copies
                            UpdateBookCopies(bookId, 1);

                            LoadTransactions();
                            LoadStatistics();
                            LoadBooks();

                            // Clear quick search and hide results
                            txtQuickSearch.Text = "";
                            pnlQuickResults.Visible = false;
                            lblNoQuickResults.Visible = false;

                            // Close modal
                            ScriptManager.RegisterStartupScript(this, GetType(), "CloseQuickReturnModal",
                                "setTimeout(function() { closeQuickReturnModal(); }, 100);", true);
                            ShowSuccessMessage("Book returned successfully via quick return!");
                        }
                        else
                        {
                            ShowErrorMessage("Failed to process quick return. Please try again.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in ProcessQuickReturn: {ex.Message}");
                ShowErrorMessage("Error processing quick return: " + ex.Message);
            }
        }

        // Report Generation
        protected void btnGenerateReport_Click(object sender, EventArgs e)
        {
            GenerateTransactionsReport();
        }

        private void GenerateTransactionsReport()
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("GenerateTransactionsReport started");

                string query = @"SELECT b.BookTitle, s.FirstName + ' ' + s.LastName as StudentName,
                                s.RollNumber, c.ClassName,
                                bt.IssueDate, bt.DueDate, bt.ReturnDate,
                                CASE 
                                    WHEN bt.ReturnDate IS NOT NULL THEN 'Returned'
                                    WHEN bt.DueDate < GETDATE() THEN 'Overdue'
                                    ELSE 'Issued'
                                END as Status,
                                bt.FineAmount,
                                u.FirstName + ' ' + u.LastName as IssuedByName
                                FROM BookTransactions bt
                                INNER JOIN Books b ON bt.BookId = b.BookId
                                INNER JOIN Students s ON bt.StudentId = s.StudentId
                                INNER JOIN Classes c ON s.ClassId = c.ClassID
                                LEFT JOIN Users u ON bt.IssuedBy = u.UserId
                                ORDER BY bt.IssueDate DESC";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        System.Diagnostics.Debug.WriteLine($"Report data rows: {dt.Rows.Count}");

                        if (dt.Rows.Count == 0)
                        {
                            ShowErrorMessage("No data found to generate report.");
                            return;
                        }

                        // Generate CSV report
                        string csv = GenerateCsvFromDataTable(dt);

                        // Clear the response
                        Response.Clear();
                        Response.Buffer = true;
                        Response.ClearHeaders();
                        Response.ClearContent();

                        // Set the response headers for CSV download
                        Response.AddHeader("content-disposition",
                            "attachment;filename=BookTransactions_Report_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".csv");
                        Response.Charset = "";
                        Response.ContentType = "text/csv";
                        Response.ContentEncoding = Encoding.UTF8;

                        // Write the CSV content to response
                        Response.Write(csv);
                        Response.Flush();

                        // End the response properly
                        Response.End();
                    }
                }
            }
            catch (ThreadAbortException)
            {
                // This is expected when using Response.End()
                System.Diagnostics.Debug.WriteLine("ThreadAbortException - This is normal for file download");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GenerateTransactionsReport: {ex.Message}");
                ShowErrorMessage("Error generating report: " + ex.Message);
            }
        }

        private string GenerateCsvFromDataTable(DataTable dt)
        {
            StringBuilder sb = new StringBuilder();

            // Add headers
            string[] columnNames = new string[dt.Columns.Count];
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                columnNames[i] = EscapeCsvField(dt.Columns[i].ColumnName);
            }
            sb.AppendLine(string.Join(",", columnNames));

            // Add rows
            foreach (DataRow row in dt.Rows)
            {
                string[] fields = new string[dt.Columns.Count];
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    fields[i] = EscapeCsvField(row[i] == null ? "" : row[i].ToString());
                }
                sb.AppendLine(string.Join(",", fields));
            }

            return sb.ToString();
        }

        private string EscapeCsvField(string field)
        {
            if (string.IsNullOrEmpty(field))
                return "\"\"";

            // If field contains comma, quote, or newline, escape it
            if (field.Contains(",") || field.Contains("\"") || field.Contains("\r") || field.Contains("\n"))
            {
                field = field.Replace("\"", "\"\"");
                return $"\"{field}\"";
            }

            return field;
        }

        // Public method for data binding
        public string GetDaysRemaining(object dueDate)
        {
            if (dueDate == DBNull.Value || dueDate == null)
                return "N/A";

            DateTime due = Convert.ToDateTime(dueDate);
            DateTime today = DateTime.Today;
            int days = (due - today).Days;

            if (days < 0)
                return $"Overdue by {Math.Abs(days)} days";
            else if (days == 0)
                return "Due today";
            else
                return $"{days} days";
        }

        // Filter and Search Methods
        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadTransactions();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadTransactions();
        }

        protected void ddlDateRange_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadTransactions();
        }

        protected void btnClearFilters_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlStatusFilter.SelectedIndex = 0;
            ddlDateRange.SelectedIndex = 0;
            currentPage = 1;
            LoadTransactions();
        }

        // Pagination Methods
        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (currentPage > 1)
            {
                currentPage--;
                LoadTransactions();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            int totalPages = int.Parse(lblTotalPages.Text);
            if (currentPage < totalPages)
            {
                currentPage++;
                LoadTransactions();
            }
        }

        private void ShowSuccessMessage(string message)
        {
            string cleanMessage = message.Replace("'", "\\'").Replace("\r", "").Replace("\n", " ");
            string script = $@"showNotification('{cleanMessage}', 'success');";

            ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess", script, true);
        }

        private void ShowErrorMessage(string message)
        {
            string cleanMessage = message.Replace("'", "\\'").Replace("\r", "").Replace("\n", " ");
            string script = $@"showNotification('{cleanMessage}', 'error');";

            ScriptManager.RegisterStartupScript(this, GetType(), "showError", script, true);
        }

        protected void ddlStudents_SelectedIndexChanged(object sender, EventArgs e)
        {
            // This method is no longer needed as we're using AJAX
        }

        protected void ddlBooks_SelectedIndexChanged(object sender, EventArgs e)
        {
            // This method is no longer needed as we're using AJAX
        }
    }
}