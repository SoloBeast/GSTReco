report 50027 "Item Ageing"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\ItemAgeing_Iappc_50027.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Inventory Posting Group";
            DataItemTableView = sorting("No.");

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; txtHeading) { }
            column(txtFilters; txtFilters) { }
            column(AccountNo; Item."No.") { }
            column(AccountName; Item.Description) { }
            column(BeforeQty; decBeforeQty) { }
            column(BeforeValue; decBeforeValue) { }
            column(Slab1Caption; txtSlab1Caption) { }
            column(Slab1Qty; decSlab1Qty) { }
            column(Slab1Value; decSlab1Value) { }
            column(Slab2Caption; txtSlab2Caption) { }
            column(Slab2Qty; decSlab2Qty) { }
            column(Slab2Value; decSlab2Value) { }
            column(Slab3Caption; txtSlab3Caption) { }
            column(Slab3Qty; decSlab3Qty) { }
            column(Slab3Value; decSlab3Value) { }
            column(AfterQty; decAfterQty) { }
            column(AfterValue; decAfterValue) { }

            trigger OnPreDataItem()
            begin
                recCompanyInfo.get;
                if dtAsOnDate = 0D then
                    Error('Enter As On Date to View.');
                if Format(dtPeriodLength) = '' then
                    Error('Enter Period Length to view.');

                txtHeading := 'Item Ageing Report As On ' + Format(dtAsOnDate);
                txtFilters := Item.GetFilters;

                txtPeriodLength := '-' + Format(dtPeriodLength);
                dtSlab3EndDate := dtAsOnDate;
                dtSlab3StartDate := CalcDate(txtPeriodLength, dtSlab3EndDate);
                dtSlab2StartDate := CalcDate(txtPeriodLength, dtSlab3StartDate);
                dtSlab1StartDate := CalcDate(txtPeriodLength, dtSlab2StartDate);
                intDaysInterval := dtSlab3EndDate - dtSlab3StartDate;
                txtSlab1Caption := Format(intDaysInterval * 2 + 1) + ' to ' + Format(intDaysInterval * 3) + ' days';
                txtSlab2Caption := Format(intDaysInterval + 1) + ' to ' + Format(intDaysInterval * 2) + ' days';
                txtSlab3Caption := '1 to ' + Format(intDaysInterval) + ' days';
            end;

            trigger OnAfterGetRecord()
            begin
                decBeforeQty := 0;
                decBeforeValue := 0;
                decSlab1Qty := 0;
                decSlab1Value := 0;
                decSlab2Qty := 0;
                decSlab2Value := 0;
                decSlab3Qty := 0;
                decSlab3Value := 0;
                decAfterQty := 0;
                decAfterValue := 0;

                recItemLedgerEntry.Reset();
                recItemLedgerEntry.SetRange("Item No.", Item."No.");
                recItemLedgerEntry.SetFilter("Location Code", Item."Location Filter");
                recItemLedgerEntry.SetRange("Posting Date", 0D, dtAsOnDate);
                recItemLedgerEntry.SetFilter("Date Filter", '..%1', dtAsOnDate);
                recItemLedgerEntry.SetRange(Positive, true);
                recItemLedgerEntry.SetFilter("App. Remaining Qty.", '<>%1', 0);
                if recItemLedgerEntry.FindSet() then begin
                    repeat
                        recItemLedgerEntry.CalcFields("App. Remaining Qty.", "Cost Amount (Actual)");

                        if recItemLedgerEntry."Posting Date" > dtSlab3EndDate then begin
                            decAfterQty += recItemLedgerEntry."App. Remaining Qty.";
                            decAfterValue += Round(recItemLedgerEntry."Cost Amount (Actual)" / recItemLedgerEntry.Quantity * recItemLedgerEntry."App. Remaining Qty.", 0.01);
                        end;
                        if (recItemLedgerEntry."Posting Date" >= dtSlab3StartDate) and (recItemLedgerEntry."Posting Date" <= dtSlab3EndDate) then begin
                            decSlab3Qty += recItemLedgerEntry."App. Remaining Qty.";
                            decSlab3Value += Round(recItemLedgerEntry."Cost Amount (Actual)" / recItemLedgerEntry.Quantity * recItemLedgerEntry."App. Remaining Qty.", 0.01);
                        end;
                        if (recItemLedgerEntry."Posting Date" >= dtSlab2StartDate) and (recItemLedgerEntry."Posting Date" <= dtSlab3StartDate - 1) then begin
                            decSlab2Qty += recItemLedgerEntry."App. Remaining Qty.";
                            decSlab2Value += Round(recItemLedgerEntry."Cost Amount (Actual)" / recItemLedgerEntry.Quantity * recItemLedgerEntry."App. Remaining Qty.", 0.01);
                        end;
                        if (recItemLedgerEntry."Posting Date" >= dtSlab1StartDate) and (recItemLedgerEntry."Posting Date" <= dtSlab2StartDate - 1) then begin
                            decSlab1Qty += recItemLedgerEntry."App. Remaining Qty.";
                            decSlab1Value += Round(recItemLedgerEntry."Cost Amount (Actual)" / recItemLedgerEntry.Quantity * recItemLedgerEntry."App. Remaining Qty.", 0.01);
                        end;
                        if recItemLedgerEntry."Posting Date" < dtSlab1StartDate then begin
                            decBeforeQty += recItemLedgerEntry."App. Remaining Qty.";
                            decBeforeValue += Round(recItemLedgerEntry."Cost Amount (Actual)" / recItemLedgerEntry.Quantity * recItemLedgerEntry."App. Remaining Qty.", 0.01);
                        end;
                    until recItemLedgerEntry.Next() = 0;
                end else
                    CurrReport.Skip();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(dtAsOnDate; dtAsOnDate)
                    {
                        ApplicationArea = All;
                        Caption = 'As On Date';
                    }
                    field(dtPeriodLength; dtPeriodLength)
                    {
                        ApplicationArea = all;
                        Caption = 'Period Length';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            dtAsOnDate := Today;
            Evaluate(dtPeriodLength, '<1M>');
        end;
    }

    var
        recCompanyInfo: Record "Company Information";
        txtHeading: Text;
        txtFilters: Text;
        dtAsOnDate: Date;
        dtPeriodLength: DateFormula;
        recItemLedgerEntry: Record "Item Ledger Entry";
        decBeforeQty: Decimal;
        decBeforeValue: Decimal;
        decSlab1Qty: Decimal;
        decSlab1Value: Decimal;
        decSlab2Qty: Decimal;
        decSlab2Value: Decimal;
        decSlab3Qty: Decimal;
        decSlab3Value: Decimal;
        decAfterQty: Decimal;
        decAfterValue: Decimal;
        dtSlab1StartDate: Date;
        dtSlab2StartDate: Date;
        dtSlab3StartDate: Date;
        dtSlab3EndDate: Date;
        txtPeriodLength: Text;
        txtSlab1Caption: Text;
        txtSlab2Caption: Text;
        txtSlab3Caption: Text;
        intDaysInterval: Integer;
}