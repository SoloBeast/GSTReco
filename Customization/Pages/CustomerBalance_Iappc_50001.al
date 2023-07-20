page 50001 "Customer Balances"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Customer;
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
            repeater(CustomerList)
            {
                Caption = 'Customer List';
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Opening Balance"; Rec."Opening Balance")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recCustomerLedgerEntry.RESET;
                        recCustomerLedgerEntry.SETRANGE("Customer No.", Rec."No.");
                        IF dtFromDate <> 0D THEN
                            recCustomerLedgerEntry.SETRANGE("Posting Date", 0D, dtFromDate - 1);
                        PAGE.RUN(0, recCustomerLedgerEntry);
                    end;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recCustomerLedgerEntry.RESET;
                        recCustomerLedgerEntry.SETRANGE("Customer No.", Rec."No.");
                        recCustomerLedgerEntry.SETRANGE("Posting Date", dtFromDate, dtToDate);
                        recCustomerLedgerEntry.SETRANGE(Positive, TRUE);
                        PAGE.RUN(0, recCustomerLedgerEntry);
                    end;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recCustomerLedgerEntry.RESET;
                        recCustomerLedgerEntry.SETRANGE("Customer No.", Rec."No.");
                        recCustomerLedgerEntry.SETRANGE("Posting Date", dtFromDate, dtToDate);
                        recCustomerLedgerEntry.SETRANGE(Positive, FALSE);
                        PAGE.RUN(0, recCustomerLedgerEntry);
                    end;
                }
                field("Closing Balance"; Rec."Closing Balance")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recCustomerLedgerEntry.RESET;
                        recCustomerLedgerEntry.SETRANGE("Customer No.", Rec."No.");
                        IF dtToDate <> 0D THEN
                            recCustomerLedgerEntry.SETRANGE("Posting Date", 0D, dtToDate);
                        PAGE.RUN(0, recCustomerLedgerEntry);
                    end;
                }
                field("Opening Balance (LCY)"; Rec."Opening Balance (LCY)")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recCustomerLedgerEntry.RESET;
                        recCustomerLedgerEntry.SETRANGE("Customer No.", Rec."No.");
                        IF dtFromDate <> 0D THEN
                            recCustomerLedgerEntry.SETRANGE("Posting Date", 0D, dtFromDate - 1);
                        PAGE.RUN(0, recCustomerLedgerEntry);
                    end;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recCustomerLedgerEntry.RESET;
                        recCustomerLedgerEntry.SETRANGE("Customer No.", Rec."No.");
                        recCustomerLedgerEntry.SETRANGE("Posting Date", dtFromDate, dtToDate);
                        recCustomerLedgerEntry.SETRANGE(Positive, TRUE);
                        PAGE.RUN(0, recCustomerLedgerEntry);
                    end;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recCustomerLedgerEntry.RESET;
                        recCustomerLedgerEntry.SETRANGE("Customer No.", Rec."No.");
                        recCustomerLedgerEntry.SETRANGE("Posting Date", dtFromDate, dtToDate);
                        recCustomerLedgerEntry.SETRANGE(Positive, FALSE);
                        PAGE.RUN(0, recCustomerLedgerEntry);
                    end;
                }
                field("Closing Balance (LCY)"; Rec."Closing Balance (LCY)")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recCustomerLedgerEntry.RESET;
                        recCustomerLedgerEntry.SETRANGE("Customer No.", Rec."No.");
                        IF dtToDate <> 0D THEN
                            recCustomerLedgerEntry.SETRANGE("Posting Date", 0D, dtToDate);
                        PAGE.RUN(0, recCustomerLedgerEntry);
                    end;
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
                Caption = 'Customer Ledger';
                Image = LedgerEntries;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    recCustomer.Reset();
                    recCustomer.SetRange("No.", Rec."No.");
                    recCustomer.FindFirst();
                    Clear(rptLedgerReport);
                    rptLedgerReport.SetTableView(recCustomer);
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
                    recCustomerLedgerEntry.Reset();
                    recCustomerLedgerEntry.SetRange("Customer No.", Rec."No.");
                    if (dtFromDate <> dtBlankDate) and (dtToDate <> dtBlankDate) then
                        recCustomerLedgerEntry.SetRange("Posting Date", dtFromDate, dtToDate);
                    if (dtFromDate <> dtBlankDate) and (dtToDate = dtBlankDate) then
                        recCustomerLedgerEntry.SetRange("Posting Date", dtFromDate, dtFromDate + 365000);
                    if (dtFromDate = dtBlankDate) and (dtToDate <> dtBlankDate) then
                        recCustomerLedgerEntry.SetRange("Posting Date", dtBlankDate, dtToDate);
                    if cdGlobalDim1 <> '' then
                        recCustomerLedgerEntry.SetRange("Global Dimension 1 Code", cdGlobalDim1);
                    if cdGlobalDim2 <> '' then
                        recCustomerLedgerEntry.SetRange("Global Dimension 2 Code", cdGlobalDim2);
                    Page.RunModal(Page::"Customer Ledger Entries", recCustomerLedgerEntry);
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
        recCustomer: Record Customer;
        rptLedgerReport: Report "Customer Ledger";
        recCustomerLedgerEntry: Record "Cust. Ledger Entry";

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