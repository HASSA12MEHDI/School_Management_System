<%@ Page Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Exams.aspx.cs" Inherits="School_Managenment_System12._00.Exams" Title="Exam Management" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
     :root {
         --primary: #4361ee;
         --secondary: #3f37c9;
         --success: #4cc9f0;
         --light: #f8f9fa;
         --dark: #212529;
         --danger: #e63946;
         --warning: #fca311;
         --info: #4895ef;
         --border: #dee2e6;
         --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
     }

     .page-title {
         text-align: center;
         margin: 2rem 0;
         color: var(--dark);
         position: relative;
     }

         .page-title:after {
             content: '';
             display: block;
             width: 80px;
             height: 4px;
             background: var(--primary);
             margin: 10px auto;
             border-radius: 2px;
         }

     .card {
         background: white;
         border-radius: 10px;
         box-shadow: var(--shadow);
         margin-bottom: 1.5rem;
         overflow: hidden;
     }

     .card-header {
         background-color: var(--primary);
         color: white;
         padding: 1rem 1.5rem;
         font-weight: 600;
         display: flex;
         justify-content: space-between;
         align-items: center;
     }

     .card-body {
         padding: 1.5rem;
     }

     .form-group {
         margin-bottom: 1.2rem;
     }

     label {
         display: block;
         margin-bottom: 0.5rem;
         font-weight: 500;
         color: #495057;
     }

     .form-control {
         width: 100%;
         padding: 0.75rem 1rem;
         border: 1px solid var(--border);
         border-radius: 5px;
         font-size: 1rem;
         transition: all 0.3s;
     }

         .form-control:focus {
             outline: none;
             border-color: var(--primary);
             box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
         }

     .btn {
         padding: 0.75rem 1.5rem;
         border: none;
         border-radius: 5px;
         font-size: 1rem;
         font-weight: 500;
         cursor: pointer;
         transition: all 0.3s;
         display: inline-flex;
         align-items: center;
         justify-content: center;
         gap: 8px;
     }

     .btn-primary {
         background-color: var(--primary);
         color: white;
     }

         .btn-primary:hover {
             background-color: var(--secondary);
             transform: translateY(-2px);
         }

     .btn-danger {
         background-color: var(--danger);
         color: white;
     }

     .btn-sm {
         padding: 0.5rem 1rem;
         font-size: 0.875rem;
     }

     .row {
         display: flex;
         flex-wrap: wrap;
         margin: 0 -10px;
     }

     .col-6 {
         flex: 0 0 50%;
         padding: 0 10px;
     }

     .table-container {
         overflow-x: auto;
         width: 100%;
     }

     table {
         width: 100%;
         border-collapse: collapse;
         margin: 1rem 0;
         table-layout: fixed;
     }

     thead {
         background-color: #f1f5fd;
     }

     th, td {
         padding: 12px 8px;
         text-align: left;
         border-bottom: 1px solid var(--border);
         word-wrap: break-word;
         overflow-wrap: break-word;
         white-space: normal;
     }

     th {
         font-weight: 600;
         color: var(--dark);
         background-color: #f8f9fa;
     }

     tr:hover {
         background-color: #f8fafc;
     }

     /* Fixed column widths for better text display */
     th:nth-child(1), td:nth-child(1) { width: 18%; } /* Exam Name */
     th:nth-child(2), td:nth-child(2) { width: 10%; } /* Type */
     th:nth-child(3), td:nth-child(3) { width: 10%; } /* Class */
     th:nth-child(4), td:nth-child(4) { width: 12%; } /* Start Date */
     th:nth-child(5), td:nth-child(5) { width: 12%; } /* End Date */
     th:nth-child(6), td:nth-child(6) { width: 10%; } /* Total Marks */
     th:nth-child(7), td:nth-child(7) { width: 12%; } /* Passing Marks */
     th:nth-child(8), td:nth-child(8) { width: 8%; }  /* Status */
     th:nth-child(9), td:nth-child(9) { width: 8%; }  /* Actions */

     .badge {
         display: inline-block;
         padding: 0.35rem 0.65rem;
         font-size: 0.75rem;
         font-weight: 600;
         line-height: 1;
         text-align: center;
         white-space: nowrap;
         vertical-align: baseline;
         border-radius: 0.375rem;
     }

     .badge-primary {
         background-color: var(--primary);
         color: white;
     }

     .badge-success {
         background-color: #28a745;
         color: white;
     }

     .badge-warning {
         background-color: var(--warning);
         color: white;
     }

     .badge-danger {
         background-color: var(--danger);
         color: white;
     }

     .actions {
         display: flex;
         gap: 6px;
         justify-content: center;
     }

     .search-box {
         display: flex;
         margin-bottom: 1.5rem;
     }

         .search-box .form-control {
             border-top-right-radius: 0;
             border-bottom-right-radius: 0;
         }

         .search-box .btn {
             border-top-left-radius: 0;
             border-bottom-left-radius: 0;
         }

     .stats-cards {
         display: grid;
         grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
         gap: 20px;
         margin-bottom: 2rem;
     }

     .stat-card {
         background: white;
         border-radius: 10px;
         padding: 1.5rem;
         box-shadow: var(--shadow);
         display: flex;
         align-items: center;
     }

     .stat-icon {
         width: 60px;
         height: 60px;
         border-radius: 10px;
         display: flex;
         align-items: center;
         justify-content: center;
         margin-right: 1rem;
         font-size: 1.8rem;
         color: white;
     }

     .stat-info h3 {
         font-size: 1.8rem;
         margin-bottom: 0.2rem;
     }

     .stat-info p {
         color: #6c757d;
         font-size: 0.9rem;
     }

     .icon-1 {
         background-color: var(--primary);
     }

     .icon-2 {
         background-color: var(--success);
     }

     .icon-3 {
         background-color: var(--warning);
     }

     .icon-4 {
         background-color: var(--danger);
     }

     .success-message {
         background-color: #d4edda;
         color: #155724;
         padding: 12px;
         border-radius: 5px;
         margin-bottom: 1rem;
         border: 1px solid #c3e6cb;
     }

     .error-message {
         color: var(--danger);
         font-size: 0.875rem;
         margin-top: 0.25rem;
     }

     .loading-overlay {
         position: fixed;
         top: 0;
         left: 0;
         width: 100%;
         height: 100%;
         background: rgba(0,0,0,0.5);
         display: flex;
         justify-content: center;
         align-items: center;
         z-index: 9999;
         color: white;
         font-size: 1.2rem;
     }

     .spinner {
         border: 4px solid #f3f3f3;
         border-top: 4px solid var(--primary);
         border-radius: 50%;
         width: 40px;
         height: 40px;
         animation: spin 2s linear infinite;
         margin-right: 10px;
     }

     @keyframes spin {
         0% { transform: rotate(0deg); }
         100% { transform: rotate(360deg); }
     }

     /* Text display improvements */
     .exam-table td {
         max-width: 200px;
         min-width: 80px;
     }

     .text-ellipsis {
         white-space: nowrap;
         overflow: hidden;
         text-overflow: ellipsis;
     }

     @media (max-width: 768px) {
         .col-6 {
             flex: 0 0 100%;
             margin-bottom: 1rem;
         }

         .stats-cards {
             grid-template-columns: 1fr;
         }

         /* Mobile responsive table */
         .table-container {
             font-size: 0.875rem;
         }

         th, td {
             padding: 8px 4px;
         }

         th:nth-child(1), td:nth-child(1) { width: 20%; }
         th:nth-child(2), td:nth-child(2) { width: 12%; }
         th:nth-child(3), td:nth-child(3) { width: 12%; }
         th:nth-child(4), td:nth-child(4) { width: 14%; }
         th:nth-child(5), td:nth-child(5) { width: 14%; }
         th:nth-child(6), td:nth-child(6) { width: 10%; }
         th:nth-child(7), td:nth-child(7) { width: 10%; }
         th:nth-child(8), td:nth-child(8) { width: 8%; }
     }

     @media (max-width: 480px) {
         .table-container {
             font-size: 0.8rem;
         }
         
         th, td {
             padding: 6px 3px;
         }
         
         .actions {
             flex-direction: column;
             gap: 3px;
         }
         
         .btn-sm {
             padding: 0.3rem 0.6rem;
             font-size: 0.75rem;
         }
     }
 </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="100">
        <ProgressTemplate>
            <div class="loading-overlay">
                <div class="spinner"></div>
                <span>Processing...</span>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <div class="container">
        <!-- Success Message -->
        <asp:Panel ID="pnlSuccess" runat="server" CssClass="success-message" Visible="false">
            <asp:Label ID="lblSuccessMessage" runat="server"></asp:Label>
        </asp:Panel>

        <h1 class="page-title">Exam Management</h1>

        <!-- Statistics Cards -->
        <div class="stats-cards">
            <div class="stat-card">
                <div class="stat-icon icon-1">
                    <i class="fas fa-file-alt"></i>
                </div>
                <div class="stat-info">
                    <h3><asp:Label ID="lblTotalExams" runat="server" Text="0"></asp:Label></h3>
                    <p>Total Exams</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-2">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-info">
                    <h3><asp:Label ID="lblActiveExams" runat="server" Text="0"></asp:Label></h3>
                    <p>Active Exams</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-3">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-info">
                    <h3><asp:Label ID="lblUpcomingExams" runat="server" Text="0"></asp:Label></h3>
                    <p>Upcoming Exams</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-4">
                    <i class="fas fa-times-circle"></i>
                </div>
                <div class="stat-info">
                    <h3><asp:Label ID="lblCompletedExams" runat="server" Text="0"></asp:Label></h3>
                    <p>Completed Exams</p>
                </div>
            </div>
        </div>

        <!-- Add/Edit Exam Form -->
        <div class="card">
            <div class="card-header">
                <span><asp:Label ID="lblFormTitle" runat="server" Text="Add New Exam"></asp:Label></span>
                <i class="fas fa-plus"></i>
            </div>
            <div class="card-body">
                <asp:HiddenField ID="hfExamId" runat="server" Value="0" />

                <div class="row">
                    <div class="col-6">
                        <div class="form-group">
                            <label for="txtExamName">Exam Name *</label>
                            <asp:TextBox ID="txtExamName" runat="server" CssClass="form-control" placeholder="Enter exam name" MaxLength="100"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvExamName" runat="server" ControlToValidate="txtExamName"
                                ErrorMessage="Exam Name is required" CssClass="error-message" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="form-group">
                            <label for="ddlExamType">Exam Type *</label>
                            <asp:DropDownList ID="ddlExamType" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select exam type</asp:ListItem>
                                <asp:ListItem Value="Monthly">Monthly</asp:ListItem>
                                <asp:ListItem Value="Term">Term</asp:ListItem>
                                <asp:ListItem Value="Final">Final</asp:ListItem>
                                <asp:ListItem Value="Practical">Practical</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvExamType" runat="server" ControlToValidate="ddlExamType"
                                ErrorMessage="Exam Type is required" CssClass="error-message" Display="Dynamic" InitialValue=""></asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-6">
                        <div class="form-group">
                            <label for="ddlClass">Class *</label>
                            <asp:DropDownList ID="ddlClass" runat="server" CssClass="form-control">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvClass" runat="server" ControlToValidate="ddlClass"
                                ErrorMessage="Class is required" CssClass="error-message" Display="Dynamic" InitialValue=""></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="form-group">
                            <label for="txtTotalMarks">Total Marks *</label>
                            <asp:TextBox ID="txtTotalMarks" runat="server" CssClass="form-control" TextMode="Number" Text="100" min="1" max="1000"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvTotalMarks" runat="server" ControlToValidate="txtTotalMarks"
                                ErrorMessage="Total Marks is required" CssClass="error-message" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="rvTotalMarks" runat="server" ControlToValidate="txtTotalMarks"
                                Type="Double" MinimumValue="1" MaximumValue="1000" ErrorMessage="Total Marks must be between 1 and 1000"
                                CssClass="error-message" Display="Dynamic"></asp:RangeValidator>
                        </div>
                    </div>
                </div>

                <!-- Separate Date and Time fields -->
                <div class="row">
                    <div class="col-6">
                        <div class="form-group">
                            <label for="txtStartDate">Start Date *</label>
                            <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="txtStartDate"
                                ErrorMessage="Start Date is required" CssClass="error-message" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="form-group">
                            <label for="txtStartTime">Start Time *</label>
                            <asp:TextBox ID="txtStartTime" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvStartTime" runat="server" ControlToValidate="txtStartTime"
                                ErrorMessage="Start Time is required" CssClass="error-message" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-6">
                        <div class="form-group">
                            <label for="txtEndDate">End Date *</label>
                            <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ControlToValidate="txtEndDate"
                                ErrorMessage="End Date is required" CssClass="error-message" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="form-group">
                            <label for="txtEndTime">End Time *</label>
                            <asp:TextBox ID="txtEndTime" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEndTime" runat="server" ControlToValidate="txtEndTime"
                                ErrorMessage="End Time is required" CssClass="error-message" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-6">
                        <div class="form-group">
                            <label for="txtPassingMarks">Passing Marks *</label>
                            <asp:TextBox ID="txtPassingMarks" runat="server" CssClass="form-control" TextMode="Number" Text="33" min="1" max="1000"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPassingMarks" runat="server" ControlToValidate="txtPassingMarks"
                                ErrorMessage="Passing Marks is required" CssClass="error-message" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="rvPassingMarks" runat="server" ControlToValidate="txtPassingMarks"
                                Type="Double" MinimumValue="1" MaximumValue="1000" ErrorMessage="Passing Marks must be between 1 and 1000"
                                CssClass="error-message" Display="Dynamic"></asp:RangeValidator>
                            <asp:CompareValidator ID="cvPassingMarks" runat="server" ControlToValidate="txtPassingMarks"
                                ControlToCompare="txtTotalMarks" Operator="LessThanEqual" Type="Double"
                                ErrorMessage="Passing Marks cannot be greater than Total Marks"
                                CssClass="error-message" Display="Dynamic"></asp:CompareValidator>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="form-group">
                            <label for="ddlIsActive">Status</label>
                            <asp:DropDownList ID="ddlIsActive" runat="server" CssClass="form-control">
                                <asp:ListItem Value="true">Active</asp:ListItem>
                                <asp:ListItem Value="false">Inactive</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>

                <!-- Date Comparison Validator -->
                <div class="form-group">
                    <asp:CustomValidator ID="cvDateComparison" runat="server"
                        ErrorMessage="End Date/Time must be greater than or equal to Start Date/Time"
                        CssClass="error-message" Display="Dynamic"
                        OnServerValidate="CvDateComparison_ServerValidate">
                    </asp:CustomValidator>
                </div>

                <div class="form-group" style="text-align: right; margin-top: 1.5rem;">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-danger" OnClick="BtnCancel_Click" CausesValidation="false" />
                    <asp:Button ID="btnSave" runat="server" Text="Save Exam" CssClass="btn btn-primary" OnClick="BtnSave_Click" />
                </div>
            </div>
        </div>

        <!-- Exams List -->
        <div class="card">
            <div class="card-header">
                <span>Exam List</span>
                <div class="search-box">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search exams..." MaxLength="50"></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="BtnSearch_Click" CausesValidation="false" />
                </div>
            </div>
            <div class="card-body">
                <div class="table-container">
                    <asp:Repeater ID="rptExams" runat="server" OnItemCommand="RptExams_ItemCommand">
                        <HeaderTemplate>
                            <table class="exam-table">
                                <thead>
                                    <tr>
                                        <th>Exam Name</th>
                                        <th>Type</th>
                                        <th>Class</th>
                                        <th>Start DateTime</th>
                                        <th>End DateTime</th>
                                        <th>Total Marks</th>
                                        <th>Passing Marks</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="text-ellipsis" title='<%# Eval("ExamName") %>'><%# Eval("ExamName") %></td>
                                <td>
                                    <span class='badge <%# GetExamTypeBadgeClass(Eval("ExamType").ToString()) %>'>
                                        <%# Eval("ExamType") %>
                                    </span>
                                </td>
                                <td><%# Eval("ClassName") %></td>
                                <td><%# Convert.ToDateTime(Eval("StartDate")).ToString("yyyy-MM-dd HH:mm") %></td>
                                <td><%# Convert.ToDateTime(Eval("EndDate")).ToString("yyyy-MM-dd HH:mm") %></td>
                                <td><%# Eval("TotalMarks") %></td>
                                <td><%# Eval("PassingMarks") %></td>
                                <td>
                                    <span class='badge <%# Convert.ToBoolean(Eval("IsActive")) ? "badge-success" : "badge-danger" %>'>
                                        <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                    </span>
                                </td>
                                <td class="actions">
                                    <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn btn-sm btn-primary"
                                        CommandName="Edit" CommandArgument='<%# Eval("ExamId") %>' ToolTip="Edit" CausesValidation="false">
                                        <i class="fas fa-edit"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-sm btn-danger"
                                        CommandName="Delete" CommandArgument='<%# Eval("ExamId") %>' ToolTip="Delete" CausesValidation="false"
                                        OnClientClick='<%# "return confirmDelete(\"" + Eval("ExamName") + "\");" %>'>
                                        <i class="fas fa-trash"></i>
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <asp:Label ID="lblNoRecords" runat="server" Text="No exams found." Visible="false"
                        Style="text-align: center; display: block; padding: 2rem; color: #6c757d;"></asp:Label>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function validateDateTime() {
            const startDate = document.getElementById('<%= txtStartDate.ClientID %>');
    const startTime = document.getElementById('<%= txtStartTime.ClientID %>');
    const endDate = document.getElementById('<%= txtEndDate.ClientID %>');
    const endTime = document.getElementById('<%= txtEndTime.ClientID %>');
    const validator = document.getElementById('<%= cvDateComparison.ClientID %>');

    if (startDate && startTime && endDate && endTime &&
        startDate.value && startTime.value && endDate.value && endTime.value) {

        const startDateTime = new Date(startDate.value + 'T' + startTime.value);
        const endDateTime = new Date(endDate.value + 'T' + endTime.value);
        if (endDateTime < startDateTime) {
            if (validator) {
                validator.style.display = 'block';
            }
            endDate.style.borderColor = 'red';
            endTime.style.borderColor = 'red';
        } else {
            if (validator) {
                validator.style.display = 'none';
            }
            endDate.style.borderColor = '';
            endTime.style.borderColor = '';
        }
    }
}
    </script>
</asp:Content>