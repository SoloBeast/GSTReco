pageextension 50048 "Purchase Lines Ext." extends "Purchase Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Buy-from Vendor No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = all;
            }
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
            }
        }
        addafter(Quantity)
        {
            field("Qty. to Receive"; Rec."Qty. to Receive")
            {
                ApplicationArea = all;
            }
            field("Quantity Received"; Rec."Quantity Received")
            {
                ApplicationArea = all;
            }
            field("Qty. to Invoice"; Rec."Qty. to Invoice")
            {
                ApplicationArea = all;
            }
            field("Quantity Invoiced"; Rec."Quantity Invoiced")
            {
                ApplicationArea = all;
            }
        }
        modify("Reserved Qty. (Base)")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
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