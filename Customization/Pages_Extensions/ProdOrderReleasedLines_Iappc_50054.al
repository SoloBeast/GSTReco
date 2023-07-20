pageextension 50054 "Prod. Order Line Released Ext." extends "Released Prod. Order Lines"
{
    layout
    {
        // Add changes to page layout here
        modify("Subcontracting Order No.")
        {
            Visible = false;
        }
        modify("Subcontractor Code")
        {
            Visible = false;
        }
        modify("Unit Cost")
        {
            Visible = false;
        }
        modify("Cost Amount")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("&Reserve")
        {
            Visible = false;
        }
        modify("Order &Tracking")
        {
            Visible = false;
        }
        modify(ReservationEntries)
        {
            Visible = false;
        }
    }

    var
}