pageextension 50059 "Routing List Ext." extends "Routing List"
{
    layout
    {
        // Add changes to page layout here
        modify("Version Nos.")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("&Versions")
        {
            Visible = false;
        }
    }

    var
}