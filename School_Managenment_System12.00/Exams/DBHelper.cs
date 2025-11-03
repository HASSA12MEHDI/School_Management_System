using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public class DBHelper
{
    private readonly SqlConnection con;

    public DBHelper()
    {
        string connectionString = ConfigurationManager.ConnectionStrings["SchoolDBConnection"].ConnectionString;
        con = new SqlConnection(connectionString);
    }

    public DataTable GetData(string query)
    {
        DataTable dt = new DataTable();
        try
        {
            con.Open();
            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
        }
        catch (Exception ex)
        {
            throw new Exception("Database error: " + ex.Message);
        }
        finally
        {
            con.Close();
        }
        return dt;
    }

    public int ExecuteQuery(string query, SqlParameter[] parameters = null)
    {
        int result = 0;
        try
        {
            con.Open();
            SqlCommand cmd = new SqlCommand(query, con);
            if (parameters != null)
            {
                cmd.Parameters.AddRange(parameters);
            }
            result = cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Database error: " + ex.Message);
        }
        finally
        {
            con.Close();
        }
        return result;
    }

    public object ExecuteScalar(string query, SqlParameter[] parameters = null)
    {
        object result = null;
        try
        {
            con.Open();
            SqlCommand cmd = new SqlCommand(query, con);
            if (parameters != null)
            {
                cmd.Parameters.AddRange(parameters);
            }
            result = cmd.ExecuteScalar();
        }
        catch (Exception ex)
        {
            throw new Exception("Database error: " + ex.Message);
        }
        finally
        {
            con.Close();
        }
        return result;
    }
}