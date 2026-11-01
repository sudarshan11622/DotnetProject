<%@ Page Title="Emergency Resources & Protocols" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Resources.aspx.cs" Inherits="Campusaid.Admin.Resources" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Emergency Resources & Protocols</h1>
    <p>Update listings, modify contact extensions, and manage vital health and safety documents.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Notice -->
    <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="alert alert-success py-2 small mb-4">
        <asp:Literal ID="litNotice" runat="server" />
    </asp:Panel>

    <!-- SECTION 1: Emergency Resource Listings (Matching Figma Page 23) -->
    <div class="card-ca mb-4">
        <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
            <div>
                <h3 class="card-title-ca mb-0">Emergency Resource Listings</h3>
                <div class="small text-muted">Immediate crisis directories published across Student and Faculty portals.</div>
            </div>
            <asp:Button ID="btnOpenAddResource" runat="server" Text="+ Add New Resource" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnOpenAddResource_Click" CausesValidation="false" />
        </div>

        <div class="row g-3">
            <asp:Repeater ID="rptResources" runat="server" OnItemCommand="rptResources_ItemCommand">
                <ItemTemplate>
                    <div class="col-12 col-md-6 col-lg-4">
                        <div class="p-3 bg-light rounded-3 border h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="badge bg-secondary text-white" style="font-size: 0.68rem;"><%# Eval("Category") %></span>
                                    <span class="badge bg-danger text-white" style="font-size: 0.68rem;"><%# Eval("Extension") %></span>
                                </div>
                                <h5 class="fw-bold text-dark mb-1 fs-6"><%# Eval("Name") %></h5>
                                <div class="text-primary fw-bold small mb-2 d-flex align-items-center gap-1.5">
                                    <svg class="ca-icon ca-icon-xs text-primary" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                                    <span><%# Eval("Phone") %></span>
                                </div>
                                <p class="small text-secondary mb-3"><%# Eval("Description") %></p>
                            </div>
                            <div class="d-flex gap-2 pt-2 border-top">
                                <asp:LinkButton ID="btnEditRes" runat="server" CommandName="EditRes" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-dark flex-grow-1" CausesValidation="false">Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnDeleteRes" runat="server" CommandName="DeleteRes" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger" CausesValidation="false" OnClientClick="return confirm('Delete this emergency directory resource?');">Delete</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <!-- SECTION 2: Emergency Response Protocols (Matching Figma Page 23) -->
    <div class="card-ca">
        <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
            <div>
                <h3 class="card-title-ca mb-0">Emergency Response Protocols</h3>
                <div class="small text-muted">Regulatory safety documentation, chemical guides, and evacuation diagrams.</div>
            </div>
            <asp:Button ID="btnOpenUploadProtocol" runat="server" Text="Upload Protocol Document" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnOpenUploadProtocol_Click" CausesValidation="false" />
        </div>

        <div class="table-ca-wrapper">
            <asp:Repeater ID="rptProtocols" runat="server" OnItemCommand="rptProtocols_ItemCommand">
                <HeaderTemplate>
                    <table class="table-ca">
                        <thead>
                            <tr>
                                <th>Protocol Title</th>
                                <th>Category Tag</th>
                                <th>Last Updated</th>
                                <th>Format</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td class="fw-bold text-dark"><%# Eval("Title") %></td>
                        <td>
                            <span class='badge-ca <%# GetTagBadge(Eval("CategoryTag").ToString()) %>'>
                                <%# Eval("CategoryTag") %>
                            </span>
                        </td>
                        <td class="small text-muted"><%# Eval("LastUpdated") %></td>
                        <td class="small text-secondary"><%# Eval("Format") %></td>
                        <td>
                            <div class="d-flex gap-1">
                                <asp:LinkButton ID="btnEditDoc" runat="server" CommandName="EditDoc" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-dark py-0 px-2" style="font-size: 0.75rem;" CausesValidation="false">Edit</asp:LinkButton>
                                <asp:LinkButton ID="btnDlDoc" runat="server" CommandName="DownloadDoc" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-primary py-0 px-2" style="font-size: 0.75rem;" CausesValidation="false">Download</asp:LinkButton>
                                <asp:LinkButton ID="btnDelDoc" runat="server" CommandName="DeleteDoc" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger py-0 px-2" style="font-size: 0.75rem;" CausesValidation="false" OnClientClick="return confirm('Remove protocol document?');">Delete</asp:LinkButton>
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

    <!-- Add/Edit Resource Modal -->
    <asp:Panel ID="pnlResourceModal" runat="server" Visible="false" CssClass="modal fade show d-block" style="background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(2px);" TabIndex="-1">
        <div class="modal-dialog modal-dialog-centered modal-ca-compact">
            <div class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-light py-2 px-3 border-bottom">
                    <h6 class="modal-title fw-bold text-dark mb-0"><asp:Literal ID="litResourceModalTitle" runat="server">Add Emergency Resource</asp:Literal></h6>
                    <asp:LinkButton ID="btnCloseResX" runat="server" CssClass="btn-close" OnClick="btnCloseModal_Click" CausesValidation="false" aria-label="Close"></asp:LinkButton>
                </div>
                <div class="modal-body modal-body-scroll p-3">
                    <asp:ValidationSummary ID="valRes" runat="server" CssClass="alert alert-danger py-1 small mb-2" ValidationGroup="vgResource" />
                    <asp:HiddenField ID="hfResourceId" runat="server" Value="0" />

                    <div class="mb-2">
                        <label class="form-label-ca" for="txtResName">Resource Name</label>
                        <asp:TextBox ID="txtResName" runat="server" CssClass="form-control-ca" placeholder="e.g. Student Health Center"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvResName" runat="server" ControlToValidate="txtResName" ErrorMessage="Resource Name required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgResource">* Required</asp:RequiredFieldValidator>
                    </div>

                    <div class="row g-2 mb-2">
                        <div class="col-6">
                            <label class="form-label-ca" for="ddlResCategory">Category</label>
                            <asp:DropDownList ID="ddlResCategory" runat="server" CssClass="form-control-ca">
                                <asp:ListItem Value="CLINIC">CLINIC</asp:ListItem>
                                <asp:ListItem Value="SECURITY">SECURITY</asp:ListItem>
                                <asp:ListItem Value="SUPPORT">SUPPORT</asp:ListItem>
                                <asp:ListItem Value="FIRE">FIRE / HAZMAT</asp:ListItem>
                                <asp:ListItem Value="IT">IT SECURITY</asp:ListItem>
                                <asp:ListItem Value="TITLE_IX">TITLE IX</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-6">
                            <label class="form-label-ca" for="txtResExt">Extension</label>
                            <asp:TextBox ID="txtResExt" runat="server" CssClass="form-control-ca" placeholder="EXT. 2233"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvResExt" runat="server" ControlToValidate="txtResExt" ErrorMessage="Extension required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgResource">* Required</asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <div class="row g-2 mb-2">
                        <div class="col-6">
                            <label class="form-label-ca" for="txtResPhone">Phone Number</label>
                            <asp:TextBox ID="txtResPhone" runat="server" CssClass="form-control-ca" placeholder="+91 98765 43211"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvResPhone" runat="server" ControlToValidate="txtResPhone" ErrorMessage="Phone required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgResource">* Required</asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revResPhone" runat="server" ControlToValidate="txtResPhone" ValidationGroup="vgResource" ValidationExpression="^\+91[\s\-]?[6-9]\d{4}[\s\-]?[0-9]{5}$|^\+91[\s\-]?[6-9]\d{9}$" ErrorMessage="Please enter a valid Indian mobile number (+91 98765 43210)." CssClass="val-error" Display="Dynamic">* Valid +91 Indian format required</asp:RegularExpressionValidator>
                        </div>
                        <div class="col-6">
                            <label class="form-label-ca" for="txtResLocation">Location</label>
                            <asp:TextBox ID="txtResLocation" runat="server" CssClass="form-control-ca" placeholder="Sector B, Wellness Wing"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-2">
                        <label class="form-label-ca" for="txtResHours">Operating Hours</label>
                        <asp:TextBox ID="txtResHours" runat="server" CssClass="form-control-ca" placeholder="08:00 AM - 18:00 PM"></asp:TextBox>
                    </div>

                    <div class="mb-2">
                        <label class="form-label-ca" for="txtResDesc">Description</label>
                        <asp:TextBox ID="txtResDesc" runat="server" CssClass="form-control-ca" TextMode="MultiLine" Rows="3" placeholder="Primary care, urgent medical attention..."></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer py-2 px-3 border-top bg-light">
                    <asp:Button ID="btnCancelRes" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary btn-sm" OnClick="btnCloseModal_Click" CausesValidation="false" />
                    <asp:Button ID="btnSaveResource" runat="server" Text="Save Resource" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnSaveResource_Click" ValidationGroup="vgResource" CausesValidation="true" />
                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- Upload/Edit Protocol Modal -->
    <asp:Panel ID="pnlProtocolModal" runat="server" Visible="false" CssClass="modal fade show d-block" style="background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(2px);" TabIndex="-1">
        <div class="modal-dialog modal-dialog-centered modal-ca-compact">
            <div class="modal-content shadow-lg border-0 rounded-3">
                <div class="modal-header bg-light py-2 px-3 border-bottom">
                    <h6 class="modal-title fw-bold text-dark mb-0"><asp:Literal ID="litProtoModalTitle" runat="server">Upload Protocol Document</asp:Literal></h6>
                    <asp:LinkButton ID="btnCloseProtoX" runat="server" CssClass="btn-close" OnClick="btnCloseModal_Click" CausesValidation="false" aria-label="Close"></asp:LinkButton>
                </div>
                <div class="modal-body modal-body-scroll p-3">
                    <asp:ValidationSummary ID="valProto" runat="server" CssClass="alert alert-danger py-1 small mb-2" ValidationGroup="vgProtocol" />
                    <asp:HiddenField ID="hfProtocolId" runat="server" Value="0" />

                    <div class="mb-2">
                        <label class="form-label-ca" for="txtProtoTitle">Protocol Title</label>
                        <asp:TextBox ID="txtProtoTitle" runat="server" CssClass="form-control-ca" placeholder="e.g. Active Shooter Response"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvProtoTitle" runat="server" ControlToValidate="txtProtoTitle" ErrorMessage="Protocol title required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgProtocol">* Required</asp:RequiredFieldValidator>
                    </div>

                    <div class="row g-2 mb-2">
                        <div class="col-6">
                            <label class="form-label-ca" for="ddlProtoCategory">Category Tag</label>
                            <asp:DropDownList ID="ddlProtoCategory" runat="server" CssClass="form-control-ca">
                                <asp:ListItem Value="CRITICAL">CRITICAL</asp:ListItem>
                                <asp:ListItem Value="HAZMAT">HAZMAT</asp:ListItem>
                                <asp:ListItem Value="FACILITY">FACILITY</asp:ListItem>
                                <asp:ListItem Value="MEDICAL">MEDICAL</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-6">
                            <label class="form-label-ca" for="txtProtoFormat">Format / File Size</label>
                            <asp:TextBox ID="txtProtoFormat" runat="server" CssClass="form-control-ca" Text="PDF (1.2MB)"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-2">
                        <label class="form-label-ca" for="fuProtoDoc">Select PDF Document</label>
                        <asp:FileUpload ID="fuProtoDoc" runat="server" CssClass="form-control form-control-sm" />
                    </div>

                    <div class="mb-2">
                        <label class="form-label-ca" for="txtProtoDesc">Description & Directives</label>
                        <asp:TextBox ID="txtProtoDesc" runat="server" CssClass="form-control-ca" TextMode="MultiLine" Rows="3" placeholder="Summary of safety protocols..."></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer py-2 px-3 border-top bg-light">
                    <asp:Button ID="btnCancelProto" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary btn-sm" OnClick="btnCloseModal_Click" CausesValidation="false" />
                    <asp:Button ID="btnSaveProtocol" runat="server" Text="Save Protocol" CssClass="btn-ca btn-ca-primary btn-sm" OnClick="btnSaveProtocol_Click" ValidationGroup="vgProtocol" CausesValidation="true" />
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
