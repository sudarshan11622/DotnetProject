<%@ Page Title="Alerts & Notifications" Language="C#" MasterPageFile="~/MasterPages/Student.Master" AutoEventWireup="true" CodeBehind="Alerts.aspx.cs" Inherits="Campusaid.Student.Alerts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Campus Safety Alerts & Notifications</h1>
    <p>Real-time alerts published by University Dispatch and Administration officials.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Filter Tabs (Matching Figma Page 13) -->
    <div class="card-ca p-3 mb-4">
        <div class="d-flex gap-2 flex-wrap">
            <asp:Button ID="btnTabAll" runat="server" Text="All Alerts" CssClass="btn btn-sm btn-dark" OnClick="btnTab_Click" CommandArgument="All" CausesValidation="false" />
            <asp:Button ID="btnTabCritical" runat="server" Text="Critical" CssClass="btn btn-sm btn-outline-danger" OnClick="btnTab_Click" CommandArgument="Critical" CausesValidation="false" />
            <asp:Button ID="btnTabWarning" runat="server" Text="Warnings" CssClass="btn btn-sm btn-outline-warning" OnClick="btnTab_Click" CommandArgument="Warning" CausesValidation="false" />
            <asp:Button ID="btnTabInfo" runat="server" Text="General Info" CssClass="btn btn-sm btn-outline-primary" OnClick="btnTab_Click" CommandArgument="Info" CausesValidation="false" />
        </div>
    </div>

    <!-- Feedback Message on Acknowledge -->
    <asp:Panel ID="pnlAckMsg" runat="server" Visible="false" CssClass="alert alert-success py-2 small mb-3">
        <asp:Literal ID="litAckMsg" runat="server" />
    </asp:Panel>

    <!-- Alerts List (Matching Figma Page 13) -->
    <div class="row g-3">
        <asp:Repeater ID="rptAlerts" runat="server" OnItemCommand="rptAlerts_ItemCommand">
            <ItemTemplate>
                <div class="col-12">
                    <div class="card-ca p-4 mb-2">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div>
                                <span class='badge-ca <%# GetSeverityBadge(Eval("Severity").ToString()) %> me-2'>
                                    <%# Eval("Severity") %>
                                </span>
                                <span class="small text-muted fw-semibold">
                                    <%# ((DateTime)Eval("IssuedDate")).ToString("MMM dd, yyyy, hh:mm tt") %>
                                </span>
                            </div>
                            <span class="badge bg-light text-secondary border d-inline-flex align-items-center gap-1">
                                <svg class="ca-icon ca-icon-xs text-muted" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="2" width="16" height="20" rx="2" ry="2"/><path d="M9 22v-4h6v4"/><path d="M8 6h.01"/><path d="M16 6h.01"/><path d="M12 6h.01"/><path d="M12 10h.01"/><path d="M12 14h.01"/><path d="M16 10h.01"/><path d="M16 14h.01"/><path d="M8 10h.01"/><path d="M8 14h.01"/></svg>
                                <%# Eval("IssuingAuthority") %>
                            </span>
                        </div>

                        <h4 class="fw-bold text-dark mb-2"><%# Eval("Title") %></h4>
                        <p class="text-secondary mb-3"><%# Eval("Message") %></p>

                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="small text-muted d-inline-flex align-items-center gap-1.5">
                                <svg class="ca-icon ca-icon-xs text-danger" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                                <span><strong>Affected Area:</strong> <%# Eval("AffectedArea") %></span>
                            </span>
                            <div>
                                <asp:PlaceHolder ID="phAckBtn" runat="server" Visible='<%# !IsAcknowledged((System.Collections.Generic.List<string>)Eval("AcknowledgedUsers")) %>'>
                                    <asp:Button ID="btnAcknowledge" runat="server" Text="Acknowledge Read" CommandName="Ack" CommandArgument='<%# Eval("Id") %>' CssClass="btn-ca btn-ca-primary btn-sm" CausesValidation="false" />
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="phAckDone" runat="server" Visible='<%# IsAcknowledged((System.Collections.Generic.List<string>)Eval("AcknowledgedUsers")) %>'>
                                    <span class="badge bg-success-subtle text-success border border-success px-3 py-2 fw-bold d-inline-flex align-items-center gap-1" style="font-size: 0.8rem;">
                                        <svg class="ca-icon ca-icon-xs text-success" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                                        Acknowledged
                                    </span>
                                </asp:PlaceHolder>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoAlerts" runat="server" Visible="false" CssClass="p-5 text-center text-muted">
            <div class="mb-2 text-muted">
                <svg class="ca-icon ca-icon-2xl" width="42" height="42" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg>
            </div>
            <h5>No alerts found in this category.</h5>
            <p class="small">Campus status is currently safe and operating under normal protocols.</p>
        </asp:Panel>
    </div>
</asp:Content>
