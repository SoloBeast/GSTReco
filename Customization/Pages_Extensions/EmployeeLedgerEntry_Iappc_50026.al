pageextension 50026 "Employee Ledger Entry Ext." extends "Employee Ledger Entries"
{
    editable = false;
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
        addafter("Document No.")
        {
            field("Transaction Nature"; Rec."Transaction Nature")
            {
                ApplicationArea = all;
            }
        }
        addafter(Description)
        {
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Amount (LCY)")
        {
            field("Debit Amount"; Rec."Debit Amount")
            {
                ApplicationArea = all;
            }
            field("Credit Amount"; Rec."Credit Amount")
            {
                ApplicationArea = all;
            }
            field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
            {
                ApplicationArea = all;
            }
            field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
            {
                ApplicationArea = all;
            }
        }
        addafter(Open)
        {
            field("Employee Posting Group"; Rec."Employee Posting Group")
            {
                ApplicationArea = all;
            }
        }
        addafter("Entry No.")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = all;
            }
        }

        modify("Message to Recipient")
        {
            Visible = false;
        }
        modify("Payment Method Code")
        {
            Visible = false;
        }
        modify("Original Amount")
        {
            Visible = false;
        }
        modify("Amount (LCY)")
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

        moveafter("Shortcut Dimension 3 Code"; "Shortcut Dimension 4 Code")
        moveafter("Shortcut Dimension 4 Code"; "Shortcut Dimension 5 Code")
        moveafter("Shortcut Dimension 5 Code"; "Shortcut Dimension 6 Code")
        moveafter("Shortcut Dimension 6 Code"; "Shortcut Dimension 7 Code")
        moveafter("Shortcut Dimension 7 Code"; "Shortcut Dimension 8 Code")
        moveafter("Shortcut Dimension 8 Code"; "Entry No.")
    }

    actions
    {
        // Add changes to page actions here
        addafter(Dimensions)
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
    }

    var
}