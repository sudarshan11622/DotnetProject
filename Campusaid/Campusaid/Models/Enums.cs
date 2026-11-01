using System;

namespace Campusaid.Models
{
    public enum UserRole
    {
        Student,
        Faculty,
        Admin,
        Staff
    }

    public enum IncidentSeverity
    {
        Critical,
        Medium,
        Minor
    }

    public enum IncidentStatus
    {
        Submitted,
        Pending,
        Dispatching,
        Investigating,
        Resolved,
        Rejected
    }

    public enum AlertSeverity
    {
        Critical,
        Warning,
        Routine,
        Info
    }

    public enum AnnouncementStatus
    {
        Published,
        Draft,
        Archived
    }
}
