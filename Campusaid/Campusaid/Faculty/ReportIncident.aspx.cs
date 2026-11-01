using System;
using System.Web.UI;
using Campusaid.Data;
using Campusaid.Helpers;
using Campusaid.Models;

namespace Campusaid.Faculty
{
    public partial class ReportIncident : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Faculty");

            if (!IsPostBack)
            {
                if (Request.QueryString["override"] == "1")
                {
                    chkPriorityOverride.Checked = true;
                    ddlIncidentType.SelectedValue = "Medical Emergency";
                }
            }
        }

        protected void btnDiscard_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        protected void btnSubmitReport_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string type = ddlIncidentType.SelectedValue;
            string location = txtBuildingRoom.Text.Trim();
            string description = txtDescription.Text.Trim();
            int.TryParse(txtAffectedCount.Text, out int affected);
            bool isOverride = chkPriorityOverride.Checked;
            bool notifyDept = chkNotifyDept.Checked;

            string severity = isOverride ? "Critical" : "High";

            var report = new IncidentReport
            {
                ReporterName = AuthHelper.CurrentName,
                ReporterEmail = AuthHelper.CurrentEmail,
                ReporterRole = "Faculty",
                IncidentType = type,
                Location = location,
                Description = description,
                Severity = severity,
                Status = isOverride ? "Dispatching" : "Submitted",
                DateFiled = DateTime.Now,
                AssignedOfficer = isOverride ? "Sgt. Miller (EMT-2)" : "Awaiting Dispatch",
                AffectedCount = affected,
                EmergencyOverride = isOverride,
                NotifyDepartment = notifyDept
            };

            DataStore.AddIncidentReport(report);

            Response.Redirect("Reports.aspx?submitted=1");
        }
    }
}
