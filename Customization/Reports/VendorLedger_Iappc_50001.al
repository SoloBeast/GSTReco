report 50001 "Vendor Ledger"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\VendorLedger_Iappc_50001.rdl';

    dataset
    {
        dataitem(Vendor; Vendor)
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
            column(AccountNo; Vendor."No.")
            { }
            column(AccountName; Vendor.Name)
            { }
            column(OpeningBalance; decOpeningBalance)
            { }

            dataitem(VendorEntry; "Vendor Ledger Entry")
            {
                DataItemTableView = sorting("Vendor NO.", "Posting Date");
                DataItemLink = "Vendor No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
                                "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                CalcFields = "Debit Amount (LCY)", "Credit Amount (LCY)", Amount, "Amount (LCY)";
                column(EntryNo; "Entry No.")
                { }
                column(OfSetAccNo; recGLEntry."G/L Account No.") { }
                column(ExpenseLedger; txtExpenseLedger) { }
                column(Posting_Date; format(NormalDate("Posting Date")))
                { }
                column(Sorting_Date; normaldate("Posting Date"))
                { }
                column(Document_Date; format(NormalDate("Document Date")))
                { }
                column(External_Document_No_; "External Document No.")
                { }
                column(Document_Type; "Document Type")
                { }
                column(Document_No_; "Document No.")
                { }
                column(Narration; txtnarration)
                { }
                column(Currency_Code; "Currency Code")
                { }
                column(ExchangeRate; decExchangeRate) { }
                column(FCYAmount; decFCYAmount)
                { }
                column(Total_TDS_Including_SHE_CESS; "Total TDS Including SHE CESS")
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
                dataitem(EntryDetail; Integer)
                {
                    DataItemTableView = sorting(Number);

                    column(RefEntryNo; recApplicationEntry."Document No." + format(recApplicationEntry."Line No."))
                    { }
                    column(DataHeading; Format(recApplicationEntry."Reversing Entry")) { }
                    column(DetailedAccNo; recApplicationEntry."Account No.")
                    { }
                    column(DetailedAccName; recApplicationEntry.Description)
                    { }
                    column(DetailedDebitAmt; recApplicationEntry."Debit Amount")
                    { }
                    column(DetailedCreditAmt; recApplicationEntry."Credit Amount")
                    { }
                    trigger OnPreDataItem()
                    begin
                        recApplicationEntry.Reset();
                        EntryDetail.SetRange(Number, 1, recApplicationEntry.Count);
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        recApplicationEntry.Reset();
                        recApplicationEntry.SetRange("Line No.", EntryDetail.Number);
                        recApplicationEntry.FindFirst();
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    decRunningBalance += VendorEntry."Debit Amount (LCY)" - VendorEntry."Credit Amount (LCY)";
                    decTotalDebitAmount += VendorEntry."Debit Amount (LCY)";
                    decTotalCreditAmount += VendorEntry."Credit Amount (LCY)";

                    if VendorEntry."Currency Code" <> '' then
                        decFCYAmount := VendorEntry.Amount
                    else
                        decFCYAmount := 0;

                    if decFCYAmount <> 0 then
                        decExchangeRate := Round(VendorEntry."Amount (LCY)" / VendorEntry.Amount)
                    else
                        decExchangeRate := 0;

                    txtExpenseLedger := '';
                    recGLEntry.Reset();
                    recGLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
                    recGLEntry.SetRange("Document No.", VendorEntry."Document No.");
                    recGLEntry.SetRange("Transaction No.", VendorEntry."Transaction No.");
                    recGLEntry.SetRange("Posting Date", VendorEntry."Posting Date");
                    recGLEntry.SetFilter("Entry No.", '<>%1', VendorEntry."Entry No.");
                    if VendorEntry."Amount (LCY)" > 0 then
                        recGLEntry.SetFilter(Amount, '<%1', 0)
                    else
                        recGLEntry.SetFilter(Amount, '>%1', 0);
                    recGLEntry.FindFirst();
                    recGLEntry.CalcFields("G/L Account Name");
                    txtExpenseLedger := recGLEntry."G/L Account Name";

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

                    recApplicationEntry.Reset();
                    recApplicationEntry.DeleteAll();
                    intLineNo := 0;
                    if blnPrintDetails then begin
                        recGLEntry.Reset();
                        recGLEntry.SetCurrentKey("Transaction No.");
                        recGLEntry.SetRange("Transaction No.", VendorEntry."Transaction No.");
                        if recGLEntry.FindFirst() then begin
                            recApplicationEntry.Init();
                            intLineNo += 1;
                            recApplicationEntry."Line No." := intLineNo;
                            recApplicationEntry."Document No." := VendorEntry."Document No.";
                            recApplicationEntry.Description := 'Detailed Entries';
                            recApplicationEntry."Reversing Entry" := true;
                            recApplicationEntry.Insert();
                            repeat
                                recGLEntry.CalcFields("G/L Account Name");

                                recApplicationEntry.Init();
                                intLineNo += 1;
                                recApplicationEntry."Line No." := intLineNo;
                                recApplicationEntry."IC Partner Transaction No." := recGLEntry."Entry No.";
                                recApplicationEntry."Document No." := VendorEntry."Document No.";
                                recApplicationEntry."Account No." := recGLEntry."G/L Account No.";
                                recApplicationEntry.Description := recGLEntry."G/L Account Name";
                                recApplicationEntry."Debit Amount" := recGLEntry."Debit Amount";
                                recApplicationEntry."Credit Amount" := recGLEntry."Credit Amount";
                                recApplicationEntry.Insert();
                            until recGLEntry.Next() = 0;
                        end;
                    end;
                    if blnPrintApplication then begin
                        recApplicationEntry.Init();
                        intLineNo += 1;
                        recApplicationEntry."Line No." := intLineNo;
                        recApplicationEntry."Document No." := VendorEntry."Document No.";
                        recApplicationEntry.Description := 'Application Details';
                        recApplicationEntry."Reversing Entry" := true;
                        recApplicationEntry.Insert();

                        FindApplnEntriesDtldtLedgEntry();
                    end;
                end;
            }
            trigger OnPreDataItem()
            begin
                recCompanyInfo.get;
                IF Vendor.GETRANGEMIN("Date Filter") <> 0D THEN
                    dtStartDate := Vendor.GETRANGEMIN("Date Filter");
                IF Vendor.GETRANGEMAX("Date Filter") <> 0D THEN
                    dtEndDate := Vendor.GETRANGEMAX("Date Filter");

                IF Vendor.GETFILTER("Global Dimension 1 Filter") <> '' THEN
                    txtGlobalDim1Filter := Vendor.GETFILTER("Global Dimension 1 Filter");

                IF Vendor.GETFILTER("Global Dimension 2 Filter") <> '' THEN
                    txtGlobalDim2Filter := Vendor.GETFILTER("Global Dimension 2 Filter");
                txtAccountFilter := Vendor.GetFilter("No.");

                txtHeading := 'Vendor Ledger Report';
                txtFilters := Vendor.GetFilters;

                recAccountBalance.Reset();
                recAccountBalance.DeleteAll();
                if dtStartDate <> dtBlankDate then begin
                    Clear(qryVendorBalance);
                    qryVendorBalance.setfilter(Posting_Date, '..%1', closingdate(dtStartDate - 1));
                    if txtGlobalDim1Filter <> '' then
                        qryVendorBalance.setfilter(Global_Dimension_1_Code, txtGlobalDim1Filter);
                    if txtGlobalDim2Filter <> '' then
                        qryVendorBalance.setfilter(Global_Dimension_2_Code, txtGlobalDim2Filter);
                    if txtAccountFilter <> '' then
                        qryVendorBalance.setfilter(Vendor_No_, txtAccountFilter);
                    qryVendorBalance.Open();
                    while qryVendorBalance.Read() do begin
                        recAccountBalance.Init();
                        recAccountBalance."Customer No." := qryVendorBalance.Vendor_No_;
                        recAccountBalance."Amount (LCY)" := qryVendorBalance.Amount__LCY_;
                        recAccountBalance.Insert();
                    end;
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                decOpeningBalance := 0;
                recAccountBalance.RESET;
                recAccountBalance.SetRange("Customer No.", Vendor."No.");
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
                    field(blnPrintApplication; blnPrintApplication)
                    {
                        Caption = 'Print Application';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    local procedure FindApplnEntriesDtldtLedgEntry()
    var
        DtldVendLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        recVLE: Record "Vendor Ledger Entry";
    begin
        DtldVendLedgEntry1.SetCurrentKey("Vendor Ledger Entry No.");
        DtldVendLedgEntry1.SetRange("Vendor Ledger Entry No.", VendorEntry."Entry No.");
        DtldVendLedgEntry1.SetRange(Unapplied, false);
        if DtldVendLedgEntry1.Find('-') then
            repeat
                if DtldVendLedgEntry1."Vendor Ledger Entry No." = DtldVendLedgEntry1."Applied Vend. Ledger Entry No." then begin
                    DtldVendLedgEntry2.Init();
                    DtldVendLedgEntry2.SetCurrentKey("Applied Vend. Ledger Entry No.", "Entry Type");
                    DtldVendLedgEntry2.SetRange("Applied Vend. Ledger Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    DtldVendLedgEntry2.SetRange("Entry Type", DtldVendLedgEntry2."Entry Type"::Application);
                    DtldVendLedgEntry2.SetRange(Unapplied, false);
                    if DtldVendLedgEntry2.Find('-') then
                        repeat
                            if DtldVendLedgEntry2."Vendor Ledger Entry No." <> DtldVendLedgEntry2."Applied Vend. Ledger Entry No." then begin
                                recVLE.Reset();
                                recVLE.SetCurrentKey("Entry No.");
                                recVLE.SetRange("Entry No.", DtldVendLedgEntry2."Vendor Ledger Entry No.");
                                if recVLE.Find('-') then begin
                                    recApplicationEntry.Init();
                                    intLineNo += 1;
                                    recApplicationEntry."Line No." := intLineNo;
                                    recApplicationEntry."IC Partner Transaction No." := recVLE."Entry No.";
                                    recApplicationEntry."Document No." := VendorEntry."Document No.";
                                    recApplicationEntry."Account No." := recVLE."Document No.";
                                    recApplicationEntry.Description := Format(recVLE."Posting Date");
                                    recApplicationEntry."Debit Amount" := Abs(DtldVendLedgEntry2."Amount (LCY)");
                                    recApplicationEntry.Insert();
                                end;
                            end;
                        until DtldVendLedgEntry2.Next() = 0;
                end else begin
                    recVLE.Reset();
                    recVLE.SetCurrentKey("Entry No.");
                    recVLE.SetRange("Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    if recVLE.Find('-') then begin
                        recApplicationEntry.Init();
                        intLineNo += 1;
                        recApplicationEntry."Line No." := intLineNo;
                        recApplicationEntry."IC Partner Transaction No." := recVLE."Entry No.";
                        recApplicationEntry."Document No." := VendorEntry."Document No.";
                        recApplicationEntry."Account No." := recVLE."Document No.";
                        recApplicationEntry.Description := Format(recVLE."Posting Date");
                        recApplicationEntry."Debit Amount" := Abs(DtldVendLedgEntry1."Amount (LCY)");
                        recApplicationEntry.Insert();
                    end;
                end;
            until DtldVendLedgEntry1.Next() = 0;
    end;

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
        qryVendorBalance: Query "Vendor Ledger Report";
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
        recApplicationEntry: Record "Gen. Journal Line" temporary;
        intLineNo: Integer;
        recGLEntry: Record "G/L Entry";
        blnPrintApplication: Boolean;
        decExchangeRate: Decimal;
        txtExpenseLedger: Text[100];
}