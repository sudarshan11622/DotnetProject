<%@ Page Title="System Configuration Settings" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="Campusaid.Admin.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>System Configuration Settings</h1>
    <p>Tune application safety defaults, roles/permissions tables, and security logging tools.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Notice -->
    <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="alert alert-success py-2 small mb-4">
        <asp:Literal ID="litNotice" runat="server" />
    </asp:Panel>

    <div class="row g-4">
        <!-- Left Column: General Configuration & Notification Rules -->
        <div class="col-lg-6">
            <!-- General Configuration (Matching Figma Page 27) -->
            <div class="card-ca mb-4">
                <div class="card-title-ca mb-3 pb-2 border-bottom">
                    <span>General Configuration</span>
                </div>

                <div class="mb-3">
                    <label class="form-label-ca" for="txtAppName">Directory App Name</label>
                    <asp:TextBox ID="txtAppName" runat="server" CssClass="form-control-ca"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label class="form-label-ca" for="txtInstitution">University Institution Name</label>
                    <asp:TextBox ID="txtInstitution" runat="server" CssClass="form-control-ca"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label class="form-label-ca" for="txtEmergencyDesk">Official Emergency Contact Desk</label>
                    <asp:TextBox ID="txtEmergencyDesk" runat="server" CssClass="form-control-ca"></asp:TextBox>
                </div>

                <div class="mb-4">
                    <label class="form-label-ca" for="txtEmergencyExt">Emergency Hotline Extension</label>
                    <asp:TextBox ID="txtEmergencyExt" runat="server" CssClass="form-control-ca"></asp:TextBox>
                </div>

                <asp:Button ID="btnSaveGeneral" runat="server" Text="Save General Configuration" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnSaveGeneral_Click" CausesValidation="false" />
            </div>

            <!-- Notification Dispatch Rules (Matching Figma Page 27) -->
            <div class="card-ca">
                <div class="card-title-ca mb-3 pb-2 border-bottom">
                    <span>Notification Dispatch Rules</span>
                </div>

                <div class="p-3 bg-light rounded-3 border mb-3">
                    <label class="ca-toggle-switch mb-3 p-2 bg-white rounded border d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-dark small">Enable Instant Emergency SMS Alerts</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Dispatch automatic SMS texts to all registered cellular devices.</div>
                        </div>
                        <span class="ca-toggle-track">
                            <asp:CheckBox ID="chkEnableSms" runat="server" />
                            <span class="ca-toggle-slider"></span>
                        </span>
                    </label>

                    <label class="ca-toggle-switch mb-3 p-2 bg-white rounded border d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-dark small">Automated Push Warnings to Student App</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Push notification warnings during severe weather emergencies.</div>
                        </div>
                        <span class="ca-toggle-track">
                            <asp:CheckBox ID="chkEnablePush" runat="server" />
                            <span class="ca-toggle-slider"></span>
                        </span>
                    </label>

                    <label class="ca-toggle-switch mb-0 p-2 bg-white rounded border d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-dark small">Siren Dispatch &amp; Voice Broadcast Sync</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Link critical warnings with campus audio horn devices.</div>
                        </div>
                        <span class="ca-toggle-track">
                            <asp:CheckBox ID="chkEnableSiren" runat="server" />
                            <span class="ca-toggle-slider"></span>
                        </span>
                    </label>
                </div>

                <asp:Button ID="btnSaveRules" runat="server" Text="Update Notification Rules" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnSaveRules_Click" CausesValidation="false" />
            </div>
        </div>

        <!-- Right Column: Access Control Permissions & Audit Logs -->
        <div class="col-lg-6">
            <!-- Access Control Permissions Matrix (Matching Figma Page 27) -->
            <div class="card-ca mb-4">
                <div class="card-title-ca mb-3 pb-2 border-bottom">
                    <span>Access Control Permissions</span>
                </div>

                <div class="table-ca-wrapper mb-2">
                    <table class="table-ca">
                        <thead>
                            <tr>
                                <th>Role</th>
                                <th>Initiate SOS</th>
                                <th>Broad Alerts</th>
                                <th>Edit Directory</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="fw-bold">Student Access</td>
                                <td><span class="badge bg-success-subtle text-success border">Allow Local</span></td>
                                <td><span class="badge bg-danger-subtle text-danger border">Deny</span></td>
                                <td><span class="badge bg-danger-subtle text-danger border">Deny</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold">Faculty / Staff</td>
                                <td><span class="badge bg-success-subtle text-success border">Allow Local</span></td>
                                <td><span class="badge bg-primary-subtle text-primary border">Allow Dept</span></td>
                                <td><span class="badge bg-success-subtle text-success border">Allow Local</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold">Police / Safety</td>
                                <td><span class="badge bg-success-subtle text-success border">Allow Global</span></td>
                                <td><span class="badge bg-success-subtle text-success border">Allow Global</span></td>
                                <td><span class="badge bg-success-subtle text-success border">Allow Global</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">System Admin</td>
                                <td><span class="badge bg-success-subtle text-success border">Allow Global</span></td>
                                <td><span class="badge bg-success-subtle text-success border">Allow Global</span></td>
                                <td><span class="badge bg-success-subtle text-success border">Allow Global</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="text-muted small text-end">* Active role permission boundaries enforced by server authorization.</div>
            </div>

            <!-- System Audit Logs (Matching Figma Page 27) -->
            <div class="card-ca">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <h3 class="card-title-ca mb-0">System Audit Logs</h3>
                    <asp:Button ID="btnExportAuditCsv" runat="server" Text="Export CSV" CssClass="btn-ca btn-ca-outline btn-sm py-1" OnClick="btnExportAuditCsv_Click" CausesValidation="false" />
                </div>

                <div class="p-2 bg-light rounded-3 border" style="max-height: 260px; overflow-y: auto;">
                    <asp:Repeater ID="rptAuditLogs" runat="server">
                        <ItemTemplate>
                            <div class="p-2 mb-2 bg-white rounded border small">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="fw-bold text-dark"><%# Eval("Action") %></span>
                                    <span class="text-muted" style="font-size: 0.7rem;"><%# GetTimeAgo((DateTime)Eval("Timestamp")) %></span>
                                </div>
                                <div class="text-secondary" style="font-size: 0.78rem;"><%# Eval("Details") %></div>
                                <div class="text-muted mt-1" style="font-size: 0.68rem;">User: <strong><%# Eval("User") %></strong></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
