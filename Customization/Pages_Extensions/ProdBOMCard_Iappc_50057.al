pageextension 50057 "Prod. BOM Card Ext." extends "Production BOM"
{
    layout
    {
        // Add changes to page layout here
        modify("Version Nos.")
        {
            Visible = false;
        }
        modify(ActiveVersionCode)
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("Ma&trix per Version")
        {
            Visible = false;
        }
    }

    var
}