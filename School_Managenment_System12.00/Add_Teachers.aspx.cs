using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class Add_Teacher : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GenerateEmployeeId();
                TxtJoiningDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                // Set focus without scrolling
                ScriptManager.RegisterStartupScript(this, this.GetType(), "FocusFirstName",
                    "document.getElementById('" + TxtFirstName.ClientID + "').focus({ preventScroll: true });", true);
            }
        }

        private string GetConnectionString()
        {
            try
            {
                if (ConfigurationManager.ConnectionStrings["SchoolDBConnectionString"] != null)
                {
                    return ConfigurationManager.ConnectionStrings["SchoolDBConnectionString"].ConnectionString;
                }
                return @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf;Integrated Security=True";
            }
            catch
            {
                return @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf;Integrated Security=True";
            }
        }

        private void GenerateEmployeeId()
        {
            try
            {
                string connectionString = GetConnectionString();
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT 'TCH-' + FORMAT(ISNULL(MAX(CAST(SUBSTRING(EmployeeId, 5, LEN(EmployeeId)) AS INT)), 0) + 1, '000') FROM Teachers";
                    SqlCommand cmd = new SqlCommand(query, con);
                    con.Open();
                    var result = cmd.ExecuteScalar();
                    string newEmployeeId = result != null ? result.ToString() : "TCH-001";
                    TxtEmployeeId.Text = newEmployeeId;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error generating employee ID: " + ex.Message);
                TxtEmployeeId.Text = "TCH-" + DateTime.Now.ToString("yyMMddHHmm");
                ShowMessage("New Employee ID generated: " + TxtEmployeeId.Text, "info");
            }
        }

        private string UploadProfilePicture()
        {
            try
            {
                if (FileProfilePic.HasFile)
                {
                    string fileName = Path.GetFileName(FileProfilePic.FileName);
                    string fileExtension = Path.GetExtension(fileName).ToLower();

                    // Validate file type
                    if (fileExtension == ".jpg" || fileExtension == ".jpeg" || fileExtension == ".png" || fileExtension == ".gif")
                    {
                        // Validate file size (2MB)
                        if (FileProfilePic.PostedFile.ContentLength <= 2097152)
                        {
                            // Create unique filename
                            string cleanEmployeeId = TxtEmployeeId.Text.Trim().Replace("-", "_");
                            string newFileName = "teacher_" + cleanEmployeeId + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + fileExtension;
                            string filePath = Server.MapPath("~/images/teachers/") + newFileName;

                            // Create directory if it doesn't exist
                            string directory = Server.MapPath("~/images/teachers/");
                            if (!Directory.Exists(directory))
                            {
                                Directory.CreateDirectory(directory);
                            }

                            // Save the file
                            FileProfilePic.SaveAs(filePath);

                            // Return relative path for database
                            return "images/teachers/" + newFileName;
                        }
                        else
                        {
                            ShowMessage("File size must be less than 2MB", "danger");
                            return "images/default-teacher.png";
                        }
                    }
                    else
                    {
                        ShowMessage("Only JPG, JPEG, PNG and GIF files are allowed", "danger");
                        return "images/default-teacher.png";
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error uploading file: " + ex.Message, "danger");
                return "images/default-teacher.png";
            }

            return "images/default-teacher.png";
        }

        private bool ValidateForm()
        {
            // Check First Name
            if (string.IsNullOrEmpty(TxtFirstName.Text.Trim()))
            {
                ShowMessage("Please enter first name", "danger");
                return false;
            }

            // Check Last Name
            if (string.IsNullOrEmpty(TxtLastName.Text.Trim()))
            {
                ShowMessage("Please enter last name", "danger");
                return false;
            }

            // Check Email
            if (string.IsNullOrEmpty(TxtEmail.Text.Trim()))
            {
                ShowMessage("Please enter email address", "danger");
                return false;
            }

            // Validate email format
            if (!System.Text.RegularExpressions.Regex.IsMatch(TxtEmail.Text.Trim(),
                @"^[^\s@]+@[^\s@]+\.[^\s@]+$"))
            {
                ShowMessage("Please enter a valid email address", "danger");
                return false;
            }

            // Check Phone
            if (string.IsNullOrEmpty(TxtPhone.Text.Trim()))
            {
                ShowMessage("Please enter phone number", "danger");
                return false;
            }

            // Validate phone format
            if (!System.Text.RegularExpressions.Regex.IsMatch(TxtPhone.Text.Trim(),
                @"^[\+]?[0-9\s\-\(\)]{10,}$"))
            {
                ShowMessage("Please enter a valid phone number", "danger");
                return false;
            }

            // Check Qualification
            if (string.IsNullOrEmpty(DdlQualification.SelectedValue))
            {
                ShowMessage("Please select qualification", "danger");
                return false;
            }

            // Check Experience
            if (string.IsNullOrEmpty(TxtExperience.Text))
            {
                ShowMessage("Please enter experience", "danger");
                return false;
            }

            if (!int.TryParse(TxtExperience.Text, out int experience) || experience < 0 || experience > 50)
            {
                ShowMessage("Please enter valid experience (0-50 years)", "danger");
                return false;
            }

            // Check Salary
            if (string.IsNullOrEmpty(TxtSalary.Text))
            {
                ShowMessage("Please enter salary", "danger");
                return false;
            }

            if (!decimal.TryParse(TxtSalary.Text, out decimal salary) || salary <= 0)
            {
                ShowMessage("Please enter valid salary (positive number)", "danger");
                return false;
            }

            // Check Joining Date
            if (string.IsNullOrEmpty(TxtJoiningDate.Text))
            {
                ShowMessage("Please select joining date", "danger");
                return false;
            }

            if (!DateTime.TryParse(TxtJoiningDate.Text, out DateTime joiningDate))
            {
                ShowMessage("Please enter valid joining date", "danger");
                return false;
            }

            // Check if joining date is not in future
            if (joiningDate > DateTime.Now)
            {
                ShowMessage("Joining date cannot be in the future", "danger");
                return false;
            }

            return true;
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (!ValidateForm())
                return;

            try
            {
                // Upload profile picture and get the path
                string profilePicPath = UploadProfilePicture();

                string connectionString = GetConnectionString();
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO Teachers 
                                    (EmployeeId, FirstName, LastName, Email, Phone, 
                                     Qualification, Experience, JoiningDate, Salary, 
                                     IsActive, profilepic) 
                                    VALUES 
                                    (@EmployeeId, @FirstName, @LastName, @Email, @Phone,
                                     @Qualification, @Experience, @JoiningDate, @Salary,
                                     @IsActive, @profilepic)";

                    SqlCommand cmd = new SqlCommand(query, con);

                    // Add parameters with proper data types
                    cmd.Parameters.AddWithValue("@EmployeeId", TxtEmployeeId.Text.Trim());
                    cmd.Parameters.AddWithValue("@FirstName", TxtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@LastName", TxtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", TxtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Phone", TxtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@Qualification", DdlQualification.SelectedValue);
                    cmd.Parameters.AddWithValue("@Experience", Convert.ToInt32(TxtExperience.Text));
                    cmd.Parameters.AddWithValue("@JoiningDate", Convert.ToDateTime(TxtJoiningDate.Text));
                    cmd.Parameters.AddWithValue("@Salary", Convert.ToDecimal(TxtSalary.Text));
                    cmd.Parameters.AddWithValue("@IsActive", ChkIsActive.Checked);
                    cmd.Parameters.AddWithValue("@profilepic", profilePicPath);

                    con.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowMessage("Teacher added successfully!", "success");

                        // Clear form after successful save
                        ClearForm();
                        GenerateEmployeeId();
                    }
                    else
                    {
                        ShowMessage("Failed to add teacher. Please try again.", "danger");
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 2627) // Unique constraint violation
                {
                    ShowMessage("Employee ID already exists. Please generate a new ID.", "danger");
                    GenerateEmployeeId();
                }
                else
                {
                    ShowMessage("Database error: " + sqlEx.Message, "danger");
                }
            }
            catch (FormatException)
            {
                ShowMessage("Please check the format of your input data (numbers and dates).", "danger");
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving teacher: " + ex.Message, "danger");
            }
            finally
            {
                // Hide loading overlay
                ScriptManager.RegisterStartupScript(this, this.GetType(), "HideLoading", "hideLoading();", true);
            }
        }

        protected void BtnSaveAndAdd_Click(object sender, EventArgs e)
        {
            BtnSave_Click(sender, e);
        }

        protected void BtnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            GenerateEmployeeId();
            ShowMessage("Form cleared successfully!", "info");
        }

        private void ClearForm()
        {
            TxtFirstName.Text = "";
            TxtLastName.Text = "";
            TxtEmail.Text = "";
            TxtPhone.Text = "";
            DdlQualification.SelectedIndex = 0;
            TxtExperience.Text = "0";
            TxtJoiningDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            TxtSalary.Text = "";
            ChkIsActive.Checked = true;

            // Reset image to default
            ImgProfile.ImageUrl = "~/images/default-teacher.png";
            ImgProfile.Attributes.Remove("data-preview");

            // Clear file upload
            FileProfilePic.Attributes.Clear();
        }

        protected void BtnGenerateId_Click(object sender, EventArgs e)
        {
            GenerateEmployeeId();
            ShowMessage("New Employee ID generated!", "info");
        }

        protected void BtnViewTeachers_Click(object sender, EventArgs e)
        {
            Response.Redirect("Teacher_Add.aspx");
        }

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
                case "warning":
                    LblMessage.CssClass = "alert alert-warning";
                    break;
                default:
                    LblMessage.CssClass = "alert alert-info";
                    break;
            }

            // Auto-hide message after 5 seconds
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideMessage",
                "setTimeout(function() { document.getElementById('" + LblMessage.ClientID + "').style.display = 'none'; }, 5000);", true);
        }
    }
}