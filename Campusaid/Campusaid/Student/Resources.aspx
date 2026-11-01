<%@ Page Title="Resources Directory" Language="C#" MasterPageFile="~/MasterPages/Student.Master" AutoEventWireup="true" CodeBehind="Resources.aspx.cs" Inherits="Campusaid.Student.Resources" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Campus Safety Directory</h1>
    <p>Instant access to key emergency services, administrative clinics, and safety resources.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Search Bar (Matching Figma Page 10) -->
    <div class="card-ca p-3 mb-4">
        <div class="row g-2 align-items-center">
            <div class="col-md-9">
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0 text-muted">
                        <svg class="ca-icon ca-icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                    </span>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-start-0" placeholder="Search directory by service name, keyword, or division..."></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3 d-flex gap-2">
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-ca btn-ca-primary flex-grow-1" OnClick="btnSearch_Click" CausesValidation="false" />
                <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn-ca btn-ca-outline" OnClick="btnReset_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

    <!-- Active Search Filter Banner -->
    <asp:Panel ID="pnlFilterNotice" runat="server" Visible="false" CssClass="alert alert-light border py-2 px-3 small d-flex justify-content-between align-items-center mb-3">
        <span>Showing results matching "<strong class="text-primary"><asp:Literal ID="litFilterQuery" runat="server" /></strong>"</span>
        <asp:LinkButton ID="lnkClearFilter" runat="server" CssClass="text-danger small fw-bold text-decoration-none" OnClick="btnReset_Click" CausesValidation="false">Clear Filter</asp:LinkButton>
    </asp:Panel>

    <!-- Resources Cards Grid -->
    <div class="row g-3">
        <asp:Repeater ID="rptResources" runat="server">
            <ItemTemplate>
                <div class="col-12 col-md-6 col-lg-4">
                    <div class="card-ca p-3 h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="badge bg-light text-dark border fw-bold" style="font-size: 0.68rem;"><%# Eval("Category") %></span>
                                <span class="badge bg-secondary text-white" style="font-size: 0.68rem;"><%# Eval("Extension") %></span>
                            </div>
                            <h5 class="fw-bold text-dark mb-1 fs-6"><%# Eval("Name") %></h5>
                            <div class="fw-bold text-primary mb-2 d-flex align-items-center gap-1.5" style="font-size: 0.9rem;">
                                <svg class="ca-icon ca-icon-sm text-primary" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                                <span><%# Eval("Phone") %></span>
                            </div>
                            <p class="small text-muted mb-1.5 d-flex align-items-center gap-1.5">
                                <svg class="ca-icon ca-icon-xs text-muted" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                                <span><strong>Location:</strong> <%# Eval("Location") %></span>
                            </p>
                            <p class="small text-muted mb-2 d-flex align-items-center gap-1.5">
                                <svg class="ca-icon ca-icon-xs text-muted" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                <span><strong>Hours:</strong> <%# Eval("OperatingHours") %></span>
                            </p>
                            <p class="small text-secondary mb-3" style="font-size: 0.8rem; line-height: 1.45;">
                                <%# Eval("Description") %>
                            </p>
                        </div>

                        <!-- Action Buttons: Call & Locate (Matching Figma Page 10) -->
                        <div class="d-flex gap-2 pt-2 border-top">
                            <a href='<%# "tel:" + Eval("Phone").ToString().Replace(" ", "").Replace("-", "") %>' class="btn-ca btn-ca-danger btn-sm flex-grow-1">
                                <svg class="ca-icon ca-icon-xs" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                                Call
                            </a>
                            <button type="button" class="btn-ca btn-ca-outline btn-sm flex-grow-1"
                                    data-name='<%# Eval("Name") %>'
                                    data-location='<%# Eval("Location") %>'
                                    onclick="showLocateModal(this.getAttribute('data-name'), this.getAttribute('data-location'))">
                                <svg class="ca-icon ca-icon-xs" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                                Locate
                            </button>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- Empty State when no resources match search -->
    <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="card-ca p-4 text-center text-muted my-3">
        <div class="mb-2">
            <svg class="ca-icon ca-icon-xl text-muted" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
        </div>
        <h5 class="fw-bold text-dark fs-6">No campus resources found</h5>
        <p class="small text-secondary mb-2">No directory entries matched your search query. Try searching with different keywords.</p>
        <asp:LinkButton ID="lnkResetEmpty" runat="server" CssClass="btn-ca btn-ca-outline btn-sm" OnClick="btnReset_Click" CausesValidation="false">Reset Search</asp:LinkButton>
    </asp:Panel>

    <!-- Campus Resource Location Modal -->
    <div class="modal fade" id="locateModal" tabindex="-1" aria-labelledby="locateModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-ca-compact">
            <div class="modal-content shadow" style="max-height: 85vh; border-radius: 12px; overflow: hidden;">
                <div class="modal-header bg-light py-2 px-3">
                    <h5 class="modal-title fw-bold fs-6 d-flex align-items-center" id="locateModalLabel">
                        <svg class="ca-icon ca-icon-sm text-primary me-2" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                        <span id="modalResourceName">Resource Location</span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-3" style="overflow-y: auto;">
                    <div class="p-2.5 bg-light rounded-3 border mb-3">
                        <div class="small text-muted mb-0.5">Campus Facility Location:</div>
                        <div class="fw-bold text-dark" id="modalResourceLocation"></div>
                    </div>
                    <div class="p-3 border rounded-3 bg-white text-center">
                        <svg class="ca-icon ca-icon-lg text-primary mb-2" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="3 6 9 3 15 6 21 3 21 18 15 21 9 18 3 21"/><line x1="9" y1="3" x2="9" y2="18"/><line x1="15" y1="6" x2="15" y2="21"/></svg>
                        <div class="fw-bold text-dark fs-6">Interactive Campus Wayfinding</div>
                        <div class="small text-muted mt-1">Direct pedestrian route mapped from Central Student Quad to this destination.</div>
                    </div>
                </div>
                <div class="modal-footer py-2 px-3">
                    <button type="button" class="btn-ca btn-ca-outline btn-sm" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn-ca btn-ca-primary btn-sm" data-bs-dismiss="modal">Open Full Map</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
