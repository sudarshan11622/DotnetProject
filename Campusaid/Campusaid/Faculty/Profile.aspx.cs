using System;
using System.Web.UI;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.Faculty
{
    public partial class Profile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Faculty");

            if (!IsPostBack)
            {
                BindFacultyProfile();
            }
        }

        private void BindFacultyProfile()
        {
            var user = AuthHelper.GetCurrentUser();
            if (user != null)
            {
                litFacultyName.Text = user.FullName;
                txtOfficeLocation.Text = !string.IsNullOrEmpty(user.OfficeLocation) ? user.OfficeLocation : "Sector B, Building 3 - Room 204";
                txtEmail.Text = user.Email;
                txtPhone.Text = user.Phone;

                chkSms.Checked = user.PrefSms;
                chkEmailDigest.Checked = user.PrefEmail;
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            var user = AuthHelper.GetCurrentUser();
            if (user != null)
            {
                user.OfficeLocation = txtOfficeLocation.Text.Trim();
                string phone = txtPhone.Text.Trim();
                if (!phone.StartsWith("+91") && phone.Length == 10)
                {
                    phone = "+91 " + phone;
                }
                user.Phone = phone;
                user.PrefSms = chkSms.Checked;
                user.PrefEmail = chkEmailDigest.Checked;

                DataStore.LogAudit("Faculty Profile Updated", user.FullName, "Updated office coordinates and notification channel settings.");
            }

            pnlNotice.Visible = true;
            litNotice.Text = "Faculty profile & notification preferences successfully saved!";
        }
    }
}
