pageextension 50073 "Item Reclassification Ext." extends "Item Reclass. Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Applies-to Entry") { Visible = false; }
    }

    actions
    {
        // Add changes to page actions here
        modify("Bin Contents") { Visible = false; }
        modify("F&unctions") { Visible = false; }
    }

    var
}