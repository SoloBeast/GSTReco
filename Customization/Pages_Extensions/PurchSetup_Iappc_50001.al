pageextension 50001 "Purch. Setup Ext." extends "Purchases & Payables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Ignore Updated Addresses")
        {
            field("Vendor Dimension"; Rec."Vendor Dimension")
            {
                ApplicationArea = all;
            }
            field("Term 1"; Rec."Term 1")
            {
                ApplicationArea = all;
            }
            field("Term 2"; Rec."Term 2")
            {
                ApplicationArea = all;
            }
            field("Term 3"; Rec."Term 3")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}