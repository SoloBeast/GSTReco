pageextension 50109 "Prod. Order Component Ext." extends "Prod. Order Components"
{
    layout
    {
        // Add changes to page layout here
        modify("Substitution Available")
        {
            Visible = false;
        }
        modify("Bin Code")
        {
            Visible = false;
        }
        modify("Flushing Method")
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