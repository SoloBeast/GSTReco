pageextension 50003 "FA Setup Ext." extends "Fixed Asset Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Automatic Insurance Posting")
        {
            field("FA Dimension"; Rec."FA Dimension")
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