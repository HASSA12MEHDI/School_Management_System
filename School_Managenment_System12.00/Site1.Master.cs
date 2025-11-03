using System;
using System.Web.UI;
using System.Web;

namespace School_Managenment_System12._00
{
    public partial class Site1 : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in and update UI
                CheckUserLoginStatus();
            }
        }

        private void CheckUserLoginStatus()
        {
            if (Session["UserId"] != null)
            {
                // User is logged in
                if (lnkLogout != null)
                    lnkLogout.Visible = true;

                // Set user information
                if (lblUserName != null)
                    lblUserName.Text = "Welcome, " + (Session["FirstName"] ?? Session["Username"] ?? "User");

                if (lblUserRole != null)
                    lblUserRole.Text = Session["Role"]?.ToString() ?? "User";

                // Set profile picture
                if (ProfilePic != null && Session["ProfilePicture"] != null)
                {
                    ProfilePic.ImageUrl = Session["ProfilePicture"].ToString();
                }
            }
            else
            {
                // User not logged in
                if (lnkLogout != null)
                    lnkLogout.Visible = false;

                if (lblUserName != null)
                    lblUserName.Text = "Welcome, Guest";

                if (lblUserRole != null)
                    lblUserRole.Text = "Guest";
            }
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            // Clear all session variables
            Session.Clear();
            Session.Abandon();

            // Clear session cookie
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            }

            // Clear other authentication cookies if any
            if (Request.Cookies["UserAuth"] != null)
            {
                Response.Cookies["UserAuth"].Value = string.Empty;
                Response.Cookies["UserAuth"].Expires = DateTime.Now.AddMonths(-20);
            }

            // Redirect to login page
            Response.Redirect("~/Login.aspx");
        }

        protected void ProfilePic_Click(object sender, ImageClickEventArgs e)
        {
            // Redirect to profile page when profile picture is clicked
            Response.Redirect("~/profile.aspx");
        }
        protected void lnkStudents_Click(object sender, ImageClickEventArgs e)
        {
            // Redirect to profile page when profile picture is clicked
            Response.Redirect("~/Add_Student.aspx");
        }

        protected void lnkProfile_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Profile_Setting.aspx");
        }
        protected void lnkTeachers_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Teachers.aspx");
        }


    }
}