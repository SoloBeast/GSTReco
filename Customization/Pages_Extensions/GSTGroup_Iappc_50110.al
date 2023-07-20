pageextension 50110 "GST Group" extends "GST Group"
{
    layout
    {
        // Add changes to page layout here
        addafter("GST Group Type")
        {
            field("GST %"; Rec."GST %")
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