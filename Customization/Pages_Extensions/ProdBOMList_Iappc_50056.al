pageextension 50056 "Prod. BOM List Ext." extends "Production BOM List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify("Exchange Production BOM Item")
        {
            Visible = false;
        }
        modify("Delete Expired Components")
        {
            Visible = false;
        }
        modify("Ma&trix per Version")
        {
            Visible = false;
        }
    }

    var
}