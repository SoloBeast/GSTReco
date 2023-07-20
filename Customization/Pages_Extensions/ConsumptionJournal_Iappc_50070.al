pageextension 50070 "Consumption Journal Ext." extends "Consumption Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Order No.") { Visible = false; }
        modify("Order Line No.") { Visible = false; }
        modify("Prod. Order Comp. Line No.") { Visible = false; }
        modify("Unit Amount") { Visible = false; }
        modify("Applies-from Entry") { Visible = false; }
        modify("Applies-to Entry") { Visible = false; }
    }

    actions
    {
        // Add changes to page actions here
        modify("Bin Contents") { Visible = false; }
        modify("Capacity Ledger Entries") { Visible = false; }
    }

    var
}