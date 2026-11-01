<%@ Page Title="User Registry" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="Campusaid.Admin.Users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>CEARD Directory User Registry</h1>
    <p>Manage portal access roles, audit logs, and status credentials.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Notice -->
    <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="alert alert-success py-2 small mb-4">
        <asp:Literal ID="litNotice" runat="server" />
    </asp:Panel>

    <!-- Search & Filter Controls (Matching Figma Page 24) -->
    <div class="card-ca p-3 mb-4">
        <div class="row g-2 align-items-center">
            <div class="col-md-4">
                <div class="input-group input-group-sm">
                    <span class="input-group-text bg-white border-end-0 text-muted">
                        <svg class="ca-icon ca-icon-xs" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                    </span>
                    <asp:TextBox ID="txtSearchUser" runat="server" CssClass="form-control border-start-0" placeholder="Search by email, name or ID..."></asp:TextBox>
                </div>
            </div>
            <div class="col-md-2 col-6">
                <asp:DropDownList ID="ddlRoleFilter" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Value="All">Role: All Roles</asp:ListItem>
                    <asp:ListItem Value="Student">Role: Student</asp:ListItem>
                    <asp:ListItem Value="Faculty">Role: Faculty</asp:ListItem>
                    <asp:ListItem Value="Staff">Role: Staff</asp:ListItem>
                    <asp:ListItem Value="Admin">Role: Admin</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2 col-6">
                <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Value="All">Status: All</asp:ListItem>
                    <asp:ListItem Value="Active">Status: Active</asp:ListItem>
                    <asp:ListItem Value="Inactive">Status: Inactive</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2 col-6">
                <asp:DropDownList ID="ddlDeptFilter" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Value="All">Dept: All Departments</asp:ListItem>
                    <asp:ListItem Value="Computer Science">Computer Science</asp:ListItem>
                    <asp:ListItem Value="Bio-Engineering">Bio-Engineering</asp:ListItem>
                    <asp:ListItem Value="Chemistry Department">Chemistry Department</asp:ListItem>
                    <asp:ListItem Value="Campus Facilities">Campus Facilities</asp:ListItem>
                    <asp:ListItem Value="Campus Safety Administration">Safety Administration</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2 col-6 d-flex gap-1">
                <asp:Button ID="btnSearch" runat="server" Text="Filter" CssClass="btn btn-sm btn-outline-dark flex-grow-1" OnClick="btnSearch_Click" CausesValidation="false" />
                <asp:Button ID="btnOpenAddUser" runat="server" Text="+ Add User" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnOpenAddUser_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

    <!-- Users Table (Matching Figma Page 24) -->
    <div class="table-ca-wrapper">
        <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
            <HeaderTemplate>
                <table class="table-ca">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Department</th>
                            <th>Status</th>
                            <th>Last Login</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td>
                        <div class="fw-bold text-dark"><%# Eval("FullName") %></div>
                        <div class="small text-muted"><%# Eval("IdentifierNumber") %></div>
                    </td>
                    <td class="small text-secondary font-monospace"><%# Eval("Email") %></td>
                    <td>
                        <span class="badge bg-light text-dark border fw-bold"><%# Eval("Role") %></span>
                    </td>
                    <td class="small text-dark"><%# Eval("Department") %></td>
                    <td>
                        <span class='badge-ca <%# (bool)Eval("IsActive") ? "badge-active" : "badge-inactive" %>'>
                            <%# (bool)Eval("IsActive") ? "ACTIVE" : "INACTIVE" %>
                        </span>
                    </td>
                    <td class="small text-muted"><%# ((DateTime)Eval("LastLogin")).ToString("MMM dd, HH:mm") %></td>
                    <td>
                        <div class="d-flex gap-1">
                            <asp:LinkButton ID="btnToggleActive" runat="server" 
                                CommandName="ToggleActive" 
                                CommandArgument='<%# Eval("Id") %>' 
                                CssClass='<%# (bool)Eval("IsActive") ? "btn btn-sm btn-outline-danger py-0 px-2" : "btn btn-sm btn-outline-success py-0 px-2" %>'
                                style="font-size: 0.75rem;" 
                                CausesValidation="false">
                                <%# (bool)Eval("IsActive") ? "Deactivate" : "Activate" %>
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnEditUser" runat="server" CommandName="EditUser" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-dark py-0 px-2" style="font-size: 0.75rem;" CausesValidation="false">Edit</asp:LinkButton>
                        </div>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </div>

    <!-- Add/Edit User Modal -->
    <asp:Panel ID="pnlUserModal" runat="server" Visible="false" CssClass="modal fade show d-block" style="background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(2px);" TabIndex="-1">
        <div class="modal-dialog modal-dialog-centered modal-ca-compact">
            <div class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-light py-2 px-3 border-bottom">
                    <h6 class="modal-title fw-bold text-dark mb-0"><asp:Literal ID="litUserModalTitle" runat="server">Add User</asp:Literal></h6>
                    <asp:LinkButton ID="btnCloseUserX" runat="server" CssClass="btn-close" OnClick="btnCloseModal_Click" CausesValidation="false" aria-label="Close"></asp:LinkButton>
                </div>
                <div class="modal-body modal-body-scroll p-3">
                    <asp:ValidationSummary ID="valUser" runat="server" CssClass="alert alert-danger py-1 small mb-2" ValidationGroup="vgUser" />
                    <asp:HiddenField ID="hfUserId" runat="server" Value="0" />

                    <div class="mb-2">
                        <label class="form-label-ca" for="txtUserName">Full Name</label>
                        <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control-ca" placeholder="e.g. Dr. Jane Doe"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvUserName" runat="server" ControlToValidate="txtUserName" ErrorMessage="Full Name required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgUser">* Required</asp:RequiredFieldValidator>
                    </div>

                    <div class="mb-2">
                        <label class="form-label-ca" for="txtUserEmail">University Email</label>
                        <asp:TextBox ID="txtUserEmail" runat="server" CssClass="form-control-ca" placeholder="name@rku.ac.in"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvUserEmail" runat="server" ControlToValidate="txtUserEmail" ErrorMessage="Email required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgUser">* Required</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revUserEmail" runat="server" ControlToValidate="txtUserEmail" ValidationGroup="vgUser" ValidationExpression="^[a-zA-Z0-9._%+-]+@rku\.ac\.in$" ErrorMessage="University email must end with @rku.ac.in." CssClass="val-error" Display="Dynamic">* Must end with @rku.ac.in</asp:RegularExpressionValidator>
                    </div>

                    <div class="row g-2 mb-2">
                        <div class="col-6">
                            <label class="form-label-ca" for="ddlUserRole">Role</label>
                            <asp:DropDownList ID="ddlUserRole" runat="server" CssClass="form-control-ca">
                                <asp:ListItem Value="Student">Student</asp:ListItem>
                                <asp:ListItem Value="Faculty">Faculty</asp:ListItem>
                                <asp:ListItem Value="Staff">Staff</asp:ListItem>
                                <asp:ListItem Value="Admin">Admin</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-6">
                            <label class="form-label-ca" for="ddlUserDept">Department</label>
                            <asp:DropDownList ID="ddlUserDept" runat="server" CssClass="form-control-ca">
                                <asp:ListItem Value="Computer Science">Computer Science</asp:ListItem>
                                <asp:ListItem Value="Bio-Engineering">Bio-Engineering</asp:ListItem>
                                <asp:ListItem Value="Chemistry Department">Chemistry Department</asp:ListItem>
                                <asp:ListItem Value="Campus Facilities">Campus Facilities</asp:ListItem>
                                <asp:ListItem Value="Campus Safety Administration">Safety Administration</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="mb-2">
                        <label class="form-label-ca" for="txtUserPassword">Temporary Password</label>
                        <asp:TextBox ID="txtUserPassword" runat="server" CssClass="form-control-ca" placeholder="Pass@123"></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer py-2 px-3 border-top bg-light">
                    <asp:Button ID="btnCancelUser" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary btn-sm" OnClick="btnCloseModal_Click" CausesValidation="false" />
                    <asp:Button ID="btnSaveUser" runat="server" Text="Save User" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnSaveUser_Click" ValidationGroup="vgUser" CausesValidation="true" />
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
