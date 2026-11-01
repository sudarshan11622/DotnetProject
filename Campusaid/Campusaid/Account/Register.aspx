<%@ Page Title="Create Account" Language="C#" MasterPageFile="~/MasterPages/Auth.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Campusaid.Account.Register" %>

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
                <h2 class="auth-title mb-0">Create Account</h2>
            </div>
            <div class="auth-subtitle">Emergency Assistant &amp; Resource Directory</div>

            <!-- Role Selector Tabs (Student & Faculty Only - No Public Admin) -->
            <div class="auth-role-tabs">
                <asp:Button ID="btnRoleStudent" runat="server" Text="Student" CssClass="auth-role-tab active" OnClick="btnRole_Click" CommandArgument="Student" CausesValidation="false" />
                <asp:Button ID="btnRoleFaculty" runat="server" Text="Faculty" CssClass="auth-role-tab" OnClick="btnRole_Click" CommandArgument="Faculty" CausesValidation="false" />
            </div>
            <asp:HiddenField ID="hfSelectedRole" runat="server" Value="Student" />
        </div>

        <div class="auth-body">
            <div class="alert alert-info py-2 small mb-3 d-flex align-items-center gap-2">
                <svg class="ca-icon ca-icon-sm text-primary flex-shrink-0" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
                <span><strong>In-Memory Notice:</strong> Registered accounts are stored in memory for the active session.</span>
            </div>

            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger py-2 small mb-3">
                <asp:Literal ID="litAlertMsg" runat="server" />
            </asp:Panel>

            <asp:ValidationSummary ID="valSummary" runat="server" CssClass="alert alert-danger py-2 small mb-3" HeaderText="Please correct the following:" ValidationGroup="vgRegister" />

            <div class="mb-3">
                <label class="form-label-ca" for="txtName">Full Name</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control-ca" placeholder="Enter your full name"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ErrorMessage="Full Name is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgRegister">* Full Name required</asp:RequiredFieldValidator>
            </div>

            <div class="mb-3">
                <label class="form-label-ca" for="txtEmail">University Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control-ca" placeholder="name@rku.ac.in"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="University Email is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgRegister">* Email required</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="University email must end with @rku.ac.in." ValidationExpression="^[a-zA-Z0-9._%+-]+@rku\.ac\.in$" CssClass="val-error" Display="Dynamic" ValidationGroup="vgRegister">* Must be an @rku.ac.in address</asp:RegularExpressionValidator>
                <asp:CustomValidator ID="cvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="An account with this email already exists." OnServerValidate="cvEmail_ServerValidate" CssClass="val-error" Display="Dynamic" ValidationGroup="vgRegister">* Email already in use</asp:CustomValidator>
            </div>

            <div class="mb-3">
                <label class="form-label-ca" for="ddlDepartment">Department</label>
                <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-control-ca">
                    <asp:ListItem Value="Computer Science">Computer Science</asp:ListItem>
                    <asp:ListItem Value="Chemistry Department">Chemistry Department</asp:ListItem>
                    <asp:ListItem Value="Bio-Engineering">Bio-Engineering</asp:ListItem>
                    <asp:ListItem Value="Civil Engineering">Civil Engineering</asp:ListItem>
                    <asp:ListItem Value="Electrical & Electronics">Electrical & Electronics</asp:ListItem>
                    <asp:ListItem Value="Campus Administration">Campus Administration</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="mb-3">
                <label class="form-label-ca" for="txtPassword">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control-ca" placeholder="••••••••" TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgRegister">* Password required</asp:RequiredFieldValidator>
            </div>

            <div class="mb-3">
                <label class="form-label-ca" for="txtConfirmPassword">Confirm Password</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control-ca" placeholder="••••••••" TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="Confirm Password is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgRegister">* Confirm Password required</asp:RequiredFieldValidator>
                <asp:CompareValidator ID="cvPasswordMatch" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" ErrorMessage="Passwords do not match." CssClass="val-error" Display="Dynamic" ValidationGroup="vgRegister">* Passwords must match</asp:CompareValidator>
            </div>

            <div class="mt-4 mb-3">
                <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn-ca btn-ca-primary w-100 py-2" OnClick="btnRegister_Click" ValidationGroup="vgRegister" CausesValidation="true" />
            </div>

            <div class="text-center mt-3 pt-2 border-top">
                <span class="small text-muted">Already have an account?</span>
                <a href="Login.aspx" class="small fw-bold text-decoration-none text-primary ms-1">Sign In</a>
            </div>
        </div>
    </div>
</asp:Content>
