pageextension 50103 "Purch.CrMemo SubPage Ext." extends "Purch. Cr. Memo Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("GST Credit")
        {
            field("Iappc TDS Section"; Rec."Iappc TDS Section")
            {
                ApplicationArea = all;
            }
            field("TDS %"; Rec."TDS %")
            {
                ApplicationArea = all;
            }
            field("TDS Amount"; Rec."TDS Amount")
            {
                ApplicationArea = all;
            }
        }
        modify("Deferral Code")
        {
            Visible = true;
        }
        moveafter("Gen. Prod. Posting Group"; "Deferral Code")
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Location Code")
        {
            Visible = true;
        }
        modify("GST Group Code")
        {
            Visible = true;
        }
        modify("HSN/SAC Code")
        {
            Visible = true;
        }
        modify("Item Reference No.")
        {
            Visible = false;
        }
        modify("Total VAT Amount")
        {
            Visible = false;
        }
        modify("Total Amount Excl. VAT")
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