using System;
using System.Linq;
using System.Web.UI;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.Admin
{
    public partial class Settings : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Admin");

            if (!IsPostBack)
            {
                BindSettings();
                BindAuditLogs();
            }
        }

        private void BindSettings()
        {
            var s = DataStore.Settings;
            txtAppName.Text = s.AppName;
            txtInstitution.Text = s.InstitutionName;
            txtEmergencyDesk.Text = s.EmergencyDesk;
            txtEmergencyExt.Text = s.EmergencyExtension;

            chkEnableSms.Checked = s.EnableSmsAlerts;
            chkEnablePush.Checked = s.EnablePushWarnings;
            chkEnableSiren.Checked = s.EnableSirenSync;
        }

        private void BindAuditLogs()
        {
            rptAuditLogs.DataSource = DataStore.AuditLogs.Take(15).ToList();
            rptAuditLogs.DataBind();
        }

        protected void btnSaveGeneral_Click(object sender, EventArgs e)
        {
            var s = DataStore.Settings;
            s.AppName = txtAppName.Text.Trim();
            s.InstitutionName = txtInstitution.Text.Trim();
            s.EmergencyDesk = txtEmergencyDesk.Text.Trim();
            s.EmergencyExtension = txtEmergencyExt.Text.Trim();

            DataStore.LogAudit("General Settings Updated", AuthHelper.CurrentName, "Modified Directory App Name and Official Emergency Desk info.");

            pnlNotice.CssClass = "alert alert-success py-2 small mb-4";
            pnlNotice.Visible = true;
            litNotice.Text = "General system configuration saved in memory.";

            BindAuditLogs();
        }

        protected void btnSaveRules_Click(object sender, EventArgs e)
        {
            var s = DataStore.Settings;
            s.EnableSmsAlerts = chkEnableSms.Checked;
            s.EnablePushWarnings = chkEnablePush.Checked;
            s.EnableSirenSync = chkEnableSiren.Checked;

            DataStore.LogAudit("Notification Rules Updated", AuthHelper.CurrentName, 
                $"Rules: SMS={s.EnableSmsAlerts}, Push={s.EnablePushWarnings}, SirenSync={s.EnableSirenSync}");

            pnlNotice.CssClass = "alert alert-success py-2 small mb-4";
            pnlNotice.Visible = true;
            litNotice.Text = "Notification dispatch rules updated successfully!";

            BindAuditLogs();
        }

        protected void btnExportAuditCsv_Click(object sender, EventArgs e)
        {
            DataStore.LogAudit("Audit Logs Exported", AuthHelper.CurrentName, "Exported system audit logs to CSV.");
            CsvHelper.ExportAuditLogs(DataStore.AuditLogs, "System_Audit_Logs");
        }

        protected string GetTimeAgo(DateTime dt)
        {
            TimeSpan span = DateTime.Now - dt;
            if (span.TotalMinutes < 60) return $"{(int)Math.Max(1, span.TotalMinutes)} mins ago";
            if (span.TotalHours < 24) return $"{(int)span.TotalHours} hours ago";
            return $"{(int)span.TotalDays} days ago";
        }
    }
}
