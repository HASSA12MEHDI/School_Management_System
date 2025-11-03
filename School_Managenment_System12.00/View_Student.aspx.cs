using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class View_Student : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Label lblPageTitle = (Label)Master.FindControl("lblPageTitle");
                if (lblPageTitle != null)
                {
                    lblPageTitle.Text = "Student Management";
                }

                BindClassFilter();
                BindStudents();
            }
        }

        protected void BtnApplyFilter_Click(object sender, EventArgs e)
        {
            BindStudents();
        }

        protected void BtnClearFilter_Click(object sender, EventArgs e)
        {
            txtSearchName.Text = "";
            ddlClassFilter.SelectedValue = "";
            ddlStatusFilter.SelectedValue = "";
            BindStudents();
        }

        protected void BtnSaveReport_Click(object sender, EventArgs e)
        {
            try
            {
                GenerateStudentReport();
                ShowMessage("Student report generated successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error generating report: " + ex.Message, "error");
            }
        }

        // VIEW BUTTON CLICK
        protected void BtnView_Click(object sender, EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;
                string studentId = btn.CommandArgument;
                ShowStudentDetails(studentId);
            }
            catch (Exception ex)
            {
                ShowMessage("Error viewing student: " + ex.Message, "error");
            }
        }

        // DELETE BUTTON CLICK - SOFT DELETE
        protected void BtnDelete_Click(object sender, EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;
                string studentId = btn.CommandArgument;

                // Show confirmation dialog
                deleteConfirmation.Style["display"] = "block";
                hdnStudentToDelete.Value = studentId;

                // Get student name for confirmation message
                string studentName = GetStudentName(studentId);
                ShowMessage($"Please confirm deletion of student: {studentName}", "error");
            }
            catch (Exception ex)
            {
                ShowMessage("Error preparing to delete student: " + ex.Message, "error");
            }
        }

        // CONFIRM DELETE - SOFT DELETE
        protected void BtnConfirmDelete_Click(object sender, EventArgs e)
        {
            try
            {
                string studentId = hdnStudentToDelete.Value;
                SoftDeleteStudent(studentId);
                BindStudents();
                deleteConfirmation.Style["display"] = "none";
                ShowMessage("Student deactivated successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error deactivating student: " + ex.Message, "error");
            }
        }

        // CANCEL DELETE
        protected void BtnCancelDelete_Click(object sender, EventArgs e)
        {
            deleteConfirmation.Style["display"] = "none";
            ShowMessage("Deletion cancelled.", "success");
        }

        // GRIDVIEW EVENTS
        protected void GvStudents_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvStudents.PageIndex = e.NewPageIndex;
            BindStudents();
        }

        protected void GvStudents_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvStudents.EditIndex = e.NewEditIndex;
            BindStudents();
        }

        protected void GvStudents_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvStudents.EditIndex = -1;
            BindStudents();
        }

        protected void GvStudents_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                string studentId = gvStudents.DataKeys[e.RowIndex].Value.ToString();

                GridViewRow row = gvStudents.Rows[e.RowIndex];
                string firstName = ((TextBox)row.FindControl("txtFirstName")).Text;
                string lastName = ((TextBox)row.FindControl("txtLastName")).Text;
                string email = ((TextBox)row.FindControl("txtEmail")).Text;
                string phone = ((TextBox)row.FindControl("txtPhone")).Text;
                string classId = ((DropDownList)row.FindControl("ddlClass")).SelectedValue;
                bool isActive = ((CheckBox)row.FindControl("chkIsActive")).Checked;

                UpdateStudent(studentId, firstName, lastName, email, phone, classId, isActive);

                gvStudents.EditIndex = -1;
                BindStudents();
                ShowMessage("Student updated successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating student: " + ex.Message, "error");
            }
        }

        protected void GvStudents_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Format phone number
                Label lblPhone = (Label)e.Row.FindControl("lblPhone");
                if (lblPhone != null)
                {
                    lblPhone.Text = FormatPhoneNumber(lblPhone.Text);
                }

                // Set class name
                Label lblClassName = (Label)e.Row.FindControl("lblClassName");
                if (lblClassName != null)
                {
                    string classId = DataBinder.Eval(e.Row.DataItem, "ClassId").ToString();
                    lblClassName.Text = GetClassName(classId);
                }

                // Set edit dropdown value
                if (e.Row.RowState == DataControlRowState.Edit || e.Row.RowState == (DataControlRowState.Edit | DataControlRowState.Alternate))
                {
                    DropDownList ddlClass = (DropDownList)e.Row.FindControl("ddlClass");
                    if (ddlClass != null)
                    {
                        string classId = DataBinder.Eval(e.Row.DataItem, "ClassId").ToString();
                        ddlClass.SelectedValue = classId;
                    }
                }

                // Hide delete button for already inactive students
                Button btnDelete = (Button)e.Row.FindControl("btnDelete");
                if (btnDelete != null)
                {
                    bool isActive = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "IsActive"));
                    if (!isActive)
                    {
                        btnDelete.Visible = false;
                    }
                }
            }
        }

        // DATA METHODS
        private void BindStudents()
        {
            try
            {
                DataTable dt = GetStudentsData();
                gvStudents.DataSource = dt;
                gvStudents.DataBind();
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "error");
            }
        }

        private DataTable GetStudentsData()
        {
            DataTable dt = new DataTable();
            string constr = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(constr))
            {
                // Only show active students by default
                string query = @"SELECT StudentId, RollNumber, FirstName, LastName, Email, Phone, ClassId, IsActive 
                               FROM Students WHERE IsActive = 1";

                // Add filters
                if (!string.IsNullOrEmpty(txtSearchName.Text))
                    query += " AND (FirstName LIKE '%' + @SearchName + '%' OR LastName LIKE '%' + @SearchName + '%')";

                if (!string.IsNullOrEmpty(ddlClassFilter.SelectedValue))
                    query += " AND ClassId = @ClassId";

                if (!string.IsNullOrEmpty(ddlStatusFilter.SelectedValue))
                {
                    if (ddlStatusFilter.SelectedValue == "all")
                    {
                        // Show all students including inactive
                        query = @"SELECT StudentId, RollNumber, FirstName, LastName, Email, Phone, ClassId, IsActive 
                                FROM Students WHERE 1=1";

                        if (!string.IsNullOrEmpty(txtSearchName.Text))
                            query += " AND (FirstName LIKE '%' + @SearchName + '%' OR LastName LIKE '%' + @SearchName + '%')";

                        if (!string.IsNullOrEmpty(ddlClassFilter.SelectedValue))
                            query += " AND ClassId = @ClassId";
                    }
                    else
                    {
                        query += " AND IsActive = @IsActive";
                    }
                }

                query += " ORDER BY RollNumber";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (!string.IsNullOrEmpty(txtSearchName.Text))
                        cmd.Parameters.AddWithValue("@SearchName", txtSearchName.Text);

                    if (!string.IsNullOrEmpty(ddlClassFilter.SelectedValue))
                        cmd.Parameters.AddWithValue("@ClassId", ddlClassFilter.SelectedValue);

                    if (!string.IsNullOrEmpty(ddlStatusFilter.SelectedValue) && ddlStatusFilter.SelectedValue != "all")
                        cmd.Parameters.AddWithValue("@IsActive", ddlStatusFilter.SelectedValue == "true");

                    con.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            return dt;
        }

        private void BindClassFilter()
        {
            try
            {
                string constr = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constr))
                {
                    string query = "SELECT ClassID, ClassName FROM Classes ORDER BY ClassName";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlClassFilter.Items.Clear();
                            ddlClassFilter.Items.Add(new ListItem("All Classes", ""));

                            while (reader.Read())
                            {
                                ddlClassFilter.Items.Add(new ListItem(
                                    reader["ClassName"].ToString(),
                                    reader["ClassID"].ToString()
                                ));
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
                ddlClassFilter.Items.Add(new ListItem("Class 1", "1"));
                ddlClassFilter.Items.Add(new ListItem("Class 2", "2"));
                ddlClassFilter.Items.Add(new ListItem("Class 3", "3"));
            }
        }

        private void UpdateStudent(string studentId, string firstName, string lastName, string email, string phone, string classId, bool isActive)
        {
            string constr = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                string query = @"UPDATE Students SET FirstName=@FirstName, LastName=@LastName, 
                               Email=@Email, Phone=@Phone, ClassId=@ClassId, IsActive=@IsActive 
                               WHERE StudentId=@StudentId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    cmd.Parameters.AddWithValue("@FirstName", firstName);
                    cmd.Parameters.AddWithValue("@LastName", lastName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@ClassId", classId);
                    cmd.Parameters.AddWithValue("@IsActive", isActive);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // SOFT DELETE METHOD
        private void SoftDeleteStudent(string studentId)
        {
            string constr = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                string query = "UPDATE Students SET IsActive = 0 WHERE StudentId = @StudentId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    con.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected == 0)
                    {
                        throw new Exception("Student not found or already deactivated.");
                    }
                }
            }
        }

        // HARD DELETE METHOD (Use only if you want to permanently delete)
        private void HardDeleteStudent(string studentId)
        {
            string constr = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                con.Open();
                using (SqlTransaction transaction = con.BeginTransaction())
                {
                    try
                    {
                        // First delete related records from Results table
                        string deleteResultsQuery = "DELETE FROM Results WHERE StudentId = @StudentId";
                        using (SqlCommand cmd = new SqlCommand(deleteResultsQuery, con, transaction))
                        {
                            cmd.Parameters.AddWithValue("@StudentId", studentId);
                            cmd.ExecuteNonQuery();
                        }

                        // Then delete from Attendance table if exists
                        string deleteAttendanceQuery = "DELETE FROM Attendance WHERE StudentId = @StudentId";
                        using (SqlCommand cmd = new SqlCommand(deleteAttendanceQuery, con, transaction))
                        {
                            cmd.Parameters.AddWithValue("@StudentId", studentId);
                            cmd.ExecuteNonQuery();
                        }

                        // Finally delete the student
                        string deleteStudentQuery = "DELETE FROM Students WHERE StudentId = @StudentId";
                        using (SqlCommand cmd = new SqlCommand(deleteStudentQuery, con, transaction))
                        {
                            cmd.Parameters.AddWithValue("@StudentId", studentId);
                            int rowsAffected = cmd.ExecuteNonQuery();

                            if (rowsAffected == 0)
                            {
                                throw new Exception("Student not found.");
                            }
                        }

                        transaction.Commit();
                    }
                    catch (Exception)
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }

        private void ShowStudentDetails(string studentId)
        {
            string constr = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                string query = @"SELECT s.*, c.ClassName FROM Students s 
                               LEFT JOIN Classes c ON s.ClassId = c.ClassID 
                               WHERE s.StudentId=@StudentId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string details = $@"
                                <div style='background:#f8f9fa; padding:15px; border-radius:5px;'>
                                <h4>Student Details</h4>
                                <strong>Roll No:</strong> {reader["RollNumber"]}<br/>
                                <strong>Name:</strong> {reader["FirstName"]} {reader["LastName"]}<br/>
                                <strong>Email:</strong> {reader["Email"]}<br/>
                                <strong>Phone:</strong> {reader["Phone"]}<br/>
                                <strong>Class:</strong> {reader["ClassName"]}<br/>
                                <strong>Status:</strong> {(reader["IsActive"].ToString() == "True" ? "Active" : "Inactive")}
                                </div>";

                            ShowMessage(details, "success");
                        }
                    }
                }
            }
        }

        private string GetStudentName(string studentId)
        {
            string constr = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                string query = "SELECT FirstName, LastName FROM Students WHERE StudentId = @StudentId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return $"{reader["FirstName"]} {reader["LastName"]}";
                        }
                    }
                }
            }
            return "Unknown Student";
        }

        private void GenerateStudentReport()
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Students.xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";

            System.IO.StringWriter sw = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter hw = new System.Web.UI.HtmlTextWriter(sw);

            gvStudents.AllowPaging = false;
            BindStudents();
            gvStudents.RenderControl(hw);

            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
        }

        // HELPER METHODS
        public string GetClassName(string classId)
        {
            if (string.IsNullOrEmpty(classId)) return "N/A";

            string constr = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    string query = "SELECT ClassName FROM Classes WHERE ClassID=@ClassId";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@ClassId", classId);
                        con.Open();
                        object result = cmd.ExecuteScalar();
                        return result != null ? result.ToString() : "Class " + classId;
                    }
                }
            }
            catch
            {
                return "Class " + classId;
            }
        }

        private string FormatPhoneNumber(string phone)
        {
            if (string.IsNullOrEmpty(phone)) return "N/A";
            phone = phone.Trim();
            return phone.Length == 10 ? $"{phone.Substring(0, 3)}-{phone.Substring(3, 3)}-{phone.Substring(6)}" : phone;
        }

        private void ShowMessage(string message, string type)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;

            if (type == "success")
            {
                pnlMessage.Style["background-color"] = "#d4edda";
                pnlMessage.Style["border-color"] = "#c3e6cb";
                pnlMessage.Style["color"] = "#155724";
            }
            else if (type == "error")
            {
                pnlMessage.Style["background-color"] = "#f8d7da";
                pnlMessage.Style["border-color"] = "#f5c6cb";
                pnlMessage.Style["color"] = "#721c24";
            }
            else
            {
                pnlMessage.Style["background-color"] = "#cce7ff";
                pnlMessage.Style["border-color"] = "#b3d9ff";
                pnlMessage.Style["color"] = "#004085";
            }
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            // Required for Export to Excel
        }
    }
}