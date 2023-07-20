pageextension 50086 "Pstd. Sales Shipment List Ext." extends "Posted Sales Shipments"
{
    layout
    {
        // Add changes to page layout here
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("No. Printed")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("F&unctions")
        {
            Visible = true;
        }
        modify(CertificateOfSupplyDetails)
        {
            Visible = true;
        }
        modify(PrintCertificateofSupply)
        {
            Visible = true;
        }
    }

    var
}