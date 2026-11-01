<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/MasterPages/Auth.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="Campusaid.Account.ForgotPassword" %>

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
                <h2 class="auth-title mb-0">Forgot Password</h2>
            </div>
            <div class="auth-subtitle">Enter your university email address and we will send you a verification code</div>
        </div>

        <div class="auth-body">
            <div class="alert alert-info py-2 small mb-3 d-flex align-items-center gap-2">
                <svg class="ca-icon ca-icon-sm text-primary flex-shrink-0" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
                <span><strong>Demonstration OTP Workflow:</strong> Generates a temporary 6-digit verification code with a 60-second expiration.</span>
            </div>

            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger py-2 small mb-3">
                <asp:Literal ID="litAlertMsg" runat="server" />
            </asp:Panel>

            <asp:ValidationSummary ID="valSummary" runat="server" CssClass="alert alert-danger py-2 small mb-3" HeaderText="Please correct the following:" ValidationGroup="vgForgot" />

            <div class="mb-3">
                <label class="form-label-ca" for="txtEmail">University Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control-ca" placeholder="name@rku.ac.in"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="University Email is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgForgot">* Email required</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="University email must end with @rku.ac.in (or use a valid demo account)." ValidationExpression="^[a-zA-Z0-9._%+-]+@rku\.ac\.in$|^bokul@gmail\.com$|^manab@gmail\.com$|^sudarshan@gmail\.com$" CssClass="val-error" Display="Dynamic" ValidationGroup="vgForgot">* Valid university email (@rku.ac.in) required</asp:RegularExpressionValidator>
            </div>

            <div class="mt-4 mb-3">
                <asp:Button ID="btnSendCode" runat="server" Text="Send Verification Code" CssClass="btn-ca btn-ca-primary w-100 py-2" OnClick="btnSendCode_Click" ValidationGroup="vgForgot" CausesValidation="true" />
            </div>

            <div class="text-center mt-3 pt-2 border-top">
                <a href="Login.aspx" class="small fw-bold text-decoration-none text-secondary">Back to Sign In</a>
            </div>
        </div>
    </div>
</asp:Content>
