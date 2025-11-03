using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text;

namespace School_Managenment_System12._00
{
    public partial class View_AllTransaction : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set default date range to current month
                dateFrom.Text = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).ToString("yyyy-MM-dd");
                dateTo.Text = DateTime.Now.ToString("yyyy-MM-dd");

                // Load dropdown options
                LoadCategories();
                LoadPaymentModes();

                // Load initial data
                LoadTransactions();
                CalculateStatistics();
            }
        }

        private void LoadCategories()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Get unique categories from both Income and Expenses tables
                    string query = @"
                        SELECT DISTINCT Category FROM Income
                        UNION
                        SELECT DISTINCT Category FROM Expenses
                        ORDER BY Category";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        SqlDataReader reader = cmd.ExecuteReader();

                        // Keep the "All Categories" option
                        category.Items.Clear();
                        category.Items.Add(new ListItem("All Categories", "all"));

                        while (reader.Read())
                        {
                            category.Items.Add(new ListItem(reader["Category"].ToString(), reader["Category"].ToString()));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading categories: " + ex.Message, false);
            }
        }

        private void LoadPaymentModes()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Get unique payment modes from both Income and Expenses tables
                    string query = @"
                        SELECT DISTINCT PaymentMode FROM Income
                        UNION
                        SELECT DISTINCT PaymentMode FROM Expenses
                        ORDER BY PaymentMode";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        SqlDataReader reader = cmd.ExecuteReader();

                        // Keep the "All Payment Modes" option
                        paymentMode.Items.Clear();
                        paymentMode.Items.Add(new ListItem("All Payment Modes", "all"));

                        while (reader.Read())
                        {
                            paymentMode.Items.Add(new ListItem(reader["PaymentMode"].ToString(), reader["PaymentMode"].ToString()));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading payment modes: " + ex.Message, false);
            }
        }

        private void LoadTransactions()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Build the query based on filters
                    string query = @"
                        SELECT 
                            TransactionDate, 
                            TransactionType, 
                            Category, 
                            Description, 
                            Amount, 
                            PaymentMode, 
                            Party,
                            TransactionId,
                            OriginalTable
                        FROM (
                            SELECT 
                                IncomeDate AS TransactionDate,
                                'Income' AS TransactionType,
                                Category,
                                Description,
                                Amount,
                                PaymentMode,
                                ReceivedFrom AS Party,
                                IncomeId AS TransactionId,
                                'Income' AS OriginalTable
                            FROM Income
                            
                            UNION ALL
                            
                            SELECT 
                                ExpenseDate AS TransactionDate,
                                'Expense' AS TransactionType,
                                Category,
                                Description,
                                Amount,
                                PaymentMode,
                                PaidTo AS Party,
                                ExpenseId AS TransactionId,
                                'Expense' AS OriginalTable
                            FROM Expenses
                        ) AS AllTransactions
                        WHERE 1=1";

                    // Add date filters
                    if (!string.IsNullOrEmpty(dateFrom.Text))
                    {
                        query += " AND CAST(TransactionDate AS DATE) >= CAST('" + dateFrom.Text + "' AS DATE)";
                    }

                    if (!string.IsNullOrEmpty(dateTo.Text))
                    {
                        query += " AND CAST(TransactionDate AS DATE) <= CAST('" + dateTo.Text + "' AS DATE)";
                    }

                    // Add transaction type filter
                    if (transactionType.SelectedValue != "all")
                    {
                        query += " AND TransactionType = '" + transactionType.SelectedValue + "'";
                    }

                    // Add category filter
                    if (category.SelectedValue != "all")
                    {
                        query += " AND Category = '" + category.SelectedValue + "'";
                    }

                    // Add payment mode filter
                    if (paymentMode.SelectedValue != "all")
                    {
                        query += " AND PaymentMode = '" + paymentMode.SelectedValue + "'";
                    }

                    // Add search filter
                    if (!string.IsNullOrEmpty(search.Text))
                    {
                        query += " AND Description LIKE '%" + search.Text.Replace("'", "''") + "%'";
                    }

                    // Order by date (newest first)
                    query += " ORDER BY TransactionDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvTransactions.DataSource = dt;
                        gvTransactions.DataBind();

                        // Show/hide no records message
                        lblNoRecords.Visible = dt.Rows.Count == 0;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading transactions: " + ex.Message, false);
            }
        }

        private void CalculateStatistics()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Build the query based on filters
                    string query = @"
                        SELECT 
                            SUM(CASE WHEN TransactionType = 'Income' THEN Amount ELSE 0 END) AS TotalIncome,
                            SUM(CASE WHEN TransactionType = 'Expense' THEN Amount ELSE 0 END) AS TotalExpense
                        FROM (
                            SELECT 
                                IncomeDate AS TransactionDate,
                                'Income' AS TransactionType,
                                Amount
                            FROM Income
                            
                            UNION ALL
                            
                            SELECT 
                                ExpenseDate AS TransactionDate,
                                'Expense' AS TransactionType,
                                Amount
                            FROM Expenses
                        ) AS AllTransactions
                        WHERE 1=1";

                    // Add date filters
                    if (!string.IsNullOrEmpty(dateFrom.Text))
                    {
                        query += " AND CAST(TransactionDate AS DATE) >= CAST('" + dateFrom.Text + "' AS DATE)";
                    }

                    if (!string.IsNullOrEmpty(dateTo.Text))
                    {
                        query += " AND CAST(TransactionDate AS DATE) <= CAST('" + dateTo.Text + "' AS DATE)";
                    }

                    // Add transaction type filter
                    if (transactionType.SelectedValue != "all")
                    {
                        query += " AND TransactionType = '" + transactionType.SelectedValue + "'";
                    }

                    // Add category filter
                    if (category.SelectedValue != "all")
                    {
                        query += " AND Category = '" + category.SelectedValue + "'";
                    }

                    // Add payment mode filter
                    if (paymentMode.SelectedValue != "all")
                    {
                        query += " AND PaymentMode = '" + paymentMode.SelectedValue + "'";
                    }

                    // Add search filter
                    if (!string.IsNullOrEmpty(search.Text))
                    {
                        query += " AND Description LIKE '%" + search.Text.Replace("'", "''") + "%'";
                    }

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            decimal totalIncome = reader["TotalIncome"] != DBNull.Value ? Convert.ToDecimal(reader["TotalIncome"]) : 0;
                            decimal totalExpense = reader["TotalExpense"] != DBNull.Value ? Convert.ToDecimal(reader["TotalExpense"]) : 0;
                            decimal balance = totalIncome - totalExpense;

                            lblTotalIncome.Text = totalIncome.ToString("C");
                            lblTotalExpense.Text = totalExpense.ToString("C");
                            lblBalance.Text = balance.ToString("C");

                            // Set color for balance based on value
                            if (balance < 0)
                            {
                                lblBalance.CssClass = "amount-expense";
                            }
                            else
                            {
                                lblBalance.CssClass = "amount-income";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error calculating statistics: " + ex.Message, false);
            }
        }

        protected void BtnApplyFilters_Click(object sender, EventArgs e)
        {
            LoadTransactions();
            CalculateStatistics();
            ShowMessage("Filters applied successfully", true);
        }

        protected void BtnResetFilters_Click(object sender, EventArgs e)
        {
            // Reset all filters
            dateFrom.Text = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).ToString("yyyy-MM-dd");
            dateTo.Text = DateTime.Now.ToString("yyyy-MM-dd");
            transactionType.SelectedValue = "all";
            category.SelectedValue = "all";
            paymentMode.SelectedValue = "all";
            search.Text = "";

            // Reload data
            LoadTransactions();
            CalculateStatistics();
            ShowMessage("Filters reset successfully", true);
        }

        protected void BtnExport_Click(object sender, EventArgs e)
        {
            try
            {
                // Get the data with current filters
                DataTable dt = GetTransactionData();

                if (dt.Rows.Count == 0)
                {
                    ShowMessage("No data to export", false);
                    return;
                }

                // Export to Excel
                ExportToExcel(dt);
                ShowMessage("Data exported successfully", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Error exporting data: " + ex.Message, false);
            }
        }

        private DataTable GetTransactionData()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Build the query based on filters
                string query = @"
                    SELECT 
                        TransactionDate, 
                        TransactionType, 
                        Category, 
                        Description, 
                        Amount, 
                        PaymentMode, 
                        Party
                    FROM (
                        SELECT 
                            IncomeDate AS TransactionDate,
                            'Income' AS TransactionType,
                            Category,
                            Description,
                            Amount,
                            PaymentMode,
                            ReceivedFrom AS Party
                        FROM Income
                        
                        UNION ALL
                        
                        SELECT 
                            ExpenseDate AS TransactionDate,
                            'Expense' AS TransactionType,
                            Category,
                            Description,
                            Amount,
                            PaymentMode,
                            PaidTo AS Party
                        FROM Expenses
                    ) AS AllTransactions
                    WHERE 1=1";

                // Add date filters
                if (!string.IsNullOrEmpty(dateFrom.Text))
                {
                    query += " AND CAST(TransactionDate AS DATE) >= CAST('" + dateFrom.Text + "' AS DATE)";
                }

                if (!string.IsNullOrEmpty(dateTo.Text))
                {
                    query += " AND CAST(TransactionDate AS DATE) <= CAST('" + dateTo.Text + "' AS DATE)";
                }

                // Add transaction type filter
                if (transactionType.SelectedValue != "all")
                {
                    query += " AND TransactionType = '" + transactionType.SelectedValue + "'";
                }

                // Add category filter
                if (category.SelectedValue != "all")
                {
                    query += " AND Category = '" + category.SelectedValue + "'";
                }

                // Add payment mode filter
                if (paymentMode.SelectedValue != "all")
                {
                    query += " AND PaymentMode = '" + paymentMode.SelectedValue + "'";
                }

                // Add search filter
                if (!string.IsNullOrEmpty(search.Text))
                {
                    query += " AND Description LIKE '%" + search.Text.Replace("'", "''") + "%'";
                }

                // Order by date (newest first)
                query += " ORDER BY TransactionDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
            }

            return dt;
        }

        private void ExportToExcel(DataTable dt)
        {
            // Create a new StringBuilder to build the HTML table
            StringBuilder sb = new StringBuilder();

            // Add HTML header
            sb.Append("<html>");
            sb.Append("<head>");
            sb.Append("<title>Transaction Report</title>");
            sb.Append("<style>");
            sb.Append("table { border-collapse: collapse; width: 100%; }");
            sb.Append("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
            sb.Append("th { background-color: #4361ee; color: white; }");
            sb.Append("tr:nth-child(even) { background-color: #f2f2f2; }");
            sb.Append("</style>");
            sb.Append("</head>");
            sb.Append("<body>");

            // Add title
            sb.Append("<h2>Transaction Report</h2>");
            sb.Append("<p>Generated on: " + DateTime.Now.ToString() + "</p>");
            sb.Append("<p>Period: " + dateFrom.Text + " to " + dateTo.Text + "</p>");
            sb.Append("<br/>");

            // Add table header
            sb.Append("<table>");
            sb.Append("<tr>");
            foreach (DataColumn column in dt.Columns)
            {
                sb.Append("<th>" + column.ColumnName + "</th>");
            }
            sb.Append("</tr>");

            // Add table rows
            foreach (DataRow row in dt.Rows)
            {
                sb.Append("<tr>");
                foreach (DataColumn column in dt.Columns)
                {
                    sb.Append("<td>" + row[column].ToString() + "</td>");
                }
                sb.Append("</tr>");
            }
            sb.Append("</table>");

            // Add summary statistics
            sb.Append("<br/>");
            sb.Append("<h3>Summary</h3>");
            sb.Append("<p>Total Income: " + lblTotalIncome.Text + "</p>");
            sb.Append("<p>Total Expenses: " + lblTotalExpense.Text + "</p>");
            sb.Append("<p>Balance: " + lblBalance.Text + "</p>");

            sb.Append("</body>");
            sb.Append("</html>");

            // Set the content type and filename
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=TransactionReport_" + DateTime.Now.ToString("yyyyMMdd") + ".xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";

            // Write the content
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        protected void GvTransactions_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Store transaction details for edit/delete operations
                string transactionId = DataBinder.Eval(e.Row.DataItem, "TransactionId").ToString();
                string originalTable = DataBinder.Eval(e.Row.DataItem, "OriginalTable").ToString();

                // Format date
                Label lblDate = (Label)e.Row.FindControl("lblDate");
                if (lblDate != null)
                {
                    DateTime date = Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "TransactionDate"));
                    lblDate.Text = date.ToString("dd-MMM-yyyy");
                }

                // Format transaction type with badge
                Label lblTransactionType = (Label)e.Row.FindControl("lblTransactionType");
                if (lblTransactionType != null)
                {
                    string type = DataBinder.Eval(e.Row.DataItem, "TransactionType").ToString();
                    lblTransactionType.Text = type;

                    if (type == "Income")
                    {
                        lblTransactionType.CssClass = "badge badge-income";
                    }
                    else
                    {
                        lblTransactionType.CssClass = "badge badge-expense";
                    }
                }

                // Format amount with color
                Label lblAmount = (Label)e.Row.FindControl("lblAmount");
                if (lblAmount != null)
                {
                    decimal amount = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Amount"));
                    lblAmount.Text = amount.ToString("C");

                    string type = DataBinder.Eval(e.Row.DataItem, "TransactionType").ToString();
                    if (type == "Income")
                    {
                        lblAmount.CssClass = "amount-income";
                    }
                    else
                    {
                        lblAmount.CssClass = "amount-expense";
                    }
                }

                // Add edit and delete buttons
                LinkButton btnEdit = (LinkButton)e.Row.FindControl("btnEdit");
                LinkButton btnDelete = (LinkButton)e.Row.FindControl("btnDelete");

                if (btnEdit != null)
                {
                    btnEdit.CommandArgument = transactionId + "|" + originalTable;
                }

                if (btnDelete != null)
                {
                    btnDelete.CommandArgument = transactionId + "|" + originalTable;
                }
            }
        }

        protected void GvTransactions_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvTransactions.PageIndex = e.NewPageIndex;
            LoadTransactions();
        }

        protected void GvTransactions_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditTransaction")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                string transactionId = args[0];
                string originalTable = args[1];

                // Load transaction details into edit form
                LoadTransactionForEdit(transactionId, originalTable);

                // Show edit modal
                ScriptManager.RegisterStartupScript(this, this.GetType(), "showEditModal", "showEditModal();", true);
            }
            else if (e.CommandName == "DeleteTransaction")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                string transactionId = args[0];
                string originalTable = args[1];

                // Show confirmation modal
                hfDeleteTransactionId.Value = transactionId;
                hfDeleteTable.Value = originalTable;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "showDeleteModal", "showDeleteModal();", true);
            }
        }

        private void LoadTransactionForEdit(string transactionId, string originalTable)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = "";
                    if (originalTable == "Income")
                    {
                        query = @"
                            SELECT IncomeId, IncomeDate, IncomeType, Amount, Category, Description, 
                                   ReceivedFrom, PaymentMode
                            FROM Income 
                            WHERE IncomeId = @TransactionId";
                    }
                    else
                    {
                        query = @"
                            SELECT ExpenseId, ExpenseDate, ExpenseType, Amount, Category, Description, 
                                   PaidTo, PaymentMode
                            FROM Expenses 
                            WHERE ExpenseId = @TransactionId";
                    }

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TransactionId", transactionId);
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            hfEditTransactionId.Value = transactionId;
                            hfEditTable.Value = originalTable;

                            if (originalTable == "Income")
                            {
                                txtEditDate.Text = Convert.ToDateTime(reader["IncomeDate"]).ToString("yyyy-MM-dd");
                                txtEditType.Text = reader["IncomeType"].ToString();
                                txtEditAmount.Text = reader["Amount"].ToString();
                                txtEditCategory.Text = reader["Category"].ToString();
                                txtEditDescription.Text = reader["Description"].ToString();
                                txtEditParty.Text = reader["ReceivedFrom"].ToString();
                                ddlEditPaymentMode.SelectedValue = reader["PaymentMode"].ToString();
                            }
                            else
                            {
                                txtEditDate.Text = Convert.ToDateTime(reader["ExpenseDate"]).ToString("yyyy-MM-dd");
                                txtEditType.Text = reader["ExpenseType"].ToString();
                                txtEditAmount.Text = reader["Amount"].ToString();
                                txtEditCategory.Text = reader["Category"].ToString();
                                txtEditDescription.Text = reader["Description"].ToString();
                                txtEditParty.Text = reader["PaidTo"].ToString();
                                ddlEditPaymentMode.SelectedValue = reader["PaymentMode"].ToString();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading transaction details: " + ex.Message, false);
            }
        }

        protected void BtnUpdateTransaction_Click(object sender, EventArgs e)
        {
            try
            {
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = "";
                    if (hfEditTable.Value == "Income")
                    {
                        query = @"
                            UPDATE Income 
                            SET IncomeDate = @Date, IncomeType = @Type, Amount = @Amount, 
                                Category = @Category, Description = @Description, 
                                ReceivedFrom = @Party, PaymentMode = @PaymentMode
                            WHERE IncomeId = @TransactionId";
                    }
                    else
                    {
                        query = @"
                            UPDATE Expenses 
                            SET ExpenseDate = @Date, ExpenseType = @Type, Amount = @Amount, 
                                Category = @Category, Description = @Description, 
                                PaidTo = @Party, PaymentMode = @PaymentMode
                            WHERE ExpenseId = @TransactionId";
                    }

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Date", txtEditDate.Text);
                        cmd.Parameters.AddWithValue("@Type", txtEditType.Text);
                        cmd.Parameters.AddWithValue("@Amount", Convert.ToDecimal(txtEditAmount.Text));
                        cmd.Parameters.AddWithValue("@Category", txtEditCategory.Text);
                        cmd.Parameters.AddWithValue("@Description", txtEditDescription.Text);
                        cmd.Parameters.AddWithValue("@Party", txtEditParty.Text);
                        cmd.Parameters.AddWithValue("@PaymentMode", ddlEditPaymentMode.SelectedValue);
                        cmd.Parameters.AddWithValue("@TransactionId", hfEditTransactionId.Value);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowMessage("Transaction updated successfully", true);
                            LoadTransactions();
                            CalculateStatistics();
                        }
                        else
                        {
                            ShowMessage("Failed to update transaction", false);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating transaction: " + ex.Message, false);
            }
        }

        protected void BtnConfirmDelete_Click(object sender, EventArgs e)
        {
            try
            {
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = "";
                    if (hfDeleteTable.Value == "Income")
                    {
                        query = "DELETE FROM Income WHERE IncomeId = @TransactionId";
                    }
                    else
                    {
                        query = "DELETE FROM Expenses WHERE ExpenseId = @TransactionId";
                    }

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TransactionId", hfDeleteTransactionId.Value);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowMessage("Transaction deleted successfully", true);
                            LoadTransactions();
                            CalculateStatistics();
                        }
                        else
                        {
                            ShowMessage("Failed to delete transaction", false);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting transaction: " + ex.Message, false);
            }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;

            if (isSuccess)
            {
                lblMessage.CssClass = "message success-message";
            }
            else
            {
                lblMessage.CssClass = "message error-message";
            }
        }
    }
}