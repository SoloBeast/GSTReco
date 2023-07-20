report 50004 "FA Ledger"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\FALedger_Iappc_50004.rdl';

    dataset
    {
        dataitem(FAAccount; "Fixed Asset")
        {
            RequestFilterFields = "No.", "Date Filter";
            DataItemTableView = sorting("No.");

            column(CompanyName; recCompanyInfo.Name)
            { }
            column(Heading; txtHeading)
            { }
            column(UserID; UserId)
            { }
            column(TimeStamp; Format(CurrentDateTime))
            { }
            column(txtFilters; txtFilters)
            { }
            column(AccountNo; FAAccount."No.")
            { }
            column(AccountName; FAAccount.Description)
            { }
            column(OpeningBalance; decOpeningBalance)
            { }

            dataitem(FAEntry; "FA Ledger Entry")
            {
                DataItemTableView = sorting("FA NO.", "Posting Date");
                DataItemLink = "FA No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
                                "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                column(EntryNo; "Entry No.")
                { }
                column(Posting_Date; format(NormalDate("Posting Date")))
                { }
                column(Sorting_Date; normaldate("Posting Date"))
                { }
                column(Document_Type; "Document Type")
                { }
                column(Document_No_; "Document No.")
                { }
                column(Narration; txtnarration)
                { }
                column(Debit_Amount; decLineDebitAmount)
                { }
                column(Credit_Amount; decLineCreditAmount)
                { }
                column(RunningBalance; decRunningBalance)
                { }
                column(TotalDebitAmount; decTotalDebitAmount)
                { }
                column(TotalCreditAmount; decTotalCreditAmount)
                { }
                dataitem(DetailedGLEntry; "G/L Entry")
                {
                    DataItemTableView = sorting("Transaction No.");
                    DataItemLink = "Transaction No." = field("Transaction No.");
                    column(RefEntryNo; detailedglentry."Document No." + format(DetailedGLEntry."Entry No."))
                    { }
                    column(DetailedAccNo; "G/L Account No.")
                    { }
                    column(DetailedAccName; "G/L Account Name")
                    { }
                    column(DetailedDebitAmt; "Debit Amount")
                    { }
                    column(DetailedCreditAmt; "Credit Amount")
                    { }
                    trigger OnPreDataItem()
                    begin
                        if blnPrintDetail = false then
                            CurrReport.Break();
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    decRunningBalance += FAEntry."Amount (LCY)";
                    decLineDebitAmount := 0;
                    decLineCreditAmount := 0;
                    if FAEntry."Amount (LCY)" > 0 then
                        decLineDebitAmount := FAEntry."Amount (LCY)"
                    else
                        decLineCreditAmount := -FAEntry."Amount (LCY)";
                    decTotalDebitAmount += decLineDebitAmount;
                    decTotalCreditAmount += decLineCreditAmount;

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

                    recPostedNarration.Reset();
                    recPostedNarration.SetRange("Document No.", "Document No.");
                    recPostedNarration.SetRange("Transaction No.", "Transaction No.");
                    if recPostedNarration.FindFirst() then
                        repeat
                            txtNarration += ' ' + recPostedNarration.Narration;
                        until recPostedNarration.Next() = 0;

                    if txtNarration = '' then
                        txtNarration := Description;

                end;
            }
            trigger OnPreDataItem()
            begin
                recCompanyInfo.get;
                IF FAAccount.GETRANGEMIN("Date Filter") <> 0D THEN
                    dtStartDate := FAAccount.GETRANGEMIN("Date Filter");
                IF FAAccount.GETRANGEMAX("Date Filter") <> 0D THEN
                    dtEndDate := FAAccount.GETRANGEMAX("Date Filter");

                IF FAAccount.GETFILTER("Global Dimension 1 Filter") <> '' THEN
                    txtGlobalDim1Filter := FAAccount.GETFILTER("Global Dimension 1 Filter");

                IF FAAccount.GETFILTER("Global Dimension 2 Filter") <> '' THEN
                    txtGlobalDim2Filter := FAAccount.GETFILTER("Global Dimension 2 Filter");
                txtAccountFilter := FAAccount.GetFilter("No.");

                txtHeading := 'Fixed Asset Ledger Report';
                txtFilters := FAAccount.GetFilters;

                recAccountBalance.Reset();
                recAccountBalance.DeleteAll();
                if dtStartDate <> dtBlankDate then begin
                    Clear(qryFABalance);
                    qryFABalance.setfilter(Posting_Date, '..%1', closingdate(dtStartDate - 1));
                    if txtGlobalDim1Filter <> '' then
                        qryFABalance.setfilter(Global_Dimension_1_Code, txtGlobalDim1Filter);
                    if txtGlobalDim2Filter <> '' then
                        qryFABalance.setfilter(Global_Dimension_2_Code, txtGlobalDim2Filter);
                    if txtAccountFilter <> '' then
                        qryFABalance.setfilter(FA_No_, txtAccountFilter);
                    qryFABalance.Open();
                    while qryFABalance.Read() do begin
                        recAccountBalance.Init();
                        recAccountBalance."Customer No." := qryFABalance.FA_No_;
                        recAccountBalance."Amount (LCY)" := qryFABalance.Amount__LCY_;
                        recAccountBalance.Insert();
                    end;
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                decOpeningBalance := 0;
                recAccountBalance.RESET;
                recAccountBalance.SetRange("Customer No.", FAAccount."No.");
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
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = 'Filters';
                    field(blnPrintDetail; blnPrintDetail)
                    {
                        Caption = 'Print Details';
                        ApplicationArea = All;
                    }
                }
            }
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
        qryFABalance: Query "FA Ledger Report";
        recAccountBalance: Record "Customer Amount" temporary;
        txtGlobalDim1Filter: Text;
        txtGlobalDim2Filter: Text;
        txtAccountFilter: Text;
        recpurchcommline: Record "Purch. Comment Line";
        recSalescommline: Record "Sales Comment Line";
        recPostedNarration: Record "Posted Narration";
        blnPrintDetail: Boolean;
        decLineDebitAmount: Decimal;
        decLineCreditAmount: Decimal;
        txtFilters: Text;
}