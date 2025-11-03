using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class Staff : System.Web.UI.Page
    {
        private string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=\"C:\\Programs wbd\\School_Managenment_System12.00\\School_Managenment_System12.00\\App_Data\\School.mdf\";Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindStaffGrid();
                UpdateStatistics();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        string query;
                        if (string.IsNullOrEmpty(hdnStaffId.Value))
                        {
                            // Insert new staff
                            query = @"INSERT INTO Staff (FirstName, LastName, Position, IsActive, CreatedDate) 
                                     VALUES (@FirstName, @LastName, @Position, @IsActive, GETDATE())";
                        }
                        else
                        {
                            // Update existing staff
                            query = @"UPDATE Staff SET FirstName = @FirstName, LastName = @LastName, 
                                     Position = @Position, IsActive = @IsActive 
                                     WHERE StaffId = @StaffId";
                        }

                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            if (!string.IsNullOrEmpty(hdnStaffId.Value))
                            {
                                cmd.Parameters.AddWithValue("@StaffId", hdnStaffId.Value);
                            }

                            cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                            cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                            cmd.Parameters.AddWithValue("@Position", ddlPosition.SelectedValue);
                            cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);

                            con.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    ClearForm();
                    BindStaffGrid();
                    UpdateStatistics();
                    ShowMessage("Staff member saved successfully!", "success");
                }
                catch (Exception ex)
                {
                    ShowMessage("Error saving staff member: " + ex.Message, "error");
                }
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindStaffGrid();
        }

        protected void btnShowAll_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            BindStaffGrid();
        }

        protected void gvStaff_RowEditing(object sender, GridViewEditEventArgs e)
        {
            int staffId = Convert.ToInt32(gvStaff.DataKeys[e.NewEditIndex].Value);
            LoadStaffForEdit(staffId);
            e.Cancel = true; // Cancel edit mode to use our custom form
        }

        protected void gvStaff_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int staffId = Convert.ToInt32(gvStaff.DataKeys[e.RowIndex].Value);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "DELETE FROM Staff WHERE StaffId = @StaffId";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@StaffId", staffId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                BindStaffGrid();
                UpdateStatistics();
                ShowMessage("Staff member deleted successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting staff member: " + ex.Message, "error");
            }
        }

        protected void gvStaff_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvStaff.PageIndex = e.NewPageIndex;
            BindStaffGrid();
        }

        private void BindStaffGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT StaffId, FirstName, LastName, Position, IsActive, CreatedDate 
                                   FROM Staff WHERE 1=1";

                    if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                    {
                        query += " AND (FirstName LIKE @Search OR LastName LIKE @Search OR Position LIKE @Search)";
                    }

                    query += " ORDER BY CreatedDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                        {
                            cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text.Trim() + "%");
                        }

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            gvStaff.DataSource = dt;
                            gvStaff.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading staff data: " + ex.Message, "error");
            }
        }

        private void LoadStaffForEdit(int staffId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM Staff WHERE StaffId = @StaffId";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@StaffId", staffId);
                        con.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                hdnStaffId.Value = reader["StaffId"].ToString();
                                txtFirstName.Text = reader["FirstName"].ToString();
                                txtLastName.Text = reader["LastName"].ToString();
                                ddlPosition.SelectedValue = reader["Position"].ToString();
                                chkIsActive.Checked = Convert.ToBoolean(reader["IsActive"]);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading staff data: " + ex.Message, "error");
            }
        }

        private void UpdateStatistics()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Total staff
                    string totalQuery = "SELECT COUNT(*) FROM Staff";
                    using (SqlCommand cmd = new SqlCommand(totalQuery, con))
                    {
                        totalStaff.InnerText = cmd.ExecuteScalar().ToString();
                    }

                    // Active staff
                    string activeQuery = "SELECT COUNT(*) FROM Staff WHERE IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(activeQuery, con))
                    {
                        activeStaff.InnerText = cmd.ExecuteScalar().ToString();
                    }

                    // Inactive staff
                    string inactiveQuery = "SELECT COUNT(*) FROM Staff WHERE IsActive = 0";
                    using (SqlCommand cmd = new SqlCommand(inactiveQuery, con))
                    {
                        inactiveStaff.InnerText = cmd.ExecuteScalar().ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                // Silently handle errors in statistics
                System.Diagnostics.Debug.WriteLine("Error updating statistics: " + ex.Message);
            }
        }

        private void ClearForm()
        {
            hdnStaffId.Value = "";
            txtFirstName.Text = "";
            txtLastName.Text = "";
            ddlPosition.SelectedIndex = 0;
            chkIsActive.Checked = true;
        }

        private void ShowMessage(string message, string type)
        {
            // You can implement a custom message display here
            // For now, we'll use a simple JavaScript alert
            ScriptManager.RegisterStartupScript(this, GetType(), "showMessage",
                $"alert('{message}');", true);
        }

        protected void gvStaff_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}