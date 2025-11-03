using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Threading;

namespace School_Managenment_System12._00
{
    public partial class Books : System.Web.UI.Page
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
                LoadCategories();
                LoadBooks();
            }
        }

        private void LoadPageTitle()
        {
            if (Master != null)
            {
                Label lblPageTitle = (Label)Master.FindControl("lblPageTitle");
                if (lblPageTitle != null)
                {
                    lblPageTitle.Text = "Books Management";
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

                    // Total Books
                    string totalBooksQuery = "SELECT COUNT(*) FROM Books WHERE IsActive = 1";
                    using (SqlCommand totalBooksCmd = new SqlCommand(totalBooksQuery, conn))
                    {
                        lblTotalBooks.Text = totalBooksCmd.ExecuteScalar().ToString();
                    }

                    // Available Books
                    string availableBooksQuery = "SELECT ISNULL(SUM(AvailableCopies), 0) FROM Books WHERE IsActive = 1";
                    using (SqlCommand availableBooksCmd = new SqlCommand(availableBooksQuery, conn))
                    {
                        lblAvailableBooks.Text = availableBooksCmd.ExecuteScalar().ToString();
                    }

                    // Issued Books
                    string issuedBooksQuery = "SELECT ISNULL(SUM(TotalCopies - AvailableCopies), 0) FROM Books WHERE IsActive = 1";
                    using (SqlCommand issuedBooksCmd = new SqlCommand(issuedBooksQuery, conn))
                    {
                        lblIssuedBooks.Text = issuedBooksCmd.ExecuteScalar().ToString();
                    }

                    // Low Stock Books (AvailableCopies = 0)
                    string lowStockQuery = "SELECT COUNT(*) FROM Books WHERE IsActive = 1 AND AvailableCopies = 0";
                    using (SqlCommand lowStockCmd = new SqlCommand(lowStockQuery, conn))
                    {
                        lblLowStockBooks.Text = lowStockCmd.ExecuteScalar().ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading statistics: " + ex.Message);
            }
        }

        private void LoadCategories()
        {
            try
            {
                string query = "SELECT CategoryId, CategoryName FROM BookCategories WHERE IsActive = 1 ORDER BY CategoryName";

                using (SqlConnection conn = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlCategory.DataSource = dt;
                    ddlCategory.DataTextField = "CategoryName";
                    ddlCategory.DataValueField = "CategoryId";
                    ddlCategory.DataBind();
                    ddlCategory.Items.Insert(0, new ListItem("Select Category", ""));

                    ddlCategoryFilter.DataSource = dt;
                    ddlCategoryFilter.DataTextField = "CategoryName";
                    ddlCategoryFilter.DataValueField = "CategoryId";
                    ddlCategoryFilter.DataBind();
                    ddlCategoryFilter.Items.Insert(0, new ListItem("All Categories", ""));
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading categories: " + ex.Message);
            }
        }

        private void LoadBooks()
        {
            try
            {
                string query = @"SELECT b.BookId, b.BookTitle, b.Author, b.ISBN, b.Publisher, 
                                b.Edition, b.TotalCopies, b.AvailableCopies, b.ShelfNumber,
                                ISNULL(c.CategoryName, 'Uncategorized') as Category
                                FROM Books b
                                LEFT JOIN BookCategories c ON b.CategoryId = c.CategoryId
                                WHERE b.IsActive = 1";

                // Apply filters
                if (!string.IsNullOrEmpty(txtSearch.Text))
                {
                    query += " AND (b.BookTitle LIKE @Search OR b.Author LIKE @Search OR b.ISBN LIKE @Search)";
                }

                if (!string.IsNullOrEmpty(ddlCategoryFilter.SelectedValue))
                {
                    query += " AND b.CategoryId = @CategoryId";
                }

                if (!string.IsNullOrEmpty(ddlAvailabilityFilter.SelectedValue))
                {
                    switch (ddlAvailabilityFilter.SelectedValue)
                    {
                        case "Available":
                            query += " AND b.AvailableCopies > 0";
                            break;
                        case "Unavailable":
                            query += " AND b.AvailableCopies = 0";
                            break;
                        case "LowStock":
                            query += " AND b.AvailableCopies <= 2 AND b.AvailableCopies > 0";
                            break;
                    }
                }

                query += " ORDER BY b.BookTitle";

                using (SqlConnection conn = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (!string.IsNullOrEmpty(txtSearch.Text))
                    {
                        cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text + "%");
                    }

                    if (!string.IsNullOrEmpty(ddlCategoryFilter.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@CategoryId", ddlCategoryFilter.SelectedValue);
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

                        rptBooks.DataSource = pagedDt;
                        rptBooks.DataBind();
                        lblNoBooks.Visible = false;
                    }
                    else
                    {
                        rptBooks.DataSource = null;
                        rptBooks.DataBind();
                        lblNoBooks.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading books: " + ex.Message);
            }
        }

        // REMOVED btnAddBook_Click method - Now handled by client-side JavaScript

        protected void btnSaveBook_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate form
                if (!ValidateForm())
                    return;

                int bookId = int.Parse(hfBookId.Value);
                int totalCopies = int.Parse(txtTotalCopies.Text);
                int availableCopies = int.Parse(txtAvailableCopies.Text);

                if (availableCopies > totalCopies)
                {
                    ShowErrorMessage("Available copies cannot be greater than total copies");
                    ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal", "openAddModal();", true);
                    return;
                }

                if (bookId == 0)
                {
                    // Check if ISBN already exists
                    if (IsISBNExists(txtISBN.Text.Trim()))
                    {
                        ShowErrorMessage("A book with this ISBN already exists.");
                        ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal", "openAddModal();", true);
                        return;
                    }

                    // Add new book
                    if (InsertBook())
                    {
                        ShowSuccessMessage("Book added successfully!");
                        LoadBooks();
                        LoadStatistics();
                        ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", "closeModal();", true);
                    }
                }
                else
                {
                    // Update existing book
                    if (UpdateBook(bookId))
                    {
                        ShowSuccessMessage("Book updated successfully!");
                        LoadBooks();
                        LoadStatistics();
                        ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", "closeModal();", true);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error saving book: " + ex.Message);
                ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal", "openAddModal();", true);
            }
        }

        private bool ValidateForm()
        {
            // Clear previous validation
            ClearValidationErrors();

            bool isValid = true;

            if (string.IsNullOrWhiteSpace(txtBookTitle.Text))
            {
                ShowErrorMessage("Book title is required");
                isValid = false;
            }

            if (string.IsNullOrWhiteSpace(txtAuthor.Text))
            {
                ShowErrorMessage("Author is required");
                isValid = false;
            }

            if (string.IsNullOrWhiteSpace(txtISBN.Text))
            {
                ShowErrorMessage("ISBN is required");
                isValid = false;
            }

            if (string.IsNullOrWhiteSpace(ddlCategory.SelectedValue))
            {
                ShowErrorMessage("Category is required");
                isValid = false;
            }

            if (!int.TryParse(txtTotalCopies.Text, out int totalCopies) || totalCopies < 1)
            {
                ShowErrorMessage("Total copies must be a valid number greater than 0");
                isValid = false;
            }

            if (!int.TryParse(txtAvailableCopies.Text, out int availableCopies) || availableCopies < 0)
            {
                ShowErrorMessage("Available copies must be a valid number");
                isValid = false;
            }

            return isValid;
        }

        private void ClearValidationErrors()
        {
            // This method can be used to clear any validation error displays
        }

        private bool IsISBNExists(string isbn)
        {
            string query = "SELECT COUNT(*) FROM Books WHERE ISBN = @ISBN AND IsActive = 1";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@ISBN", isbn);
                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        private bool InsertBook()
        {
            string query = @"INSERT INTO Books (BookTitle, Author, ISBN, Publisher, Edition, CategoryId, 
                           TotalCopies, AvailableCopies, ShelfNumber, IsActive, AddedDate)
                           VALUES (@BookTitle, @Author, @ISBN, @Publisher, @Edition, @CategoryId,
                           @TotalCopies, @AvailableCopies, @ShelfNumber, 1, GETDATE())";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@BookTitle", txtBookTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@Author", txtAuthor.Text.Trim());
                cmd.Parameters.AddWithValue("@ISBN", txtISBN.Text.Trim());
                cmd.Parameters.AddWithValue("@Publisher", txtPublisher.Text.Trim());
                cmd.Parameters.AddWithValue("@Edition", txtEdition.Text.Trim());
                cmd.Parameters.AddWithValue("@CategoryId", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@TotalCopies", int.Parse(txtTotalCopies.Text));
                cmd.Parameters.AddWithValue("@AvailableCopies", int.Parse(txtAvailableCopies.Text));
                cmd.Parameters.AddWithValue("@ShelfNumber", txtShelfNumber.Text.Trim());

                conn.Open();
                int result = cmd.ExecuteNonQuery();
                return result > 0;
            }
        }

        private bool UpdateBook(int bookId)
        {
            string query = @"UPDATE Books SET 
                           BookTitle = @BookTitle,
                           Author = @Author,
                           ISBN = @ISBN,
                           Publisher = @Publisher,
                           Edition = @Edition,
                           CategoryId = @CategoryId,
                           TotalCopies = @TotalCopies,
                           AvailableCopies = @AvailableCopies,
                           ShelfNumber = @ShelfNumber
                           WHERE BookId = @BookId AND IsActive = 1";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@BookId", bookId);
                cmd.Parameters.AddWithValue("@BookTitle", txtBookTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@Author", txtAuthor.Text.Trim());
                cmd.Parameters.AddWithValue("@ISBN", txtISBN.Text.Trim());
                cmd.Parameters.AddWithValue("@Publisher", txtPublisher.Text.Trim());
                cmd.Parameters.AddWithValue("@Edition", txtEdition.Text.Trim());
                cmd.Parameters.AddWithValue("@CategoryId", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@TotalCopies", int.Parse(txtTotalCopies.Text));
                cmd.Parameters.AddWithValue("@AvailableCopies", int.Parse(txtAvailableCopies.Text));
                cmd.Parameters.AddWithValue("@ShelfNumber", txtShelfNumber.Text.Trim());

                conn.Open();
                int result = cmd.ExecuteNonQuery();
                return result > 0;
            }
        }

        protected void rptBooks_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                int bookId = Convert.ToInt32(e.CommandArgument);

                if (e.CommandName == "Edit")
                {
                    LoadBookForEdit(bookId);
                }
                else if (e.CommandName == "Delete")
                {
                    DeleteBook(bookId);
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error processing command: " + ex.Message);
            }
        }

        private void LoadBookForEdit(int bookId)
        {
            try
            {
                string query = "SELECT * FROM Books WHERE BookId = @BookId AND IsActive = 1";

                using (SqlConnection conn = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@BookId", bookId);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        DataRow row = dt.Rows[0];
                        hfBookId.Value = bookId.ToString();
                        txtBookTitle.Text = row["BookTitle"].ToString();
                        txtAuthor.Text = row["Author"].ToString();
                        txtISBN.Text = row["ISBN"].ToString();
                        txtPublisher.Text = row["Publisher"].ToString();
                        txtEdition.Text = row["Edition"].ToString();

                        if (row["CategoryId"] != DBNull.Value)
                        {
                            ddlCategory.SelectedValue = row["CategoryId"].ToString();
                        }

                        txtTotalCopies.Text = row["TotalCopies"].ToString();
                        txtAvailableCopies.Text = row["AvailableCopies"].ToString();
                        txtShelfNumber.Text = row["ShelfNumber"].ToString();

                        ScriptManager.RegisterStartupScript(this, GetType(), "OpenEditModal",
                            "document.getElementById('lblModalTitle').innerText = 'Edit Book'; openEditModal(" + bookId + ");", true);
                    }
                    else
                    {
                        ShowErrorMessage("Book not found!");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading book for edit: " + ex.Message);
            }
        }

        private void DeleteBook(int bookId)
        {
            try
            {
                // Soft delete - set IsActive to 0
                string query = "UPDATE Books SET IsActive = 0 WHERE BookId = @BookId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@BookId", bookId);
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        LoadBooks();
                        LoadStatistics();
                        ShowSuccessMessage("Book deleted successfully!");
                    }
                    else
                    {
                        ShowErrorMessage("Book not found or already deleted!");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error deleting book: " + ex.Message);
            }
        }

        // Filter and Search Methods
        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadBooks();
        }

        protected void ddlCategoryFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadBooks();
        }

        protected void ddlAvailabilityFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadBooks();
        }

        protected void btnClearFilters_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlCategoryFilter.SelectedIndex = 0;
            ddlAvailabilityFilter.SelectedIndex = 0;
            currentPage = 1;
            LoadBooks();
        }

        // Pagination Methods
        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (currentPage > 1)
            {
                currentPage--;
                LoadBooks();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            int totalPages;
            if (int.TryParse(lblTotalPages.Text, out totalPages))
            {
                if (currentPage < totalPages)
                {
                    currentPage++;
                    LoadBooks();
                }
            }
        }

        // Import and Export Methods
        protected void btnImportBooks_Click(object sender, EventArgs e)
        {
            try
            {
                ShowSuccessMessage("Import Books feature is under development. Currently, please use the 'Add New Book' feature.");
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error in import: " + ex.Message);
            }
        }

        protected void btnExportBooks_Click(object sender, EventArgs e)
        {
            try
            {
                // Export books to CSV
                string query = @"SELECT b.BookTitle, b.Author, b.ISBN, b.Publisher, b.Edition, 
                                c.CategoryName as Category, b.TotalCopies, b.AvailableCopies, b.ShelfNumber
                                FROM Books b
                                LEFT JOIN BookCategories c ON b.CategoryId = c.CategoryId
                                WHERE b.IsActive = 1 ORDER BY b.BookTitle";

                using (SqlConnection conn = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        // Create CSV content
                        string csv = "Book Title,Author,ISBN,Publisher,Edition,Category,Total Copies,Available Copies,Shelf Number\n";

                        foreach (DataRow row in dt.Rows)
                        {
                            csv += $"\"{row["BookTitle"]}\",\"{row["Author"]}\",\"{row["ISBN"]}\",\"{row["Publisher"]}\",\"{row["Edition"]}\",\"{row["Category"]}\",{row["TotalCopies"]},{row["AvailableCopies"]},\"{row["ShelfNumber"]}\"\n";
                        }

                        // Export as file
                        Response.Clear();
                        Response.Buffer = true;
                        Response.AddHeader("content-disposition", "attachment;filename=Books_Export_" + DateTime.Now.ToString("yyyyMMdd") + ".csv");
                        Response.Charset = "";
                        Response.ContentType = "application/text";
                        Response.Output.Write(csv);
                        Response.Flush();
                        Response.End();
                    }
                    else
                    {
                        ShowErrorMessage("No books available to export.");
                    }
                }
            }
            catch (ThreadAbortException)
            {
                // This exception is expected when calling Response.End()
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error exporting books: " + ex.Message);
            }
        }

        // Public methods for data binding
        public string GetAvailabilityClass(object availableCopies, object totalCopies)
        {
            if (availableCopies == DBNull.Value || totalCopies == DBNull.Value)
                return "unavailable";

            int available = Convert.ToInt32(availableCopies);
            int total = Convert.ToInt32(totalCopies);

            if (available == 0)
                return "unavailable";
            else if (available <= 2)
                return "low-stock";
            else
                return "available";
        }

        public string GetAvailabilityText(object availableCopies, object totalCopies)
        {
            if (availableCopies == DBNull.Value || totalCopies == DBNull.Value)
                return "Unavailable";

            int available = Convert.ToInt32(availableCopies);
            int total = Convert.ToInt32(totalCopies);

            if (available == 0)
                return "Unavailable";
            else if (available <= 2)
                return "Low Stock";
            else
                return "Available";
        }

        private void ShowSuccessMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
                $"showNotification('{message.Replace("'", "\\'")}', 'success');", true);
        }

        private void ShowErrorMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                $"showNotification('{message.Replace("'", "\\'")}', 'error');", true);
        }
    }
}