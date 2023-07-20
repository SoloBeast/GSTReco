pageextension 50092 "Posted Trf. Shipment List Ext." extends "Posted Transfer Shipments"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify("&Print")
        {
            Visible = false;
        }
    }

    var
}