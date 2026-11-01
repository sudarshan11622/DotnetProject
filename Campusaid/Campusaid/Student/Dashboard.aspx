<%@ Page Title="Student Home" Language="C#" MasterPageFile="~/MasterPages/Student.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Campusaid.Student.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Welcome back, <asp:Literal ID="litWelcomeName" runat="server">Bokul</asp:Literal></h1>
    <p>Stay informed and safe on campus today.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Success Banner if redirected from SOS or Report -->
    <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="alert alert-success d-flex align-items-center mb-4 p-3 rounded-3 shadow-sm">
        <span class="me-3 text-success d-flex align-items-center">
            <svg class="ca-icon ca-icon-lg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
        </span>
        <div>
            <div class="fw-bold"><asp:Literal ID="litNoticeTitle" runat="server" /></div>
            <div class="small"><asp:Literal ID="litNoticeMsg" runat="server" /></div>
        </div>
    </asp:Panel>

    <div class="row g-4">
        <!-- Main Left Column -->
        <div class="col-lg-8">
            <!-- SOS Emergency Card -->
            <div class="sos-banner-card">
                <div class="sos-banner-content">
                    <span class="badge-ca badge-critical mb-2">Emergency Assistance</span>
                    <h2>EMERGENCY SOS TRIGGERS</h2>
                    <p>Need immediate dispatcher help? Press the button to sound the alarm, alert Campus Police, and send your GPS coordinates.</p>
                    <div class="mt-3">
                        <a href="SOS.aspx" class="btn-sos-trigger">
                            <svg class="ca-icon ca-icon-sm" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M7 12a5 5 0 0 1 10 0v4H7v-4z"/><path d="M5 20h14"/><path d="M12 4V2"/><path d="M4 4l2 2"/><path d="M20 4l-2 2"/></svg>
                            TRIGGER SOS
                        </a>
                    </div>
                </div>
            </div>

            <!-- Two Action Cards -->
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="card-ca h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex align-items-center gap-2 mb-2">
                                <div class="brand-icon bg-warning-subtle text-warning border border-warning" style="width: 36px; height: 36px; border-radius: 8px;">
                                    <svg class="ca-icon ca-icon-md text-warning" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                                </div>
                                <h3 class="card-title-ca mb-0">Report Incident</h3>
                            </div>
                            <p class="text-muted small mb-4">File a non-emergency or emergency campus safety report with real-time evidence upload.</p>
                        </div>
                        <a href="ReportIncident.aspx" class="btn-ca btn-ca-primary w-100">Submit Report</a>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card-ca h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex align-items-center gap-2 mb-2">
                                <div class="brand-icon bg-primary-subtle text-primary border border-primary" style="width: 36px; height: 36px; border-radius: 8px;">
                                    <svg class="ca-icon ca-icon-md text-primary" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13c0 1.1.9 2 2 2Z"/></svg>
                                </div>
                                <h3 class="card-title-ca mb-0">Resources Directory</h3>
                            </div>
                            <p class="text-muted small mb-4">Access official university helplines, clinic operational hours, and security guides.</p>
                        </div>
                        <a href="Resources.aspx" class="btn-ca btn-ca-primary w-100">View Directory</a>
                    </div>
                </div>
            </div>

            <!-- Dashboard Stats Summary for Student -->
            <div class="row g-3 mt-1">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-header">My Filed Reports</div>
                        <div class="stat-value"><asp:Literal ID="litMyReportsCount" runat="server">4</asp:Literal></div>
                        <div class="stat-subtext">Case tracking active</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-header">Active Campus Alerts</div>
                        <div class="stat-value text-danger"><asp:Literal ID="litActiveAlerts" runat="server">3</asp:Literal></div>
                        <div class="stat-subtext">1 Critical shelter warning</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-header">Helplines On Call</div>
                        <div class="stat-value text-primary"><asp:Literal ID="litHotlinesCount" runat="server">6</asp:Literal></div>
                        <div class="stat-subtext">24/7 Security dispatch</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Alerts Column (Matching Figma Page 8) -->
        <div class="col-lg-4">
            <div class="card-ca h-100">
                <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
                    <h3 class="card-title-ca mb-0">Recent Alerts</h3>
                    <span class="badge-ca badge-critical"><asp:Literal ID="litActiveBadge" runat="server">3 ACTIVE</asp:Literal></span>
                </div>

                <asp:Repeater ID="rptRecentAlerts" runat="server">
                    <ItemTemplate>
                        <div class="p-3 mb-3 rounded-3 border bg-light">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="small text-muted fw-semibold"><%# GetTimeAgo((DateTime)Eval("IssuedDate")) %></span>
                                <span class='badge-ca <%# GetSeverityBadgeClass(Eval("Severity").ToString()) %>'>
                                    <%# Eval("Severity") %>
                                </span>
                            </div>
                            <h6 class="fw-bold text-dark mb-1"><%# Eval("Title") %></h6>
                            <p class="small text-muted mb-2"><%# Eval("Message") %></p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="badge bg-white text-secondary border" style="font-size: 0.68rem;"><%# Eval("IssuingAuthority") %></span>
                                <a href="Alerts.aspx" class="text-decoration-none small text-primary fw-bold d-inline-flex align-items-center gap-1">View Alert <svg class="ca-icon ca-icon-xs" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg></a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div class="text-center pt-2">
                    <a href="Alerts.aspx" class="btn-ca btn-ca-outline w-100">View All Campus Alerts</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
