pageextension 50067 "Inventory Shipment Card Ext." extends "Invt. Shipment"
{
    layout
    {
        // Add changes to page layout here
        modify("Posting Description")
        {
            Visible = false;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify(Correction)
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("Create &Tracking from Reservation")
        {
            Visible = false;
        }
    }

    var
}