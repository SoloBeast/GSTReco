pageextension 50088 "Pstd. Sales Shmp. SPage Ext." extends "Posted Sales Shpt. Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Planned Delivery Date")
        {
            Visible = false;
        }
        modify("Planned Shipment Date")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("Order Tra&cking")
        {
            Visible = false;
        }
    }

    var
}