using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Data;
using Campusaid.Models;

namespace Campusaid.Account
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
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
            // Only Student and Faculty registration permitted
            if (role != "Faculty") role = "Student";
            hfSelectedRole.Value = role;
            btnRoleStudent.CssClass = "auth-role-tab " + (role == "Student" ? "active" : "");
            btnRoleFaculty.CssClass = "auth-role-tab " + (role == "Faculty" ? "active" : "");
        }

        protected void cvEmail_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string email = args.Value != null ? args.Value.Trim() : string.Empty;
            bool exists = DataStore.Users.Any(u => u.Email.Equals(email, StringComparison.OrdinalIgnoreCase));
            args.IsValid = !exists;
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim();
            if (!email.EndsWith("@rku.ac.in", StringComparison.OrdinalIgnoreCase))
            {
                pnlAlert.CssClass = "alert alert-danger py-2 small mb-3";
                litAlertMsg.Text = "Only official university email addresses ending with @rku.ac.in are permitted for new registrations.";
                pnlAlert.Visible = true;
                return;
            }

            string fullName = txtName.Text.Trim();
            string password = txtPassword.Text.Trim();
            string role = hfSelectedRole.Value;
            string dept = ddlDepartment.SelectedValue;

            // Generate unique identifier
            string idPrefix = role == "Faculty" ? "F-" : "2024-";
            string idNum = idPrefix + (8000 + DataStore.Users.Count);

            var newUser = new User
            {
                Id = DataStore.Users.Count > 0 ? DataStore.Users.Max(u => u.Id) + 1 : 1,
                FullName = fullName,
                Email = email,
                Password = password,
                Role = role,
                Department = dept,
                IdentifierNumber = idNum,
                Phone = "+91 98765 00000",
                IsActive = true,
                LastLogin = DateTime.Now
            };

            lock (DataStore.Users)
            {
                DataStore.Users.Add(newUser);
            }

            DataStore.LogAudit("User Registration", fullName, $"New temporary in-memory {role} account registered ({email}).");

            Response.Redirect("Login.aspx?registered=1");
        }
    }
}
