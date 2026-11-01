using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.Student
{
    public partial class MyReports : Page
    {
        private string ActiveFilter
        {
            get { return ViewState["ActiveFilter"] as string ?? "All"; }
            set { ViewState["ActiveFilter"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Student");

            if (!IsPostBack)
            {
                if (Request.QueryString["submitted"] == "1")
                {
                    pnlSuccess.Visible = true;
                }

                BindCases();
            }
        }

        private void BindCases(string search = "")
        {
            string email = AuthHelper.CurrentEmail;

            // Fetch reports filed by student, or if none yet for new student, include sample student reports
            var query = DataStore.IncidentReports
                .Where(r => r.ReporterEmail.Equals(email, StringComparison.OrdinalIgnoreCase) || r.ReporterRole == "Student");

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
                                         r.IncidentType.ToLower().Contains(s) ||
                                         r.Location.ToLower().Contains(s) ||
                                         r.Description.ToLower().Contains(s));
            }

            var list = query.OrderByDescending(r => r.DateFiled).ToList();
            rptCases.DataSource = list;
            rptCases.DataBind();

            pnlEmpty.Visible = list.Count == 0;
            rptCases.Visible = list.Count > 0;
        }

        protected void btnFilterStatus_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            ActiveFilter = btn.CommandArgument;

            btnFilterAll.CssClass = "btn btn-sm " + (ActiveFilter == "All" ? "btn-dark" : "btn-outline-secondary");
            btnFilterActive.CssClass = "btn btn-sm " + (ActiveFilter == "Active" ? "btn-dark" : "btn-outline-secondary");
            btnFilterResolved.CssClass = "btn btn-sm " + (ActiveFilter == "Resolved" ? "btn-dark" : "btn-outline-secondary");

            BindCases(txtSearchCases.Text);
        }

        protected void btnSearchCases_Click(object sender, EventArgs e)
        {
            BindCases(txtSearchCases.Text);
        }

        protected void btnResetCases_Click(object sender, EventArgs e)
        {
            txtSearchCases.Text = "";
            ActiveFilter = "All";
            btnFilterAll.CssClass = "btn btn-sm btn-dark";
            btnFilterActive.CssClass = "btn btn-sm btn-outline-secondary";
            btnFilterResolved.CssClass = "btn btn-sm btn-outline-secondary";
            BindCases();
        }

        protected void rptCases_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                var report = DataStore.IncidentReports.FirstOrDefault(r => r.Id == id);
                if (report != null)
                {
                    litModalCaseId.Text = report.CaseNumber;
                    litModalType.Text = report.IncidentType;
                    litModalLocation.Text = report.Location;
                    litModalSeverity.Text = $"<span class='badge-ca {GetSeverityBadge(report.Severity)}'>{report.Severity}</span>";
                    litModalStatus.Text = $"<span class='badge-ca {GetStatusBadge(report.Status)}'>{report.Status}</span>";
                    litModalOfficer.Text = report.AssignedOfficer;
                    litModalDesc.Text = report.Description;

                    if (!string.IsNullOrEmpty(report.EvidenceFileName))
                    {
                        pnlEvidence.Visible = true;
                        litModalEvidence.Text = report.EvidenceFileName;
                    }
                    else
                    {
                        pnlEvidence.Visible = false;
                    }

                    pnlCaseModal.Visible = true;
                }
            }
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            pnlCaseModal.Visible = false;
        }

        protected string GetSeverityBadge(string s)
        {
            if (s.Equals("Critical", StringComparison.OrdinalIgnoreCase)) return "badge-critical";
            if (s.Equals("Warning", StringComparison.OrdinalIgnoreCase) || s.Equals("Medium", StringComparison.OrdinalIgnoreCase) || s.Equals("High", StringComparison.OrdinalIgnoreCase)) return "badge-warning";
            return "badge-info";
        }

        protected string GetStatusBadge(string s)
        {
            if (s.Equals("Resolved", StringComparison.OrdinalIgnoreCase)) return "badge-resolved";
            if (s.Equals("Dispatching", StringComparison.OrdinalIgnoreCase) || s.Equals("In Progress", StringComparison.OrdinalIgnoreCase)) return "badge-critical";
            if (s.Equals("Investigating", StringComparison.OrdinalIgnoreCase) || s.Equals("Pending", StringComparison.OrdinalIgnoreCase)) return "badge-warning";
            return "badge-info";
        }
    }
}
