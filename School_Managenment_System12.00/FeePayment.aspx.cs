using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class FeePayment : System.Web.UI.Page
    {
        private string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf"";Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropdownData();
                LoadPaymentHistory();
                txtPaymentDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            }
        }

        private void LoadDropdownData()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Load Students
                    string studentQuery = "SELECT StudentId, FirstName + ' ' + LastName AS StudentName FROM Students ORDER BY FirstName";
                    SqlDataAdapter studentAdapter = new SqlDataAdapter(studentQuery, conn);
                    DataTable studentTable = new DataTable();
                    studentAdapter.Fill(studentTable);

                    ddlStudent.DataSource = studentTable;
                    ddlStudent.DataTextField = "StudentName";
                    ddlStudent.DataValueField = "StudentId";
                    ddlStudent.DataBind();
                    ddlStudent.Items.Insert(0, new ListItem("Select Student", ""));

                    // Load Fee Structure
                    string feeQuery = "SELECT FeeId, FeeType FROM FeeStructure ORDER BY FeeType";
                    SqlDataAdapter feeAdapter = new SqlDataAdapter(feeQuery, conn);
                    DataTable feeTable = new DataTable();
                    feeAdapter.Fill(feeTable);

                    ddlFee.DataSource = feeTable;
                    ddlFee.DataTextField = "FeeType";
                    ddlFee.DataValueField = "FeeId";
                    ddlFee.DataBind();
                    ddlFee.Items.Insert(0, new ListItem("Select Fee Type", ""));

                    // Load Users (Received By)
                    string userQuery = "SELECT UserId, UserName FROM Users ORDER BY UserName";
                    SqlDataAdapter userAdapter = new SqlDataAdapter(userQuery, conn);
                    DataTable userTable = new DataTable();
                    userAdapter.Fill(userTable);

                    ddlReceivedBy.DataSource = userTable;
                    ddlReceivedBy.DataTextField = "UserName";
                    ddlReceivedBy.DataValueField = "UserId";
                    ddlReceivedBy.DataBind();
                    ddlReceivedBy.Items.Insert(0, new ListItem("Select User", ""));
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading data: {ex.Message}", "danger");
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (!ValidateForm())
                return;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"INSERT INTO FeePayments 
                                   (StudentId, FeeId, AmountPaid, PaymentDate, PaymentMode, TransactionId, ReceivedBy, Remarks)
                                   VALUES (@StudentId, @FeeId, @AmountPaid, @PaymentDate, @PaymentMode, @TransactionId, @ReceivedBy, @Remarks)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentId", ddlStudent.SelectedValue);
                        cmd.Parameters.AddWithValue("@FeeId", ddlFee.SelectedValue);
                        cmd.Parameters.AddWithValue("@AmountPaid", decimal.Parse(txtAmount.Text));
                        cmd.Parameters.AddWithValue("@PaymentDate", DateTime.Parse(txtPaymentDate.Text));
                        cmd.Parameters.AddWithValue("@PaymentMode", ddlPaymentMode.SelectedValue);
                        cmd.Parameters.AddWithValue("@TransactionId", txtTransactionId.Text.Trim());
                        cmd.Parameters.AddWithValue("@ReceivedBy", ddlReceivedBy.SelectedValue);
                        cmd.Parameters.AddWithValue("@Remarks", txtRemarks.Text.Trim());

                        int rowsAffected = cmd.ExecuteNonQuery();
                        if (rowsAffected > 0)
                        {
                            ShowMessage("Payment recorded successfully!", "success");
                            ClearForm();
                            LoadPaymentHistory();
                        }
                        else
                        {
                            ShowMessage("No records were affected. Please try again.", "danger");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error saving payment: {ex.Message}", "danger");
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            ShowMessage("Form cleared successfully.", "success");
        }

        protected void gvPaymentHistory_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPaymentHistory.PageIndex = e.NewPageIndex;
            LoadPaymentHistory();
        }

        private void LoadPaymentHistory()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = @"SELECT 
                                    fp.PaymentId,
                                    s.FirstName + ' ' + s.LastName AS StudentName,
                                    fs.FeeType,
                                    fp.AmountPaid,
                                    fp.PaymentDate,
                                    fp.PaymentMode,
                                    fp.TransactionId,
                                    u.UserName AS ReceivedByName,
                                    fp.Remarks
                                FROM FeePayments fp
                                INNER JOIN Students s ON fp.StudentId = s.StudentId
                                INNER JOIN FeeStructure fs ON fp.FeeId = fs.FeeId
                                INNER JOIN Users u ON fp.ReceivedBy = u.UserId
                                ORDER BY fp.PaymentDate DESC";

                    SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    gvPaymentHistory.DataSource = dt;
                    gvPaymentHistory.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading payment history: {ex.Message}", "danger");

                // Load sample data for demonstration
                DataTable dt = CreateSampleData();
                gvPaymentHistory.DataSource = dt;
                gvPaymentHistory.DataBind();
            }
        }

        private DataTable CreateSampleData()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("PaymentId", typeof(int));
            dt.Columns.Add("StudentName", typeof(string));
            dt.Columns.Add("FeeType", typeof(string));
            dt.Columns.Add("AmountPaid", typeof(decimal));
            dt.Columns.Add("PaymentDate", typeof(DateTime));
            dt.Columns.Add("PaymentMode", typeof(string));
            dt.Columns.Add("TransactionId", typeof(string));
            dt.Columns.Add("ReceivedByName", typeof(string));
            dt.Columns.Add("Remarks", typeof(string));

            // Add sample data
            dt.Rows.Add(1001, "John Smith", "Tuition Fee", 15000.00, DateTime.Now.AddDays(-1), "Online", "TXN001234", "Admin User", "Paid in full");
            dt.Rows.Add(1002, "Sarah Johnson", "Examination Fee", 2500.00, DateTime.Now.AddDays(-2), "Cash", "CASH001", "Finance Officer", "First installment");
            dt.Rows.Add(1003, "Michael Brown", "Transportation Fee", 5000.00, DateTime.Now.AddDays(-3), "Card", "CARD789012", "Admin User", "Annual fee");
            dt.Rows.Add(1004, "Emily Davis", "Library Fee", 1200.00, DateTime.Now.AddDays(-4), "Online", "TXN001235", "Finance Officer", "");
            dt.Rows.Add(1005, "David Wilson", "Sports Fee", 3000.00, DateTime.Now.AddDays(-5), "Cheque", "CHQ456789", "Admin User", "Equipment fee included");

            return dt;
        }

        private bool ValidateForm()
        {
            if (string.IsNullOrEmpty(ddlStudent.SelectedValue))
            {
                ShowMessage("Please select a student", "danger");
                ddlStudent.Focus();
                return false;
            }

            if (string.IsNullOrEmpty(ddlFee.SelectedValue))
            {
                ShowMessage("Please select a fee type", "danger");
                ddlFee.Focus();
                return false;
            }

            if (!decimal.TryParse(txtAmount.Text, out decimal amount) || amount <= 0)
            {
                ShowMessage("Please enter a valid amount", "danger");
                txtAmount.Focus();
                return false;
            }

            if (string.IsNullOrEmpty(txtPaymentDate.Text))
            {
                ShowMessage("Please select payment date", "danger");
                txtPaymentDate.Focus();
                return false;
            }

            if (string.IsNullOrEmpty(ddlPaymentMode.SelectedValue))
            {
                ShowMessage("Please select payment mode", "danger");
                ddlPaymentMode.Focus();
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtTransactionId.Text))
            {
                ShowMessage("Please enter transaction ID", "danger");
                txtTransactionId.Focus();
                return false;
            }

            if (string.IsNullOrEmpty(ddlReceivedBy.SelectedValue))
            {
                ShowMessage("Please select who received the payment", "danger");
                ddlReceivedBy.Focus();
                return false;
            }

            return true;
        }

        private void ClearForm()
        {
            ddlStudent.SelectedIndex = 0;
            ddlFee.SelectedIndex = 0;
            txtAmount.Text = "";
            txtPaymentDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            ddlPaymentMode.SelectedIndex = 0;
            txtTransactionId.Text = "";
            ddlReceivedBy.SelectedIndex = 0;
            txtRemarks.Text = "";
        }

        private void ShowMessage(string message, string type)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;

            if (type == "success")
            {
                pnlMessage.CssClass = "alert alert-success";
            }
            else if (type == "danger")
            {
                pnlMessage.CssClass = "alert alert-danger";
            }

            // Hide message after 5 seconds
            ScriptManager.RegisterStartupScript(this, this.GetType(), "hideMessage",
                "setTimeout(function() { document.getElementById('" + pnlMessage.ClientID + "').style.display = 'none'; }, 5000);", true);
        }
    }
}