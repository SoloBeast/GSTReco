pageextension 50022 "Cust.Ledger Entry Ext." extends "Customer Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
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
        }
        addafter("Entry No.")
        {
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;
            }
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                ApplicationArea = all;
            }
        }

        modify("Original Amount")
        {
            Visible = false;
        }
        modify("Certificate No.")
        {
            Visible = false;
        }
        modify("TDS Certificate Rcpt Date")
        {
            Visible = false;
        }
        modify("TDS Certificate Amount")
        {
            Visible = false;
        }
        modify("TDS Certificate Receivable")
        {
            Visible = false;
        }
        modify("TDS Certificate Received")
        {
            Visible = false;
        }
        modify("TDS Section Code")
        {
            Visible = false;
        }
        modify("Certificate Received")
        {
            Visible = false;
        }
        modify("Sales (LCY)")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
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
        modify("Payment Method Code")
        {
            Visible = false;
        }
        modify("Exported to Payment File")
        {
            Visible = false;
        }
        modify("Message to Recipient")
        {
            Visible = false;
        }
        modify(RecipientBankAccount)
        {
            Visible = false;
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
        modify("Salesperson Code")
        {
            Visible = true;
        }
        modify("External Document No.")
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

        movebefore("Posting Date"; "Customer Name")
        movebefore("Customer Name"; "Customer No.")
        moveafter("Amount (LCY)"; "Remaining Amount")
        moveafter("Remaining Amount"; "Remaining Amt. (LCY)")
        moveafter("Location GST Reg. No."; "User ID")
        moveafter("User ID"; "Shortcut Dimension 3 Code")
        moveafter("Shortcut Dimension 3 Code"; "Shortcut Dimension 4 Code")
        moveafter("Shortcut Dimension 4 Code"; "Shortcut Dimension 5 Code")
        moveafter("Shortcut Dimension 5 Code"; "Shortcut Dimension 6 Code")
        moveafter("Shortcut Dimension 6 Code"; "Shortcut Dimension 7 Code")
        moveafter("Shortcut Dimension 7 Code"; "Shortcut Dimension 8 Code")
        moveafter("Sell-to Customer No."; "Salesperson Code")
        moveafter("Salesperson Code"; "External Document No.")
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
        }
        modify("Print Voucher")
        {
            Visible = false;
        }
    }

    var
}