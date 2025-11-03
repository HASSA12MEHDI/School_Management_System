using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace School_Managenment_System12._00
{
    public partial class Classes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                if (Session["UserId"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                // Set focus to first field
                txtClassName.Focus();
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf"";Integrated Security=True";

                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        string query = @"INSERT INTO Classes 
                                        (ClassName, Section, Capacity, AcademicYear, IsActive, CreatedDate) 
                                        VALUES 
                                        (@ClassName, @Section, @Capacity, @AcademicYear, @IsActive, GETDATE())";

                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue("@ClassName", txtClassName.Text.Trim());
                            cmd.Parameters.AddWithValue("@Section", txtSection.Text.Trim().ToUpper());
                            cmd.Parameters.AddWithValue("@Capacity", string.IsNullOrEmpty(txtCapacity.Text) ? (object)DBNull.Value : Convert.ToInt32(txtCapacity.Text));
                            cmd.Parameters.AddWithValue("@AcademicYear", string.IsNullOrEmpty(txtAcademicYear.Text) ? (object)DBNull.Value : txtAcademicYear.Text.Trim());
                            cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);

                            con.Open();
                            int result = cmd.ExecuteNonQuery();

                            if (result > 0)
                            {
                                ShowMessage("Class added successfully!", "success");
                                ClearForm();
                            }
                            else
                            {
                                ShowMessage("Error saving class. Please try again.", "error");
                            }
                        }
                    }
                }
                catch (SqlException sqlEx)
                {
                    if (sqlEx.Number == 2627) // Unique constraint violation
                    {
                        ShowMessage("Class with this name and section already exists!", "error");
                    }
                    else
                    {
                        ShowMessage("Database error: " + sqlEx.Message, "error");
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error: " + ex.Message, "error");
                }
            }
        }

        protected void BtnViewClasses_Click(object sender, EventArgs e)
        {
            Response.Redirect("Veiw_Classes.aspx");
        }

        protected void BtnBackDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = type == "success" ? "message success" : "message error";
            lblMessage.Visible = true;
        }

        private void ClearForm()
        {
            txtClassName.Text = "";
            txtSection.Text = "";
            txtCapacity.Text = "40";
            txtAcademicYear.Text = "2024-2025";
            chkIsActive.Checked = true;
            txtClassName.Focus();
        }
    }
}