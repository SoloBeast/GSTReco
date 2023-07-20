pageextension 50005 "TCS Register Ext." extends "TCS Entries"
{
    layout
    {
        // Add changes to page layout here
        modify("Pay TCS Document No.")
        {
            Visible = false;
        }
        modify("TCS Paid")
        {
            Visible = false;
        }
        modify("Challan Date")
        {
            Visible = false;
        }
        modify("Challan No.")
        {
            Visible = false;
        }
        modify("Bank Name")
        {
            Visible = false;
        }
        modify(Adjusted)
        {
            Visible = false;
        }
        modify("Adjusted TCS %")
        {
            Visible = false;
        }
        modify("Bal. TCS Including SHE CESS")
        {
            Visible = false;
        }
        modify(Applied)
        {
            Visible = false;
        }
        modify("Adjusted Surcharge %")
        {
            Visible = false;
        }
        modify("Adjusted eCESS %")
        {
            Visible = false;
        }
        modify("Adjusted SHE CESS %")
        {
            Visible = false;
        }
        modify(Reversed)
        {
            Visible = false;
        }
        modify("Reversed by Entry No.")
        {
            Visible = false;
        }
        modify("Reversed Entry No.")
        {
            Visible = false;
        }
        modify("Check/DD No.")
        {
            Visible = false;
        }
        modify("Check Date")
        {
            Visible = false;
        }
        modify("TCS Payment Date")
        {
            Visible = false;
        }
        modify("Challan Register Entry No.")
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