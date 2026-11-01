using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Data;
using Campusaid.Helpers;
using Campusaid.Models;

namespace Campusaid.Admin
{
    public partial class Resources : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Admin");

            if (!IsPostBack)
            {
                BindAll();
            }
        }

        private void BindAll()
        {
            rptResources.DataSource = DataStore.EmergencyResources.Where(r => r.IsActive).ToList();
            rptResources.DataBind();

            rptProtocols.DataSource = DataStore.ProtocolDocuments.ToList();
            rptProtocols.DataBind();
        }

        protected void btnOpenAddResource_Click(object sender, EventArgs e)
        {
            hfResourceId.Value = "0";
            txtResName.Text = "";
            txtResExt.Text = "EXT. ";
            txtResPhone.Text = "+91 ";
            txtResLocation.Text = "";
            txtResHours.Text = "08:00 AM - 18:00 PM";
            txtResDesc.Text = "";
            litResourceModalTitle.Text = "Add New Emergency Resource";
            pnlResourceModal.Visible = true;
        }

        protected void btnSaveResource_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int id = Convert.ToInt32(hfResourceId.Value);
            string name = txtResName.Text.Trim();
            string cat = ddlResCategory.SelectedValue;
            string ext = txtResExt.Text.Trim();
            string phone = txtResPhone.Text.Trim();
            string loc = txtResLocation.Text.Trim();
            string hours = txtResHours.Text.Trim();
            string desc = txtResDesc.Text.Trim();

            lock (DataStore.EmergencyResources)
            {
                if (id == 0)
                {
                    int newId = DataStore.EmergencyResources.Count > 0 ? DataStore.EmergencyResources.Max(r => r.Id) + 1 : 1;
                    DataStore.EmergencyResources.Add(new EmergencyResource
                    {
                        Id = newId,
                        Name = name,
                        Category = cat,
                        Extension = ext,
                        Phone = phone,
                        Location = loc,
                        OperatingHours = hours,
                        Description = desc,
                        IsActive = true
                    });
                    DataStore.LogAudit("Resource Added", AuthHelper.CurrentName, $"Added emergency listing: {name} ({ext})");
                }
                else
                {
                    var res = DataStore.EmergencyResources.FirstOrDefault(r => r.Id == id);
                    if (res != null)
                    {
                        res.Name = name;
                        res.Category = cat;
                        res.Extension = ext;
                        res.Phone = phone;
                        res.Location = loc;
                        res.OperatingHours = hours;
                        res.Description = desc;
                        DataStore.LogAudit("Resource Modified", AuthHelper.CurrentName, $"Updated emergency listing #{id}: {name}");
                    }
                }
            }

            pnlResourceModal.Visible = false;
            pnlNotice.Visible = true;
            litNotice.Text = $"Emergency resource '{name}' saved successfully and updated in Student & Faculty portals!";
            BindAll();
        }

        protected void rptResources_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditRes")
            {
                var res = DataStore.EmergencyResources.FirstOrDefault(r => r.Id == id);
                if (res != null)
                {
                    hfResourceId.Value = res.Id.ToString();
                    txtResName.Text = res.Name;
                    ddlResCategory.SelectedValue = res.Category;
                    txtResExt.Text = res.Extension;
                    txtResPhone.Text = res.Phone;
                    txtResLocation.Text = res.Location;
                    txtResHours.Text = res.OperatingHours;
                    txtResDesc.Text = res.Description;
                    litResourceModalTitle.Text = "Edit Emergency Resource";
                    pnlResourceModal.Visible = true;
                }
            }
            else if (e.CommandName == "DeleteRes")
            {
                var res = DataStore.EmergencyResources.FirstOrDefault(r => r.Id == id);
                if (res != null)
                {
                    res.IsActive = false;
                    DataStore.LogAudit("Resource Deactivated", AuthHelper.CurrentName, $"Deactivated directory resource #{id}: {res.Name}");
                    pnlNotice.Visible = true;
                    litNotice.Text = $"Resource '{res.Name}' removed from directory.";
                    BindAll();
                }
            }
        }

        // Protocol Documents Logic
        protected void btnOpenUploadProtocol_Click(object sender, EventArgs e)
        {
            hfProtocolId.Value = "0";
            txtProtoTitle.Text = "";
            txtProtoFormat.Text = "PDF (1.2MB)";
            txtProtoDesc.Text = "";
            litProtoModalTitle.Text = "Upload Protocol Document";
            pnlProtocolModal.Visible = true;
        }

        protected void btnSaveProtocol_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int id = Convert.ToInt32(hfProtocolId.Value);
            string title = txtProtoTitle.Text.Trim();
            string cat = ddlProtoCategory.SelectedValue;
            string format = txtProtoFormat.Text.Trim();
            string desc = txtProtoDesc.Text.Trim();

            if (fuProtoDoc.HasFile)
            {
                format = $"PDF ({fuProtoDoc.FileBytes.Length / 1024}KB)";
            }

            lock (DataStore.ProtocolDocuments)
            {
                if (id == 0)
                {
                    int newId = DataStore.ProtocolDocuments.Count > 0 ? DataStore.ProtocolDocuments.Max(p => p.Id) + 1 : 1;
                    DataStore.ProtocolDocuments.Add(new ProtocolDocument
                    {
                        Id = newId,
                        Title = title,
                        CategoryTag = cat,
                        Format = format,
                        LastUpdated = DateTime.Now.ToString("MMM dd, yyyy"),
                        Description = desc
                    });
                    DataStore.LogAudit("Protocol Uploaded", AuthHelper.CurrentName, $"Added protocol document: {title} [{cat}]");
                }
                else
                {
                    var proto = DataStore.ProtocolDocuments.FirstOrDefault(p => p.Id == id);
                    if (proto != null)
                    {
                        proto.Title = title;
                        proto.CategoryTag = cat;
                        proto.Format = format;
                        proto.LastUpdated = DateTime.Now.ToString("MMM dd, yyyy");
                        proto.Description = desc;
                        DataStore.LogAudit("Protocol Modified", AuthHelper.CurrentName, $"Updated protocol document #{id}: {title}");
                    }
                }
            }

            pnlProtocolModal.Visible = false;
            pnlNotice.Visible = true;
            litNotice.Text = $"Protocol document '{title}' saved successfully!";
            BindAll();
        }

        protected void rptProtocols_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditDoc")
            {
                var doc = DataStore.ProtocolDocuments.FirstOrDefault(p => p.Id == id);
                if (doc != null)
                {
                    hfProtocolId.Value = doc.Id.ToString();
                    txtProtoTitle.Text = doc.Title;
                    ddlProtoCategory.SelectedValue = doc.CategoryTag;
                    txtProtoFormat.Text = doc.Format;
                    txtProtoDesc.Text = doc.Description;
                    litProtoModalTitle.Text = "Edit Protocol Details";
                    pnlProtocolModal.Visible = true;
                }
            }
            else if (e.CommandName == "DownloadDoc")
            {
                var doc = DataStore.ProtocolDocuments.FirstOrDefault(p => p.Id == id);
                if (doc != null)
                {
                    DataStore.LogAudit("Admin Protocol Download", AuthHelper.CurrentName, $"Downloaded document: {doc.Title}");
                    string text = $"CAMPUSAID ADMINISTRATIVE PROTOCOL DOCUMENT\nTitle: {doc.Title}\nTag: {doc.CategoryTag}\nLast Updated: {doc.LastUpdated}\nDescription: {doc.Description}\nAuthorized by: System Administrator ({AuthHelper.CurrentName})";

                    Response.Clear();
                    Response.ContentType = "text/plain";
                    Response.AddHeader("content-disposition", $"attachment;filename={doc.Title.Replace(" ", "_")}.txt");
                    Response.BinaryWrite(Encoding.UTF8.GetBytes(text));
                    Response.End();
                }
            }
            else if (e.CommandName == "DeleteDoc")
            {
                var doc = DataStore.ProtocolDocuments.FirstOrDefault(p => p.Id == id);
                if (doc != null)
                {
                    DataStore.ProtocolDocuments.Remove(doc);
                    DataStore.LogAudit("Protocol Removed", AuthHelper.CurrentName, $"Removed protocol document #{id}: {doc.Title}");
                    pnlNotice.Visible = true;
                    litNotice.Text = $"Protocol document '{doc.Title}' deleted.";
                    BindAll();
                }
            }
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            pnlResourceModal.Visible = false;
            pnlProtocolModal.Visible = false;
        }

        protected string GetTagBadge(string tag)
        {
            if (tag.Equals("CRITICAL", StringComparison.OrdinalIgnoreCase)) return "badge-critical";
            if (tag.Equals("HAZMAT", StringComparison.OrdinalIgnoreCase)) return "badge-warning";
            return "badge-info";
        }
    }
}
