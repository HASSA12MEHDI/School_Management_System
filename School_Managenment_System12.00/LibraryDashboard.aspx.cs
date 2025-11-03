using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class LibraryDashboard : System.Web.UI.Page
    {
        // Make field readonly
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;

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
                LoadDashboardStats();
                LoadRecentTransactions();
                LoadOverdueBooks();
            }
        }

        private void LoadPageTitle()
        {
            if (Master != null)
            {
                Label lblPageTitle = (Label)Master.FindControl("lblPageTitle");
                if (lblPageTitle != null)
                {
                    lblPageTitle.Text = "Library Dashboard";
                }
            }
        }

        private void LoadDashboardStats()
        {
            try
            {
                if (string.IsNullOrEmpty(connectionString))
                {
                    ShowErrorMessage("Database connection string is not configured.");
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Total Books
                    string totalBooksQuery = "SELECT COUNT(*) FROM Books WHERE IsActive = 1";
                    using (SqlCommand totalBooksCmd = new SqlCommand(totalBooksQuery, conn))
                    {
                        lblTotalBooks.Text = totalBooksCmd.ExecuteScalar().ToString();
                    }

                    // Available Books
                    string availableBooksQuery = "SELECT SUM(AvailableCopies) FROM Books WHERE IsActive = 1";
                    using (SqlCommand availableBooksCmd = new SqlCommand(availableBooksQuery, conn))
                    {
                        var availableResult = availableBooksCmd.ExecuteScalar();
                        lblAvailableBooks.Text = availableResult != DBNull.Value ? availableResult.ToString() : "0";
                    }

                    // Issued Books
                    string issuedBooksQuery = @"SELECT COUNT(*) FROM BookTransactions 
                                              WHERE Status IN ('Issued', 'Overdue')";
                    using (SqlCommand issuedBooksCmd = new SqlCommand(issuedBooksQuery, conn))
                    {
                        lblIssuedBooks.Text = issuedBooksCmd.ExecuteScalar().ToString();
                    }

                    // Overdue Books
                    string overdueBooksQuery = @"SELECT COUNT(*) FROM BookTransactions 
                                               WHERE Status = 'Overdue'";
                    using (SqlCommand overdueBooksCmd = new SqlCommand(overdueBooksQuery, conn))
                    {
                        lblOverdueBooks.Text = overdueBooksCmd.ExecuteScalar().ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading dashboard statistics: " + ex.Message);
            }
        }

        private void LoadRecentTransactions()
        {
            try
            {
                if (string.IsNullOrEmpty(connectionString))
                {
                    ShowErrorMessage("Database connection string is not configured.");
                    return;
                }

                string query = @"SELECT TOP 5 
                                bt.TransactionId, 
                                b.BookTitle,
                                s.FirstName + ' ' + s.LastName as StudentName,
                                bt.IssueDate,
                                bt.DueDate,
                                bt.ReturnDate,
                                bt.Status,
                                bt.FineAmount,
                                u.Username as IssuedByName
                                FROM BookTransactions bt
                                INNER JOIN Books b ON bt.BookId = b.BookId
                                INNER JOIN Students s ON bt.StudentId = s.StudentId
                                LEFT JOIN Users u ON bt.IssuedBy = u.UserId
                                ORDER BY bt.IssueDate DESC";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptRecentTransactions.DataSource = dt;
                            rptRecentTransactions.DataBind();
                            lblNoTransactions.Visible = false;
                        }
                        else
                        {
                            rptRecentTransactions.DataSource = null;
                            rptRecentTransactions.DataBind();
                            lblNoTransactions.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading recent transactions: " + ex.Message);
            }
        }

        private void LoadOverdueBooks()
        {
            try
            {
                if (string.IsNullOrEmpty(connectionString))
                {
                    ShowErrorMessage("Database connection string is not configured.");
                    return;
                }

                string query = @"SELECT 
                                bt.TransactionId,
                                b.BookTitle,
                                s.FirstName + ' ' + s.LastName as StudentName,
                                bt.DueDate,
                                DATEDIFF(day, bt.DueDate, GETDATE()) as DaysOverdue,
                                (DATEDIFF(day, bt.DueDate, GETDATE()) * 5.00) as CalculatedFine
                                FROM BookTransactions bt
                                INNER JOIN Books b ON bt.BookId = b.BookId
                                INNER JOIN Students s ON bt.StudentId = s.StudentId
                                WHERE bt.Status = 'Issued' 
                                AND bt.DueDate < CAST(GETDATE() AS DATE)
                                ORDER BY bt.DueDate ASC";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptOverdueBooks.DataSource = dt;
                            rptOverdueBooks.DataBind();
                            pnlOverdueAlert.Visible = true;

                            // Update overdue status in database
                            UpdateOverdueStatus();
                        }
                        else
                        {
                            pnlOverdueAlert.Visible = false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading overdue books: " + ex.Message);
            }
        }

        private void UpdateOverdueStatus()
        {
            try
            {
                string updateQuery = @"UPDATE BookTransactions 
                                     SET Status = 'Overdue',
                                         FineAmount = DATEDIFF(day, DueDate, GETDATE()) * 5.00
                                     WHERE Status = 'Issued' 
                                     AND DueDate < CAST(GETDATE() AS DATE)";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error but don't show to user
                System.Diagnostics.Debug.WriteLine("Error updating overdue status: " + ex.Message);
            }
        }

        // Public method to be called from ASPX
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

        // Navigation Methods with proper naming convention
        protected void BtnAddBook_Click(object sender, EventArgs e)
        {
            Response.Redirect("Books.aspx");
        }

        protected void BtnBookTransaction_Click(object sender, EventArgs e)
        {
            Response.Redirect("BookTransaction.aspx");
        }

        protected void BtnManageBooks_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageBooks.aspx");
        }

        protected void LnkQuickIssue_Click(object sender, EventArgs e)
        {
            Response.Redirect("BookTransaction.aspx?action=issue");
        }

        protected void LnkQuickReturn_Click(object sender, EventArgs e)
        {
            Response.Redirect("BookTransaction.aspx?action=return");
        }

        protected void LnkViewReports_Click(object sender, EventArgs e)
        {
            Response.Redirect("LibraryReports.aspx");
        }

        protected void LnkManageCategories_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageCategories.aspx");
        }

        protected void LnkViewAllTransactions_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewTransactions.aspx");
        }
        protected void BtnLibrarySettings_Click(object sender, EventArgs e)
        {
          
            Response.Redirect("~/LibrarySettings.aspx");
        }

        private void ShowErrorMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                $"showNotification('{message.Replace("'", "\\'")}', 'error');", true);
        }

        private void ShowSuccessMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
                $"showNotification('{message.Replace("'", "\\'")}', 'success');", true);
        }
    }
}