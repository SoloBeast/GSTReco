pageextension 50063 "Transfer Order Card Ext." extends "Transfer Order"
{
    layout
    {
        // Add changes to page layout here
        modify("Direct Transfer")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Load Unreal Prof Amt on Invt.")
        {
            Visible = false;
        }
        modify("Outbound Whse. Handling Time")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Shipping Agent Service Code")
        {
            Visible = false;
        }
        modify("Shipping Advice")
        {
            Visible = false;
        }
        modify("Receipt Date")
        {
            Visible = false;
        }
        modify("Inbound Whse. Handling Time")
        {
            Visible = false;
        }
        modify("Transaction Type")
        {
            Visible = false;
        }
        modify("Transaction Specification")
        {
            Visible = false;
        }
        modify("Area")
        {
            Visible = false;
        }
        modify("Entry/Exit Point")
        {
            Visible = false;
        }
        modify(GST)
        {
            Visible = false;
        }
        modify(Control19)
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("Inventory - Inbound Transfer")
        {
            Visible = false;
        }
        modify("F&unctions")
        {
            Visible = false;
        }
        modify(Warehouse)
        {
            Visible = false;
        }
    }

    var
}