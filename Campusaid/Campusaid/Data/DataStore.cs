using System;
using System.Collections.Generic;
using System.Linq;
using Campusaid.Models;

namespace Campusaid.Data
{
    public class AlertEventArgs : EventArgs
    {
        public EmergencyAlert Alert { get; set; }
        public AlertEventArgs(EmergencyAlert alert) { Alert = alert; }
    }

    public class IncidentEventArgs : EventArgs
    {
        public IncidentReport Report { get; set; }
        public IncidentEventArgs(IncidentReport report) { Report = report; }
    }

    public delegate void AlertBroadcastEventHandler(object sender, AlertEventArgs e);
    public delegate void IncidentFiledEventHandler(object sender, IncidentEventArgs e);
    public delegate void AuditLoggedEventHandler(string action, string user, string details);
    public delegate void StatusChangedEventHandler(string entityType, int entityId, string oldStatus, string newStatus);

    public static class DataStore
    {
        private static readonly object _syncRoot = new object();

        public static List<User> Users { get; private set; }
        public static List<IncidentReport> IncidentReports { get; private set; }
        public static List<EmergencyResource> EmergencyResources { get; private set; }
        public static List<EmergencyAlert> EmergencyAlerts { get; private set; }
        public static List<EmergencyContact> EmergencyContacts { get; private set; }
        public static List<ProtocolDocument> ProtocolDocuments { get; private set; }
        public static List<Announcement> Announcements { get; private set; }
        public static List<AuditLog> AuditLogs { get; private set; }
        public static List<EmergencyEvent> EmergencyEvents { get; private set; }
        public static SystemSettings Settings { get; private set; }

        // Delegates and Events
        public static event AlertBroadcastEventHandler OnAlertBroadcast;
        public static event IncidentFiledEventHandler OnIncidentFiled;
        public static event AuditLoggedEventHandler OnAuditLogged;
        public static event StatusChangedEventHandler OnStatusChanged;

        static DataStore()
        {
            InitializeData();

            // Wire internal event reactions
            OnAlertBroadcast += (sender, e) =>
            {
                LogAudit("Alert Broadcasted", e.Alert.CreatedBy ?? "System", $"Title: {e.Alert.Title} [{e.Alert.Severity}]");
            };

            OnIncidentFiled += (sender, e) =>
            {
                LogAudit("Incident Submitted", e.Report.ReporterName ?? "Anonymous", $"Case: {e.Report.CaseNumber} - {e.Report.IncidentType} ({e.Report.Severity})");
            };

            OnStatusChanged += (type, id, oldStatus, newStatus) =>
            {
                LogAudit("Status Changed", "System Dispatch", $"{type} #{id} status updated from {oldStatus} to {newStatus}");
            };
        }

        public static void InitializeData()
        {
            lock (_syncRoot)
            {
                Settings = new SystemSettings();

                // 1. Predefined Demo Users
                Users = new List<User>
                {
                    new User
                    {
                        Id = 1,
                        FullName = "Bokul Bormon",
                        Email = "bokul@gmail.com",
                        Password = "Bokul@123",
                        Role = "Student",
                        Department = "Computer Science",
                        IdentifierNumber = "2024-8941",
                        Phone = "+91 98765 43210",
                        IsActive = true,
                        LastLogin = DateTime.Now.AddMinutes(-12)
                    },
                    new User
                    {
                        Id = 2,
                        FullName = "Prof. Manab Roy",
                        Email = "manab@gmail.com",
                        Password = "Manab@123",
                        Role = "Faculty",
                        Department = "Chemistry Department",
                        IdentifierNumber = "F-2840",
                        OfficeLocation = "Sector B, Building 3 - Room 204",
                        SafetyTitle = "Senior Instructor — CERTIFIED MARSHAL",
                        Phone = "+91 98765 43210",
                        IsActive = true,
                        LastLogin = DateTime.Now.AddHours(-1)
                    },
                    new User
                    {
                        Id = 3,
                        FullName = "Sudarshan Bhul",
                        Email = "sudarshan@gmail.com",
                        Password = "Sudarshan@123",
                        Role = "Admin",
                        Department = "Campus Safety Administration",
                        IdentifierNumber = "ADM-001",
                        SafetyTitle = "System Administrator",
                        Phone = "+91 98765 91110",
                        IsActive = true,
                        LastLogin = DateTime.Now
                    },
                    new User
                    {
                        Id = 4,
                        FullName = "Nandan Kumar",
                        Email = "nandankumar@gmail.com",
                        Password = "User@123",
                        Role = "Student",
                        Department = "Bio-Engineering",
                        IdentifierNumber = "2024-7721",
                        Phone = "+91 98765 11223",
                        IsActive = true,
                        LastLogin = DateTime.Now.AddDays(-2)
                    },
                    new User
                    {
                        Id = 5,
                        FullName = "Dr. S. Jenkins",
                        Email = "sjenkins@university.edu",
                        Password = "User@123",
                        Role = "Faculty",
                        Department = "Computer Science",
                        IdentifierNumber = "F-1902",
                        OfficeLocation = "Sector C, Tech Block - Room 301",
                        Phone = "+91 98765 01902",
                        IsActive = true,
                        LastLogin = DateTime.Now.AddHours(-3)
                    },
                    new User
                    {
                        Id = 6,
                        FullName = "Prof. Robert Chen",
                        Email = "rchen@university.edu",
                        Password = "User@123",
                        Role = "Faculty",
                        Department = "Chemical Engineering",
                        IdentifierNumber = "F-3109",
                        OfficeLocation = "Sector B, Lab Annex 101",
                        Phone = "+91 98765 88990",
                        IsActive = true,
                        LastLogin = DateTime.Now.AddDays(-1)
                    },
                    new User
                    {
                        Id = 7,
                        FullName = "Sopnoo Roy",
                        Email = "mvance@university.edu",
                        Password = "User@123",
                        Role = "Staff",
                        Department = "Campus Facilities",
                        IdentifierNumber = "STF-4412",
                        OfficeLocation = "Sector D, Operations Depot",
                        Phone = "+91 98765 66778",
                        IsActive = false,
                        LastLogin = DateTime.Now.AddDays(-5)
                    }
                };

                // 2. Incident Reports
                IncidentReports = new List<IncidentReport>
                {
                    new IncidentReport
                    {
                        Id = 1,
                        CaseNumber = "CASE-9841",
                        ReporterName = "Bokul Bormon",
                        ReporterEmail = "bokul@gmail.com",
                        ReporterRole = "Student",
                        IncidentType = "Medical Assistance",
                        Location = "Science Lab B, Rm 302",
                        Description = "Chemical splash in Chemistry Lab Room 302. EMT Unit 2 dispatched immediately. First aid applied.",
                        Severity = "Critical",
                        Status = "Resolved",
                        DateFiled = DateTime.Now.AddDays(-2),
                        AssignedOfficer = "Sgt. Miller (EMT-2)",
                        AffectedCount = 2,
                        EmergencyOverride = true
                    },
                    new IncidentReport
                    {
                        Id = 2,
                        CaseNumber = "CASE-9824",
                        ReporterName = "Nandan Kumar",
                        ReporterEmail = "nandankumar@gmail.com",
                        ReporterRole = "Student",
                        IncidentType = "Suspicious Activity",
                        Location = "Student Union Quad",
                        Description = "Unattended luggage found next to the central fountain. Security officers deployed to cordon area.",
                        Severity = "Medium",
                        Status = "Dispatching",
                        DateFiled = DateTime.Now.AddDays(-5),
                        AssignedOfficer = "Officer Davis",
                        AffectedCount = 0
                    },
                    new IncidentReport
                    {
                        Id = 3,
                        CaseNumber = "CASE-9799",
                        ReporterName = "Prof. Manab Roy",
                        ReporterEmail = "manab@gmail.com",
                        ReporterRole = "Faculty",
                        IncidentType = "Facility Hazard",
                        Location = "Tech Library Room 400",
                        Description = "Power outage and panel sparking. Power delivery systems currently operating on backup batteries.",
                        Severity = "Minor",
                        Status = "Resolved",
                        DateFiled = DateTime.Now.AddDays(-10),
                        AssignedOfficer = "Officer Martinez",
                        AffectedCount = 10
                    },
                    new IncidentReport
                    {
                        Id = 4,
                        CaseNumber = "CASE-9755",
                        ReporterName = "Bokul Bormon",
                        ReporterEmail = "bokul@gmail.com",
                        ReporterRole = "Student",
                        IncidentType = "Harassment Claim",
                        Location = "North Quad Dormitory Gate",
                        Description = "Unregistered visitors trespassing dormitory compound after curfews. Security dispatched.",
                        Severity = "Critical",
                        Status = "Resolved",
                        DateFiled = DateTime.Now.AddDays(-18),
                        AssignedOfficer = "Sgt. Miller (EMT-2)",
                        AffectedCount = 1
                    },
                    new IncidentReport
                    {
                        Id = 5,
                        CaseNumber = "CASE-1023",
                        ReporterName = "Prof. Manab Roy",
                        ReporterEmail = "manab@gmail.com",
                        ReporterRole = "Faculty",
                        IncidentType = "Facility Hazard",
                        Location = "Library Basement Sub-floor",
                        Description = "Water pipe leakage causing minor subterranean flooding near electrical junction boxes.",
                        Severity = "High",
                        Status = "Investigating",
                        DateFiled = DateTime.Now.AddHours(-4),
                        AssignedOfficer = "Officer Davis",
                        AffectedCount = 0,
                        NotifyDepartment = true
                    },
                    new IncidentReport
                    {
                        Id = 6,
                        CaseNumber = "CASE-1024",
                        ReporterName = "Prof. Robert Chen",
                        ReporterEmail = "rchen@university.edu",
                        ReporterRole = "Faculty",
                        IncidentType = "Medical Emergency",
                        Location = "Sector B, Lab Room 402",
                        Description = "Secondary chemical pressure valve failed slightly, releasing minor gas irritants. Classroom evacuated.",
                        Severity = "Critical",
                        Status = "Dispatching",
                        DateFiled = DateTime.Now.AddMinutes(-30),
                        AssignedOfficer = "Sgt. Miller (EMT-2)",
                        AffectedCount = 2,
                        EmergencyOverride = true,
                        NotifyDepartment = true
                    },
                    new IncidentReport
                    {
                        Id = 7,
                        CaseNumber = "CASE-1022",
                        ReporterName = "Nandan Kumar",
                        ReporterEmail = "nandankumar@gmail.com",
                        ReporterRole = "Student",
                        IncidentType = "Security Threat",
                        Location = "West Parking Lot",
                        Description = "Vehicle lock tampered with in section 3B of student parking lot.",
                        Severity = "Routine",
                        Status = "Resolved",
                        DateFiled = DateTime.Now.AddDays(-1),
                        AssignedOfficer = "Officer Martinez",
                        AffectedCount = 0
                    }
                };

                // 3. Emergency Resources Directory
                EmergencyResources = new List<EmergencyResource>
                {
                    new EmergencyResource
                    {
                        Id = 1,
                        Name = "Campus Police Dispatch",
                        Category = "SECURITY",
                        Phone = "+91 98765 43210",
                        Extension = "EXT. 9111",
                        Location = "Sector A, Admin Building 1st Floor",
                        OperatingHours = "24/7 Dispatch",
                        Description = "Main campus physical security dispatched 24/7. Immediate emergency threat management, armed defense, and escort service."
                    },
                    new EmergencyResource
                    {
                        Id = 2,
                        Name = "Student Health Center",
                        Category = "CLINIC",
                        Phone = "+91 98765 43211",
                        Extension = "EXT. 2233",
                        Location = "Sector B, Wellness Wing",
                        OperatingHours = "08:00 AM - 18:00 PM",
                        Description = "On-duty physicians, first aid paramedics, triage care, vaccination clinics, and urgent health consultations."
                    },
                    new EmergencyResource
                    {
                        Id = 3,
                        Name = "Crisis Counseling & Wellness",
                        Category = "SUPPORT",
                        Phone = "+91 98765 43212",
                        Extension = "EXT. 4455",
                        Location = "Sector B, Wellness Wing Room 204",
                        OperatingHours = "24/7 Helpline",
                        Description = "Confidential crisis intervention, mental health stabilization, panic response, and anonymous counselor access."
                    },
                    new EmergencyResource
                    {
                        Id = 4,
                        Name = "Fire & Hazmat Safety Division",
                        Category = "FIRE",
                        Phone = "+91 98765 43213",
                        Extension = "EXT. 9113",
                        Location = "Sector D, Operations Depot",
                        OperatingHours = "08:00 AM - 17:00 PM (Emergency 24/7)",
                        Description = "Chemical spills, biological waste containment, fire extinguishers, and emergency evacuation drills."
                    },
                    new EmergencyResource
                    {
                        Id = 5,
                        Name = "Campus IT Security Team",
                        Category = "IT",
                        Phone = "+91 98765 43214",
                        Extension = "EXT. 4100",
                        Location = "Sector C, Tech Library Room 400",
                        OperatingHours = "09:00 AM - 17:00 PM",
                        Description = "Digital forensics, cyber intrusion response, campus-wide network lockdown, and server security outages."
                    },
                    new EmergencyResource
                    {
                        Id = 6,
                        Name = "Student Affairs & Title IX",
                        Category = "TITLE_IX",
                        Phone = "+91 98765 43215",
                        Extension = "EXT. 3300",
                        Location = "Sector A, Admin Building Room 302",
                        OperatingHours = "09:00 AM - 17:00 PM",
                        Description = "Equal access protection, harassment reporting, legal student advocacy, and institutional safety audits."
                    }
                };

                // 4. Campus Alerts
                EmergencyAlerts = new List<EmergencyAlert>
                {
                    new EmergencyAlert
                    {
                        Id = 1,
                        Title = "Active Shelter-In-Place: Sector B Wind Warning",
                        Message = "Severe wind speeds exceeding 55mph have breached safety standards. All students and personnel are directed to remain indoors. Avoid walkways near tall trees and lightweight structures.",
                        Severity = "Critical",
                        TargetAudience = "All Campus",
                        IssuingAuthority = "Campus Emergency Operations Center",
                        AffectedArea = "Main Quad, Sector B Labs",
                        IssuedDate = DateTime.Now.AddMinutes(-12),
                        IsActive = true,
                        CreatedBy = "Admin Sudarshan",
                        AcknowledgedUsers = new List<string>()
                    },
                    new EmergencyAlert
                    {
                        Id = 2,
                        Title = "Partial Power Grid Failure - Sector D",
                        Message = "Maintenance teams are resolving line disruptions in Sector D. Elevators in Science Block 3 are offline until grid backup systems fully sync. Please use stairwells.",
                        Severity = "Warning",
                        TargetAudience = "Students & Staff",
                        IssuingAuthority = "Campus Services & Operations Depot",
                        AffectedArea = "Sector D Engineering Depot & Science Block 3",
                        IssuedDate = DateTime.Now.AddHours(-2),
                        IsActive = true,
                        CreatedBy = "Admin Sudarshan",
                        AcknowledgedUsers = new List<string>()
                    },
                    new EmergencyAlert
                    {
                        Id = 3,
                        Title = "Routine Fire Drill Testing - Admin Area A",
                        Message = "Scheduled fire alarm diagnostics will occur tomorrow between 1:00 PM and 3:00 PM in Administration Block 1. Alarm triggers will sound momentarily but require no action.",
                        Severity = "Info",
                        TargetAudience = "Faculty & Staff",
                        IssuingAuthority = "Campus Security Command Division",
                        AffectedArea = "Sector A Admin Complex",
                        IssuedDate = DateTime.Now.AddDays(-1),
                        IsActive = true,
                        CreatedBy = "Chief Deputy",
                        AcknowledgedUsers = new List<string>()
                    },
                    new EmergencyAlert
                    {
                        Id = 4,
                        Title = "Scheduled Maintenance: Library Power Transition",
                        Message = "Backup power supply generators will kick in during a quick 10-minute panel transition. Expect light flickering in Tech Library Room 400.",
                        Severity = "Info",
                        TargetAudience = "All Campus",
                        IssuingAuthority = "Campus Facilities Wing",
                        AffectedArea = "Sector C Library",
                        IssuedDate = DateTime.Now.AddDays(-3),
                        IsActive = false,
                        CreatedBy = "Admin Sudarshan",
                        AcknowledgedUsers = new List<string>()
                    }
                };

                // 5. Emergency Contacts for Bokul Bormon
                EmergencyContacts = new List<EmergencyContact>
                {
                    new EmergencyContact
                    {
                        Id = 1,
                        StudentEmail = "bokul@gmail.com",
                        Name = "Jiten Bormon",
                        Phone = "+91 98765 01788",
                        Priority = "Primary Contact",
                        Relationship = "Father"
                    },
                    new EmergencyContact
                    {
                        Id = 2,
                        StudentEmail = "bokul@gmail.com",
                        Name = "Minu Rani",
                        Phone = "+91 98765 01789",
                        Priority = "Secondary Contact",
                        Relationship = "Mother"
                    }
                };

                // 6. Protocol Documents
                ProtocolDocuments = new List<ProtocolDocument>
                {
                    new ProtocolDocument
                    {
                        Id = 1,
                        Title = "Active Shooter Response Protocol",
                        CategoryTag = "CRITICAL",
                        LastUpdated = "Sep 12, 2024",
                        Format = "PDF (1.2MB)",
                        FilePath = "~/Assets/Docs/active-shooter.pdf",
                        Description = "Run, Hide, Fight directives, classroom barricade instructions, and emergency dispatch signaling guidelines."
                    },
                    new ProtocolDocument
                    {
                        Id = 2,
                        Title = "Chemical / Hazard Spill Emergency Guide",
                        CategoryTag = "HAZMAT",
                        LastUpdated = "Aug 30, 2024",
                        Format = "PDF (850KB)",
                        FilePath = "~/Assets/Docs/chemical-spill.pdf",
                        Description = "Containment procedures for volatile chemical reagents, laboratory gas shutoff valves, and PPE deployment."
                    },
                    new ProtocolDocument
                    {
                        Id = 3,
                        Title = "Campus Evacuation Routes & Assembly Grid",
                        CategoryTag = "FACILITY",
                        LastUpdated = "Jan 15, 2026",
                        Format = "PDF (2.4MB)",
                        FilePath = "~/Assets/Docs/campus-map.pdf",
                        Description = "Detailed floor plans showing primary and secondary fire escape routes, AED stations, and safe quad assembly points."
                    }
                };

                // 7. Announcements
                Announcements = new List<Announcement>
                {
                    new Announcement
                    {
                        Id = 1,
                        Title = "Influenza Vaccine Clinic open",
                        Category = "Health & Wellness Services",
                        TargetAudience = "All Campus",
                        Content = "Annual flu vaccination clinic is now open at the Student Health Center (Sector B). Free for all enrolled students and faculty members with valid university ID.",
                        PublishedDate = DateTime.Now.AddDays(-7),
                        Status = "Published",
                        Author = "Campus Health Center"
                    },
                    new Announcement
                    {
                        Id = 2,
                        Title = "Winter Safety Protocol Briefing Campus Security",
                        Category = "Campus Security",
                        TargetAudience = "Faculty & Staff",
                        Content = "Mandatory safety briefing for all departmental safety marshals on heater regulations, frost bite prevention, and winter road salt applications.",
                        PublishedDate = DateTime.Now.AddDays(-9),
                        Status = "Published",
                        Author = "Security Command"
                    },
                    new Announcement
                    {
                        Id = 3,
                        Title = "Building B Elevator Repairs",
                        Category = "Maintenance Updates",
                        TargetAudience = "Students",
                        Content = "The central elevator in Building B Science Block is undergoing hydraulic routine servicing. Please utilize the west stairwells through Friday.",
                        PublishedDate = DateTime.Now.AddDays(-12),
                        Status = "Published",
                        Author = "Facilities Wing"
                    },
                    new Announcement
                    {
                        Id = 4,
                        Title = "Counseling Support Hotlines (24/7 Free Access)",
                        Category = "Mental Health Support",
                        TargetAudience = "All Campus",
                        Content = "Mid-term examination stress management workshops and 24/7 confidential counseling services are accessible online or via telephone extension 4455.",
                        PublishedDate = DateTime.Now.AddDays(-16),
                        Status = "Draft",
                        Author = "Wellness Division"
                    },
                    new Announcement
                    {
                        Id = 5,
                        Title = "Monsoon Flash Flood Awareness & Precautions",
                        Category = "Weather Preparedness",
                        TargetAudience = "Staff",
                        Content = "Pre-monsoon subterranean drainage check and vehicle parking safety reminders for lower basement zones.",
                        PublishedDate = DateTime.Now.AddDays(-21),
                        Status = "Archived",
                        Author = "Disaster Mgmt"
                    }
                };

                // 8. Emergency Events
                EmergencyEvents = new List<EmergencyEvent>
                {
                    new EmergencyEvent
                    {
                        Id = 1,
                        InitiatedBy = "Bokul Bormon",
                        InitiatorEmail = "bokul@gmail.com",
                        InitiatorRole = "Student",
                        Timestamp = DateTime.Now.AddDays(-2),
                        LocationCoordinates = "University Quad, Building 4 - Room 102 (22.2587° N, 70.7963° E)",
                        Status = "RESOLVED",
                        Notes = "Student activated SOS button. Campus security responded in 4 minutes. Triage verified safe."
                    }
                };

                // 9. Audit Logs
                AuditLogs = new List<AuditLog>
                {
                    new AuditLog
                    {
                        Id = 1,
                        Action = "Admin Broad Alert Initiated",
                        Details = "Severe Weather warning sent to all campus sectors.",
                        User = "Sudarshan Bhul",
                        Timestamp = DateTime.Now.AddMinutes(-10)
                    },
                    new AuditLog
                    {
                        Id = 2,
                        Action = "Siren Hook test executed",
                        Details = "Emergency dispatcher connection verified successfully across audio horns.",
                        User = "Sudarshan Bhul",
                        Timestamp = DateTime.Now.AddHours(-1)
                    },
                    new AuditLog
                    {
                        Id = 3,
                        Action = "User Credentials Modified",
                        Details = "Robert Chen assigned Faculty role and Marshal credentials.",
                        User = "Sudarshan Bhul",
                        Timestamp = DateTime.Now.AddHours(-2)
                    },
                    new AuditLog
                    {
                        Id = 4,
                        Action = "System Config Updated",
                        Details = "SMS dispatcher provider rate rules and fallback voice numbers updated.",
                        User = "Sudarshan Bhul",
                        Timestamp = DateTime.Now.AddDays(-1)
                    }
                };
            }
        }

        // Public helper methods
        public static void LogAudit(string action, string user, string details)
        {
            lock (_syncRoot)
            {
                var log = new AuditLog
                {
                    Id = AuditLogs.Count > 0 ? AuditLogs.Max(x => x.Id) + 1 : 1,
                    Action = action,
                    User = user,
                    Details = details,
                    Timestamp = DateTime.Now
                };
                AuditLogs.Insert(0, log);
            }
            OnAuditLogged?.Invoke(action, user, details);
        }

        public static void BroadcastAlert(EmergencyAlert alert)
        {
            lock (_syncRoot)
            {
                alert.Id = EmergencyAlerts.Count > 0 ? EmergencyAlerts.Max(x => x.Id) + 1 : 1;
                alert.IssuedDate = DateTime.Now;
                alert.IsActive = true;
                EmergencyAlerts.Insert(0, alert);
            }

            OnAlertBroadcast?.Invoke(null, new AlertEventArgs(alert));
        }

        public static void AddIncidentReport(IncidentReport report)
        {
            lock (_syncRoot)
            {
                report.Id = IncidentReports.Count > 0 ? IncidentReports.Max(x => x.Id) + 1 : 1;
                report.DateFiled = DateTime.Now;
                if (string.IsNullOrEmpty(report.CaseNumber))
                {
                    report.CaseNumber = $"CASE-{9840 + report.Id}";
                }
                IncidentReports.Insert(0, report);
            }

            OnIncidentFiled?.Invoke(null, new IncidentEventArgs(report));
        }

        public static EmergencyEvent TriggerSOS(string userName, string userEmail, string role, string customLocation = null)
        {
            lock (_syncRoot)
            {
                var evt = new EmergencyEvent
                {
                    Id = EmergencyEvents.Count > 0 ? EmergencyEvents.Max(x => x.Id) + 1 : 1,
                    InitiatedBy = userName,
                    InitiatorEmail = userEmail,
                    InitiatorRole = role,
                    Timestamp = DateTime.Now,
                    LocationCoordinates = !string.IsNullOrEmpty(customLocation) ? customLocation : "University Quad, Building 4 - Room 102 (22.2587° N, 70.7963° E)",
                    Status = "ACTIVE DISPATCH",
                    Notes = "High priority SOS signal sent to Campus Police and Medical units."
                };
                EmergencyEvents.Insert(0, evt);

                LogAudit("SOS Signal Triggered", userName, $"Location: {evt.LocationCoordinates} | Role: {role}");
                return evt;
            }
        }

        public static void UpdateIncidentStatus(int id, string newStatus, string assignedOfficer = null)
        {
            lock (_syncRoot)
            {
                var report = IncidentReports.FirstOrDefault(r => r.Id == id);
                if (report != null)
                {
                    string oldStatus = report.Status;
                    report.Status = newStatus;
                    if (!string.IsNullOrEmpty(assignedOfficer))
                    {
                        report.AssignedOfficer = assignedOfficer;
                    }
                    OnStatusChanged?.Invoke("IncidentReport", id, oldStatus, newStatus);
                }
            }
        }
    }
}
