using System;

namespace Campusaid.Models
{
    public class IncidentReport
    {
        public int Id { get; set; }
        public string CaseNumber { get; set; } // e.g. CASE-9841
        public string ReporterName { get; set; }
        public string ReporterEmail { get; set; }
        public string ReporterRole { get; set; } // Student, Faculty, Staff, Anonymous
        public string IncidentType { get; set; } // Medical Emergency, Security Threat, Fire/Hazard, Natural Disaster, Facility Hazard, Other
        public string Location { get; set; }
        public string Description { get; set; }
        public string Severity { get; set; } // Critical, High, Medium, Minor, Routine
        public string Status { get; set; } // Submitted, Pending, Dispatching, Investigating, Resolved, Rejected
        public DateTime DateFiled { get; set; }
        public string AssignedOfficer { get; set; } // Sgt. Miller (EMT-2), Officer Davis, Officer Martinez
        public string EvidenceFileName { get; set; }
        public bool IsAnonymous { get; set; }
        public int AffectedCount { get; set; }
        public bool EmergencyOverride { get; set; }
        public bool NotifyDepartment { get; set; }

        public IncidentReport()
        {
            DateFiled = DateTime.Now;
            Status = "Submitted";
            AssignedOfficer = "Unassigned";
            Severity = "Medium";
        }
    }
}
