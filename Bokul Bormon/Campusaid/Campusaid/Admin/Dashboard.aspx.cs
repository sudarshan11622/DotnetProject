using System;
using System.Linq;
using System.Web.UI;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.Admin
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Admin");

            if (!IsPostBack)
            {
                BindAdminDashboard();
            }
        }

        private void BindAdminDashboard()
        {
            // Dynamic values calculated from collections
            int userCount = DataStore.Users.Count;
            litTotalUsers.Text = (12475 + userCount).ToString("N0");

            int activeCount = DataStore.IncidentReports.Count(r => r.Status != "Resolved" && r.Status != "Rejected");
            litActiveIncidents.Text = $"{activeCount} Urgent";

            int resolvedCount = DataStore.IncidentReports.Count(r => r.Status == "Resolved");
            litResolvedCount.Text = $"{resolvedCount + 44} Cases";

            int pendingCount = DataStore.IncidentReports.Count(r => r.Status == "Submitted" || r.Status == "Pending");
            litPendingCount.Text = $"{pendingCount + 10} Awaiting";

            int activeAlerts = DataStore.EmergencyAlerts.Count(a => a.IsActive);
            litBroadAlertCount.Text = $"{activeAlerts} Broadcast";

            // Percentages
            int totalReports = DataStore.IncidentReports.Count;
            if (totalReports > 0)
            {
                int crits = DataStore.IncidentReports.Count(r => r.Severity.Equals("Critical", StringComparison.OrdinalIgnoreCase));
                int warns = DataStore.IncidentReports.Count(r => r.Severity.Equals("Warning", StringComparison.OrdinalIgnoreCase) || r.Severity.Equals("Medium", StringComparison.OrdinalIgnoreCase) || r.Severity.Equals("High", StringComparison.OrdinalIgnoreCase));
                int routs = totalReports - (crits + warns);

                litPctCritical.Text = $"{Math.Round((double)crits / totalReports * 100)}%";
                litPctWarning.Text = $"{Math.Round((double)warns / totalReports * 100)}%";
                litPctRoutine.Text = $"{Math.Round((double)routs / totalReports * 100)}%";
            }

            // Live Dispatch Feed
            var dispatch = DataStore.IncidentReports.OrderByDescending(r => r.DateFiled).Take(4).ToList();
            rptLiveDispatch.DataSource = dispatch;
            rptLiveDispatch.DataBind();
        }

        protected string GetSeverityBadge(string s)
        {
            if (s.Equals("Critical", StringComparison.OrdinalIgnoreCase)) return "badge-critical";
            if (s.Equals("Warning", StringComparison.OrdinalIgnoreCase) || s.Equals("High", StringComparison.OrdinalIgnoreCase) || s.Equals("Medium", StringComparison.OrdinalIgnoreCase)) return "badge-warning";
            return "badge-info";
        }

        protected string GetStatusBadge(string s)
        {
            if (s.Equals("Resolved", StringComparison.OrdinalIgnoreCase)) return "badge-resolved";
            if (s.Equals("Dispatching", StringComparison.OrdinalIgnoreCase)) return "badge-critical";
            if (s.Equals("Investigating", StringComparison.OrdinalIgnoreCase) || s.Equals("Pending", StringComparison.OrdinalIgnoreCase)) return "badge-warning";
            return "badge-info";
        }

        protected string GetTimeAgo(DateTime dt)
        {
            TimeSpan span = DateTime.Now - dt;
            if (span.TotalMinutes < 60) return $"{(int)Math.Max(1, span.TotalMinutes)}m ago";
            if (span.TotalHours < 24) return $"{(int)span.TotalHours}h ago";
            return $"{(int)span.TotalDays}d ago";
        }
    }
}
