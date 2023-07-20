pageextension 50102 "Purch.Inv.SubPage Ext." extends "Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Location Code")
        {
            Visible = true;
        }
        modify("Deferral Code")
        {
            Visible = true;
        }
        modify("GST Group Code")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("HSN/SAC Code")
        {
            Visible = true;
        }
        modify("GST Assessable Value")
        {
            Visible = false;
        }
        modify("Custom Duty Amount")
        {
            Visible = false;
        }
        modify("Total VAT Amount")
        {
            Visible = false;
        }
        modify("Total Amount Excl. VAT")
        {
            Visible = false;
        }
        modify("Act Applicable")
        {
            Visible = false;
        }
        modify("Nature of Remittance")
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