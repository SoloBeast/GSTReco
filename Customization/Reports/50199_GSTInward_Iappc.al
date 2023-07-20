report 50199 "GST Inward Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; txtHeading) { }
            column(UserID; UserId) { }
            column(TimeStamp; Format(CurrentDateTime)) { }
            column(GLAccountCode; cdGLAccountNo) { }
            column(ReturnPeriod; cdReturnPeriod) { }
            column(RecipientGSTIN; cdLocationGSTRegNo) { }
            column(DocumentType; cdDocumentType) { }
            column(InternalDocType; txtInternalDocType) { }
            column(SupplyType; cdSupplyType) { }
            column(DocumentNumber; cdVendorInvoiceNo) { }
            column(DocumentDate; Format(dtVendorInvoiceDate)) { }
            column(OriginalDocumentNumber; cdOriginalInvNo) { }
            column(OriginalDocumentDate; Format(dtOriginalInvDate)) { }
            column(LineNumber; intSrNo) { }
            column(SupplierGSTIN; cdSupplierGSTRegNo) { }
            column(OriginalSupplierGSTIN; '') { }
            column(SupplierName; txtSupplierName) { }
            column(POS; cdPOS) { }
            column(BillOfEntry; cdBillOfEntry) { }
            column(BillOfEntryDate; Format(dtBillOfEntryDate)) { }
            column(HSNorSAC; recReportData."HSN/SAC Code") { }
            column(ItemDescription; recReportData.Description) { }
            column(UnitOfMeasurement; recReportData."Unit of Measure Code") { }
            column(Quantity; recReportData.Quantity) { }
            column(UOM; recReportData."Unit of Measure Code") { }
            column(TaxableValue; decTaxableAmount) { }
            column(IntegratedTaxRate; decIGSTPerc) { }
            column(IntegratedTaxAmount; decIGSTAmount) { }
            column(CentralTaxRate; decCGSTPerc) { }
            column(CentralTaxAmount; decCGSTAmount) { }
            column(StateUTTaxRate; decSGSTPerc) { }
            column(StateUTTaxAmount; decSGSTAmount) { }
            column(CessRateAdvalorem; 0) { }
            column(CessAmountAdvalorem; 0) { }
            column(InvoiceValue; decInvoiceValue) { }
            column(ReverseChargeFlag; cdReverseCharge) { }
            column(EligibilityIndicator; cdITCEligible) { }
            column(CommonSupplyIndicator; '') { }
            column(ITCReversalIdentifier; '') { }
            column(PurchaseVoucherNumber; recReportData."Document No.") { }
            column(PurchaseVoucherDate; Format(recReportData."Posting Date")) { }
            column(PaymentVoucherNumber; cdPaymentDocNo) { }
            column(PaymentDate; Format(dtPaymentDocDate)) { }
            column(Narration; txtNarration) { }

            trigger OnPreDataItem()
            begin
                if (Format(dtFromDate) = '') and (Format(dtToDate) = '') then
                    Error('The From or To Date must not be blank.');

                recCompanyInfo.Get();

                recReportData.Reset();
                recReportData.DeleteAll();
                recPurchInvoiceLines.Reset();
                recPurchInvoiceLines.SetRange("System-Created Entry", false);
                recPurchInvoiceLines.SetFilter(Quantity, '<>%1', 0);
                recPurchInvoiceLines.SetRange("Posting Date", dtFromDate, dtToDate);
                if recPurchInvoiceLines.FindFirst() then begin
                    repeat
                        recReportData.Init();
                        recReportData.TransferFields(recPurchInvoiceLines);
                        recReportData.Insert();
                    until recPurchInvoiceLines.Next() = 0;
                end;

                recPurchCrMemoLines.Reset();
                recPurchCrMemoLines.SetRange("System-Created Entry", false);
                recPurchCrMemoLines.SetFilter(Quantity, '<>%1', 0);
                recPurchCrMemoLines.SetRange("Posting Date", dtFromDate, dtToDate);
                if recPurchCrMemoLines.FindFirst() then
                    repeat
                        recReportData.Init();
                        recReportData.TransferFields(recPurchCrMemoLines);
                        recReportData.Quantity := -recPurchCrMemoLines.Quantity;
                        recReportData.Insert();
                    until recPurchCrMemoLines.Next() = 0;

                txtHeading := 'GST Inward Report for the period from ' + Format(dtFromDate) + ' to ' + Format(dtToDate);

                intCounter := 0;
                intSrNo := 0;
                cdOldDocNo := '';
                cdOldHSNSAC := '';
                recReportData.Reset();
                Integer.SetRange(Number, 1, recReportData.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                intCounter += 1;
                if intCounter > 1 then begin
                    recReportData.Reset();
                    recReportData.SetCurrentKey("Posting Date");
                    recReportData.FindFirst();
                    recReportData.Delete();
                end;

                cdGLAccountNo := '';
                cdDocumentType := '';
                cdSupplyType := '';
                cdOriginalInvNo := '';
                dtOriginalInvDate := 0D;
                cdPOS := '';
                cdBillOfEntry := '';
                dtBillOfEntryDate := 0D;
                decTaxableAmount := 0;
                decIGSTAmount := 0;
                decCGSTAmount := 0;
                decSGSTAmount := 0;
                decIGSTPerc := 0;
                decSGSTPerc := 0;
                decCGSTPerc := 0;
                decInvoiceValue := 0;
                cdReverseCharge := '';
                cdITCEligible := '';
                cdPaymentDocNo := '';
                dtPaymentDocDate := 0D;
                txtInternalDocType := '';
                txtNarration := '';

                recReportData.Reset();
                recReportData.SetCurrentKey("Posting Date");
                recReportData.FindFirst();
                if recReportData."Document No." <> cdOldDocNo then begin
                    intSrNo := 0;
                    cdOldHSNSAC := '';
                end;

                if recReportData."HSN/SAC Code" <> cdOldHSNSAC then
                    intSrNo += 1;
                if intSrNo = 0 then
                    intSrNo += 1;
                cdOldDocNo := recReportData."Document No.";
                cdOldHSNSAC := recReportData."HSN/SAC Code";

                cdReturnPeriod := Format(Date2DMY(recReportData."Posting Date", 2)) + Format(Date2DMY(recReportData."Posting Date", 3));

                if recPurchInvoiceLines.Get(recReportData."Document No.", recReportData."Line No.") then begin
                    recPurchInvoiceLines.CalcFields("GST Base Amount", "IGST Amount", "CGST Amount", "SGST Amount");
                    recPurchInvoiceLines.CalcFields("IGST %", "CGST %", "SGST %");

                    recPurchInvoiceHeader.Get(recReportData."Document No.");
                    recPurchInvoiceHeader.CalcFields("IGST Amount", "CGST Amount", "SGST Amount", "Total Line Amount");
                    cdLocationGSTRegNo := recPurchInvoiceHeader."Location GST Reg. No.";
                    cdVendorInvoiceNo := recPurchInvoiceHeader."Vendor Invoice No.";
                    dtVendorInvoiceDate := recPurchInvoiceHeader."Document Date";
                    cdSupplierGSTRegNo := recPurchInvoiceHeader."Vendor GST Reg. No.";
                    txtSupplierName := recPurchInvoiceHeader."Buy-from Vendor Name";
                    cdBillOfEntry := recPurchInvoiceHeader."Bill of Entry No.";
                    dtBillOfEntryDate := recPurchInvoiceHeader."Bill of Entry Date";
                    if recPurchInvoiceHeader."Invoice Type" = recPurchInvoiceHeader."Invoice Type"::"Self Invoice" then
                        cdReverseCharge := 'Y'
                    else
                        cdReverseCharge := 'N';
                    txtInternalDocType := Format(recPurchInvoiceHeader."Internal Document Type");

                    recPurchCommentLine.Reset();
                    recPurchCommentLine.SetRange("Document Type", recPurchCommentLine."Document Type"::"Posted Invoice");
                    recPurchCommentLine.SetRange("No.", recPurchInvoiceHeader."No.");
                    recPurchCommentLine.SetRange("Document Line No.", 0);
                    if recPurchCommentLine.FindFirst() then
                        repeat
                            if txtNarration = '' then
                                txtNarration := recPurchCommentLine.Comment
                            else
                                txtNarration := txtNarration + ' ' + recPurchCommentLine.Comment;
                        until recPurchCommentLine.Next() = 0;

                    if recPurchInvoiceHeader."Currency Code" <> '' then
                        decCurrencyFactor := 1 / recPurchInvoiceHeader."Currency Factor"
                    else
                        decCurrencyFactor := 1;

                    if recPurchInvoiceHeader."Invoice Type" = recPurchInvoiceHeader."Invoice Type"::"Debit Note" then
                        cdDocumentType := 'DR'
                    else
                        if recPurchInvoiceHeader."RCM Applicable" = recPurchInvoiceHeader."RCM Applicable"::Yes then
                            cdDocumentType := 'SLF'
                        else
                            cdDocumentType := 'INV';

                    FindApplnEntriesDtldtLedgEntry(recPurchInvoiceHeader."Vendor Ledger Entry No.");

                    if recPurchInvoiceLines.Type = recPurchInvoiceLines.Type::"G/L Account" then
                        cdGLAccountNo := recPurchInvoiceLines."No."
                    else begin
                        recGeneralPostingSetup.Reset();
                        recGeneralPostingSetup.SetRange("Gen. Bus. Posting Group", recPurchInvoiceLines."Gen. Bus. Posting Group");
                        recGeneralPostingSetup.SetRange("Gen. Prod. Posting Group", recPurchInvoiceLines."Gen. Prod. Posting Group");
                        recGeneralPostingSetup.FindFirst();
                        cdGLAccountNo := recGeneralPostingSetup."Purch. Account";
                    end;

                    if recPurchInvoiceHeader."GST Vendor Type" = recPurchInvoiceHeader."GST Vendor Type"::SEZ then begin
                        if recPurchInvoiceLines."GST Group Type" = recPurchInvoiceLines."GST Group Type"::Goods then
                            cdSupplyType := 'SEZG'
                        else
                            cdSupplyType := 'SEZS';
                    end else
                        if recPurchInvoiceHeader."GST Vendor Type" = recPurchInvoiceHeader."GST Vendor Type"::Import then begin
                            if recPurchInvoiceLines."GST Group Type" = recPurchInvoiceLines."GST Group Type"::Goods then
                                cdSupplyType := 'IMPG'
                            else
                                cdSupplyType := 'IMPS';
                        end else
                            if recPurchInvoiceLines."IGST Amount" + recPurchInvoiceLines."CGST Amount" + recPurchInvoiceLines."SGST Amount" <> 0 then
                                cdSupplyType := 'TAX'
                            else
                                if recPurchInvoiceLines."GST Group Code" <> '' then
                                    cdSupplyType := 'NIL'
                                else
                                    cdSupplyType := 'EXT';

                    decTaxableAmount := Round(recPurchInvoiceLines."Line Amount" * decCurrencyFactor, 0.01);

                    if recPurchInvoiceLines."Line Amount" < 0 then begin
                        decIGSTAmount := -recPurchInvoiceLines."IGST Amount";
                        decSGSTAmount := -recPurchInvoiceLines."SGST Amount";
                        decCGSTAmount := -recPurchInvoiceLines."CGST Amount";
                    end else begin
                        decIGSTAmount := recPurchInvoiceLines."IGST Amount";
                        decSGSTAmount := recPurchInvoiceLines."SGST Amount";
                        decCGSTAmount := recPurchInvoiceLines."CGST Amount";
                    end;
                    decIGSTPerc := recPurchInvoiceLines."IGST %";
                    decSGSTPerc := recPurchInvoiceLines."SGST %";
                    decCGSTPerc := recPurchInvoiceLines."CGST %";
                    if recPurchInvoiceLines."Line Amount" > 0 then
                        decInvoiceValue := Round(recPurchInvoiceLines."Line Amount" * decCurrencyFactor, 0.01) + recPurchInvoiceLines."IGST Amount" + recPurchInvoiceLines."CGST Amount" + recPurchInvoiceLines."SGST Amount"
                    else
                        decInvoiceValue := Round(recPurchInvoiceLines."Line Amount" * decCurrencyFactor, 0.01) - (recPurchInvoiceLines."IGST Amount" + recPurchInvoiceLines."CGST Amount" + recPurchInvoiceLines."SGST Amount");

                    if recPurchInvoiceLines."GST Credit" = recPurchInvoiceLines."GST Credit"::"Non-Availment" then
                        cdITCEligible := 'NO'
                    else begin
                        if recPurchInvoiceLines.Type = recPurchInvoiceLines.Type::"Fixed Asset" then
                            cdITCEligible := 'CG'
                        else
                            if recPurchInvoiceLines."GST Group Type" = recPurchInvoiceLines."GST Group Type"::Goods then
                                cdITCEligible := 'IG'
                            else
                                cdITCEligible := 'IS';
                    end;

                    // recRefInvNo.Reset();
                    // recRefInvNo.SetRange("Document No.", recPurchInvoiceHeader."No.");
                    // if recRefInvNo.FindFirst() then begin
                    //     recPurchInvoiceHeader.Get(cdOriginalInvNo);
                    cdOriginalInvNo := recPurchInvoiceHeader."Vendor Invoice No.";
                    dtOriginalInvDate := recPurchInvoiceHeader."Document Date";
                    //end;
                end else begin
                    recPurchCrMemoLines.Get(recReportData."Document No.", recReportData."Line No.");
                    recPurchCrMemoLines.CalcFields("GST Base Amount", "IGST Amount", "CGST Amount", "SGST Amount");
                    recPurchCrMemoLines.CalcFields("IGST %", "CGST %", "SGST %");

                    recPurchCrMemoHeader.Get(recReportData."Document No.");
                    recPurchCrMemoHeader.CalcFields("IGST Amount", "CGST Amount", "SGST Amount", "Total Line Amount");
                    cdLocationGSTRegNo := recPurchCrMemoHeader."Location GST Reg. No.";
                    cdDocumentType := 'CR';
                    cdVendorInvoiceNo := recPurchCrMemoHeader."Vendor Cr. Memo No.";
                    dtVendorInvoiceDate := recPurchCrMemoHeader."Document Date";
                    cdSupplierGSTRegNo := recPurchCrMemoHeader."Vendor GST Reg. No.";
                    txtSupplierName := recPurchCrMemoHeader."Buy-from Vendor Name";
                    cdBillOfEntry := recPurchCrMemoHeader."Bill of Entry No.";
                    dtBillOfEntryDate := recPurchCrMemoHeader."Bill of Entry Date";
                    if recPurchCrMemoHeader."Invoice Type" = recPurchCrMemoHeader."Invoice Type"::"Self Invoice" then
                        cdReverseCharge := 'Y'
                    else
                        cdReverseCharge := 'N';
                    txtInternalDocType := Format(recPurchCrMemoHeader."Internal Document Type");

                    recPurchCommentLine.Reset();
                    recPurchCommentLine.SetRange("Document Type", recPurchCommentLine."Document Type"::"Posted Credit Memo");
                    recPurchCommentLine.SetRange("No.", recPurchCrMemoHeader."No.");
                    recPurchCommentLine.SetRange("Document Line No.", 0);
                    if recPurchCommentLine.FindFirst() then
                        repeat
                            if txtNarration = '' then
                                txtNarration := recPurchCommentLine.Comment
                            else
                                txtNarration := txtNarration + ' ' + recPurchCommentLine.Comment;
                        until recPurchCommentLine.Next() = 0;

                    if recPurchCrMemoHeader."Currency Code" <> '' then
                        decCurrencyFactor := 1 / recPurchCrMemoHeader."Currency Factor"
                    else
                        decCurrencyFactor := 1;

                    FindApplnEntriesDtldtLedgEntry(recPurchCrMemoHeader."Vendor Ledger Entry No.");

                    if recPurchCrMemoLines.Type = recPurchCrMemoLines.Type::"G/L Account" then
                        cdGLAccountNo := recPurchCrMemoLines."No."
                    else begin
                        recGeneralPostingSetup.Reset();
                        recGeneralPostingSetup.SetRange("Gen. Bus. Posting Group", recPurchCrMemoLines."Gen. Bus. Posting Group");
                        recGeneralPostingSetup.SetRange("Gen. Prod. Posting Group", recPurchCrMemoLines."Gen. Prod. Posting Group");
                        recGeneralPostingSetup.FindFirst();
                        cdGLAccountNo := recGeneralPostingSetup."Purch. Account";
                    end;

                    if recPurchCrMemoHeader."GST Vendor Type" = recPurchCrMemoHeader."GST Vendor Type"::SEZ then begin
                        if recPurchCrMemoLines."GST Group Type" = recPurchCrMemoLines."GST Group Type"::Goods then
                            cdSupplyType := 'SEZG'
                        else
                            cdSupplyType := 'SEZS';
                    end else
                        if recPurchCrMemoHeader."GST Vendor Type" = recPurchCrMemoHeader."GST Vendor Type"::Import then begin
                            if recPurchCrMemoLines."GST Group Type" = recPurchCrMemoLines."GST Group Type"::Goods then
                                cdSupplyType := 'IMPG'
                            else
                                cdSupplyType := 'IMPS';
                        end else
                            if recPurchCrMemoLines."IGST Amount" + recPurchCrMemoLines."CGST Amount" + recPurchCrMemoLines."SGST Amount" <> 0 then
                                cdSupplyType := 'TAX'
                            else
                                if recPurchCrMemoLines."GST Group Code" <> '' then
                                    cdSupplyType := 'NIL'
                                else
                                    cdSupplyType := 'EXT';

                    decTaxableAmount := -Round(recPurchCrMemoLines."Line Amount" * decCurrencyFactor, 0.01);

                    if recPurchCrMemoLines."Line Amount" > 0 then begin
                        decIGSTAmount := recPurchCrMemoLines."IGST Amount";
                        decSGSTAmount := recPurchCrMemoLines."SGST Amount";
                        decCGSTAmount := recPurchCrMemoLines."CGST Amount";
                    end else begin
                        decIGSTAmount := -recPurchCrMemoLines."IGST Amount";
                        decSGSTAmount := -recPurchCrMemoLines."SGST Amount";
                        decCGSTAmount := -recPurchCrMemoLines."CGST Amount";
                    end;
                    decIGSTPerc := recPurchCrMemoLines."IGST %";
                    decSGSTPerc := recPurchCrMemoLines."SGST %";
                    decCGSTPerc := recPurchCrMemoLines."CGST %";

                    if recPurchCrMemoLines."Line Amount" > 0 then
                        decInvoiceValue := -(Round(recPurchCrMemoLines."Line Amount" * decCurrencyFactor, 0.01) + Abs(recPurchCrMemoLines."IGST Amount" + recPurchCrMemoLines."CGST Amount" + recPurchCrMemoLines."SGST Amount"))
                    else
                        decInvoiceValue := (Round(recPurchCrMemoLines."Line Amount" * decCurrencyFactor, 0.01) + Abs(recPurchCrMemoLines."IGST Amount" + recPurchCrMemoLines."CGST Amount" + recPurchCrMemoLines."SGST Amount"));

                    if recPurchCrMemoLines."GST Credit" = recPurchCrMemoLines."GST Credit"::"Non-Availment" then
                        cdITCEligible := 'NO'
                    else begin
                        if recPurchCrMemoLines.Type = recPurchCrMemoLines.Type::"Fixed Asset" then
                            cdITCEligible := 'CG'
                        else
                            if recPurchCrMemoLines."GST Group Type" = recPurchCrMemoLines."GST Group Type"::Goods then
                                cdITCEligible := 'IG'
                            else
                                cdITCEligible := 'IS';
                    end;

                    recRefInvNo.Reset();
                    recRefInvNo.SetRange("Document No.", recPurchCrMemoHeader."No.");
                    if recRefInvNo.FindFirst() then begin
                        recPurchInvoiceHeader.Get(recRefInvNo."Reference Invoice Nos.");
                        cdOriginalInvNo := recPurchInvoiceHeader."Vendor Invoice No.";
                        dtOriginalInvDate := recPurchInvoiceHeader."Document Date";
                    end;
                end;

                if cdLocationGSTRegNo <> '' then
                    cdPOS := CopyStr(cdLocationGSTRegNo, 1, 2)
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
                    field(dtFromDate; dtFromDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea = All;
                    }
                    field(dtToDate; dtToDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'Customization\Reports\50199_GSTInward.rdl';
        }
    }

    local procedure FindApplnEntriesDtldtLedgEntry(VendorLedgerEntryNo: Integer)
    var
        DtldVendLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        recVLE: Record "Vendor Ledger Entry";
    begin
        DtldVendLedgEntry1.SetCurrentKey("Vendor Ledger Entry No.");
        DtldVendLedgEntry1.SetRange("Vendor Ledger Entry No.", VendorLedgerEntryNo);
        DtldVendLedgEntry1.SetRange(Unapplied, false);
        if DtldVendLedgEntry1.Find('-') then
            repeat
                if DtldVendLedgEntry1."Vendor Ledger Entry No." = DtldVendLedgEntry1."Applied Vend. Ledger Entry No." then begin
                    DtldVendLedgEntry2.Init();
                    DtldVendLedgEntry2.SetCurrentKey("Applied Vend. Ledger Entry No.", "Entry Type");
                    DtldVendLedgEntry2.SetRange(
                      "Applied Vend. Ledger Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    DtldVendLedgEntry2.SetRange("Entry Type", DtldVendLedgEntry2."Entry Type"::Application);
                    DtldVendLedgEntry2.SetRange(Unapplied, false);
                    if DtldVendLedgEntry2.Find('-') then
                        repeat
                            if DtldVendLedgEntry2."Vendor Ledger Entry No." <> DtldVendLedgEntry2."Applied Vend. Ledger Entry No." then begin
                                recVLE.Reset();
                                recVLE.SetCurrentKey("Entry No.");
                                recVLE.SetRange("Entry No.", DtldVendLedgEntry2."Vendor Ledger Entry No.");
                                if (recVLE.Find('-')) and (recVLE."Document Type" <> recVLE."Document Type"::"Credit Memo") then begin
                                    cdPaymentDocNo := recVLE."Document No.";
                                    dtPaymentDocDate := recVLE."Posting Date";
                                end;
                            end;
                        until DtldVendLedgEntry2.Next() = 0;
                end else begin
                    recVLE.Reset();
                    recVLE.SetCurrentKey("Entry No.");
                    recVLE.SetRange("Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    if (recVLE.Find('-')) and (recVLE."Document Type" <> recVLE."Document Type"::"Credit Memo") then begin
                        cdPaymentDocNo := recVLE."Document No.";
                        dtPaymentDocDate := recVLE."Posting Date";
                    end;
                end;
            until DtldVendLedgEntry1.Next() = 0;
    end;

    var
        dtFromDate: Date;
        dtToDate: Date;
        recCompanyInfo: Record "Company Information";
        recReportData: Record "Purch. Inv. Line" temporary;
        recPurchInvoiceLines: Record "Purch. Inv. Line";
        recPurchCrMemoLines: Record "Purch. Cr. Memo Line";
        intCounter: Integer;
        recPurchInvoiceHeader: Record "Purch. Inv. Header";
        recPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        decCurrencyFactor: Decimal;
        cdGLAccountNo: Code[20];
        recGeneralPostingSetup: Record "General Posting Setup";
        txtHeading: Text;
        cdReturnPeriod: Code[10];
        cdLocationGSTRegNo: Code[15];
        cdDocumentType: Code[10];
        cdSupplyType: Code[10];
        cdVendorInvoiceNo: Code[35];
        dtVendorInvoiceDate: Date;
        cdOriginalInvNo: Code[35];
        dtOriginalInvDate: Date;
        recRefInvNo: Record "Reference Invoice No.";
        cdSupplierGSTRegNo: Code[15];
        txtSupplierName: Text[100];
        cdPOS: Code[10];
        cdBillOfEntry: Code[20];
        dtBillOfEntryDate: Date;
        decTaxableAmount: Decimal;
        decIGSTAmount: Decimal;
        decCGSTAmount: Decimal;
        decSGSTAmount: Decimal;
        decIGSTPerc: Decimal;
        decSGSTPerc: Decimal;
        decCGSTPerc: Decimal;
        decInvoiceValue: Decimal;
        cdReverseCharge: Code[1];
        cdITCEligible: Code[10];
        cdPaymentDocNo: Code[20];
        dtPaymentDocDate: Date;
        txtInternalDocType: Text[30];
        intSrNo: Integer;
        cdOldDocNo: Code[20];
        cdOldHSNSAC: Code[20];
        txtNarration: Text;
        recPurchCommentLine: Record "Purch. Comment Line";
}