<%@ Page Title="Manage Classes" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Classes.aspx.cs" Inherits="School_Managenment_System12._00.Classes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .class-form-container {
            background: #121212;
            color: #fff;
            padding: 30px;
            border-radius: 15px;
            max-width: 700px;
            margin: 20px auto;
            box-shadow: 0 0 30px #00bcd4;
            border: 2px solid #00bcd4;
        }

        .form-header {
            text-align: center;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 2px solid #00bcd4;
        }

        .form-header h2 {
            color: #00e5ff;
            text-shadow: 0 0 10px #00bcd4;
            margin: 0;
            font-size: 26px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-label {
            display: block;
            font-weight: bold;
            color: #00e5ff;
            margin-bottom: 6px;
            font-size: 14px;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #444;
            background: #222;
            color: #fff;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-control:focus {
            border-color: #00bcd4;
            box-shadow: 0 0 8px #00e5ff;
            outline: none;
        }

        .btn-save {
            width: 100%;
            padding: 14px;
            background: linear-gradient(45deg, #00bcd4, #00e5ff);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-weight: bold;
            font-size: 18px;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 20px;
        }

        .btn-save:hover {
            background: linear-gradient(45deg, #00e5ff, #00bcd4);
            transform: translateY(-2px);
            box-shadow: 0 0 20px #00bcd4;
        }

        .message {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 15px;
            text-align: center;
            font-weight: bold;
        }

        .message.success {
            background: #155724;
            color: #d4edda;
        }

        .message.error {
            background: #721c24;
            color: #f8d7da;
        }

        .required::after {
            content: " *";
            color: #ff0000;
        }

        /* Additional styles for better validation display */
        .validator-error {
            color: #ff6b6b;
            font-size: 12px;
            margin-top: 5px;
            display: block;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn-info {
            border-style: none;
            border-color: inherit;
            border-width: medium;
            background: #17a2b8;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            height: 58px;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .btn-info:hover {
            background: #138496;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="class-form-container">
        <div class="form-header">
            <h2>🏫 Add New Class</h2>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>

        <div class="form-group">
            <asp:Label Text="Class Name" runat="server" CssClass="form-label required" />
            <asp:TextBox ID="txtClassName" runat="server" CssClass="form-control" placeholder="e.g., Class 1, Grade 5, etc." />
            <asp:RequiredFieldValidator ID="rfvClassName" ControlToValidate="txtClassName" runat="server" 
                ErrorMessage="Class name is required" ForeColor="Red" Display="Dynamic" CssClass="validator-error" />
        </div>

        <div class="form-group">
            <asp:Label Text="Section" runat="server" CssClass="form-label required" />
            <asp:TextBox ID="txtSection" runat="server" CssClass="form-control" placeholder="e.g., A, B, C" MaxLength="1" />
            <asp:RequiredFieldValidator ID="rfvSection" ControlToValidate="txtSection" runat="server" 
                ErrorMessage="Section is required" ForeColor="Red" Display="Dynamic" CssClass="validator-error" />
            <asp:RegularExpressionValidator ID="revSection" ControlToValidate="txtSection" runat="server"
                ErrorMessage="Single letter only (A-Z)" ValidationExpression="^[A-Za-z]$"
                ForeColor="Red" Display="Dynamic" CssClass="validator-error" />
        </div>

        <div class="form-group">
            <asp:Label Text="Capacity" runat="server" CssClass="form-label" />
            <asp:TextBox ID="txtCapacity" runat="server" CssClass="form-control" Text="40" TextMode="Number" 
                min="1" max="100" />
            <asp:RangeValidator ID="rvCapacity" ControlToValidate="txtCapacity" runat="server"
                ErrorMessage="Capacity must be between 1-100" MinimumValue="1" MaximumValue="100"
                Type="Integer" ForeColor="Red" Display="Dynamic" CssClass="validator-error" />
        </div>

        <div class="form-group">
            <asp:Label Text="Academic Year" runat="server" CssClass="form-label" />
            <asp:TextBox ID="txtAcademicYear" runat="server" CssClass="form-control" Text="2024-2025" 
                placeholder="YYYY-YYYY" />
            <asp:RegularExpressionValidator ID="revAcademicYear" ControlToValidate="txtAcademicYear" runat="server"
                ErrorMessage="Format must be YYYY-YYYY" ValidationExpression="^\d{4}-\d{4}$"
                ForeColor="Red" Display="Dynamic" CssClass="validator-error" />
        </div>

        <div class="form-group">
            <asp:Label Text="Active" runat="server" CssClass="form-label" />
            <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
        </div>

        <asp:Button ID="btnSave" runat="server" Text="💾 Save Class" CssClass="btn-save" OnClick="BtnSave_Click" />
        
        <!-- Navigation Buttons -->
        <div style="margin-top: 20px; text-align: center;">
            <asp:Button ID="btnViewClasses" runat="server" Text="📋 View All Classes" 
                CssClass="btn-info me-2" CausesValidation="false" OnClick="BtnViewClasses_Click" />
            <asp:Button ID="btnBackDashboard" runat="server" Text="🏠 Back to Dashboard" 
                CssClass="btn-secondary" CausesValidation="false" OnClick="BtnBackDashboard_Click" />
        </div>
    </div>
</asp:Content>