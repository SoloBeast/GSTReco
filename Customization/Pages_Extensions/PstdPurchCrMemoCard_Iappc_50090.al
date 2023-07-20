pageextension 50090 "Pstd. Purch.Cr.Memo Card Ext." extends "Posted Purchase Credit Memo"
{
    Editable = false;

    layout
    {
        // Add changes to page layout here
        modify("Document Date")
        {
            Visible = false;
        }
        modify("VAT Reporting Date")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Vehicle No.")
        {
            Visible = false;
        }
        modify("Vehicle Type")
        {
            Visible = false;
        }
        modify("Distance (Km)")
        {
            Visible = false;
        }
        modify("Shipping Agent Code")
        {
            Visible = false;
        }
        modify("Order Address Code")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("No. Printed")
        {
            Visible = false;
        }
        modify("GST Invoice")
        {
            Visible = false;
        }
        modify("Associated Enterprises")
        {
            Visible = false;
        }
        modify("Rate Change Applicable")
        {
            Visible = false;
        }
        modify("Supply Finish Date")
        {
            Visible = false;
        }
        modify("GST Reason Type")
        {
            Visible = false;
        }
        modify("E-Way Bill No.")
        {
            Visible = false;
        }
        modify("Reference Invoice No.")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("&Print")
        {
            Visible = false;
        }
        modify(IncomingDocument)
        {
            Visible = false;
        }
    }

    var
}