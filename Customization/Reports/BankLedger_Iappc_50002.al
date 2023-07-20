report 50002 "Bank Ledger"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\BankLedger_Iappc_50002.rdl';

    dataset
    {
        dataitem(BankAccount; "Bank Account")
        {
            RequestFilterFields = "No.", "Date Filter";
            DataItemTableView = sorting("No.");

            column(CompanyName; recCompanyInfo.Name)
            { }
            column(Heading; txtHeading)
            { }
            column(txtFilters; txtFilters)
            { }
            column(AccountNo; BankAccount."No.")
            { }
            column(AccountName; BankAccount.Name)
            { }
            column(OpeningBalance; decOpeningBalance)
            { }
            column(BankAccNo; BankAccount."Bank Account No.") { }
            column(GLNo; recBankGLAcc."No.") { }
            column(GLName; recBankGLAcc.Name) { }
            column(AccountCategory; Format(recBankGLAcc."Account Category")) { }

            dataitem(BankEntry; "Bank Account Ledger Entry")
            {
                DataItemTableView = sorting("Bank Account No.", "Posting Date");
                DataItemLink = "Bank Account No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
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
                column(Transaction_Nature; "Transaction Nature") { }
                column(Document_No_; "Document No.")
                { }
                column(Document_Date; Format("Document Date")) { }
                column(External_Document_No_; "External Document No.") { }
                column(Narration; txtnarration)
                { }
                column(Currency_Code; "Currency Code")
                { }
                column(Amount; decFCYAmount)
                { }
                column(Debit_Amount; "Debit Amount (LCY)")
                { }
                column(Credit_Amount; "Credit Amount (LCY)")
                { }
                column(Amount__LCY_; "Amount (LCY)") { }
                column(RunningBalance; decRunningBalance)
                { }
                column(TotalDebitAmount; decTotalDebitAmount)
                { }
                column(TotalCreditAmount; decTotalCreditAmount)
                { }
                column(OffSetGLNo; cdOffSetGLNo) { }
                column(OffSetGLName; txtOffGLName) { }
                column(VendCustNo; cdVendCustCode) { }
                column(VendCustName; txtVendCustName) { }
                column(Created_By; "Created By") { }
                column(Posted_By; "Posted By") { }

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
                    decRunningBalance += BankEntry."Debit Amount (LCY)" - BankEntry."Credit Amount (LCY)";
                    decTotalDebitAmount += BankEntry."Debit Amount (LCY)";
                    decTotalCreditAmount += BankEntry."Credit Amount (LCY)";
                    if BankEntry."Currency Code" <> '' then
                        decFCYAmount := BankEntry.Amount
                    else
                        decFCYAmount := 0;

                    cdOffSetGLNo := '';
                    cdVendCustCode := '';
                    txtOffGLName := '';
                    txtVendCustName := '';
                    recGLEntry.Get(BankEntry."Entry No.");
                    if (recGLEntry."Source Type" = recGLEntry."Source Type"::Customer) and (recGLEntry."Source No." <> '') then begin
                        cdVendCustCode := recGLEntry."Source No.";
                        recCustomer.Get(recGLEntry."Source No.");
                        txtVendCustName := recCustomer.Name;
                    end;
                    if (recGLEntry."Source Type" = recGLEntry."Source Type"::Vendor) and (recGLEntry."Source No." <> '') then begin
                        cdVendCustCode := recGLEntry."Source No.";
                        recVendor.Get(recGLEntry."Source No.");
                        txtVendCustName := recVendor.Name;
                    end;
                    recGLEntry.Reset();
                    recGLEntry.SetCurrentKey("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                    recGLEntry.SetRange("Document No.", BankEntry."Document No.");
                    recGLEntry.SetRange("Transaction No.", BankEntry."Transaction No.");
                    recGLEntry.SetRange("Posting Date", BankEntry."Posting Date");
                    recGLEntry.SetFilter("G/L Account No.", '<>%1', recBankGLAcc."No.");
                    if recGLEntry.FindFirst() then begin
                        cdOffSetGLNo := recGLEntry."G/L Account No.";
                        recGLEntry.CalcFields("G/L Account Name");
                        txtOffGLName := recGLEntry."G/L Account Name";
                    end;

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
                IF BankAccount.GETRANGEMIN("Date Filter") <> 0D THEN
                    dtStartDate := BankAccount.GETRANGEMIN("Date Filter");
                IF BankAccount.GETRANGEMAX("Date Filter") <> 0D THEN
                    dtEndDate := BankAccount.GETRANGEMAX("Date Filter");

                IF BankAccount.GETFILTER("Global Dimension 1 Filter") <> '' THEN
                    txtGlobalDim1Filter := BankAccount.GETFILTER("Global Dimension 1 Filter");

                IF BankAccount.GETFILTER("Global Dimension 2 Filter") <> '' THEN
                    txtGlobalDim2Filter := BankAccount.GETFILTER("Global Dimension 2 Filter");
                txtAccountFilter := BankAccount.GetFilter("No.");

                txtHeading := 'Bank Account Ledger Report';
                txtFilters := BankAccount.GetFilters;

                recAccountBalance.Reset();
                recAccountBalance.DeleteAll();
                if dtStartDate <> dtBlankDate then begin
                    Clear(qryBankBalance);
                    qryBankBalance.setfilter(Posting_Date, '..%1', closingdate(dtStartDate - 1));
                    if txtGlobalDim1Filter <> '' then
                        qryBankBalance.setfilter(Global_Dimension_1_Code, txtGlobalDim1Filter);
                    if txtGlobalDim2Filter <> '' then
                        qryBankBalance.setfilter(Global_Dimension_2_Code, txtGlobalDim2Filter);
                    if txtAccountFilter <> '' then
                        qryBankBalance.setfilter(Bank_Account_No_, txtAccountFilter);
                    qryBankBalance.Open();
                    while qryBankBalance.Read() do begin
                        recAccountBalance.Init();
                        recAccountBalance."Customer No." := qryBankBalance.Bank_Account_No_;
                        recAccountBalance."Amount (LCY)" := qryBankBalance.Amount__LCY_;
                        recAccountBalance.Insert();
                    end;
                    qryBankBalance.close;
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                if not recBankAccPostingGroup.Get(BankAccount."Bank Acc. Posting Group") then
                    recBankAccPostingGroup.Init()
                else begin
                    recBankAccPostingGroup.TestField("G/L Account No.");
                    recBankGLAcc.Get(recBankAccPostingGroup."G/L Account No.");
                end;

                decOpeningBalance := 0;
                recAccountBalance.RESET;
                recAccountBalance.SetRange("Customer No.", BankAccount."No.");
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
        qryBankBalance: Query "Bank Ledger Report";
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
        cdOffSetGLNo: Code[20];
        cdVendCustCode: Code[20];
        txtOffGLName: Text[100];
        txtVendCustName: Text[100];
        recGLAccount: Record "G/L Account";
        recVendor: Record Vendor;
        recCustomer: Record Customer;
        recBankAccPostingGroup: Record "Bank Account Posting Group";
        recBankGLAcc: Record "G/L Account";
        recGLEntry: Record "G/L Entry";
}