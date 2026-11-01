using System;
using System.Linq;
using System.Web.UI;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.Account
{
    public partial class ForgotPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSendCode_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim();
            var user = DataStore.Users.FirstOrDefault(u => u.Email.Equals(email, StringComparison.OrdinalIgnoreCase));

            if (user == null)
            {
                pnlAlert.CssClass = "alert alert-danger py-2 small mb-3";
                litAlertMsg.Text = "No registered account found with that email address.";
                pnlAlert.Visible = true;
                return;
            }

            // Generate demo 6-digit OTP (expires in 60 seconds)
            string code = AuthHelper.GenerateOtp(email);

            // Redirect to VerifyOTP page with email and simulated OTP info
            Response.Redirect($"VerifyOTP.aspx?email={Server.UrlEncode(email)}&demoCode={code}");
        }
    }
}
