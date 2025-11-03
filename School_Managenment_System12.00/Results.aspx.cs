using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Management_System
{
    public partial class Results : Page
    {
        private string GetConnectionString()
        {
            return System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFormData();
            }
        }

        private void LoadFormData()
        {
            LoadStudents();
            LoadExams();
            LoadSubjects();
        }

        private void LoadStudents()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(GetConnectionString()))
                {
                    string query = @"
                        SELECT 
                            s.StudentId,
                            s.RollNumber + ' - ' + s.FirstName + ' ' + s.LastName AS StudentName
                        FROM Students s
                        WHERE s.IsActive = 1 
                        ORDER BY s.FirstName, s.LastName";

                    SqlCommand cmd = new SqlCommand(query, con);
                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlStudent.DataSource = reader;
                    ddlStudent.DataTextField = "StudentName";
                    ddlStudent.DataValueField = "StudentId";
                    ddlStudent.DataBind();

                    ddlStudent.Items.Insert(0, new ListItem("Select Student", ""));
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading students: " + ex.Message, true);
            }
        }

        private void LoadExams()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(GetConnectionString()))
                {
                    string query = "SELECT ExamId, ExamName FROM Exams WHERE IsActive = 1 ORDER BY ExamName";
                    SqlCommand cmd = new SqlCommand(query, con);
                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlExam.DataSource = reader;
                    ddlExam.DataTextField = "ExamName";
                    ddlExam.DataValueField = "ExamId";
                    ddlExam.DataBind();

                    ddlExam.Items.Insert(0, new ListItem("Select Exam", ""));
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading exams: " + ex.Message, true);
            }
        }

        private void LoadSubjects()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(GetConnectionString()))
                {
                    string query = "SELECT SubjectId, SubjectName FROM Subjects WHERE IsActive = 1 ORDER BY SubjectName";
                    SqlCommand cmd = new SqlCommand(query, con);
                    con.Open();

                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlSubject.DataSource = reader;
                    ddlSubject.DataTextField = "SubjectName";
                    ddlSubject.DataValueField = "SubjectId";
                    ddlSubject.DataBind();

                    ddlSubject.Items.Insert(0, new ListItem("Select Subject", ""));
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading subjects: " + ex.Message, true);
            }
        }

        private void CalculateGradeAndRemarks()
        {
            if (!string.IsNullOrEmpty(txtMarks.Text) && decimal.TryParse(txtMarks.Text, out decimal marks))
            {
                if (marks >= 75)
                {
                    lblGrade.Text = "A";
                    lblRemarks.Text = "Excellent";
                }
                else if (marks >= 60)
                {
                    lblGrade.Text = "B";
                    lblRemarks.Text = "Good";
                }
                else if (marks >= 45)
                {
                    lblGrade.Text = "C";
                    lblRemarks.Text = "Average";
                }
                else if (marks >= 33)
                {
                    lblGrade.Text = "D";
                    lblRemarks.Text = "Pass";
                }
                else
                {
                    lblGrade.Text = "F";
                    lblRemarks.Text = "Fail";
                }
            }
            else
            {
                lblGrade.Text = "--";
                lblRemarks.Text = "--";
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid &&
                ddlStudent.SelectedIndex > 0 &&
                ddlExam.SelectedIndex > 0 &&
                ddlSubject.SelectedIndex > 0 &&
                !string.IsNullOrEmpty(txtMarks.Text))
            {
                try
                {
                    // Calculate grade first
                    CalculateGradeAndRemarks();

                    // Check if result already exists
                    if (CheckDuplicateResult())
                    {
                        ShowMessage("Result already exists for this student, exam, and subject combination!", true);
                        return;
                    }

                    using (SqlConnection con = new SqlConnection(GetConnectionString()))
                    {
                        string query = @"INSERT INTO Results (StudentId, ExamId, SubjectId, MarksObtained, Grade, Remarks, EnteredBy) 
                                       VALUES (@StudentId, @ExamId, @SubjectId, @MarksObtained, @Grade, @Remarks, @EnteredBy)";

                        SqlCommand cmd = new SqlCommand(query, con);
                        cmd.Parameters.AddWithValue("@StudentId", ddlStudent.SelectedValue);
                        cmd.Parameters.AddWithValue("@ExamId", ddlExam.SelectedValue);
                        cmd.Parameters.AddWithValue("@SubjectId", ddlSubject.SelectedValue);
                        cmd.Parameters.AddWithValue("@MarksObtained", decimal.Parse(txtMarks.Text));
                        cmd.Parameters.AddWithValue("@Grade", lblGrade.Text);
                        cmd.Parameters.AddWithValue("@Remarks", lblRemarks.Text);
                        cmd.Parameters.AddWithValue("@EnteredBy", GetCurrentUserId());

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowMessage("Result added successfully!", false);
                            ClearForm();
                        }
                        else
                        {
                            ShowMessage("Failed to add result. Please try again.", true);
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error saving result: " + ex.Message, true);
                }
            }
            else
            {
                ShowMessage("Please fill all fields correctly!", true);
            }
        }

        private bool CheckDuplicateResult()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(GetConnectionString()))
                {
                    string query = @"SELECT COUNT(*) FROM Results 
                                   WHERE StudentId = @StudentId 
                                   AND ExamId = @ExamId 
                                   AND SubjectId = @SubjectId";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@StudentId", ddlStudent.SelectedValue);
                    cmd.Parameters.AddWithValue("@ExamId", ddlExam.SelectedValue);
                    cmd.Parameters.AddWithValue("@SubjectId", ddlSubject.SelectedValue);

                    con.Open();
                    int count = (int)cmd.ExecuteScalar();
                    return count > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        private int GetCurrentUserId()
        {
            if (Session["UserId"] != null)
            {
                return Convert.ToInt32(Session["UserId"]);
            }
            return 1; // Default admin user
        }

        protected void BtnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            ShowMessage("Form cleared successfully!", false);
        }

        protected void BtnRefreshData_Click(object sender, EventArgs e)
        {
            LoadFormData();
            ShowMessage("Data refreshed successfully!", false);
        }

        private void ClearForm()
        {
            ddlStudent.SelectedIndex = 0;
            ddlExam.SelectedIndex = 0;
            ddlSubject.SelectedIndex = 0;
            txtMarks.Text = "";
            lblGrade.Text = "--";
            lblRemarks.Text = "--";
        }

        private void ShowMessage(string message, bool isError)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;

            if (isError)
            {
                pnlMessage.CssClass = "alert alert-error";
            }
            else
            {
                pnlMessage.CssClass = "alert alert-success";

                // Auto-hide success messages after 5 seconds
                ScriptManager.RegisterStartupScript(this, this.GetType(), "hideMessage",
                    "setTimeout(function() { $('.alert-success').fadeOut('slow'); }, 5000);", true);
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewResults.aspx");
        }
    }
}