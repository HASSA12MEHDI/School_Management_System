using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class BookCategories : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

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
            }
        }

        private void LoadPageTitle()
        {
            if (Master != null)
            {
                Label lblPageTitle = (Label)Master.FindControl("lblPageTitle");
                if (lblPageTitle != null)
                {
                    lblPageTitle.Text = "Book Categories";
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

                    // Total Categories
                    string totalQuery = "SELECT COUNT(*) FROM BookCategories";
                    SqlCommand totalCmd = new SqlCommand(totalQuery, conn);
                    lblTotalCategories.Text = totalCmd.ExecuteScalar().ToString();

                    // Active Categories
                    string activeQuery = "SELECT COUNT(*) FROM BookCategories WHERE IsActive = 1";
                    SqlCommand activeCmd = new SqlCommand(activeQuery, conn);
                    lblActiveCategories.Text = activeCmd.ExecuteScalar().ToString();

                    // Inactive Categories
                    string inactiveQuery = "SELECT COUNT(*) FROM BookCategories WHERE IsActive = 0";
                    SqlCommand inactiveCmd = new SqlCommand(inactiveQuery, conn);
                    lblInactiveCategories.Text = inactiveCmd.ExecuteScalar().ToString();

                    // Total Books
                    string booksQuery = "SELECT COUNT(*) FROM Books WHERE IsActive = 1";
                    SqlCommand booksCmd = new SqlCommand(booksQuery, conn);
                    lblTotalBooks.Text = booksCmd.ExecuteScalar().ToString();
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
                string query = @"SELECT c.CategoryId, c.CategoryName, c.Description, c.IsActive, c.CreatedDate,
                                ISNULL(bc.TotalBooks, 0) as BookCount,
                                ISNULL(bc.AvailableBooks, 0) as AvailableBooks
                                FROM BookCategories c
                                LEFT JOIN (
                                    SELECT CategoryId, 
                                           COUNT(*) as TotalBooks,
                                           SUM(AvailableCopies) as AvailableBooks
                                    FROM Books 
                                    WHERE IsActive = 1
                                    GROUP BY CategoryId
                                ) bc ON c.CategoryId = bc.CategoryId
                                WHERE 1=1";

                // Apply filters
                if (!string.IsNullOrEmpty(txtSearch.Text))
                {
                    query += " AND (c.CategoryName LIKE @Search OR c.Description LIKE @Search)";
                }

                if (!string.IsNullOrEmpty(ddlStatusFilter.SelectedValue))
                {
                    if (ddlStatusFilter.SelectedValue == "Active")
                    {
                        query += " AND c.IsActive = 1";
                    }
                    else if (ddlStatusFilter.SelectedValue == "Inactive")
                    {
                        query += " AND c.IsActive = 0";
                    }
                }

                query += " ORDER BY c.CategoryName";

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

                        if (dt.Rows.Count > 0)
                        {
                            rptCategories.DataSource = dt;
                            rptCategories.DataBind();
                            lblNoCategories.Visible = false;
                        }
                        else
                        {
                            rptCategories.DataSource = null;
                            rptCategories.DataBind();
                            lblNoCategories.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading categories: " + ex.Message);
            }
        }

        protected void BtnAddCategory_Click(object sender, EventArgs e)
        {
            ClearForm();
            hfCategoryId.Value = "0";
            cbIsActive.Checked = true;
            ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal", "openModal();", true);
        }

        protected void BtnSaveCategory_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int categoryId = int.Parse(hfCategoryId.Value);
                string categoryName = txtCategoryName.Text.Trim();
                string description = txtDescription.Text.Trim();
                bool isActive = cbIsActive.Checked;

                // Check for duplicate category name (case insensitive)
                if (IsDuplicateCategoryName(categoryName, categoryId))
                {
                    ShowErrorMessage("A category with this name already exists. Please choose a different name.");
                    return;
                }

                if (categoryId == 0)
                {
                    // Add new category
                    InsertCategory(categoryName, description, isActive);
                }
                else
                {
                    // Update existing category
                    UpdateCategory(categoryId, categoryName, description, isActive);
                }

                LoadCategories();
                LoadStatistics();
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", "closeModal();", true);
                ShowSuccessMessage($"Category {(categoryId == 0 ? "added" : "updated")} successfully!");
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error saving category: " + ex.Message);
            }
        }

        private bool IsDuplicateCategoryName(string categoryName, int excludeCategoryId)
        {
            string query = "SELECT COUNT(*) FROM BookCategories WHERE LOWER(CategoryName) = LOWER(@CategoryName) AND CategoryId != @ExcludeCategoryId";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryName", categoryName);
                    cmd.Parameters.AddWithValue("@ExcludeCategoryId", excludeCategoryId);

                    conn.Open();
                    int count = (int)cmd.ExecuteScalar();
                    return count > 0;
                }
            }
        }

        private void InsertCategory(string categoryName, string description, bool isActive)
        {
            string query = @"INSERT INTO BookCategories (CategoryName, Description, IsActive, CreatedDate)
                           VALUES (@CategoryName, @Description, @IsActive, GETDATE())";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryName", categoryName);
                    cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? DBNull.Value : (object)description);
                    cmd.Parameters.AddWithValue("@IsActive", isActive);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateCategory(int categoryId, string categoryName, string description, bool isActive)
        {
            string query = @"UPDATE BookCategories SET 
                           CategoryName = @CategoryName,
                           Description = @Description,
                           IsActive = @IsActive
                           WHERE CategoryId = @CategoryId";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                    cmd.Parameters.AddWithValue("@CategoryName", categoryName);
                    cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? DBNull.Value : (object)description);
                    cmd.Parameters.AddWithValue("@IsActive", isActive);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void RptCategories_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int categoryId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Edit")
            {
                LoadCategoryForEdit(categoryId);
            }
            else if (e.CommandName == "Toggle")
            {
                ToggleCategoryStatus(categoryId);
            }
            else if (e.CommandName == "Delete")
            {
                DeleteCategory(categoryId);
            }
        }

        private void LoadCategoryForEdit(int categoryId)
        {
            try
            {
                string query = "SELECT * FROM BookCategories WHERE CategoryId = @CategoryId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            DataRow row = dt.Rows[0];
                            hfCategoryId.Value = categoryId.ToString();
                            txtCategoryName.Text = row["CategoryName"].ToString();
                            txtDescription.Text = row["Description"].ToString();
                            cbIsActive.Checked = Convert.ToBoolean(row["IsActive"]);

                            ScriptManager.RegisterStartupScript(this, GetType(), "OpenEditModal",
                                $"openEditModal({categoryId}, '{row["CategoryName"].ToString().Replace("'", "\\'")}', '{row["Description"].ToString().Replace("'", "\\'")}', {row["IsActive"]});", true);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading category for edit: " + ex.Message);
            }
        }

        private void ToggleCategoryStatus(int categoryId)
        {
            try
            {
                // Get current status
                string getStatusQuery = "SELECT IsActive FROM BookCategories WHERE CategoryId = @CategoryId";
                bool currentStatus = false;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(getStatusQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                        conn.Open();
                        currentStatus = (bool)cmd.ExecuteScalar();
                    }
                }

                // Toggle status
                string updateQuery = "UPDATE BookCategories SET IsActive = @NewStatus WHERE CategoryId = @CategoryId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                        cmd.Parameters.AddWithValue("@NewStatus", !currentStatus);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                LoadCategories();
                LoadStatistics();
                ShowSuccessMessage($"Category {(currentStatus ? "deactivated" : "activated")} successfully!");
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error toggling category status: " + ex.Message);
            }
        }

        private void DeleteCategory(int categoryId)
        {
            try
            {
                // Check if category has books
                string checkBooksQuery = "SELECT COUNT(*) FROM Books WHERE CategoryId = @CategoryId AND IsActive = 1";
                int bookCount = 0;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(checkBooksQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                        conn.Open();
                        bookCount = (int)cmd.ExecuteScalar();
                    }
                }

                if (bookCount > 0)
                {
                    ShowErrorMessage("Cannot delete category because it has books associated with it. Please reassign or delete the books first.");
                    return;
                }

                // Hard delete the category (since it has no books)
                string deleteQuery = "DELETE FROM BookCategories WHERE CategoryId = @CategoryId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(deleteQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                LoadCategories();
                LoadStatistics();
                ShowSuccessMessage("Category deleted successfully!");
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error deleting category: " + ex.Message);
            }
        }

        private void ClearForm()
        {
            txtCategoryName.Text = "";
            txtDescription.Text = "";
        }

        // Filter and Search Methods
        protected void TxtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadCategories();
        }

        protected void DdlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCategories();
        }

        protected void BtnClearFilters_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlStatusFilter.SelectedIndex = 0;
            LoadCategories();
        }

        protected void BtnRefresh_Click(object sender, EventArgs e)
        {
            LoadCategories();
            LoadStatistics();
            ShowSuccessMessage("Data refreshed successfully!");
        }

        // Other button click handlers
        protected void BtnExportCategories_Click(object sender, EventArgs e)
        {
            ShowErrorMessage("Export feature coming soon!");
        }

        private void ShowSuccessMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
                $"showServerSuccess('{message.Replace("'", "\\'")}');", true);
        }

        private void ShowErrorMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                $"showServerError('{message.Replace("'", "\\'")}');", true);
        }
    }
}