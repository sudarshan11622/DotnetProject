<%@ Page Title="Admin Command Center" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Campusaid.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .trend-bar {
            background: linear-gradient(180deg, #2563eb 0%, #1e40af 100%);
            border-radius: 4px 4px 0 0;
            width: 22px;
            display: inline-block;
            transition: height 0.3s ease;
        }
        .trend-bar-crit {
            background: linear-gradient(180deg, #ef4444 0%, #b91c1c 100%);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Admin Command Center</h1>
    <p>Comprehensive campus security oversight, live dispatch status, and utility analytics.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- 5 Stat Cards (Matching Figma Page 21) -->
    <div class="row g-3 mb-4">
        <div class="col">
            <div class="stat-card">
                <div class="stat-header">Total Portal Users</div>
                <div class="stat-value"><asp:Literal ID="litTotalUsers" runat="server">12,482</asp:Literal></div>
                <div class="stat-subtext">Students, Faculty, and Admin Staff</div>
            </div>
        </div>
        <div class="col">
            <div class="stat-card">
                <div class="stat-header">Active Incidents</div>
                <div class="stat-value text-danger"><asp:Literal ID="litActiveIncidents" runat="server">4 Urgent</asp:Literal></div>
                <div class="stat-subtext">Immediate response dispatched</div>
            </div>
        </div>
        <div class="col">
            <div class="stat-card">
                <div class="stat-header">Resolved This Month</div>
                <div class="stat-value text-success"><asp:Literal ID="litResolvedCount" runat="server">48 Cases</asp:Literal></div>
                <div class="stat-subtext">Average resolution time 18 mins</div>
            </div>
        </div>
        <div class="col">
            <div class="stat-card">
                <div class="stat-header">Pending Reports</div>
                <div class="stat-value text-warning"><asp:Literal ID="litPendingCount" runat="server">14 Awaiting</asp:Literal></div>
                <div class="stat-subtext">Requires dispatch assignment</div>
            </div>
        </div>
        <div class="col">
            <div class="stat-card">
                <div class="stat-header">Active Broad Alert</div>
                <div class="stat-value text-primary"><asp:Literal ID="litBroadAlertCount" runat="server">1 Broadcast</asp:Literal></div>
                <div class="stat-subtext">High Wind Warning active</div>
            </div>
        </div>
    </div>

    <!-- Charts Section (Matching Figma Page 21) -->
    <div class="row g-4 mb-4">
        <!-- Incident Trends (Last 30 Days) -->
        <div class="col-lg-8">
            <div class="card-ca h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3 class="card-title-ca mb-0">Incident Trends (Last 30 Days)</h3>
                    <span class="badge bg-light text-dark border">Oct 1 - Oct 28</span>
                </div>
                
                <!-- SVG / CSS Bar Chart Representation -->
                <div class="p-3 bg-light rounded-3 border d-flex align-items-end justify-content-between" style="height: 180px;">
                    <div class="text-center"><div class="trend-bar" style="height: 45px;"></div><div class="small text-muted" style="font-size: 0.68rem;">Oct 1</div></div>
                    <div class="text-center"><div class="trend-bar" style="height: 70px;"></div><div class="small text-muted" style="font-size: 0.68rem;">Oct 4</div></div>
                    <div class="text-center"><div class="trend-bar" style="height: 35px;"></div><div class="small text-muted" style="font-size: 0.68rem;">Oct 7</div></div>
                    <div class="text-center"><div class="trend-bar trend-bar-crit" style="height: 120px;"></div><div class="small text-muted" style="font-size: 0.68rem;">Oct 10</div></div>
                    <div class="text-center"><div class="trend-bar" style="height: 60px;"></div><div class="small text-muted" style="font-size: 0.68rem;">Oct 13</div></div>
                    <div class="text-center"><div class="trend-bar" style="height: 85px;"></div><div class="small text-muted" style="font-size: 0.68rem;">Oct 16</div></div>
                    <div class="text-center"><div class="trend-bar" style="height: 50px;"></div><div class="small text-muted" style="font-size: 0.68rem;">Oct 19</div></div>
                    <div class="text-center"><div class="trend-bar trend-bar-crit" style="height: 135px;"></div><div class="small text-muted" style="font-size: 0.68rem;">Oct 22</div></div>
                    <div class="text-center"><div class="trend-bar" style="height: 90px;"></div><div class="small text-muted" style="font-size: 0.68rem;">Oct 25</div></div>
                    <div class="text-center"><div class="trend-bar" style="height: 65px;"></div><div class="small text-muted" style="font-size: 0.68rem;">Oct 28</div></div>
                </div>
            </div>
        </div>

        <!-- Incidents by Severity Donut / Percent Breakdown -->
        <div class="col-lg-4">
            <div class="card-ca h-100">
                <div class="card-title-ca mb-3">
                    <span>Incidents by Severity</span>
                </div>

                <div class="mb-3">
                    <div class="d-flex justify-content-between align-items-center small mb-1">
                        <span class="fw-bold text-danger d-flex align-items-center gap-1.5">
                            <span class="status-dot" style="background-color: var(--ca-red); box-shadow: none;"></span>
                            Critical Alerts
                        </span>
                        <span class="fw-bold"><asp:Literal ID="litPctCritical" runat="server">12%</asp:Literal></span>
                    </div>
                    <div class="progress" style="height: 8px;">
                        <div class="progress-bar bg-danger" style="width: 12%;"></div>
                    </div>
                </div>

                <div class="mb-3">
                    <div class="d-flex justify-content-between align-items-center small mb-1">
                        <span class="fw-bold text-warning d-flex align-items-center gap-1.5">
                            <span class="status-dot" style="background-color: var(--ca-amber); box-shadow: none;"></span>
                            Major Warnings
                        </span>
                        <span class="fw-bold"><asp:Literal ID="litPctWarning" runat="server">35%</asp:Literal></span>
                    </div>
                    <div class="progress" style="height: 8px;">
                        <div class="progress-bar bg-warning" style="width: 35%;"></div>
                    </div>
                </div>

                <div class="mb-3">
                    <div class="d-flex justify-content-between align-items-center small mb-1">
                        <span class="fw-bold text-primary d-flex align-items-center gap-1.5">
                            <span class="status-dot" style="background-color: var(--ca-blue); box-shadow: none;"></span>
                            Routine Support
                        </span>
                        <span class="fw-bold"><asp:Literal ID="litPctRoutine" runat="server">53%</asp:Literal></span>
                    </div>
                    <div class="progress" style="height: 8px;">
                        <div class="progress-bar bg-primary" style="width: 53%;"></div>
                    </div>
                </div>

                <div class="p-2.5 bg-light rounded-3 border text-center small text-muted mt-4">
                    Based on <asp:Literal ID="litTotalCasesSample" runat="server">148</asp:Literal> total triage events logged.
                </div>
            </div>
        </div>
    </div>

    <!-- Live Dispatch Activity & Quick Admin Actions (Matching Figma Page 21) -->
    <div class="row g-4">
        <!-- Live Dispatch Activity -->
        <div class="col-lg-8">
            <div class="card-ca">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <h3 class="card-title-ca mb-0">Live Dispatch Activity</h3>
                    <a href="Reports.aspx" class="text-primary small fw-bold text-decoration-none d-inline-flex align-items-center gap-1">
                        View All Reports
                        <svg class="ca-icon ca-icon-xs" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                    </a>
                </div>

                <asp:Repeater ID="rptLiveDispatch" runat="server">
                    <ItemTemplate>
                        <div class="p-3 mb-3 bg-light rounded-3 border">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class='badge-ca <%# GetSeverityBadge(Eval("Severity").ToString()) %>'>
                                    <%# Eval("Severity") %>
                                </span>
                                <span class="small text-muted fw-semibold">
                                    <%# GetTimeAgo((DateTime)Eval("DateFiled")) %>
                                </span>
                            </div>
                            <h5 class="fw-bold text-dark mb-1"><%# Eval("IncidentType") %> reported at <%# Eval("Location") %></h5>
                            <p class="small text-secondary mb-2">
                                <strong><%# Eval("ReporterRole") %> report:</strong> <%# Eval("Description") %>
                            </p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="badge bg-white border text-primary d-inline-flex align-items-center gap-1" style="font-size: 0.72rem;">
                                    <svg class="ca-icon ca-icon-xs text-primary" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                    Assigned: <%# Eval("AssignedOfficer") %>
                                </span>
                                <span class='badge-ca <%# GetStatusBadge(Eval("Status").ToString()) %>'><%# Eval("Status") %></span>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <!-- Quick Admin Actions -->
        <div class="col-lg-4">
            <div class="card-ca">
                <div class="card-title-ca mb-3">
                    <span>Quick Admin Actions</span>
                </div>
                <p class="small text-muted mb-3">Execute campus-wide emergency commands instantly.</p>

                <div class="d-grid gap-2">
                    <a href="EmergencyAlerts.aspx" class="admin-action-card action-danger">
                        <span class="fw-bold text-danger d-flex align-items-center gap-2">
                            <svg class="ca-icon ca-icon-sm text-danger" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M7 12a5 5 0 0 1 10 0v4H7v-4z"/><path d="M5 20h14"/><path d="M12 4V2"/><path d="M4 4l2 2"/><path d="M20 4l-2 2"/></svg>
                            Send Campus Alert
                        </span>
                        <svg class="ca-icon ca-icon-xs text-muted" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                    </a>
                    <a href="Reports.aspx" class="admin-action-card action-dark">
                        <span class="fw-bold text-dark d-flex align-items-center gap-2">
                            <svg class="ca-icon ca-icon-sm text-dark" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                            View All Reports
                        </span>
                        <svg class="ca-icon ca-icon-xs text-muted" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                    </a>
                    <a href="Users.aspx" class="admin-action-card action-primary">
                        <span class="fw-bold text-primary d-flex align-items-center gap-2">
                            <svg class="ca-icon ca-icon-sm text-primary" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                            Manage Users
                        </span>
                        <svg class="ca-icon ca-icon-xs text-muted" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                    </a>
                    <a href="Settings.aspx" class="admin-action-card action-secondary">
                        <span class="fw-bold text-secondary d-flex align-items-center gap-2">
                            <svg class="ca-icon ca-icon-sm text-secondary" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
                            System Configuration
                        </span>
                        <svg class="ca-icon ca-icon-xs text-muted" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
