using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.Faculty
{
    public partial class EmergencyAlerts : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Faculty");

            if (!IsPostBack)
            {
                BindAlerts();
            }
        }

        private void BindAlerts()
        {
            var query = DataStore.EmergencyAlerts.Where(a => a.IsActive && 
                (a.TargetAudience == "All Campus" || a.TargetAudience == "Faculty" || a.TargetAudience == "Faculty & Staff"));

            string search = txtSearchAlerts.Text.Trim();
            if (!string.IsNullOrEmpty(search))
            {
                string s = search.ToLower();
                query = query.Where(a => a.Title.ToLower().Contains(s) || a.Message.ToLower().Contains(s) || a.AffectedArea.ToLower().Contains(s));
            }

            string sev = ddlFilterSeverity.SelectedValue;
            if (sev != "All")
            {
                query = query.Where(a => a.Severity.Equals(sev, StringComparison.OrdinalIgnoreCase));
            }

            var list = query.OrderByDescending(a => a.IssuedDate).ToList();
            rptAlerts.DataSource = list;
            rptAlerts.DataBind();

            pnlNoAlerts.Visible = list.Count == 0;
            rptAlerts.Visible = list.Count > 0;
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindAlerts();
        }

        protected void ddlFilterSeverity_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindAlerts();
        }

        protected void rptAlerts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AckAlert")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                var alert = DataStore.EmergencyAlerts.FirstOrDefault(a => a.Id == id);
                if (alert != null)
                {
                    string email = AuthHelper.CurrentEmail;
                    if (!alert.AcknowledgedUsers.Contains(email))
                    {
                        alert.AcknowledgedUsers.Add(email);
                        DataStore.LogAudit("Faculty Acknowledged Alert", AuthHelper.CurrentName, $"Acknowledged broadcast #{id}: {alert.Title}");
                    }

                    pnlNotice.Visible = true;
                    litNotice.Text = $"Alert '{alert.Title}' marked acknowledged.";
                    BindAlerts();
                }
            }
        }

        protected bool IsAcknowledged(List<string> list)
        {
            if (list == null) return false;
            return list.Contains(AuthHelper.CurrentEmail);
        }

        protected string GetSeverityBadge(string s)
        {
            if (s.Equals("Critical", StringComparison.OrdinalIgnoreCase)) return "badge-critical";
            if (s.Equals("Warning", StringComparison.OrdinalIgnoreCase)) return "badge-warning";
            return "badge-info";
        }
    }
}
