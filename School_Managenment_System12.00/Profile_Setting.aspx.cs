using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class Profile_Setting : System.Web.UI.Page
    {
        private readonly string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf"";Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadUserProfile();
                // Hide edit mode by default
                editMode.Style["display"] = "none";
            }
        }

        private void LoadUserProfile()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT UserId, Username, Email, Role, FirstName, LastName, Phone, 
                           ProfilePicture, IsActive, CreatedDate, LastLogin 
                    FROM Users 
                    WHERE UserId = @UserId";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserId", userId);
                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Display user information
                            lblUserId.Text = reader["UserId"].ToString();
                            lblUsername.Text = reader["Username"].ToString();
                            lblEmail.Text = reader["Email"].ToString();
                            lblRole.Text = reader["Role"].ToString();
                            lblFirstName.Text = reader["FirstName"].ToString();
                            lblLastName.Text = reader["LastName"].ToString();

                            // Handle phone number (can be null)
                            if (reader["Phone"] != DBNull.Value)
                            {
                                lblPhone.Text = reader["Phone"].ToString();
                            }

                            // Handle profile picture
                            if (reader["ProfilePicture"] != DBNull.Value && !string.IsNullOrEmpty(reader["ProfilePicture"].ToString()))
                            {
                                imgProfile.ImageUrl = reader["ProfilePicture"].ToString();
                            }

                            // Account status
                            bool isActive = Convert.ToBoolean(reader["IsActive"]);
                            lblStatus.Text = isActive ? "Active" : "Inactive";
                            lblStatus.Style["color"] = isActive ? "green" : "red";

                            // Dates
                            DateTime createdDate = Convert.ToDateTime(reader["CreatedDate"]);
                            lblCreatedDate.Text = createdDate.ToString("MMMM dd, yyyy");

                            if (reader["LastLogin"] != DBNull.Value)
                            {
                                DateTime lastLogin = Convert.ToDateTime(reader["LastLogin"]);
                                lblLastLogin.Text = lastLogin.ToString("MMMM dd, yyyy hh:mm tt");
                            }

                            // Set values for edit mode
                            txtFirstName.Text = reader["FirstName"].ToString();
                            txtLastName.Text = reader["LastName"].ToString();
                            txtEmail.Text = reader["Email"].ToString();
                            if (reader["Phone"] != DBNull.Value)
                            {
                                txtPhone.Text = reader["Phone"].ToString();
                            }
                        }
                        else
                        {
                            ShowMessage("User not found!", "error");
                        }
                    }
                }
            }
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            // Show edit mode, hide view mode
            editMode.Style["display"] = "block";
          
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                ShowMessage("Please fix validation errors.", "error");
                return;
            }

            try
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                string firstName = txtFirstName.Text.Trim();
                string lastName = txtLastName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string phone = txtPhone.Text.Trim();
                string newPassword = txtNewPassword.Text.Trim();

                // Check if email already exists (excluding current user)
                if (IsEmailExists(email, userId))
                {
                    ShowMessage("Email already exists. Please use a different email.", "error");
                    return;
                }

                // Handle profile picture upload
                string profilePicturePath = HandleProfilePictureUpload();

                // Update user information
                if (UpdateUserProfile(userId, firstName, lastName, email, phone, profilePicturePath, newPassword))
                {
                    // Update session information
                    Session["FirstName"] = firstName;
                    Session["LastName"] = lastName;
                    Session["Email"] = email;

                    ShowMessage("Profile updated successfully!", "success");

                    // Reload profile data
                    LoadUserProfile();

                    // Switch back to view mode
                    editMode.Style["display"] = "none";
                
                }
                else
                {
                    ShowMessage("Failed to update profile. Please try again.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("An error occurred: " + ex.Message, "error");
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // Reload original data and switch to view mode
            LoadUserProfile();
            editMode.Style["display"] = "none";
            lblMessage.Visible = false;
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            // Redirect to dashboard based on user role
            string role = Session["Role"]?.ToString();
            switch (role?.ToLower())
            {
                case "admin":
                    Response.Redirect("AdminDashboard.aspx");
                    break;
                case "teacher":
                    Response.Redirect("TeacherDashboard.aspx");
                    break;
                case "student":
                    Response.Redirect("StudentDashboard.aspx");
                    break;
                case "parent":
                    Response.Redirect("ParentDashboard.aspx");
                    break;
                default:
                    Response.Redirect("Dashboard.aspx");
                    break;
            }
        }

        private bool IsEmailExists(string email, int currentUserId)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email AND UserId != @UserId";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Email", email);
                    command.Parameters.AddWithValue("@UserId", currentUserId);
                    connection.Open();

                    int count = Convert.ToInt32(command.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        private string HandleProfilePictureUpload()
        {
            if (fileProfile.HasFile)
            {
                try
                {
                    // Validate file size (max 2MB)
                    if (fileProfile.PostedFile.ContentLength > 2 * 1024 * 1024)
                    {
                        ShowMessage("Profile picture must be less than 2MB.", "error");
                        return null;
                    }

                    // Validate file type
                    string fileExtension = Path.GetExtension(fileProfile.FileName).ToLower();
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };

                    bool isValidExtension = false;
                    foreach (string ext in allowedExtensions)
                    {
                        if (fileExtension == ext)
                        {
                            isValidExtension = true;
                            break;
                        }
                    }

                    if (!isValidExtension)
                    {
                        ShowMessage("Please select a valid image file (JPG, PNG, GIF).", "error");
                        return null;
                    }

                    // Create uploads directory if it doesn't exist
                    string uploadsDir = Server.MapPath("~/Uploads/ProfilePictures/");
                    if (!Directory.Exists(uploadsDir))
                    {
                        Directory.CreateDirectory(uploadsDir);
                    }

                    // Generate unique filename
                    string fileName = Guid.NewGuid().ToString() + fileExtension;
                    string fullPath = Path.Combine(uploadsDir, fileName);

                    // Save the file
                    fileProfile.SaveAs(fullPath);

                    // Return relative path for database storage
                    return "~/Uploads/ProfilePictures/" + fileName;
                }
                catch (Exception ex)
                {
                    ShowMessage("Error uploading profile picture: " + ex.Message, "error");
                    return null;
                }
            }

            return null; // No new file uploaded
        }

        private bool UpdateUserProfile(int userId, string firstName, string lastName, string email,
                                     string phone, string profilePicturePath, string newPassword)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                    UPDATE Users 
                    SET FirstName = @FirstName,
                        LastName = @LastName,
                        Email = @Email,
                        Phone = @Phone,
                        ProfilePicture = COALESCE(@ProfilePicture, ProfilePicture)";

                // Add password update if provided
                if (!string.IsNullOrEmpty(newPassword))
                {
                    query += ", PasswordHash = @PasswordHash";
                }

                query += " WHERE UserId = @UserId";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@FirstName", firstName);
                    command.Parameters.AddWithValue("@LastName", lastName);
                    command.Parameters.AddWithValue("@Email", email);
                    command.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(phone) ? (object)DBNull.Value : phone);
                    command.Parameters.AddWithValue("@ProfilePicture", string.IsNullOrEmpty(profilePicturePath) ? (object)DBNull.Value : profilePicturePath);
                    command.Parameters.AddWithValue("@UserId", userId);

                    if (!string.IsNullOrEmpty(newPassword))
                    {
                        // In production, hash the password properly
                        command.Parameters.AddWithValue("@PasswordHash", newPassword);
                    }

                    connection.Open();
                    int rowsAffected = command.ExecuteNonQuery();
                    return rowsAffected > 0;
                }
            }
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;

            // Remove existing classes
            lblMessage.CssClass = lblMessage.CssClass
                .Replace("success", "")
                .Replace("error", "");

            // Add appropriate class
            lblMessage.CssClass += " " + type;

            // Auto-hide message after 5 seconds
            ScriptManager.RegisterStartupScript(this, this.GetType(), "hideMessage",
                "setTimeout(function() { document.getElementById('" + lblMessage.ClientID + "').style.display = 'none'; }, 5000);", true);
        }
    }
}