<%@ Page Title="Faculty Profile & Preferences" Language="C#" MasterPageFile="~/MasterPages/Faculty.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Campusaid.Faculty.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Faculty Profile & Preferences</h1>
    <p>Manage safety credentials, departmental duties, and notifications.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Notice -->
    <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="alert alert-success py-2 small mb-4">
        <asp:Literal ID="litNotice" runat="server" />
    </asp:Panel>

    <div class="row g-4">
        <!-- Left Column: Faculty Identity & Channels (Matching Figma Page 20) -->
        <div class="col-lg-6">
            <div class="card-ca mb-4">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <div class="rounded-circle bg-dark text-white d-flex align-items-center justify-content-center fw-bold fs-3" style="width: 65px; height: 65px;">
                        MR
                    </div>
                    <div>
                        <h4 class="fw-bold text-dark mb-1"><asp:Literal ID="litFacultyName" runat="server">Prof. Manab Roy</asp:Literal></h4>
                        <div class="small text-secondary mb-1">Senior Instructor — Chemistry Department</div>
                        <span class="badge-ca badge-resolved">STATUS: CERTIFIED MARSHAL</span>
                    </div>
                </div>

                <div class="p-3 bg-light rounded-3 border mb-3">
                    <div class="mb-2">
                        <label class="form-label-ca" for="txtOfficeLocation">Office Location</label>
                        <asp:TextBox ID="txtOfficeLocation" runat="server" CssClass="form-control-ca" Text="Sector B, Building 3 - Room 204"></asp:TextBox>
                    </div>

                    <div class="mb-2">
                        <label class="form-label-ca" for="txtEmail">University Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control-ca" ReadOnly="true"></asp:TextBox>
                    </div>

                    <div class="mb-0">
                        <label class="form-label-ca" for="txtPhone">Department Direct Line</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control-ca" placeholder="+91 98765 43210"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" ValidationGroup="vgFacultyProfile" ErrorMessage="Department direct phone number is required." CssClass="text-danger small d-block mt-1" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhone" ValidationGroup="vgFacultyProfile" ValidationExpression="^\+91[\s\-]?[6-9]\d{4}[\s\-]?[0-9]{5}$|^\+91[\s\-]?[6-9]\d{9}$" ErrorMessage="Please enter a valid Indian mobile number (+91 98765 43210)." CssClass="text-danger small d-block mt-1" Display="Dynamic" />
                    </div>
                </div>

                <!-- Notification Channels with Modern Toggle Switches -->
                <h6 class="fw-bold text-dark mb-2">Notification Channels</h6>
                <div class="p-3 bg-light rounded-3 border mb-3">
                    <label class="ca-toggle-switch mb-2 p-2 bg-white rounded border d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-dark small">SMS Warnings</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Instant priority texts for campus evacuations</div>
                        </div>
                        <span class="ca-toggle-track">
                            <asp:CheckBox ID="chkSms" runat="server" Checked="true" />
                            <span class="ca-toggle-slider"></span>
                        </span>
                    </label>

                    <label class="ca-toggle-switch mb-0 p-2 bg-white rounded border d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-dark small">Email Digests</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Daily administrative security recap</div>
                        </div>
                        <span class="ca-toggle-track">
                            <asp:CheckBox ID="chkEmailDigest" runat="server" Checked="true" />
                            <span class="ca-toggle-slider"></span>
                        </span>
                    </label>
                </div>

                <asp:Button ID="btnSaveProfile" runat="server" Text="Update Profile & Channels" CssClass="btn-ca btn-ca-primary w-100" OnClick="btnSaveProfile_Click" ValidationGroup="vgFacultyProfile" CausesValidation="true" />
            </div>
        </div>

        <!-- Right Column: Department Emergency Duties (Matching Figma Page 20) -->
        <div class="col-lg-6">
            <div class="card-ca">
                <div class="card-title-ca mb-3">
                    <span>Department Emergency Duties</span>
                    <span class="badge bg-secondary text-white">ASSIGNED</span>
                </div>
                <p class="small text-muted mb-3">Active roles designated by the University Campus Safety Committee.</p>

                <!-- Duty 1: Evacuation Coordinator -->
                <div class="p-3 bg-light rounded-3 border mb-3">
                    <div class="d-flex align-items-center gap-2 mb-2">
                        <div class="brand-icon bg-primary-subtle text-primary border border-primary" style="width: 36px; height: 36px; border-radius: 8px;">
                            <svg class="ca-icon ca-icon-md text-primary" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                        </div>
                        <h5 class="fw-bold text-dark mb-0 fs-6">Evacuation Coordinator</h5>
                    </div>
                    <p class="small text-secondary mb-0">
                        Responsible for verifying Science Block 3 floor sweeps during active alarms, guiding classes to Sector B South Lawn assembly point.
                    </p>
                </div>

                <!-- Duty 2: First-Aid Responder -->
                <div class="p-3 bg-light rounded-3 border mb-3">
                    <div class="d-flex align-items-center gap-2 mb-2">
                        <div class="brand-icon bg-danger-subtle text-danger border border-danger" style="width: 36px; height: 36px; border-radius: 8px;">
                            <svg class="ca-icon ca-icon-md text-danger" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="M12 8v8"/><path d="M8 12h8"/></svg>
                        </div>
                        <h5 class="fw-bold text-dark mb-0 fs-6">First-Aid Responder</h5>
                    </div>
                    <p class="small text-secondary mb-0">
                        CPR/AED Certified. Active backup for local medical incidents in Chemistry &amp; Physics labs until paramedics arrive.
                    </p>
                </div>

                <!-- Duty 3: Chemical Neutralization Lead -->
                <div class="p-3 bg-light rounded-3 border">
                    <div class="d-flex align-items-center gap-2 mb-2">
                        <div class="brand-icon bg-warning-subtle text-warning border border-warning" style="width: 36px; height: 36px; border-radius: 8px;">
                            <svg class="ca-icon ca-icon-md text-warning" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 2v7.31L4.15 19.3a2 2 0 0 0 1.7 2.7h12.3a2 2 0 0 0 1.7-2.7L14 9.31V2"/></svg>
                        </div>
                        <h5 class="fw-bold text-dark mb-0 fs-6">Chemical Spill Warden</h5>
                    </div>
                    <p class="small text-secondary mb-0">
                        Authorized to operate Sector B laboratory exhaust cutoffs and maintain hazardous material inventory sheets.
                    </p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
