using System;
using System.ComponentModel.DataAnnotations;

namespace School_Managenment_System12._00.Models
{
    public class Exams
    {
        public int ExamId { get; set; }

        [Required(ErrorMessage = "Exam Name is required")]
        [StringLength(100, ErrorMessage = "Exam Name cannot exceed 100 characters")]
        public string ExamName { get; set; }

        [Required(ErrorMessage = "Exam Type is required")]
        public string ExamType { get; set; }

        [Required(ErrorMessage = "Class is required")]
        public int ClassId { get; set; }

        [Required(ErrorMessage = "Start Date is required")]
        public DateTime StartDate { get; set; }

        [Required(ErrorMessage = "End Date is required")]
        public DateTime EndDate { get; set; }

        [Required(ErrorMessage = "Total Marks is required")]
        [Range(1, 1000, ErrorMessage = "Total Marks must be between 1 and 1000")]
        public decimal TotalMarks { get; set; } = 100;

        [Required(ErrorMessage = "Passing Marks is required")]
        [Range(1, 1000, ErrorMessage = "Passing Marks must be between 1 and 1000")]
        public decimal PassingMarks { get; set; } = 33;

        public bool IsActive { get; set; } = true;
        public DateTime CreatedDate { get; set; } = DateTime.Now;

       
        public string ClassName { get; set; }
    }

    public class Class
    {
        public int ClassID { get; set; }

        [Required(ErrorMessage = "Class Name is required")]
        [StringLength(50, ErrorMessage = "Class Name cannot exceed 50 characters")]
        public string ClassName { get; set; }
    }
}