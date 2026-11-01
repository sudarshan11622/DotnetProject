using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Data;
using Campusaid.Helpers;
using Campusaid.Models;

namespace Campusaid.Admin
{
    public partial class EmergencyAlerts : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Admin");

            if (!IsPostBack)
            {
                BindAlerts();
            }
        }

        private void BindAlerts()
        {
            var list = DataStore.EmergencyAlerts.OrderByDescending(a => a.IssuedDate).ToList();
            rptAlertHistory.DataSource = list;
            rptAlertHistory.DataBind();

            int activeCount = list.Count(a => a.IsActive);
            litActiveCountBadge.Text = $"{activeCount} ACTIVE";
        }

        protected void btnBroadcastNow_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string heading = txtAlertHeading.Text.Trim();
            string severity = ddlAlertSeverity.SelectedValue;
            string audience = ddlAudience.SelectedValue;
            string area = !string.IsNullOrEmpty(txtAffectedArea.Text) ? txtAffectedArea.Text.Trim() : "All Campus Sectors";
            string msg = txtAlertMessage.Text.Trim();

            var alert = new EmergencyAlert
            {
                Title = heading,
                Severity = severity,
                TargetAudience = audience,
                AffectedArea = area,
                Message = msg,
                CreatedBy = AuthHelper.CurrentName,
                IssuingAuthority = "Campus Emergency Command Desk",
                IsActive = true,
                IsScheduled = false,
                IssuedDate = DateTime.Now
            };

            // This calls DataStore.BroadcastAlert which triggers the C# event OnAlertBroadcast!
            DataStore.BroadcastAlert(alert);

            pnlNotice.CssClass = "alert alert-success py-2 small mb-4";
            pnlNotice.Visible = true;
            litNotice.Text = $"Emergency Alert '{heading}' has been broadcasted immediately to {audience} and is now active across Student and Faculty portals!";

            // Reset fields
            txtAlertHeading.Text = "";
            txtAffectedArea.Text = "";
            txtAlertMessage.Text = "";

            BindAlerts();
        }

        protected void btnScheduleBroadcast_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string heading = txtAlertHeading.Text.Trim();
            string severity = ddlAlertSeverity.SelectedValue;
            string audience = ddlAudience.SelectedValue;
            string area = !string.IsNullOrEmpty(txtAffectedArea.Text) ? txtAffectedArea.Text.Trim() : "All Campus Sectors";
            string msg = txtAlertMessage.Text.Trim();

            var alert = new EmergencyAlert
            {
                Title = heading,
                Severity = severity,
                TargetAudience = audience,
                AffectedArea = area,
                Message = msg,
                CreatedBy = AuthHelper.CurrentName,
                IssuingAuthority = "Scheduled Dispatch System",
                IsActive = false,
                IsScheduled = true,
                ScheduledDate = DateTime.Now.AddHours(2),
                IssuedDate = DateTime.Now
            };

            lock (DataStore.EmergencyAlerts)
            {
                alert.Id = DataStore.EmergencyAlerts.Count > 0 ? DataStore.EmergencyAlerts.Max(a => a.Id) + 1 : 1;
                DataStore.EmergencyAlerts.Insert(0, alert);
            }

            DataStore.LogAudit("Alert Scheduled", AuthHelper.CurrentName, $"Scheduled broadcast '{heading}' for in-memory execution.");

            pnlNotice.CssClass = "alert alert-info py-2 small mb-4";
            pnlNotice.Visible = true;
            litNotice.Text = $"Alert '{heading}' has been scheduled in memory (Scheduled for +2 hours). Note: In-memory scheduling resets on app pool restart.";

            BindAlerts();
        }

        protected void rptAlertHistory_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ToggleAlert")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                var alert = DataStore.EmergencyAlerts.FirstOrDefault(a => a.Id == id);
                if (alert != null)
                {
                    alert.IsActive = !alert.IsActive;
                    string action = alert.IsActive ? "Activated" : "Deactivated";
                    DataStore.LogAudit($"Alert {action}", AuthHelper.CurrentName, $"{action} broadcast alert #{id}: {alert.Title}");

                    pnlNotice.CssClass = "alert alert-success py-2 small mb-4";
                    pnlNotice.Visible = true;
                    litNotice.Text = $"Alert '{alert.Title}' has been {action.ToLower()}.";

                    BindAlerts();
                }
            }
        }

        protected string GetSeverityBadge(string s)
        {
            if (s.Equals("Critical", StringComparison.OrdinalIgnoreCase)) return "badge-critical";
            if (s.Equals("Warning", StringComparison.OrdinalIgnoreCase)) return "badge-warning";
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
