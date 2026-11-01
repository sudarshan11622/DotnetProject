<%@ Page Title="Emergency Alerts Control Center" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="EmergencyAlerts.aspx.cs" Inherits="Campusaid.Admin.EmergencyAlerts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Emergency Alerts Control Center</h1>
    <p>Dispatch broadcast warnings, control campus sirens, and review critical safety records.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Notice -->
    <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="alert alert-success py-2 small mb-4">
        <asp:Literal ID="litNotice" runat="server" />
    </asp:Panel>

    <div class="row g-4">
        <!-- Left Column: Broadcast New Alert Form (Matching Figma Page 25) -->
        <div class="col-lg-5">
            <div class="card-ca">
                <div class="card-title-ca mb-3 pb-2 border-bottom">
                    <span>Broadcast New Alert</span>
                    <span class="badge bg-danger text-white">LIVE COMMAND</span>
                </div>

                <asp:ValidationSummary ID="valAlert" runat="server" CssClass="alert alert-danger py-1 small mb-3" ValidationGroup="vgBroadcast" />

                <!-- Alert Heading -->
                <div class="mb-3">
                    <label class="form-label-ca" for="txtAlertHeading">Alert Heading <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtAlertHeading" runat="server" CssClass="form-control-ca" placeholder="e.g. Active Intruder or Gas Leak Alert"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvHeading" runat="server" ControlToValidate="txtAlertHeading" ErrorMessage="Alert Heading is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgBroadcast">* Required</asp:RequiredFieldValidator>
                </div>

                <!-- Severity Level -->
                <div class="mb-3">
                    <label class="form-label-ca" for="ddlAlertSeverity">Severity Level <span class="text-danger">*</span></label>
                    <asp:DropDownList ID="ddlAlertSeverity" runat="server" CssClass="form-control-ca">
                        <asp:ListItem Value="Critical">Critical Level (Immediate Shelter / Triage)</asp:ListItem>
                        <asp:ListItem Value="Warning">Warning Level (Restricted Operations)</asp:ListItem>
                        <asp:ListItem Value="Routine">Routine / Informational Advisory</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Target Audience -->
                <div class="mb-3">
                    <label class="form-label-ca" for="ddlAudience">Target Audience <span class="text-danger">*</span></label>
                    <asp:DropDownList ID="ddlAudience" runat="server" CssClass="form-control-ca">
                        <asp:ListItem Value="All Campus">All Campus (Students, Faculty, Staff)</asp:ListItem>
                        <asp:ListItem Value="Students">Students Only</asp:ListItem>
                        <asp:ListItem Value="Faculty">Faculty Only</asp:ListItem>
                        <asp:ListItem Value="Staff">Staff & Facilities Team</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Affected Area -->
                <div class="mb-3">
                    <label class="form-label-ca" for="txtAffectedArea">Affected Campus Area</label>
                    <asp:TextBox ID="txtAffectedArea" runat="server" CssClass="form-control-ca" placeholder="e.g. Sector B Labs, Science Block 3"></asp:TextBox>
                </div>

                <!-- SMS & Broadcast Message -->
                <div class="mb-4">
                    <label class="form-label-ca" for="txtAlertMessage">SMS & Broadcast Message <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtAlertMessage" runat="server" CssClass="form-control-ca" TextMode="MultiLine" Rows="4" placeholder="Enter exact emergency instructions here to dispatch immediately to safety devices..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvMsg" runat="server" ControlToValidate="txtAlertMessage" ErrorMessage="Broadcast Message is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgBroadcast">* Required</asp:RequiredFieldValidator>
                </div>

                <div class="d-grid gap-2">
                    <asp:LinkButton ID="btnBroadcastNow" runat="server" CssClass="btn-ca btn-ca-danger py-2.5 fw-bold" OnClick="btnBroadcastNow_Click" ValidationGroup="vgBroadcast" CausesValidation="true">
                        <svg class="ca-icon ca-icon-sm" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M7 12a5 5 0 0 1 10 0v4H7v-4z"/><path d="M5 20h14"/><path d="M12 4V2"/><path d="M4 4l2 2"/><path d="M20 4l-2 2"/></svg>
                        BROADCAST ALERT NOW
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnScheduleBroadcast" runat="server" CssClass="btn-ca btn-ca-outline py-2" OnClick="btnScheduleBroadcast_Click" ValidationGroup="vgBroadcast" CausesValidation="true">
                        <svg class="ca-icon ca-icon-sm" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                        Schedule Broadcast (In-Memory)...
                    </asp:LinkButton>
                </div>
            </div>
        </div>

        <!-- Right Column: Active Alerts & Broadcast History (Matching Figma Page 25) -->
        <div class="col-lg-7">
            <div class="card-ca">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <div>
                        <h3 class="card-title-ca mb-0">Active Alerts & Broadcast History</h3>
                    </div>
                    <span class="badge-ca badge-critical"><asp:Literal ID="litActiveCountBadge" runat="server">3 ACTIVE</asp:Literal></span>
                </div>

                <div class="table-ca-wrapper">
                    <asp:Repeater ID="rptAlertHistory" runat="server" OnItemCommand="rptAlertHistory_ItemCommand">
                        <HeaderTemplate>
                            <table class="table-ca">
                                <thead>
                                    <tr>
                                        <th>Title</th>
                                        <th>Severity</th>
                                        <th>Audience</th>
                                        <th>Created By</th>
                                        <th>Date/Time</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="fw-bold text-dark"><%# Eval("Title") %></td>
                                <td>
                                    <span class='badge-ca <%# GetSeverityBadge(Eval("Severity").ToString()) %>'>
                                        <%# Eval("Severity") %>
                                    </span>
                                </td>
                                <td class="small text-secondary"><%# Eval("TargetAudience") %></td>
                                <td class="small text-muted"><%# Eval("CreatedBy") %></td>
                                <td class="small text-muted"><%# GetTimeAgo((DateTime)Eval("IssuedDate")) %></td>
                                <td>
                                    <span class='badge-ca <%# (bool)Eval("IsActive") ? "badge-active" : "badge-inactive" %>'>
                                        <%# (bool)Eval("IsActive") ? "Active" : "Expired" %>
                                    </span>
                                </td>
                                <td>
                                    <asp:LinkButton ID="btnToggleAlert" runat="server" 
                                        CommandName="ToggleAlert" 
                                        CommandArgument='<%# Eval("Id") %>' 
                                        CssClass='<%# (bool)Eval("IsActive") ? "btn btn-sm btn-outline-danger py-0 px-2" : "btn btn-sm btn-outline-success py-0 px-2" %>'
                                        style="font-size: 0.72rem;" 
                                        CausesValidation="false">
                                        <%# (bool)Eval("IsActive") ? "Deactivate" : "Activate" %>
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
