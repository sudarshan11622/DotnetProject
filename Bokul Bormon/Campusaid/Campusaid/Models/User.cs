using System;

namespace Campusaid.Models
{
    public class User
    {
        public int Id { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string Role { get; set; } // "Student", "Faculty", "Admin", "Staff"
        public string Department { get; set; }
        public string IdentifierNumber { get; set; } // Student ID or Faculty ID
        public string Phone { get; set; }
        public bool IsActive { get; set; }
        public DateTime LastLogin { get; set; }
        public string OfficeLocation { get; set; }
        public string SafetyTitle { get; set; }
        
        // Notification preferences
        public bool PrefSms { get; set; }
        public bool PrefPush { get; set; }
        public bool PrefVoice { get; set; }
        public bool PrefEmail { get; set; }

        public User()
        {
            IsActive = true;
            LastLogin = DateTime.Now;
            PrefSms = true;
            PrefPush = true;
            PrefVoice = false;
            PrefEmail = true;
        }
    }
}
