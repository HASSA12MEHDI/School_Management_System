using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class FeeStructure : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
        private int currentFeeId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadClasses();
                LoadFeeStructure();
                ClearForm();
            }
        }

        private void LoadClasses()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT ClassID, ClassName FROM Classes WHERE IsActive = 1 ORDER BY ClassName";
                    SqlCommand cmd = new SqlCommand(query, con);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlClass.DataSource = dt;
                    ddlClass.DataTextField = "ClassName";
                    ddlClass.DataValueField = "ClassID";
                    ddlClass.DataBind();
                    ddlClass.Items.Insert(0, new ListItem("-- Select Class --", ""));
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading classes: " + ex.Message, "error");
            }
        }

        private void LoadFeeStructure()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT FS.FeeId, FS.FeeType, FS.ClassId, C.ClassName, 
                                    FS.Amount, FS.AcademicYear, FS.DueDate, FS.IsActive, FS.CreatedDate 
                                    FROM FeeStructure FS 
                                    INNER JOIN Classes C ON FS.ClassId = C.ClassID 
                                    ORDER BY FS.FeeId DESC";

                    SqlCommand cmd = new SqlCommand(query, con);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvFeeStructure.DataSource = dt;
                    gvFeeStructure.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading fee structure: " + ex.Message, "error");
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                if (ValidateForm())
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        con.Open();

                        if (ViewState["CurrentFeeId"] != null)
                        {
                            currentFeeId = Convert.ToInt32(ViewState["CurrentFeeId"]);

                            // Update existing record
                            string updateQuery = @"UPDATE FeeStructure SET 
                                                FeeType = @FeeType, 
                                                ClassId = @ClassId, 
                                                Amount = @Amount, 
                                                AcademicYear = @AcademicYear, 
                                                DueDate = @DueDate, 
                                                IsActive = @IsActive 
                                                WHERE FeeId = @FeeId";

                            SqlCommand cmd = new SqlCommand(updateQuery, con);
                            SetParameters(cmd);
                            cmd.Parameters.AddWithValue("@FeeId", currentFeeId);

                            int result = cmd.ExecuteNonQuery();
                            if (result > 0)
                            {
                                ShowMessage("Fee structure updated successfully!", "success");
                            }
                        }
                        else
                        {
                            // Insert new record
                            string insertQuery = @"INSERT INTO FeeStructure 
                                                (FeeType, ClassId, Amount, AcademicYear, DueDate, IsActive) 
                                                VALUES 
                                                (@FeeType, @ClassId, @Amount, @AcademicYear, @DueDate, @IsActive)";

                            SqlCommand cmd = new SqlCommand(insertQuery, con);
                            SetParameters(cmd);

                            int result = cmd.ExecuteNonQuery();
                            if (result > 0)
                            {
                                ShowMessage("Fee structure added successfully!", "success");
                            }
                        }
                    }

                    LoadFeeStructure();
                    ClearForm();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving data: " + ex.Message, "error");
            }
        }

        private void SetParameters(SqlCommand cmd)
        {
            cmd.Parameters.AddWithValue("@FeeType", txtFeeType.Text.Trim());
            cmd.Parameters.AddWithValue("@ClassId", Convert.ToInt32(ddlClass.SelectedValue));
            cmd.Parameters.AddWithValue("@Amount", Convert.ToDecimal(txtAmount.Text));
            cmd.Parameters.AddWithValue("@AcademicYear", txtAcademicYear.Text.Trim());

            if (!string.IsNullOrEmpty(txtDueDate.Text))
            {
                cmd.Parameters.AddWithValue("@DueDate", Convert.ToDateTime(txtDueDate.Text));
            }
            else
            {
                cmd.Parameters.AddWithValue("@DueDate", DBNull.Value);
            }

            cmd.Parameters.AddWithValue("@IsActive", Convert.ToBoolean(ddlIsActive.SelectedValue));
        }

        private bool ValidateForm()
        {
            if (string.IsNullOrEmpty(txtFeeType.Text.Trim()))
            {
                ShowMessage("Please enter fee type", "error");
                return false;
            }

            if (string.IsNullOrEmpty(ddlClass.SelectedValue))
            {
                ShowMessage("Please select class", "error");
                return false;
            }

            if (string.IsNullOrEmpty(txtAmount.Text) || !decimal.TryParse(txtAmount.Text, out decimal amount) || amount <= 0)
            {
                ShowMessage("Please enter valid amount", "error");
                return false;
            }

            if (string.IsNullOrEmpty(txtAcademicYear.Text.Trim()))
            {
                ShowMessage("Please enter academic year", "error");
                return false;
            }

            return true;
        }

        protected void gvFeeStructure_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "EditRecord")
                {
                    int feeId = Convert.ToInt32(e.CommandArgument);
                    LoadRecordForEdit(feeId);
                }
                else if (e.CommandName == "DeleteRecord")
                {
                    int feeId = Convert.ToInt32(e.CommandArgument);
                    DeleteRecord(feeId);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error processing request: " + ex.Message, "error");
            }
        }

        private void LoadRecordForEdit(int feeId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM FeeStructure WHERE FeeId = @FeeId";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@FeeId", feeId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        DataRow row = dt.Rows[0];

                        txtFeeType.Text = row["FeeType"].ToString();
                        ddlClass.SelectedValue = row["ClassId"].ToString();
                        txtAmount.Text = row["Amount"].ToString();
                        txtAcademicYear.Text = row["AcademicYear"].ToString();

                        if (row["DueDate"] != DBNull.Value)
                        {
                            DateTime dueDate = Convert.ToDateTime(row["DueDate"]);
                            txtDueDate.Text = dueDate.ToString("yyyy-MM-dd");
                        }

                        ddlIsActive.SelectedValue = row["IsActive"].ToString();
                        ViewState["CurrentFeeId"] = feeId;

                        btnSave.Text = "💾 Update Fee";
                    }
                }

                ShowMessage("Editing fee structure...", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading record for edit: " + ex.Message, "error");
            }
        }

        private void DeleteRecord(int feeId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    string deleteQuery = "DELETE FROM FeeStructure WHERE FeeId = @FeeId";
                    SqlCommand deleteCmd = new SqlCommand(deleteQuery, con);
                    deleteCmd.Parameters.AddWithValue("@FeeId", feeId);

                    int result = deleteCmd.ExecuteNonQuery();
                    if (result > 0)
                    {
                        ShowMessage("Fee structure deleted successfully!", "success");
                    }
                    else
                    {
                        ShowMessage("Record not found or already deleted", "error");
                    }
                }

                LoadFeeStructure();
                ClearForm();
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 547) // Foreign key constraint violation
                {
                    ShowMessage("Cannot delete this fee structure because it has related records in other tables. Please remove related records first.", "error");
                }
                else
                {
                    ShowMessage("Database error: " + sqlEx.Message, "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting record: " + ex.Message, "error");
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
            ShowMessage("Operation cancelled", "success");
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadFeeStructure();
            ShowMessage("Data refreshed successfully!", "success");
        }

        private void ClearForm()
        {
            txtFeeType.Text = "";
            ddlClass.SelectedIndex = 0;
            txtAmount.Text = "";
            txtAcademicYear.Text = "2024-2025";
            txtDueDate.Text = "";
            ddlIsActive.SelectedValue = "true";
            ViewState["CurrentFeeId"] = null;
            btnSave.Text = "💾 Save Fee";
        }

        protected void ShowMessage(string message, string type)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;

            if (type == "success")
            {
                pnlMessage.CssClass = "message message-success";
            }
            else
            {
                pnlMessage.CssClass = "message message-error";
            }

            // Auto hide success messages after 5 seconds
            if (type == "success")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "hideMessage",
                    "setTimeout(function() { document.getElementById('" + pnlMessage.ClientID + "').style.display = 'none'; }, 5000);", true);
            }
        }
    }
}