pageextension 50100 "Finish Prod. Order SPage Ext." extends "Finished Prod. Order Lines"
{
    layout
    {
        // Add changes to page layout here
        modify("Starting Date-Time")
        {
            Visible = false;
        }
        modify("Ending Date-Time")
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