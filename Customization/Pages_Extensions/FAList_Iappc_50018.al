pageextension 50018 "FA List Ext." extends "Fixed Asset List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Tagging No."; Rec."Tagging No.")
            {
                ApplicationArea = all;
            }
        }
        addafter(Acquired)
        {
            field("GST Group Code"; Rec."GST Group Code")
            {
                ApplicationArea = all;
            }
            field("GST Credit"; Rec."GST Credit")
            {
                ApplicationArea = all;
            }
            field("HSN/SAC Code"; Rec."HSN/SAC Code")
            {
                ApplicationArea = all;
            }
            field("Acquisition Cost"; Rec."Acquisition Cost")
            {
                ApplicationArea = all;
            }
            field(Depreciation; Rec.Depreciation)
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
    }

    actions
    {
        // Add changes to page actions here
        addafter("Ledger E&ntries")
        {
            action(AccountLedger)
            {
                Caption = 'FA Ledger';
                Image = LedgerEntries;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    recFA.Reset();
                    recFA.SetRange("No.", Rec."No.");
                    recFA.FindFirst();
                    Clear(rptLedgerReport);
                    rptLedgerReport.SetTableView(recFA);
                    rptLedgerReport.Run();
                end;
            }
        }

        modify("Fixed Asset G/L Journal")
        {
            Visible = false;
        }
        modify(CalculateDepreciation)
        {
            Visible = false;
        }
        modify("FA Posting Types Overview")
        {
            Visible = false;
        }
        modify("Fixed Assets List")
        {
            Visible = false;
        }
        modify("Acquisition List")
        {
            Visible = false;
        }
        modify(Details)
        {
            Visible = false;
        }
        modify(Analysis)
        {
            Visible = false;
        }
        modify("Projected Value")
        {
            Visible = false;
        }
        modify("Fixed Asset Journal")
        {
            Visible = false;
        }
        modify("Fixed Asset Reclassification Journal")
        {
            Visible = false;
        }
        modify("Recurring Fixed Asset Journal")
        {
            Visible = false;
        }
        modify("C&opy Fixed Asset")
        {
            Visible = true;
        }
        modify("Main&tenance Ledger Entries")
        {
            Visible = false;
        }
        modify("Error Ledger Entries")
        {
            Visible = false;
        }
        modify("Maintenance &Registration")
        {
            Visible = false;
        }
        modify(Register)
        {
            Visible = false;
        }
        modify("G/L Analysis")
        {
            Visible = false;
        }
        modify("FA Book Val. - Appr. & Write-D")
        {
            Visible = false;
        }
        modify("FA Book Value")
        {
            Visible = false;
        }
    }

    var
        recFA: Record "Fixed Asset";
        rptLedgerReport: Report "FA Ledger";
}