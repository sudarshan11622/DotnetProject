<%@ Page Title="Contact CampusAid" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="Campusaid.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
        <h2 id="title"><%: Title %></h2>
        <h3>Campus Emergency & Safety Assistance</h3>
        <address>
            RK University Campus<br />
            Bhavnagar Highway, Kasturbadham, Rajkot, Gujarat 360020<br />
            <abbr title="Phone">Phone:</abbr>
            <a href="tel:+919876543210">+91 98765 43210</a>
        </address>

        <address>
            <strong>Support:</strong> <a href="mailto:support@rku.ac.in">support@rku.ac.in</a><br />
            <strong>Safety Command:</strong> <a href="mailto:safety@rku.ac.in">safety@rku.ac.in</a>
        </address>
    </main>
</asp:Content>
