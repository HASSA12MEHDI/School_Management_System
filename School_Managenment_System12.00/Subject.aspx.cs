using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class Subjects : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
        private int subjectId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadClasses();
                LoadSubjectsGrid();

                if (Request.QueryString["SubjectId"] != null)
                {
                    subjectId = Convert.ToInt32(Request.QueryString["SubjectId"]);
                    LoadSubjectData(subjectId);
                    BtnSave.Visible = false;
                    BtnUpdate.Visible = true;
                    BtnCancel.Visible = true;
                }
            }
        }

        // Load Classes in Dropdown
        private void LoadClasses()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT ClassID, ClassName FROM Classes WHERE IsActive = 1 ORDER BY ClassName";
                    SqlDataAdapter da = new SqlDataAdapter(query, con);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    DdlClass.DataSource = dt;
                    DdlClass.DataTextField = "ClassName";
                    DdlClass.DataValueField = "ClassID";
                    DdlClass.DataBind();
                    DdlClass.Items.Insert(0, new ListItem("Select Class", ""));
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading classes: " + ex.Message, "danger");
            }
        }

        // Load Subjects GridView
        private void LoadSubjectsGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT s.SubjectId, s.SubjectName, s.SubjectCode, s.Description, 
                                   c.ClassName, s.IsActive
                                   FROM Subjects s
                                   INNER JOIN Classes c ON s.ClassId = c.ClassID
                                   ORDER BY s.SubjectName";

                    SqlDataAdapter da = new SqlDataAdapter(query, con);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    GvSubjects.DataSource = dt;
                    GvSubjects.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading subjects: " + ex.Message, "danger");
            }
        }

        // Save Subject
        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        string query = @"INSERT INTO Subjects 
                                        (SubjectName, SubjectCode, Description, ClassId, IsActive) 
                                        VALUES 
                                        (@SubjectName, @SubjectCode, @Description, @ClassId, @IsActive)";

                        SqlCommand cmd = new SqlCommand(query, con);

                        cmd.Parameters.AddWithValue("@SubjectName", TxtSubjectName.Text.Trim());
                        cmd.Parameters.AddWithValue("@SubjectCode", TxtSubjectCode.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", TxtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@ClassId", Convert.ToInt32(DdlClass.SelectedValue));
                        cmd.Parameters.AddWithValue("@IsActive", ChkIsActive.Checked);

                        con.Open();
                        cmd.ExecuteNonQuery();

                        ShowMessage("Subject added successfully!", "success");
                        ClearForm();
                        LoadSubjectsGrid();
                    }
                }
                catch (SqlException ex)
                {
                    if (ex.Number == 2627) // Unique constraint violation
                    {
                        ShowMessage("Subject code already exists. Please use a different code.", "danger");
                    }
                    else
                    {
                        ShowMessage("Error saving subject: " + ex.Message, "danger");
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error saving subject: " + ex.Message, "danger");
                }
            }
        }

        // Update Subject
        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            if (Page.IsValid && subjectId > 0)
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        string query = @"UPDATE Subjects SET 
                                        SubjectName = @SubjectName,
                                        SubjectCode = @SubjectCode,
                                        Description = @Description,
                                        ClassId = @ClassId,
                                        IsActive = @IsActive
                                        WHERE SubjectId = @SubjectId";

                        SqlCommand cmd = new SqlCommand(query, con);

                        cmd.Parameters.AddWithValue("@SubjectId", subjectId);
                        cmd.Parameters.AddWithValue("@SubjectName", TxtSubjectName.Text.Trim());
                        cmd.Parameters.AddWithValue("@SubjectCode", TxtSubjectCode.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", TxtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@ClassId", Convert.ToInt32(DdlClass.SelectedValue));
                        cmd.Parameters.AddWithValue("@IsActive", ChkIsActive.Checked);

                        con.Open();
                        cmd.ExecuteNonQuery();

                        ShowMessage("Subject updated successfully!", "success");
                        ClearForm();
                        LoadSubjectsGrid();
                        Response.Redirect("Subjects.aspx");
                    }
                }
                catch (SqlException ex)
                {
                    if (ex.Number == 2627)
                    {
                        ShowMessage("Subject code already exists. Please use a different code.", "danger");
                    }
                    else
                    {
                        ShowMessage("Error updating subject: " + ex.Message, "danger");
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error updating subject: " + ex.Message, "danger");
                }
            }
        }

        // Load Subject Data for Editing
        private void LoadSubjectData(int subjectId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM Subjects WHERE SubjectId = @SubjectId";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@SubjectId", subjectId);

                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        TxtSubjectName.Text = reader["SubjectName"].ToString();
                        TxtSubjectCode.Text = reader["SubjectCode"].ToString();
                        TxtDescription.Text = reader["Description"].ToString();
                        DdlClass.SelectedValue = reader["ClassId"].ToString();
                        ChkIsActive.Checked = Convert.ToBoolean(reader["IsActive"]);
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading subject data: " + ex.Message, "danger");
            }
        }

        // GridView Edit
        protected void GvSubjects_RowEditing(object sender, GridViewEditEventArgs e)
        {
            int subjectId = Convert.ToInt32(GvSubjects.DataKeys[e.NewEditIndex].Value);
            Response.Redirect("Subjects.aspx?SubjectId=" + subjectId);
        }

        // GridView Delete
        protected void GvSubjects_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int subjectId = Convert.ToInt32(GvSubjects.DataKeys[e.RowIndex].Value);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "DELETE FROM Subjects WHERE SubjectId = @SubjectId";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@SubjectId", subjectId);

                    con.Open();
                    cmd.ExecuteNonQuery();

                    ShowMessage("Subject deleted successfully!", "success");
                    LoadSubjectsGrid();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting subject: " + ex.Message, "danger");
            }
        }

        // GridView Row Data Bound
        protected void GvSubjects_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Add confirmation for delete
                Button btnDelete = (Button)e.Row.FindControl("BtnDelete");
                if (btnDelete != null)
                {
                    btnDelete.OnClientClick = "return confirm('Are you sure you want to delete this subject?');";
                }
            }
        }

        // Clear Form
        protected void BtnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            TxtSubjectName.Text = "";
            TxtSubjectCode.Text = "";
            TxtDescription.Text = "";
            DdlClass.SelectedIndex = 0;
            ChkIsActive.Checked = true;

            BtnSave.Visible = true;
            BtnUpdate.Visible = false;
            BtnCancel.Visible = false;

            subjectId = 0;
        }

        // Other Button Handlers
        protected void BtnAddNew_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void BtnViewAll_Click(object sender, EventArgs e)
        {
            LoadSubjectsGrid();
        }

        protected void BtnExport_Click(object sender, EventArgs e)
        {
            ShowMessage("Export feature coming soon!", "info");
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Subjects.aspx");
        }

        // Show Message
        private void ShowMessage(string message, string type)
        {
            LblMessage.Text = message;
            LblMessage.Visible = true;

            switch (type.ToLower())
            {
                case "success":
                    LblMessage.CssClass = "alert alert-success";
                    break;
                case "danger":
                    LblMessage.CssClass = "alert alert-danger";
                    break;
                case "info":
                    LblMessage.CssClass = "alert alert-info";
                    break;
                default:
                    LblMessage.CssClass = "alert alert-info";
                    break;
            }
        }
    }
}