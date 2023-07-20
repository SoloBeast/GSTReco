pageextension 50014 "Bank Account List Ext." extends "Bank Account List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Currency Code")
        {
            field(recBalance; Rec.Balance)
            {
                Caption = 'Balance';
                ApplicationArea = all;
            }
            field("Balance (LCY)"; Rec."Balance (LCY)")
            {
                ApplicationArea = all;
            }
            field("GST Registration No."; Rec."GST Registration No.")
            {
                ApplicationArea = all;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;
            }
            field("Created At"; Rec."Created At")
            {
                ApplicationArea = all;
            }
            field("Modified By"; Rec."Modified By")
            {
                ApplicationArea = all;
            }
            field("Last Date Modified"; Rec."Last Date Modified")
            {
                ApplicationArea = all;
            }
        }

        modify("Bank Acc. Posting Group")
        {
            Visible = true;
        }
        modify("Bank Account No.")
        {
            Visible = true;
        }
        modify("Currency Code")
        {
            Visible = true;
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter(Statistics)
        {
            action(AccountLedger)
            {
                Caption = 'Bank Ledger';
                Image = LedgerEntries;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    recBankAccount.Reset();
                    recBankAccount.SetRange("No.", Rec."No.");
                    recBankAccount.FindFirst();
                    Clear(rptLedgerReport);
                    rptLedgerReport.SetTableView(recBankAccount);
                    rptLedgerReport.Run();
                end;
            }
            action(ReconciliationReport)
            {
                Caption = 'Bank Reconciliation Report';
                Image = Reconcile;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                RunObject = report "Bank Reconciliation Report";
            }
        }

        modify("Detail Trial Balance")
        {
            Visible = false;
        }
        modify("Trial Balance by Period")
        {
            Visible = false;
        }
        modify(List)
        {
            Visible = false;
        }
        modify(Statements)
        {
            Visible = false;
        }
        modify("Chec&k Ledger Entries")
        {
            Visible = false;
        }
        modify("Check Details")
        {
            Visible = false;
        }
        modify("Receivables-Payables")
        {
            Visible = false;
        }
        modify("Trial Balance")
        {
            Visible = false;
        }
        modify("Bank Account Statements")
        {
            Visible = false;
        }
        modify(Balance)
        {
            Visible = false;
        }
    }

    var
        recBankAccount: Record "Bank Account";
        rptLedgerReport: Report "Bank Ledger";
}