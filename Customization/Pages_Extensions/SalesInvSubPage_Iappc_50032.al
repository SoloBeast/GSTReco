pageextension 50032 "Sales Inv. Line Ext." extends "Sales Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = all;
            }
        }
        modify("Qty. to Invoice")
        {
            Visible = false;
        }
        modify("Tax Category")
        {
            Visible = false;
        }
        modify("Item Reference No.")
        {
            Visible = false;
        }
        modify("GST Assessable Value (LCY)")
        {
            Visible = false;
        }
        modify("GST on Assessable Value")
        {
            Visible = false;
        }
        modify("Total Amount Excl. VAT")
        {
            Visible = false;
        }
        modify("Total VAT Amount")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}