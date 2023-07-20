pageextension 50080 "Pstd. Purch. Rcpt. List Ext." extends "Posted Purchase Receipts"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
            field("Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = all;
            }
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("No. Printed")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Print")
        {
            action(PrintReceipt)
            {
                ApplicationArea = all;
                Caption = 'Print GRN';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category5;

                trigger OnAction()
                begin
                    recPurchReceipt.Reset();
                    recPurchReceipt.SetRange("No.", Rec."No.");
                    recPurchReceipt.FindFirst();
                    Report.Run(50017, true, true, recPurchReceipt);
                end;
            }
        }

        modify("&Print")
        {
            Visible = false;
        }
    }

    var
        recPurchReceipt: Record "Purch. Rcpt. Header";
}