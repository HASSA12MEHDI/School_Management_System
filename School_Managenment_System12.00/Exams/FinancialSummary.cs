using System;

namespace SchoolFinancialManagementSystem.Models
{
    public class FinancialSummary
    {
        public decimal TotalIncome { get; set; }
        public decimal TotalExpenses { get; set; }
        public decimal NetBalance { get; set; }
        public decimal BudgetUtilization { get; set; }
        public int ActiveAlerts { get; set; }
        public decimal IncomeTrend { get; set; }
        public decimal ExpenseTrend { get; set; }
    }

    public class Transaction
    {
        public string Type { get; set; }
        public DateTime Date { get; set; }
        public string Description { get; set; }
        public string Category { get; set; }
        public decimal Amount { get; set; }
    }

    public class BudgetAlert
    {
        public string Category { get; set; }
        public decimal BudgetAmount { get; set; }
        public decimal ActualAmount { get; set; }
        public string Status { get; set; }
    }
}