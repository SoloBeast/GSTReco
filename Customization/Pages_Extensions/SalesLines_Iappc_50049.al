pageextension 50049 "Sales Lines Ext." extends "Sales Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sell-to Customer No.")
        {
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = all;
            }
        }
        modify(Reserve)
        {
            Visible = false;
        }
        modify("Reserved Qty. (Base)")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("Reservation Entries")
        {
            Visible = false;
        }
    }

    var
}