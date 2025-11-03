using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace School_Managenment_System12._00
{
    public partial class FeeConcessions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set the page title in the master page
                if (Master != null)
                {
                    var lblPageTitle = (Label)Master.FindControl("lblPageTitle");
                    if (lblPageTitle != null)
                    {
                        lblPageTitle.Text = "Fee Concessions";
                    }
                }

                LoadDropdowns();
                LoadConcessions();
                LoadStatistics();
                ClearForm();
            }
        }

        private void LoadDropdowns()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connectionString))
            {
                ShowAlert("Database connection not configured.", "danger");
                return;
            }

            // Load Students
            string studentsQuery = "SELECT StudentId, FirstName + ' ' + LastName AS StudentName FROM Students WHERE IsActive = 1 ORDER BY FirstName";
            // Load Fee Types
            string feesQuery = "SELECT FeeId, FeeType FROM FeeStructure WHERE IsActive = 1 ORDER BY FeeType";
            // Load Approvers
            string approversQuery = "SELECT UserId, Username FROM Users WHERE IsActive = 1 ORDER BY Username";

            using (var con = new SqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    // Load Students
                    using (var studentsCmd = new SqlCommand(studentsQuery, con))
                    using (var studentsReader = studentsCmd.ExecuteReader())
                    {
                        ddlStudent.DataSource = studentsReader;
                        ddlStudent.DataTextField = "StudentName";
                        ddlStudent.DataValueField = "StudentId";
                        ddlStudent.DataBind();
                    }

                    // Load Fee Types
                    using (var feesCmd = new SqlCommand(feesQuery, con))
                    using (var feesReader = feesCmd.ExecuteReader())
                    {
                        ddlFee.DataSource = feesReader;
                        ddlFee.DataTextField = "FeeType";
                        ddlFee.DataValueField = "FeeId";
                        ddlFee.DataBind();
                    }

                    // Load Approvers
                    using (var approversCmd = new SqlCommand(approversQuery, con))
                    using (var approversReader = approversCmd.ExecuteReader())
                    {
                        ddlApprovedBy.DataSource = approversReader;
                        ddlApprovedBy.DataTextField = "Username";
                        ddlApprovedBy.DataValueField = "UserId";
                        ddlApprovedBy.DataBind();
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading dropdown data: " + ex.Message, "danger");
                }
            }
        }

        private void LoadConcessions()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connectionString))
            {
                ShowAlert("Database connection not configured.", "danger");
                return;
            }

            string query = @"SELECT 
                    fc.ConcessionId,
                    s.FirstName + ' ' + s.LastName AS StudentName,
                    fs.FeeType,
                    fc.ConcessionType,
                    fc.DiscountPercent,
                    fc.DiscountAmount,
                    fc.Reason,
                    fc.ValidFrom,
                    fc.ValidTo,
                    fc.IsActive,
                    u.Username AS ApprovedByName
                    FROM FeeConcessions fc
                    INNER JOIN Students s ON fc.StudentId = s.StudentId
                    INNER JOIN FeeStructure fs ON fc.FeeId = fs.FeeId
                    INNER JOIN Users u ON fc.ApprovedBy = u.UserId
                    WHERE 1=1";

            // Add search filter
            if (!string.IsNullOrEmpty(txtSearch.Text))
            {
                query += " AND (s.FirstName LIKE @Search OR s.LastName LIKE @Search OR fs.FeeType LIKE @Search OR fc.ConcessionType LIKE @Search)";
            }

            // Add type filter
            if (!string.IsNullOrEmpty(ddlTypeFilter.SelectedValue))
            {
                query += " AND fc.ConcessionType = @ConcessionType";
            }

            // Add status filter
            if (!string.IsNullOrEmpty(ddlStatusFilter.SelectedValue))
            {
                switch (ddlStatusFilter.SelectedValue)
                {
                    case "Active":
                        query += " AND fc.IsActive = 1 AND fc.ValidTo >= GETDATE()";
                        break;
                    case "Inactive":
                        query += " AND fc.IsActive = 0";
                        break;
                    case "Expired":
                        query += " AND fc.ValidTo < GETDATE()";
                        break;
                }
            }

            query += " ORDER BY fc.ValidFrom DESC";

            using (var con = new SqlConnection(connectionString))
            using (var cmd = new SqlCommand(query, con))
            {
                if (!string.IsNullOrEmpty(txtSearch.Text))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text + "%");
                }

                if (!string.IsNullOrEmpty(ddlTypeFilter.SelectedValue))
                {
                    cmd.Parameters.AddWithValue("@ConcessionType", ddlTypeFilter.SelectedValue);
                }

                try
                {
                    con.Open();
                    var da = new SqlDataAdapter(cmd);
                    var dt = new DataTable();
                    da.Fill(dt);
                    gvConcessions.DataSource = dt;
                    gvConcessions.DataBind();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading concessions: " + ex.Message, "danger");
                }
            }
        }

        private void LoadStatistics()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connectionString))
            {
                SetDefaultStatistics();
                return;
            }

            using (var con = new SqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    // Total Concessions
                    string totalQuery = "SELECT COUNT(*) FROM FeeConcessions";
                    using (var totalCmd = new SqlCommand(totalQuery, con))
                    {
                        int totalConcessions = Convert.ToInt32(totalCmd.ExecuteScalar());
                        lblTotalConcessions.Text = totalConcessions.ToString();
                    }

                    // Active Concessions
                    string activeQuery = "SELECT COUNT(*) FROM FeeConcessions WHERE IsActive = 1 AND ValidTo >= GETDATE()";
                    using (var activeCmd = new SqlCommand(activeQuery, con))
                    {
                        int activeConcessions = Convert.ToInt32(activeCmd.ExecuteScalar());
                        lblActiveConcessions.Text = activeConcessions.ToString();
                    }

                    // Total Discount
                    decimal totalDiscount = 0;

                    // Calculate discount amount for fixed amount concessions
                    string amountQuery = "SELECT ISNULL(SUM(DiscountAmount), 0) FROM FeeConcessions WHERE IsActive = 1 AND ValidTo >= GETDATE() AND DiscountAmount IS NOT NULL";
                    using (var amountCmd = new SqlCommand(amountQuery, con))
                    {
                        decimal amountDiscount = Convert.ToDecimal(amountCmd.ExecuteScalar());
                        totalDiscount += amountDiscount;
                    }

                    // Calculate discount amount for percentage concessions
                    string percentQuery = @"SELECT ISNULL(SUM(fs.Amount * (fc.DiscountPercent / 100.0)), 0) 
                                  FROM FeeConcessions fc
                                  INNER JOIN FeeStructure fs ON fc.FeeId = fs.FeeId
                                  WHERE fc.IsActive = 1 AND fc.ValidTo >= GETDATE() AND fc.DiscountPercent IS NOT NULL";
                    using (var percentCmd = new SqlCommand(percentQuery, con))
                    {
                        decimal percentDiscount = Convert.ToDecimal(percentCmd.ExecuteScalar());
                        totalDiscount += percentDiscount;
                    }

                    lblTotalDiscount.Text = "Rs " + totalDiscount.ToString("N2");

                    // Expiring Soon
                    string expiringQuery = "SELECT COUNT(*) FROM FeeConcessions WHERE ValidTo BETWEEN GETDATE() AND DATEADD(day, 30, GETDATE()) AND IsActive = 1";
                    using (var expiringCmd = new SqlCommand(expiringQuery, con))
                    {
                        int expiringSoon = Convert.ToInt32(expiringCmd.ExecuteScalar());
                        lblExpiringSoon.Text = expiringSoon.ToString();
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading statistics: " + ex.Message, "danger");
                    SetDefaultStatistics();
                }
            }
        }

        private void SetDefaultStatistics()
        {
            lblTotalConcessions.Text = "0";
            lblActiveConcessions.Text = "0";
            lblTotalDiscount.Text = "Rs 0";
            lblExpiringSoon.Text = "0";
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;

                if (string.IsNullOrEmpty(connectionString))
                {
                    ShowAlert("Database connection not configured.", "danger");
                    return;
                }

                string query;
                bool isEdit = !string.IsNullOrEmpty(hfConcessionId.Value);

                if (isEdit)
                {
                    query = @"UPDATE FeeConcessions SET 
                             StudentId = @StudentId, FeeId = @FeeId, ConcessionType = @ConcessionType,
                             DiscountPercent = @DiscountPercent, DiscountAmount = @DiscountAmount,
                             Reason = @Reason, ApprovedBy = @ApprovedBy, ValidFrom = @ValidFrom,
                             ValidTo = @ValidTo, IsActive = @IsActive
                             WHERE ConcessionId = @ConcessionId";
                }
                else
                {
                    query = @"INSERT INTO FeeConcessions 
                             (StudentId, FeeId, ConcessionType, DiscountPercent, DiscountAmount, 
                              Reason, ApprovedBy, ValidFrom, ValidTo, IsActive)
                             VALUES 
                             (@StudentId, @FeeId, @ConcessionType, @DiscountPercent, @DiscountAmount,
                              @Reason, @ApprovedBy, @ValidFrom, @ValidTo, @IsActive)";
                }

                using (var con = new SqlConnection(connectionString))
                using (var cmd = new SqlCommand(query, con))
                {
                    // Set parameters
                    cmd.Parameters.AddWithValue("@StudentId", int.Parse(ddlStudent.SelectedValue));
                    cmd.Parameters.AddWithValue("@FeeId", int.Parse(ddlFee.SelectedValue));
                    cmd.Parameters.AddWithValue("@ConcessionType", ddlConcessionType.SelectedValue);

                    // Handle discount values (one should be null)
                    if (!string.IsNullOrEmpty(txtDiscountPercent.Text))
                    {
                        cmd.Parameters.AddWithValue("@DiscountPercent", decimal.Parse(txtDiscountPercent.Text));
                        cmd.Parameters.AddWithValue("@DiscountAmount", DBNull.Value);
                    }
                    else if (!string.IsNullOrEmpty(txtDiscountAmount.Text))
                    {
                        cmd.Parameters.AddWithValue("@DiscountPercent", DBNull.Value);
                        cmd.Parameters.AddWithValue("@DiscountAmount", decimal.Parse(txtDiscountAmount.Text));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@DiscountPercent", DBNull.Value);
                        cmd.Parameters.AddWithValue("@DiscountAmount", DBNull.Value);
                    }

                    cmd.Parameters.AddWithValue("@Reason", txtReason.Text.Trim());
                    cmd.Parameters.AddWithValue("@ApprovedBy", int.Parse(ddlApprovedBy.SelectedValue));
                    cmd.Parameters.AddWithValue("@ValidFrom", DateTime.Parse(txtValidFrom.Text));
                    cmd.Parameters.AddWithValue("@ValidTo", DateTime.Parse(txtValidTo.Text));
                    cmd.Parameters.AddWithValue("@IsActive", cbIsActive.Checked);

                    if (isEdit)
                    {
                        cmd.Parameters.AddWithValue("@ConcessionId", int.Parse(hfConcessionId.Value));
                    }

                    try
                    {
                        con.Open();
                        int result = cmd.ExecuteNonQuery();

                        if (result > 0)
                        {
                            string message = isEdit ? "Concession updated successfully!" : "Concession created successfully!";
                            ShowAlert(message, "success");
                            LoadConcessions();
                            LoadStatistics();
                            ClearForm();
                        }
                        else
                        {
                            ShowAlert("Error saving concession.", "danger");
                        }
                    }
                    catch (SqlException ex)
                    {
                        if (ex.Number == 2627) // Unique constraint
                        {
                            ShowAlert("A concession for this student and fee type already exists.", "danger");
                        }
                        else
                        {
                            ShowAlert("Database error: " + ex.Message, "danger");
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowAlert("Error saving concession: " + ex.Message, "danger");
                    }
                }
            }
        }

        protected void CvDiscount_ServerValidate(object source, ServerValidateEventArgs args)
        {
            // Validate that only one discount field is filled
            bool hasPercent = !string.IsNullOrEmpty(txtDiscountPercent.Text);
            bool hasAmount = !string.IsNullOrEmpty(txtDiscountAmount.Text);

            args.IsValid = (hasPercent && !hasAmount) || (!hasPercent && hasAmount) || (!hasPercent && !hasAmount);
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
            ShowAlert("Form cancelled.", "info");
        }

        protected void GvConcessions_RowEditing(object sender, GridViewEditEventArgs e)
        {
            int concessionId = Convert.ToInt32(gvConcessions.DataKeys[e.NewEditIndex].Value);
            LoadConcessionForEdit(concessionId);
            e.Cancel = true;
            ShowAlert("Editing concession...", "info");
        }

        protected void GvConcessions_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int concessionId = Convert.ToInt32(gvConcessions.DataKeys[e.RowIndex].Value);
            DeleteConcession(concessionId);
        }

        protected void GvConcessions_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvConcessions.PageIndex = e.NewPageIndex;
            LoadConcessions();
        }

        protected void TxtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadConcessions();
        }

        protected void DdlTypeFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadConcessions();
        }

        protected void DdlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadConcessions();
        }

        protected void BtnExport_Click(object sender, EventArgs e)
        {
            ExportToExcel();
        }

        protected void GvConcessions_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Add confirmation for delete
                var btnDelete = (LinkButton)e.Row.FindControl("btnDelete");
                if (btnDelete != null)
                {
                    btnDelete.OnClientClick = "return confirm('Are you sure you want to delete this concession?');";
                }

                // Highlight expired concessions
                var rowView = (DataRowView)e.Row.DataItem;
                DateTime validTo = Convert.ToDateTime(rowView["ValidTo"]);
                bool isActive = Convert.ToBoolean(rowView["IsActive"]);

                if (validTo < DateTime.Now && isActive)
                {
                    e.Row.Style.Add("background-color", "rgba(255, 107, 107, 0.1)");
                }
            }
        }

        private void LoadConcessionForEdit(int concessionId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connectionString))
            {
                ShowAlert("Database connection not configured.", "danger");
                return;
            }

            string query = @"SELECT ConcessionId, StudentId, FeeId, ConcessionType, DiscountPercent, 
                           DiscountAmount, Reason, ApprovedBy, ValidFrom, ValidTo, IsActive
                           FROM FeeConcessions WHERE ConcessionId = @ConcessionId";

            using (var con = new SqlConnection(connectionString))
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@ConcessionId", concessionId);

                try
                {
                    con.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            hfConcessionId.Value = reader["ConcessionId"].ToString();
                            ddlStudent.SelectedValue = reader["StudentId"].ToString();
                            ddlFee.SelectedValue = reader["FeeId"].ToString();
                            ddlConcessionType.SelectedValue = reader["ConcessionType"].ToString();

                            // Handle discount values
                            if (reader["DiscountPercent"] != DBNull.Value)
                            {
                                txtDiscountPercent.Text = Convert.ToDecimal(reader["DiscountPercent"]).ToString("F2");
                                txtDiscountAmount.Text = "";
                            }
                            else if (reader["DiscountAmount"] != DBNull.Value)
                            {
                                txtDiscountAmount.Text = Convert.ToDecimal(reader["DiscountAmount"]).ToString("F2");
                                txtDiscountPercent.Text = "";
                            }

                            txtReason.Text = reader["Reason"].ToString();
                            ddlApprovedBy.SelectedValue = reader["ApprovedBy"].ToString();
                            txtValidFrom.Text = Convert.ToDateTime(reader["ValidFrom"]).ToString("yyyy-MM-dd");
                            txtValidTo.Text = Convert.ToDateTime(reader["ValidTo"]).ToString("yyyy-MM-dd");
                            cbIsActive.Checked = Convert.ToBoolean(reader["IsActive"]);

                            lblFormTitle.Text = "Edit Concession";
                            btnSave.Text = "Update Concession";

                            // Scroll to form using JavaScript
                            ScriptManager.RegisterStartupScript(this, GetType(), "scrollToForm",
                                "document.querySelector('.form-section').scrollIntoView({ behavior: 'smooth' });", true);
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading concession for edit: " + ex.Message, "danger");
                }
            }
        }

        private void DeleteConcession(int concessionId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connectionString))
            {
                ShowAlert("Database connection not configured.", "danger");
                return;
            }

            string query = "DELETE FROM FeeConcessions WHERE ConcessionId = @ConcessionId";

            using (var con = new SqlConnection(connectionString))
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@ConcessionId", concessionId);

                try
                {
                    con.Open();
                    int result = cmd.ExecuteNonQuery();

                    if (result > 0)
                    {
                        ShowAlert("Concession deleted successfully!", "success");
                        LoadConcessions();
                        LoadStatistics();
                    }
                    else
                    {
                        ShowAlert("Error deleting concession.", "danger");
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error deleting concession: " + ex.Message, "danger");
                }
            }
        }

        private void ExportToExcel()
        {
            try
            {
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=FeeConcessions_" + DateTime.Now.ToString("yyyyMMdd") + ".xls");
                Response.Charset = "";
                Response.ContentType = "application/vnd.ms-excel";

                using (var sw = new StringWriter())
                using (var hw = new HtmlTextWriter(sw))
                {
                    // Create a temporary GridView for export
                    var gvExport = new GridView
                    {
                        DataSource = gvConcessions.DataSource
                    };
                    gvExport.DataBind();

                    // Apply styling
                    gvExport.HeaderStyle.BackColor = System.Drawing.Color.DarkBlue;
                    gvExport.HeaderStyle.ForeColor = System.Drawing.Color.White;
                    gvExport.HeaderStyle.Font.Bold = true;

                    gvExport.RenderControl(hw);

                    Response.Output.Write(sw.ToString());
                    Response.Flush();
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error exporting to Excel: " + ex.Message, "danger");
            }
        }

        private void ClearForm()
        {
            hfConcessionId.Value = string.Empty;
            ddlStudent.SelectedIndex = 0;
            ddlFee.SelectedIndex = 0;
            ddlConcessionType.SelectedIndex = 0;
            txtDiscountPercent.Text = string.Empty;
            txtDiscountAmount.Text = string.Empty;
            txtReason.Text = string.Empty;
            ddlApprovedBy.SelectedIndex = 0;
            txtValidFrom.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtValidTo.Text = DateTime.Now.AddYears(1).ToString("yyyy-MM-dd");
            cbIsActive.Checked = true;

            lblFormTitle.Text = "Add New Concession";
            btnSave.Text = "Save Concession";
        }

        // UPDATED ALERT METHOD - Fixed to work with new alert system
        private void ShowAlert(string message, string type)
        {
            // Register JavaScript to show the alert
            string script = $@"showServerAlert('{type}', '{message.Replace("'", "\\'")}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowAlert", script, true);
        }

        // Helper methods for status display
        public string GetStatusClass(object isActive, object validTo)
        {
            if (isActive == DBNull.Value || validTo == DBNull.Value)
                return "status-inactive";

            bool active = Convert.ToBoolean(isActive);
            DateTime toDate = Convert.ToDateTime(validTo);

            if (!active)
                return "status-inactive";
            else if (toDate < DateTime.Now)
                return "status-expired";
            else
                return "status-active";
        }

        public string GetStatusText(object isActive, object validTo)
        {
            if (isActive == DBNull.Value || validTo == DBNull.Value)
                return "Inactive";

            bool active = Convert.ToBoolean(isActive);
            DateTime toDate = Convert.ToDateTime(validTo);

            if (!active)
                return "Inactive";
            else if (toDate < DateTime.Now)
                return "Expired";
            else
                return "Active";
        }

        public string GetDiscountDisplay(object discountPercent, object discountAmount)
        {
            if (discountPercent != DBNull.Value && discountPercent != null && !string.IsNullOrEmpty(discountPercent.ToString()))
            {
                if (decimal.TryParse(discountPercent.ToString(), out decimal percent))
                {
                    return $"{percent:F2}%";
                }
            }
            else if (discountAmount != DBNull.Value && discountAmount != null && !string.IsNullOrEmpty(discountAmount.ToString()))
            {
                if (decimal.TryParse(discountAmount.ToString(), out decimal amount))
                {
                    return $"Rs {amount:F2}";
                }
            }
            return "N/A";
        }
    }
}