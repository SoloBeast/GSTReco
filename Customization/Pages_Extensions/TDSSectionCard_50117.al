pageextension 50117 "TDS Section Card Ext." extends "TDS Section Card"
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