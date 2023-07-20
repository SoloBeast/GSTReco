report 50006 "Employee Ledger"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\EmployeeLedger_Iappc_50006.rdl';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.", "Date Filter";
            DataItemTableView = sorting("No.");

            column(CompanyName; recCompanyInfo.Name)
            { }
            column(Heading; txtHeading)
            { }
            column(txtFilters; txtFilters)
            { }
            column(AccountNo; Employee."No.")
            { }
            column(AccountName; Employee.FullName())
            { }
            column(OpeningBalance; decOpeningBalance)
            { }

            dataitem(EmployeeEntry; "Employee Ledger Entry")
            {
                DataItemTableView = sorting("Employee NO.", "Posting Date");
                DataItemLink = "Employee No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
                                "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                CalcFields = "Debit Amount (LCY)", "Credit Amount (LCY)", Amount;
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
                column(Currency_Code; "Currency Code")
                { }
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
                    decRunningBalance += EmployeeEntry."Debit Amount (LCY)" - EmployeeEntry."Credit Amount (LCY)";
                    decTotalDebitAmount += EmployeeEntry."Debit Amount (LCY)";
                    decTotalCreditAmount += EmployeeEntry."Credit Amount (LCY)";

                    if EmployeeEntry."Currency Code" <> '' then
                        decFCYAmount := EmployeeEntry.Amount
                    else
                        decFCYAmount := 0;

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
                IF Employee.GETRANGEMIN("Date Filter") <> 0D THEN
                    dtStartDate := Employee.GETRANGEMIN("Date Filter");
                IF Employee.GETRANGEMAX("Date Filter") <> 0D THEN
                    dtEndDate := Employee.GETRANGEMAX("Date Filter");

                IF Employee.GETFILTER("Global Dimension 1 Filter") <> '' THEN
                    txtGlobalDim1Filter := Employee.GETFILTER("Global Dimension 1 Filter");

                IF Employee.GETFILTER("Global Dimension 2 Filter") <> '' THEN
                    txtGlobalDim2Filter := Employee.GETFILTER("Global Dimension 2 Filter");
                txtAccountFilter := Employee.GetFilter("No.");

                txtHeading := 'Employee Ledger Report';
                txtFilters := Employee.GetFilters;

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
                        qryCustomerBalance.setfilter(Employee_No_, txtAccountFilter);
                    qryCustomerBalance.Open();
                    while qryCustomerBalance.Read() do begin
                        recAccountBalance.Init();
                        recAccountBalance."Customer No." := qryCustomerBalance.Employee_No_;
                        recAccountBalance."Amount (LCY)" := qryCustomerBalance.Amount__LCY_;
                        recAccountBalance.Insert();
                    end;
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                decOpeningBalance := 0;
                recAccountBalance.RESET;
                recAccountBalance.SetRange("Customer No.", Employee."No.");
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
        qryCustomerBalance: Query "Employee Ledger Report";
        recAccountBalance: Record "Customer Amount" temporary;
        txtGlobalDim1Filter: Text;
        txtGlobalDim2Filter: Text;
        txtAccountFilter: Text;
        blnPrintDetails: Boolean;
        txtFilters: Text;
        decFCYAmount: Decimal;
        recPurchCommLine: Record "Purch. Comment Line";
        recSalesCommLine: Record "Sales Comment Line";
        recPostedNarration: Record "Posted Narration";
}