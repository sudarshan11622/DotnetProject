using System;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using Campusaid.Data;
using Campusaid.Helpers;

namespace Campusaid.Faculty
{
    public partial class Resources : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Faculty");

            if (!IsPostBack)
            {
                rptProtocols.DataSource = DataStore.ProtocolDocuments;
                rptProtocols.DataBind();
            }
        }

        protected void btnDownloadMap_Click(object sender, EventArgs e)
        {
            DataStore.LogAudit("Evacuation Map Download", AuthHelper.CurrentName, "Faculty retrieved High-Res Campus Evacuation Map.");
            
            // Generate simulated SVG campus evacuation map download
            string svg = @"<svg xmlns='http://www.w3.org/2000/svg' width='800' height='600' viewBox='0 0 800 600'>
  <rect width='800' height='600' fill='#0f172a'/>
  <text x='400' y='50' font-size='24' fill='#ffffff' font-family='sans-serif' text-anchor='middle' font-weight='bold'>CAMPUSAID — OFFICIAL CAMPUS EVACUATION MAP</text>
  <rect x='50' y='100' width='320' height='200' rx='10' fill='#1e293b' stroke='#2563eb' stroke-width='2'/>
  <text x='210' y='180' font-size='18' fill='#93c5fd' font-family='sans-serif' text-anchor='middle'>SECTOR A: ADMINISTRATION</text>
  <text x='210' y='210' font-size='14' fill='#cbd5e1' font-family='sans-serif' text-anchor='middle'>Assembly Point: Quad Flagpole</text>
  <rect x='430' y='100' width='320' height='200' rx='10' fill='#1e293b' stroke='#dc2626' stroke-width='2'/>
  <text x='590' y='180' font-size='18' fill='#fca5a5' font-family='sans-serif' text-anchor='middle'>SECTOR B: SCIENCE &amp; LABS</text>
  <text x='590' y='210' font-size='14' fill='#cbd5e1' font-family='sans-serif' text-anchor='middle'>Assembly Point: South Lawn</text>
  <rect x='50' y='340' width='320' height='200' rx='10' fill='#1e293b' stroke='#059669' stroke-width='2'/>
  <text x='210' y='420' font-size='18' fill='#86efac' font-family='sans-serif' text-anchor='middle'>SECTOR C: TECH &amp; LIBRARY</text>
  <text x='210' y='450' font-size='14' fill='#cbd5e1' font-family='sans-serif' text-anchor='middle'>Assembly Point: East Parking</text>
  <rect x='430' y='340' width='320' height='200' rx='10' fill='#1e293b' stroke='#d97706' stroke-width='2'/>
  <text x='590' y='420' font-size='18' fill='#fde047' font-family='sans-serif' text-anchor='middle'>SECTOR D: OPERATIONS DEPOT</text>
  <text x='590' y='450' font-size='14' fill='#cbd5e1' font-family='sans-serif' text-anchor='middle'>Assembly Point: Sports Track</text>
</svg>";

            Response.Clear();
            Response.ContentType = "image/svg+xml";
            Response.AddHeader("content-disposition", "attachment;filename=Campus_Evacuation_Map_2026.svg");
            Response.BinaryWrite(Encoding.UTF8.GetBytes(svg));
            Response.End();
        }

        protected void btnDownloadDoc_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            string docTitle = btn.CommandArgument;
            DataStore.LogAudit("Protocol Document Download", AuthHelper.CurrentName, $"Downloaded protocol document: {docTitle}");

            string text = $"CAMPUSAID SAFETY PROTOCOL DOCUMENT\nTitle: {docTitle}\nSecurity Clearance: Faculty\nVerified by: Campus Safety Administration\nTimestamp: {DateTime.Now:yyyy-MM-dd HH:mm:ss}\n\nContents: Official standard operating procedures for {docTitle}. Ensure floor sweep coordination with appointed safety marshals.";

            Response.Clear();
            Response.ContentType = "text/plain";
            Response.AddHeader("content-disposition", $"attachment;filename={docTitle.Replace(" ", "_")}.txt");
            Response.BinaryWrite(Encoding.UTF8.GetBytes(text));
            Response.End();
        }
    }
}
