<%@ Page Title="Report Incident" Language="C#" MasterPageFile="~/MasterPages/Student.Master" AutoEventWireup="true" CodeBehind="ReportIncident.aspx.cs" Inherits="Campusaid.Student.ReportIncident" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .severity-btn-group input[type="radio"] {
            display: none;
        }
        .severity-btn-group label {
            cursor: pointer;
            padding: 0.55rem 1.25rem;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 800;
            letter-spacing: 0.05em;
            border: 2px solid transparent;
            transition: all 0.15s;
        }
        .severity-crit {
            background-color: #fee2e2;
            color: #991b1b;
        }
        .severity-med {
            background-color: #fef3c7;
            color: #92400e;
        }
        .severity-min {
            background-color: #dbeafe;
            color: #1e40af;
        }
        .severity-btn-group input[type="radio"]:checked + label {
            box-shadow: 0 0 0 3px #0f172a;
            transform: scale(1.03);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Report Security or Safety Incident</h1>
    <p>File an official incident report. Information is shared directly with Campus Security.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="card-ca">
                <asp:ValidationSummary ID="valSummary" runat="server" CssClass="alert alert-danger py-2 small mb-3" HeaderText="Please resolve the following required fields:" ValidationGroup="vgIncident" />

                <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger py-2 small mb-3">
                    <asp:Literal ID="litAlertMsg" runat="server" />
                </asp:Panel>

                <!-- Incident Type -->
                <div class="mb-3">
                    <label class="form-label-ca" for="ddlIncidentType">Incident Type <span class="text-danger">*</span></label>
                    <asp:DropDownList ID="ddlIncidentType" runat="server" CssClass="form-control-ca">
                        <asp:ListItem Value="">-- Select Incident Type (e.g. Medical, Security) --</asp:ListItem>
                        <asp:ListItem Value="Medical Emergency">Medical Emergency</asp:ListItem>
                        <asp:ListItem Value="Security Threat">Security Threat</asp:ListItem>
                        <asp:ListItem Value="Fire/Hazard">Fire / Physical Hazard</asp:ListItem>
                        <asp:ListItem Value="Facility Hazard">Facility Hazard (Power / Water)</asp:ListItem>
                        <asp:ListItem Value="Natural Disaster">Natural Disaster / Severe Weather</asp:ListItem>
                        <asp:ListItem Value="Harassment Claim">Harassment or Campus Safety Concern</asp:ListItem>
                        <asp:ListItem Value="Other">Other Campus Anomaly</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvType" runat="server" ControlToValidate="ddlIncidentType" InitialValue="" ErrorMessage="Incident Type is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgIncident">* Please select incident type</asp:RequiredFieldValidator>
                </div>

                <!-- Incident Location -->
                <div class="mb-3">
                    <label class="form-label-ca" for="txtLocation">Incident Location <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control-ca" placeholder="Building name, floor, or outdoor landmark coordinates..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvLocation" runat="server" ControlToValidate="txtLocation" ErrorMessage="Location is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgIncident">* Incident location required</asp:RequiredFieldValidator>
                </div>

                <!-- Detailed Description -->
                <div class="mb-3">
                    <label class="form-label-ca" for="txtDescription">Detailed Description <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control-ca" TextMode="MultiLine" Rows="5" placeholder="Describe what happened, any persons involved, injuries, physical hazards, or immediate threats..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDescription" runat="server" ControlToValidate="txtDescription" ErrorMessage="Detailed Description is required." CssClass="val-error" Display="Dynamic" ValidationGroup="vgIncident">* Description required</asp:RequiredFieldValidator>
                </div>

                <!-- Severity Level Selector (Matching Figma Page 11) -->
                <div class="mb-4">
                    <label class="form-label-ca mb-2">Severity Level <span class="text-danger">*</span></label>
                    <div class="d-flex flex-wrap gap-2 severity-btn-group">
                        <div class="flex-grow-1 text-center">
                            <asp:RadioButton ID="rbCritical" runat="server" GroupName="grpSeverity" />
                            <label for="<%= rbCritical.ClientID %>" class="severity-crit d-block py-2">CRITICAL</label>
                        </div>
                        <div class="flex-grow-1 text-center">
                            <asp:RadioButton ID="rbMedium" runat="server" GroupName="grpSeverity" Checked="true" />
                            <label for="<%= rbMedium.ClientID %>" class="severity-med d-block py-2">MEDIUM</label>
                        </div>
                        <div class="flex-grow-1 text-center">
                            <asp:RadioButton ID="rbMinor" runat="server" GroupName="grpSeverity" />
                            <label for="<%= rbMinor.ClientID %>" class="severity-min d-block py-2">MINOR</label>
                        </div>
                    </div>
                </div>

                <!-- Evidence Upload -->
                <div class="mb-4 p-3 bg-light rounded-3 border">
                    <label class="form-label-ca mb-1" for="fuEvidence">Upload Photo / Evidence</label>
                    <div class="text-muted small mb-2">JPEG, PNG, MP4 up to 25MB (Evidence files are verified and logged)</div>
                    <asp:FileUpload ID="fuEvidence" runat="server" CssClass="form-control" />
                    <asp:CustomValidator ID="cvFileUpload" runat="server" ErrorMessage="File must be an image (.jpg, .jpeg, .png) or video (.mp4) and under 25MB." OnServerValidate="cvFileUpload_ServerValidate" CssClass="val-error" Display="Dynamic" ValidationGroup="vgIncident"></asp:CustomValidator>
                </div>

                <!-- Submit Anonymously Checkbox -->
                <div class="mb-4 p-3 bg-light rounded-3 border">
                    <label class="ca-toggle-switch p-2 bg-white rounded border d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-dark">Submit Anonymously</div>
                            <div class="text-muted small">Hide your personal profile details from dispatcher logs</div>
                        </div>
                        <span class="ca-toggle-track">
                            <asp:CheckBox ID="chkAnonymous" runat="server" />
                            <span class="ca-toggle-slider"></span>
                        </span>
                    </label>
                </div>

                <!-- Submit / Cancel Buttons -->
                <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center gap-3 pt-3 border-top">
                    <a href="Dashboard.aspx" class="btn-ca btn-ca-outline w-100 w-sm-auto text-center order-2 order-sm-1">Cancel</a>
                    <asp:Button ID="btnSubmitReport" runat="server" Text="Submit Official Report" CssClass="btn-ca btn-ca-primary px-4 py-2 w-100 w-sm-auto order-1 order-sm-2" OnClick="btnSubmitReport_Click" ValidationGroup="vgIncident" CausesValidation="true" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
