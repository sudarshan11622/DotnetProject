using System;
using System.IO;
using System.Linq;
using System.Web.UI;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.MasterPages
{
    public partial class FacultyMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (AuthHelper.IsAuthenticated)
                {
                    litUserName.Text = AuthHelper.CurrentName;
                    litUserId.Text = !string.IsNullOrEmpty(AuthHelper.CurrentIdentifier) ? $"Faculty ID: {AuthHelper.CurrentIdentifier}" : "Faculty ID: F-2840";
                }

                int activeCount = DataStore.EmergencyAlerts.Count(a => a.IsActive && 
                    (a.TargetAudience == "All Campus" || a.TargetAudience == "Faculty" || a.TargetAudience == "Faculty & Staff"));
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
