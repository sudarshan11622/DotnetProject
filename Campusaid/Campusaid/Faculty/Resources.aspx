<%@ Page Title="Faculty Safety Resources" Language="C#" MasterPageFile="~/MasterPages/Faculty.Master" AutoEventWireup="true" CodeBehind="Resources.aspx.cs" Inherits="Campusaid.Faculty.Resources" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitleContent" runat="server">
    <h1>Faculty Safety Resource Directory</h1>
    <p>Protocols, emergency contacts, clinic operations, and building map grids.</p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row g-4">
        <!-- Left Column: Hotlines & Emergency Protocols -->
        <div class="col-lg-7">
            <!-- Crisis & Emergency Contact Lines (Matching Figma Page 19) -->
            <div class="card-ca mb-4">
                <div class="card-title-ca mb-3">
                    <span>Crisis & Emergency Contact Lines</span>
                    <span class="badge bg-danger text-white">24/7 PRIORITY</span>
                </div>

                <div class="quick-dial-card mb-3 p-3 rounded-3 border d-flex justify-content-between align-items-center bg-light">
                    <div>
                        <div class="quick-dial-name fw-bold text-dark">Campus Security</div>
                        <div class="quick-dial-desc small text-muted">Main campus physical security dispatched 24/7.</div>
                        <div class="quick-dial-phone font-monospace fw-bold text-danger mt-1 small">+91 98765 43210</div>
                    </div>
                    <a href="tel:+919876543210" class="btn-ca btn-ca-danger btn-sm px-3 text-decoration-none">Call</a>
                </div>

                <div class="quick-dial-card mb-0 p-3 rounded-3 border d-flex justify-content-between align-items-center bg-light">
                    <div>
                        <div class="quick-dial-name fw-bold text-dark">Health Services</div>
                        <div class="quick-dial-desc small text-muted">On-duty physicians, first aid, and psychiatric clinic.</div>
                        <div class="quick-dial-phone font-monospace fw-bold text-primary mt-1 small">+91 98765 43211</div>
                    </div>
                    <a href="tel:+919876543211" class="btn-ca btn-ca-blue btn-sm px-3 text-decoration-none">Call</a>
                </div>
            </div>

            <!-- Emergency Protocols Accordion (Matching Figma Page 19) -->
            <div class="card-ca">
                <div class="card-title-ca mb-3">
                    <span>Emergency Protocols Accordion</span>
                </div>

                <div class="accordion" id="accordionProtocols">
                    <!-- Protocol 1 -->
                    <div class="accordion-item mb-2 border rounded-3 overflow-hidden">
                        <h2 class="accordion-header" id="headingOne">
                            <button class="accordion-button fw-bold text-dark d-flex align-items-center gap-2" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true">
                                <svg class="ca-icon ca-icon-sm text-primary flex-shrink-0" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 2v7.31L4.15 19.3a2 2 0 0 0 1.7 2.7h12.3a2 2 0 0 0 1.7-2.7L14 9.31V2"/></svg>
                                <span>Chemical Spills in Laboratory Areas</span>
                            </button>
                        </h2>
                        <div id="collapseOne" class="accordion-collapse collapse show" data-bs-parent="#accordionProtocols">
                            <div class="accordion-body small text-secondary">
                                Evacuate classroom immediate zone, switch on localized exhaust hoods if stable, call Facilities Hazmat at ext 4455. Do not attempt neutralisation without Level B gear.
                            </div>
                        </div>
                    </div>

                    <!-- Protocol 2 -->
                    <div class="accordion-item mb-2 border rounded-3 overflow-hidden">
                        <h2 class="accordion-header" id="headingTwo">
                            <button class="accordion-button collapsed fw-bold text-dark d-flex align-items-center gap-2" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo">
                                <svg class="ca-icon ca-icon-sm text-danger flex-shrink-0" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M7 12a5 5 0 0 1 10 0v4H7v-4z"/><path d="M5 20h14"/><path d="M12 4V2"/><path d="M4 4l2 2"/><path d="M20 4l-2 2"/></svg>
                                <span>Active Intruder on Campus</span>
                            </button>
                        </h2>
                        <div id="collapseTwo" class="accordion-collapse collapse" data-bs-parent="#accordionProtocols">
                            <div class="accordion-body small text-secondary">
                                Lock classroom doors immediately, extinguish lights, silence mobile devices, barricade entry doors with heavy desks, and stay out of window sightlines until all-clear broadcast.
                            </div>
                        </div>
                    </div>

                    <!-- Protocol 3 -->
                    <div class="accordion-item border rounded-3 overflow-hidden">
                        <h2 class="accordion-header" id="headingThree">
                            <button class="accordion-button collapsed fw-bold text-dark d-flex align-items-center gap-2" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree">
                                <svg class="ca-icon ca-icon-sm text-warning flex-shrink-0" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
                                <span>Power Grid &amp; Substation Failure</span>
                            </button>
                        </h2>
                        <div id="collapseThree" class="accordion-collapse collapse" data-bs-parent="#accordionProtocols">
                            <div class="accordion-body small text-secondary">
                                Switch off heavy equipment in physics/chemistry laboratories. Ensure emergency hallway lighting batteries engage, and guide students toward main lighted exits.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column: Building Evacuation Maps (Matching Figma Page 19) -->
        <div class="col-lg-5">
            <div class="card-ca h-100">
                <div class="card-title-ca mb-3">
                    <span>Building Evacuation Maps</span>
                </div>

                <div class="p-3 bg-light rounded-3 border mb-3 text-center">
                    <div class="fw-bold text-dark mb-1">Campus Evacuation Routes Grid</div>
                    <div class="small text-muted mb-3">
                        Updated January 2026. Map showcases localized assembly points for all Sectors.
                    </div>

                    <!-- Schematic Preview of Sectors -->
                    <div class="p-3 bg-white rounded border mb-3 text-center">
                        <div class="row g-2 text-center small fw-bold">
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light text-primary">
                                    Sector A (Admin)<br />
                                    <span class="text-muted fw-normal" style="font-size: 0.7rem;">Assembly: Quad Flagpole</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light text-danger">
                                    Sector B (Labs)<br />
                                    <span class="text-muted fw-normal" style="font-size: 0.7rem;">Assembly: South Lawn</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light text-success">
                                    Sector C (Tech)<br />
                                    <span class="text-muted fw-normal" style="font-size: 0.7rem;">Assembly: East Parking</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light text-warning">
                                    Sector D (Depot)<br />
                                    <span class="text-muted fw-normal" style="font-size: 0.7rem;">Assembly: Sports Track</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <asp:LinkButton ID="btnDownloadMap" runat="server" CssClass="btn-ca btn-ca-primary w-100 d-inline-flex align-items-center justify-content-center gap-2 py-2" OnClick="btnDownloadMap_Click" CausesValidation="false">
                        <svg class="ca-icon ca-icon-sm" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                        <span>Download High-Res Map</span>
                    </asp:LinkButton>
                </div>

                <!-- Downloadable Protocol Documents -->
                <h6 class="fw-bold text-dark mt-4 mb-2">Downloadable Protocol Documents</h6>
                <div class="list-group">
                    <asp:Repeater ID="rptProtocols" runat="server">
                        <ItemTemplate>
                            <div class="list-group-item d-flex justify-content-between align-items-center p-2.5">
                                <div>
                                    <div class="fw-bold small text-dark"><%# Eval("Title") %></div>
                                    <div class="text-muted" style="font-size: 0.7rem;"><%# Eval("Format") %> &bull; Updated <%# Eval("LastUpdated") %></div>
                                </div>
                                <asp:Button ID="btnDlDoc" runat="server" Text="Download" CssClass="btn btn-sm btn-outline-dark py-0 px-2" style="font-size: 0.75rem;" CommandArgument='<%# Eval("Title") %>' OnClick="btnDownloadDoc_Click" CausesValidation="false" />
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
