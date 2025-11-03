using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class Reset : System.Web.UI.Page
    {
        // Made field readonly
        private readonly string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf"";Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set focus to email field
                txtEmail.Focus();
                pnlMessage.Visible = false;
            }
        }

        protected void BtnReset_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string email = txtEmail.Text.Trim();
                string username = txtUsername.Text.Trim();
                string newPassword = txtNewPassword.Text.Trim();
                string confirmPassword = txtConfirmPassword.Text.Trim();

                // Validate passwords match (client-side should catch this, but double-check)
                if (newPassword != confirmPassword)
                {
                    ShowMessage("Passwords do not match. Please try again.", "danger");
                    return;
                }

                // Validate password strength
                if (!IsPasswordStrong(newPassword))
                {
                    ShowMessage("Password does not meet strength requirements. Please use a stronger password.", "warning");
                    return;
                }

                try
                {
                    // Verify user exists and email matches username
                    if (VerifyUser(email, username))
                    {
                        // Update password
                        if (UpdatePassword(email, newPassword))
                        {
                            ShowMessage("Password reset successfully! You can now login with your new password.", "success");
                            ClearForm();

                            // Redirect to login page after 3 seconds
                            ScriptManager.RegisterStartupScript(this, GetType(), "redirect",
                                "setTimeout(function(){ window.location.href = 'Login.aspx'; }, 3000);", true);
                        }
                        else
                        {
                            ShowMessage("Failed to reset password. Please try again.", "danger");
                        }
                    }
                    else
                    {
                        ShowMessage("Invalid email or username. Please check your credentials and try again.", "danger");
                    }
                }
                catch (Exception)
                {
                    // Removed unused 'ex' variable - only keeping the exception type
                    ShowMessage("An error occurred while resetting your password. Please try again later.", "danger");
                }
            }
        }

        private bool VerifyUser(string email, string username)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(1) FROM Users WHERE Email = @Email AND Username = @Username AND IsActive = 1";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Email", email);
                    command.Parameters.AddWithValue("@Username", username);

                    connection.Open();
                    int count = Convert.ToInt32(command.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        private bool UpdatePassword(string email, string newPassword)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "UPDATE Users SET PasswordHash = @PasswordHash, LastLogin = NULL WHERE Email = @Email";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // In production, hash the password properly
                    // For now, storing in plain text as requested
                    command.Parameters.AddWithValue("@PasswordHash", newPassword);
                    command.Parameters.AddWithValue("@Email", email);

                    connection.Open();
                    int rowsAffected = command.ExecuteNonQuery();
                    return rowsAffected > 0;
                }
            }
        }

        private bool IsPasswordStrong(string password)
        {
            // Check minimum length
            if (password.Length < 8)
                return false;

            // Check for uppercase letters
            if (!System.Text.RegularExpressions.Regex.IsMatch(password, "[A-Z]"))
                return false;

            // Check for lowercase letters
            if (!System.Text.RegularExpressions.Regex.IsMatch(password, "[a-z]"))
                return false;

            // Check for numbers
            if (!System.Text.RegularExpressions.Regex.IsMatch(password, "[0-9]"))
                return false;

            return true;
        }

        private void ShowMessage(string message, string type)
        {
            pnlMessage.Visible = true;
            pnlMessage.CssClass = $"alert alert-{type} alert-dismissible fade show";
            litMessage.Text = message;

            // Add appropriate icon based on message type
            string icon = type == "success" ? "fa-check-circle" :
                         type == "danger" ? "fa-exclamation-circle" :
                         type == "warning" ? "fa-exclamation-triangle" : "fa-info-circle";

            litMessage.Text = $"<i class='fas {icon} me-2'></i>" + message;
        }

        private void ClearForm()
        {
            txtEmail.Text = "";
            txtUsername.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";
        }
    }
}