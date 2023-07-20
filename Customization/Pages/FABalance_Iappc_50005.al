page 50005 "FA Balances"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Asset";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            grid(FilterGrid)
            {
                GridLayout = Rows;
                field(dtFromDate; dtFromDate)
                {
                    Caption = 'From Date';
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        UpdateValues();
                    end;
                }
                field(dtToDate; dtToDate)
                {
                    Caption = 'To Date';
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        UpdateValues();
                    end;
                }
                field(cdDepreciationBook; cdDepreciationBook)
                {
                    Caption = 'Depreciation Book Filter';
                    ApplicationArea = all;
                    TableRelation = "Depreciation Book";
                    trigger OnValidate()
                    begin
                        UpdateValues();
                    end;
                }
                field(cdGlobalDim1; cdGlobalDim1)
                {
                    Caption = 'Global Dimension 1 Filter';
                    ApplicationArea = all;
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
                    CaptionClass = '1,3,1';
                    trigger OnValidate()
                    begin
                        UpdateValues();
                    end;
                }
                field(cdGlobalDim2; cdGlobalDim2)
                {
                    Caption = 'Global Dimension 2 Filter';
                    ApplicationArea = all;
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
                    CaptionClass = '1,3,2';
                    trigger OnValidate()
                    begin
                        UpdateValues();
                    end;
                }
            }
            repeater(FAList)
            {
                Caption = 'FA List';
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Opening Balance"; Rec."Opening Balance")
                {
                    ApplicationArea = all;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = all;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = all;
                }
                field("Closing Balance"; Rec."Closing Balance")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FALedger)
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
    }

    var
        dtBlankDate: Date;
        dtFromDate: Date;
        dtToDate: Date;
        cdDepreciationBook: Code[10];
        cdGlobalDim1: Code[20];
        cdGlobalDim2: Code[20];
        recFA: Record "Fixed Asset";
        rptLedgerReport: Report "FA Ledger";

    trigger OnAfterGetRecord()
    begin
    end;

    local procedure UpdateValues()
    var

    begin
        if (dtFromDate <> dtBlankDate) and (dtToDate <> dtBlankDate) then begin
            Rec.SetFilter("Opening Date Filter", '%1..%2', dtBlankDate, dtFromDate - 1);
            Rec.SetFilter("Date Filter", '%1..%2', dtFromDate, dtToDate);
        end else
            if (dtFromDate <> dtBlankDate) and (dtToDate = dtBlankDate) then begin
                Rec.SetFilter("Opening Date Filter", '..%1', dtBlankDate, dtFromDate - 1);
                Rec.SetFilter("Date Filter", '%1..%2', dtfromdate, dtFromDate);
            end else
                if (dtFromDate = dtBlankDate) and (dtToDate <> dtBlankDate) then begin
                    Rec.SetFilter("Opening Date Filter", '..%1', dtBlankDate);
                    Rec.SetFilter("Date Filter", '%1..%2', dtToDate, dtToDate);
                end;
        if cdDepreciationBook <> '' then
            Rec.SetFilter("Depreciation Book Filter", cdDepreciationBook);
        if cdGlobalDim1 <> '' then
            Rec.SetFilter("Global Dimension 1 Filter", cdGlobalDim1);
        if cdGlobalDim2 <> '' then
            Rec.SetFilter("Global Dimension 2 Filter", cdGlobalDim2);
        CurrPage.Update;
    end;
}