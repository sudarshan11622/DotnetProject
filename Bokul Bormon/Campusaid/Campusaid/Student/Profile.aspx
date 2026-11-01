<%@ Page Title="Student Profile" Language="C#" MasterPageFile="~/MasterPages/Student.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Campusaid.Student.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Student Profile & Emergency Contacts</h1>
    <p>Update your profile, configure emergency contact lists, and adjust notification pathways.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Notice Banner -->
    <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="alert alert-success py-2 small mb-4">
        <asp:Literal ID="litNotice" runat="server" />
    </asp:Panel>

    <div class="row g-4">
        <!-- Left Column: Student Profile & Notification Preferences -->
        <div class="col-lg-6">
            <!-- Student Profile Information Card -->
            <div class="card-ca mb-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3 class="card-title-ca mb-0">Personal Profile</h3>
                    <asp:Button ID="btnEditProfileToggle" runat="server" Text="Edit Profile" CssClass="btn btn-sm btn-outline-dark" OnClick="btnEditProfileToggle_Click" CausesValidation="false" />
                </div>

                <!-- Read-only view -->
                <asp:Panel ID="pnlProfileView" runat="server">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="rounded-circle bg-dark text-white d-flex align-items-center justify-content-center fw-bold fs-3" style="width: 60px; height: 60px;">
                            BB
                        </div>
                        <div>
                            <h4 class="fw-bold text-dark mb-0"><asp:Literal ID="litFullName" runat="server" /></h4>
                            <span class="badge bg-secondary"><asp:Literal ID="litIdentifier" runat="server" /></span>
                            <span class="text-muted small ms-2"><asp:Literal ID="litDept" runat="server" /></span>
                        </div>
                    </div>
                    <div class="p-3 bg-light rounded-3 border">
                        <div class="row g-2 small">
                            <div class="col-6">
                                <span class="text-muted">University Email:</span>
                                <div class="fw-bold text-dark"><asp:Literal ID="litEmail" runat="server" /></div>
                            </div>
                            <div class="col-6">
                                <span class="text-muted">Emergency Mobile:</span>
                                <div class="fw-bold text-dark"><asp:Literal ID="litPhone" runat="server" /></div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <!-- Edit Profile Panel -->
                <asp:Panel ID="pnlProfileEdit" runat="server" Visible="false" CssClass="mt-3">
                    <div class="mb-3">
                        <label class="form-label-ca" for="txtEditName">Full Name</label>
                        <asp:TextBox ID="txtEditName" runat="server" CssClass="form-control-ca"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEditName" runat="server" ControlToValidate="txtEditName" ErrorMessage="Full Name is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgProfile">* Required</asp:RequiredFieldValidator>
                    </div>
                    <div class="mb-3">
                        <label class="form-label-ca" for="txtEditPhone">Emergency Phone Number</label>
                        <asp:TextBox ID="txtEditPhone" runat="server" CssClass="form-control-ca" placeholder="+91 98765 43210"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEditPhone" runat="server" ControlToValidate="txtEditPhone" ErrorMessage="Phone number is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgProfile">* Required</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revEditPhone" runat="server" ControlToValidate="txtEditPhone" ValidationGroup="vgProfile" ValidationExpression="^\+91[\s\-]?[6-9]\d{4}[\s\-]?[0-9]{5}$|^\+91[\s\-]?[6-9]\d{9}$" ErrorMessage="Please enter a valid Indian mobile number (+91 98765 43210)." CssClass="val-error" Display="Dynamic">* Valid +91 Indian format required</asp:RegularExpressionValidator>
                    </div>
                    <div class="d-flex gap-2">
                        <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnSaveProfile_Click" ValidationGroup="vgProfile" CausesValidation="true" />
                        <asp:Button ID="btnCancelProfile" runat="server" Text="Cancel" CssClass="btn-ca btn-ca-outline btn-sm" OnClick="btnCancelProfile_Click" CausesValidation="false" />
                    </div>
                </asp:Panel>
            </div>

            <!-- Emergency Alerts Pathway Preferences (Matching Figma Page 14) -->
            <div class="card-ca">
                <div class="card-title-ca mb-3">
                    <span>Emergency Alerts Pathway Preferences</span>
                </div>
                <p class="small text-muted mb-3">Configure active delivery channels for severe campus dispatch warnings.</p>

                <div class="p-3 bg-light rounded-3 border mb-3">
                    <label class="ca-toggle-switch mb-3 p-2 bg-white rounded border d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-dark small">SMS/Text Messages</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Direct safety texts on emergency mobile phone line</div>
                        </div>
                        <span class="ca-toggle-track">
                            <asp:CheckBox ID="chkPrefSms" runat="server" Checked="true" />
                            <span class="ca-toggle-slider"></span>
                        </span>
                    </label>

                    <label class="ca-toggle-switch mb-3 p-2 bg-white rounded border d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-dark small">University Mobile App Push</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Push notification alert system bypass</div>
                        </div>
                        <span class="ca-toggle-track">
                            <asp:CheckBox ID="chkPrefPush" runat="server" Checked="true" />
                            <span class="ca-toggle-slider"></span>
                        </span>
                    </label>

                    <label class="ca-toggle-switch mb-0 p-2 bg-white rounded border d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-dark small">Automated Voice Calls</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Voice robot dialer fallback for critical tier warnings</div>
                        </div>
                        <span class="ca-toggle-track">
                            <asp:CheckBox ID="chkPrefVoice" runat="server" />
                            <span class="ca-toggle-slider"></span>
                        </span>
                    </label>
                </div>

                <asp:Button ID="btnSavePreferences" runat="server" Text="Update Notification Preferences" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnSavePreferences_Click" CausesValidation="false" />
            </div>
        </div>

        <!-- Right Column: Emergency Contacts (Matching Figma Page 14) -->
        <div class="col-lg-6">
            <div class="card-ca">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <div>
                        <h3 class="card-title-ca mb-0">Emergency Contacts</h3>
                        <div class="small text-muted">First responders will dial these contacts during medical triage.</div>
                    </div>
                    <asp:Button ID="btnShowAddContact" runat="server" Text="+ ADD NEW" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnShowAddContact_Click" CausesValidation="false" />
                </div>

                <!-- Add/Edit Contact Form Panel -->
                <asp:Panel ID="pnlContactForm" runat="server" Visible="false" CssClass="p-3 bg-light rounded-3 border mb-4">
                    <h6 class="fw-bold text-dark mb-3">
                        <asp:Literal ID="litContactFormTitle" runat="server">Add Emergency Contact</asp:Literal>
                    </h6>
                    <asp:HiddenField ID="hfContactId" runat="server" Value="0" />

                    <div class="mb-2">
                        <label class="form-label-ca" for="txtContactName">Full Name</label>
                        <asp:TextBox ID="txtContactName" runat="server" CssClass="form-control-ca" placeholder="e.g. Jiten Bormon"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvContactName" runat="server" ControlToValidate="txtContactName" ErrorMessage="Name is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgContact">* Required</asp:RequiredFieldValidator>
                    </div>

                    <div class="mb-2">
                        <label class="form-label-ca" for="txtContactPhone">Phone Number</label>
                        <asp:TextBox ID="txtContactPhone" runat="server" CssClass="form-control-ca" placeholder="+91 98765 43210"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvContactPhone" runat="server" ControlToValidate="txtContactPhone" ErrorMessage="Phone is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgContact">* Required</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revContactPhone" runat="server" ControlToValidate="txtContactPhone" ValidationGroup="vgContact" ValidationExpression="^\+91[\s\-]?[6-9]\d{4}[\s\-]?[0-9]{5}$|^\+91[\s\-]?[6-9]\d{9}$" ErrorMessage="Please enter a valid Indian mobile number (+91 98765 43210)." CssClass="val-error" Display="Dynamic">* Valid +91 Indian format required</asp:RegularExpressionValidator>
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label-ca" for="ddlContactPriority">Priority</label>
                            <asp:DropDownList ID="ddlContactPriority" runat="server" CssClass="form-control-ca">
                                <asp:ListItem Value="Primary Contact">Primary Contact</asp:ListItem>
                                <asp:ListItem Value="Secondary Contact">Secondary Contact</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-6">
                            <label class="form-label-ca" for="txtContactRel">Relationship</label>
                            <asp:TextBox ID="txtContactRel" runat="server" CssClass="form-control-ca" placeholder="e.g. Father, Mother"></asp:TextBox>
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <asp:Button ID="btnSaveContact" runat="server" Text="Save Contact" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnSaveContact_Click" ValidationGroup="vgContact" CausesValidation="true" />
                        <asp:Button ID="btnCancelContact" runat="server" Text="Cancel" CssClass="btn-ca btn-ca-outline btn-sm" OnClick="btnCancelContact_Click" CausesValidation="false" />
                    </div>
                </asp:Panel>

                <!-- Contacts List (Matching Figma Page 14) -->
                <asp:Repeater ID="rptContacts" runat="server" OnItemCommand="rptContacts_ItemCommand">
                    <ItemTemplate>
                        <div class="p-3 mb-3 bg-light rounded-3 border d-flex justify-content-between align-items-center">
                            <div>
                                <div class="d-flex align-items-center gap-2">
                                    <h5 class="fw-bold text-dark mb-0"><%# Eval("Name") %></h5>
                                    <span class="badge bg-secondary" style="font-size: 0.68rem;"><%# Eval("Relationship") %></span>
                                </div>
                                <div class="text-primary fw-bold small my-1 d-flex align-items-center gap-1.5">
                                    <svg class="ca-icon ca-icon-xs text-primary" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                                    <span><%# Eval("Phone") %></span>
                                </div>
                                <div class="text-muted small">
                                    Priority: <strong><%# Eval("Priority") %></strong>
                                </div>
                            </div>
                            <div class="d-flex gap-1">
                                <a href='tel:<%# Eval("Phone").ToString().Replace(" ", "").Replace("-", "") %>' class="btn btn-sm btn-outline-success py-1 px-2 d-inline-flex align-items-center gap-1" style="font-size: 0.75rem;">
                                    <svg class="ca-icon ca-icon-xs" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                                    Call
                                </a>
                                <asp:LinkButton ID="btnEditContact" runat="server" CommandName="EditContact" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-dark py-1 px-2" style="font-size: 0.75rem;" CausesValidation="false">Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnDeleteContact" runat="server" CommandName="DeleteContact" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger py-1 px-2" style="font-size: 0.75rem;" CausesValidation="false" OnClientClick="return confirm('Are you sure you want to remove this emergency contact?');">Delete</asp:LinkButton>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoContacts" runat="server" Visible="false" CssClass="p-4 text-center text-muted">
                    <p class="small mb-2">No emergency contacts configured yet.</p>
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>
