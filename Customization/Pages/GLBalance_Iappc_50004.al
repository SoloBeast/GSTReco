page 50004 "G/L Balances"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "G/L Account";
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
            repeater(GLList)
            {
                Caption = 'G/L Account List';
                Editable = false;
                field("No."; Rec."No.")
                {
                    StyleExpr = blnStrong;
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    StyleExpr = blnStrong;
                    ApplicationArea = all;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = all;
                }
                field("Income/Balance"; Rec."Income/Balance")
                {
                    ApplicationArea = all;
                }
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = all;
                }
                field("Account Subcategory Descript."; Rec."Account Subcategory Descript.")
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
                field("Balance at Date"; Rec."Balance at Date")
                {
                    ApplicationArea = all;
                    Caption = 'Closing Balance';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(AccountLedger)
            {
                Caption = 'G/L Ledger';
                Image = LedgerEntries;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    recGLAccount.Reset();
                    recGLAccount.SetRange("No.", Rec."No.");
                    recGLAccount.FindFirst();
                    Clear(rptLedgerReport);
                    rptLedgerReport.SetTableView(recGLAccount);
                    rptLedgerReport.Run();
                end;
            }
        }
    }

    var
        dtBlankDate: Date;
        dtFromDate: Date;
        dtToDate: Date;
        cdGlobalDim1: Code[20];
        cdGlobalDim2: Code[20];
        blnStrong: Boolean;
        intIndentation: Integer;
        recGLAccount: Record "G/L Account";
        rptLedgerReport: Report "Account Ledger";

    trigger OnAfterGetRecord()
    begin
        blnStrong := rec."Account Type" <> rec."Account Type"::Posting;
        intIndentation := Rec.Indentation;
    end;

    local procedure UpdateValues()
    var
    begin
        if (dtFromDate <> dtBlankDate) and (dtToDate <> dtBlankDate) then begin
            Rec.SetFilter("Opening Date Filter", '%1..%2', dtBlankDate, ClosingDate(dtFromDate - 1));
            Rec.SetFilter("Date Filter", '%1..%2', dtFromDate, ClosingDate(dtToDate));
        end else
            if (dtFromDate <> dtBlankDate) and (dtToDate = dtBlankDate) then begin
                Rec.SetFilter("Opening Date Filter", '..%1', dtBlankDate, ClosingDate(dtFromDate - 1));
                Rec.SetFilter("Date Filter", '%1..%2', dtfromdate, ClosingDate(dtFromDate));
            end else
                if (dtFromDate = dtBlankDate) and (dtToDate <> dtBlankDate) then begin
                    Rec.SetFilter("Opening Date Filter", '..%1', dtBlankDate);
                    Rec.SetFilter("Date Filter", '%1..%2', dtToDate, ClosingDate(dtToDate));
                end;
        Rec.SetFilter("Global Dimension 1 Filter", cdGlobalDim1);
        Rec.SetFilter("Global Dimension 2 Filter", cdGlobalDim2);
        CurrPage.Update;
    end;
}