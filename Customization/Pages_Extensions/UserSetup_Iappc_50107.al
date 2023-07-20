pageextension 50107 "User Setup Ext." extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Allow Posting To")
        {
            field("Default Location Code"; Rec."Default Location Code")
            {
                ApplicationArea = all;
            }
            field("Default Global Dimension 1"; Rec."Default Global Dimension 1")
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