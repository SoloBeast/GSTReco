pageextension 50096 "Pstd.Trf. Receipt Card Ext." extends "Posted Transfer Receipt"
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
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify(GST)
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