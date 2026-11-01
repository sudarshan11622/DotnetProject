using System;
using System.Linq;
using System.Web.UI;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.Student
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Student");

            if (!IsPostBack)
            {
                string name = AuthHelper.CurrentName;
                if (!string.IsNullOrEmpty(name))
                {
                    litWelcomeName.Text = name.Split(' ')[0];
                }

                // Notices from actions
                if (Request.QueryString["sos"] == "1")
                {
                    pnlNotice.Visible = true;
                    litNoticeTitle.Text = "Emergency SOS Dispatched";
                    litNoticeMsg.Text = "Campus Police & Paramedics have received your distress signal with quad location broadcasting.";
                }
                else if (Request.QueryString["reported"] == "1")
                {
                    pnlNotice.Visible = true;
                    litNoticeTitle.Text = "Incident Report Submitted";
                    litNoticeMsg.Text = "Your safety report has been logged with official Case ID and routed to dispatch officers.";
                }

                // Bind Data
                BindDashboard();
            }
        }

        private void BindDashboard()
        {
            string email = AuthHelper.CurrentEmail;

            // My Reports count
            int myReports = DataStore.IncidentReports.Count(r => r.ReporterEmail.Equals(email, StringComparison.OrdinalIgnoreCase));
            litMyReportsCount.Text = myReports.ToString();

            // Active alerts
            var activeList = DataStore.EmergencyAlerts.Where(a => a.IsActive).OrderByDescending(a => a.IssuedDate).ToList();
            litActiveAlerts.Text = activeList.Count.ToString();
            litActiveBadge.Text = $"{activeList.Count} ACTIVE";

            // Bind top 3 alerts
            rptRecentAlerts.DataSource = activeList.Take(3).ToList();
            rptRecentAlerts.DataBind();

            // Resource count
            litHotlinesCount.Text = DataStore.EmergencyResources.Count(r => r.IsActive).ToString();
        }

        protected string GetSeverityBadgeClass(string severity)
        {
            if (severity.Equals("Critical", StringComparison.OrdinalIgnoreCase)) return "badge-critical";
            if (severity.Equals("Warning", StringComparison.OrdinalIgnoreCase)) return "badge-warning";
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
