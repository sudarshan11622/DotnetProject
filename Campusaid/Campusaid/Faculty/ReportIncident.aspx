<%@ Page Title="Faculty Incident Report" Language="C#" MasterPageFile="~/MasterPages/Faculty.Master" AutoEventWireup="true" CodeBehind="ReportIncident.aspx.cs" Inherits="Campusaid.Faculty.ReportIncident" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Submit Incident Report</h1>
    <p>Report safety anomalies, classroom medical crises, or hazard breaches immediately.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="card-ca">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <h3 class="card-title-ca mb-0">FACULTY RISK INTAKE FORM</h3>
                    <span class="badge bg-danger text-white">RAPID DISPATCH READY</span>
                </div>

                <asp:ValidationSummary ID="valSummary" runat="server" CssClass="alert alert-danger py-2 small mb-3" HeaderText="Please address the following requirements:" ValidationGroup="vgFacultyReport" />

                <!-- Incident Type -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label-ca" for="ddlIncidentType">Incident Type <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlIncidentType" runat="server" CssClass="form-control-ca">
                            <asp:ListItem Value="">-- Select Incident Classification --</asp:ListItem>
                            <asp:ListItem Value="Medical Emergency">Medical Emergency</asp:ListItem>
                            <asp:ListItem Value="Fire/Hazard">Fire / Chemical Hazard</asp:ListItem>
                            <asp:ListItem Value="Security Threat">Security Threat</asp:ListItem>
                            <asp:ListItem Value="Natural Disaster">Natural Disaster / Structural Threat</asp:ListItem>
                            <asp:ListItem Value="Facility Hazard">Facility Hazard / Power Disruption</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvType" runat="server" ControlToValidate="ddlIncidentType" InitialValue="" ErrorMessage="Incident Classification is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgFacultyReport">* Type required</asp:RequiredFieldValidator>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label-ca" for="txtBuildingRoom">Building & Room Selector <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtBuildingRoom" runat="server" CssClass="form-control-ca" placeholder="e.g. Sector B, Science Block 3 - Lab 402"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvLocation" runat="server" ControlToValidate="txtBuildingRoom" ErrorMessage="Building & Room Location is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgFacultyReport">* Location required</asp:RequiredFieldValidator>
                    </div>
                </div>

                <!-- Affected Count -->
                <div class="mb-3">
                    <label class="form-label-ca" for="txtAffectedCount">Affected Students/Personnel Count</label>
                    <asp:TextBox ID="txtAffectedCount" runat="server" CssClass="form-control-ca" TextMode="Number" Text="1" min="0" max="500"></asp:TextBox>
                    <div class="text-muted small mt-1">Estimated number of individuals requiring medical evaluation or relocation.</div>
                </div>

                <!-- Detailed Description -->
                <div class="mb-4">
                    <label class="form-label-ca" for="txtDescription">Detailed Description of the Situation <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control-ca" TextMode="MultiLine" Rows="5" placeholder="Provide precise details: reagents, injuries, room clearance status, equipment involved..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDescription" runat="server" ControlToValidate="txtDescription" ErrorMessage="Detailed Description is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgFacultyReport">* Description required</asp:RequiredFieldValidator>
                </div>

                <!-- Faculty Special Checkboxes (Matching Figma Page 17) -->
                <div class="p-3 bg-light rounded-3 border mb-4">
                    <label class="ca-toggle-switch mb-3 p-2.5 bg-white rounded border d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-danger">Emergency Priority Override</div>
                            <div class="text-muted small">Bypasses normal intake queues for immediate dispatch alerts across campus safety radio channels.</div>
                        </div>
                        <span class="ca-toggle-track">
                            <asp:CheckBox ID="chkPriorityOverride" runat="server" />
                            <span class="ca-toggle-slider"></span>
                        </span>
                    </label>

                    <label class="ca-toggle-switch mb-0 p-2.5 bg-white rounded border d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-dark">Notify Department Administration</div>
                            <div class="text-muted small">Sends direct SMS alerts to the Dean and Department safety marshal.</div>
                        </div>
                        <span class="ca-toggle-track">
                            <asp:CheckBox ID="chkNotifyDept" runat="server" Checked="true" />
                            <span class="ca-toggle-slider"></span>
                        </span>
                    </label>
                </div>

                <!-- Action Buttons -->
                <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center gap-3 pt-3 border-top">
                    <asp:Button ID="btnDiscard" runat="server" Text="Discard Draft" CssClass="btn-ca btn-ca-outline w-100 w-sm-auto order-2 order-sm-1" OnClick="btnDiscard_Click" CausesValidation="false" />
                    <asp:Button ID="btnSubmitReport" runat="server" Text="Submit Report &amp; Alert Teams" CssClass="btn-ca btn-ca-danger px-4 py-2 w-100 w-sm-auto order-1 order-sm-2" OnClick="btnSubmitReport_Click" ValidationGroup="vgFacultyReport" CausesValidation="true" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
