using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.UI;

namespace School_Management_System
{
    public partial class Attendance : System.Web.UI.Page
    {
        private readonly string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=\"C:\\Programs wbd\\School_Managenment_System12.00\\School_Managenment_System12.00\\App_Data\\School.mdf\";Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null)
                {
                    Response.Redirect("Login.aspx");
                }

                LblCurrentUser.Text = "Welcome, " + Session["UserName"]?.ToString();
                TxtAttendanceDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                // Check today's attendance
                CheckTodaysAttendance();
            }
        }

        private void CheckTodaysAttendance()
        {
            string today = DateTime.Now.ToString("yyyy-MM-dd");
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Attendance WHERE AttendanceDate = @TodayDate";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@TodayDate", today);
                    con.Open();
                    int count = (int)cmd.ExecuteScalar();

                    if (count > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "showMessage",
                            "ShowClientMessage('info', 'Attendance already marked for today!');", true);
                    }
                }
            }
        }

        [WebMethod]
        public static List<ClassInfo> LoadClasses()
        {
            var classes = new List<ClassInfo>();
            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=\"C:\\Programs wbd\\School_Managenment_System12.00\\School_Managenment_System12.00\\App_Data\\School.mdf\";Integrated Security=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT ClassID, ClassName FROM Classes WHERE IsActive = 1 ORDER BY ClassName";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    foreach (DataRow row in dt.Rows)
                    {
                        classes.Add(new ClassInfo
                        {
                            ClassID = row["ClassID"].ToString(),
                            ClassName = row["ClassName"].ToString()
                        });
                    }
                }
            }

            return classes;
        }

        [WebMethod]
        public static List<StudentInfo> LoadStudents(int classId, string attendanceDate)
        {
            var students = new List<StudentInfo>();
            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=\"C:\\Programs wbd\\School_Managenment_System12.00\\School_Managenment_System12.00\\App_Data\\School.mdf\";Integrated Security=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        s.StudentId, 
                        s.RollNumber, 
                        s.FirstName + ' ' + s.LastName as StudentName,
                        ISNULL(a.Status, 'Not Marked') as Status,
                        ISNULL(a.Remarks, '') as Remarks
                    FROM Students s
                    LEFT JOIN Attendance a ON s.StudentId = a.StudentId 
                        AND a.AttendanceDate = @AttendanceDate 
                        AND a.ClassId = @ClassId
                    WHERE s.ClassId = @ClassId AND s.IsActive = 1
                    ORDER BY s.RollNumber";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ClassId", classId);
                    cmd.Parameters.AddWithValue("@AttendanceDate", attendanceDate);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    foreach (DataRow row in dt.Rows)
                    {
                        students.Add(new StudentInfo
                        {
                            StudentId = Convert.ToInt32(row["StudentId"]),
                            RollNumber = row["RollNumber"].ToString(),
                            StudentName = row["StudentName"].ToString(),
                            Status = row["Status"].ToString(),
                            Remarks = row["Remarks"].ToString()
                        });
                    }
                }
            }

            return students;
        }

        [WebMethod]
        public static AttendanceSummary LoadSummary(int classId, string attendanceDate)
        {
            var summary = new AttendanceSummary();
            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=\"C:\\Programs wbd\\School_Managenment_System12.00\\School_Managenment_System12.00\\App_Data\\School.mdf\";Integrated Security=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        COUNT(*) as Total,
                        SUM(CASE WHEN Status = 'Present' THEN 1 ELSE 0 END) as Present,
                        SUM(CASE WHEN Status = 'Absent' THEN 1 ELSE 0 END) as Absent,
                        SUM(CASE WHEN Status IN ('Late', 'HalfDay', 'Leave') THEN 1 ELSE 0 END) as Others
                    FROM Attendance 
                    WHERE ClassId = @ClassId AND AttendanceDate = @AttendanceDate";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ClassId", classId);
                    cmd.Parameters.AddWithValue("@AttendanceDate", attendanceDate);

                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        summary.Total = reader["Total"] != DBNull.Value ? Convert.ToInt32(reader["Total"]) : 0;
                        summary.Present = reader["Present"] != DBNull.Value ? Convert.ToInt32(reader["Present"]) : 0;
                        summary.Absent = reader["Absent"] != DBNull.Value ? Convert.ToInt32(reader["Absent"]) : 0;
                        summary.Others = reader["Others"] != DBNull.Value ? Convert.ToInt32(reader["Others"]) : 0;
                    }
                    reader.Close();
                }
            }

            return summary;
        }

        [WebMethod]
        public static AttendanceCheckResult CheckClassAttendance(int classId, string attendanceDate, string className)
        {
            var result = new AttendanceCheckResult();
            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=\"C:\\Programs wbd\\School_Managenment_System12.00\\School_Managenment_System12.00\\App_Data\\School.mdf\";Integrated Security=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        COUNT(*) as TotalStudents,
                        SUM(CASE WHEN a.AttendanceId IS NOT NULL THEN 1 ELSE 0 END) as MarkedStudents,
                        MIN(a.MarkedAt) as FirstMarkedAt,
                        MAX(a.MarkedAt) as LastMarkedAt,
                        MIN(u.FirstName + ' ' + u.LastName) as MarkedByName
                    FROM Students s
                    LEFT JOIN Attendance a ON s.StudentId = a.StudentId 
                        AND a.AttendanceDate = @AttendanceDate 
                        AND a.ClassId = @ClassId
                    LEFT JOIN Users u ON a.MarkedBy = u.UserId
                    WHERE s.ClassId = @ClassId AND s.IsActive = 1";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ClassId", classId);
                    cmd.Parameters.AddWithValue("@AttendanceDate", attendanceDate);

                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        int totalStudents = reader["TotalStudents"] != DBNull.Value ? Convert.ToInt32(reader["TotalStudents"]) : 0;
                        int markedStudents = reader["MarkedStudents"] != DBNull.Value ? Convert.ToInt32(reader["MarkedStudents"]) : 0;
                        string markedByName = reader["MarkedByName"] != DBNull.Value ? reader["MarkedByName"].ToString() : "";
                        DateTime? firstMarkedAt = reader["FirstMarkedAt"] != DBNull.Value ? Convert.ToDateTime(reader["FirstMarkedAt"]) : (DateTime?)null;
                        DateTime? lastMarkedAt = reader["LastMarkedAt"] != DBNull.Value ? Convert.ToDateTime(reader["LastMarkedAt"]) : (DateTime?)null;

                        if (markedStudents > 0)
                        {
                            string message = "";

                            if (markedStudents == totalStudents)
                            {
                                message = $"✅ <strong>{className}</strong> class attendance is <strong>COMPLETELY MARKED</strong> for {attendanceDate}. ";
                                result.Type = "warning";
                            }
                            else
                            {
                                message = $"⚠️ <strong>{className}</strong> class attendance is <strong>PARTIALLY MARKED</strong> for {attendanceDate} ({markedStudents}/{totalStudents} students). ";
                                result.Type = "warning";
                            }

                            if (!string.IsNullOrEmpty(markedByName))
                            {
                                message += $"Marked by: <strong>{markedByName}</strong>. ";
                            }

                            if (firstMarkedAt.HasValue)
                            {
                                message += $"First marked: <strong>{firstMarkedAt.Value:hh:mm tt}</strong>. ";
                            }

                            if (lastMarkedAt.HasValue && lastMarkedAt.Value != firstMarkedAt)
                            {
                                message += $"Last updated: <strong>{lastMarkedAt.Value:hh:mm tt}</strong>.";
                            }

                            result.Message = message;
                        }
                        else
                        {
                            result.Message = $"📋 <strong>{className}</strong> class attendance is <strong>NOT MARKED</strong> for {attendanceDate}. You can mark attendance now.";
                            result.Type = "info";
                        }
                    }
                    reader.Close();
                }
            }

            return result;
        }

        [WebMethod]
        public static AttendanceResult MarkAttendance(int studentId, string status, string remarks, int classId, string attendanceDate)
        {
            var result = new AttendanceResult { Success = false };
            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=\"C:\\Programs wbd\\School_Managenment_System12.00\\School_Managenment_System12.00\\App_Data\\School.mdf\";Integrated Security=True";

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        IF EXISTS (SELECT 1 FROM Attendance WHERE StudentId = @StudentId AND AttendanceDate = @AttendanceDate)
                        BEGIN
                            UPDATE Attendance 
                            SET Status = @Status, Remarks = @Remarks, MarkedAt = GETDATE()
                            WHERE StudentId = @StudentId AND AttendanceDate = @AttendanceDate
                        END
                        ELSE
                        BEGIN
                            INSERT INTO Attendance (StudentId, StudentName, ClassId, AttendanceDate, Status, Remarks, MarkedBy, MarkedByName)
                            SELECT @StudentId, s.FirstName + ' ' + s.LastName, @ClassId, @AttendanceDate, @Status, @Remarks, 
                                   @MarkedBy, u.FirstName + ' ' + u.LastName
                            FROM Students s, Users u
                            WHERE s.StudentId = @StudentId AND u.UserId = @MarkedBy
                        END";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@StudentId", studentId);
                        cmd.Parameters.AddWithValue("@ClassId", classId);
                        cmd.Parameters.AddWithValue("@AttendanceDate", attendanceDate);
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.Parameters.AddWithValue("@Remarks", remarks);
                        cmd.Parameters.AddWithValue("@MarkedBy", HttpContext.Current.Session["UserId"]);
                        cmd.Parameters.AddWithValue("@MarkedByName", HttpContext.Current.Session["UserName"]);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                result.Success = true;
            }
            catch (Exception ex)
            {
                result.Message = ex.Message;
            }

            return result;
        }

        [WebMethod]
        public static AttendanceResult SaveAllAttendance(List<AttendanceData> attendanceData, int classId, string attendanceDate)
        {
            var result = new AttendanceResult { Success = false };
            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=\"C:\\Programs wbd\\School_Managenment_System12.00\\School_Managenment_System12.00\\App_Data\\School.mdf\";Integrated Security=True";

            try
            {
                int savedCount = 0;
                int markedAsPresentCount = 0;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    foreach (var data in attendanceData)
                    {
                        string query = @"
                            IF EXISTS (SELECT 1 FROM Attendance WHERE StudentId = @StudentId AND AttendanceDate = @AttendanceDate)
                            BEGIN
                                UPDATE Attendance 
                                SET Status = @Status, Remarks = @Remarks, MarkedAt = GETDATE()
                                WHERE StudentId = @StudentId AND AttendanceDate = @AttendanceDate
                            END
                            ELSE
                            BEGIN
                                INSERT INTO Attendance (StudentId, StudentName, ClassId, AttendanceDate, Status, Remarks, MarkedBy, MarkedByName)
                                SELECT @StudentId, s.FirstName + ' ' + s.LastName, @ClassId, @AttendanceDate, @Status, @Remarks, 
                                       @MarkedBy, u.FirstName + ' ' + u.LastName
                                FROM Students s, Users u
                                WHERE s.StudentId = @StudentId AND u.UserId = @MarkedBy
                            END";

                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue("@StudentId", data.StudentId);
                            cmd.Parameters.AddWithValue("@ClassId", classId);
                            cmd.Parameters.AddWithValue("@AttendanceDate", attendanceDate);
                            cmd.Parameters.AddWithValue("@Status", data.Status);
                            cmd.Parameters.AddWithValue("@Remarks", data.Remarks);
                            cmd.Parameters.AddWithValue("@MarkedBy", HttpContext.Current.Session["UserId"]);
                            cmd.Parameters.AddWithValue("@MarkedByName", HttpContext.Current.Session["UserName"]);

                            cmd.ExecuteNonQuery();
                            savedCount++;

                            if (data.Status == "Present")
                                markedAsPresentCount++;
                        }
                    }
                }

                result.Success = true;

                string message = $"✅ Attendance saved successfully! ";
                if (markedAsPresentCount > 0)
                {
                    message += $"<strong>{markedAsPresentCount}</strong> unmarked students set to Present.";
                }
                else
                {
                    message += "All students already had attendance marked.";
                }

                result.Message = message;
            }
            catch (Exception ex)
            {
                result.Message = $"❌ Error saving attendance: {ex.Message}";
            }

            return result;
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }
    }

    // Helper classes for WebMethods
    public class ClassInfo
    {
        public string ClassID { get; set; }
        public string ClassName { get; set; }
    }

    public class StudentInfo
    {
        public int StudentId { get; set; }
        public string RollNumber { get; set; }
        public string StudentName { get; set; }
        public string Status { get; set; }
        public string Remarks { get; set; }
    }

    public class AttendanceSummary
    {
        public int Total { get; set; }
        public int Present { get; set; }
        public int Absent { get; set; }
        public int Others { get; set; }
    }

    public class AttendanceCheckResult
    {
        public string Message { get; set; }
        public string Type { get; set; }
    }

    public class AttendanceResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
    }

    public class AttendanceData
    {
        public int StudentId { get; set; }
        public string Status { get; set; }
        public string Remarks { get; set; }
    }
}