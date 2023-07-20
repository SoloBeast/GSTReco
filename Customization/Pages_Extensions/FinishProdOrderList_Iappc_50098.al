pageextension 50098 "Finish Prod. Order List Ext." extends "Finished Production Orders"
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
        modify("Due Date")
        {
            Visible = false;
        }
        modify("Assigned User ID")
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