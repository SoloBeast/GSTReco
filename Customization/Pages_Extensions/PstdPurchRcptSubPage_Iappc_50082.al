pageextension 50082 "Pstd.Purch.Rcpt SPage Ext." extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Planned Receipt Date")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
        {
            Visible = false;
        }
        modify("Order Date")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(OrderTracking)
        {
            Visible = false;
        }
        modify(DocumentLineTracking)
        {
            Visible = false;
        }
    }

    var
}