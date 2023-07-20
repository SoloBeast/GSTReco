pageextension 50108 "Prod. Journal Ext." extends "Production Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Setup Time")
        {
            Visible = false;
        }
        modify("Run Time")
        {
            Visible = false;
        }
        modify("Scrap Quantity")
        {
            Visible = false;
        }
        modify(ShortcutDimCode3)
        {
            Visible = false;
        }
        modify(ShortcutDimCode4)
        {
            Visible = false;
        }
        modify(ShortcutDimCode5)
        {
            Visible = false;
        }
        modify(ShortcutDimCode6)
        {
            Visible = false;
        }
        modify(ShortcutDimCode7)
        {
            Visible = false;
        }
        modify(ShortcutDimCode8)
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