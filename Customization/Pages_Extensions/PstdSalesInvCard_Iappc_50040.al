pageextension 50040 "Pstd. Sales Invoice Card Ext." extends "Posted Sales Invoice"
{
    Editable = false;

    layout
    {
        // Add changes to page layout here
        modify("Document Date")
        {
            Visible = false;
        }
        modify("Quote No.")
        {
            Visible = false;
        }
        // modify("Company Bank Account Code")
        // {
        //     Visible = false;
        // }
        modify("LR/RR Date")
        {
            Visible = false;
        }
        modify("LR/RR No.")
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
        modify("Date of Removal")
        {
            Visible = false;
        }
        modify("Time of Removal")
        {
            Visible = false;
        }
        modify("Mode of Transport")
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
        modify("No. Printed")
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
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify("Direct Debit Mandate ID")
        {
            Visible = false;
        }
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("Reference Invoice No.")
        {
            Visible = false;
        }
        modify("GST Invoice")
        {
            Visible = false;
        }
        modify("Payment Date")
        {
            Visible = false;
        }
        modify("E-Way Bill No.")
        {
            Visible = false;
        }
        modify("Acknowledgement No.")
        {
            Visible = false;
        }
        modify("Acknowledgement Date")
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
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Payment Method Code")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
        }
        modify(Control15)
        {
            Visible = false;
        }
        addafter("Customer Posting Group")
        {
            field("Internal Document Type"; Rec."Internal Document Type")
            {
                ApplicationArea = all;
                Visible = true;
            }
        }
        moveafter("Internal Document Type"; "Location Code")
        moveafter("Location Code"; "Shipping Agent Code")
        moveafter("Shipping Agent Code"; "Currency Code")
        moveafter("Currency Code"; "Company Bank Account Code")
    }

    actions
    {
        // Add changes to page actions here
        modify(Print)
        {
            Visible = false;
        }
        modify("&Track Package")
        {
            Visible = false;
        }
        modify(ChangePaymentService)
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
        modify(ActivityLog)
        {
            Visible = false;
        }
        modify(IncomingDocument)
        {
            Visible = false;
        }
        modify("Generate IRN")
        {
            Visible = false;
        }
        modify("Cancel E-Invoice")
        {
            Visible = false;
        }
    }

    var
}