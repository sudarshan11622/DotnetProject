using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Data;
using Campusaid.Helpers;
using Campusaid.Models;

namespace Campusaid.Student
{
    public partial class Profile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Student");

            if (!IsPostBack)
            {
                BindProfileData();
                BindContacts();
            }
        }

        private void BindProfileData()
        {
            var user = AuthHelper.GetCurrentUser();
            if (user != null)
            {
                litFullName.Text = user.FullName;
                litIdentifier.Text = !string.IsNullOrEmpty(user.IdentifierNumber) ? $"ID: {user.IdentifierNumber}" : "ID: 2024-8941";
                litDept.Text = $"Dept: {user.Department}";
                litEmail.Text = user.Email;
                litPhone.Text = user.Phone;

                txtEditName.Text = user.FullName;
                txtEditPhone.Text = user.Phone;

                chkPrefSms.Checked = user.PrefSms;
                chkPrefPush.Checked = user.PrefPush;
                chkPrefVoice.Checked = user.PrefVoice;
            }
        }

        private void BindContacts()
        {
            string email = AuthHelper.CurrentEmail;
            var list = DataStore.EmergencyContacts
                .Where(c => c.StudentEmail.Equals(email, StringComparison.OrdinalIgnoreCase))
                .ToList();

            rptContacts.DataSource = list;
            rptContacts.DataBind();

            pnlNoContacts.Visible = list.Count == 0;
            rptContacts.Visible = list.Count > 0;
        }

        protected void btnEditProfileToggle_Click(object sender, EventArgs e)
        {
            pnlProfileView.Visible = false;
            pnlProfileEdit.Visible = true;
            btnEditProfileToggle.Visible = false;
        }

        protected void btnCancelProfile_Click(object sender, EventArgs e)
        {
            pnlProfileView.Visible = true;
            pnlProfileEdit.Visible = false;
            btnEditProfileToggle.Visible = true;
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            var user = AuthHelper.GetCurrentUser();
            if (user != null)
            {
                user.FullName = txtEditName.Text.Trim();
                user.Phone = txtEditPhone.Text.Trim();
                Session[AuthHelper.SessionUserName] = user.FullName;

                DataStore.LogAudit("Profile Updated", user.FullName, "Student modified personal contact profile.");
            }

            pnlNotice.Visible = true;
            litNotice.Text = "Profile details updated successfully!";

            BindProfileData();
            pnlProfileView.Visible = true;
            pnlProfileEdit.Visible = false;
            btnEditProfileToggle.Visible = true;
        }

        protected void btnSavePreferences_Click(object sender, EventArgs e)
        {
            var user = AuthHelper.GetCurrentUser();
            if (user != null)
            {
                user.PrefSms = chkPrefSms.Checked;
                user.PrefPush = chkPrefPush.Checked;
                user.PrefVoice = chkPrefVoice.Checked;

                DataStore.LogAudit("Notification Preferences Updated", user.FullName, 
                    $"Preferences: SMS={user.PrefSms}, Push={user.PrefPush}, Voice={user.PrefVoice}");
            }

            pnlNotice.Visible = true;
            litNotice.Text = "Emergency Alerts Pathway Preferences updated!";
        }

        protected void btnShowAddContact_Click(object sender, EventArgs e)
        {
            hfContactId.Value = "0";
            txtContactName.Text = "";
            txtContactPhone.Text = "";
            txtContactRel.Text = "";
            litContactFormTitle.Text = "Add Emergency Contact";
            pnlContactForm.Visible = true;
        }

        protected void btnCancelContact_Click(object sender, EventArgs e)
        {
            pnlContactForm.Visible = false;
        }

        protected void btnSaveContact_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int id = Convert.ToInt32(hfContactId.Value);
            string name = txtContactName.Text.Trim();
            string phone = txtContactPhone.Text.Trim();
            string priority = ddlContactPriority.SelectedValue;
            string rel = txtContactRel.Text.Trim();
            string email = AuthHelper.CurrentEmail;

            lock (DataStore.EmergencyContacts)
            {
                if (id == 0)
                {
                    // Add new
                    int newId = DataStore.EmergencyContacts.Count > 0 ? DataStore.EmergencyContacts.Max(c => c.Id) + 1 : 1;
                    DataStore.EmergencyContacts.Add(new EmergencyContact
                    {
                        Id = newId,
                        StudentEmail = email,
                        Name = name,
                        Phone = phone,
                        Priority = priority,
                        Relationship = rel
                    });

                    DataStore.LogAudit("Contact Added", AuthHelper.CurrentName, $"Added emergency contact: {name} ({priority})");
                }
                else
                {
                    // Edit
                    var contact = DataStore.EmergencyContacts.FirstOrDefault(c => c.Id == id);
                    if (contact != null)
                    {
                        contact.Name = name;
                        contact.Phone = phone;
                        contact.Priority = priority;
                        contact.Relationship = rel;

                        DataStore.LogAudit("Contact Modified", AuthHelper.CurrentName, $"Updated emergency contact: {name}");
                    }
                }
            }

            pnlContactForm.Visible = false;
            pnlNotice.Visible = true;
            litNotice.Text = "Emergency contact saved successfully!";

            BindContacts();
        }

        protected void rptContacts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditContact")
            {
                var contact = DataStore.EmergencyContacts.FirstOrDefault(c => c.Id == id);
                if (contact != null)
                {
                    hfContactId.Value = contact.Id.ToString();
                    txtContactName.Text = contact.Name;
                    txtContactPhone.Text = contact.Phone;
                    ddlContactPriority.SelectedValue = contact.Priority;
                    txtContactRel.Text = contact.Relationship;
                    litContactFormTitle.Text = "Edit Emergency Contact";
                    pnlContactForm.Visible = true;
                }
            }
            else if (e.CommandName == "DeleteContact")
            {
                lock (DataStore.EmergencyContacts)
                {
                    var contact = DataStore.EmergencyContacts.FirstOrDefault(c => c.Id == id);
                    if (contact != null)
                    {
                        DataStore.EmergencyContacts.Remove(contact);
                        DataStore.LogAudit("Contact Removed", AuthHelper.CurrentName, $"Removed emergency contact: {contact.Name}");
                    }
                }

                pnlNotice.Visible = true;
                litNotice.Text = "Emergency contact removed.";
                BindContacts();
            }
        }
    }
}
