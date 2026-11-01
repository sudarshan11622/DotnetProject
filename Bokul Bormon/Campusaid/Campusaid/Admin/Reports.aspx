<%@ Page Title="Incident Report Management" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="Campusaid.Admin.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Incident Report Management</h1>
    <p>Track, filter, and dispatch personnel for all security, medical, or facility reports.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Notice -->
    <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="alert alert-success py-2 small mb-4">
        <asp:Literal ID="litNotice" runat="server" />
    </asp:Panel>

    <!-- Filters Bar (Matching Figma Page 22) -->
    <div class="card-ca p-3 mb-4">
        <div class="row g-2 align-items-center mb-3">
            <div class="col-md-2 col-6">
                <label class="form-label-ca mb-1 small">Date Range</label>
                <asp:DropDownList ID="ddlDateFilter" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Value="30">Last 30 Days</asp:ListItem>
                    <asp:ListItem Value="7">Last 7 Days</asp:ListItem>
                    <asp:ListItem Value="1">Today</asp:ListItem>
                    <asp:ListItem Value="All">All Time</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2 col-6">
                <label class="form-label-ca mb-1 small">Incident Type</label>
                <asp:DropDownList ID="ddlTypeFilter" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Value="All">All Incidents</asp:ListItem>
                    <asp:ListItem Value="Medical">Medical Assistance</asp:ListItem>
                    <asp:ListItem Value="Security">Security Threat</asp:ListItem>
                    <asp:ListItem Value="Facility">Facility Hazard</asp:ListItem>
                    <asp:ListItem Value="Hazard">Fire / Hazmat</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2 col-6">
                <label class="form-label-ca mb-1 small">Status</label>
                <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Value="All">All Statuses</asp:ListItem>
                    <asp:ListItem Value="Submitted">Submitted</asp:ListItem>
                    <asp:ListItem Value="Pending">Pending</asp:ListItem>
                    <asp:ListItem Value="Dispatching">Dispatching</asp:ListItem>
                    <asp:ListItem Value="Investigating">Investigating</asp:ListItem>
                    <asp:ListItem Value="Resolved">Resolved</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2 col-6">
                <label class="form-label-ca mb-1 small">Severity</label>
                <asp:DropDownList ID="ddlSeverityFilter" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Value="All">All Severities</asp:ListItem>
                    <asp:ListItem Value="Critical">Critical</asp:ListItem>
                    <asp:ListItem Value="Warning">Warning / High</asp:ListItem>
                    <asp:ListItem Value="Routine">Routine / Minor</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2 col-6">
                <label class="form-label-ca mb-1 small">Reporter Role</label>
                <asp:DropDownList ID="ddlRoleFilter" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Value="All">All Roles</asp:ListItem>
                    <asp:ListItem Value="Student">Student</asp:ListItem>
                    <asp:ListItem Value="Faculty">Faculty</asp:ListItem>
                    <asp:ListItem Value="Staff">Staff</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2 col-6 d-flex align-items-end">
                <asp:Button ID="btnResetFilters" runat="server" Text="Reset Filters" CssClass="btn btn-sm btn-outline-secondary w-100" OnClick="btnResetFilters_Click" CausesValidation="false" />
            </div>
        </div>

        <!-- Action Buttons Row (Matching Figma Page 22) -->
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 pt-2 border-top">
            <div class="d-flex gap-2">
                <asp:Button ID="btnOpenAssignModal" runat="server" Text="Assign To Officer" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnOpenAssignModal_Click" CausesValidation="false" />
                <asp:Button ID="btnOpenStatusModal" runat="server" Text="Change Status" CssClass="btn-ca btn-ca-outline btn-sm" OnClick="btnOpenStatusModal_Click" CausesValidation="false" />
                <asp:Button ID="btnExportSelection" runat="server" Text="Export Selection" CssClass="btn-ca btn-ca-outline btn-sm" OnClick="btnExportSelection_Click" CausesValidation="false" />
            </div>
            <div class="small text-muted fw-semibold">
                <asp:Literal ID="litSelectedCount" runat="server">Selected: 0 of 7 Reports</asp:Literal>
            </div>
        </div>
    </div>

    <!-- Reports Table (Matching Figma Page 22) -->
    <div class="table-ca-wrapper">
        <asp:Repeater ID="rptAdminReports" runat="server">
            <HeaderTemplate>
                <table class="table-ca">
                    <thead>
                        <tr>
                            <th style="width: 40px;">Sel</th>
                            <th>ID</th>
                            <th>Reporter Name</th>
                            <th>Role</th>
                            <th>Type</th>
                            <th>Location</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Severity</th>
                            <th>Assigned To</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td>
                        <asp:CheckBox ID="chkSelect" runat="server" />
                        <asp:HiddenField ID="hfReportId" runat="server" Value='<%# Eval("Id") %>' />
                    </td>
                    <td class="fw-bold text-primary font-monospace">#<%# Eval("CaseNumber").ToString().Replace("CASE-", "") %></td>
                    <td class="fw-bold text-dark"><%# Eval("ReporterName") %></td>
                    <td><span class="badge bg-light text-dark border"><%# Eval("ReporterRole") %></span></td>
                    <td><%# Eval("IncidentType") %></td>
                    <td class="small text-muted"><%# Eval("Location") %></td>
                    <td class="small text-muted"><%# ((DateTime)Eval("DateFiled")).ToString("MMM dd, HH:mm") %></td>
                    <td>
                        <span class='badge-ca <%# GetStatusBadge(Eval("Status").ToString()) %>'>
                            <%# Eval("Status").ToString().ToUpper() %>
                        </span>
                    </td>
                    <td>
                        <span class='badge-ca <%# GetSeverityBadge(Eval("Severity").ToString()) %>'>
                            <%# Eval("Severity").ToString().ToUpper() %>
                        </span>
                    </td>
                    <td class="small fw-semibold text-secondary">
                        <%# Eval("AssignedOfficer") %>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>

        <!-- Pagination Controls -->
        <div class="p-3 bg-light d-flex justify-content-between align-items-center border-top">
            <span class="small text-muted"><asp:Literal ID="litShowingReports" runat="server">Showing 1-7 of 7 Reports</asp:Literal></span>
            <div class="d-flex gap-1">
                <asp:Button ID="btnPrevPage" runat="server" Text="Previous" CssClass="btn btn-sm btn-outline-secondary" OnClick="btnPrevPage_Click" CausesValidation="false" />
                <asp:Button ID="btnNextPage" runat="server" Text="Next" CssClass="btn btn-sm btn-outline-secondary" OnClick="btnNextPage_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

    <!-- Assign To Officer Modal -->
    <asp:Panel ID="pnlAssignModal" runat="server" Visible="false" CssClass="modal fade show d-block" style="background: rgba(0,0,0,0.5);" TabIndex="-1">
        <div class="modal-dialog modal-dialog-centered modal-ca-compact">
            <div class="modal-content shadow">
                <div class="modal-header bg-light py-2 px-3">
                    <h6 class="modal-title fw-bold mb-0">Assign Responder / Dispatch Officer</h6>
                    <asp:LinkButton ID="btnCloseAssignX" runat="server" CssClass="btn-close" OnClick="btnCloseModal_Click" CausesValidation="false"></asp:LinkButton>
                </div>
                <div class="modal-body p-3">
                    <div class="mb-3">
                        <label class="form-label-ca small fw-semibold" for="ddlOfficers">Select Officer to Deploy</label>
                        <asp:DropDownList ID="ddlOfficers" runat="server" CssClass="form-control-ca">
                            <asp:ListItem Value="Sgt. Miller (EMT-2)">Sgt. Miller (EMT-2) — Medical Priority</asp:ListItem>
                            <asp:ListItem Value="Officer Davis">Officer Davis — Campus Security Lead</asp:ListItem>
                            <asp:ListItem Value="Officer Martinez">Officer Martinez — Patrol & Facility Safety</asp:ListItem>
                            <asp:ListItem Value="Chief Deputy">Chief Deputy — Administrative Dispatch</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-check">
                        <asp:CheckBox ID="chkUpdateStatusToDispatch" runat="server" CssClass="form-check-input" Checked="true" />
                        <label class="form-check-label small" for="<%= chkUpdateStatusToDispatch.ClientID %>">Also update status to DISPATCHING</label>
                    </div>
                </div>
                <div class="modal-footer py-2 px-3">
                    <asp:Button ID="btnCancelAssign" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary btn-sm" OnClick="btnCloseModal_Click" CausesValidation="false" />
                    <asp:Button ID="btnConfirmAssign" runat="server" Text="Assign Selected" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnConfirmAssign_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- Change Status Modal -->
    <asp:Panel ID="pnlStatusModal" runat="server" Visible="false" CssClass="modal fade show d-block" style="background: rgba(0,0,0,0.5);" TabIndex="-1">
        <div class="modal-dialog modal-dialog-centered modal-ca-compact">
            <div class="modal-content shadow">
                <div class="modal-header bg-light py-2 px-3">
                    <h6 class="modal-title fw-bold mb-0">Update Incident Case Status</h6>
                    <asp:LinkButton ID="btnCloseStatusX" runat="server" CssClass="btn-close" OnClick="btnCloseModal_Click" CausesValidation="false"></asp:LinkButton>
                </div>
                <div class="modal-body p-3">
                    <div class="mb-3">
                        <label class="form-label-ca small fw-semibold" for="ddlNewStatus">Select New Status</label>
                        <asp:DropDownList ID="ddlNewStatus" runat="server" CssClass="form-control-ca">
                            <asp:ListItem Value="Investigating">INVESTIGATING</asp:ListItem>
                            <asp:ListItem Value="Dispatching">DISPATCHING</asp:ListItem>
                            <asp:ListItem Value="Resolved">RESOLVED</asp:ListItem>
                            <asp:ListItem Value="Pending">PENDING</asp:ListItem>
                            <asp:ListItem Value="Rejected">REJECTED</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnCancelStatus" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary btn-sm" OnClick="btnCloseModal_Click" CausesValidation="false" />
                    <asp:Button ID="btnConfirmStatus" runat="server" Text="Update Status" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnConfirmStatus_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
