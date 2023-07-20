pageextension 50089 "Pstd. Purch.Cr.Memo List Ext." extends "Posted Purchase Credit Memos"
{
    layout
    {
        // Add changes to page layout here
        addafter("Buy-from Vendor Name")
        {
            field("Internal Document Type"; Rec."Internal Document Type")
            {
                ApplicationArea = all;
            }
            field("Buy-from Address"; Rec."Buy-from Address")
            {
                ApplicationArea = all;
            }
            field("Buy-from Address 2"; Rec."Buy-from Address 2")
            {
                ApplicationArea = all;
            }
            field("Buy-from City"; Rec."Buy-from City")
            {
                ApplicationArea = all;
            }
            field("Vendor GST Reg. No."; Rec."Vendor GST Reg. No.")
            {
                ApplicationArea = all;
            }
        }
        addafter(Amount)
        {
            field("IGST Amount"; Rec."IGST Amount")
            {
                ApplicationArea = all;
            }
            field("CGST Amount"; Rec."CGST Amount")
            {
                ApplicationArea = all;
            }
            field("SGST Amount"; Rec."SGST Amount")
            {
                ApplicationArea = all;
            }
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Due Date")
        {
            Visible = false;
        }
        modify("Amount Including VAT")
        {
            Visible = false;
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
            action(PrintPortrait)
            {
                ApplicationArea = all;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                begin
                    recPurchCrMemoHeader.Reset();
                    recPurchCrMemoHeader.SetRange("No.", Rec."No.");
                    recPurchCrMemoHeader.FindFirst();
                    Report.Run(50026, true, true, recPurchCrMemoHeader);
                end;
            }
        }
        modify("&Print")
        {
            Visible = false;
        }
    }

    var
        recPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
}