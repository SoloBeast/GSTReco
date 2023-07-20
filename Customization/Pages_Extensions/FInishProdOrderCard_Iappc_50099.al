pageextension 50099 "Finish Prod. Order Card. Ext." extends "Finished Production Order"
{
    layout
    {
        // Add changes to page layout here
        modify(Schedule)
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("Registered P&ick Lines")
        {
            Visible = false;
        }
        modify("<Action2>")
        {
            Visible = false;
        }
    }

    var
}