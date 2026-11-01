<%@ Page Title="SOS Emergency Assistance" Language="C#" MasterPageFile="~/MasterPages/Student.Master" AutoEventWireup="true" CodeBehind="SOS.aspx.cs" Inherits="Campusaid.Student.SOS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .pulse-ring {
            animation: pulse-border 1.8s infinite;
        }
        @keyframes pulse-border {
            0% { box-shadow: 0 0 0 0 rgba(220, 38, 38, 0.6); }
            70% { box-shadow: 0 0 0 25px rgba(220, 38, 38, 0); }
            100% { box-shadow: 0 0 0 0 rgba(220, 38, 38, 0); }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>SOS Emergency Assistance</h1>
    <p>Tap the button below to initiate emergency campus dispatch protocols.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Active SOS Dispatch Notification Banner -->
    <asp:Panel ID="pnlSosActive" runat="server" Visible="false" CssClass="alert alert-danger p-3 mb-4 rounded-3 border-danger shadow">
        <div class="d-flex align-items-center">
            <span class="me-3 text-danger d-flex align-items-center">
                <svg class="ca-icon ca-icon-2xl" width="42" height="42" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M7 12a5 5 0 0 1 10 0v4H7v-4z"/><path d="M5 20h14"/><path d="M12 4V2"/><path d="M4 4l2 2"/><path d="M20 4l-2 2"/></svg>
            </span>
            <div class="flex-grow-1">
                <div class="d-flex align-items-center gap-2">
                    <span class="badge-ca badge-critical">DISPATCH ACTIVE</span>
                    <span class="small text-muted"><asp:Literal ID="litSosTimestamp" runat="server" /></span>
                </div>
                <h5 class="fw-bold text-danger mt-1 mb-1">Campus Emergency Dispatch Protocol Initiated!</h5>
                <p class="small mb-0 text-dark">
                    Your distress signal and GPS coordinates (<strong class="text-danger"><asp:Literal ID="litActiveCoords" runat="server" /></strong>)
                    have been broadcast to the Campus Police Command Desk and Nearest Paramedics Unit.
                </p>
            </div>
            <div>
                <asp:Button ID="btnCancelSos" runat="server" Text="Cancel Distress" CssClass="btn btn-sm btn-outline-danger" OnClick="btnCancelSos_Click" CausesValidation="false" />
            </div>
        </div>
    </asp:Panel>

    <div class="row g-4 align-items-center">
        <!-- SOS Button & GPS Coordinates (Left Column) -->
        <div class="col-lg-7 text-center">
            <div class="card-ca p-4">
                <div class="sos-dial-container">
                    <div id="sosPressButton" class="sos-dial-btn pulse-ring">
                        <span class="sos-dial-title">SOS</span>
                        <span id="sosCountdown" class="sos-dial-subtitle">Press 3 Sec</span>
                    </div>

                    <!-- Hidden Button triggered by 3-second hold in Javascript -->
                    <asp:Button ID="btnHiddenSosSubmit" runat="server" ClientIDMode="Static" Style="display: none;" OnClick="btnSosTrigger_Click" CausesValidation="false" />
                    <asp:HiddenField ID="hfCurrentLocation" runat="server" ClientIDMode="Static" Value="University Quad, Building 4 - Room 102" />
                </div>

                <!-- Instant Trigger Fallback Button -->
                <div class="mb-3">
                    <asp:LinkButton ID="btnDirectSos" runat="server" CssClass="btn-ca btn-ca-danger px-4 py-2" OnClick="btnSosTrigger_Click" CausesValidation="false">
                        <svg class="ca-icon ca-icon-sm" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M7 12a5 5 0 0 1 10 0v4H7v-4z"/><path d="M5 20h14"/><path d="M12 4V2"/><path d="M4 4l2 2"/><path d="M20 4l-2 2"/></svg>
                        Click to Trigger Instant Dispatch
                    </asp:LinkButton>
                </div>

                <!-- GPS Location Information -->
                <div class="p-3 bg-light rounded-3 border d-inline-block text-start" style="max-width: 520px; width: 100%;">
                    <div class="d-flex align-items-center gap-2 text-danger fw-bold small text-uppercase mb-1">
                        <span class="status-dot" style="background-color: #dc2626; box-shadow: 0 0 0 2px rgba(220, 38, 38, 0.3);"></span>
                        Current GPS Coordinates Broadcasting
                    </div>
                    <div class="fw-bold text-dark fs-6">
                        <asp:Label ID="lblBroadcastingLocation" runat="server" Text="University Quad, Building 4 - Room 102"></asp:Label>
                    </div>
                    <div class="text-muted small mt-1">
                        GPS Sensor: 22.2587° N, 70.7963° E (Accuracy ±3m)
                    </div>

                    <!-- Manual override field -->
                    <div class="mt-2 pt-2 border-top">
                        <label class="form-label-ca mb-1 small" for="txtManualLocation">Manual Location Override (if not at current GPS):</label>
                        <div class="input-group input-group-sm">
                            <asp:TextBox ID="txtManualLocation" runat="server" CssClass="form-control" placeholder="e.g. Science Block 2, 3rd Floor Restroom"></asp:TextBox>
                            <asp:Button ID="btnUpdateLocation" runat="server" Text="Update" CssClass="btn btn-outline-secondary" OnClick="btnUpdateLocation_Click" CausesValidation="false" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Emergency Quick Dial Cards (Right Column - Matching Figma Page 9) -->
        <div class="col-lg-5">
            <div class="card-ca">
                <div class="card-title-ca mb-3">
                    <span>Emergency Quick Dial</span>
                    <span class="badge bg-danger text-white">EXT. 9111</span>
                </div>
                <p class="text-muted small mb-3">Direct hotline lines connect instantly to active response personnel.</p>

                <!-- Campus Police -->
                <div class="quick-dial-card">
                    <div>
                        <div class="quick-dial-name">Campus Police</div>
                        <div class="quick-dial-desc">For security, threat, safety breach</div>
                        <div class="quick-dial-phone">+91 98765 43210</div>
                    </div>
                    <a href="tel:+919876543210" class="btn-ca btn-ca-danger btn-sm px-3 text-decoration-none">
                        <svg class="ca-icon ca-icon-xs" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                        Call
                    </a>
                </div>

                <!-- Campus Health Center -->
                <div class="quick-dial-card">
                    <div>
                        <div class="quick-dial-name">Campus Health Center</div>
                        <div class="quick-dial-desc">Paramedics and on-duty doctors</div>
                        <div class="quick-dial-phone">+91 98765 43211</div>
                    </div>
                    <a href="tel:+919876543211" class="btn-ca btn-ca-blue btn-sm px-3 text-decoration-none">
                        <svg class="ca-icon ca-icon-xs" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                        Call
                    </a>
                </div>

                <!-- Fire & Hazmat Dispatch -->
                <div class="quick-dial-card">
                    <div>
                        <div class="quick-dial-name">Fire & Hazmat Dispatch</div>
                        <div class="quick-dial-desc">Chemical spills, fire hazards</div>
                        <div class="quick-dial-phone">+91 98765 43213</div>
                    </div>
                    <a href="tel:+919876543213" class="btn-ca btn-ca-danger btn-sm px-3 text-decoration-none">
                        <svg class="ca-icon ca-icon-xs" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                        Call
                    </a>
                </div>

                <!-- Crisis Counseling Center -->
                <div class="quick-dial-card mb-0">
                    <div>
                        <div class="quick-dial-name">Crisis Helpline (24/7)</div>
                        <div class="quick-dial-desc">Confidential psychological first aid</div>
                        <div class="quick-dial-phone">+91 98765 43212</div>
                    </div>
                    <a href="tel:+919876543212" class="btn-ca btn-ca-outline btn-sm px-3 text-decoration-none">
                        <svg class="ca-icon ca-icon-xs" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                        Call
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
