using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Helpers;

namespace Campusaid.Account
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is already logged in
                if (AuthHelper.IsAuthenticated)
                {
                    RedirectToRoleDashboard(AuthHelper.CurrentRole);
                    return;
                }

                // Handle query parameters
                string err = Request.QueryString["error"];
                if (err == "unauthorized")
                {
                    ShowError("Session expired or unauthorized. Please sign in to access that portal.");
                }
                else if (err == "role_denied")
                {
                    ShowError("You do not have administrative authorization to access that section.");
                }

                string registered = Request.QueryString["registered"];
                if (registered == "1")
                {
                    pnlAlert.CssClass = "alert alert-success py-2 small mb-3";
                    litAlertMsg.Text = "Temporary in-memory account created successfully! Please sign in.";
                    pnlAlert.Visible = true;
                }

                string reset = Request.QueryString["reset"];
                if (reset == "1")
                {
                    pnlAlert.CssClass = "alert alert-success py-2 small mb-3";
                    litAlertMsg.Text = "Password updated successfully! Please sign in with your new password.";
                    pnlAlert.Visible = true;
                }

                // Default selection
                SelectRole("Student");
            }
        }

        protected void btnRole_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            SelectRole(btn.CommandArgument);
        }

        private void SelectRole(string role)
        {
            hfSelectedRole.Value = role;
            btnRoleStudent.CssClass = "auth-role-tab " + (role == "Student" ? "active" : "");
            btnRoleFaculty.CssClass = "auth-role-tab " + (role == "Faculty" ? "active" : "");
            btnRoleAdmin.CssClass = "auth-role-tab " + (role == "Admin" ? "active" : "");
        }

        protected void btnQuickFill_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            string role = btn.CommandArgument;
            SelectRole(role);

            if (role == "Student")
            {
                txtEmail.Text = "bokul@gmail.com";
                txtPassword.Attributes["value"] = "Bokul@123";
                txtPassword.Text = "Bokul@123";
            }
            else if (role == "Faculty")
            {
                txtEmail.Text = "manab@gmail.com";
                txtPassword.Attributes["value"] = "Manab@123";
                txtPassword.Text = "Manab@123";
            }
            else if (role == "Admin")
            {
                txtEmail.Text = "sudarshan@gmail.com";
                txtPassword.Attributes["value"] = "Sudarshan@123";
                txtPassword.Text = "Sudarshan@123";
            }
        }

        protected void btnSignIn_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (AuthHelper.Login(email, password, out string err))
            {
                RedirectToRoleDashboard(AuthHelper.CurrentRole);
            }
            else
            {
                ShowError(err);
            }
        }

        private void RedirectToRoleDashboard(string role)
        {
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
            else
            {
                Response.Redirect("~/Student/Dashboard.aspx");
            }
        }

        private void ShowError(string message)
        {
            pnlAlert.CssClass = "alert alert-danger py-2 small mb-3";
            litAlertMsg.Text = message;
            pnlAlert.Visible = true;
        }
    }
}
