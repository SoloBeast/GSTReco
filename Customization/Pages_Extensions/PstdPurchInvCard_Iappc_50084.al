pageextension 50084 "Pstd. Purch. Inv Card Ext." extends "Posted Purchase Invoice"
{
    Editable = false;

    layout
    {
        // Add changes to page layout here
        addafter("Payment Terms Code")
        {
            field("Due Date Calc. Basis"; Rec."Due Date Calc. Basis")
            {
                ApplicationArea = all;
            }
        }
        modify("Quote No.")
        {
            Visible = false;
        }
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
        modify("Remit-to")
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
        modify("Vendor Order No.")
        {
            Visible = false;
        }
        modify("No. Printed")
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
        modify("E-Way Bill No.")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
        {
            Visible = false;
        }
        modify("Payment Method Code")
        {
            Visible = false;
        }
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
        }
        modify("Payment Reference")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Print)
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