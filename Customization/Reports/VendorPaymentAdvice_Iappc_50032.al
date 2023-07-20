report 50094 "Payment Advice"
{
    UsageCategory = Administration;
    ApplicationArea = all;
    DefaultLayout = RDLC;
    Caption = 'Payment Advice';
    RDLCLayout = 'Customization\Reports\VendorPaymentAdvice_Iappc_50032.rdl';

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.");

            column(CompanyLogo; recCompanyInfo.Picture) { }
            column(CompanyName; recCompanyInfo.Name) { }
            column(CompanyAddress; recCompanyInfo.Address) { }
            column(CompanyAddress1; recCompanyInfo."Address 2") { }
            column(CompanyCity; recCompanyInfo.City) { }
            column(CompanyPostCode; recCompanyInfo."Post Code") { }
            column(CompanyState; txtCompanyState) { }
            column(CompanyCountry; txtCompanyCountry) { }
            column(BankNameNo; txtBankName) { }
            column(ChequeNo; cdChequeNo) { }
            column(ChequeDate; Format(dtChequeDate)) { }
            column(VendorName; recVendor.Name) { }
            column(VendorAddress; recVendor.Address) { }
            column(VendorAddress1; recVendor."Address 2") { }
            column(VendorCity; recVendor.City) { }
            column(VendorPostCode; recVendor."Post Code") { }
            column(VendorState; txtVendorState) { }
            column(VendorCountry; txtVendorCountry) { }
            column(VoucherNo; "Vendor Ledger Entry"."Document No.") { }
            column(VoucherDate; Format("Vendor Ledger Entry"."Posting Date")) { }
            column(VoucherNarration; txtNarration) { }
            column(AmountInWords; txtAmountInWords[1] + ' ' + txtAmountInWords[2]) { }

            dataitem(DocumentDetails; Integer)
            {
                column(LineNo; DocumentDetails.Number) { }
                column(DocumentType; recAppliedEntries.Description) { }
                column(VendorDocNo; recAppliedEntries."External Document No.") { }
                column(VendorDocDate; Format(recAppliedEntries."Document Date")) { }
                column(InvoiceAmount; recAppliedEntries."Amount (LCY)" + recAppliedEntries."Credit Amount") { }
                column(TDSDeducted; -recAppliedEntries."Credit Amount") { }
                column(AppliedAmount; recAppliedEntries.Amount) { }

                trigger OnPreDataItem()
                begin
                    recAppliedEntries.Reset();
                    DocumentDetails.SetRange(Number, 1, recAppliedEntries.Count);
                    intLineCounter := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    intLineCounter += 1;
                    recAppliedEntries.Reset();
                    recAppliedEntries.SetRange("Line No.", DocumentDetails.Number);
                    recAppliedEntries.FindFirst();
                end;
            }
            dataitem(BlankLines; Integer)
            {
                DataItemTableView = sorting(Number);

                column(BlankLineNo; BlankLines.Number) { }

                trigger OnAfterGetRecord()
                begin
                    intLineCounter += 1;
                    if intLineCounter > 7 then
                        CurrReport.Break();
                end;
            }

            trigger OnPreDataItem()
            begin
                recCompanyInfo.Get();
                recCompanyInfo.CalcFields(Picture);

                txtCompanyState := '';
                txtCompanyCountry := '';
                if recState.Get(recCompanyInfo."State Code") then begin
                    txtCompanyState := recState.Description;
                end;
                if recCountry.Get(recCompanyInfo."Country/Region Code") then
                    txtCompanyCountry := recCountry.Name;
            end;

            trigger OnAfterGetRecord()
            begin
                recVendor.Get("Vendor Ledger Entry"."Vendor No.");

                txtVendorState := '';
                txtVendorCountry := '';
                if recState.Get(recVendor."State Code") then begin
                    txtVendorState := recState.Description;
                end;
                if recCountry.Get(recVendor."Country/Region Code") then
                    txtVendorCountry := recCountry.Name;

                cuProcess.InitTextVariable();
                Clear(txtAmountInWords);
                "Vendor Ledger Entry".CalcFields("Original Amt. (LCY)");
                cuProcess.FormatNoText(txtAmountInWords, "Vendor Ledger Entry"."Original Amt. (LCY)", "Vendor Ledger Entry"."Currency Code");

                txtBankName := '';
                recBankLedger.Reset();
                recBankLedger.SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                recBankLedger.SetRange("Posting Date", "Vendor Ledger Entry"."Posting Date");
                if recBankLedger.FindFirst() then begin
                    recBankAccount.Get(recBankLedger."Bank Account No.");
                    txtBankName := recBankAccount.Name + ' ' + recBankAccount."Bank Account No.";
                    cdChequeNo := recBankLedger."Cheque No.";
                    dtChequeDate := recBankLedger."Cheque Date";
                end;

                recVoucherNarration.Reset();
                recVoucherNarration.SetRange("Transaction No.", "Vendor Ledger Entry"."Transaction No.");
                if recVoucherNarration.FindSet() then
                    repeat
                        if txtNarration = '' then
                            txtNarration := recVoucherNarration.Narration
                        else
                            txtNarration := txtNarration + ' ' + recVoucherNarration.Narration;
                    until recVoucherNarration.Next() = 0;

                recAppliedEntries.Reset();
                recAppliedEntries.DeleteAll();
                FindApplnEntriesDtldtLedgEntry();
            end;
        }
    }

    local procedure FindApplnEntriesDtldtLedgEntry()
    var
        DtldCustLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        recVLE: Record "Vendor Ledger Entry";
        intEntryNo: Integer;
        recPurchCreditMemo: Record "Purch. Cr. Memo Hdr.";
    begin
        DtldCustLedgEntry1.Reset();
        DtldCustLedgEntry1.SetCurrentKey("Vendor Ledger Entry No.");
        DtldCustLedgEntry1.SetRange("Vendor Ledger Entry No.", "Vendor Ledger Entry"."Entry No.");
        DtldCustLedgEntry1.SetRange(Unapplied, false);
        if DtldCustLedgEntry1.Find('-') then begin
            repeat
                if DtldCustLedgEntry1."Vendor Ledger Entry No." = DtldCustLedgEntry1."Vendor Ledger Entry No." then begin
                    DtldCustLedgEntry2.Init();
                    DtldCustLedgEntry2.SetCurrentKey("Applied Vend. Ledger Entry No.", "Entry Type");
                    DtldCustLedgEntry2.SetRange("Applied Vend. Ledger Entry No.", DtldCustLedgEntry1."Applied Vend. Ledger Entry No.");
                    DtldCustLedgEntry2.SetRange("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                    DtldCustLedgEntry2.SetRange(Unapplied, false);
                    if DtldCustLedgEntry2.Find('-') then
                        repeat
                            if DtldCustLedgEntry2."Vendor Ledger Entry No." <> DtldCustLedgEntry2."Applied Vend. Ledger Entry No." then begin
                                recVLE.Get(DtldCustLedgEntry2."Vendor Ledger Entry No.");
                                recVLE.CalcFields("Original Amt. (LCY)");

                                recAppliedEntries.Init();
                                intEntryNo += 1;
                                recAppliedEntries."Line No." := intEntryNo;
                                recAppliedEntries.Description := Format(recVLE."Document Type");
                                recAppliedEntries."External Document No." := recVLE."External Document No.";
                                recAppliedEntries."Document Date" := recVLE."Document Date";
                                recAppliedEntries.Amount := DtldCustLedgEntry2."Amount (LCY)";
                                recAppliedEntries."Amount (LCY)" := -recVLE."Original Amt. (LCY)";

                                recTDSEntry.Reset();
                                recTDSEntry.SetCurrentKey("Document No.", "Posting Date");
                                recTDSEntry.SetRange("Document No.", recVLE."Document No.");
                                recTDSEntry.SetRange("Posting Date", recVLE."Posting Date");
                                if recTDSEntry.FindFirst() then
                                    repeat
                                        recAppliedEntries."Credit Amount" += recTDSEntry."Total TDS Including SHE CESS";
                                    until recTDSEntry.Next() = 0;

                                recAppliedEntries.Insert();
                            end;
                        until DtldCustLedgEntry2.Next() = 0;
                end else begin
                    if recVLE.Get(DtldCustLedgEntry1."Applied Vend. Ledger Entry No.") then begin
                        recVLE.CalcFields("Original Amt. (LCY)");

                        recAppliedEntries.Init();
                        intEntryNo += 1;
                        recAppliedEntries."Line No." := intEntryNo;
                        recAppliedEntries.Description := Format(recVLE."Document Type");
                        recAppliedEntries."External Document No." := recVLE."External Document No.";
                        recAppliedEntries."Document Date" := recVLE."Document Date";
                        recAppliedEntries.Amount := DtldCustLedgEntry1."Amount (LCY)";
                        recAppliedEntries."Amount (LCY)" := -recVLE."Original Amt. (LCY)";

                        recTDSEntry.Reset();
                        recTDSEntry.SetCurrentKey("Document No.", "Posting Date");
                        recTDSEntry.SetRange("Document No.", recVLE."Document No.");
                        recTDSEntry.SetRange("Posting Date", recVLE."Posting Date");
                        if recTDSEntry.FindFirst() then
                            repeat
                                recAppliedEntries."Credit Amount" += recTDSEntry."Total TDS Including SHE CESS";
                            until recTDSEntry.Next() = 0;

                        recAppliedEntries.Insert();
                    end;
                end;
            until DtldCustLedgEntry1.Next() = 0;
        end;
    end;

    var
        recCompanyInfo: Record "Company Information";
        txtCompanyState: Text[50];
        txtCompanyCountry: Text[50];
        recVendor: Record Vendor;
        txtVendorState: Text[50];
        txtVendorCountry: Text[50];
        intLineCounter: Integer;
        recState: Record State;
        recCountry: Record "Country/Region";
        cuProcess: Codeunit "Process Flow";
        txtAmountInWords: array[2] of Text[80];
        recAppliedEntries: Record "Gen. Journal Line" temporary;
        txtBankName: Text;
        recBankLedger: Record "Bank Account Ledger Entry";
        recBankAccount: Record "Bank Account";
        cdChequeNo: Code[20];
        dtChequeDate: Date;
        txtNarration: Text;
        recVoucherNarration: Record "Posted Narration";
        recTDSEntry: Record "TDS Entry";
}