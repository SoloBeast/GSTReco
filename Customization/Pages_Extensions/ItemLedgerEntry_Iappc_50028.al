pageextension 50028 "Item Ledger Entry Ext." extends "Item Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Unit of Measure Code")
        {
            field("Transaction Type"; Rec."Transaction Type")
            {
                ApplicationArea = all;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = all;
            }
            field("Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ApplicationArea = all;
            }
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = all;
            }
            field("Item Tracking"; Rec."Item Tracking")
            {
                ApplicationArea = all;
            }
        }
        modify("Lot No.")
        {
            Visible = true;
        }
        modify("Serial No.")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 3 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 4 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 5 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 6 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 7 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 8 Code")
        {
            Visible = false;
        }
        modify("Order No.")
        {
            Visible = true;
        }
        modify("Order Line No.")
        {
            Visible = true;
        }
        modify("Variant Code")
        {
            Visible = true;
        }
        modify("Unit of Measure Code")
        {
            Visible = true;
        }
        modify("Completely Invoiced")
        {
            Visible = true;
        }

        moveafter("Remaining Quantity"; "Sales Amount (Actual)")
        moveafter("Sales Amount (Actual)"; "Cost Amount (Actual)")
        moveafter("Cost Amount (Actual)"; "Cost Amount (Non-Invtbl.)")
        moveafter("Cost Amount (Non-Invtbl.)"; Open)
        moveafter(Open; "Order Type")
        moveafter("Order Type"; "Order No.")
        moveafter("Order No."; "Order Line No.")
        moveafter("Order Line No."; "Unit of Measure Code")
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}