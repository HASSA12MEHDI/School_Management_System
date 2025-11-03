using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace School_Managenment_System12._00
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtUsername.Focus();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            lblMessage.Text = "";
            lblMessage.CssClass = "alert alert-danger";

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter both email and password!";
                lblMessage.CssClass = "alert alert-danger";
                lblMessage.Attributes.Add("style", "display:block");
                return;
            }

            try
            {
                // Use your direct connection string
                string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf"";Integrated Security=True";

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    // Query matching your Users table structure
                    string query = @"SELECT UserId, Username, PasswordHash, Email, Role, 
                                            FirstName, LastName, Phone, ProfilePicture, IsActive,
                                            CreatedDate, LastLogin
                                     FROM Users 
                                     WHERE Email = @Email AND PasswordHash = @Password AND IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);

                        con.Open();
                        SqlDataReader dr = cmd.ExecuteReader();

                        if (dr.HasRows && dr.Read())
                        {
                            // Login successful
                            Session["UserId"] = dr["UserId"].ToString();
                            Session["Username"] = dr["Username"].ToString();
                            Session["Email"] = dr["Email"].ToString();
                            Session["Role"] = dr["Role"].ToString();
                            Session["FirstName"] = dr["FirstName"].ToString();
                            Session["LastName"] = dr["LastName"].ToString();

                            // Phone number (if available)
                            if (dr["Phone"] != DBNull.Value && !string.IsNullOrEmpty(dr["Phone"].ToString()))
                            {
                                Session["Phone"] = dr["Phone"].ToString();
                            }

                            // Profile picture (if available)
                            if (dr["ProfilePicture"] != DBNull.Value && !string.IsNullOrEmpty(dr["ProfilePicture"].ToString()))
                            {
                                Session["ProfilePicture"] = dr["ProfilePicture"].ToString();
                            }
                            else
                            {
                                Session["ProfilePicture"] = "~/images/default.png";
                            }

                            // Update last login
                            UpdateLastLogin(Convert.ToInt32(dr["UserId"]));

                            // Redirect based on role
                            string role = dr["Role"].ToString().ToLower();
                            string redirectPage = GetRedirectPage(role);

                            // DIRECT Dashboard.aspx pe redirect karo - koi bhi role ho
                            Response.Redirect("Dashboard.aspx");
                        }
                        else
                        {
                            lblMessage.Text = "Invalid email or password!";
                            lblMessage.Attributes.Add("style", "display:block");
                        }
                        dr.Close();
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                lblMessage.Text = "Database error: " + sqlEx.Message;
                lblMessage.Attributes.Add("style", "display:block");
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.Attributes.Add("style", "display:block");
            }
        }

        private string GetRedirectPage(string role)
        {
            // Yeh method bas page ka naam return karega
            switch (role.ToLower())
            {
                case "admin":
                    return "AdminDashboard.aspx";
                case "teacher":
                    return "TeacherDashboard.aspx";
                case "student":
                    return "StudentDashboard.aspx";
                case "parent":
                    return "ParentDashboard.aspx";
                default:
                    return "Dashboard.aspx";
            }
        }

        private void UpdateLastLogin(int userId)
        {
            try
            {
                string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf"";Integrated Security=True";

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Users SET LastLogin = GETDATE() WHERE UserId = @UserId";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error but don't show to user
                System.Diagnostics.Debug.WriteLine("Last login update error: " + ex.Message);
            }
        }
    }
}