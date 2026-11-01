using System;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Data;
using Campusaid.Helpers;
using Campusaid.Models;

namespace Campusaid.Admin
{
    public partial class Announcements : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Admin");

            if (!IsPostBack)
            {
                BindAnnouncements();
            }
        }

        private void BindAnnouncements()
        {
            var list = DataStore.Announcements.OrderByDescending(a => a.PublishedDate).ToList();
            rptAnnouncements.DataSource = list;
            rptAnnouncements.DataBind();
        }

        protected void btnSaveDraft_Click(object sender, EventArgs e)
        {
            SaveAnnouncement("Draft");
        }

        protected void btnPublishNews_Click(object sender, EventArgs e)
        {
            SaveAnnouncement("Published");
        }

        private void SaveAnnouncement(string status)
        {
            if (!Page.IsValid) return;

            string title = txtAnnounceTitle.Text.Trim();
            string category = ddlAnnounceCategory.SelectedValue;
            string audience = ddlAudience.SelectedValue;
            string content = txtContent.Text.Trim();

            string attachName = null;
            if (fuAttachment.HasFile)
            {
                attachName = Path.GetFileName(fuAttachment.FileName);
            }

            var item = new Announcement
            {
                Id = DataStore.Announcements.Count > 0 ? DataStore.Announcements.Max(a => a.Id) + 1 : 1,
                Title = title,
                Category = category,
                TargetAudience = audience,
                Content = content,
                AttachmentName = attachName,
                PublishedDate = DateTime.Now,
                Status = status,
                Author = AuthHelper.CurrentName
            };

            lock (DataStore.Announcements)
            {
                DataStore.Announcements.Insert(0, item);
            }

            DataStore.LogAudit($"Announcement {status}", AuthHelper.CurrentName, $"Announcement '{title}' set to {status}.");

            pnlNotice.CssClass = "alert alert-success py-2 small mb-4";
            pnlNotice.Visible = true;
            litNotice.Text = $"Announcement '{title}' has been successfully {status.ToLower()} in memory.";

            // Reset
            txtAnnounceTitle.Text = "";
            txtContent.Text = "";

            BindAnnouncements();
        }

        protected void rptAnnouncements_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            var item = DataStore.Announcements.FirstOrDefault(a => a.Id == id);
            if (item != null)
            {
                if (e.CommandName == "Archive")
                {
                    item.Status = item.Status == "Archived" ? "Published" : "Archived";
                    DataStore.LogAudit("Announcement Status Changed", AuthHelper.CurrentName, $"Announcement #{id} status changed to {item.Status}.");
                    pnlNotice.CssClass = "alert alert-info py-2 small mb-4";
                    pnlNotice.Visible = true;
                    litNotice.Text = $"Announcement '{item.Title}' updated to {item.Status}.";
                }
                else if (e.CommandName == "Delete")
                {
                    DataStore.Announcements.Remove(item);
                    DataStore.LogAudit("Announcement Deleted", AuthHelper.CurrentName, $"Removed announcement #{id}: {item.Title}.");
                    pnlNotice.CssClass = "alert alert-warning py-2 small mb-4";
                    pnlNotice.Visible = true;
                    litNotice.Text = $"Announcement '{item.Title}' removed.";
                }

                BindAnnouncements();
            }
        }

        protected string GetStatusBadge(string s)
        {
            if (s.Equals("Published", StringComparison.OrdinalIgnoreCase)) return "badge-active";
            if (s.Equals("Draft", StringComparison.OrdinalIgnoreCase)) return "badge-warning";
            return "badge-inactive";
        }
    }
}
