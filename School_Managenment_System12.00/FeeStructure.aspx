<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FeeStructure.aspx.cs" 
    Inherits="School_Managenment_System12._00.FeeStructure" MasterPageFile="~/Site2.master" 
    Title="Fee Structure Management" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .fee-content {
            background: linear-gradient(135deg, #0c0c0c 0%, #1a1a1a 100%);
            color: #ffffff;
            min-height: calc(100vh - 120px);
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: linear-gradient(45deg, #1a1a1a, #2d2d2d);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            border-left: 5px solid #ffeb3b;
            box-shadow: 0 8px 32px rgba(255, 235, 59, 0.1);
        }

            .header h1 {
                color: #ffeb3b;
                font-size: 2.5em;
                text-shadow: 0 2px 10px rgba(255, 235, 59, 0.3);
                margin-bottom: 10px;
            }

            .header p {
                color: #e0e0e0;
                font-size: 1.1em;
            }

        .form-container {
            background: rgba(42, 42, 42, 0.95);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            border: 1px solid #333;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            color: #ffeb3b;
            margin-bottom: 8px;
            font-weight: 600;
            font-size: 1.1em;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            background: rgba(255, 255, 255, 0.1);
            border: 2px solid #444;
            border-radius: 8px;
            color: #ffffff;
            font-size: 1em;
            transition: all 0.3s ease;
        }

            .form-control:focus {
                border-color: #ff4081;
                background: rgba(255, 255, 255, 0.15);
                outline: none;
                box-shadow: 0 0 15px rgba(255, 64, 129, 0.3);
            }

        .class-dropdown {
            border: 2px solid #ffeb3b;
            background: rgba(255, 235, 59, 0.1);
        }

            .class-dropdown:focus {
                border-color: #ffeb3b;
                box-shadow: 0 0 15px rgba(255, 235, 59, 0.3);
            }

        .class-dropdown option {
            background: #1a1a1a;
            color: #ffeb3b;
            padding: 10px;
            font-weight: 600;
        }

            .class-dropdown option:hover {
                background: #ffeb3b !important;
                color: #1a1a1a !important;
            }

            .class-dropdown option:checked {
                background: #ffeb3b;
                color: #1a1a1a;
                font-weight: bold;
            }

        .status-dropdown {
            border: 2px solid #ff4081;
            background: rgba(255, 64, 129, 0.1);
        }

            .status-dropdown:focus {
                border-color: #ff4081;
                box-shadow: 0 0 15px rgba(255, 64, 129, 0.3);
            }

        .status-dropdown option {
            background: #1a1a1a;
            color: #ff4081;
            padding: 10px;
            font-weight: 600;
        }

            .status-dropdown option:hover {
                background: #ff4081 !important;
                color: #ffffff !important;
            }

            .status-dropdown option:checked {
                background: #ff4081;
                color: #ffffff;
                font-weight: bold;
            }

        select.form-control {
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=US-ASCII,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 4 5'><path fill='%23ffffff' d='M2 0L0 2h4zm0 5L0 3h4z'/></svg>");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 12px;
        }

        select.form-control::-webkit-scrollbar {
            width: 8px;
        }

        select.form-control::-webkit-scrollbar-track {
            background: #1a1a1a;
            border-radius: 4px;
        }

        select.form-control::-webkit-scrollbar-thumb {
            background: #ff4081;
            border-radius: 4px;
        }

            select.form-control::-webkit-scrollbar-thumb:hover {
                background: #ff79a6;
            }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-primary {
            background: linear-gradient(45deg, #ff4081, #ff79a6);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 64, 129, 0.3);
        }

            .btn-primary:hover {
                background: linear-gradient(45deg, #f50057, #ff4081);
                box-shadow: 0 6px 20px rgba(255, 64, 129, 0.4);
                transform: translateY(-2px);
            }

        .btn-secondary {
            background: linear-gradient(45deg, #ffeb3b, #fff59d);
            color: #1a1a1a;
            box-shadow: 0 4px 15px rgba(255, 235, 59, 0.3);
        }

            .btn-secondary:hover {
                background: linear-gradient(45deg, #fbc02d, #ffeb3b);
                box-shadow: 0 6px 20px rgba(255, 235, 59, 0.4);
                transform: translateY(-2px);
            }

        .grid-container {
            background: rgba(42, 42, 42, 0.95);
            padding: 20px;
            border-radius: 15px;
            overflow-x: auto;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        .gridview {
            width: 100%;
            border-collapse: collapse;
            background: transparent;
        }

            .gridview th {
                background: linear-gradient(45deg, #ff4081, #ff79a6);
                color: white;
                padding: 15px;
                text-align: left;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .gridview tr {
                border-bottom: 1px solid #444;
                transition: all 0.3s ease;
            }

                .gridview tr:nth-child(even) {
                    background: rgba(255, 255, 255, 0.05);
                }

                .gridview tr:hover {
                    background: rgba(255, 235, 59, 0.1);
                    transform: scale(1.01);
                }

            .gridview td {
                padding: 15px;
                color: #e0e0e0;
            }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .btn-edit {
            background: #ffeb3b;
            color: #1a1a1a;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

            .btn-edit:hover {
                background: #fbc02d;
                transform: scale(1.05);
            }

        .btn-delete {
            background: #ff4081;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

            .btn-delete:hover {
                background: #f50057;
                transform: scale(1.05);
            }

        .status-active {
            color: #4caf50;
            font-weight: 600;
        }

        .status-inactive {
            color: #ff4081;
            font-weight: 600;
        }

        .message {
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            text-align: center;
            font-weight: 600;
        }

        .message-success {
            background: rgba(76, 175, 80, 0.2);
            border: 1px solid #4caf50;
            color: #4caf50;
        }

        .message-error {
            background: rgba(244, 67, 54, 0.2);
            border: 1px solid #f44336;
            color: #f44336;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            .header h1 {
                font-size: 2em;
            }

            .form-row {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
        }
    </style>

    <div class="fee-content">
        <div class="container">
            <!-- Header Section -->
            <div class="header">
                <h1>🎓 Fee Structure Management</h1>
                <p>Manage school fee structures efficiently with our premium dashboard</p>
            </div>

            <!-- Message Display -->
            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="message">
                <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
            </asp:Panel>

            <!-- Input Form -->
            <div class="form-container">
                <h2 style="color: #ff4081; margin-bottom: 20px;">Add/Edit Fee Structure</h2>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Fee Type</label>
                        <asp:TextBox ID="txtFeeType" runat="server" CssClass="form-control"
                            placeholder="Enter fee type (e.g., Tuition, Library, Sports)"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Class</label>
                        <asp:DropDownList ID="ddlClass" runat="server" CssClass="form-control class-dropdown">
                            <asp:ListItem Value="">-- Select Class --</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Amount (₹)</label>
                        <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control"
                            placeholder="Enter amount" TextMode="Number" step="0.01"></asp:TextBox>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Academic Year</label>
                        <asp:TextBox ID="txtAcademicYear" runat="server" CssClass="form-control"
                            placeholder="e.g., 2024-2025"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Due Date</label>
                        <asp:TextBox ID="txtDueDate" runat="server" CssClass="form-control"
                            TextMode="Date"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Status</label>
                        <asp:DropDownList ID="ddlIsActive" runat="server" CssClass="form-control status-dropdown">
                            <asp:ListItem Value="true">Active</asp:ListItem>
                            <asp:ListItem Value="false">Inactive</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div style="display: flex; gap: 15px; margin-top: 20px; flex-wrap: wrap;">
                    <asp:Button ID="btnSave" runat="server" Text="💾 Save Fee" CssClass="btn btn-primary"
                        OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="❌ Cancel" CssClass="btn btn-secondary"
                        OnClick="btnCancel_Click" />
                    <asp:Button ID="btnRefresh" runat="server" Text="🔄 Refresh Data" CssClass="btn btn-secondary"
                        OnClick="btnRefresh_Click" />
                </div>
            </div>

            <!-- Data Grid -->
            <div class="grid-container">
                <h2 style="color: #ffeb3b; margin-bottom: 20px;">Current Fee Structures</h2>
                <asp:GridView ID="gvFeeStructure" runat="server" AutoGenerateColumns="False"
                    CssClass="gridview" OnRowCommand="gvFeeStructure_RowCommand" DataKeyNames="FeeId">
                    <Columns>
                        <asp:BoundField DataField="FeeId" HeaderText="ID" ItemStyle-Width="50px" />
                        <asp:BoundField DataField="FeeType" HeaderText="Fee Type" />
                        <asp:BoundField DataField="ClassName" HeaderText="Class" />
                        <asp:BoundField DataField="Amount" HeaderText="Amount (₹)"
                            DataFormatString="{0:N2}" ItemStyle-Width="120px" />
                        <asp:BoundField DataField="AcademicYear" HeaderText="Academic Year" />
                        <asp:BoundField DataField="DueDate" HeaderText="Due Date"
                            DataFormatString="{0:dd-MMM-yyyy}" />
                        <asp:TemplateField HeaderText="Status" ItemStyle-Width="100px">
                            <ItemTemplate>
                                <span class='<%# Eval("IsActive").ToString() == "True" ? "status-active" : "status-inactive" %>'>
                                    <%# Eval("IsActive").ToString() == "True" ? "✅ Active" : "❌ Inactive" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CreatedDate" HeaderText="Created On"
                            DataFormatString="{0:dd-MMM-yyyy}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <asp:Button ID="btnEdit" runat="server" CommandName="EditRecord"
                                        CommandArgument='<%# Eval("FeeId") %>' Text="✏️ Edit" CssClass="btn-edit"
                                        CausesValidation="false" />
                                    <asp:Button ID="btnDelete" runat="server" CommandName="DeleteRecord"
                                        CommandArgument='<%# Eval("FeeId") %>' Text="🗑️ Delete" CssClass="btn-delete"
                                        OnClientClick="return confirm('Are you sure you want to delete this fee structure?');"
                                        CausesValidation="false" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>