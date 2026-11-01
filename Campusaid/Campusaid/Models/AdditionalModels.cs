using System;

namespace Campusaid.Models
{
    public class EmergencyResource
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Category { get; set; } // CLINIC, SECURITY, SUPPORT, FIRE, IT, TITLE_IX
        public string Phone { get; set; }
        public string Extension { get; set; }
        public string Location { get; set; }
        public string OperatingHours { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }

        public EmergencyResource()
        {
            IsActive = true;
        }
    }

    public class EmergencyAlert
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public string Severity { get; set; } // CRITICAL, WARNING, INFO, ROUTINE
        public string TargetAudience { get; set; } // All Campus, Students, Faculty, Staff
        public string IssuingAuthority { get; set; }
        public string AffectedArea { get; set; }
        public DateTime IssuedDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsScheduled { get; set; }
        public DateTime? ScheduledDate { get; set; }
        public string CreatedBy { get; set; }
        public System.Collections.Generic.List<string> AcknowledgedUsers { get; set; }

        public EmergencyAlert()
        {
            IssuedDate = DateTime.Now;
            IsActive = true;
            AcknowledgedUsers = new System.Collections.Generic.List<string>();
        }
    }

    public class EmergencyContact
    {
        public int Id { get; set; }
        public string StudentEmail { get; set; }
        public string Name { get; set; }
        public string Phone { get; set; }
        public string Priority { get; set; } // Primary Contact, Secondary Contact
        public string Relationship { get; set; }
    }

    public class ProtocolDocument
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string CategoryTag { get; set; } // CRITICAL, HAZMAT, FACILITY, MEDICAL
        public string LastUpdated { get; set; }
        public string Format { get; set; } // PDF (1.2MB)
        public string FilePath { get; set; }
        public string Description { get; set; }
    }

    public class Announcement
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Category { get; set; }
        public string TargetAudience { get; set; }
        public string Content { get; set; }
        public string AttachmentName { get; set; }
        public DateTime PublishedDate { get; set; }
        public string Status { get; set; } // Published, Draft, Archived
        public string Author { get; set; }

        public Announcement()
        {
            PublishedDate = DateTime.Now;
            Status = "Published";
        }
    }

    public class AuditLog
    {
        public int Id { get; set; }
        public string Action { get; set; }
        public string Details { get; set; }
        public string User { get; set; }
        public DateTime Timestamp { get; set; }

        public AuditLog()
        {
            Timestamp = DateTime.Now;
        }
    }

    public class SystemSettings
    {
        public string AppName { get; set; }
        public string InstitutionName { get; set; }
        public string EmergencyDesk { get; set; }
        public string EmergencyExtension { get; set; }
        public bool EnableSmsAlerts { get; set; }
        public bool EnablePushWarnings { get; set; }
        public bool EnableSirenSync { get; set; }

        public SystemSettings()
        {
            AppName = "CampusAid - CEARD Portal";
            InstitutionName = "RK University, Rajkot Gujarat";
            EmergencyDesk = "Campus Safety Dispatch Main desk - Ext. 9111";
            EmergencyExtension = "EXT. 9111";
            EnableSmsAlerts = true;
            EnablePushWarnings = true;
            EnableSirenSync = false;
        }
    }

    public class EmergencyEvent
    {
        public int Id { get; set; }
        public string InitiatedBy { get; set; }
        public string InitiatorEmail { get; set; }
        public string InitiatorRole { get; set; }
        public DateTime Timestamp { get; set; }
        public string LocationCoordinates { get; set; }
        public string Status { get; set; } // ACTIVE DISPATCH, RESOLVED, CANCELLED
        public string Notes { get; set; }

        public EmergencyEvent()
        {
            Timestamp = DateTime.Now;
            Status = "ACTIVE DISPATCH";
            LocationCoordinates = "University Quad, Building 4 - Room 102";
        }
    }
}
