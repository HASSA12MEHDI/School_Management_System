using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class New_User : System.Web.UI.Page
    {
        private readonly string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf"";Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set focus to username field on page load
                txtUsername.Focus();

                // Check if user is already logged in, redirect to appropriate page
                if (Session["IsAuthenticated"] != null && (bool)Session["IsAuthenticated"])
                {
                    Response.Redirect("Dashboard.aspx");
                }
            }
        }

        protected void BtnRegister_Click(object sender, EventArgs e)
        {
            // Validate page first
            if (!Page.IsValid)
            {
                ShowMessage("Please fix the validation errors before submitting.", "danger");
                return;
            }

            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string role = ddlRole.SelectedValue;

            try
            {
                // Check if username already exists
                if (IsUsernameExists(username))
                {
                    ShowMessage("Username already exists. Please choose a different username.", "danger");
                    txtUsername.Focus();
                    return;
                }

                // Check if email already exists
                if (IsEmailExists(email))
                {
                    ShowMessage("Email address is already registered. Please use a different email or try logging in.", "danger");
                    txtEmail.Focus();
                    return;
                }

                // Validate password strength
                if (!IsPasswordStrong(password))
                {
                    ShowMessage("Password must be at least 6 characters long.", "danger");
                    txtPassword.Focus();
                    return;
                }

                // Handle profile picture upload
                string profilePicturePath = HandleProfilePictureUpload();

                // Create new user account
                int newUserId = CreateUser(username, password, email, role, firstName, lastName, phone, profilePicturePath);

                if (newUserId > 0)
                {
                    // Registration successful
                    ShowMessage("Account created successfully! You can now login with your credentials.", "success");

                    // Log the registration
                    LogRegistration(newUserId, username, email, role);

                    // Clear form
                    ClearForm();

                    // Redirect to login page after 3 seconds
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "redirectScript",
                        "setTimeout(function() { window.location.href = 'Login.aspx?registered=true'; }, 3000);", true);
                }
                else
                {
                    ShowMessage("Failed to create account. Please try again later.", "danger");
                }
            }
            catch (SqlException sqlEx)
            {
                ShowMessage("Database error occurred. Please try again.", "danger");
                System.Diagnostics.Debug.WriteLine($"SQL Error during registration: {sqlEx.Message}");
            }
            catch (Exception ex)
            {
                ShowMessage("An unexpected error occurred. Please try again.", "danger");
                System.Diagnostics.Debug.WriteLine($"Registration error: {ex.Message}");
            }
        }

        protected void BtnReset_Click(object sender, EventArgs e)
        {
            ClearForm();
            ShowMessage("Form has been reset.", "info");
        }

        protected void BtnRemoveImage_Click(object sender, EventArgs e)
        {
            // Remove profile picture
            imgProfilePreview.Visible = false;
            profilePlaceholder.Style.Remove("display");
            btnRemoveImage.Visible = false;
            hdnHasNewImage.Value = "false";

            // Clear the file upload
            fileProfilePicture.Attributes.Clear();

            ShowMessage("Profile picture removed.", "info");
        }

        protected void CvPassword_ServerValidate(object source, ServerValidateEventArgs args)
        {
            // Server-side password validation
            string password = args.Value;
            args.IsValid = !string.IsNullOrEmpty(password) && password.Length >= 6;
        }

        private string HandleProfilePictureUpload()
        {
            string profilePicturePath = null;

            // Check if a new file was uploaded
            if (fileProfilePicture.HasFile)
            {
                try
                {
                    // Validate file size (max 2MB)
                    if (fileProfilePicture.PostedFile.ContentLength > 2 * 1024 * 1024)
                    {
                        ShowMessage("Profile picture must be less than 2MB.", "danger");
                        return null;
                    }

                    // Validate file type
                    string fileExtension = Path.GetExtension(fileProfilePicture.FileName).ToLower();
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
                        ShowMessage("Please select a valid image file (JPG, PNG, GIF).", "danger");
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
                    fileProfilePicture.SaveAs(fullPath);

                    // Return relative path for database storage
                    profilePicturePath = "~/Uploads/ProfilePictures/" + fileName;
                }
                catch (Exception ex)
                {
                    ShowMessage("Error uploading profile picture: " + ex.Message, "danger");
                    System.Diagnostics.Debug.WriteLine($"Profile picture upload error: {ex.Message}");
                }
            }

            return profilePicturePath;
        }

        private bool IsUsernameExists(string username)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Username = @Username AND IsActive = 1";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Username", username);
                    connection.Open();

                    int count = Convert.ToInt32(command.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        private bool IsEmailExists(string email)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email AND IsActive = 1";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Email", email);
                    connection.Open();

                    int count = Convert.ToInt32(command.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        private bool IsPasswordStrong(string password)
        {
            // Basic password strength check
            return !string.IsNullOrEmpty(password) && password.Length >= 6;
        }

        private int CreateUser(string username, string password, string email, string role,
                            string firstName, string lastName, string phone, string profilePicturePath)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                    INSERT INTO Users (
                        Username, 
                        PasswordHash, 
                        Email, 
                        Role, 
                        FirstName, 
                        LastName, 
                        Phone, 
                        ProfilePicture,
                        IsActive, 
                        CreatedDate,
                        LastLogin
                    ) OUTPUT INSERTED.UserId 
                    VALUES (
                        @Username, 
                        @PasswordHash, 
                        @Email, 
                        @Role, 
                        @FirstName, 
                        @LastName, 
                        @Phone, 
                        @ProfilePicture,
                        @IsActive, 
                        @CreatedDate,
                        @LastLogin
                    )";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // Add parameters
                    command.Parameters.AddWithValue("@Username", username);

                    // In production, use proper password hashing
                    // For demo purposes, storing plain text (NOT recommended for production)
                    command.Parameters.AddWithValue("@PasswordHash", password);

                    command.Parameters.AddWithValue("@Email", email);
                    command.Parameters.AddWithValue("@Role", role);
                    command.Parameters.AddWithValue("@FirstName", firstName);
                    command.Parameters.AddWithValue("@LastName", lastName);
                    command.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(phone) ? (object)DBNull.Value : phone);
                    command.Parameters.AddWithValue("@ProfilePicture", string.IsNullOrEmpty(profilePicturePath) ? (object)DBNull.Value : profilePicturePath);
                    command.Parameters.AddWithValue("@IsActive", true);
                    command.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                    command.Parameters.AddWithValue("@LastLogin", (object)DBNull.Value);

                    connection.Open();

                    // Execute and return the new UserId
                    object result = command.ExecuteScalar();
                    return result != null ? Convert.ToInt32(result) : 0;
                }
            }
        }

        private void LogRegistration(int userId, string username, string email, string role)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO RegistrationLog (
                            UserId, 
                            Username, 
                            Email, 
                            Role, 
                            RegistrationDate, 
                            IPAddress
                        ) VALUES (
                            @UserId, 
                            @Username, 
                            @Email, 
                            @Role, 
                            @RegistrationDate, 
                            @IPAddress
                        )";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);
                        command.Parameters.AddWithValue("@Username", username);
                        command.Parameters.AddWithValue("@Email", email);
                        command.Parameters.AddWithValue("@Role", role);
                        command.Parameters.AddWithValue("@RegistrationDate", DateTime.Now);
                        command.Parameters.AddWithValue("@IPAddress", GetClientIPAddress());

                        connection.Open();
                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the error but don't break the registration process
                System.Diagnostics.Debug.WriteLine($"Registration logging error: {ex.Message}");
            }
        }

        private string GetClientIPAddress()
        {
            string ipAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

            if (string.IsNullOrEmpty(ipAddress))
            {
                ipAddress = Request.ServerVariables["REMOTE_ADDR"];
            }

            return ipAddress ?? "Unknown";
        }

        private void ClearForm()
        {
            txtUsername.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtPassword.Text = string.Empty;
            txtConfirmPassword.Text = string.Empty;
            txtFirstName.Text = string.Empty;
            txtLastName.Text = string.Empty;
            txtPhone.Text = string.Empty;
            ddlRole.SelectedIndex = 0;

            // Reset profile picture
            imgProfilePreview.Visible = false;
            profilePlaceholder.Style.Remove("display");
            btnRemoveImage.Visible = false;
            fileProfilePicture.Attributes.Clear();
            hdnHasNewImage.Value = "false";

            // Set focus back to username
            txtUsername.Focus();
        }

        private void ShowMessage(string message, string type)
        {
            pnlMessage.Visible = true;
            litMessage.Text = message;

            // Remove existing alert classes
            pnlMessage.CssClass = pnlMessage.CssClass
                .Replace("alert-success", "")
                .Replace("alert-danger", "")
                .Replace("alert-warning", "")
                .Replace("alert-info", "");

            // Add appropriate alert class based on type
            switch (type.ToLower())
            {
                case "success":
                    pnlMessage.CssClass += " alert-success";
                    break;
                case "danger":
                    pnlMessage.CssClass += " alert-danger";
                    break;
                case "warning":
                    pnlMessage.CssClass += " alert-warning";
                    break;
                case "info":
                    pnlMessage.CssClass += " alert-info";
                    break;
                default:
                    pnlMessage.CssClass += " alert-info";
                    break;
            }

            // Register script to auto-hide the message after 5 seconds (except for success messages that redirect)
            if (type != "success")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "hideMessageScript",
                    $"setTimeout(function() {{ var alert = document.getElementById('{pnlMessage.ClientID}'); if (alert) alert.style.display = 'none'; }}, 5000);", true);
            }
        }
    }
}