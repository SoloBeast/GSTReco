report 50000 "Customer Ledger"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\CustomerLedger_Iappc_50000.rdl';

    dataset
    {
        dataitem(Customer; Customer)
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
            column(AccountNo; Customer."No.")
            { }
            column(AccountName; Customer.Name)
            { }
            column(OpeningBalance; decOpeningBalance)
            { }

            dataitem(CustomerEntry; "Cust. Ledger Entry")
            {
                DataItemTableView = sorting("Customer NO.", "Posting Date");
                DataItemLink = "Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
                                "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                CalcFields = "Debit Amount (LCY)", "Credit Amount (LCY)", Amount, "Amount (LCY)";
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
                column(External_Document_No_; "External Document No.") { }
                column(Due_Date; Format("Due Date")) { }
                column(OffSetAccNo; recGLEntry."G/L Account No.") { }
                column(OffsetAcc; txtOffSetLedger) { }
                column(Narration; txtnarration)
                { }
                column(Currency_Code; "Currency Code")
                { }
                column(ExchangeRate; decExchangeRate) { }
                column(FCYAmount; decFCYAmount)
                { }
                column(Debit_Amount; "Debit Amount (LCY)")
                { }
                column(Credit_Amount; "Credit Amount (LCY)")
                { }
                column(Remaining_Amt___LCY_; "Remaining Amt. (LCY)")
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
                        if blnPrintDetails = false then
                            CurrReport.Break();
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    decRunningBalance += CustomerEntry."Debit Amount (LCY)" - CustomerEntry."Credit Amount (LCY)";
                    decTotalDebitAmount += CustomerEntry."Debit Amount (LCY)";
                    decTotalCreditAmount += CustomerEntry."Credit Amount (LCY)";

                    if CustomerEntry."Currency Code" <> '' then
                        decFCYAmount := CustomerEntry.Amount
                    else
                        decFCYAmount := 0;

                    if decFCYAmount <> 0 then
                        decExchangeRate := Round(CustomerEntry."Amount (LCY)" / CustomerEntry.Amount)
                    else
                        decExchangeRate := 0;

                    txtOffSetLedger := '';
                    recGLEntry.Reset();
                    recGLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
                    recGLEntry.SetRange("Document No.", CustomerEntry."Document No.");
                    recGLEntry.SetRange("Transaction No.", CustomerEntry."Transaction No.");
                    recGLEntry.SetRange("Posting Date", CustomerEntry."Posting Date");
                    recGLEntry.SetFilter("Entry No.", '<>%1', CustomerEntry."Entry No.");
                    if CustomerEntry."Amount (LCY)" > 0 then
                        recGLEntry.SetFilter(Amount, '<%1', 0)
                    else
                        recGLEntry.SetFilter(Amount, '>%1', 0);
                    recGLEntry.FindFirst();
                    recGLEntry.CalcFields("G/L Account Name");
                    txtOffSetLedger := recGLEntry."G/L Account Name";

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
                IF Customer.GETRANGEMIN("Date Filter") <> 0D THEN
                    dtStartDate := Customer.GETRANGEMIN("Date Filter");
                IF Customer.GETRANGEMAX("Date Filter") <> 0D THEN
                    dtEndDate := Customer.GETRANGEMAX("Date Filter");

                IF Customer.GETFILTER("Global Dimension 1 Filter") <> '' THEN
                    txtGlobalDim1Filter := Customer.GETFILTER("Global Dimension 1 Filter");

                IF Customer.GETFILTER("Global Dimension 2 Filter") <> '' THEN
                    txtGlobalDim2Filter := Customer.GETFILTER("Global Dimension 2 Filter");
                txtAccountFilter := Customer.GetFilter("No.");

                txtHeading := 'Customer Ledger Report';
                txtFilters := Customer.GetFilters;

                recAccountBalance.Reset();
                recAccountBalance.DeleteAll();
                if dtStartDate <> dtBlankDate then begin
                    Clear(qryCustomerBalance);
                    qryCustomerBalance.setfilter(Posting_Date, '..%1', closingdate(dtStartDate - 1));
                    if txtGlobalDim1Filter <> '' then
                        qryCustomerBalance.setfilter(Global_Dimension_1_Code, txtGlobalDim1Filter);
                    if txtGlobalDim2Filter <> '' then
                        qryCustomerBalance.setfilter(Global_Dimension_2_Code, txtGlobalDim2Filter);
                    if txtAccountFilter <> '' then
                        qryCustomerBalance.setfilter(Customer_No_, txtAccountFilter);
                    qryCustomerBalance.Open();
                    while qryCustomerBalance.Read() do begin
                        recAccountBalance.Init();
                        recAccountBalance."Customer No." := qryCustomerBalance.Customer_No_;
                        recAccountBalance."Amount (LCY)" := qryCustomerBalance.Amount__LCY_;
                        recAccountBalance.Insert();
                    end;
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                decOpeningBalance := 0;
                recAccountBalance.RESET;
                recAccountBalance.SetRange("Customer No.", Customer."No.");
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
                    field(blnPrintDetails; blnPrintDetails)
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
        qryCustomerBalance: Query "Customer Ledger Report";
        recAccountBalance: Record "Customer Amount" temporary;
        txtGlobalDim1Filter: Text;
        txtGlobalDim2Filter: Text;
        txtAccountFilter: Text;
        recpurchcommline: Record "Purch. Comment Line";
        recSalescommline: Record "Sales Comment Line";
        blnPrintDetails: Boolean;
        txtFilters: Text;
        decFCYAmount: Decimal;
        recPostedNarration: Record "Posted Narration";
        decExchangeRate: Decimal;
        txtOffSetLedger: Text[100];
        recGLEntry: Record "G/L Entry";
}