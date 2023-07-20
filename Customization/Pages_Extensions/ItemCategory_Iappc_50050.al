pageextension 50050 "Item Category Ext." extends "Item Categories"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Purchase QC Required"; Rec."Purchase QC Required")
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