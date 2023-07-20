pageextension 50068 "Invt. Shipment SubPage Ext." extends "Invt. Shipment Subform"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify("Reserve from &Inventory")
        {
            Visible = false;
        }
    }

    var
}