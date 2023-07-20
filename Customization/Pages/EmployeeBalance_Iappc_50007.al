page 50007 "Employee Balances"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Employee;
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
            repeater(EmployeeList)
            {
                Caption = 'Employee List';
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.FullName())
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
                field("Opening Balance (LCY)"; Rec."Opening Balance (LCY)")
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
                field("Closing Balance (LCY)"; Rec."Closing Balance (LCY)")
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
            action(AccountLedger)
            {
                Caption = 'Employee Ledger';
                Image = LedgerEntries;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    recEmployee.Reset();
                    recEmployee.SetRange("No.", Rec."No.");
                    recEmployee.FindFirst();
                    Clear(rptLedgerReport);
                    rptLedgerReport.SetTableView(recEmployee);
                    rptLedgerReport.Run();
                end;
            }
            action(LedgerEntries)
            {
                Caption = 'Ledger Entries';
                Image = LedgerEntries;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    recEmployeeLedgerEntry.Reset();
                    recEmployeeLedgerEntry.SetRange("Employee No.", Rec."No.");
                    if (dtFromDate <> dtBlankDate) and (dtToDate <> dtBlankDate) then
                        recEmployeeLedgerEntry.SetRange("Posting Date", dtFromDate, dtToDate);
                    if (dtFromDate <> dtBlankDate) and (dtToDate = dtBlankDate) then
                        recEmployeeLedgerEntry.SetRange("Posting Date", dtFromDate, dtFromDate + 365000);
                    if (dtFromDate = dtBlankDate) and (dtToDate <> dtBlankDate) then
                        recEmployeeLedgerEntry.SetRange("Posting Date", dtBlankDate, dtToDate);
                    if cdGlobalDim1 <> '' then
                        recEmployeeLedgerEntry.SetRange("Global Dimension 1 Code", cdGlobalDim1);
                    if cdGlobalDim2 <> '' then
                        recEmployeeLedgerEntry.SetRange("Global Dimension 2 Code", cdGlobalDim2);
                    Page.RunModal(Page::"Employee Ledger Entries", recEmployeeLedgerEntry);
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
        recEmployee: Record Employee;
        rptLedgerReport: Report "Employee Ledger";
        recEmployeeLedgerEntry: Record "Employee Ledger Entry";

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
        if cdGlobalDim1 <> '' then
            Rec.SetFilter("Global Dimension 1 Filter", cdGlobalDim1);
        if cdGlobalDim2 <> '' then
            Rec.SetFilter("Global Dimension 2 Filter", cdGlobalDim2);
        CurrPage.Update;
    end;
}