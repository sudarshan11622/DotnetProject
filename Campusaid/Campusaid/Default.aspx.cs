using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Campusaid
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Helpers.AuthHelper.IsAuthenticated)
            {
                string role = Helpers.AuthHelper.CurrentRole;
                if (role.Equals("Student", StringComparison.OrdinalIgnoreCase))
                {
                    Response.Redirect("~/Student/Dashboard.aspx");
                }
                else if (role.Equals("Faculty", StringComparison.OrdinalIgnoreCase))
                {
                    Response.Redirect("~/Faculty/Dashboard.aspx");
                }
                else if (role.Equals("Admin", StringComparison.OrdinalIgnoreCase))
                {
                    Response.Redirect("~/Admin/Dashboard.aspx");
                }
            }
            else
            {
                Response.Redirect("~/Account/Login.aspx");
            }
        }
    }
}