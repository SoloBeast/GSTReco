pageextension 50024 "Vendor Ledger Entries Ext." extends "Vendor Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Entry No.")
        {
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;
            }
        }
        addafter("Currency Code")
        {
            field("Currency Excharge Rate"; Rec."Currency Excharge Rate")
            {
                ApplicationArea = all;
            }
        }
        addafter("Document No.")
        {
            field("Transaction Nature"; Rec."Transaction Nature")
            {
                ApplicationArea = all;
            }
            field("Advance Payment"; Rec."Advance Payment")
            {
                ApplicationArea = all;
            }
            field("Type of Transaction"; Rec."Type of Transaction")
            {
                ApplicationArea = all;
            }
        }
        addbefore("Due Date")
        {
            field("Total TDS Including SHE CESS"; Rec."Total TDS Including SHE CESS")
            {
                ApplicationArea = all;
            }
        }

        modify("Purchaser Code")
        {
            Visible = true;
        }
        modify("Debit Amount")
        {
            Visible = true;
        }
        modify("Debit Amount (LCY)")
        {
            Visible = true;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }
        modify("Credit Amount (LCY)")
        {
            Visible = true;
        }
        modify("User ID")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 3 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 4 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 5 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 6 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 7 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 8 Code")
        {
            Visible = true;
        }
        modify("Payment Reference")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
        modify("Original Amount")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
        }
        modify(RecipientBankAcc)
        {
            Visible = false;
        }
        modify("GST on Advance Payment")
        {
            Visible = false;
        }
        modify("Pmt. Disc. Tolerance Date")
        {
            Visible = false;
        }
        modify("Original Pmt. Disc. Possible")
        {
            Visible = false;
        }
        modify("Remaining Pmt. Disc. Possible")
        {
            Visible = false;
        }
        modify("Max. Payment Tolerance")
        {
            Visible = false;
        }
        modify("Exported to Payment File")
        {
            Visible = false;
        }

        movebefore("Posting Date"; "Vendor No.")
        moveafter("Vendor No."; "Vendor Name")
        moveafter(Amount; "Amount (LCY)")
        moveafter("Amount (LCY)"; "Debit Amount")
        moveafter("Debit Amount"; "Credit Amount")
        moveafter("Credit Amount"; "Debit Amount (LCY)")
        moveafter("Debit Amount (LCY)"; "Credit Amount (LCY)")
        moveafter("Remaining Amt. (LCY)"; "TDS Section Code")
        moveafter("On Hold"; "Purchaser Code")
        moveafter("Location GST Reg. No."; "Entry No.")
        moveafter("Entry No."; "User ID")
        moveafter("User ID"; "Shortcut Dimension 3 Code")
        moveafter("Shortcut Dimension 3 Code"; "Shortcut Dimension 4 Code")
        moveafter("Shortcut Dimension 4 Code"; "Shortcut Dimension 5 Code")
        moveafter("Shortcut Dimension 5 Code"; "Shortcut Dimension 6 Code")
        moveafter("Shortcut Dimension 6 Code"; "Shortcut Dimension 7 Code")
        moveafter("Shortcut Dimension 7 Code"; "Shortcut Dimension 8 Code")
    }

    actions
    {
        // Add changes to page actions here
        addafter("Print Voucher")
        {
            action(PrintVoucher)
            {
                Caption = 'Print Voucher';
                ApplicationArea = all;
                Image = PrintVoucher;
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    rptVoucherReport: Report "Voucher Test Report";
                begin
                    Clear(rptVoucherReport);
                    rptVoucherReport.SetDocumentDetails('PV', Rec."Document No.", '', '');
                    rptVoucherReport.Run();
                end;
            }
            action(PrintAdvice)
            {
                Caption = 'Payment Advice';
                ApplicationArea = all;
                Image = PrintVoucher;
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    recVendorLedger: Record "Vendor Ledger Entry";
                begin
                    recVendorLedger.Reset();
                    recVendorLedger.SetRange("Entry No.", Rec."Entry No.");
                    recVendorLedger.FindFirst();
                    recVendorLedger.CalcFields("Original Amt. (LCY)");
                    if recVendorLedger."Original Amt. (LCY)" < 0 then
                        Error('Payment Advice can be printed for positive entry only.');

                    Report.Run(Report::"Payment Advice", true, true, recVendorLedger);
                end;
            }
        }
        modify("Print Voucher")
        {
            Visible = false;
        }
    }

    var
}