<%@ Page Title="Verify OTP" Language="C#" MasterPageFile="~/MasterPages/Auth.Master" AutoEventWireup="true" CodeBehind="VerifyOTP.aspx.cs" Inherits="Campusaid.Account.VerifyOTP" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .otp-input-box {
            letter-spacing: 0.5rem;
            font-size: 1.4rem;
            text-align: center;
            font-weight: 700;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-card-portal">
        <div class="auth-header">
            <div class="auth-portal-badge">CARD PORTAL</div>
            <div class="d-flex align-items-center justify-content-center gap-2 my-1">
                <div class="brand-icon" style="width: 32px; height: 32px;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="M12 8v8"/><path d="M8 12h8"/></svg>
                </div>
                <h2 class="auth-title mb-0">Verify OTP</h2>
            </div>
            <div class="auth-subtitle">Enter the 6-digit verification code sent to your email</div>
        </div>

        <div class="auth-body">
            <!-- Simulated OTP banner for testing/demo per prompt requirements -->
            <asp:Panel ID="pnlDemoBanner" runat="server" CssClass="alert alert-warning py-2 small mb-3">
                <div class="d-flex align-items-center gap-2 mb-1">
                    <svg class="ca-icon ca-icon-sm text-dark flex-shrink-0" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="7.5" cy="15.5" r="5.5"/><path d="m21 2-9.6 9.6"/><path d="m15.5 7.5 3 3L22 7l-3-3"/></svg>
                    <span><strong>Demo Code Generated:</strong> <span class="fw-bold font-monospace fs-6 text-dark"><asp:Literal ID="litDemoOtp" runat="server" /></span></span>
                </div>
                <div class="text-muted" style="font-size: 0.72rem;">Valid for 60 seconds. In-memory demo workflow.</div>
            </asp:Panel>

            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger py-2 small mb-3">
                <asp:Literal ID="litAlertMsg" runat="server" />
            </asp:Panel>

            <asp:ValidationSummary ID="valSummary" runat="server" CssClass="alert alert-danger py-2 small mb-3" HeaderText="Please correct the following:" ValidationGroup="vgVerify" />

            <div class="mb-3 text-center">
                <label class="form-label-ca mb-2" for="txtOtpCode">6-Digit Code for <span class="text-primary"><asp:Literal ID="litTargetEmail" runat="server" /></span></label>
                <asp:TextBox ID="txtOtpCode" runat="server" CssClass="form-control-ca otp-input-box" MaxLength="6" placeholder="000000"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvOtp" runat="server" ControlToValidate="txtOtpCode" ErrorMessage="Verification code is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgVerify">* 6-digit code required</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revOtp" runat="server" ControlToValidate="txtOtpCode" ErrorMessage="Code must be exactly 6 numeric digits." ValidationExpression="^\d{6}$" CssClass="val-error" Display="Dynamic" ValidationGroup="vgVerify">* Enter 6 digits</asp:RegularExpressionValidator>
            </div>

            <div class="mt-4 mb-3">
                <asp:Button ID="btnVerifyCode" runat="server" Text="Verify Code" CssClass="btn-ca btn-ca-primary w-100 py-2" OnClick="btnVerifyCode_Click" ValidationGroup="vgVerify" CausesValidation="true" />
            </div>

            <div class="text-center mt-3 pt-2">
                <span class="small text-muted">Didn't receive the code?</span>
                <asp:LinkButton ID="btnResendCode" runat="server" CssClass="small fw-bold text-decoration-none text-primary ms-1" OnClick="btnResendCode_Click" CausesValidation="false">Resend Code</asp:LinkButton>
            </div>

            <div class="text-center mt-3 pt-2 border-top">
                <a href="Login.aspx" class="small fw-bold text-decoration-none text-secondary">Back to Sign In</a>
            </div>
        </div>
    </div>
</asp:Content>
