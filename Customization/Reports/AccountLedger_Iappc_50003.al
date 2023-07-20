report 50003 "Account Ledger"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\AccountLedger_Iappc_50003.rdl';

    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {
            RequestFilterFields = "No.", "Date Filter";
            DataItemTableView = sorting("No.");

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; txtHeading) { }
            column(UserID; UserId)
            { }
            column(TimeStamp; Format(CurrentDateTime))
            { }
            column(txtFilters; txtFilters) { }
            column(PrintDetail; Format(blnPrintDetail)) { }
            column(PrintDimensions; Format(blnPrintDimensions)) { }
            column(AccountNo; GLAccount."No.") { }
            column(AccountName; GLAccount.Name) { }
            column(OpeningBalance; decOpeningBalance) { }
            column(AccountCategory; "Account Category") { }

            dataitem(GLEntry; "G/L Entry")
            {
                DataItemTableView = sorting("G/l Account NO.", "Posting Date");
                DataItemLink = "G/L Account No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
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
                column(TransactionNature; Format("Transaction Nature")) { }
                column(Document_Date; "Document Date") { }
                column(External_Document_No_; "External Document No.") { }
                column(NetAmount; Amount) { }
                column(OffSetGLNo; cdOffSetGLNo) { }
                column(OffSetGLName; txtOffGLName) { }
                column(VendCustNo; cdVendCustCode) { }
                column(VendCustName; txtVendCustName) { }
                column(Created_By; "Created By") { }
                column(Posted_By; "Posted By") { }
                column(Document_No_; "Document No.")
                { }
                column(Narration; txtnarration)
                { }
                column(Debit_Amount; "Debit Amount")
                { }
                column(Credit_Amount; "Credit Amount")
                { }
                column(RunningBalance; decRunningBalance)
                { }
                column(TotalDebitAmount; decTotalDebitAmount)
                { }
                column(TotalCreditAmount; decTotalCreditAmount)
                { }
                dataitem(DetailedGLEntry; Integer)
                {
                    DataItemTableView = sorting(Number);
                    column(RefEntryNo; recDetailedEntryData."Line No.") { }
                    column(EntryType; recDetailedEntryData."Transaction Information") { }
                    column(DetailedAccNo; recDetailedEntryData."Account No.") { }
                    column(DimensionValueCode; recDetailedEntryData."Shortcut Dimension 1 Code") { }
                    column(DetailedAccName; recDetailedEntryData.Description) { }
                    column(DetailedDebitAmt; recDetailedEntryData.Amount) { }
                    column(DetailedCreditAmt; 0) { }

                    trigger OnPreDataItem()
                    begin
                        recDetailedEntryData.Reset();
                        DetailedGLEntry.SetRange(Number, 1, recDetailedEntryData.Count);
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        recDetailedEntryData.Reset();
                        recDetailedEntryData.SetRange("Line No.", DetailedGLEntry.Number);
                        recDetailedEntryData.FindFirst();
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    decRunningBalance += GLEntry.Amount;
                    decTotalDebitAmount += GLEntry."Debit Amount";
                    decTotalCreditAmount += GLEntry."Credit Amount";

                    cdOffSetGLNo := '';
                    cdVendCustCode := '';
                    txtOffGLName := '';
                    txtVendCustName := '';
                    if (GLEntry."Source Type" = GLEntry."Source Type"::Customer) and (GLEntry."Source No." <> '') then begin
                        cdVendCustCode := GLEntry."Source No.";
                        recCustomer.Get(GLEntry."Source No.");
                        txtVendCustName := recCustomer.Name;
                    end;
                    if (GLEntry."Source Type" = GLEntry."Source Type"::Vendor) and (GLEntry."Source No." <> '') then begin
                        cdVendCustCode := GLEntry."Source No.";
                        recVendor.Get(GLEntry."Source No.");
                        txtVendCustName := recVendor.Name;
                    end;
                    recGLEntry.Reset();
                    recGLEntry.SetCurrentKey("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                    recGLEntry.SetRange("Document No.", GLEntry."Document No.");
                    recGLEntry.SetRange("Transaction No.", GLEntry."Transaction No.");
                    recGLEntry.SetRange("Posting Date", GLEntry."Posting Date");
                    recGLEntry.SetFilter("G/L Account No.", '<>%1', GLEntry."G/L Account No.");
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

                    recDetailedEntryData.Reset();
                    recDetailedEntryData.DeleteAll();
                    intLineNo := 0;
                    if blnPrintDetail then begin
                        recGLEntry.Reset();
                        recGLEntry.SetRange("Transaction No.", GLEntry."Transaction No.");
                        if recGLEntry.FindSet() then begin
                            recDetailedEntryData.Init();
                            intLineNo += 1;
                            recDetailedEntryData."Line No." := intLineNo;
                            recDetailedEntryData."Transaction Information" := 'Detailed Entry';
                            recDetailedEntryData.Insert();
                            repeat
                                recGLEntry.CalcFields("G/L Account Name");

                                recDetailedEntryData.Init();
                                intLineNo += 1;
                                recDetailedEntryData."Line No." := intLineNo;
                                recDetailedEntryData."Account No." := recGLEntry."G/L Account No.";
                                recDetailedEntryData.Description := recGLEntry."G/L Account Name";
                                recDetailedEntryData.Amount := recGLEntry.Amount;
                                recDetailedEntryData.Insert();
                            until recGLEntry.Next() = 0;
                        end;
                    end;

                    if blnPrintDimensions then begin
                        recDimensionSetEntry.Reset();
                        recDimensionSetEntry.SetRange("Dimension Set ID", GLEntry."Dimension Set ID");
                        if recDimensionSetEntry.FindSet() then begin
                            recDetailedEntryData.Init();
                            intLineNo += 1;
                            recDetailedEntryData."Line No." := intLineNo;
                            recDetailedEntryData."Transaction Information" := 'Dimension Details';
                            recDetailedEntryData.Insert();
                            repeat
                                recDimensionSetEntry.CalcFields("Dimension Value Name");

                                recDetailedEntryData.Init();
                                intLineNo += 1;
                                recDetailedEntryData."Line No." := intLineNo;
                                recDetailedEntryData."Account No." := recDimensionSetEntry."Dimension Code";
                                recDetailedEntryData."Shortcut Dimension 1 Code" := recDimensionSetEntry."Dimension Value Code";
                                recDetailedEntryData.Description := recDimensionSetEntry."Dimension Value Name";
                                recDetailedEntryData.Insert();
                            until recDimensionSetEntry.Next() = 0;
                        end;
                    end;
                end;
            }
            trigger OnPreDataItem()
            begin
                recCompanyInfo.get;
                IF GLAccount.GETRANGEMIN("Date Filter") <> 0D THEN
                    dtStartDate := GLAccount.GETRANGEMIN("Date Filter");
                IF GLAccount.GETRANGEMAX("Date Filter") <> 0D THEN
                    dtEndDate := GLAccount.GETRANGEMAX("Date Filter");

                IF GLAccount.GETFILTER("Global Dimension 1 Filter") <> '' THEN
                    txtGlobalDim1Filter := GLAccount.GETFILTER("Global Dimension 1 Filter");

                IF GLAccount.GETFILTER("Global Dimension 2 Filter") <> '' THEN
                    txtGlobalDim2Filter := GLAccount.GETFILTER("Global Dimension 2 Filter");
                txtAccountFilter := GLAccount.GetFilter("No.");

                txtHeading := 'Account Ledger Report';
                txtFilters := GLAccount.GetFilters;

                recAccountBalance.Reset();
                recAccountBalance.DeleteAll();
                if dtStartDate <> dtBlankDate then begin
                    Clear(qryAccountBalance);
                    qryAccountBalance.setfilter(Posting_Date, '..%1', closingdate(dtStartDate - 1));
                    if txtGlobalDim1Filter <> '' then
                        qryAccountBalance.setfilter(Global_Dimension_1_Code, txtGlobalDim1Filter);
                    if txtGlobalDim2Filter <> '' then
                        qryAccountBalance.setfilter(Global_Dimension_2_Code, txtGlobalDim2Filter);
                    if txtAccountFilter <> '' then
                        qryAccountBalance.setfilter(G_L_Account_No_, txtAccountFilter);
                    qryAccountBalance.Open();
                    while qryAccountBalance.Read() do begin
                        recAccountBalance.Init();
                        recAccountBalance."Customer No." := qryAccountBalance.G_L_Account_No_;
                        recAccountBalance."Amount (LCY)" := qryAccountBalance.Amount;
                        recAccountBalance.Insert();
                    end;
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                decOpeningBalance := 0;
                recAccountBalance.RESET;
                recAccountBalance.SetRange("Customer No.", GLAccount."No.");
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
                    field(blnPrintDimensions; blnPrintDimensions)
                    {
                        Caption = 'Print Dimensions';
                        ApplicationArea = all;
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
        qryAccountBalance: Query "GL Ledger Report";
        recAccountBalance: Record "Customer Amount" temporary;
        txtGlobalDim1Filter: Text;
        txtGlobalDim2Filter: Text;
        txtAccountFilter: Text;
        recpurchcommline: Record "Purch. Comment Line";
        recSalescommline: Record "Sales Comment Line";
        recPostedNarration: Record "Posted Narration";
        blnPrintDetail: Boolean;
        txtFilters: Text;
        blnPrintDimensions: Boolean;
        recGLEntry: Record "G/L Entry";
        recDimensionSetEntry: Record "Dimension Set Entry";
        recDetailedEntryData: Record "Gen. Journal Line" temporary;
        intLineNo: Integer;
        cdOffSetGLNo: Code[20];
        cdVendCustCode: Code[20];
        txtOffGLName: Text[100];
        txtVendCustName: Text[100];
        recGLAccount: Record "G/L Account";
        recVendor: Record Vendor;
        recCustomer: Record Customer;
}