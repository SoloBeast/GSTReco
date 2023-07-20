pageextension 50027 "FA Ledger Entry Ext." extends "FA Ledger Entries"
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
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = all;
            }
            field("FA Posting Group"; Rec."FA Posting Group")
            {
                ApplicationArea = all;
            }
            field("FA Location Code"; Rec."FA Location Code")
            {
                ApplicationArea = all;
            }
            field("Depreciation Method"; Rec."Depreciation Method")
            {
                ApplicationArea = all;
            }
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
        modify("Debit Amount")
        {
            Visible = true;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }
        modify("User ID")
        {
            Visible = true;
        }

        moveafter(Amount; "Debit Amount")
        moveafter("Debit Amount"; "Credit Amount")
        moveafter("Depreciation Method"; "Shortcut Dimension 3 Code")
        moveafter("Shortcut Dimension 3 Code"; "Shortcut Dimension 4 Code")
        moveafter("Shortcut Dimension 4 Code"; "Shortcut Dimension 5 Code")
        moveafter("Shortcut Dimension 5 Code"; "Shortcut Dimension 6 Code")
        moveafter("Shortcut Dimension 6 Code"; "Shortcut Dimension 7 Code")
        moveafter("Shortcut Dimension 7 Code"; "Shortcut Dimension 8 Code")
        moveafter("Shortcut Dimension 8 Code"; "User ID")
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