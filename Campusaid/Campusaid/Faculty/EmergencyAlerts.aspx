<%@ Page Title="Broadcast Emergency Alerts" Language="C#" MasterPageFile="~/MasterPages/Faculty.Master" AutoEventWireup="true" CodeBehind="EmergencyAlerts.aspx.cs" Inherits="Campusaid.Faculty.EmergencyAlerts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Broadcast Emergency Alerts</h1>
    <p>Acknowledge, monitor, and configure system-wide safety notifications.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Notice Banner -->
    <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="alert alert-success py-2 small mb-4">
        <asp:Literal ID="litNotice" runat="server" />
    </asp:Panel>

    <!-- Search and Filter Bar (Matching Figma Page 16) -->
    <div class="card-ca p-3 mb-4">
        <div class="row g-2 align-items-center">
            <div class="col-md-7">
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0 text-muted">
                        <svg class="ca-icon ca-icon-sm" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                    </span>
                    <asp:TextBox ID="txtSearchAlerts" runat="server" CssClass="form-control border-start-0" placeholder="Search active broadcast warnings, evacuations, or alerts..."></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:DropDownList ID="ddlFilterSeverity" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterSeverity_SelectedIndexChanged">
                    <asp:ListItem Value="All">Filter: All Alerts</asp:ListItem>
                    <asp:ListItem Value="Critical">Critical Level Only</asp:ListItem>
                    <asp:ListItem Value="Warning">Warning Level Only</asp:ListItem>
                    <asp:ListItem Value="Info">Info / Routine Only</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2 d-flex gap-1">
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-ca btn-ca-primary w-100" OnClick="btnSearch_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

    <!-- Alerts Feed (Matching Figma Page 16) -->
    <div class="row g-3">
        <asp:Repeater ID="rptAlerts" runat="server" OnItemCommand="rptAlerts_ItemCommand">
            <ItemTemplate>
                <div class="col-12">
                    <div class="card-ca p-4 mb-2">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="small text-muted d-inline-flex align-items-center gap-1.5">
                                <svg class="ca-icon ca-icon-xs text-muted" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                                <span>Issued: <strong><%# ((DateTime)Eval("IssuedDate")).ToString("MMM dd, hh:mm tt") %></strong> by <strong><%# Eval("IssuingAuthority") %></strong></span>
                            </span>
                            <span class='badge-ca <%# GetSeverityBadge(Eval("Severity").ToString()) %>'>
                                <%# Eval("Severity") %> LEVEL
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
                                    <asp:Button ID="btnAcknowledge" runat="server" Text="Acknowledge" CommandName="AckAlert" CommandArgument='<%# Eval("Id") %>' CssClass="btn-ca btn-ca-primary btn-sm" CausesValidation="false" />
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
            <h5>No broadcast alerts found.</h5>
        </asp:Panel>
    </div>
</asp:Content>
