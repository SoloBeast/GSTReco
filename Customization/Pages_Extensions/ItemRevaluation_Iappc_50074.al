pageextension 50074 "Item Revaluation Ext." extends "Revaluation Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify("Calculate Inventory Value") { Visible = false; }
        modify("Calculate Inventory Value - Test") { Visible = false; }
    }

    var
}