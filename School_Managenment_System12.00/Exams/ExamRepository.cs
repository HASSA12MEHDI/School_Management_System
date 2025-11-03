using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace School_Managenment_System12._00.Models
{
    public class ExamRepository
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["SchoolConnectionString"].ConnectionString;

        // Helper method to handle DBNull values
        private T GetSafeValue<T>(object value, T defaultValue = default(T))
        {
            if (value == null || value == DBNull.Value)
                return defaultValue;

            try
            {
                return (T)Convert.ChangeType(value, typeof(T));
            }
            catch
            {
                return defaultValue;
            }
        }

        // Safe DateTime method for SQL Server
        private DateTime GetSafeSqlDateTime(object value, DateTime defaultValue)
        {
            if (value == null || value == DBNull.Value)
                return defaultValue;

            try
            {
                DateTime date = Convert.ToDateTime(value);
                // SQL Server DateTime range: 1753-01-01 to 9999-12-31
                DateTime minSqlDate = new DateTime(1753, 1, 1);
                DateTime maxSqlDate = new DateTime(9999, 12, 31);

                if (date < minSqlDate) return minSqlDate;
                if (date > maxSqlDate) return maxSqlDate;

                return date;
            }
            catch
            {
                return defaultValue;
            }
        }

        // 1. Get All Exams
        public List<Exams> GetAllExams()
        {
            List<Exams> exams = new List<Exams>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT e.*, c.ClassName 
                               FROM Exams e 
                               INNER JOIN Classes c ON e.ClassId = c.ClassID 
                               ORDER BY e.CreatedDate DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Exams exam = new Exams();
                    exam.ExamId = GetSafeValue<int>(reader["ExamId"]);
                    exam.ExamName = GetSafeValue<string>(reader["ExamName"], "");
                    exam.ExamType = GetSafeValue<string>(reader["ExamType"], "");
                    exam.ClassId = GetSafeValue<int>(reader["ClassId"]);
                    exam.ClassName = GetSafeValue<string>(reader["ClassName"], "");

                    // Use safe SQL DateTime method
                    exam.StartDate = GetSafeSqlDateTime(reader["StartDate"], DateTime.Now);
                    exam.EndDate = GetSafeSqlDateTime(reader["EndDate"], DateTime.Now.AddDays(7));

                    exam.TotalMarks = GetSafeValue<decimal>(reader["TotalMarks"], 100m);
                    exam.PassingMarks = GetSafeValue<decimal>(reader["PassingMarks"], 33m);
                    exam.IsActive = GetSafeValue<bool>(reader["IsActive"], true);
                    exam.CreatedDate = GetSafeSqlDateTime(reader["CreatedDate"], DateTime.Now);

                    exams.Add(exam);
                }
            }
            return exams;
        }

        // 2. Get Exam by ID
        public Exams GetExamById(int examId)
        {
            Exams exam = null;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT e.*, c.ClassName 
                               FROM Exams e 
                               INNER JOIN Classes c ON e.ClassId = c.ClassID 
                               WHERE e.ExamId = @ExamId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ExamId", examId);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    exam = new Exams();
                    exam.ExamId = GetSafeValue<int>(reader["ExamId"]);
                    exam.ExamName = GetSafeValue<string>(reader["ExamName"], "");
                    exam.ExamType = GetSafeValue<string>(reader["ExamType"], "");
                    exam.ClassId = GetSafeValue<int>(reader["ClassId"]);
                    exam.ClassName = GetSafeValue<string>(reader["ClassName"], "");

                    // Use safe SQL DateTime method
                    exam.StartDate = GetSafeSqlDateTime(reader["StartDate"], DateTime.Now);
                    exam.EndDate = GetSafeSqlDateTime(reader["EndDate"], DateTime.Now.AddDays(7));

                    exam.TotalMarks = GetSafeValue<decimal>(reader["TotalMarks"], 100m);
                    exam.PassingMarks = GetSafeValue<decimal>(reader["PassingMarks"], 33m);
                    exam.IsActive = GetSafeValue<bool>(reader["IsActive"], true);
                    exam.CreatedDate = GetSafeSqlDateTime(reader["CreatedDate"], DateTime.Now);
                }
            }
            return exam;
        }

        // 3. Add New Exam
        public bool AddExam(Exams exam)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO Exams (ExamName, ExamType, ClassId, StartDate, EndDate, 
                               TotalMarks, PassingMarks, IsActive, CreatedDate)
                               VALUES (@ExamName, @ExamType, @ClassId, @StartDate, @EndDate, 
                               @TotalMarks, @PassingMarks, @IsActive, @CreatedDate)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ExamName", (object)exam.ExamName ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@ExamType", (object)exam.ExamType ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@ClassId", exam.ClassId);

                // Use safe SQL DateTime parameters
                cmd.Parameters.AddWithValue("@StartDate", GetSafeSqlParameterValue(exam.StartDate));
                cmd.Parameters.AddWithValue("@EndDate", GetSafeSqlParameterValue(exam.EndDate));

                cmd.Parameters.AddWithValue("@TotalMarks", exam.TotalMarks);
                cmd.Parameters.AddWithValue("@PassingMarks", exam.PassingMarks);
                cmd.Parameters.AddWithValue("@IsActive", exam.IsActive);
                cmd.Parameters.AddWithValue("@CreatedDate", GetSafeSqlParameterValue(exam.CreatedDate));

                conn.Open();
                int result = cmd.ExecuteNonQuery();
                return result > 0;
            }
        }

        // 4. Update Exam
        public bool UpdateExam(Exams exam)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"UPDATE Exams SET 
                               ExamName = @ExamName, 
                               ExamType = @ExamType, 
                               ClassId = @ClassId, 
                               StartDate = @StartDate, 
                               EndDate = @EndDate, 
                               TotalMarks = @TotalMarks, 
                               PassingMarks = @PassingMarks, 
                               IsActive = @IsActive 
                               WHERE ExamId = @ExamId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ExamId", exam.ExamId);
                cmd.Parameters.AddWithValue("@ExamName", (object)exam.ExamName ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@ExamType", (object)exam.ExamType ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@ClassId", exam.ClassId);

                // Use safe SQL DateTime parameters
                cmd.Parameters.AddWithValue("@StartDate", GetSafeSqlParameterValue(exam.StartDate));
                cmd.Parameters.AddWithValue("@EndDate", GetSafeSqlParameterValue(exam.EndDate));

                cmd.Parameters.AddWithValue("@TotalMarks", exam.TotalMarks);
                cmd.Parameters.AddWithValue("@PassingMarks", exam.PassingMarks);
                cmd.Parameters.AddWithValue("@IsActive", exam.IsActive);

                conn.Open();
                int result = cmd.ExecuteNonQuery();
                return result > 0;
            }
        }

        // Safe SQL DateTime parameter method
        private object GetSafeSqlParameterValue(DateTime dateTime)
        {
            DateTime minSqlDate = new DateTime(1753, 1, 1);
            DateTime maxSqlDate = new DateTime(9999, 12, 31);

            if (dateTime < minSqlDate) return minSqlDate;
            if (dateTime > maxSqlDate) return maxSqlDate;

            return dateTime;
        }

        // 5. Delete Exam
        public bool DeleteExam(int examId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Exams WHERE ExamId = @ExamId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ExamId", examId);

                conn.Open();
                int result = cmd.ExecuteNonQuery();
                return result > 0;
            }
        }

        // 6. Get All Classes (for dropdown)
        public List<Class> GetAllClasses()
        {
            List<Class> classes = new List<Class>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT ClassID, ClassName FROM Classes ORDER BY ClassName";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Class cls = new Class();
                    cls.ClassID = GetSafeValue<int>(reader["ClassID"]);
                    cls.ClassName = GetSafeValue<string>(reader["ClassName"], "");
                    classes.Add(cls);
                }
            }
            return classes;
        }

        // 7. Get Exam Statistics
        public Dictionary<string, int> GetExamStats()
        {
            Dictionary<string, int> stats = new Dictionary<string, int>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT 
                                COUNT(*) as TotalExams,
                                SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) as ActiveExams,
                                SUM(CASE WHEN StartDate > GETDATE() THEN 1 ELSE 0 END) as UpcomingExams,
                                SUM(CASE WHEN EndDate < GETDATE() THEN 1 ELSE 0 END) as CompletedExams
                                FROM Exams";

                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    stats.Add("TotalExams", GetSafeValue<int>(reader["TotalExams"], 0));
                    stats.Add("ActiveExams", GetSafeValue<int>(reader["ActiveExams"], 0));
                    stats.Add("UpcomingExams", GetSafeValue<int>(reader["UpcomingExams"], 0));
                    stats.Add("CompletedExams", GetSafeValue<int>(reader["CompletedExams"], 0));
                }
            }
            return stats;
        }

        // 8. Search Exams
        public List<Exams> SearchExams(string searchTerm)
        {
            List<Exams> exams = new List<Exams>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT e.*, c.ClassName 
                               FROM Exams e 
                               INNER JOIN Classes c ON e.ClassId = c.ClassID 
                               WHERE e.ExamName LIKE @SearchTerm OR c.ClassName LIKE @SearchTerm
                               ORDER BY e.CreatedDate DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Exams exam = new Exams();
                    exam.ExamId = GetSafeValue<int>(reader["ExamId"]);
                    exam.ExamName = GetSafeValue<string>(reader["ExamName"], "");
                    exam.ExamType = GetSafeValue<string>(reader["ExamType"], "");
                    exam.ClassId = GetSafeValue<int>(reader["ClassId"]);
                    exam.ClassName = GetSafeValue<string>(reader["ClassName"], "");

                    // Use safe SQL DateTime method
                    exam.StartDate = GetSafeSqlDateTime(reader["StartDate"], DateTime.Now);
                    exam.EndDate = GetSafeSqlDateTime(reader["EndDate"], DateTime.Now.AddDays(7));

                    exam.TotalMarks = GetSafeValue<decimal>(reader["TotalMarks"], 100m);
                    exam.PassingMarks = GetSafeValue<decimal>(reader["PassingMarks"], 33m);
                    exam.IsActive = GetSafeValue<bool>(reader["IsActive"], true);
                    exam.CreatedDate = GetSafeSqlDateTime(reader["CreatedDate"], DateTime.Now);

                    exams.Add(exam);
                }
            }
            return exams;
        }
    }
}