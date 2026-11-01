<%@ Page Title="Incident Records & Auditing" Language="C#" MasterPageFile="~/MasterPages/Faculty.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="Campusaid.Faculty.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Incident Records & Auditing</h1>
    <p>Review reported emergencies, status updates, and administrative assignments.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Notice Banner -->
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success d-flex align-items-center mb-4 p-3 rounded-3 shadow-sm">
        <span class="me-3 text-success d-flex align-items-center">
            <svg class="ca-icon ca-icon-lg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
        </span>
        <div>
            <div class="fw-bold">Faculty Incident Case Registered!</div>
            <div class="small">Case logged with immediate administrative priority and dispatch tracking.</div>
        </div>
    </asp:Panel>

    <!-- Top Controls: Database Tag, Filters, Export CSV (Matching Figma Page 18) -->
    <div class="card-ca p-3 mb-4">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
            <div class="d-flex align-items-center gap-2">
                <span class="fw-bold text-dark fs-6">Active Incident Database</span>
                <span class="badge bg-primary text-white" style="font-size: 0.7rem;">FACULTY ACCESS</span>
            </div>

            <div class="d-flex align-items-center gap-2 flex-wrap">
                <asp:Button ID="btnFilterAll" runat="server" Text="All" CssClass="btn btn-sm btn-outline-secondary" OnClick="btnFilterStatus_Click" CommandArgument="All" CausesValidation="false" />
                <asp:Button ID="btnFilterActive" runat="server" Text="Filter: Active" CssClass="btn btn-sm btn-dark" OnClick="btnFilterStatus_Click" CommandArgument="Active" CausesValidation="false" />
                <asp:Button ID="btnFilterResolved" runat="server" Text="Resolved" CssClass="btn btn-sm btn-outline-secondary" OnClick="btnFilterStatus_Click" CommandArgument="Resolved" CausesValidation="false" />
                
                <div class="input-group input-group-sm" style="max-width: 200px;">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search ID, reporter..."></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="Go" CssClass="btn btn-outline-dark" OnClick="btnSearch_Click" CausesValidation="false" />
                </div>

                <asp:Button ID="btnExportCsv" runat="server" Text="Export CSV" CssClass="btn-ca btn-ca-outline btn-sm" OnClick="btnExportCsv_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

    <!-- Incident Table (Matching Figma Page 18) -->
    <div class="table-ca-wrapper">
        <asp:Repeater ID="rptIncidents" runat="server" OnItemCommand="rptIncidents_ItemCommand">
            <HeaderTemplate>
                <table class="table-ca">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>REPORTER</th>
                            <th>TYPE</th>
                            <th>LOCATION</th>
                            <th>STATUS</th>
                            <th>SEVERITY</th>
                            <th>ASSIGNED TO</th>
                            <th>ACTION</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td class="fw-bold text-primary font-monospace">#<%# Eval("CaseNumber").ToString().Replace("CASE-", "") %></td>
                    <td class="fw-semibold text-dark"><%# Eval("ReporterName") %></td>
                    <td><%# Eval("IncidentType") %></td>
                    <td class="small text-muted"><%# Eval("Location") %></td>
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
                    <td>
                        <asp:LinkButton ID="lnkViewDetails" runat="server" CommandName="ViewDetails" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-dark py-0 px-2" style="font-size: 0.75rem;" CausesValidation="false">View</asp:LinkButton>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="p-5 text-center text-muted">
            <h5>No incident records found.</h5>
        </asp:Panel>
    </div>

    <!-- Incident Detail Modal -->
    <asp:Panel ID="pnlDetailModal" runat="server" Visible="false" CssClass="modal fade show d-block" style="background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(2px);" TabIndex="-1">
        <div class="modal-dialog modal-dialog-centered modal-ca-compact">
            <div class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-light py-2 px-3 border-bottom">
                    <h6 class="modal-title fw-bold text-dark mb-0 d-flex align-items-center gap-2">
                        <span>Incident Case #<asp:Literal ID="litModalCaseId" runat="server" /></span>
                    </h6>
                    <asp:LinkButton ID="btnCloseX" runat="server" CssClass="btn-close" OnClick="btnCloseModal_Click" CausesValidation="false" aria-label="Close"></asp:LinkButton>
                </div>
                <div class="modal-body modal-body-scroll p-3">
                    <div class="mb-2 p-2 bg-light rounded border">
                        <div class="text-muted small fw-bold" style="font-size: 0.72rem; text-transform: uppercase;">Reporter & Incident Type</div>
                        <div class="fw-bold text-dark fs-6 mt-0.5"><asp:Literal ID="litModalReporter" runat="server" /> &bull; <asp:Literal ID="litModalType" runat="server" /></div>
                        <div class="text-muted small d-flex align-items-center gap-1 mt-1">
                            <svg class="ca-icon ca-icon-xs text-muted" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                            <span class="fw-semibold text-secondary"><asp:Literal ID="litModalLocation" runat="server" /></span>
                        </div>
                    </div>

                    <div class="row g-2 mb-2">
                        <div class="col-6">
                            <div class="p-2 border rounded bg-white">
                                <div class="text-muted small fw-bold" style="font-size: 0.7rem; text-transform: uppercase;">Severity</div>
                                <div class="mt-1"><asp:Literal ID="litModalSeverity" runat="server" /></div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="p-2 border rounded bg-white">
                                <div class="text-muted small fw-bold" style="font-size: 0.7rem; text-transform: uppercase;">Status</div>
                                <div class="mt-1"><asp:Literal ID="litModalStatus" runat="server" /></div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-2 p-2 border rounded bg-white">
                        <div class="text-muted small fw-bold" style="font-size: 0.7rem; text-transform: uppercase;">Assigned Responder</div>
                        <div class="fw-semibold text-dark d-flex align-items-center gap-1 mt-1 small">
                            <svg class="ca-icon ca-icon-sm text-primary" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            <asp:Literal ID="litModalOfficer" runat="server" />
                        </div>
                    </div>

                    <div class="mb-1 p-2 border rounded bg-white">
                        <div class="text-muted small fw-bold mb-1" style="font-size: 0.7rem; text-transform: uppercase;">Situation Narrative</div>
                        <div class="p-2 bg-light rounded border-0 small text-dark" style="line-height: 1.45;"><asp:Literal ID="litModalDesc" runat="server" /></div>
                    </div>
                </div>
                <div class="modal-footer py-2 px-3 border-top bg-light">
                    <asp:Button ID="btnClose" runat="server" Text="Close Window" CssClass="btn btn-outline-secondary btn-sm px-3" OnClick="btnCloseModal_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
