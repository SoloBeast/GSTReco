pageextension 50064 "Transfer Order SubPage Ext." extends "Transfer Order Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Reserved Quantity Inbnd.")
        {
            Visible = false;
        }
        modify("Reserved Quantity Shipped")
        {
            Visible = false;
        }
        modify("Reserved Quantity Outbnd.")
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
        modify("Custom Duty Amount")
        {
            Visible = false;
        }
        modify("GST Assessable Value")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("F&unctions")
        {
            Visible = false;
        }
    }

    var
}