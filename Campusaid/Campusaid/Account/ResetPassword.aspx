<%@ Page Title="Reset Password" Language="C#" MasterPageFile="~/MasterPages/Auth.Master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="Campusaid.Account.ResetPassword" %>

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
                <h2 class="auth-title mb-0">Reset Password</h2>
            </div>
            <div class="auth-subtitle">Create a new secure password for <asp:Literal ID="litEmail" runat="server" /></div>
        </div>

        <div class="auth-body">
            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger py-2 small mb-3">
                <asp:Literal ID="litAlertMsg" runat="server" />
            </asp:Panel>

            <asp:ValidationSummary ID="valSummary" runat="server" CssClass="alert alert-danger py-2 small mb-3" HeaderText="Please correct the following:" ValidationGroup="vgReset" />

            <div class="mb-3">
                <label class="form-label-ca" for="txtNewPassword">New Password</label>
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control-ca" placeholder="••••••••" TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ControlToValidate="txtNewPassword" ErrorMessage="New password is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgReset">* New password required</asp:RequiredFieldValidator>
            </div>

            <div class="mb-3">
                <label class="form-label-ca" for="txtConfirmNewPassword">Confirm New Password</label>
                <asp:TextBox ID="txtConfirmNewPassword" runat="server" CssClass="form-control-ca" placeholder="••••••••" TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvConfirmNewPassword" runat="server" ControlToValidate="txtConfirmNewPassword" ErrorMessage="Confirm password is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgReset">* Confirm password required</asp:RequiredFieldValidator>
                <asp:CompareValidator ID="cvMatch" runat="server" ControlToValidate="txtConfirmNewPassword" ControlToCompare="txtNewPassword" ErrorMessage="Passwords do not match." CssClass="val-error" Display="Dynamic" ValidationGroup="vgReset">* Passwords must match</asp:CompareValidator>
            </div>

            <div class="mt-4 mb-3">
                <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password & Sign In" CssClass="btn-ca btn-ca-primary w-100 py-2" OnClick="btnResetPassword_Click" ValidationGroup="vgReset" CausesValidation="true" />
            </div>

            <div class="text-center mt-3 pt-2 border-top">
                <a href="Login.aspx" class="small fw-bold text-decoration-none text-secondary">Back to Sign In</a>
            </div>
        </div>
    </div>
</asp:Content>
