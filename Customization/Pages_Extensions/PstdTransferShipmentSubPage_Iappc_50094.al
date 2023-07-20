pageextension 50094 "Pstd.Trf. Shipment SPage Ext." extends "Posted Transfer Shpt. Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Custom Duty Amount")
        {
            Visible = false;
        }
        modify("GST Assessable Value")
        {
            Visible = false;
        }
        modify("Shipping Time")
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