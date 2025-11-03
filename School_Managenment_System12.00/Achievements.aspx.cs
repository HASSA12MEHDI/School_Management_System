using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class Achievements : System.Web.UI.Page
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
                LoadAcademicYears();
                LoadAchievements();

                // Set default date
                txtAchievedDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            }
        }

        private void LoadPageTitle()
        {
            if (Master != null)
            {
                Label lblPageTitle = (Label)Master.FindControl("lblPageTitle");
                if (lblPageTitle != null)
                {
                    lblPageTitle.Text = "Achievements";
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

                    // Total Achievements
                    string totalQuery = "SELECT COUNT(*) FROM Achievements";
                    SqlCommand totalCmd = new SqlCommand(totalQuery, conn);
                    lblTotalAchievements.Text = totalCmd.ExecuteScalar().ToString();

                    // Current Year Achievements
                    string currentYearQuery = "SELECT COUNT(*) FROM Achievements WHERE AcademicYear = YEAR(GETDATE())";
                    SqlCommand currentYearCmd = new SqlCommand(currentYearQuery, conn);
                    lblCurrentYearAchievements.Text = currentYearCmd.ExecuteScalar().ToString();

                    // Recent Achievements (Last 30 days)
                    string recentQuery = "SELECT COUNT(*) FROM Achievements WHERE CreatedDate >= DATEADD(day, -30, GETDATE())";
                    SqlCommand recentCmd = new SqlCommand(recentQuery, conn);
                    lblRecentAchievements.Text = recentCmd.ExecuteScalar().ToString();
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading statistics: " + ex.Message);
            }
        }

        private void LoadAcademicYears()
        {
            try
            {
                // Generate academic years from current year to 10 years back
                int currentYear = DateTime.Now.Year;

                ddlAcademicYear.Items.Clear();
                ddlYearFilter.Items.Clear();

                for (int year = currentYear + 1; year >= currentYear - 10; year--)
                {
                    ddlAcademicYear.Items.Add(new ListItem(year.ToString(), year.ToString()));
                    ddlYearFilter.Items.Add(new ListItem(year.ToString(), year.ToString()));
                }

                // Set current year as default
                ddlAcademicYear.SelectedValue = currentYear.ToString();
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading academic years: " + ex.Message);
            }
        }

        private void LoadAchievements()
        {
            try
            {
                string query = @"SELECT AchievementId, Title, Description, AcademicYear, 
                                AchievedDate, CreatedDate
                                FROM Achievements
                                WHERE 1=1";

                // Apply filters
                if (!string.IsNullOrEmpty(txtSearch.Text))
                {
                    query += " AND (Title LIKE @Search OR Description LIKE @Search)";
                }

                if (!string.IsNullOrEmpty(ddlYearFilter.SelectedValue))
                {
                    query += " AND AcademicYear = @AcademicYear";
                }

                query += " ORDER BY AchievedDate DESC, CreatedDate DESC";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(txtSearch.Text))
                        {
                            cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text + "%");
                        }

                        if (!string.IsNullOrEmpty(ddlYearFilter.SelectedValue))
                        {
                            cmd.Parameters.AddWithValue("@AcademicYear", ddlYearFilter.SelectedValue);
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

                            rptAchievements.DataSource = pagedDt;
                            rptAchievements.DataBind();
                            lblNoAchievements.Visible = false;
                        }
                        else
                        {
                            rptAchievements.DataSource = null;
                            rptAchievements.DataBind();
                            lblNoAchievements.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading achievements: " + ex.Message);
            }
        }

        protected void btnSaveAchievement_Click(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsValid)
                {
                    ShowErrorMessage("Please fill all required fields correctly.");
                    return;
                }

                string title = txtTitle.Text.Trim();
                string description = txtDescription.Text.Trim();
                int academicYear = int.Parse(ddlAcademicYear.SelectedValue);
                DateTime achievedDate = DateTime.Parse(txtAchievedDate.Text);
                int achievementId = int.Parse(hfAchievementId.Value);

                if (achievementId == 0)
                {
                    // Insert new achievement
                    string insertQuery = @"INSERT INTO Achievements (Title, Description, AcademicYear, AchievedDate)
                                         VALUES (@Title, @Description, @AcademicYear, @AchievedDate)";

                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@Title", title);
                            cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description);
                            cmd.Parameters.AddWithValue("@AcademicYear", academicYear);
                            cmd.Parameters.AddWithValue("@AchievedDate", achievedDate);

                            conn.Open();
                            int result = cmd.ExecuteNonQuery();

                            if (result > 0)
                            {
                                LoadAchievements();
                                LoadStatistics();
                                LoadAcademicYears(); // Refresh year filters if needed

                                // Close modal and show success message
                                ScriptManager.RegisterStartupScript(this, GetType(), "CloseAchievementModal", "closeAchievementModal();", true);
                                ShowSuccessMessage("Achievement added successfully!");
                            }
                            else
                            {
                                ShowErrorMessage("Failed to add achievement. Please try again.");
                            }
                        }
                    }
                }
                else
                {
                    // Update existing achievement
                    string updateQuery = @"UPDATE Achievements 
                                         SET Title = @Title, 
                                             Description = @Description,
                                             AcademicYear = @AcademicYear,
                                             AchievedDate = @AchievedDate
                                         WHERE AchievementId = @AchievementId";

                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@Title", title);
                            cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description);
                            cmd.Parameters.AddWithValue("@AcademicYear", academicYear);
                            cmd.Parameters.AddWithValue("@AchievedDate", achievedDate);
                            cmd.Parameters.AddWithValue("@AchievementId", achievementId);

                            conn.Open();
                            int result = cmd.ExecuteNonQuery();

                            if (result > 0)
                            {
                                LoadAchievements();
                                LoadStatistics();

                                // Close modal and show success message
                                ScriptManager.RegisterStartupScript(this, GetType(), "CloseAchievementModal", "closeAchievementModal();", true);
                                ShowSuccessMessage("Achievement updated successfully!");
                            }
                            else
                            {
                                ShowErrorMessage("Failed to update achievement. Please try again.");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error saving achievement: " + ex.Message);
            }
        }

        protected void rptAchievements_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                int achievementId = Convert.ToInt32(e.CommandArgument);

                if (e.CommandName == "Edit")
                {
                    LoadAchievementForEdit(achievementId);
                }
                else if (e.CommandName == "Delete")
                {
                    DeleteAchievement(achievementId);
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error processing command: " + ex.Message);
            }
        }

        private void LoadAchievementForEdit(int achievementId)
        {
            try
            {
                string query = @"SELECT AchievementId, Title, Description, AcademicYear, AchievedDate
                                FROM Achievements
                                WHERE AchievementId = @AchievementId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AchievementId", achievementId);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            string title = reader["Title"].ToString();
                            string description = reader["Description"] == DBNull.Value ? "" : reader["Description"].ToString();
                            string academicYear = reader["AcademicYear"].ToString();
                            DateTime achievedDate = Convert.ToDateTime(reader["AchievedDate"]);

                            // Register script to open edit modal with data
                            string script = $@"openEditModal({achievementId}, '{title.Replace("'", "\\'")}', '{description.Replace("'", "\\'")}', '{academicYear}', '{achievedDate:yyyy-MM-dd}');";
                            ScriptManager.RegisterStartupScript(this, GetType(), "OpenEditModal", script, true);
                        }
                        else
                        {
                            ShowErrorMessage("Achievement not found.");
                        }
                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading achievement for edit: " + ex.Message);
            }
        }

        private void DeleteAchievement(int achievementId)
        {
            try
            {
                string query = "DELETE FROM Achievements WHERE AchievementId = @AchievementId";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AchievementId", achievementId);
                        conn.Open();
                        int result = cmd.ExecuteNonQuery();

                        if (result > 0)
                        {
                            LoadAchievements();
                            LoadStatistics();
                            ShowSuccessMessage("Achievement deleted successfully!");
                        }
                        else
                        {
                            ShowErrorMessage("Failed to delete achievement. Please try again.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error deleting achievement: " + ex.Message);
            }
        }

        // COMPLETELY REWRITTEN Report Generation Method
        protected void btnGenerateReport_Click(object sender, EventArgs e)
        {
            try
            {
                // Disable page caching to ensure fresh download
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Cache.SetExpires(DateTime.Now.AddSeconds(-1));
                Response.Cache.SetNoStore();

                // Apply the same filters as in the main view
                string query = @"SELECT AchievementId, Title, Description, AcademicYear, 
                                AchievedDate, CreatedDate
                                FROM Achievements
                                WHERE 1=1";

                // Apply filters
                if (!string.IsNullOrEmpty(txtSearch.Text))
                {
                    query += " AND (Title LIKE @Search OR Description LIKE @Search)";
                }

                if (!string.IsNullOrEmpty(ddlYearFilter.SelectedValue))
                {
                    query += " AND AcademicYear = @AcademicYear";
                }

                query += " ORDER BY AchievedDate DESC, CreatedDate DESC";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(txtSearch.Text))
                        {
                            cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text + "%");
                        }

                        if (!string.IsNullOrEmpty(ddlYearFilter.SelectedValue))
                        {
                            cmd.Parameters.AddWithValue("@AcademicYear", ddlYearFilter.SelectedValue);
                        }

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count == 0)
                        {
                            ShowErrorMessage("No data found to generate report.");
                            return;
                        }

                        // Generate CSV report
                        string csv = GenerateCsvFromDataTable(dt);

                        // Create a unique filename with timestamp
                        string fileName = "Achievements_Report_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".csv";

                        // Clear the response completely
                        Response.Clear();
                        Response.ClearHeaders();
                        Response.ClearContent();

                        // Set the content type and headers for CSV download
                        Response.ContentType = "application/csv";
                        Response.AddHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
                        Response.AddHeader("Content-Length", csv.Length.ToString());
                        Response.AddHeader("Pragma", "public");
                        Response.AddHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
                        Response.AddHeader("Expires", "0");

                        // Write the CSV content directly to response
                        Response.Write(csv);

                        // IMPORTANT: Use Response.End() to trigger the download immediately
                        // This is necessary for file downloads to work properly
                        try
                        {
                            Response.End();
                        }
                        catch (ThreadAbortException)
                        {
                            // This is expected when using Response.End()
                            // Don't do anything here
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Only show error message if response hasn't been started
                if (!Response.IsRequestBeingRedirected)
                {
                    ShowErrorMessage("Error generating report: " + ex.Message);
                }
            }
        }

        private string GenerateCsvFromDataTable(DataTable dt)
        {
            StringBuilder sb = new StringBuilder();

            // Add headers with proper formatting
            // Create a list of columns to include (exclude AchievementId)
            var columnsToInclude = new List<string>();
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                if (dt.Columns[i].ColumnName != "AchievementId")
                {
                    columnsToInclude.Add(dt.Columns[i].ColumnName);
                }
            }

            // Write headers
            for (int i = 0; i < columnsToInclude.Count; i++)
            {
                sb.Append(EscapeCsvField(columnsToInclude[i]));
                if (i < columnsToInclude.Count - 1)
                    sb.Append(",");
            }
            sb.AppendLine();

            // Write rows
            foreach (DataRow row in dt.Rows)
            {
                for (int i = 0; i < columnsToInclude.Count; i++)
                {
                    string columnName = columnsToInclude[i];
                    string value = row[columnName] == DBNull.Value ? "" : row[columnName].ToString();

                    // Format dates properly
                    if (dt.Columns[columnName].DataType == typeof(DateTime))
                    {
                        DateTime dateValue = Convert.ToDateTime(row[columnName]);
                        value = dateValue.ToString("yyyy-MM-dd");
                    }

                    sb.Append(EscapeCsvField(value));
                    if (i < columnsToInclude.Count - 1)
                        sb.Append(",");
                }
                sb.AppendLine();
            }

            return sb.ToString();
        }

        private string EscapeCsvField(string field)
        {
            if (string.IsNullOrEmpty(field))
                return "";

            // If field contains comma, quote, or newline, escape it
            if (field.Contains(",") || field.Contains("\"") || field.Contains("\r") || field.Contains("\n"))
            {
                field = field.Replace("\"", "\"\"");
                return $"\"{field}\"";
            }

            return field;
        }

        // Filter and Search Methods
        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadAchievements();
        }

        protected void ddlYearFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadAchievements();
        }

        protected void btnClearFilters_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlYearFilter.SelectedIndex = 0;
            currentPage = 1;
            LoadAchievements();
        }

        // Pagination Methods
        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (currentPage > 1)
            {
                currentPage--;
                LoadAchievements();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            int totalPages = int.Parse(lblTotalPages.Text);
            if (currentPage < totalPages)
            {
                currentPage++;
                LoadAchievements();
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
    }
}