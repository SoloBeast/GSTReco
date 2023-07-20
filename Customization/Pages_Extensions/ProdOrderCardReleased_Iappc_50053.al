pageextension 50053 "Prod. Order Card Released Ext." extends "Released Production Order"
{
    layout
    {
        // Add changes to page layout here
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Bin Code")
        {
            Visible = false;
        }
        modify(Schedule)
        {
            Visible = false;
        }

        moveafter("Search Description"; "Location Code")
    }

    actions
    {
        // Add changes to page actions here
        modify("Re&plan")
        {
            Visible = false;
        }
        modify("&Reserve")
        {
            Visible = false;
        }
        modify("C&opy Prod. Order Document")
        {
            Visible = false;
        }
        modify(OrderTracking)
        {
            Visible = false;
        }
        modify(Warehouse)
        {
            Visible = false;
        }
        modify(Planning)
        {
            Visible = false;
        }
        modify("Put-away/Pick Lines/Movement Lines")
        {
            Visible = false;
        }
        modify("Registered P&ick Lines")
        {
            Visible = false;
        }
        modify("Registered Invt. Movement Lines")
        {
            Visible = false;
        }
        modify("Subcontractor - Dispatch List")
        {
            Visible = false;
        }
    }

    var
}