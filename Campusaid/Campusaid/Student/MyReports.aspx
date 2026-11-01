<%@ Page Title="My Reports" Language="C#" MasterPageFile="~/MasterPages/Student.Master" AutoEventWireup="true" CodeBehind="MyReports.aspx.cs" Inherits="Campusaid.Student.MyReports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>My Submitted Reports</h1>
    <p>View and track updates of your filed incident reports and dispatch actions.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Success Banner after submission -->
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success d-flex align-items-center mb-4 p-3 rounded-3 shadow-sm">
        <span class="me-3 text-success d-flex align-items-center">
            <svg class="ca-icon ca-icon-lg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
        </span>
        <div>
            <div class="fw-bold">Incident Report Filed Successfully!</div>
            <div class="small">Your case has been queued for immediate triage. Assigned officers will update status in real time.</div>
        </div>
    </asp:Panel>

    <!-- Filter and Search Bar (Matching Figma Page 12) -->
    <div class="card-ca p-3 mb-4">
        <div class="row g-2 align-items-center">
            <div class="col-md-6 d-flex gap-2">
                <asp:Button ID="btnFilterAll" runat="server" Text="All Cases" CssClass="btn btn-sm btn-dark" OnClick="btnFilterStatus_Click" CommandArgument="All" CausesValidation="false" />
                <asp:Button ID="btnFilterActive" runat="server" Text="Filter Active" CssClass="btn btn-sm btn-outline-secondary" OnClick="btnFilterStatus_Click" CommandArgument="Active" CausesValidation="false" />
                <asp:Button ID="btnFilterResolved" runat="server" Text="Resolved" CssClass="btn btn-sm btn-outline-secondary" OnClick="btnFilterStatus_Click" CommandArgument="Resolved" CausesValidation="false" />
            </div>
            <div class="col-md-6">
                <div class="input-group input-group-sm">
                    <span class="input-group-text bg-white border-end-0 text-muted">
                        <svg class="ca-icon ca-icon-xs" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                    </span>
                    <asp:TextBox ID="txtSearchCases" runat="server" CssClass="form-control border-start-0" placeholder="Search your cases..."></asp:TextBox>
                    <asp:Button ID="btnSearchCases" runat="server" Text="Search" CssClass="btn btn-outline-dark" OnClick="btnSearchCases_Click" CausesValidation="false" />
                    <asp:Button ID="btnResetCases" runat="server" Text="Reset" CssClass="btn btn-outline-secondary" OnClick="btnResetCases_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </div>

    <!-- Case Table (Matching Figma Page 12) -->
    <div class="table-ca-wrapper">
        <asp:Repeater ID="rptCases" runat="server" OnItemCommand="rptCases_ItemCommand">
            <HeaderTemplate>
                <table class="table-ca">
                    <thead>
                        <tr>
                            <th>CASE ID</th>
                            <th>INCIDENT TYPE</th>
                            <th>DATE FILED</th>
                            <th>SEVERITY</th>
                            <th>STATUS</th>
                            <th>ASSIGNED OFFICER</th>
                            <th>ACTION</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td class="fw-bold text-primary font-monospace"><%# Eval("CaseNumber") %></td>
                    <td>
                        <div class="fw-bold text-dark"><%# Eval("IncidentType") %></div>
                        <div class="small text-muted"><%# Eval("Location") %></div>
                    </td>
                    <td><%# ((DateTime)Eval("DateFiled")).ToString("MMM dd, yyyy") %></td>
                    <td>
                        <span class='badge-ca <%# GetSeverityBadge(Eval("Severity").ToString()) %>'>
                            <%# Eval("Severity") %>
                        </span>
                    </td>
                    <td>
                        <span class='badge-ca <%# GetStatusBadge(Eval("Status").ToString()) %>'>
                            <%# Eval("Status") %>
                        </span>
                    </td>
                    <td class="small text-secondary"><%# Eval("AssignedOfficer") %></td>
                    <td>
                        <asp:LinkButton ID="lnkViewDetails" runat="server" CommandName="ViewDetails" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-dark py-0 px-2" style="font-size: 0.75rem;" CausesValidation="false">Details</asp:LinkButton>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="p-5 text-center text-muted">
            <div class="mb-2 text-muted">
                <svg class="ca-icon ca-icon-2xl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13c0 1.1.9 2 2 2Z"/></svg>
            </div>
            <h5>No incident cases found matching criteria.</h5>
            <p class="small">Submit an official incident report to begin tracking.</p>
            <a href="ReportIncident.aspx" class="btn-ca btn-ca-primary btn-sm mt-2">Submit New Report</a>
        </asp:Panel>
    </div>

    <!-- Case Details Modal -->
    <!-- Compact Case Details Modal (520-560px, 85vh max, internal scroll) -->
    <asp:Panel ID="pnlCaseModal" runat="server" Visible="false" CssClass="modal fade show d-block" style="background: rgba(15,23,42,0.6);" TabIndex="-1">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 540px; margin: 1.75rem auto;">
            <div class="modal-content shadow-lg border-0" style="max-height: 85vh; border-radius: 12px; overflow: hidden; display: flex; flex-direction: column;">
                <div class="modal-header bg-light py-2.5 px-3 border-bottom d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle font-monospace fw-bold" style="font-size: 0.75rem;">CASE #<asp:Literal ID="litModalCaseId" runat="server" /></span>
                        <h6 class="modal-title fw-bold text-dark mb-0 fs-6">Incident Case Details</h6>
                    </div>
                    <asp:LinkButton ID="btnCloseModalX" runat="server" CssClass="btn-close" OnClick="btnCloseModal_Click" CausesValidation="false" aria-label="Close"></asp:LinkButton>
                </div>
                <div class="modal-body p-3" style="overflow-y: auto; max-height: calc(85vh - 120px);">
                    <div class="row g-2 mb-2.5">
                        <div class="col-6">
                            <label class="text-muted fw-bold" style="font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.05em;">Incident Type</label>
                            <div class="fw-bold text-dark fs-6"><asp:Literal ID="litModalType" runat="server" /></div>
                        </div>
                        <div class="col-6">
                            <label class="text-muted fw-bold" style="font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.05em;">Location</label>
                            <div class="text-dark small d-flex align-items-center gap-1.5 mt-0.5">
                                <svg class="ca-icon ca-icon-xs text-danger" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                                <span class="fw-semibold"><asp:Literal ID="litModalLocation" runat="server" /></span>
                            </div>
                        </div>
                    </div>

                    <div class="row g-2 mb-2.5 p-2.5 bg-light rounded-3 border">
                        <div class="col-6">
                            <label class="text-muted fw-bold" style="font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.05em;">Severity Level</label>
                            <div class="mt-0.5"><asp:Literal ID="litModalSeverity" runat="server" /></div>
                        </div>
                        <div class="col-6">
                            <label class="text-muted fw-bold" style="font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.05em;">Current Status</label>
                            <div class="mt-0.5"><asp:Literal ID="litModalStatus" runat="server" /></div>
                        </div>
                    </div>

                    <div class="mb-2.5">
                        <label class="text-muted fw-bold" style="font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.05em;">Assigned Dispatch Officer</label>
                        <div class="fw-semibold text-dark small d-flex align-items-center gap-1.5 mt-0.5">
                            <svg class="ca-icon ca-icon-sm text-primary" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            <span><asp:Literal ID="litModalOfficer" runat="server" /></span>
                        </div>
                    </div>

                    <div class="mb-2.5">
                        <label class="text-muted fw-bold" style="font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.05em;">Incident Description</label>
                        <div class="p-2.5 bg-white rounded-3 border small text-dark mt-0.5" style="line-height: 1.5; white-space: pre-wrap;"><asp:Literal ID="litModalDesc" runat="server" /></div>
                    </div>

                    <asp:Panel ID="pnlEvidence" runat="server" Visible="false" CssClass="mb-1">
                        <label class="text-muted fw-bold" style="font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.05em;">Evidence File</label>
                        <div class="small mt-1 d-flex align-items-center gap-2">
                            <span class="badge bg-light text-primary border py-1.5 px-2.5 d-inline-flex align-items-center gap-1.5 font-monospace" style="font-size: 0.75rem;">
                                <svg class="ca-icon ca-icon-xs text-primary" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m21.44 11.05-9.19 9.19a6 6 0 0 1-8.49-8.49l8.57-8.57A4 4 0 1 1 18 8.84l-8.59 8.57a2 2 0 0 1-2.83-2.83l8.49-8.48"/></svg>
                                <asp:Literal ID="litModalEvidence" runat="server" />
                            </span>
                        </div>
                    </asp:Panel>
                </div>
                <div class="modal-footer py-2 px-3 bg-light border-top d-flex justify-content-end">
                    <asp:Button ID="btnCloseModal" runat="server" Text="Close Window" CssClass="btn-ca btn-ca-outline btn-sm px-3" OnClick="btnCloseModal_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
