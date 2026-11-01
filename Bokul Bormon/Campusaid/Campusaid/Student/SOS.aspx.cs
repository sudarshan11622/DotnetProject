using System;
using System.Linq;
using System.Web.UI;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.Student
{
    public partial class SOS : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Student");

            if (!IsPostBack)
            {
                // Check if user already has an active emergency event
                string email = AuthHelper.CurrentEmail;
                var activeEvt = DataStore.EmergencyEvents.FirstOrDefault(ev => ev.InitiatorEmail.Equals(email, StringComparison.OrdinalIgnoreCase) && ev.Status == "ACTIVE DISPATCH");
                if (activeEvt != null)
                {
                    ShowActiveSos(activeEvt.LocationCoordinates, activeEvt.Timestamp);
                }
            }
        }

        protected void btnSosTrigger_Click(object sender, EventArgs e)
        {
            string email = AuthHelper.CurrentEmail;
            string name = AuthHelper.CurrentName;
            string location = !string.IsNullOrEmpty(txtManualLocation.Text) ? txtManualLocation.Text.Trim() : lblBroadcastingLocation.Text;

            var evt = DataStore.TriggerSOS(name, email, "Student", location);
            ShowActiveSos(evt.LocationCoordinates, evt.Timestamp);
        }

        protected void btnUpdateLocation_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrWhiteSpace(txtManualLocation.Text))
            {
                lblBroadcastingLocation.Text = txtManualLocation.Text.Trim();
                hfCurrentLocation.Value = txtManualLocation.Text.Trim();
            }
        }

        protected void btnCancelSos_Click(object sender, EventArgs e)
        {
            string email = AuthHelper.CurrentEmail;
            var activeEvt = DataStore.EmergencyEvents.FirstOrDefault(ev => ev.InitiatorEmail.Equals(email, StringComparison.OrdinalIgnoreCase) && ev.Status == "ACTIVE DISPATCH");
            if (activeEvt != null)
            {
                activeEvt.Status = "CANCELLED";
                DataStore.LogAudit("SOS Cancelled", AuthHelper.CurrentName, "Distress event cancelled by student.");
            }

            pnlSosActive.Visible = false;
        }

        private void ShowActiveSos(string coords, DateTime time)
        {
            pnlSosActive.Visible = true;
            litActiveCoords.Text = coords;
            litSosTimestamp.Text = time.ToString("hh:mm:ss tt");
        }
    }
}
