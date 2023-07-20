pageextension 50062 "Transfer Order List Ext." extends "Transfer Orders"
{
    layout
    {
        // Add changes to page layout here
        modify("Direct Transfer")
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
        modify("Transfer Routes")
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