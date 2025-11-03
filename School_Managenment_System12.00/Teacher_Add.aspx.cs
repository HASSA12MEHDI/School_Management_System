using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Management_System
{
    public partial class Teacher_Add : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadTeachers();
            }
        }

        private void LoadTeachers()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TeacherId, EmployeeId, FirstName, LastName, Email, Phone, 
                                            Qualification, Experience, JoiningDate, Salary, IsActive, profilepic
                                     FROM Teachers 
                                     ORDER BY TeacherId DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        GvTeachers.DataSource = dt;
                        GvTeachers.DataBind();

                        if (dt.Rows.Count > 0)
                        {
                            ShowMessage($"Successfully loaded {dt.Rows.Count} teachers", "success");
                        }
                        else
                        {
                            ShowMessage("No teacher records found.", "info");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Database error: {ex.Message}", "danger");
            }
        }

        // Profile Image Method - FIXED VERSION
        public string GetProfileImage(object profilePic)
        {
            try
            {
                if (profilePic == null || profilePic == DBNull.Value || string.IsNullOrEmpty(profilePic.ToString()))
                {
                    return ResolveUrl("~/images/default-teacher.png");
                }

                string imagePath = profilePic.ToString().Trim();

                // Debugging ke liye
                System.Diagnostics.Debug.WriteLine($"Profile Pic Path from DB: {imagePath}");

                // Agar path mein "images/teachers/" hai to use direct use karein
                if (imagePath.StartsWith("images/teachers/"))
                {
                    string fullPath = ResolveUrl($"~/{imagePath}");

                    // Check if file physically exists
                    string physicalPath = Server.MapPath($"~/{imagePath}");
                    if (!File.Exists(physicalPath))
                    {
                        System.Diagnostics.Debug.WriteLine($"File not found: {physicalPath}");
                        return ResolveUrl("~/images/default-teacher.png");
                    }

                    return fullPath;
                }
                // Agar sirf file name hai to "images/teachers/" folder mein dhoondhein
                else if (!imagePath.Contains("/"))
                {
                    string fullPath = ResolveUrl($"~/images/teachers/{imagePath}");
                    string physicalPath = Server.MapPath($"~/images/teachers/{imagePath}");

                    if (!File.Exists(physicalPath))
                    {
                        System.Diagnostics.Debug.WriteLine($"File not found in teachers folder: {physicalPath}");
                        return ResolveUrl("~/images/default-teacher.png");
                    }

                    return fullPath;
                }
                // Default case
                else
                {
                    return ResolveUrl("~/images/default-teacher.png");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetProfileImage: {ex.Message}");
                return ResolveUrl("~/images/default-teacher.png");
            }
        }

        // Alternative method for Edit Template - FIXED VERSION
        public string GetProfileImageForEdit(object profilePic)
        {
            try
            {
                if (profilePic == null || profilePic == DBNull.Value || string.IsNullOrEmpty(profilePic.ToString()))
                {
                    return "/images/default-teacher.png";
                }

                string imagePath = profilePic.ToString().Trim();

                // Debugging
                System.Diagnostics.Debug.WriteLine($"Edit Mode - Profile Pic: {imagePath}");

                if (imagePath.StartsWith("images/teachers/"))
                {
                    return $"/{imagePath}";
                }
                else if (!imagePath.Contains("/"))
                {
                    return $"/images/teachers/{imagePath}";
                }
                else
                {
                    return "/images/default-teacher.png";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetProfileImageForEdit: {ex.Message}");
                return "/images/default-teacher.png";
            }
        }

        public string FormatSalary(object salary)
        {
            try
            {
                if (salary == null || salary == DBNull.Value) return "0.00";
                decimal sal = Convert.ToDecimal(salary);
                return sal.ToString("#,##0.00");
            }
            catch
            {
                return "0.00";
            }
        }

        public string FormatDate(object date)
        {
            try
            {
                if (date == null || date == DBNull.Value) return "N/A";
                DateTime dt = Convert.ToDateTime(date);
                return dt.ToString("dd MMM yyyy");
            }
            catch
            {
                return "N/A";
            }
        }

        public string GetStatusClass(object isActive)
        {
            try
            {
                if (isActive == null || isActive == DBNull.Value) return "status-inactive";
                bool active = Convert.ToBoolean(isActive);
                return active ? "status-active" : "status-inactive";
            }
            catch
            {
                return "status-inactive";
            }
        }

        public string GetStatusText(object isActive)
        {
            try
            {
                if (isActive == null || isActive == DBNull.Value) return "Inactive";
                bool active = Convert.ToBoolean(isActive);
                return active ? "Active" : "Inactive";
            }
            catch
            {
                return "Inactive";
            }
        }

        // Event Handlers
        protected void BtnAddTeacher_Click(object sender, EventArgs e)
        {
            Response.Redirect("Teacher_Add_Edit.aspx?mode=add");
        }

        protected void BtnExportExcel_Click(object sender, EventArgs e)
        {
            try
            {
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=Teachers_" + DateTime.Now.ToString("yyyyMMdd") + ".xls");
                Response.Charset = "";
                Response.ContentType = "application/vnd.ms-excel";

                StringWriter sw = new StringWriter();
                HtmlTextWriter hw = new HtmlTextWriter(sw);

                GridView gvExport = new GridView();
                gvExport.DataSource = ((DataTable)GvTeachers.DataSource);
                gvExport.DataBind();

                gvExport.Columns.RemoveAt(0);

                gvExport.RenderControl(hw);

                Response.Output.Write(sw.ToString());
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                ShowMessage($"Export error: {ex.Message}", "danger");
            }
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            // Required for Export to Excel
        }

        protected void BtnRefresh_Click(object sender, EventArgs e)
        {
            LoadTeachers();
            ShowMessage("Data refreshed successfully", "success");
        }

        protected void GvTeachers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GvTeachers.PageIndex = e.NewPageIndex;
            LoadTeachers();
        }

        // RowCommand for View button
        protected void GvTeachers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "View")
            {
                try
                {
                    int index = Convert.ToInt32(e.CommandArgument);
                    int teacherId = Convert.ToInt32(GvTeachers.DataKeys[index].Value);

                    ShowTeacherDetails(teacherId);
                }
                catch (Exception ex)
                {
                    ShowMessage($"Error viewing teacher details: {ex.Message}", "danger");
                }
            }
        }

        // RowEditing - Same page pe edit karega
        protected void GvTeachers_RowEditing(object sender, GridViewEditEventArgs e)
        {
            try
            {
                GvTeachers.EditIndex = e.NewEditIndex;
                LoadTeachers();
                ShowMessage("You can now edit the teacher details.", "info");
            }
            catch (Exception ex)
            {
                ShowMessage($"Error editing teacher: {ex.Message}", "danger");
            }
        }

        // RowUpdating for in-place editing with profile picture - FIXED VERSION
        protected void GvTeachers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                GridViewRow row = GvTeachers.Rows[e.RowIndex];
                int teacherId = Convert.ToInt32(GvTeachers.DataKeys[e.RowIndex].Value);

                // Get updated values using FindControl
                string employeeId = ((TextBox)row.FindControl("TxtEmployeeId")).Text;
                string firstName = ((TextBox)row.FindControl("TxtFirstName")).Text;
                string lastName = ((TextBox)row.FindControl("TxtLastName")).Text;
                string email = ((TextBox)row.FindControl("TxtEmail")).Text;
                string phone = ((TextBox)row.FindControl("TxtPhone")).Text;
                string qualification = ((TextBox)row.FindControl("TxtQualification")).Text;
                string experienceText = ((TextBox)row.FindControl("TxtExperience")).Text;
                string salaryText = ((TextBox)row.FindControl("TxtSalary")).Text;
                string joiningDateText = ((TextBox)row.FindControl("TxtJoiningDate")).Text;
                bool isActive = ((CheckBox)row.FindControl("ChkIsActive")).Checked;

                // Handle profile picture - FIXED VERSION
                string profilePicName = "";
                FileUpload fileUploadProfile = (FileUpload)row.FindControl("FileUploadProfile");
                HiddenField hdnCurrentProfilePic = (HiddenField)row.FindControl("HdnCurrentProfilePic");

                string currentProfilePic = hdnCurrentProfilePic?.Value ?? "";

                if (fileUploadProfile.HasFile)
                {
                    // New file uploaded
                    string fileName = Path.GetFileName(fileUploadProfile.FileName);
                    string fileExtension = Path.GetExtension(fileName).ToLower();

                    // Validate file type
                    if (fileExtension == ".jpg" || fileExtension == ".jpeg" || fileExtension == ".png" || fileExtension == ".gif")
                    {
                        // Generate unique file name - Add_Teacher.aspx ke format ke mutabiq
                        profilePicName = $"teacher_{employeeId.Replace("-", "_")}_{DateTime.Now:yyyyMMddHHmmss}{fileExtension}";
                        string filePath = Server.MapPath($"~/images/teachers/{profilePicName}");

                        // Create directory if it doesn't exist
                        string directoryPath = Server.MapPath("~/images/teachers/");
                        if (!Directory.Exists(directoryPath))
                        {
                            Directory.CreateDirectory(directoryPath);
                        }

                        // Save new file
                        fileUploadProfile.SaveAs(filePath);

                        // Delete old profile picture if it exists and is not default
                        if (!string.IsNullOrEmpty(currentProfilePic) &&
                            !currentProfilePic.Equals("default-teacher.png", StringComparison.OrdinalIgnoreCase) &&
                            !currentProfilePic.StartsWith("images/teachers/default-teacher.png", StringComparison.OrdinalIgnoreCase))
                        {
                            string oldFilePath = "";
                            if (currentProfilePic.StartsWith("images/teachers/"))
                            {
                                oldFilePath = Server.MapPath($"~/{currentProfilePic}");
                            }
                            else
                            {
                                oldFilePath = Server.MapPath($"~/images/teachers/{currentProfilePic}");
                            }

                            if (File.Exists(oldFilePath))
                            {
                                try
                                {
                                    File.Delete(oldFilePath);
                                }
                                catch (Exception ex)
                                {
                                    System.Diagnostics.Debug.WriteLine($"File deletion error: {ex.Message}");
                                }
                            }
                        }
                    }
                    else
                    {
                        ShowMessage("Please upload only image files (JPG, PNG, GIF).", "warning");
                        return;
                    }
                }
                else
                {
                    // No new file, keep current profile picture
                    profilePicName = currentProfilePic;
                }

                // Validate numeric fields
                if (!decimal.TryParse(salaryText, out decimal salary))
                {
                    ShowMessage("Please enter a valid salary amount.", "warning");
                    return;
                }

                // Salary range validation
                if (salary < 0)
                {
                    ShowMessage("Salary cannot be negative.", "warning");
                    return;
                }

                if (salary > 9999999.99m) // Maximum 99,99,999.99
                {
                    ShowMessage("Salary cannot exceed 99,99,999.99", "warning");
                    return;
                }

                if (!int.TryParse(experienceText, out int experience))
                {
                    experience = 0; // Default value
                }

                if (!DateTime.TryParse(joiningDateText, out DateTime joiningDate))
                {
                    joiningDate = DateTime.Now; // Default value
                }

                // Update in database with profile picture - FIXED VERSION
                string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string updateQuery = @"UPDATE Teachers SET 
                            EmployeeId = @EmployeeId,
                            FirstName = @FirstName, 
                            LastName = @LastName,
                            Email = @Email, 
                            Phone = @Phone,
                            Qualification = @Qualification,
                            Experience = @Experience,
                            Salary = @Salary,
                            JoiningDate = @JoiningDate,
                            IsActive = @IsActive,
                            profilepic = @ProfilePic
                            WHERE TeacherId = @TeacherId";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                        cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                        cmd.Parameters.AddWithValue("@FirstName", firstName);
                        cmd.Parameters.AddWithValue("@LastName", lastName);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Phone", phone);
                        cmd.Parameters.AddWithValue("@Qualification", qualification);
                        cmd.Parameters.AddWithValue("@Experience", experience);
                        cmd.Parameters.AddWithValue("@Salary", salary);
                        cmd.Parameters.AddWithValue("@JoiningDate", joiningDate);
                        cmd.Parameters.AddWithValue("@IsActive", isActive);

                        // Handle profile picture parameter - FIXED VERSION
                        if (string.IsNullOrEmpty(profilePicName))
                        {
                            cmd.Parameters.AddWithValue("@ProfilePic", "images/default-teacher.png");
                        }
                        else
                        {
                            // Ensure consistent path format
                            if (profilePicName.StartsWith("images/teachers/"))
                            {
                                cmd.Parameters.AddWithValue("@ProfilePic", profilePicName);
                            }
                            else
                            {
                                cmd.Parameters.AddWithValue("@ProfilePic", "images/teachers/" + profilePicName);
                            }
                        }

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            GvTeachers.EditIndex = -1;
                            LoadTeachers();
                            ShowMessage("Teacher updated successfully!", "success");
                        }
                        else
                        {
                            ShowMessage("Failed to update teacher.", "danger");
                        }
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 8115) // Arithmetic overflow error
                {
                    ShowMessage("Salary value is too large. Please enter a smaller amount.", "danger");
                }
                else
                {
                    ShowMessage($"Database error: {sqlEx.Message}", "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error updating teacher: {ex.Message}", "danger");
            }
        }

        // Cancel edit
        protected void GvTeachers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GvTeachers.EditIndex = -1;
            LoadTeachers();
            ShowMessage("Edit cancelled.", "info");
        }

        // Delete teacher - FIXED VERSION
        protected void GvTeachers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int teacherId = Convert.ToInt32(GvTeachers.DataKeys[e.RowIndex].Value);
                string profilePicName = "";

                string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string selectQuery = "SELECT profilepic FROM Teachers WHERE TeacherId = @TeacherId";
                    using (SqlCommand selectCmd = new SqlCommand(selectQuery, con))
                    {
                        selectCmd.Parameters.AddWithValue("@TeacherId", teacherId);
                        con.Open();
                        object result = selectCmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            profilePicName = result.ToString();
                        }
                    }
                }

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string deleteQuery = "DELETE FROM Teachers WHERE TeacherId = @TeacherId";
                    using (SqlCommand deleteCmd = new SqlCommand(deleteQuery, con))
                    {
                        deleteCmd.Parameters.AddWithValue("@TeacherId", teacherId);
                        con.Open();
                        int rowsAffected = deleteCmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Delete profile picture if exists and not default
                            if (!string.IsNullOrEmpty(profilePicName) &&
                                !profilePicName.Equals("default-teacher.png", StringComparison.OrdinalIgnoreCase) &&
                                !profilePicName.StartsWith("images/teachers/default-teacher.png", StringComparison.OrdinalIgnoreCase))
                            {
                                string filePath = "";
                                if (profilePicName.StartsWith("images/teachers/"))
                                {
                                    filePath = Server.MapPath($"~/{profilePicName}");
                                }
                                else
                                {
                                    filePath = Server.MapPath($"~/images/teachers/{profilePicName}");
                                }

                                if (File.Exists(filePath))
                                {
                                    try
                                    {
                                        File.Delete(filePath);
                                    }
                                    catch (Exception ex)
                                    {
                                        System.Diagnostics.Debug.WriteLine($"File deletion error: {ex.Message}");
                                    }
                                }
                            }

                            ShowMessage("Teacher deleted successfully", "success");
                            LoadTeachers();
                        }
                        else
                        {
                            ShowMessage("Teacher not found or already deleted", "warning");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error deleting teacher: {ex.Message}", "danger");
            }
        }

        // Show teacher details in same page
        private void ShowTeacherDetails(int teacherId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT * FROM Teachers WHERE TeacherId = @TeacherId";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string profilePic = GetProfileImage(reader["profilepic"]);

                                string details = $@"
                                <div style='background: #f8f9fa; padding: 20px; border-radius: 10px; border-left: 5px solid #667eea;'>
                                    <div style='display: flex; align-items: center; margin-bottom: 15px;'>
                                        <img src='{profilePic}' style='width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid #667eea; margin-right: 15px;' onerror='this.src=\""/images/default-teacher.png\""' />
                                        <div>
                                            <h4 style='color: #667eea; margin: 0;'><i class='fas fa-user-graduate'></i> Teacher Details</h4>
                                            <p style='margin: 5px 0 0 0; color: #666;'>{reader["EmployeeId"]}</p>
                                        </div>
                                    </div>
                                    <div style='display: grid; grid-template-columns: 1fr 1fr; gap: 10px;'>
                                        <div><strong>Name:</strong> {reader["FirstName"]} {reader["LastName"]}</div>
                                        <div><strong>Employee ID:</strong> {reader["EmployeeId"]}</div>
                                        <div><strong>Email:</strong> {reader["Email"]}</div>
                                        <div><strong>Phone:</strong> {reader["Phone"]}</div>
                                        <div><strong>Qualification:</strong> {reader["Qualification"]}</div>
                                        <div><strong>Experience:</strong> {reader["Experience"]} years</div>
                                        <div><strong>Salary:</strong> ₹{FormatSalary(reader["Salary"])}</div>
                                        <div><strong>Status:</strong> {GetStatusText(reader["IsActive"])}</div>
                                        <div><strong>Joining Date:</strong> {FormatDate(reader["JoiningDate"])}</div>
                                    </div>
                                </div>
                                ";

                                ShowMessage(details, "info");
                            }
                            else
                            {
                                ShowMessage("Teacher details not found.", "warning");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading details: {ex.Message}", "danger");
            }
        }

        protected void GvTeachers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Set CommandArgument for View button
                LinkButton btnView = e.Row.FindControl("BtnView") as LinkButton;
                if (btnView != null)
                {
                    btnView.CommandArgument = e.Row.RowIndex.ToString();
                }

                // Delete button confirmation
                LinkButton btnDelete = e.Row.FindControl("BtnDelete") as LinkButton;
                if (btnDelete != null)
                {
                    string firstName = DataBinder.Eval(e.Row.DataItem, "FirstName")?.ToString() ?? "";
                    string lastName = DataBinder.Eval(e.Row.DataItem, "LastName")?.ToString() ?? "";
                    btnDelete.OnClientClick = $"return confirm('Are you sure you want to delete teacher: {firstName} {lastName}? This action cannot be undone.');";
                }

                // Handle image errors for both ItemTemplate and EditItemTemplate
                Image imgProfile = e.Row.FindControl("ImgProfile") as Image;
                if (imgProfile != null)
                {
                    imgProfile.Attributes["onerror"] = $"this.src='{ResolveUrl("~/images/default-teacher.png")}'";
                }

                // Edit mode mein image handle karein
                if ((e.Row.RowState & DataControlRowState.Edit) != 0)
                {
                    Image imgCurrentProfile = e.Row.FindControl("ImgCurrentProfile") as Image;
                    if (imgCurrentProfile != null)
                    {
                        imgCurrentProfile.Attributes["onerror"] = $"this.src='{ResolveUrl("~/images/default-teacher.png")}'";

                        // Set current profile picture path for edit mode
                        HiddenField hdnCurrentProfilePic = e.Row.FindControl("HdnCurrentProfilePic") as HiddenField;
                        if (hdnCurrentProfilePic != null)
                        {
                            object profilePic = DataBinder.Eval(e.Row.DataItem, "profilepic");
                            hdnCurrentProfilePic.Value = profilePic?.ToString() ?? "";
                        }
                    }
                }
            }
            else if (e.Row.RowType == DataControlRowType.Header)
            {
                foreach (TableCell cell in e.Row.Cells)
                {
                    cell.Attributes["title"] = cell.Text.Replace("🖼️", "").Replace("🆔", "").Replace("👤", "").Replace("📞", "").Replace("🎓", "").Replace("💰", "").Replace("📅", "").Replace("📊", "").Replace("⚡", "").Trim();
                }
            }
        }

        private void ShowMessage(string message, string type)
        {
            PnlMessage.Visible = true;
            LblMessage.Text = message;

            PnlMessage.CssClass = "alert";

            switch (type.ToLower())
            {
                case "success":
                    PnlMessage.CssClass += " alert-success";
                    break;
                case "danger":
                    PnlMessage.CssClass += " alert-danger";
                    break;
                case "info":
                    PnlMessage.CssClass += " alert-info";
                    break;
                case "warning":
                    PnlMessage.CssClass += " alert-warning";
                    break;
                default:
                    PnlMessage.CssClass += " alert-info";
                    break;
            }
        }
    }
}