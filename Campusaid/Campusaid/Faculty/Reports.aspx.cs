using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.Faculty
{
    public partial class Reports : Page
    {
        private string ActiveFilter
        {
            get { return ViewState["ActiveFilter"] as string ?? "Active"; }
            set { ViewState["ActiveFilter"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Faculty");

            if (!IsPostBack)
            {
                if (Request.QueryString["submitted"] == "1")
                {
                    pnlSuccess.Visible = true;
                }

                BindIncidents();
            }
        }

        private void BindIncidents(string search = "")
        {
            var query = DataStore.IncidentReports.AsQueryable();

            if (ActiveFilter == "Active")
            {
                query = query.Where(r => r.Status != "Resolved" && r.Status != "Rejected");
            }
            else if (ActiveFilter == "Resolved")
            {
                query = query.Where(r => r.Status == "Resolved");
            }

            if (!string.IsNullOrWhiteSpace(search))
            {
                string s = search.Trim().ToLower();
                query = query.Where(r => r.CaseNumber.ToLower().Contains(s) ||
                                         r.ReporterName.ToLower().Contains(s) ||
                                         r.IncidentType.ToLower().Contains(s) ||
                                         r.Location.ToLower().Contains(s));
            }

            var list = query.OrderByDescending(r => r.DateFiled).ToList();
            rptIncidents.DataSource = list;
            rptIncidents.DataBind();

            pnlEmpty.Visible = list.Count == 0;
            rptIncidents.Visible = list.Count > 0;
        }

        protected void btnFilterStatus_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            ActiveFilter = btn.CommandArgument;

            btnFilterAll.CssClass = "btn btn-sm " + (ActiveFilter == "All" ? "btn-dark" : "btn-outline-secondary");
            btnFilterActive.CssClass = "btn btn-sm " + (ActiveFilter == "Active" ? "btn-dark" : "btn-outline-secondary");
            btnFilterResolved.CssClass = "btn btn-sm " + (ActiveFilter == "Resolved" ? "btn-dark" : "btn-outline-secondary");

            BindIncidents(txtSearch.Text);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindIncidents(txtSearch.Text);
        }

        protected void btnExportCsv_Click(object sender, EventArgs e)
        {
            var query = DataStore.IncidentReports.AsEnumerable();
            if (ActiveFilter == "Active") query = query.Where(r => r.Status != "Resolved");
            else if (ActiveFilter == "Resolved") query = query.Where(r => r.Status == "Resolved");

            DataStore.LogAudit("CSV Export", AuthHelper.CurrentName, "Faculty downloaded incident audit records.");
            CsvHelper.ExportIncidentReports(query, "Faculty_Incident_Records");
        }

        protected void rptIncidents_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                var report = DataStore.IncidentReports.FirstOrDefault(r => r.Id == id);
                if (report != null)
                {
                    litModalCaseId.Text = report.CaseNumber.Replace("CASE-", "");
                    litModalReporter.Text = report.ReporterName;
                    litModalType.Text = report.IncidentType;
                    litModalLocation.Text = report.Location;
                    litModalSeverity.Text = $"<span class='badge-ca {GetSeverityBadge(report.Severity)}'>{report.Severity.ToUpper()}</span>";
                    litModalStatus.Text = $"<span class='badge-ca {GetStatusBadge(report.Status)}'>{report.Status.ToUpper()}</span>";
                    litModalOfficer.Text = report.AssignedOfficer;
                    litModalDesc.Text = report.Description;

                    pnlDetailModal.Visible = true;
                }
            }
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            pnlDetailModal.Visible = false;
        }

        protected string GetSeverityBadge(string s)
        {
            if (s.Equals("Critical", StringComparison.OrdinalIgnoreCase)) return "badge-critical";
            if (s.Equals("Warning", StringComparison.OrdinalIgnoreCase) || s.Equals("High", StringComparison.OrdinalIgnoreCase)) return "badge-warning";
            return "badge-info";
        }

        protected string GetStatusBadge(string s)
        {
            if (s.Equals("Resolved", StringComparison.OrdinalIgnoreCase)) return "badge-resolved";
            if (s.Equals("Dispatching", StringComparison.OrdinalIgnoreCase)) return "badge-critical";
            if (s.Equals("Investigating", StringComparison.OrdinalIgnoreCase) || s.Equals("Pending", StringComparison.OrdinalIgnoreCase)) return "badge-warning";
            return "badge-info";
        }
    }
}
