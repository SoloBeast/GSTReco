report 50005 "Item Ledger"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\ItemLedger_Iappc_50005.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Location Filter", "Date Filter";
            DataItemTableView = sorting("No.");

            column(CompanyName; recCompanyInfo.Name)
            { }
            column(Heading; txtHeading)
            { }
            column(txtFilters; txtFilters)
            { }
            column(AccountNo; Item."No.")
            { }
            column(AccountName; Item.Description)
            { }
            column(OpeningBalance; decOpeningBalance)
            { }

            dataitem(ItemEntry; "Item Ledger Entry")
            {
                DataItemTableView = sorting("Item NO.", "Posting Date");
                DataItemLink = "Item No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
                                "Location Code" = field("Location Filter"),
                                "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                column(EntryNo; "Entry No.")
                { }
                column(Posting_Date; format(NormalDate("Posting Date")))
                { }
                column(Sorting_Date; normaldate("Posting Date"))
                { }
                column(Document_Type; "Entry Type")
                { }
                column(Document_No_; "Document No.")
                { }
                column(Narration; txtnarration)
                { }
                column(Debit_Amount; decInwardQuantity)
                { }
                column(Credit_Amount; decOutwardQuantity)
                { }
                column(RunningBalance; decRunningBalance)
                { }
                column(TotalDebitAmount; decTotalDebitAmount)
                { }
                column(TotalCreditAmount; decTotalCreditAmount)
                { }

                trigger OnAfterGetRecord()
                begin
                    decRunningBalance += ItemEntry.Quantity;
                    decInwardQuantity := 0;
                    decOutwardQuantity := 0;
                    if ItemEntry.Quantity > 0 then
                        decInwardQuantity := ItemEntry.Quantity
                    else
                        decOutwardQuantity := -ItemEntry.Quantity;
                    decTotalDebitAmount += decInwardQuantity;
                    decTotalCreditAmount += decOutwardQuantity;

                    txtNarration := '';
                    recpurchcommline.RESET;
                    recpurchcommline.SETRANGE("No.", "Document No.");
                    IF recpurchcommline.FIND('-') THEN
                        REPEAT
                            txtNarration += ' ' + recpurchcommline.Comment;
                        UNTIL recpurchcommline.NEXT = 0;

                    recSalescommline.RESET;
                    recSalescommline.SETRANGE("No.", "Document No.");
                    IF recSalescommline.FIND('-') THEN
                        REPEAT
                            txtNarration += ' ' + recSalescommline.Comment;
                        UNTIL recSalescommline.NEXT = 0;

                    if txtNarration = '' then
                        txtNarration := Description;
                end;
            }
            trigger OnPreDataItem()
            begin
                recCompanyInfo.get;
                IF Item.GETRANGEMIN("Date Filter") <> 0D THEN
                    dtStartDate := Item.GETRANGEMIN("Date Filter");
                IF Item.GETRANGEMAX("Date Filter") <> 0D THEN
                    dtEndDate := Item.GETRANGEMAX("Date Filter");

                txtLocationFiter := Item.GetFilter("Location Filter");
                IF Item.GETFILTER("Global Dimension 1 Filter") <> '' THEN
                    txtGlobalDim1Filter := Item.GETFILTER("Global Dimension 1 Filter");

                IF Item.GETFILTER("Global Dimension 2 Filter") <> '' THEN
                    txtGlobalDim2Filter := Item.GETFILTER("Global Dimension 2 Filter");
                txtAccountFilter := Item.GetFilter("No.");

                txtHeading := 'Item Ledger Report';
                txtFilters := Item.GetFilters;

                recAccountBalance.Reset();
                recAccountBalance.DeleteAll();
                if dtStartDate <> dtBlankDate then begin
                    Clear(qryItemBalance);
                    qryItemBalance.setfilter(Posting_Date, '..%1', closingdate(dtStartDate - 1));
                    if txtLocationFiter <> '' then
                        qryItemBalance.Setfilter(Location_Code, txtLocationFiter);
                    if txtGlobalDim1Filter <> '' then
                        qryItemBalance.setfilter(Global_Dimension_1_Code, txtGlobalDim1Filter);
                    if txtGlobalDim2Filter <> '' then
                        qryItemBalance.setfilter(Global_Dimension_2_Code, txtGlobalDim2Filter);
                    if txtAccountFilter <> '' then
                        qryItemBalance.setfilter(Item_No_, txtAccountFilter);
                    qryItemBalance.Open();
                    while qryItemBalance.Read() do begin
                        recAccountBalance.Init();
                        recAccountBalance."Customer No." := qryItemBalance.Item_No_;
                        recAccountBalance."Amount (LCY)" := qryItemBalance.Quantity;
                        recAccountBalance.Insert();
                    end;
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                decOpeningBalance := 0;
                recAccountBalance.RESET;
                recAccountBalance.SetRange("Customer No.", Item."No.");
                IF recAccountBalance.FIND('-') THEN BEGIN
                    decOpeningBalance := recAccountBalance."Amount (LCY)";
                END;
                decRunningBalance := decOpeningBalance;
                decTotalDebitAmount := 0;
                decTotalCreditAmount := 0;

                IF decOpeningBalance > 0 THEN
                    decTotalDebitAmount := decOpeningBalance
                ELSE
                    decTotalCreditAmount := decOpeningBalance;
                decTotalCreditAmount := ABS(decTotalCreditAmount);

            end;
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        txtHeading: Text[250];
        decOpeningBalance: Decimal;
        txtNarration: Text;
        decRunningBalance: Decimal;
        decTotalDebitAmount: Decimal;
        decTotalCreditAmount: Decimal;
        dtStartDate: Date;
        dtEndDate: Date;
        dtBlankDate: Date;
        qryItemBalance: Query "Item Ledger Report";
        recAccountBalance: Record "Customer Amount" temporary;
        txtGlobalDim1Filter: Text;
        txtGlobalDim2Filter: Text;
        txtAccountFilter: Text;
        txtLocationFiter: Text;
        recpurchcommline: Record "Purch. Comment Line";
        recSalescommline: Record "Sales Comment Line";
        //        recPostedNarration: Record;
        decInwardQuantity: Decimal;
        decOutwardQuantity: Decimal;
        txtFilters: Text;
}