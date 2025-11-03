using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class Add_Student : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadClasses();
                GenerateRollNumber();
                txtAdmissionDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            }
        }

        private void LoadClasses()
        {
            try
            {
                string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf"";Integrated Security=True";

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    // Correct query to SELECT classes instead of INSERT
                    string query = "SELECT ClassID, ClassName FROM Classes WHERE IsActive = 1 ORDER BY ClassName";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        ddlClass.DataSource = reader;
                        ddlClass.DataTextField = "ClassName";
                        ddlClass.DataValueField = "ClassID";
                        ddlClass.DataBind();
                        ddlClass.Items.Insert(0, new ListItem("Select Class", ""));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading classes: " + ex.Message, "danger");
            }
        }

        protected void BtnGenerateRollNumber_Click(object sender, EventArgs e)
        {
            GenerateRollNumber();
        }

        private void GenerateRollNumber()
        {
            try
            {
                string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf"";Integrated Security=True";
                string query = "SELECT ISNULL(MAX(CAST(SUBSTRING(RollNumber, 4, LEN(RollNumber)) AS INT)), 0) + 1 FROM Students WHERE RollNumber LIKE 'STD%'";

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        int nextNumber = Convert.ToInt32(cmd.ExecuteScalar());
                        txtRollNumber.Text = "STD" + nextNumber.ToString("D4"); // Fixed: Added "STD" prefix
                    }
                }
            }
            catch (Exception ex)
            {
                // Fallback to timestamp-based roll number
                txtRollNumber.Text = "STD" + DateTime.Now.ToString("yyyyMMddHHmmss");
                ShowMessage("Generated temporary roll number. Save to get permanent one. Error: " + ex.Message, "warning");
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (SaveStudent())
            {
                ShowMessage("Student saved successfully!", "success");
                ClearForm();
            }
        }

        protected void BtnSaveAndAdd_Click(object sender, EventArgs e)
        {
            if (SaveStudent())
            {
                ShowMessage("Student saved successfully! You can add another student.", "success");
                ClearForm();
                GenerateRollNumber();
                txtFirstName.Focus();
            }
        }

        private bool SaveStudent()
        {
            try
            {
                if (!ValidateForm())
                    return false;

                string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Programs wbd\School_Managenment_System12.00\School_Managenment_System12.00\App_Data\School.mdf"";Integrated Security=True";
                string query = @"INSERT INTO Students (RollNumber, FirstName, LastName, Email, Phone, DateOfBirth, Gender, 
                                BloodGroup, AdmissionDate, Address, FatherName, MotherName, ParentPhone, ClassID) 
                                VALUES (@RollNumber, @FirstName, @LastName, @Email, @Phone, @DateOfBirth, @Gender, 
                                @BloodGroup, @AdmissionDate, @Address, @FatherName, @MotherName, @ParentPhone, @ClassID)";

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        // Handle optional fields with proper null checks
                        cmd.Parameters.AddWithValue("@RollNumber", txtRollNumber.Text);
                        cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text);
                        cmd.Parameters.AddWithValue("@LastName", txtLastName.Text);
                        cmd.Parameters.AddWithValue("@Email", string.IsNullOrEmpty(txtEmail.Text) ? (object)DBNull.Value : txtEmail.Text);
                        cmd.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(txtPhone.Text) ? (object)DBNull.Value : txtPhone.Text);

                        // Handle date fields
                        cmd.Parameters.AddWithValue("@DateOfBirth", string.IsNullOrEmpty(txtDateOfBirth.Text) ? (object)DBNull.Value : DateTime.Parse(txtDateOfBirth.Text));
                        cmd.Parameters.AddWithValue("@AdmissionDate", string.IsNullOrEmpty(txtAdmissionDate.Text) ? (object)DBNull.Value : DateTime.Parse(txtAdmissionDate.Text));

                        cmd.Parameters.AddWithValue("@Gender", string.IsNullOrEmpty(ddlGender.SelectedValue) ? (object)DBNull.Value : ddlGender.SelectedValue);
                        cmd.Parameters.AddWithValue("@BloodGroup", string.IsNullOrEmpty(ddlBloodGroup.SelectedValue) ? (object)DBNull.Value : ddlBloodGroup.SelectedValue);
                        cmd.Parameters.AddWithValue("@Address", string.IsNullOrEmpty(txtAddress.Text) ? (object)DBNull.Value : txtAddress.Text);
                        cmd.Parameters.AddWithValue("@FatherName", string.IsNullOrEmpty(txtFatherName.Text) ? (object)DBNull.Value : txtFatherName.Text);
                        cmd.Parameters.AddWithValue("@MotherName", string.IsNullOrEmpty(txtMotherName.Text) ? (object)DBNull.Value : txtMotherName.Text);
                        cmd.Parameters.AddWithValue("@ParentPhone", string.IsNullOrEmpty(txtParentPhone.Text) ? (object)DBNull.Value : txtParentPhone.Text);
                        cmd.Parameters.AddWithValue("@ClassID", string.IsNullOrEmpty(ddlClass.SelectedValue) ? (object)DBNull.Value : Convert.ToInt32(ddlClass.SelectedValue));

                        con.Open();
                        int result = cmd.ExecuteNonQuery();
                        return result > 0;
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 2627)
                {
                    ShowMessage("Student with this roll number already exists!", "danger");
                }
                else
                {
                    ShowMessage("Database error: " + sqlEx.Message, "danger");
                }
                return false;
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving student: " + ex.Message, "danger");
                return false;
            }
        }

        private bool ValidateForm()
        {
            if (string.IsNullOrEmpty(txtRollNumber.Text))
            {
                ShowMessage("Please generate a roll number first.", "danger");
                return false;
            }

            if (string.IsNullOrEmpty(txtFirstName.Text) || string.IsNullOrEmpty(txtLastName.Text))
            {
                ShowMessage("Please enter both first and last name.", "danger");
                return false;
            }

            if (ddlClass.SelectedValue == "")
            {
                ShowMessage("Please select a class.", "danger");
                return false;
            }


            if (!string.IsNullOrEmpty(txtPhone.Text) && txtPhone.Text.Length != 11)
            {
                ShowMessage("Phone number must be 11 digits.", "danger");
                return false;
            }

            if (!string.IsNullOrEmpty(txtParentPhone.Text) && txtParentPhone.Text.Length != 11)
            {
                ShowMessage("Parent's phone number must be 11 digits.", "danger");
                return false;
            }

            return true;
        }

        protected void BtnViewStudents_Click(object sender, EventArgs e)
        {
            Response.Redirect("View_Students.aspx");
        }

        protected void BtnQuickClasses_Click(object sender, EventArgs e)
        {
            Response.Redirect("Manage_Classes.aspx");
        }

        protected void DdlClass_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Optional: Add any logic that should run when class selection changes
            if (ddlClass.SelectedValue != "")
            {
                // You can load additional class information here if needed
            }
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = type == "success" ? "alert alert-success" : "alert alert-danger";
            lblMessage.Visible = true;
        }

        private void ClearForm()
        {
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtEmail.Text = "";
            txtPhone.Text = "";
            txtDateOfBirth.Text = "";
            ddlGender.SelectedIndex = 0;
            ddlBloodGroup.SelectedIndex = 0;
            txtAddress.Text = "";
            txtFatherName.Text = "";
            txtMotherName.Text = "";
            txtParentPhone.Text = "";
            ddlClass.SelectedIndex = 0;
            txtAdmissionDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            // Don't clear roll number when clearing form
            GenerateRollNumber(); // Generate new roll number after clear
        }
    }
}