<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewResults.aspx.cs" Inherits="School_Management_System.ViewResults" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Student Results</title>
    <style>
        .container {
            width: 95%;
            margin: 20px auto;
            font-family: Arial, sans-serif;
        }
        .header {
            background: #2c3e50;
            color: white;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .filters {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #dee2e6;
        }
        .filter-row {
            display: flex;
            gap: 15px;
            align-items: end;
            flex-wrap: wrap;
        }
        .filter-group {
            flex: 1;
            min-width: 200px;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ced4da;
            border-radius: 4px;
        }
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 2px;
        }
        .btn-primary {
            background: #007bff;
            color: white;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-export {
            background: #28a745;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 5px;
        }
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 5px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
        }
        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: #2c3e50;
        }
        .stat-label {
            color: #6c757d;
            margin-top: 5px;
        }
        .results-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .results-table th,
        .results-table td {
            padding: 12px;
            text-align: left;
            border: 1px solid #dee2e6;
        }
        .results-table th {
            background: #343a40;
            color: white;
        }
        .results-table tr:nth-child(even) {
            background: #f8f9fa;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        .btn-sm {
            padding: 5px 10px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        .btn-edit {
            background: #ffc107;
            color: black;
        }
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        .message-panel {
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        .success-message {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error-message {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .grade-A { background-color: #d4edda !important; }
        .grade-B { background-color: #fff3cd !important; }
        .grade-C { background-color: #ffeaa7 !important; }
        .grade-D { background-color: #f8d7da !important; }
        .grade-F { background-color: #f5c6cb !important; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h1>📋 Student Results Dashboard</h1>
                <p>View and manage all student examination results</p>
            </div>

            <div class="filters">
                <div class="filter-row">
                    <div class="filter-group">
                        <label for="ddlFilterStudent">Filter by Student</label>
                        <asp:DropDownList ID="ddlFilterStudent" runat="server" CssClass="form-control">
                            <asp:ListItem Text="All Students" Value=""></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="filter-group">
                        <label for="ddlFilterExam">Filter by Exam</label>
                        <asp:DropDownList ID="ddlFilterExam" runat="server" CssClass="form-control">
                            <asp:ListItem Text="All Exams" Value=""></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="filter-group">
                        <label for="ddlFilterSubject">Filter by Subject</label>
                        <asp:DropDownList ID="ddlFilterSubject" runat="server" CssClass="form-control">
                            <asp:ListItem Text="All Subjects" Value=""></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="filter-group">
                        <asp:Button ID="btnFilter" runat="server" Text="🔍 Apply Filters" CssClass="btn btn-primary" OnClick="BtnFilter_Click" />
                        <asp:Button ID="btnReset" runat="server" Text="🔄 Reset" CssClass="btn btn-secondary" OnClick="BtnReset_Click" />
                    </div>
                </div>
            </div>

            <div class="content">
                <asp:Panel ID="pnlMessage" runat="server" CssClass="message-panel" Visible="false">
                    <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
                </asp:Panel>

                <div class="export-buttons">
                    <asp:Button ID="AddNew" runat="server" PostBackUrl="~/Results.aspx" Text="📄 Add New Result" CssClass="btn-export" />
                </div>

                <div class="stats-cards">
                    <div class="stat-card">
                        <div class="stat-number" id="totalResults" runat="server">0</div>
                        <div class="stat-label">Total Results</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number" id="avgMarks" runat="server">0.00</div>
                        <div class="stat-label">Average Marks</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number" id="passRate" runat="server">0%</div>
                        <div class="stat-label">Pass Rate</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number" id="topGrade" runat="server">N/A</div>
                        <div class="stat-label">Top Grade</div>
                    </div>
                </div>

                <asp:GridView ID="gvResults" runat="server" AutoGenerateColumns="False" CssClass="results-table"
                    EmptyDataText="No results found." OnRowDataBound="GvResults_RowDataBound"
                    OnRowCommand="GvResults_RowCommand" DataKeyNames="ResultId">
                    <Columns>
                        <asp:BoundField DataField="ResultId" HeaderText="ID" ItemStyle-Width="50px" />
                        <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                        <asp:BoundField DataField="ExamName" HeaderText="Exam" />
                        <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                        <asp:BoundField DataField="MarksObtained" HeaderText="Marks" DataFormatString="{0:0.00}" ItemStyle-Width="80px" />
                        <asp:BoundField DataField="Grade" HeaderText="Grade" ItemStyle-Width="70px" />
                        <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                        <asp:BoundField DataField="EnteredDate" HeaderText="Date Added" DataFormatString="{0:dd/MM/yyyy HH:mm}" ItemStyle-Width="120px" />
                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="120px">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <asp:Button ID="btnEdit" runat="server" Text="✏️" CssClass="btn-sm btn-edit" 
                                        CommandName="EditResult" CommandArgument='<%# Eval("ResultId") %>' ToolTip="Edit" />
                                    <asp:Button ID="btnDelete" runat="server" Text="🗑️" CssClass="btn-sm btn-delete" 
                                        CommandName="DeleteResult" CommandArgument='<%# Eval("ResultId") %>' ToolTip="Delete"
                                        OnClientClick="return confirm('Are you sure you want to delete this result?');" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>