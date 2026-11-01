using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Data;
using Campusaid.Helpers;
using Campusaid.Models;

namespace Campusaid.Admin
{
    public partial class Users : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Admin");

            if (!IsPostBack)
            {
                BindUsers();
            }
        }

        protected void Filter_Changed(object sender, EventArgs e)
        {
            BindUsers();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindUsers();
        }

        private void BindUsers()
        {
            var query = DataStore.Users.AsQueryable();

            string search = txtSearchUser.Text.Trim();
            if (!string.IsNullOrEmpty(search))
            {
                string s = search.ToLower();
                query = query.Where(u => u.FullName.ToLower().Contains(s) ||
                                         u.Email.ToLower().Contains(s) ||
                                         (u.IdentifierNumber != null && u.IdentifierNumber.ToLower().Contains(s)));
            }

            string role = ddlRoleFilter.SelectedValue;
            if (role != "All")
            {
                query = query.Where(u => u.Role.Equals(role, StringComparison.OrdinalIgnoreCase));
            }

            string status = ddlStatusFilter.SelectedValue;
            if (status == "Active") query = query.Where(u => u.IsActive);
            else if (status == "Inactive") query = query.Where(u => !u.IsActive);

            string dept = ddlDeptFilter.SelectedValue;
            if (dept != "All")
            {
                query = query.Where(u => u.Department.Equals(dept, StringComparison.OrdinalIgnoreCase));
            }

            rptUsers.DataSource = query.OrderBy(u => u.Role).ThenBy(u => u.FullName).ToList();
            rptUsers.DataBind();
        }

        protected void btnOpenAddUser_Click(object sender, EventArgs e)
        {
            hfUserId.Value = "0";
            txtUserName.Text = "";
            txtUserEmail.Text = "";
            txtUserPassword.Text = "Campus@123";
            litUserModalTitle.Text = "Add New Portal User";
            pnlUserModal.Visible = true;
        }

        protected void btnSaveUser_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int id = Convert.ToInt32(hfUserId.Value);
            string name = txtUserName.Text.Trim();
            string email = txtUserEmail.Text.Trim();
            string role = ddlUserRole.SelectedValue;
            string dept = ddlUserDept.SelectedValue;
            string pass = !string.IsNullOrEmpty(txtUserPassword.Text) ? txtUserPassword.Text.Trim() : "Campus@123";

            lock (DataStore.Users)
            {
                if (id == 0)
                {
                    // Check duplicate
                    if (DataStore.Users.Any(u => u.Email.Equals(email, StringComparison.OrdinalIgnoreCase)))
                    {
                        pnlNotice.CssClass = "alert alert-danger py-2 small mb-4";
                        pnlNotice.Visible = true;
                        litNotice.Text = "A user with this email already exists.";
                        return;
                    }

                    int newId = DataStore.Users.Count > 0 ? DataStore.Users.Max(u => u.Id) + 1 : 1;
                    string prefix = role == "Student" ? "2024-" : (role == "Faculty" ? "F-" : "ADM-");
                    DataStore.Users.Add(new User
                    {
                        Id = newId,
                        FullName = name,
                        Email = email,
                        Role = role,
                        Department = dept,
                        Password = pass,
                        IdentifierNumber = $"{prefix}{7000 + newId}",
                        Phone = "+91 98765 00000",
                        IsActive = true,
                        LastLogin = DateTime.Now
                    });

                    DataStore.LogAudit("User Created", AuthHelper.CurrentName, $"Created user {name} ({email}) with role {role}.");
                }
                else
                {
                    var user = DataStore.Users.FirstOrDefault(u => u.Id == id);
                    if (user != null)
                    {
                        user.FullName = name;
                        user.Email = email;
                        user.Role = role;
                        user.Department = dept;
                        if (!string.IsNullOrEmpty(txtUserPassword.Text))
                        {
                            user.Password = txtUserPassword.Text.Trim();
                        }

                        DataStore.LogAudit("User Updated", AuthHelper.CurrentName, $"Updated profile for {name} ({email}).");
                    }
                }
            }

            pnlUserModal.Visible = false;
            pnlNotice.CssClass = "alert alert-success py-2 small mb-4";
            pnlNotice.Visible = true;
            litNotice.Text = $"User '{name}' saved successfully in memory.";
            BindUsers();
        }

        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ToggleActive")
            {
                var user = DataStore.Users.FirstOrDefault(u => u.Id == id);
                if (user != null)
                {
                    if (user.IsActive)
                    {
                        // Strict check: Do not allow the last active administrator account to be deactivated
                        if (user.Role == "Admin")
                        {
                            int activeAdmins = DataStore.Users.Count(u => u.Role == "Admin" && u.IsActive);
                            if (activeAdmins <= 1)
                            {
                                pnlNotice.CssClass = "alert alert-danger py-2 small mb-4";
                                pnlNotice.Visible = true;
                                litNotice.Text = "Security Policy: Cannot deactivate the last remaining active Administrator account.";
                                return;
                            }
                        }

                        user.IsActive = false;
                        DataStore.LogAudit("User Deactivated", AuthHelper.CurrentName, $"Deactivated account for {user.FullName} ({user.Email}).");
                        pnlNotice.CssClass = "alert alert-warning py-2 small mb-4";
                        pnlNotice.Visible = true;
                        litNotice.Text = $"User '{user.FullName}' deactivated.";
                    }
                    else
                    {
                        user.IsActive = true;
                        DataStore.LogAudit("User Activated", AuthHelper.CurrentName, $"Activated account for {user.FullName} ({user.Email}).");
                        pnlNotice.CssClass = "alert alert-success py-2 small mb-4";
                        pnlNotice.Visible = true;
                        litNotice.Text = $"User '{user.FullName}' activated.";
                    }

                    BindUsers();
                }
            }
            else if (e.CommandName == "EditUser")
            {
                var user = DataStore.Users.FirstOrDefault(u => u.Id == id);
                if (user != null)
                {
                    hfUserId.Value = user.Id.ToString();
                    txtUserName.Text = user.FullName;
                    txtUserEmail.Text = user.Email;
                    ddlUserRole.SelectedValue = user.Role;
                    ddlUserDept.SelectedValue = user.Department;
                    txtUserPassword.Text = "";
                    litUserModalTitle.Text = "Edit User Details";
                    pnlUserModal.Visible = true;
                }
            }
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            pnlUserModal.Visible = false;
        }
    }
}
