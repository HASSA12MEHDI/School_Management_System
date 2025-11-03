using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class Attendance_Reports : System.Web.UI.Page
    {
        string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=\"C:\\Programs wbd\\School_Managenment_System12.00\\School_Managenment_System12.00\\App_Data\\School.mdf\";Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null)
                {
                    Response.Redirect("Login.aspx");
                }

                txtStartDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                LoadClasses();
                GenerateReport();
            }
        }

        private void LoadClasses()
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
                ddlClass.Items.Insert(0, new ListItem("All Classes", "0"));
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            GenerateReport();
        }
        // Add this method to your Attendance_Reports.aspx.cs code-behind
        protected void btnLogout_Click(object sender, EventArgs e)
        {
           
            Response.Redirect("Dashboard.aspx");
        }
        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtStartDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            ddlClass.SelectedIndex = 0;
            ddlStatus.SelectedIndex = 0;
            GenerateReport();
        }

        private void GenerateReport()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        a.AttendanceId,
                        a.StudentId,
                        a.StudentName,
                        s.RollNumber,
                        a.ClassId,
                        c.ClassName,
                        a.AttendanceDate,
                        a.Status,
                        a.Remarks,
                        a.MarkedBy,
                        a.MarkedByName,
                        a.MarkedAt
                    FROM Attendance a
                    INNER JOIN Students s ON a.StudentId = s.StudentId
                    INNER JOIN Classes c ON a.ClassId = c.ClassID
                    WHERE a.AttendanceDate BETWEEN @StartDate AND @EndDate
                    AND (@ClassId = 0 OR a.ClassId = @ClassId)
                    AND (@Status = '' OR a.Status = @Status)
                    ORDER BY a.AttendanceDate DESC, s.RollNumber";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@StartDate", txtStartDate.Text);
                cmd.Parameters.AddWithValue("@EndDate", txtEndDate.Text);
                cmd.Parameters.AddWithValue("@ClassId", int.Parse(ddlClass.SelectedValue));
                cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvAttendance.DataSource = dt;
                gvAttendance.DataBind();

                // Load statistics
                LoadStatistics(dt);

                // Update record count
                lblRecordCount.Text = $"{dt.Rows.Count} records found";
            }
        }

        private void LoadStatistics(DataTable dt)
        {
            lblTotalRecords.Text = dt.Rows.Count.ToString();

            int presentCount = 0;
            int absentCount = 0;
            int otherCount = 0;

            foreach (DataRow row in dt.Rows)
            {
                string status = row["Status"].ToString();
                if (status == "Present")
                    presentCount++;
                else if (status == "Absent")
                    absentCount++;
                else
                    otherCount++;
            }

            lblPresentCount.Text = presentCount.ToString();
            lblAbsentCount.Text = absentCount.ToString();
            lblOtherCount.Text = otherCount.ToString();
        }

        // Yeh method already hai - ensure it includes Leave status
        public string GetStatusBadge(string status)
        {
            switch (status.ToLower())
            {
                case "present": return "success";
                case "absent": return "danger";
                case "late": return "warning";
                case "halfday": return "info";
                case "leave": return "secondary";
                default: return "secondary";
            }
        }

        // YEH NAYA METHOD ADD KAREIN
        public string GetStatusDisplay(string status)
        {
            switch (status.ToLower())
            {
                case "present": return "✅ Present";
                case "absent": return "❌ Absent";
                case "late": return "⏰ Late";
                case "halfday": return "🕛 Half Day";
                case "leave": return "🏠 Leave";
                default: return status;
            }
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            GenerateReport();

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=AttendanceReport_" + DateTime.Now.ToString("yyyyMMdd") + ".xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";

            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);

            GridView gvExport = new GridView();
            gvExport.DataSource = ((DataTable)gvAttendance.DataSource);
            gvExport.DataBind();

            gvExport.HeaderStyle.BackColor = System.Drawing.Color.LightGray;
            gvExport.HeaderStyle.Font.Bold = true;

            gvExport.RenderControl(hw);

            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            // Required for Export to Excel
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }
    }
}