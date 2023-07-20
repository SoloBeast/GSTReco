pageextension 50093 "Pstd. Trf. Shipment Card Ext." extends "Posted Transfer Shipment"
{
    Editable = false;

    layout
    {
        // Add changes to page layout here
        modify("Direct Transfer")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Receipt Date")
        {
            Visible = false;
        }
        modify("Transaction Type")
        {
            Visible = false;
        }
        modify("Transaction Specification")
        {
            Visible = false;
        }
        modify("Transport Method")
        {
            Visible = false;
        }
        modify("Area")
        {
            Visible = false;
        }
        modify("Entry/Exit Point")
        {
            Visible = false;
        }
        modify("Time of Removal")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("&Print")
        {
            Visible = false;
        }
        modify("Attached Gate Entry")
        {
            Visible = false;
        }
    }

    var
}