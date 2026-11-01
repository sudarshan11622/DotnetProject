using System;
using System.Web.UI;
using Campusaid.Helpers;

namespace Campusaid.Account
{
    public partial class VerifyOTP : Page
    {
        private string TargetEmail
        {
            get { return ViewState["TargetEmail"] as string ?? Request.QueryString["email"] ?? string.Empty; }
            set { ViewState["TargetEmail"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string email = Request.QueryString["email"];
                if (string.IsNullOrEmpty(email))
                {
                    Response.Redirect("ForgotPassword.aspx");
                    return;
                }

                TargetEmail = email;
                litTargetEmail.Text = email;

                string demoCode = Request.QueryString["demoCode"];
                if (!string.IsNullOrEmpty(demoCode))
                {
                    litDemoOtp.Text = demoCode;
                    txtOtpCode.Text = demoCode; // Conveniently auto-fill demo code for instant testing
                }
                else
                {
                    pnlDemoBanner.Visible = false;
                }
            }
        }

        protected void btnVerifyCode_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string code = txtOtpCode.Text.Trim();
            if (AuthHelper.VerifyOtp(TargetEmail, code, out string error))
            {
                // Invalidate OTP and proceed to ResetPassword
                Session["OtpVerifiedEmail"] = TargetEmail;
                Session["OtpVerifiedAt"] = DateTime.Now;
                Response.Redirect($"ResetPassword.aspx?email={Server.UrlEncode(TargetEmail)}");
            }
            else
            {
                pnlAlert.CssClass = "alert alert-danger py-2 small mb-3";
                litAlertMsg.Text = error;
                pnlAlert.Visible = true;
            }
        }

        protected void btnResendCode_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(TargetEmail))
            {
                Response.Redirect("ForgotPassword.aspx");
                return;
            }

            string newCode = AuthHelper.GenerateOtp(TargetEmail);
            litDemoOtp.Text = newCode;
            txtOtpCode.Text = newCode;
            pnlDemoBanner.Visible = true;

            pnlAlert.CssClass = "alert alert-info py-2 small mb-3";
            litAlertMsg.Text = "A new demonstration 6-digit OTP has been generated (expires in 60s).";
            pnlAlert.Visible = true;
        }
    }
}
