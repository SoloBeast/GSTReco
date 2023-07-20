pageextension 50060 "Routing Card Ext." extends Routing
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
        modify("&Versions")
        {
            Visible = false;
        }
    }

    var
}