pageextension 50065 "Inventory Receipt Card Ext." extends "Invt. Receipt"
{
    layout
    {
        // Add changes to page layout here
        modify("Posting Description")
        {
            Visible = false;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify(Correction)
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