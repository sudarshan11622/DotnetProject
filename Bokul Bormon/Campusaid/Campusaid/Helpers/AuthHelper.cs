using System;
using System.Collections.Concurrent;
using System.Linq;
using System.Web;
using System.Web.UI;
using Campusaid.Data;
using Campusaid.Models;

namespace Campusaid.Helpers
{
    public class OtpRecord
    {
        public string Code { get; set; }
        public DateTime ExpiryTime { get; set; }
    }

    public static class AuthHelper
    {
        private static readonly ConcurrentDictionary<string, OtpRecord> _otpStore = new ConcurrentDictionary<string, OtpRecord>();

        public const string SessionUserId = "CA_UserId";
        public const string SessionUserEmail = "CA_UserEmail";
        public const string SessionUserName = "CA_UserName";
        public const string SessionUserRole = "CA_UserRole";
        public const string SessionUserDept = "CA_UserDept";
        public const string SessionUserIdentifier = "CA_UserIdentifier";

        public static bool IsAuthenticated
        {
            get
            {
                var session = HttpContext.Current?.Session;
                return session != null && session[SessionUserEmail] != null;
            }
        }

        public static string CurrentRole
        {
            get
            {
                var session = HttpContext.Current?.Session;
                return session?[SessionUserRole] as string ?? string.Empty;
            }
        }

        public static string CurrentEmail
        {
            get
            {
                var session = HttpContext.Current?.Session;
                return session?[SessionUserEmail] as string ?? string.Empty;
            }
        }

        public static string CurrentName
        {
            get
            {
                var session = HttpContext.Current?.Session;
                return session?[SessionUserName] as string ?? string.Empty;
            }
        }

        public static string CurrentIdentifier
        {
            get
            {
                var session = HttpContext.Current?.Session;
                return session?[SessionUserIdentifier] as string ?? string.Empty;
            }
        }

        public static User GetCurrentUser()
        {
            string email = CurrentEmail;
            if (string.IsNullOrEmpty(email)) return null;
            return DataStore.Users.FirstOrDefault(u => u.Email.Equals(email, StringComparison.OrdinalIgnoreCase));
        }

        public static bool Login(string email, string password, out string errorMessage)
        {
            errorMessage = string.Empty;
            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                errorMessage = "Please enter both university email and password.";
                return false;
            }

            var user = DataStore.Users.FirstOrDefault(u => u.Email.Equals(email.Trim(), StringComparison.OrdinalIgnoreCase));
            if (user == null)
            {
                errorMessage = "Invalid credentials. Account not found.";
                return false;
            }

            if (!user.IsActive)
            {
                errorMessage = "This account has been deactivated by Campus Security. Contact administrator.";
                return false;
            }

            if (user.Password != password.Trim())
            {
                errorMessage = "Incorrect password. Please try again.";
                return false;
            }

            // Set session
            var session = HttpContext.Current.Session;
            session[SessionUserId] = user.Id;
            session[SessionUserEmail] = user.Email;
            session[SessionUserName] = user.FullName;
            session[SessionUserRole] = user.Role;
            session[SessionUserDept] = user.Department;
            session[SessionUserIdentifier] = user.IdentifierNumber;

            user.LastLogin = DateTime.Now;
            DataStore.LogAudit("User Login", user.FullName, $"Role: {user.Role} logged in from browser.");
            return true;
        }

        public static void Logout()
        {
            var session = HttpContext.Current?.Session;
            if (session != null)
            {
                string name = session[SessionUserName] as string ?? "User";
                DataStore.LogAudit("User Logout", name, "Session ended successfully.");
                session.Clear();
                session.Abandon();
            }

            HttpContext.Current.Response.Redirect("~/Account/Login.aspx");
        }

        public static void RequireRole(Page page, string expectedRole)
        {
            if (!IsAuthenticated)
            {
                page.Response.Redirect("~/Account/Login.aspx?error=unauthorized");
                return;
            }

            string actualRole = CurrentRole;
            if (!actualRole.Equals(expectedRole, StringComparison.OrdinalIgnoreCase))
            {
                // Redirect user to their own correct portal
                if (actualRole.Equals("Student", StringComparison.OrdinalIgnoreCase))
                {
                    page.Response.Redirect("~/Student/Dashboard.aspx?error=role_denied");
                }
                else if (actualRole.Equals("Faculty", StringComparison.OrdinalIgnoreCase))
                {
                    page.Response.Redirect("~/Faculty/Dashboard.aspx?error=role_denied");
                }
                else if (actualRole.Equals("Admin", StringComparison.OrdinalIgnoreCase))
                {
                    page.Response.Redirect("~/Admin/Dashboard.aspx?error=role_denied");
                }
                else
                {
                    page.Response.Redirect("~/Account/Login.aspx?error=unknown_role");
                }
            }
        }

        // OTP Generation & Verification (60 seconds expiration demo)
        public static string GenerateOtp(string email)
        {
            var rnd = new Random();
            string code = rnd.Next(100000, 999999).ToString();
            var record = new OtpRecord
            {
                Code = code,
                ExpiryTime = DateTime.Now.AddSeconds(60)
            };

            _otpStore[email.ToLower().Trim()] = record;
            DataStore.LogAudit("OTP Generated (Demo)", email, $"Demo 6-digit OTP code created: {code}. Expires in 60 seconds.");
            return code;
        }

        public static bool VerifyOtp(string email, string code, out string error)
        {
            error = string.Empty;
            string key = email.ToLower().Trim();

            if (!_otpStore.TryGetValue(key, out var record))
            {
                error = "No active verification code found for this email. Please request a new code.";
                return false;
            }

            if (DateTime.Now > record.ExpiryTime)
            {
                _otpStore.TryRemove(key, out _);
                error = "Verification code has expired (60-second limit exceeded). Please request a new code.";
                return false;
            }

            if (!record.Code.Equals(code.Trim()))
            {
                error = "Invalid 6-digit code. Please enter the correct code.";
                return false;
            }

            // Successfully verified - remove OTP
            _otpStore.TryRemove(key, out _);
            return true;
        }

        public static bool ResetPassword(string email, string newPassword, out string error)
        {
            error = string.Empty;
            var user = DataStore.Users.FirstOrDefault(u => u.Email.Equals(email.Trim(), StringComparison.OrdinalIgnoreCase));
            if (user == null)
            {
                error = "Account not found.";
                return false;
            }

            user.Password = newPassword;
            DataStore.LogAudit("Password Reset", user.FullName, "Password was updated via OTP verification.");
            return true;
        }
    }
}
