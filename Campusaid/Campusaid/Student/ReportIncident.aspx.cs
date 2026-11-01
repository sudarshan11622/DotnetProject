using System;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Data;
using Campusaid.Helpers;
using Campusaid.Models;

namespace Campusaid.Student
{
    public partial class ReportIncident : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Student");
        }

        protected void cvFileUpload_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (fuEvidence.HasFile)
            {
                string ext = Path.GetExtension(fuEvidence.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".mp4")
                {
                    args.IsValid = false;
                    return;
                }

                // 25MB check
                if (fuEvidence.FileBytes.Length > 25 * 1024 * 1024)
                {
                    args.IsValid = false;
                    return;
                }
            }
            args.IsValid = true;
        }

        protected void btnSubmitReport_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string incidentType = ddlIncidentType.SelectedValue;
            string location = txtLocation.Text.Trim();
            string description = txtDescription.Text.Trim();
            bool isAnon = chkAnonymous.Checked;

            string severity = "Medium";
            if (rbCritical.Checked) severity = "Critical";
            else if (rbMinor.Checked) severity = "Minor";

            string evidenceFileName = null;
            if (fuEvidence.HasFile)
            {
                evidenceFileName = Path.GetFileName(fuEvidence.FileName);
            }

            var report = new IncidentReport
            {
                ReporterName = isAnon ? "Anonymous Student" : AuthHelper.CurrentName,
                ReporterEmail = isAnon ? "anonymous@university.edu" : AuthHelper.CurrentEmail,
                ReporterRole = "Student",
                IncidentType = incidentType,
                Location = location,
                Description = description,
                Severity = severity,
                Status = "Submitted",
                DateFiled = DateTime.Now,
                AssignedOfficer = "Awaiting Dispatch",
                EvidenceFileName = evidenceFileName,
                IsAnonymous = isAnon
            };

            DataStore.AddIncidentReport(report);

            Response.Redirect("MyReports.aspx?submitted=1");
        }
    }
}
