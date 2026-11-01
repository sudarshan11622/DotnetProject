using System;
using System.Linq;
using System.Web.UI;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.Student
{
    public partial class Resources : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Student");

            if (!IsPostBack)
            {
                BindResources();
            }
        }

        private void BindResources(string query = "")
        {
            var list = DataStore.EmergencyResources.Where(r => r.IsActive);

            if (!string.IsNullOrWhiteSpace(query))
            {
                string q = query.Trim().ToLower();
                list = list.Where(r => (r.Name != null && r.Name.ToLower().Contains(q)) ||
                                       (r.Category != null && r.Category.ToLower().Contains(q)) ||
                                       (r.Location != null && r.Location.ToLower().Contains(q)) ||
                                       (r.Description != null && r.Description.ToLower().Contains(q)));
                pnlFilterNotice.Visible = true;
                litFilterQuery.Text = query;
            }
            else
            {
                pnlFilterNotice.Visible = false;
            }

            var resultList = list.ToList();
            pnlNoResults.Visible = resultList.Count == 0;
            rptResources.DataSource = resultList;
            rptResources.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindResources(txtSearch.Text);
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            BindResources();
        }
    }
}
