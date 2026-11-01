using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.Student
{
    public partial class Alerts : Page
    {
        private string CurrentCategory
        {
            get { return ViewState["CurrentCategory"] as string ?? "All"; }
            set { ViewState["CurrentCategory"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Student");

            if (!IsPostBack)
            {
                BindAlerts();
            }
        }

        private void BindAlerts()
        {
            // Base list of active alerts targeting students
            var query = DataStore.EmergencyAlerts.Where(a => a.IsActive && 
                (a.TargetAudience == "All Campus" || a.TargetAudience == "Students" || a.TargetAudience == "Students & Staff"));

            int total = query.Count();
            int critCount = query.Count(a => a.Severity.Equals("Critical", StringComparison.OrdinalIgnoreCase));
            int warnCount = query.Count(a => a.Severity.Equals("Warning", StringComparison.OrdinalIgnoreCase));
            int infoCount = query.Count(a => a.Severity.Equals("Info", StringComparison.OrdinalIgnoreCase) || a.Severity.Equals("Routine", StringComparison.OrdinalIgnoreCase));

            btnTabAll.Text = $"All Alerts ({total})";
            btnTabCritical.Text = $"Critical ({critCount})";
            btnTabWarning.Text = $"Warnings ({warnCount})";
            btnTabInfo.Text = $"General Info ({infoCount})";

            if (CurrentCategory == "Critical")
            {
                query = query.Where(a => a.Severity.Equals("Critical", StringComparison.OrdinalIgnoreCase));
            }
            else if (CurrentCategory == "Warning")
            {
                query = query.Where(a => a.Severity.Equals("Warning", StringComparison.OrdinalIgnoreCase));
            }
            else if (CurrentCategory == "Info")
            {
                query = query.Where(a => a.Severity.Equals("Info", StringComparison.OrdinalIgnoreCase) || a.Severity.Equals("Routine", StringComparison.OrdinalIgnoreCase));
            }

            var list = query.OrderByDescending(a => a.IssuedDate).ToList();
            rptAlerts.DataSource = list;
            rptAlerts.DataBind();

            pnlNoAlerts.Visible = list.Count == 0;
            rptAlerts.Visible = list.Count > 0;
        }

        protected void btnTab_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            CurrentCategory = btn.CommandArgument;

            btnTabAll.CssClass = "btn btn-sm " + (CurrentCategory == "All" ? "btn-dark" : "btn-outline-secondary");
            btnTabCritical.CssClass = "btn btn-sm " + (CurrentCategory == "Critical" ? "btn-danger" : "btn-outline-danger");
            btnTabWarning.CssClass = "btn btn-sm " + (CurrentCategory == "Warning" ? "btn-warning" : "btn-outline-warning");
            btnTabInfo.CssClass = "btn btn-sm " + (CurrentCategory == "Info" ? "btn-primary" : "btn-outline-primary");

            BindAlerts();
        }

        protected void rptAlerts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Ack")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                var alert = DataStore.EmergencyAlerts.FirstOrDefault(a => a.Id == id);
                if (alert != null)
                {
                    string email = AuthHelper.CurrentEmail;
                    if (!alert.AcknowledgedUsers.Contains(email))
                    {
                        alert.AcknowledgedUsers.Add(email);
                        DataStore.LogAudit("Alert Acknowledged", AuthHelper.CurrentName, $"Acknowledged alert #{id}: {alert.Title}");
                    }

                    pnlAckMsg.Visible = true;
                    litAckMsg.Text = $"Alert '{alert.Title}' has been marked acknowledged.";
                    BindAlerts();
                }
            }
        }

        protected bool IsAcknowledged(List<string> acknowledgedUsers)
        {
            if (acknowledgedUsers == null) return false;
            return acknowledgedUsers.Contains(AuthHelper.CurrentEmail);
        }

        protected string GetSeverityBadge(string s)
        {
            if (s.Equals("Critical", StringComparison.OrdinalIgnoreCase)) return "badge-critical";
            if (s.Equals("Warning", StringComparison.OrdinalIgnoreCase)) return "badge-warning";
            return "badge-info";
        }
    }
}
