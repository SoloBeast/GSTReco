pageextension 50097 "Pstd.Trf. Rcpt. SPage Ext." extends "Posted Transfer Rcpt. Subform"
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