using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class Veiw_Classes : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf"";Integrated Security=True";

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

                BindGridView();
            }
        }

        private void BindGridView()
        {
            try
            {
                string query = @"SELECT ClassID, ClassName, Section, Capacity, AcademicYear, 
                                        IsActive, CreatedDate 
                                 FROM Classes 
                                 WHERE 1=1";

                // Build search conditions
                if (!string.IsNullOrEmpty(txtSearchClassName.Text.Trim()))
                {
                    query += " AND ClassName LIKE @ClassName";
                }

                if (!string.IsNullOrEmpty(txtSearchSection.Text.Trim()))
                {
                    query += " AND Section LIKE @Section";
                }

                if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
                {
                    query += " AND IsActive = @IsActive";
                }

                query += " ORDER BY CreatedDate DESC";

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (!string.IsNullOrEmpty(txtSearchClassName.Text.Trim()))
                        {
                            cmd.Parameters.AddWithValue("@ClassName", "%" + txtSearchClassName.Text.Trim() + "%");
                        }

                        if (!string.IsNullOrEmpty(txtSearchSection.Text.Trim()))
                        {
                            cmd.Parameters.AddWithValue("@Section", "%" + txtSearchSection.Text.Trim() + "%");
                        }

                        if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
                        {
                            cmd.Parameters.AddWithValue("@IsActive", Convert.ToBoolean(ddlStatus.SelectedValue));
                        }

                        con.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvClasses.DataSource = dt;
                        gvClasses.DataBind();

                        if (dt.Rows.Count == 0)
                        {
                            ShowMessage("No classes found matching your search criteria.", "info");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading classes: " + ex.Message, "error");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindGridView();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearchClassName.Text = "";
            txtSearchSection.Text = "";
            ddlStatus.SelectedValue = "";
            BindGridView();
        }

        protected void gvClasses_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvClasses.EditIndex = e.NewEditIndex;
            BindGridView();
            ShowMessage("You are now editing the selected class.", "info");
        }

        protected void gvClasses_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                int classId = Convert.ToInt32(gvClasses.DataKeys[e.RowIndex].Value);

                string className = (gvClasses.Rows[e.RowIndex].FindControl("txtClassName") as TextBox)?.Text.Trim();
                string section = (gvClasses.Rows[e.RowIndex].FindControl("txtSection") as TextBox)?.Text.Trim();
                string capacityText = (gvClasses.Rows[e.RowIndex].FindControl("txtCapacity") as TextBox)?.Text.Trim();
                string academicYear = (gvClasses.Rows[e.RowIndex].FindControl("txtAcademicYear") as TextBox)?.Text.Trim();
                CheckBox chkIsActive = gvClasses.Rows[e.RowIndex].FindControl("chkIsActive") as CheckBox;

                if (string.IsNullOrEmpty(className))
                {
                    ShowMessage("Class name is required!", "error");
                    return;
                }

                int? capacity = null;
                if (!string.IsNullOrEmpty(capacityText) && int.TryParse(capacityText, out int cap))
                {
                    capacity = cap;
                }

                string updateQuery = @"UPDATE Classes 
                                      SET ClassName = @ClassName, 
                                          Section = @Section, 
                                          Capacity = @Capacity, 
                                          AcademicYear = @AcademicYear, 
                                          IsActive = @IsActive 
                                      WHERE ClassID = @ClassID";

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@ClassName", className);
                        cmd.Parameters.AddWithValue("@Section", string.IsNullOrEmpty(section) ? (object)DBNull.Value : section.ToUpper());
                        cmd.Parameters.AddWithValue("@Capacity", capacity.HasValue ? (object)capacity.Value : DBNull.Value);
                        cmd.Parameters.AddWithValue("@AcademicYear", string.IsNullOrEmpty(academicYear) ? (object)DBNull.Value : academicYear);
                        cmd.Parameters.AddWithValue("@IsActive", chkIsActive?.Checked ?? true);
                        cmd.Parameters.AddWithValue("@ClassID", classId);

                        con.Open();
                        int result = cmd.ExecuteNonQuery();

                        if (result > 0)
                        {
                            gvClasses.EditIndex = -1;
                            BindGridView();
                            ShowMessage("Class updated successfully!", "success");
                        }
                        else
                        {
                            ShowMessage("Error updating class.", "error");
                        }
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 2627)
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
                ShowMessage("Error updating class: " + ex.Message, "error");
            }
        }

        protected void gvClasses_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvClasses.EditIndex = -1;
            BindGridView();
            ShowMessage("Edit cancelled.", "info");
        }

        protected void gvClasses_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int classId = Convert.ToInt32(gvClasses.DataKeys[e.RowIndex].Value);

                string deleteQuery = "DELETE FROM Classes WHERE ClassID = @ClassID";

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(deleteQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@ClassID", classId);
                        con.Open();
                        int result = cmd.ExecuteNonQuery();

                        if (result > 0)
                        {
                            BindGridView();
                            ShowMessage("Class deleted successfully!", "success");
                        }
                        else
                        {
                            ShowMessage("Error deleting class.", "error");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting class: " + ex.Message, "error");
            }
        }

        protected void gvClasses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvClasses.PageIndex = e.NewPageIndex;
            BindGridView();
        }

        protected void btnAddNew_Click(object sender, EventArgs e)
        {
            Response.Redirect("Classes.aspx");
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            try
            {
                // Export to Excel functionality
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=Classes_Export_" + DateTime.Now.ToString("yyyyMMdd") + ".xls");
                Response.Charset = "";
                Response.ContentType = "application/vnd.ms-excel";

                StringWriter sw = new StringWriter();
                HtmlTextWriter hw = new HtmlTextWriter(sw);

                // Apply styles for export
                gvClasses.HeaderStyle.BackColor = System.Drawing.Color.LightGray;
                gvClasses.HeaderStyle.Font.Bold = true;

                gvClasses.RenderControl(hw);

                Response.Output.Write(sw.ToString());
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                ShowMessage("Error exporting data: " + ex.Message, "error");
            }
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            // Required for Export to Excel
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = type == "success" ? "message success" : type == "error" ? "message error" : "message info";
            lblMessage.Visible = true;

            // Auto hide success messages after 5 seconds
            if (type == "success")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "hideMessage",
                    "setTimeout(function() { document.getElementById('" + lblMessage.ClientID + "').style.display = 'none'; }, 5000);", true);
            }
        }
    }
}