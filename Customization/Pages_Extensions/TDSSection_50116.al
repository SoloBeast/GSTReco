pageextension 50116 "TDS Section Ext." extends "TDS Sections"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("206 AB"; Rec."206 AB")
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