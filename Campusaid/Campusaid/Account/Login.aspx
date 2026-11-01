<%@ Page Title="Sign In" Language="C#" MasterPageFile="~/MasterPages/Auth.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Campusaid.Account.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-card-portal">
        <div class="auth-header">
            <div class="auth-portal-badge">CARD PORTAL</div>
            <div class="d-flex align-items-center justify-content-center gap-2 my-1">
                <div class="brand-icon" style="width: 32px; height: 32px;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="M12 8v8"/><path d="M8 12h8"/></svg>
                </div>
                <h2 class="auth-title mb-0">CampusAid</h2>
            </div>
            <div class="auth-subtitle">Emergency Assistant &amp; Resource Directory</div>

            <!-- Role Selector Tabs -->
            <div class="auth-role-tabs">
                <asp:Button ID="btnRoleStudent" runat="server" Text="Student" CssClass="auth-role-tab active" OnClick="btnRole_Click" CommandArgument="Student" CausesValidation="false" />
                <asp:Button ID="btnRoleFaculty" runat="server" Text="Faculty" CssClass="auth-role-tab" OnClick="btnRole_Click" CommandArgument="Faculty" CausesValidation="false" />
                <asp:Button ID="btnRoleAdmin" runat="server" Text="Admin" CssClass="auth-role-tab" OnClick="btnRole_Click" CommandArgument="Admin" CausesValidation="false" />
            </div>
            <asp:HiddenField ID="hfSelectedRole" runat="server" Value="Student" />
        </div>

        <div class="auth-body">
            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger py-2 small mb-3">
                <asp:Literal ID="litAlertMsg" runat="server" />
            </asp:Panel>

            <asp:ValidationSummary ID="valSummary" runat="server" CssClass="alert alert-danger py-2 small mb-3" HeaderText="Please correct the following:" ValidationGroup="vgLogin" />

            <div class="mb-3">
                <label class="form-label-ca" for="txtEmail">University Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control-ca" placeholder="mail@rku.ac.in" TextMode="Email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="University Email is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgLogin">* Email required</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Enter a valid email address format." ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" CssClass="val-error" Display="Dynamic" ValidationGroup="vgLogin">* Valid email required</asp:RegularExpressionValidator>
            </div>

            <div class="mb-3">
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <label class="form-label-ca mb-0" for="txtPassword">Password</label>
                    <a href="ForgotPassword.aspx" class="text-decoration-none small text-primary fw-semibold">Forget Password?</a>
                </div>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control-ca" placeholder="••••••••" TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgLogin">* Password required</asp:RequiredFieldValidator>
            </div>

            <div class="mt-4 mb-3">
                <asp:Button ID="btnSignIn" runat="server" Text="Sign In" CssClass="btn-ca btn-ca-primary w-100 py-2" OnClick="btnSignIn_Click" ValidationGroup="vgLogin" CausesValidation="true" />
            </div>

            <div class="text-center mt-3 pt-2 border-top">
                <span class="small text-muted">Don't have an account?</span>
                <a href="Register.aspx" class="small fw-bold text-decoration-none text-primary ms-1">Create account</a>
            </div>

            <!-- Quick Demo Credentials Selector for Convenience -->
            <div class="mt-4 p-2.5 bg-light rounded-3 border">
                
                
            </div>
        </div>
    </div>
</asp:Content>
