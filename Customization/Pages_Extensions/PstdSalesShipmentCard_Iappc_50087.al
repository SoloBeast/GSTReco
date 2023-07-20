pageextension 50087 "Pstd Sales Shipment Card Ext." extends "Posted Sales Shipment"
{
    Editable = false;

    layout
    {
        // Add changes to page layout here
        modify("No. Printed")
        {
            Visible = false;
        }
        modify("Requested Delivery Date")
        {
            Visible = false;
        }
        modify("Promised Delivery Date")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Work Description")
        {
            Visible = false;
        }
        modify("Outbound Whse. Handling Time")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Shipping Time")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("&Track Package")
        {
            Visible = false;
        }
        modify(CertificateOfSupplyDetails)
        {
            Visible = false;
        }
        modify(PrintCertificateofSupply)
        {
            Visible = false;
        }
        modify("Attached Gate Entry")
        {
            Visible = false;
        }
    }

    var
}