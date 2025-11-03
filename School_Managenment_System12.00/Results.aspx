<%@ Page Title="Results Management" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Results.aspx.cs" Inherits="School_Management_System.Results" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #4895ef;
            --primary-dark: #3a0ca3;
            --secondary: #7209b7;
            --success: #4cc9f0;
            --warning: #f72585;
            --error: #e63946;
            --background: #f8f9fa;
            --surface: #ffffff;
            --border: #e9ecef;
            --text: #2b2d42;
            --text-light: #6c757d;
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        .results-container {
            background: var(--background);
            min-height: 100vh;
            padding: 2rem 0;
        }

        .content-wrapper {
            background: var(--surface);
            border-radius: 15px;
            box-shadow: var(--shadow);
            overflow: hidden;
            margin: 0 auto;
            max-width: 1000px;
        }

        .header-section {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }

            .header-section h1 {
                font-size: 2.2rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }

            .header-section p {
                font-size: 1.1rem;
                opacity: 0.9;
                margin: 0;
            }

        .main-body {
            padding: 2rem;
        }

        .form-section {
            background: var(--surface);
            border-radius: 12px;
            border: 1px solid var(--border);
            padding: 2rem;
            box-shadow: var(--shadow);
        }

        .section-title {
            color: var(--text);
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 3px solid var(--primary);
            display: inline-block;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-label {
            display: block;
            color: var(--text);
            font-weight: 600;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid var(--border);
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: var(--surface);
        }

            .form-control:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
            }

        .results-display {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin: 1.5rem 0;
        }

        .grade-box, .remarks-box {
            padding: 1.5rem;
            border-radius: 10px;
            text-align: center;
            color: white;
            font-weight: 600;
        }

        .grade-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .remarks-box {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .button-group {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-top: 1.5rem;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

            .btn-primary:hover {
                background: var(--primary-dark);
                transform: translateY(-2px);
                box-shadow: var(--shadow);
            }

        .btn-outline {
            background: transparent;
            border: 2px solid var(--border);
            color: var(--text);
        }

            .btn-outline:hover {
                border-color: var(--primary);
                color: var(--primary);
            }

        .alert {
            padding: 1rem 1.25rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            border: none;
        }

        .alert-success {
            background: #ecfdf5;
            color: #065f46;
            border-left: 4px solid #10b981;
        }

        .alert-error {
            background: #fef2f2;
            color: #991b1b;
            border-left: 4px solid #ef4444;
        }

        .validation-error {
            color: var(--error);
            font-size: 0.85rem;
            margin-top: 0.25rem;
            display: block;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .results-display {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                justify-content: center;
            }

            .main-body {
                padding: 1rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="results-container">
        <div class="content-wrapper">
            <!-- Header -->
            <div class="header-section">
                <h1>Student Results Management</h1>
                <p>Add and manage student examination results</p>
            </div>

            <div class="main-body">
                <!-- Message Alert -->
                <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert" role="alert">
                    <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
                </asp:Panel>

                <!-- Add Result Form -->
                <div class="form-section">
                    <div class="section-title">Add New Result</div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">Student</label>
                            <asp:DropDownList ID="ddlStudent" runat="server" CssClass="form-control">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvStudent" runat="server"
                                ControlToValidate="ddlStudent" InitialValue=""
                                ErrorMessage="Please select a student"
                                CssClass="validation-error" Display="Dynamic">
                            </asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Exam</label>
                            <asp:DropDownList ID="ddlExam" runat="server" CssClass="form-control">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvExam" runat="server"
                                ControlToValidate="ddlExam" InitialValue=""
                                ErrorMessage="Please select an exam"
                                CssClass="validation-error" Display="Dynamic">
                            </asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Subject</label>
                            <asp:DropDownList ID="ddlSubject" runat="server" CssClass="form-control">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvSubject" runat="server"
                                ControlToValidate="ddlSubject" InitialValue=""
                                ErrorMessage="Please select a subject"
                                CssClass="validation-error" Display="Dynamic">
                            </asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Marks Obtained</label>
                            <asp:TextBox ID="txtMarks" runat="server" CssClass="form-control"
                                placeholder="Enter marks (0-100)" TextMode="Number" step="0.01"
                                onkeyup="calculateGrade()">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvMarks" runat="server"
                                ControlToValidate="txtMarks"
                                ErrorMessage="Please enter marks"
                                CssClass="validation-error" Display="Dynamic">
                            </asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="rvMarks" runat="server"
                                ControlToValidate="txtMarks" Type="Double"
                                MinimumValue="0" MaximumValue="100"
                                ErrorMessage="Marks must be between 0 and 100"
                                CssClass="validation-error" Display="Dynamic">
                            </asp:RangeValidator>
                        </div>
                    </div>

                    <!-- Results Display -->
                    <div class="results-display">
                        <div class="grade-box">
                            <div style="font-size: 1.1rem; margin-bottom: 0.25rem;">Grade</div>
                            <div style="font-size: 1.5rem; font-weight: 700;">
                                <asp:Label ID="lblGrade" runat="server" Text="--"></asp:Label>
                            </div>
                        </div>

                        <div class="remarks-box">
                            <div style="font-size: 1.1rem; margin-bottom: 0.25rem;">Remarks</div>
                            <div style="font-size: 1.2rem; font-weight: 700;">
                                <asp:Label ID="lblRemarks" runat="server" Text="--"></asp:Label>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="button-group">
                        <asp:Button ID="btnSave" runat="server" Text="💾 Save Result"
                            CssClass="btn btn-primary" OnClick="BtnSave_Click" />
                        <asp:Button ID="btnClear" runat="server" Text="🔄 Clear Form"
                            CssClass="btn btn-outline" OnClick="BtnClear_Click" CausesValidation="false" />
                        <asp:Button ID="btnRefreshData" runat="server" Text="📊 Refresh Data"
                            CssClass="btn btn-outline" OnClick="BtnRefreshData_Click" CausesValidation="false" />
                        <asp:Button ID="Button1" runat="server" Text="🔄 View Results"
                            CssClass="btn btn-outline" OnClick="Button1_Click" CausesValidation="false" />
                    </div>
                </div>

                <!-- Note: Existing Results GridView has been removed as requested -->
            </div>
        </div>
    </div>

    <script>
        function calculateGrade() {
            var marks = document.getElementById('<%= txtMarks.ClientID %>').value;
            var gradeLabel = document.getElementById('<%= lblGrade.ClientID %>');
            var remarksLabel = document.getElementById('<%= lblRemarks.ClientID %>');

            if (marks === '') {
                gradeLabel.innerHTML = '--';
                remarksLabel.innerHTML = '--';
                return;
            }

            var numericMarks = parseFloat(marks);

            if (numericMarks >= 75) {
                gradeLabel.innerHTML = 'A';
                remarksLabel.innerHTML = 'Excellent';
            } else if (numericMarks >= 60) {
                gradeLabel.innerHTML = 'B';
                remarksLabel.innerHTML = 'Good';
            } else if (numericMarks >= 45) {
                gradeLabel.innerHTML = 'C';
                remarksLabel.innerHTML = 'Average';
            } else if (numericMarks >= 33) {
                gradeLabel.innerHTML = 'D';
                remarksLabel.innerHTML = 'Pass';
            } else {
                gradeLabel.innerHTML = 'F';
                remarksLabel.innerHTML = 'Fail';
            }
        }

        // Auto-hide success messages
        setTimeout(function () {
            var alerts = document.querySelectorAll('.alert-success');
            alerts.forEach(function (alert) {
                alert.style.opacity = '0';
                alert.style.transition = 'opacity 0.5s ease';
                setTimeout(function () {
                    alert.style.display = 'none';
                }, 500);
            });
        }, 5000);
    </script>
</asp:Content>