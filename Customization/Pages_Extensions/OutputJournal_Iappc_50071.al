pageextension 50071 "Output Journal Ext." extends "Output Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Operation No.") { Visible = false; }
        modify("Order Line No.") { Visible = false; }
        modify("No.") { Visible = false; }
        modify("Cap. Unit of Measure Code") { Visible = false; }
        modify("Applies-to Entry") { Visible = false; }
        modify("Location Code") { Visible = true; }
        modify("Output Quantity") { Visible = true; }
    }

    actions
    {
        // Add changes to page actions here
        modify("Bin Contents") { Visible = false; }
        modify("Capacity Ledger Entries") { Visible = false; }
    }

    var
}