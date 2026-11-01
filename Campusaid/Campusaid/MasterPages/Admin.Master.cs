using System;
using System.IO;
using System.Linq;
using System.Web.UI;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.MasterPages
{
    public partial class AdminMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (AuthHelper.IsAuthenticated)
                {
                    litUserName.Text = AuthHelper.CurrentName;
                }

                int activeCount = DataStore.EmergencyAlerts.Count(a => a.IsActive);
                litActiveAlertsCount.Text = activeCount.ToString();
            }
        }

        protected string IsActive(string pageName)
        {
            string current = Path.GetFileName(Request.Path);
            return string.Equals(current, pageName, StringComparison.OrdinalIgnoreCase) ? "active" : "";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            AuthHelper.Logout();
        }
    }
}
