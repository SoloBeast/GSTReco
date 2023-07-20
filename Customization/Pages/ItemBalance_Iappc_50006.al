page 50006 "Item Balances"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Item;
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
                field(cdLocationCode; cdLocationCode)
                {
                    Caption = 'Location Filter';
                    ApplicationArea = all;
                    TableRelation = Location;
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
            repeater(ItemList)
            {
                Caption = 'Item List';
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = all;
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Opening Quantity"; Rec."Opening Quantity")
                {
                    ApplicationArea = all;
                }
                field("Inward Quantity"; Rec."Inward Quantity")
                {
                    ApplicationArea = all;
                }
                field("Outward Quantity"; Rec."Outward Quantity")
                {
                    ApplicationArea = all;
                }
                field("Closing Balance"; Rec."Closing Quantity")
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
            action(ItemLedger)
            {
                Caption = 'Item Ledger';
                Image = LedgerEntries;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    recItem.Reset();
                    recItem.SetRange("No.", Rec."No.");
                    recItem.FindFirst();
                    Clear(rptLedgerReport);
                    rptLedgerReport.SetTableView(recItem);
                    rptLedgerReport.Run();
                end;
            }
        }
    }

    var
        dtBlankDate: Date;
        dtFromDate: Date;
        dtToDate: Date;
        cdLocationCode: Code[10];
        cdGlobalDim1: Code[20];
        cdGlobalDim2: Code[20];
        recItem: Record Item;
        rptLedgerReport: Report "Item Ledger";

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
        if cdLocationCode <> '' then
            Rec.SetFilter("Location Filter", cdLocationCode);
        if cdGlobalDim1 <> '' then
            Rec.SetFilter("Global Dimension 1 Filter", cdGlobalDim1);
        if cdGlobalDim2 <> '' then
            Rec.SetFilter("Global Dimension 2 Filter", cdGlobalDim2);
        CurrPage.Update;
    end;
}