<%@ Page Title="Faculty Control Hub" Language="C#" MasterPageFile="~/MasterPages/Faculty.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Campusaid.Faculty.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Faculty Control Hub</h1>
    <p>Overview of campus emergency services, pending reports, and critical resources.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Critical Broadcast Authority Banner (Matching Figma Page 15) -->
    <div class="sos-banner-card mb-4" style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);">
        <div class="sos-banner-content">
            <span class="badge-ca badge-warning mb-2">Authenticated Authority</span>
            <h2>CRITICAL BROADCAST AUTHORITY</h2>
            <p>As an authenticated faculty member, you have the authority to signal departmental warnings or request rapid response teams for classrooms.</p>
            <div class="mt-3">
                <a href="ReportIncident.aspx?override=1" class="btn-ca btn-ca-danger px-4 py-2">
                    <svg class="ca-icon ca-icon-sm" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M7 12a5 5 0 0 1 10 0v4H7v-4z"/><path d="M5 20h14"/><path d="M12 4V2"/><path d="M4 4l2 2"/><path d="M20 4l-2 2"/></svg>
                    INITIATE EMERGENCY
                </a>
            </div>
        </div>
    </div>

    <!-- 4 Stat Cards (Matching Figma Page 15) -->
    <div class="row g-3 mb-4">
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="stat-header">ACTIVE ALERTS</div>
                <div class="stat-value text-danger"><asp:Literal ID="litActiveAlerts" runat="server">3</asp:Literal> Alerts</div>
                <div class="stat-subtext">1 Critical shelter-in-place</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="stat-header">PENDING REPORTS</div>
                <div class="stat-value text-warning"><asp:Literal ID="litPendingReports" runat="server">4</asp:Literal> Pending</div>
                <div class="stat-subtext">Awaiting administrative dispatch</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="stat-header">INCIDENTS THIS MONTH</div>
                <div class="stat-value text-dark"><asp:Literal ID="litMonthIncidents" runat="server">18</asp:Literal> Logged</div>
                <div class="stat-subtext"><asp:Literal ID="litMonthBreakdown" runat="server">8 Medical, 4 Safety, 6 Other</asp:Literal></div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="stat-header">RESOURCES DIRECTORY</div>
                <div class="stat-value text-primary"><asp:Literal ID="litResourcesCount" runat="server">12</asp:Literal> Hotlines</div>
                <div class="stat-subtext">Click to view immediate help files</div>
            </div>
        </div>
    </div>

    <!-- Main Feed & Quick Dispatch Controls Row (Matching Figma Page 15) -->
    <div class="row g-4">
        <!-- Recent Incidents & Alerts Feed -->
        <div class="col-lg-8">
            <div class="card-ca">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <h3 class="card-title-ca mb-0">Recent Incidents & Alerts Feed</h3>
                    <a href="EmergencyAlerts.aspx" class="text-primary small fw-bold text-decoration-none d-inline-flex align-items-center gap-1">All Broadcasts <svg class="ca-icon ca-icon-xs" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg></a>
                </div>

                <asp:Repeater ID="rptFeed" runat="server">
                    <ItemTemplate>
                        <div class="p-3 mb-3 bg-light rounded-3 border">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class='badge-ca <%# GetSeverityBadge(Eval("Severity").ToString()) %>'>
                                    <%# Eval("Severity") %>
                                </span>
                                <span class="small text-muted fw-semibold">
                                    <%# ((DateTime)Eval("IssuedDate")).ToString("MMM dd, hh:mm tt") %>
                                </span>
                            </div>
                            <h5 class="fw-bold text-dark mb-1"><%# Eval("Title") %></h5>
                            <p class="small text-secondary mb-2"><%# Eval("Message") %></p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="small text-muted d-inline-flex align-items-center gap-1">
                                    <svg class="ca-icon ca-icon-xs text-danger" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                                    <span><strong>Affected Area:</strong> <%# Eval("AffectedArea") %></span>
                                </span>
                                <span class="badge bg-white border text-secondary" style="font-size: 0.68rem;"><%# Eval("IssuingAuthority") %></span>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <!-- Quick Dispatch Controls (Matching Figma Page 15) -->
        <div class="col-lg-4">
            <div class="card-ca">
                <div class="card-title-ca mb-3">
                    <span>Quick Dispatch Controls</span>
                </div>
                <p class="small text-muted mb-3">Fast-track direct communications to emergency centers.</p>

                <div class="d-grid gap-2">
                    <a href="ReportIncident.aspx" class="btn-quick-action text-start p-3 rounded-3 d-flex align-items-center justify-content-between">
                        <span class="fw-bold d-flex align-items-center gap-2">
                            <svg class="ca-icon ca-icon-sm text-warning" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                            Report Classroom Incident
                        </span>
                        <svg class="ca-icon ca-icon-xs text-muted" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                    </a>
                    <a href="Resources.aspx" class="btn-quick-action text-start p-3 rounded-3 d-flex align-items-center justify-content-between">
                        <span class="fw-bold d-flex align-items-center gap-2">
                            <svg class="ca-icon ca-icon-sm text-primary" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><rect x="8" y="2" width="8" height="4" rx="1" ry="1"/><path d="M9 12h6"/><path d="M9 16h6"/></svg>
                            Access Faculty Checklists
                        </span>
                        <svg class="ca-icon ca-icon-xs text-muted" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                    </a>
                    <a href="tel:+919876543210" class="btn-dial-security text-start p-3 rounded-3 d-flex align-items-center justify-content-between text-decoration-none">
                        <span class="fw-bold text-danger d-flex align-items-center gap-2">
                            <svg class="ca-icon ca-icon-sm text-danger" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                            Dial Campus Security
                        </span>
                        <span class="badge bg-danger text-white">EXT. 9111</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
