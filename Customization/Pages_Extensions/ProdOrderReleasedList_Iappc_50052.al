pageextension 50052 "Prod. Order Released List Ext." extends "Production Order List"
{
    layout
    {
        // Add changes to page layout here
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify(Status)
        {
            Visible = false;
        }
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
        modify("&Warehouse Entries")
        {
            Visible = false;
        }
    }

    var
}