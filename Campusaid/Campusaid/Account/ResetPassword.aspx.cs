using System;
using System.Web.UI;
using Campusaid.Helpers;

namespace Campusaid.Account
{
    public partial class ResetPassword : Page
    {
        private string TargetEmail
        {
            get { return ViewState["TargetEmail"] as string ?? Session["OtpVerifiedEmail"] as string ?? Request.QueryString["email"] ?? string.Empty; }
            set { ViewState["TargetEmail"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string verifiedEmail = Session["OtpVerifiedEmail"] as string ?? Request.QueryString["email"];
                if (string.IsNullOrEmpty(verifiedEmail))
                {
                    Response.Redirect("ForgotPassword.aspx");
                    return;
                }

                TargetEmail = verifiedEmail;
                litEmail.Text = verifiedEmail;
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string newPassword = txtNewPassword.Text.Trim();
            if (AuthHelper.ResetPassword(TargetEmail, newPassword, out string err))
            {
                Session.Remove("OtpVerifiedEmail");
                Response.Redirect("Login.aspx?reset=1");
            }
            else
            {
                pnlAlert.CssClass = "alert alert-danger py-2 small mb-3";
                litAlertMsg.Text = err;
                pnlAlert.Visible = true;
            }
        }
    }
}
