pageextension 50078 "Pstd. Sales Cr. Memo" extends "Posted Sales Credit Memo"
{
    Editable = false;

    layout
    {
        // Add changes to page layout here
        modify("E-Comm. Merchant Id")
        {
            Visible = false;
        }
        modify("e-Commerce Customer")
        {
            Visible = false;
        }
        modify("e-Commerce Merchant Id")
        {
            Visible = false;
        }
        modify("Distance (Km)")
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
        modify("Reference Invoice No.")
        {
            Visible = false;
        }
        modify("Sale Return Type")
        {
            Visible = false;
        }
        modify("Acknowledgement Date")
        {
            Visible = false;
        }
        modify("Acknowledgement No.")
        {
            Visible = false;
        }
        modify("IRN Hash")
        {
            Visible = false;
        }
        modify("E-Inv. Cancelled Date")
        {
            Visible = false;
        }
        modify("Cancel Reason")
        {
            Visible = false;
        }
        modify("EU 3-Party Trade")
        {
            Visible = false;
        }
        modify("Payment Method Code")
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
        modify("Generate E-Invoice")
        {
            Visible = false;
        }
        modify("Import E-Invoice Response")
        {
            Visible = false;
        }
        modify(Print)
        {
            Visible = false;
        }
        modify("F&unctions")
        {
            Visible = false;
        }
        modify("Generate IRN")
        {
            Visible = false;
        }
        modify(ActivityLog)
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