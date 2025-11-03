using School_Managenment_System12._00.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace School_Managenment_System12._00
{
    public partial class Exams : System.Web.UI.Page
    {
        private readonly ExamRepository examRepository = new ExamRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadClasses();
                LoadExamStats();
                LoadExams();
                SetDefaultDateTime();
            }
        }

        private void LoadClasses()
        {
            try
            {
                var classes = examRepository.GetAllClasses();
                ddlClass.DataSource = classes;
                ddlClass.DataTextField = "ClassName";
                ddlClass.DataValueField = "ClassID";
                ddlClass.DataBind();
                ddlClass.Items.Insert(0, new ListItem("Select Class", ""));
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading classes: " + ex.Message);
            }
        }

        private void LoadExamStats()
        {
            try
            {
                var stats = examRepository.GetExamStats();
                lblTotalExams.Text = stats["TotalExams"].ToString();
                lblActiveExams.Text = stats["ActiveExams"].ToString();
                lblUpcomingExams.Text = stats["UpcomingExams"].ToString();
                lblCompletedExams.Text = stats["CompletedExams"].ToString();
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading exam statistics: " + ex.Message);
            }
        }

        private void LoadExams()
        {
            try
            {
                var exams = examRepository.GetAllExams();

                if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                {
                    exams = exams.Where(e => e.ExamName.ToLower().Contains(txtSearch.Text.ToLower()) ||
                                            e.ClassName.ToLower().Contains(txtSearch.Text.ToLower())).ToList();
                }

                rptExams.DataSource = exams;
                rptExams.DataBind();
                lblNoRecords.Visible = exams.Count == 0;
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading exams: " + ex.Message);
            }
        }

        private void SetDefaultDateTime()
        {
            if (string.IsNullOrEmpty(txtStartDate.Text))
                txtStartDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

            if (string.IsNullOrEmpty(txtStartTime.Text))
                txtStartTime.Text = DateTime.Now.ToString("HH:mm");

            if (string.IsNullOrEmpty(txtEndDate.Text))
                txtEndDate.Text = DateTime.Now.AddDays(7).ToString("yyyy-MM-dd");

            if (string.IsNullOrEmpty(txtEndTime.Text))
                txtEndTime.Text = DateTime.Now.ToString("HH:mm");
        }

        private void ClearForm()
        {
            hfExamId.Value = "0";
            txtExamName.Text = "";
            ddlExamType.SelectedIndex = 0;
            ddlClass.SelectedIndex = 0;
            txtTotalMarks.Text = "100";
            txtPassingMarks.Text = "33";
            ddlIsActive.SelectedValue = "true";
            SetDefaultDateTime();
            lblFormTitle.Text = "Add New Exam";

            // Clear validators
            foreach (var validator in Page.Validators)
            {
                if (validator is BaseValidator baseValidator)
                {
                    baseValidator.IsValid = true;
                }
            }
        }

        private void ShowSuccessMessage(string message)
        {
            pnlSuccess.Visible = true;
            lblSuccessMessage.Text = message;
            pnlSuccess.Style["background-color"] = "#d4edda";
            pnlSuccess.Style["color"] = "#155724";
            pnlSuccess.Style["border-color"] = "#c3e6cb";
        }

        private void ShowErrorMessage(string message)
        {
            pnlSuccess.Visible = true;
            lblSuccessMessage.Text = message;
            pnlSuccess.Style["background-color"] = "#f8d7da";
            pnlSuccess.Style["color"] = "#721c24";
            pnlSuccess.Style["border-color"] = "#f5c6cb";
        }

        protected void CvDateComparison_ServerValidate(object source, ServerValidateEventArgs args)
        {
            try
            {
                if (!string.IsNullOrEmpty(txtStartDate.Text) && !string.IsNullOrEmpty(txtStartTime.Text) &&
                    !string.IsNullOrEmpty(txtEndDate.Text) && !string.IsNullOrEmpty(txtEndTime.Text))
                {
                    DateTime startDate = DateTime.Parse(txtStartDate.Text + " " + txtStartTime.Text);
                    DateTime endDate = DateTime.Parse(txtEndDate.Text + " " + txtEndTime.Text);

                    args.IsValid = (endDate >= startDate);
                }
                else
                {
                    args.IsValid = true;
                }
            }
            catch
            {
                args.IsValid = false;
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (!ValidateForm())
                return;

            if (Page.IsValid)
            {
                try
                {
                    // ✅ FIX: Use the correct model class
                    var exam = new School_Managenment_System12._00.Models.Exams();

                    exam.ExamId = Convert.ToInt32(hfExamId.Value);
                    exam.ExamName = txtExamName.Text.Trim();
                    exam.ExamType = ddlExamType.SelectedValue;
                    exam.ClassId = Convert.ToInt32(ddlClass.SelectedValue);

                    // Combine date and time
                    exam.StartDate = DateTime.Parse(txtStartDate.Text + " " + txtStartTime.Text);
                    exam.EndDate = DateTime.Parse(txtEndDate.Text + " " + txtEndTime.Text);

                    exam.TotalMarks = Convert.ToDecimal(txtTotalMarks.Text);
                    exam.PassingMarks = Convert.ToDecimal(txtPassingMarks.Text);
                    exam.IsActive = Convert.ToBoolean(ddlIsActive.SelectedValue);
                    exam.CreatedDate = DateTime.Now;

                    bool result;
                    if (exam.ExamId == 0)
                    {
                        result = examRepository.AddExam(exam);
                        if (result)
                            ShowSuccessMessage("Exam added successfully!");
                        else
                            ShowErrorMessage("Failed to add exam. Please try again.");
                    }
                    else
                    {
                        result = examRepository.UpdateExam(exam);
                        if (result)
                            ShowSuccessMessage("Exam updated successfully!");
                        else
                            ShowErrorMessage("Failed to update exam. Please try again.");
                    }

                    if (result)
                    {
                        ClearForm();
                        LoadExamStats();
                        LoadExams();
                    }
                }
                catch (Exception ex)
                {
                    ShowErrorMessage("Error saving exam: " + ex.Message);
                }
            }
        }

        private bool ValidateForm()
        {
            // Validate passing marks vs total marks
            if (decimal.TryParse(txtTotalMarks.Text, out decimal totalMarks) &&
                decimal.TryParse(txtPassingMarks.Text, out decimal passingMarks))
            {
                if (passingMarks >= totalMarks)
                {
                    ShowErrorMessage("Error: Passing marks must be less than total marks");
                    return false;
                }
            }

            // Validate dates are in valid SQL range
            if (!ValidateSqlDates())
            {
                ShowErrorMessage("Error: Dates must be within valid range (1753-9999)");
                return false;
            }

            // ✅ No past date validation - allowing any dates including past ones
            return true;
        }

        private bool ValidateSqlDates()
        {
            try
            {
                DateTime minSqlDate = new DateTime(1753, 1, 1);
                DateTime maxSqlDate = new DateTime(9999, 12, 31);

                if (!string.IsNullOrEmpty(txtStartDate.Text))
                {
                    DateTime startDate = DateTime.Parse(txtStartDate.Text + " " + txtStartTime.Text);
                    if (startDate < minSqlDate || startDate > maxSqlDate)
                        return false;
                }

                if (!string.IsNullOrEmpty(txtEndDate.Text))
                {
                    DateTime endDate = DateTime.Parse(txtEndDate.Text + " " + txtEndTime.Text);
                    if (endDate < minSqlDate || endDate > maxSqlDate)
                        return false;
                }

                return true;
            }
            catch
            {
                return false;
            }
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            LoadExams();
        }

        protected void RptExams_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                int examId = Convert.ToInt32(e.CommandArgument);
                LoadExamForEdit(examId);
            }
            else if (e.CommandName == "Delete")
            {
                int examId = Convert.ToInt32(e.CommandArgument);
                DeleteExam(examId);
            }
        }

        private void LoadExamForEdit(int examId)
        {
            try
            {
                var exam = examRepository.GetExamById(examId);
                if (exam != null)
                {
                    hfExamId.Value = exam.ExamId.ToString();
                    txtExamName.Text = exam.ExamName;
                    ddlExamType.SelectedValue = exam.ExamType;
                    ddlClass.SelectedValue = exam.ClassId.ToString();

                    // Separate date and time
                    txtStartDate.Text = exam.StartDate.ToString("yyyy-MM-dd");
                    txtStartTime.Text = exam.StartDate.ToString("HH:mm");
                    txtEndDate.Text = exam.EndDate.ToString("yyyy-MM-dd");
                    txtEndTime.Text = exam.EndDate.ToString("HH:mm");

                    txtTotalMarks.Text = exam.TotalMarks.ToString();
                    txtPassingMarks.Text = exam.PassingMarks.ToString();
                    ddlIsActive.SelectedValue = exam.IsActive.ToString().ToLower();

                    lblFormTitle.Text = "Edit Exam";
                    ScriptManager.RegisterStartupScript(this, GetType(), "scrollToForm", "window.scrollTo(0, 0);", true);
                }
                else
                {
                    ShowErrorMessage("Exam not found!");
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading exam for edit: " + ex.Message);
            }
        }

        private void DeleteExam(int examId)
        {
            try
            {
                bool result = examRepository.DeleteExam(examId);
                if (result)
                {
                    ShowSuccessMessage("Exam deleted successfully!");
                    LoadExamStats();
                    LoadExams();
                }
                else
                {
                    ShowErrorMessage("Failed to delete exam. Please try again.");
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error deleting exam: " + ex.Message);
            }
        }

        public string GetExamTypeBadgeClass(string examType)
        {
            switch (examType.ToLower())
            {
                case "monthly":
                    return "badge-warning";
                case "practical":
                    return "badge-danger";
                case "term":
                    return "badge-info";
                case "final":
                    return "badge-primary";
                default:
                    return "badge-primary";
            }
        }
    }
}