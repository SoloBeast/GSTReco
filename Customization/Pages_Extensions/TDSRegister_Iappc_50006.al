pageextension 50006 "TDS Register Ext." extends "TDS Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document No.")
        {
            field("External Doc. No."; Rec."External Doc. No.")
            {
                ApplicationArea = all;
            }
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Vendor No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = all;
            }
            field("Expense G/L Account"; Rec."Expense G/L Account")
            {
                ApplicationArea = all;
            }
            field(Narration; Rec.Narration)
            {
                ApplicationArea = all;
            }
        }
        modify("Act Applicable")
        {
            Visible = false;
        }
        modify("TDS Paid")
        {
            Visible = false;
        }
        modify("Per Contract")
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