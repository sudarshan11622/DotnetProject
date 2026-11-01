<%@ Page Title="Campus Announcements Manager" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Announcements.aspx.cs" Inherits="Campusaid.Admin.Announcements" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Campus Announcements Manager</h1>
    <p>Publish and update general news, health instructions, and non-emergency guidelines.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Notice -->
    <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="alert alert-success py-2 small mb-4">
        <asp:Literal ID="litNotice" runat="server" />
    </asp:Panel>

    <div class="row g-4">
        <!-- Left Column: Draft New Announcement (Matching Figma Page 26) -->
        <div class="col-lg-5">
            <div class="card-ca">
                <div class="card-title-ca mb-3 pb-2 border-bottom">
                    <span>Draft New Announcement</span>
                    <span class="badge bg-secondary text-white">COMMUNICATION</span>
                </div>

                <asp:ValidationSummary ID="valAnnounce" runat="server" CssClass="alert alert-danger py-1 small mb-3" ValidationGroup="vgAnnounce" />

                <!-- Title -->
                <div class="mb-3">
                    <label class="form-label-ca" for="txtAnnounceTitle">Announcement Title <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtAnnounceTitle" runat="server" CssClass="form-control-ca" placeholder="e.g. Health Center Influenza Vaccination"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtAnnounceTitle" ErrorMessage="Title is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgAnnounce">* Required</asp:RequiredFieldValidator>
                </div>

                <!-- Category -->
                <div class="mb-3">
                    <label class="form-label-ca" for="ddlAnnounceCategory">Category</label>
                    <asp:DropDownList ID="ddlAnnounceCategory" runat="server" CssClass="form-control-ca">
                        <asp:ListItem Value="Health & Wellness Services">Health & Wellness Services</asp:ListItem>
                        <asp:ListItem Value="Campus Security">Campus Security</asp:ListItem>
                        <asp:ListItem Value="Maintenance Updates">Maintenance Updates</asp:ListItem>
                        <asp:ListItem Value="Mental Health Support">Mental Health Support</asp:ListItem>
                        <asp:ListItem Value="Weather Preparedness">Weather Preparedness</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Target Audience -->
                <div class="mb-3">
                    <label class="form-label-ca" for="ddlAudience">Target Audience</label>
                    <asp:DropDownList ID="ddlAudience" runat="server" CssClass="form-control-ca">
                        <asp:ListItem Value="All Campus">All Campus</asp:ListItem>
                        <asp:ListItem Value="Students">Students Only</asp:ListItem>
                        <asp:ListItem Value="Faculty & Staff">Faculty & Staff</asp:ListItem>
                        <asp:ListItem Value="Staff Only">Staff Only</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Attachment (Optional) -->
                <div class="mb-3">
                    <label class="form-label-ca" for="fuAttachment">Attachment (Optional)</label>
                    <asp:FileUpload ID="fuAttachment" runat="server" CssClass="form-control form-control-sm" />
                    <div class="text-muted small mt-1">Upload relevant health PDFs or guides</div>
                </div>

                <!-- Content -->
                <div class="mb-4">
                    <label class="form-label-ca" for="txtContent">Announcement Content <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtContent" runat="server" CssClass="form-control-ca" TextMode="MultiLine" Rows="5" placeholder="Type announcement body here..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvContent" runat="server" ControlToValidate="txtContent" ErrorMessage="Content is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgAnnounce">* Required</asp:RequiredFieldValidator>
                </div>

                <!-- Buttons: Save Draft & Publish News (Matching Figma Page 26) -->
                <div class="d-flex gap-2">
                    <asp:Button ID="btnSaveDraft" runat="server" Text="Save Draft" CssClass="btn-ca btn-ca-outline flex-grow-1" OnClick="btnSaveDraft_Click" ValidationGroup="vgAnnounce" CausesValidation="true" />
                    <asp:Button ID="btnPublishNews" runat="server" Text="Publish News" CssClass="btn-ca btn-ca-primary flex-grow-1" OnClick="btnPublishNews_Click" ValidationGroup="vgAnnounce" CausesValidation="true" />
                </div>
            </div>
        </div>

        <!-- Right Column: Active Campus Announcements Table (Matching Figma Page 26) -->
        <div class="col-lg-7">
            <div class="card-ca">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <h3 class="card-title-ca mb-0">Active Campus Announcements</h3>
                </div>

                <div class="table-ca-wrapper">
                    <asp:Repeater ID="rptAnnouncements" runat="server" OnItemCommand="rptAnnouncements_ItemCommand">
                        <HeaderTemplate>
                            <table class="table-ca">
                                <thead>
                                    <tr>
                                        <th>Title</th>
                                        <th>Category</th>
                                        <th>Audience</th>
                                        <th>Published Date</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="fw-bold text-dark"><%# Eval("Title") %></td>
                                <td class="small text-secondary"><%# Eval("Category") %></td>
                                <td class="small text-muted"><%# Eval("TargetAudience") %></td>
                                <td class="small text-muted"><%# ((DateTime)Eval("PublishedDate")).ToString("MMM dd, yyyy") %></td>
                                <td>
                                    <span class='badge-ca <%# GetStatusBadge(Eval("Status").ToString()) %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </td>
                                <td>
                                    <div class="d-flex gap-1">
                                        <asp:LinkButton ID="btnArchive" runat="server" CommandName="Archive" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-secondary py-0 px-2" style="font-size: 0.72rem;" CausesValidation="false">
                                            <%# Eval("Status").ToString() == "Archived" ? "Restore" : "Archive" %>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger py-0 px-2" style="font-size: 0.72rem;" CausesValidation="false" OnClientClick="return confirm('Delete announcement?');">
                                            Delete
                                        </asp:LinkButton>
                                    </div>
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
