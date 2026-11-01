using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Web;
using Campusaid.Models;

namespace Campusaid.Helpers
{
    public static class CsvHelper
    {
        public static void ExportIncidentReports(IEnumerable<IncidentReport> reports, string fileNamePrefix = "CampusAid_Incidents")
        {
            var sb = new StringBuilder();
            sb.AppendLine("Case ID,Reporter,Role,Incident Type,Location,Severity,Status,Date Filed,Assigned Officer,Affected Count");

            foreach (var r in reports)
            {
                sb.AppendLine(string.Format("\"{0}\",\"{1}\",\"{2}\",\"{3}\",\"{4}\",\"{5}\",\"{6}\",\"{7}\",\"{8}\",{9}",
                    Escape(r.CaseNumber),
                    Escape(r.ReporterName),
                    Escape(r.ReporterRole),
                    Escape(r.IncidentType),
                    Escape(r.Location),
                    Escape(r.Severity),
                    Escape(r.Status),
                    r.DateFiled.ToString("yyyy-MM-dd HH:mm"),
                    Escape(r.AssignedOfficer),
                    r.AffectedCount
                ));
            }

            DownloadCsv(sb.ToString(), $"{fileNamePrefix}_{DateTime.Now:yyyyMMdd_HHmmss}.csv");
        }

        public static void ExportAuditLogs(IEnumerable<AuditLog> logs, string fileNamePrefix = "CampusAid_AuditLogs")
        {
            var sb = new StringBuilder();
            sb.AppendLine("ID,Timestamp,User,Action,Details");

            foreach (var l in logs)
            {
                sb.AppendLine(string.Format("{0},\"{1}\",\"{2}\",\"{3}\",\"{4}\"",
                    l.Id,
                    l.Timestamp.ToString("yyyy-MM-dd HH:mm:ss"),
                    Escape(l.User),
                    Escape(l.Action),
                    Escape(l.Details)
                ));
            }

            DownloadCsv(sb.ToString(), $"{fileNamePrefix}_{DateTime.Now:yyyyMMdd_HHmmss}.csv");
        }

        private static string Escape(string s)
        {
            if (string.IsNullOrEmpty(s)) return string.Empty;
            return s.Replace("\"", "\"\"");
        }

        private static void DownloadCsv(string csvContent, string fileName)
        {
            var response = HttpContext.Current.Response;
            response.Clear();
            response.Buffer = true;
            response.AddHeader("content-disposition", $"attachment;filename={fileName}");
            response.Charset = "";
            response.ContentType = "text/csv; charset=utf-8";
            response.Output.Write(csvContent);
            response.Flush();
            response.End();
        }
    }
}
