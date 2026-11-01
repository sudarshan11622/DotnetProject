using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Data;
using Campusaid.Helpers;
using Campusaid.Models;

namespace Campusaid.Admin
{
    public partial class Reports : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Admin");

            if (!IsPostBack)
            {
                BindReports();
            }
        }

        protected void Filter_Changed(object sender, EventArgs e)
        {
            BindReports();
        }

        protected void btnResetFilters_Click(object sender, EventArgs e)
        {
            ddlDateFilter.SelectedValue = "30";
            ddlTypeFilter.SelectedValue = "All";
            ddlStatusFilter.SelectedValue = "All";
            ddlSeverityFilter.SelectedValue = "All";
            ddlRoleFilter.SelectedValue = "All";
            BindReports();
        }

        private void BindReports()
        {
            var query = DataStore.IncidentReports.AsQueryable();

            // Date filter
            string d = ddlDateFilter.SelectedValue;
            if (d == "1") query = query.Where(r => r.DateFiled >= DateTime.Today);
            else if (d == "7") query = query.Where(r => r.DateFiled >= DateTime.Now.AddDays(-7));
            else if (d == "30") query = query.Where(r => r.DateFiled >= DateTime.Now.AddDays(-30));

            // Type
            string t = ddlTypeFilter.SelectedValue;
            if (t != "All") query = query.Where(r => r.IncidentType.Contains(t));

            // Status
            string s = ddlStatusFilter.SelectedValue;
            if (s != "All") query = query.Where(r => r.Status.Equals(s, StringComparison.OrdinalIgnoreCase));

            // Severity
            string sev = ddlSeverityFilter.SelectedValue;
            if (sev == "Critical") query = query.Where(r => r.Severity.Equals("Critical", StringComparison.OrdinalIgnoreCase));
            else if (sev == "Warning") query = query.Where(r => r.Severity.Equals("Warning", StringComparison.OrdinalIgnoreCase) || r.Severity.Equals("High", StringComparison.OrdinalIgnoreCase));
            else if (sev == "Routine") query = query.Where(r => r.Severity.Equals("Routine", StringComparison.OrdinalIgnoreCase) || r.Severity.Equals("Minor", StringComparison.OrdinalIgnoreCase));

            // Role
            string rl = ddlRoleFilter.SelectedValue;
            if (rl != "All") query = query.Where(r => r.ReporterRole.Equals(rl, StringComparison.OrdinalIgnoreCase));

            var list = query.OrderByDescending(r => r.DateFiled).ToList();
            rptAdminReports.DataSource = list;
            rptAdminReports.DataBind();

            litSelectedCount.Text = $"Selected: 0 of {list.Count} Reports";
            litShowingReports.Text = $"Showing 1-{list.Count} of {list.Count} Reports";
        }

        private List<int> GetSelectedReportIds()
        {
            var ids = new List<int>();
            foreach (RepeaterItem item in rptAdminReports.Items)
            {
                var chk = (CheckBox)item.FindControl("chkSelect");
                var hf = (HiddenField)item.FindControl("hfReportId");
                if (chk != null && chk.Checked && hf != null)
                {
                    if (int.TryParse(hf.Value, out int id))
                    {
                        ids.Add(id);
                    }
                }
            }
            return ids;
        }

        protected void btnOpenAssignModal_Click(object sender, EventArgs e)
        {
            var selected = GetSelectedReportIds();
            if (selected.Count == 0)
            {
                pnlNotice.CssClass = "alert alert-warning py-2 small mb-4";
                pnlNotice.Visible = true;
                litNotice.Text = "Please select at least one report using the checkbox to assign an officer.";
                return;
            }

            pnlAssignModal.Visible = true;
        }

        protected void btnConfirmAssign_Click(object sender, EventArgs e)
        {
            var selected = GetSelectedReportIds();
            string officer = ddlOfficers.SelectedValue;
            bool setDispatch = chkUpdateStatusToDispatch.Checked;

            foreach (int id in selected)
            {
                var report = DataStore.IncidentReports.FirstOrDefault(r => r.Id == id);
                if (report != null)
                {
                    report.AssignedOfficer = officer;
                    if (setDispatch)
                    {
                        report.Status = "Dispatching";
                    }
                }
            }

            DataStore.LogAudit("Officer Assignment", AuthHelper.CurrentName, $"Assigned {officer} to {selected.Count} incident cases.");

            pnlAssignModal.Visible = false;
            pnlNotice.CssClass = "alert alert-success py-2 small mb-4";
            pnlNotice.Visible = true;
            litNotice.Text = $"Successfully assigned {officer} to {selected.Count} cases.";

            BindReports();
        }

        protected void btnOpenStatusModal_Click(object sender, EventArgs e)
        {
            var selected = GetSelectedReportIds();
            if (selected.Count == 0)
            {
                pnlNotice.CssClass = "alert alert-warning py-2 small mb-4";
                pnlNotice.Visible = true;
                litNotice.Text = "Please select at least one report using the checkbox to update status.";
                return;
            }

            pnlStatusModal.Visible = true;
        }

        protected void btnConfirmStatus_Click(object sender, EventArgs e)
        {
            var selected = GetSelectedReportIds();
            string newStatus = ddlNewStatus.SelectedValue;

            foreach (int id in selected)
            {
                DataStore.UpdateIncidentStatus(id, newStatus);
            }

            pnlStatusModal.Visible = false;
            pnlNotice.CssClass = "alert alert-success py-2 small mb-4";
            pnlNotice.Visible = true;
            litNotice.Text = $"Status updated to '{newStatus}' for {selected.Count} cases.";

            BindReports();
        }

        protected void btnExportSelection_Click(object sender, EventArgs e)
        {
            var selected = GetSelectedReportIds();
            var listToExport = selected.Count > 0 
                ? DataStore.IncidentReports.Where(r => selected.Contains(r.Id)).ToList() 
                : DataStore.IncidentReports.ToList();

            DataStore.LogAudit("Admin CSV Export", AuthHelper.CurrentName, $"Exported {listToExport.Count} reports to CSV.");
            CsvHelper.ExportIncidentReports(listToExport, "Admin_Incident_Registry");
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            pnlAssignModal.Visible = false;
            pnlStatusModal.Visible = false;
        }

        protected void btnPrevPage_Click(object sender, EventArgs e)
        {
            BindReports();
        }

        protected void btnNextPage_Click(object sender, EventArgs e)
        {
            BindReports();
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
            if (s.Equals("Dispatching", StringComparison.OrdinalIgnoreCase) || s.Equals("Dispatched", StringComparison.OrdinalIgnoreCase)) return "badge-critical";
            if (s.Equals("Investigating", StringComparison.OrdinalIgnoreCase) || s.Equals("Pending", StringComparison.OrdinalIgnoreCase)) return "badge-warning";
            return "badge-info";
        }
    }
}
