using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class LibrarySettings : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadPageTitle();
                LoadSettings();
            }
        }

        private void LoadPageTitle()
        {
            if (Master != null)
            {
                Label lblPageTitle = (Label)Master.FindControl("lblPageTitle");
                if (lblPageTitle != null)
                {
                    lblPageTitle.Text = "Library Settings";
                }
            }
        }

        private void LoadSettings()
        {
            try
            {
                string query = "SELECT SettingKey, SettingValue FROM LibrarySettings";
                DataTable settingsTable = new DataTable();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(settingsTable);
                    }
                }

                if (settingsTable.Rows.Count > 0)
                {
                    // Populate form fields with existing settings
                    foreach (DataRow row in settingsTable.Rows)
                    {
                        string key = row["SettingKey"].ToString();
                        string value = row["SettingValue"].ToString();

                        switch (key)
                        {
                            case "IssueDurationDays":
                                txtIssueDuration.Text = value;
                                break;
                            case "MaxBooksPerStudent":
                                txtMaxBooks.Text = value;
                                break;
                            case "RenewalDays":
                                txtRenewalDays.Text = value;
                                break;
                            case "FinePerDay":
                                txtFinePerDay.Text = value;
                                break;
                            case "GracePeriod":
                                txtGracePeriod.Text = value;
                                break;
                            case "MaxFineAmount":
                                txtMaxFine.Text = value;
                                break;
                            case "LibraryName":
                                txtLibraryName.Text = value;
                                break;
                            case "AcademicYear":
                                txtAcademicYear.Text = value;
                                break;
                            case "ContactEmail":
                                txtContactEmail.Text = value;
                                break;
                            case "IssueTime":
                                txtIssueTime.Text = value;
                                break;
                            case "ReturnTime":
                                txtReturnTime.Text = value;
                                break;
                            case "AutoRenewal":
                                cbAutoRenewal.Checked = bool.Parse(value);
                                break;
                            case "SendNotifications":
                                cbSendNotifications.Checked = bool.Parse(value);
                                break;
                        }
                    }
                    pnlSettings.Visible = true;
                    lblNoSettings.Visible = false;
                }
                else
                {
                    // No settings found, load defaults
                    LoadDefaultSettings();
                    pnlSettings.Visible = true;
                    lblNoSettings.Visible = false;
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading settings: " + ex.Message);
            }
        }

        private void LoadDefaultSettings()
        {
            // Set default values
            txtIssueDuration.Text = "14";
            txtMaxBooks.Text = "3";
            txtRenewalDays.Text = "7";
            txtFinePerDay.Text = "5.00";
            txtGracePeriod.Text = "0";
            txtMaxFine.Text = "50.00";
            txtLibraryName.Text = "School Library";
            txtAcademicYear.Text = "2024-2025";
            txtContactEmail.Text = "library@school.edu";
            txtIssueTime.Text = "08:00";
            txtReturnTime.Text = "14:00";
            cbAutoRenewal.Checked = false;
            cbSendNotifications.Checked = true;
        }

        protected void btnSaveSettings_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                // Define all settings to save
                var settings = new System.Collections.Generic.Dictionary<string, string>
                {
                    { "IssueDurationDays", txtIssueDuration.Text },
                    { "MaxBooksPerStudent", txtMaxBooks.Text },
                    { "RenewalDays", txtRenewalDays.Text },
                    { "FinePerDay", txtFinePerDay.Text },
                    { "GracePeriod", txtGracePeriod.Text },
                    { "MaxFineAmount", txtMaxFine.Text },
                    { "LibraryName", txtLibraryName.Text },
                    { "AcademicYear", txtAcademicYear.Text },
                    { "ContactEmail", txtContactEmail.Text },
                    { "IssueTime", txtIssueTime.Text },
                    { "ReturnTime", txtReturnTime.Text },
                    { "AutoRenewal", cbAutoRenewal.Checked.ToString() },
                    { "SendNotifications", cbSendNotifications.Checked.ToString() }
                };

                // Save each setting
                foreach (var setting in settings)
                {
                    SaveSetting(setting.Key, setting.Value);
                }

                ShowSuccessMessage("Library settings updated successfully!");
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error saving settings: " + ex.Message);
            }
        }

        private void SaveSetting(string key, string value)
        {
            string query = @"MERGE LibrarySettings AS target
                           USING (SELECT @Key AS SettingKey, @Value AS SettingValue) AS source
                           ON target.SettingKey = source.SettingKey
                           WHEN MATCHED THEN
                               UPDATE SET SettingValue = source.SettingValue
                           WHEN NOT MATCHED THEN
                               INSERT (SettingKey, SettingValue) VALUES (source.SettingKey, source.SettingValue);";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Key", key);
                    cmd.Parameters.AddWithValue("@Value", value);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void btnResetDefaults_Click(object sender, EventArgs e)
        {
            try
            {
                // Clear existing settings
                string clearQuery = "DELETE FROM LibrarySettings";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(clearQuery, conn))
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Insert default settings
                InsertDefaultSettings();

                // Reload the form with default values
                LoadDefaultSettings();
                ShowSuccessMessage("Settings reset to default values successfully!");
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error resetting settings: " + ex.Message);
            }
        }

        private void InsertDefaultSettings()
        {
            var defaultSettings = new System.Collections.Generic.Dictionary<string, string>
            {
                { "IssueDurationDays", "14" },
                { "MaxBooksPerStudent", "3" },
                { "RenewalDays", "7" },
                { "FinePerDay", "5.00" },
                { "GracePeriod", "0" },
                { "MaxFineAmount", "50.00" },
                { "LibraryName", "School Library" },
                { "AcademicYear", "2024-2025" },
                { "ContactEmail", "library@school.edu" },
                { "IssueTime", "08:00" },
                { "ReturnTime", "14:00" },
                { "AutoRenewal", "False" },
                { "SendNotifications", "True" }
            };

            foreach (var setting in defaultSettings)
            {
                SaveSetting(setting.Key, setting.Value);
            }
        }

        protected void btnClearAllData_Click(object sender, EventArgs e)
        {
            try
            {
                // Clear all transaction data but keep settings
                string clearTransactions = "DELETE FROM BookTransactions";
                string resetBooks = "UPDATE Books SET AvailableCopies = TotalCopies";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    using (SqlCommand cmd1 = new SqlCommand(clearTransactions, conn))
                    {
                        cmd1.ExecuteNonQuery();
                    }

                    using (SqlCommand cmd2 = new SqlCommand(resetBooks, conn))
                    {
                        cmd2.ExecuteNonQuery();
                    }
                }

                ShowSuccessMessage("All transaction data cleared successfully! Book availability has been reset.");
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error clearing transaction data: " + ex.Message);
            }
        }

        protected void btnResetAllSettings_Click(object sender, EventArgs e)
        {
            try
            {
                // Clear all settings and transactions
                string clearSettings = "DELETE FROM LibrarySettings";
                string clearTransactions = "DELETE FROM BookTransactions";
                string resetBooks = "UPDATE Books SET AvailableCopies = TotalCopies";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    using (SqlCommand cmd1 = new SqlCommand(clearSettings, conn))
                    {
                        cmd1.ExecuteNonQuery();
                    }

                    using (SqlCommand cmd2 = new SqlCommand(clearTransactions, conn))
                    {
                        cmd2.ExecuteNonQuery();
                    }

                    using (SqlCommand cmd3 = new SqlCommand(resetBooks, conn))
                    {
                        cmd3.ExecuteNonQuery();
                    }
                }

                // Reload default settings
                InsertDefaultSettings();
                LoadDefaultSettings();

                ShowSuccessMessage("Entire system reset successfully! All settings restored to defaults and transaction data cleared.");
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error resetting system: " + ex.Message);
            }
        }

        private void ShowSuccessMessage(string message)
        {
            pnlSuccess.Visible = true;
            lblSuccessMessage.Text = message;

            // Hide success message after 5 seconds
            ScriptManager.RegisterStartupScript(this, GetType(), "HideSuccess",
                "setTimeout(function() { document.getElementById('" + pnlSuccess.ClientID + "').style.display = 'none'; }, 5000);", true);
        }

        private void ShowErrorMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                $"showNotification('{message.Replace("'", "\\'")}', 'error');", true);
        }
    }
}