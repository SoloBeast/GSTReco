pageextension 50025 "Bank Ledger Entry Ext." extends "Bank Account Ledger Entries"
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
        addafter("Cheque No.")
        {
            field("UTR No."; Rec."UTR No.")
            {
                ApplicationArea = all;
            }
        }
        modify("Cheque No.")
        {
            Visible = false;
        }
        addafter("Document No.")
        {
            field("Transaction Nature"; Rec."Transaction Nature")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shortcut Dimension 8 Code")
        {
            field("Statement Status"; Rec."Statement Status")
            {
                ApplicationArea = all;
            }
            field("Statement No."; Rec."Statement No.")
            {
                ApplicationArea = all;
            }
            field("Statement Line No."; Rec."Statement Line No.")
            {
                ApplicationArea = all;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
        }

        modify("Amount (LCY)")
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
        modify("Debit Amount (LCY)")
        {
            Visible = true;
        }
        modify("Credit Amount (LCY)")
        {
            Visible = true;
        }
        modify("Currency Code")
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

        moveafter(Amount; "Amount (LCY)")
        moveafter("Amount (LCY)"; "Debit Amount")
        moveafter("Debit Amount"; "Credit Amount")
        moveafter("Credit Amount"; "Debit Amount (LCY)")
        moveafter("Debit Amount (LCY)"; "Credit Amount (LCY)")
        moveafter(Open; "Currency Code")
        moveafter("Currency Code"; "Shortcut Dimension 3 Code")
        moveafter("Shortcut Dimension 3 Code"; "Shortcut Dimension 4 Code")
        moveafter("Shortcut Dimension 4 Code"; "Shortcut Dimension 5 Code")
        moveafter("Shortcut Dimension 5 Code"; "Shortcut Dimension 6 Code")
        moveafter("Shortcut Dimension 6 Code"; "Shortcut Dimension 7 Code")
        moveafter("Shortcut Dimension 7 Code"; "Shortcut Dimension 8 Code")
        moveafter("External Document No."; "Entry No.")
    }

    actions
    {
        // Add changes to page actions here
        addafter("Print Voucher")
        {
            action(UpdateUTR)
            {
                Caption = 'Update UTR No.';
                ApplicationArea = all;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Bank Ledger Edit";
                RunPageLink = "Entry No." = field("Entry No.");
            }
            action(ImportUTR)
            {
                Caption = 'Import UTR No.';
                ApplicationArea = all;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    xmlUTR: XmlPort "UTR No. Update";
                begin
                    Clear(xmlUTR);
                    xmlUTR.Run();
                    CurrPage.Update();
                end;
            }
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
            action(ExportKotakFile)
            {
                Caption = 'Export Kotak File';
                ApplicationArea = all;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Clear(cuCustomProcess);
                    cuCustomProcess.KotakBankPaymentFile(Rec);
                end;
            }
            action(ExportAxisFile)
            {
                Caption = 'Export Axis File';
                ApplicationArea = all;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Clear(cuCustomProcess);
                    cuCustomProcess.AxisBankFile(Rec);
                end;
            }
            action(ExportICICIFile)
            {
                Caption = 'Export ICICI File';
                ApplicationArea = all;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Clear(cuCustomProcess);
                    cuCustomProcess.ExportICICIBankPaymentFile(Rec);
                end;
            }
        }
        modify("Print Voucher")
        {
            Visible = false;
        }
    }

    var
        cuCustomProcess: Codeunit "Iappc Customization";
}