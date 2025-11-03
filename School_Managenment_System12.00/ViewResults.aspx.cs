using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Management_System
{
    public partial class ViewResults : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFilters();
                LoadResults();
                LoadStatistics();
            }
        }

        private void LoadFilters()
        {
            try
            {
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

                // Load Students
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT StudentId, FirstName + ' ' + LastName AS StudentName FROM Students WHERE IsActive = 1 ORDER BY FirstName, LastName";
                    SqlCommand cmd = new SqlCommand(query, con);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlFilterStudent.DataSource = reader;
                    ddlFilterStudent.DataTextField = "StudentName";
                    ddlFilterStudent.DataValueField = "StudentId";
                    ddlFilterStudent.DataBind();
                    ddlFilterStudent.Items.Insert(0, new ListItem("All Students", ""));
                }

                // Load Exams
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT ExamId, ExamName FROM Exams WHERE IsActive = 1 ORDER BY ExamName";
                    SqlCommand cmd = new SqlCommand(query, con);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlFilterExam.DataSource = reader;
                    ddlFilterExam.DataTextField = "ExamName";
                    ddlFilterExam.DataValueField = "ExamId";
                    ddlFilterExam.DataBind();
                    ddlFilterExam.Items.Insert(0, new ListItem("All Exams", ""));
                }

                // Load Subjects
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT SubjectId, SubjectName FROM Subjects WHERE IsActive = 1 ORDER BY SubjectName";
                    SqlCommand cmd = new SqlCommand(query, con);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlFilterSubject.DataSource = reader;
                    ddlFilterSubject.DataTextField = "SubjectName";
                    ddlFilterSubject.DataValueField = "SubjectId";
                    ddlFilterSubject.DataBind();
                    ddlFilterSubject.Items.Insert(0, new ListItem("All Subjects", ""));
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading filters: " + ex.Message, true);
            }
        }

        protected void BtnFilter_Click(object sender, EventArgs e)
        {
            LoadResults();
            LoadStatistics();
        }

        protected void BtnReset_Click(object sender, EventArgs e)
        {
            ddlFilterStudent.SelectedIndex = 0;
            ddlFilterExam.SelectedIndex = 0;
            ddlFilterSubject.SelectedIndex = 0;
            LoadResults();
            LoadStatistics();
        }

        protected void GvResults_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string grade = DataBinder.Eval(e.Row.DataItem, "Grade")?.ToString() ?? "";
                string gradeClass = "grade-" + System.Text.RegularExpressions.Regex.Replace(grade, @"[^A-Za-z0-9]", "");
                e.Row.CssClass = gradeClass;
            }
        }

        protected void GvResults_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteResult")
            {
                string resultId = e.CommandArgument.ToString();
                DeleteResult(resultId);
            }
            else if (e.CommandName == "EditResult")
            {
                string resultId = e.CommandArgument.ToString();
                Response.Redirect($"EditResult.aspx?id={resultId}");
            }
        }

        private void DeleteResult(string resultId)
        {
            try
            {
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "DELETE FROM Results WHERE ResultId = @ResultId";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@ResultId", resultId);

                    con.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowMessage("Result deleted successfully!", false);
                        LoadResults();
                        LoadStatistics();
                    }
                    else
                    {
                        ShowMessage("Failed to delete result.", true);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting result: " + ex.Message, true);
            }
        }

        private void LoadResults()
        {
            try
            {
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT r.ResultId, s.FirstName + ' ' + s.LastName as StudentName, 
                                    e.ExamName, sub.SubjectName, r.MarksObtained, r.Grade, r.Remarks, r.EnteredDate
                                    FROM Results r
                                    INNER JOIN Students s ON r.StudentId = s.StudentId
                                    INNER JOIN Exams e ON r.ExamId = e.ExamId
                                    INNER JOIN Subjects sub ON r.SubjectId = sub.SubjectId
                                    WHERE 1=1";

                    if (!string.IsNullOrEmpty(ddlFilterStudent.SelectedValue))
                        query += " AND r.StudentId = @StudentId";
                    if (!string.IsNullOrEmpty(ddlFilterExam.SelectedValue))
                        query += " AND r.ExamId = @ExamId";
                    if (!string.IsNullOrEmpty(ddlFilterSubject.SelectedValue))
                        query += " AND r.SubjectId = @SubjectId";

                    query += " ORDER BY r.EnteredDate DESC";

                    SqlCommand cmd = new SqlCommand(query, con);

                    if (!string.IsNullOrEmpty(ddlFilterStudent.SelectedValue))
                        cmd.Parameters.AddWithValue("@StudentId", ddlFilterStudent.SelectedValue);
                    if (!string.IsNullOrEmpty(ddlFilterExam.SelectedValue))
                        cmd.Parameters.AddWithValue("@ExamId", ddlFilterExam.SelectedValue);
                    if (!string.IsNullOrEmpty(ddlFilterSubject.SelectedValue))
                        cmd.Parameters.AddWithValue("@SubjectId", ddlFilterSubject.SelectedValue);

                    con.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    gvResults.DataSource = dt;
                    gvResults.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading results: " + ex.Message, true);
            }
        }

        private void LoadStatistics()
        {
            try
            {
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Total Results
                    string totalQuery = BuildQuery("SELECT COUNT(*) FROM Results");
                    SqlCommand totalCmd = new SqlCommand(totalQuery, con);
                    AddParameters(totalCmd);
                    int total = Convert.ToInt32(totalCmd.ExecuteScalar());
                    totalResults.InnerText = total.ToString();

                    // Average Marks
                    string avgQuery = BuildQuery("SELECT AVG(MarksObtained) FROM Results");
                    SqlCommand avgCmd = new SqlCommand(avgQuery, con);
                    AddParameters(avgCmd);
                    object avgResult = avgCmd.ExecuteScalar();
                    decimal avgMarksValue = avgResult != DBNull.Value ? Convert.ToDecimal(avgResult) : 0;
                    avgMarks.InnerText = avgMarksValue.ToString("0.00");

                    // Pass Rate
                    string passQuery = BuildQuery("SELECT COUNT(*) FROM Results") + " AND MarksObtained >= 50";
                    SqlCommand passCmd = new SqlCommand(passQuery, con);
                    AddParameters(passCmd);
                    int passCount = Convert.ToInt32(passCmd.ExecuteScalar());
                    decimal passRateValue = total > 0 ? (passCount * 100m / total) : 0;
                    passRate.InnerText = passRateValue.ToString("0") + "%";

                    // Most Common Grade
                    string gradeQuery = BuildQuery("SELECT TOP 1 Grade FROM Results") + " GROUP BY Grade ORDER BY COUNT(*) DESC";
                    SqlCommand gradeCmd = new SqlCommand(gradeQuery, con);
                    AddParameters(gradeCmd);
                    object gradeResult = gradeCmd.ExecuteScalar();
                    topGrade.InnerText = gradeResult?.ToString() ?? "N/A";
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading statistics: " + ex.Message, true);
            }
        }

        private string BuildQuery(string baseQuery)
        {
            string query = baseQuery + " WHERE 1=1";

            if (!string.IsNullOrEmpty(ddlFilterStudent.SelectedValue))
                query += " AND StudentId = @StudentId";
            if (!string.IsNullOrEmpty(ddlFilterExam.SelectedValue))
                query += " AND ExamId = @ExamId";
            if (!string.IsNullOrEmpty(ddlFilterSubject.SelectedValue))
                query += " AND SubjectId = @SubjectId";

            return query;
        }

        private void AddParameters(SqlCommand cmd)
        {
            if (!string.IsNullOrEmpty(ddlFilterStudent.SelectedValue))
                cmd.Parameters.AddWithValue("@StudentId", ddlFilterStudent.SelectedValue);
            if (!string.IsNullOrEmpty(ddlFilterExam.SelectedValue))
                cmd.Parameters.AddWithValue("@ExamId", ddlFilterExam.SelectedValue);
            if (!string.IsNullOrEmpty(ddlFilterSubject.SelectedValue))
                cmd.Parameters.AddWithValue("@SubjectId", ddlFilterSubject.SelectedValue);
        }

        protected void BtnExportPDF_Click(object sender, EventArgs e)
        {
            ShowMessage("PDF export feature coming soon!", false);
        }

        protected void BtnExportExcel_Click(object sender, EventArgs e)
        {
            ShowMessage("Excel export feature coming soon!", false);
        }

        private void ShowMessage(string message, bool isError)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;
            pnlMessage.CssClass = isError ? "error-message" : "success-message";
        }
    }
}