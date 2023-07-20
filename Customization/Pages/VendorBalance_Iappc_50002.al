page 50002 "Vendor Balances"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Vendor;
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
            repeater(VendorList)
            {
                Caption = 'Vendor List';
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
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
                        recVendorLedgerEntry.RESET;
                        recVendorLedgerEntry.SETRANGE("Vendor No.", Rec."No.");
                        IF dtFromDate <> 0D THEN
                            recVendorLedgerEntry.SETRANGE("Posting Date", 0D, dtFromDate - 1);
                        PAGE.RUN(0, recVendorLedgerEntry);
                    end;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recVendorLedgerEntry.RESET;
                        recVendorLedgerEntry.SETRANGE("Vendor No.", Rec."No.");
                        recVendorLedgerEntry.SETRANGE("Posting Date", dtFromDate, dtToDate);
                        recVendorLedgerEntry.SETRANGE(Positive, TRUE);
                        PAGE.RUN(0, recVendorLedgerEntry);
                    end;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recVendorLedgerEntry.RESET;
                        recVendorLedgerEntry.SETRANGE("Vendor No.", Rec."No.");
                        recVendorLedgerEntry.SETRANGE("Posting Date", dtFromDate, dtToDate);
                        recVendorLedgerEntry.SETRANGE(Positive, FALSE);
                        PAGE.RUN(0, recVendorLedgerEntry);
                    end;
                }
                field("Closing Balance"; Rec."Closing Balance")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recVendorLedgerEntry.RESET;
                        recVendorLedgerEntry.SETRANGE("Vendor No.", Rec."No.");
                        IF dtToDate <> 0D THEN
                            recVendorLedgerEntry.SETRANGE("Posting Date", 0D, dtToDate);
                        PAGE.RUN(0, recVendorLedgerEntry);
                    end;
                }
                field("Opening Balance (LCY)"; Rec."Opening Balance (LCY)")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recVendorLedgerEntry.RESET;
                        recVendorLedgerEntry.SETRANGE("Vendor No.", Rec."No.");
                        IF dtFromDate <> 0D THEN
                            recVendorLedgerEntry.SETRANGE("Posting Date", 0D, dtFromDate - 1);
                        PAGE.RUN(0, recVendorLedgerEntry);
                    end;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recVendorLedgerEntry.RESET;
                        recVendorLedgerEntry.SETRANGE("Vendor No.", Rec."No.");
                        recVendorLedgerEntry.SETRANGE("Posting Date", dtFromDate, dtToDate);
                        recVendorLedgerEntry.SETRANGE(Positive, TRUE);
                        PAGE.RUN(0, recVendorLedgerEntry);
                    end;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recVendorLedgerEntry.RESET;
                        recVendorLedgerEntry.SETRANGE("Vendor No.", Rec."No.");
                        recVendorLedgerEntry.SETRANGE("Posting Date", dtFromDate, dtToDate);
                        recVendorLedgerEntry.SETRANGE(Positive, FALSE);
                        PAGE.RUN(0, recVendorLedgerEntry);
                    end;
                }
                field("Closing Balance (LCY)"; Rec."Closing Balance (LCY)")
                {
                    ApplicationArea = all;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        recVendorLedgerEntry.RESET;
                        recVendorLedgerEntry.SETRANGE("Vendor No.", Rec."No.");
                        IF dtToDate <> 0D THEN
                            recVendorLedgerEntry.SETRANGE("Posting Date", 0D, dtToDate);
                        PAGE.RUN(0, recVendorLedgerEntry);
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(VendorLedger)
            {
                Caption = 'Vendor Ledger';
                Image = LedgerEntries;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    recVendor.Reset();
                    recVendor.SetRange("No.", Rec."No.");
                    recVendor.FindFirst();
                    Clear(rptLedgerReport);
                    rptLedgerReport.SetTableView(recVendor);
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
                    recVendorLedgerEntry.Reset();
                    recVendorLedgerEntry.SetRange("Vendor No.", Rec."No.");
                    if (dtFromDate <> dtBlankDate) and (dtToDate <> dtBlankDate) then
                        recVendorLedgerEntry.SetRange("Posting Date", dtFromDate, dtToDate);
                    if (dtFromDate <> dtBlankDate) and (dtToDate = dtBlankDate) then
                        recVendorLedgerEntry.SetRange("Posting Date", dtFromDate, dtFromDate + 365000);
                    if (dtFromDate = dtBlankDate) and (dtToDate <> dtBlankDate) then
                        recVendorLedgerEntry.SetRange("Posting Date", dtBlankDate, dtToDate);
                    if cdGlobalDim1 <> '' then
                        recVendorLedgerEntry.SetRange("Global Dimension 1 Code", cdGlobalDim1);
                    if cdGlobalDim2 <> '' then
                        recVendorLedgerEntry.SetRange("Global Dimension 2 Code", cdGlobalDim2);
                    Page.RunModal(Page::"Vendor Ledger Entries", recVendorLedgerEntry);
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
        recVendor: Record Vendor;
        rptLedgerReport: Report "Vendor Ledger";
        recVendorLedgerEntry: Record "Vendor Ledger Entry";

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