report 50011 "Detailed Purchase Register"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\PurchaseRegisterDetailed_Iappc_50011.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; 'Detailed Purchase Register for the Period Starting from ' + format(dtFromDate) + ' to ' + Format(dtToDate)) { }
            column(UserID; UserId) { }
            column(TimeStamp; Format(CurrentDateTime)) { }
            column(Filters; txtFilters) { }
            column(GlobalDim1Caption; txtGlobalDim1Caption) { }
            column(GlobalDim2Caption; txtGlobalDim2Caption) { }
            column(PostingDate; recReportData."Posting Date") { }
            column(DocumentType; txtDocumentType) { }
            column(InternalDocType; txtInternalDocType) { }
            column(DocumentNo; recReportData."Document No.") { }
            column(LocationCode; recReportData."Location Code") { }
            column(LocationGSTRegistrationNo; cdLocationGSTRegNo) { }
            column(LocationStateCode; cdLocationStateCode) { }
            column(GlobalDimension1Code; recReportData."Shortcut Dimension 1 Code") { }
            column(GlobalDimension2Code; recReportData."Shortcut Dimension 2 Code") { }
            column(VendorNo; recReportData."Buy-from Vendor No.") { }
            column(VendorName; txtBillFromName) { }
            column(VendorPostingGroup; cdVendorPostingGroup) { }
            column(VendorGSTStatus; txtVendorGSTStatus) { }
            column(VendorGSTRegistrationNo; cdVendorGSTRegNo) { }
            column(VendorInvoiceNo; cdVendorInvoiceNo) { }
            column(VendorInvoiceDate; Format(dtVendorInvoiceDate)) { }
            column(ReverseCharge; Format(blnReverseCharge)) { }
            column(StateCode; cdVendorStateCode) { }
            column(CurrencyCode; cdCurrencyCode) { }
            column(CurrencyFactor; decCurrencyFactor) { }
            column(LineType; recReportData.Type) { }
            column(AccountCode; recReportData."No.") { }
            column(AccountName; recReportData.Description) { }
            column(ItemCategory; recReportData."Item Category Code") { }
            column(PostingGroup; recReportData."Posting Group") { }
            column(GenProdGroup; recReportData."Gen. Prod. Posting Group") { }
            column(GSTGroupCode; recReportData."GST Group Code") { }
            column(GSTCredit; recReportData."GST Credit") { }
            column(HSNSACCode; recReportData."HSN/SAC Code") { }
            column(Quantity; recReportData.Quantity) { }
            column(UnitPrice; Round(recReportData."Direct Unit Cost" * decCurrencyFactor, 0.0001)) { }
            column(LineAmount; decLineAmount) { }
            column(DiscountAmount; decDiscountAmount) { }
            column(TaxableValue; decTaxableAmount) { }
            column(IGSTPerc; decIGSTPerc) { }
            column(IGSTAmount; decIGSTAmount) { }
            column(CGSTPerc; decCGSTPerc) { }
            column(CGSTAmount; decCGSTAmount) { }
            column(SGSTPerc; decSGSTPerc) { }
            column(SGSTAmount; decSGSTAmount) { }
            column(OtherCharges; decOtherCharges) { }
            column(TDSSection; recReportData."TDS Section Code") { }
            column(TDSRate; decTDSRate) { }
            column(ConcessionalCode; cdTDSConcessionalCode) { }
            column(TDSAmount; decTDSAmount) { }
            column(InvoiceValue; decInvoiceValue) { }
            column(LotNo; recReportData."IC Cross-Reference No.") { }
            column(PostingMonth; txtPostingMonth) { }
            column(RCM; txtRCM) { }
            column(GSTAavailment; Format(recReportData."GST Credit")) { }
            column(Narration; txtNarration) { }
            column(HSNSAC; recReportData."HSN/SAC Code") { }

            column(VendorAddress; txtVendorAddress) { }
            trigger OnPreDataItem()
            begin
                if (Format(dtFromDate) = '') and (Format(dtToDate) = '') then
                    Error('The From or To Date must not be blank.');

                recCompanyInfo.Get();

                recGLSetup.Get();
                if recDimensions.Get(recGLSetup."Global Dimension 1 Code") then
                    txtGlobalDim1Caption := recDimensions."Code Caption"
                else
                    txtGlobalDim1Caption := 'Global Dim 1 Code';
                if recDimensions.Get(recGLSetup."Global Dimension 2 Code") then
                    txtGlobalDim2Caption := recDimensions."Code Caption"
                else
                    txtGlobalDim2Caption := 'Global Dim 2 Code';

                recReportData.Reset();
                recReportData.DeleteAll();
                recPurchInvoiceLines.Reset();
                recPurchInvoiceLines.SetRange("System-Created Entry", false);
                recPurchInvoiceLines.SetFilter(Quantity, '<>%1', 0);
                recPurchInvoiceLines.SetRange("Posting Date", dtFromDate, dtToDate);
                if recPurchInvoiceLines.FindFirst() then begin
                    //txtFilters := recPurchInvoiceLines.GetFilters;
                    repeat
                        recReportData.Init();
                        recReportData.TransferFields(recPurchInvoiceLines);
                        IF recPurchInvoiceLines.Type = recPurchInvoiceLines.Type::Item then begin
                            recValueEntry.Reset();
                            recValueEntry.SetRange("Document No.", recPurchInvoiceLines."Document No.");
                            recValueEntry.SetRange("Document Line No.", recPurchInvoiceLines."Line No.");
                            if recValueEntry.FindFirst() then begin
                                recILE.Reset();
                                recILE.SetRange("Entry No.", recValueEntry."Item Ledger Entry No.");
                                if recILE.FindFirst() then begin
                                    recReportData."IC Cross-Reference No." := recILE."Lot No.";
                                end;
                            end;
                        end;
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
                        IF recPurchCrMemoLines.Type = recPurchCrMemoLines.Type::Item then begin
                            recValueEntry.Reset();
                            recValueEntry.SetRange("Document No.", recPurchCrMemoLines."Document No.");
                            recValueEntry.SetRange("Document Line No.", recPurchCrMemoLines."Line No.");
                            if recValueEntry.FindFirst() then begin
                                recILE.Reset();
                                recILE.SetRange("Entry No.", recValueEntry."Item Ledger Entry No.");
                                if recILE.FindFirst() then begin
                                    recReportData."IC Cross-Reference No." := recILE."Lot No.";
                                end;
                            end;
                        end;
                        recReportData.Insert();
                    until recPurchCrMemoLines.Next() = 0;

                intCounter := 0;
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

                decLineAmount := 0;
                decDiscountAmount := 0;
                decTaxableAmount := 0;
                decCGSTAmount := 0;
                decIGSTAmount := 0;
                decSGSTAmount := 0;
                decInvoiceValue := 0;
                cdVendorPostingGroup := '';
                txtBillFromName := '';
                txtVendorGSTStatus := '';
                decTDSAmount := 0;
                txtInternalDocType := '';
                txtNarration := '';

                recReportData.Reset();
                recReportData.SetCurrentKey("Posting Date");
                recReportData.FindFirst();
                if recPurchInvoiceLines.Get(recReportData."Document No.", recReportData."Line No.") then begin
                    txtDocumentType := 'Invoice';
                    recPurchInvoiceHeader.Get(recReportData."Document No.");
                    recPurchInvoiceHeader.CalcFields("GST Reverse Charged");

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

                    txtInternalDocType := Format(recPurchInvoiceHeader."Internal Document Type");
                    txtBillFromName := recPurchInvoiceHeader."Buy-from Vendor Name";
                    cdVendorPostingGroup := recPurchInvoiceHeader."Vendor Posting Group";
                    cdLocationGSTRegNo := recPurchInvoiceHeader."Location GST Reg. No.";
                    cdVendorGSTRegNo := recPurchInvoiceHeader."Vendor GST Reg. No.";
                    cdCurrencyCode := recPurchInvoiceHeader."Currency Code";
                    cdVendorInvoiceNo := recPurchInvoiceHeader."Vendor Invoice No.";
                    dtVendorInvoiceDate := recPurchInvoiceHeader."Document Date";
                    blnReverseCharge := recPurchInvoiceHeader."GST Reverse Charged";
                    txtVendorGSTStatus := Format(recPurchInvoiceHeader."GST Vendor Type");
                    txtPostingMonth := format(Date2DMY(recPurchInvoiceHeader."Posting Date", 2));
                    txtPostingYear := format(Date2DMY(recPurchInvoiceHeader."Posting Date", 3));
                    if StrLen(txtPostingMonth) = 1 then
                        txtPostingMonth := '0' + txtPostingMonth;
                    if StrLen(txtPostingYear) = 2 then
                        txtPostingMonth := '20' + txtPostingYear;

                    txtPostingMonth := txtPostingMonth + txtPostingYear;

                    IF recPurchInvoiceHeader."RCM Applicable" = recPurchInvoiceHeader."RCM Applicable"::Yes then
                        txtRCM := 'Yes'
                    else
                        txtRCM := 'No';

                    txtPlaceOfSupply := CopyStr(recPurchInvoiceHeader."Vendor GST Reg. No.", 1, 2);

                    decTDSRate := 0;
                    cdTDSConcessionalCode := '';
                    recTDSDEntry.Reset();
                    recTDSDEntry.SetRange("Document No.", recPurchInvoiceHeader."No.");
                    recTDSDEntry.SetRange(Section, recReportData."TDS Section Code");
                    if recTDSDEntry.FindFirst() then begin
                        decTDSRate := recTDSDEntry."TDS %";
                        cdTDSConcessionalCode := recTDSDEntry."Concessional Code";
                    end;

                    txtOriginalDocumentNo := '';
                    dtOriginalDocumentDate := 0D;

                    txtVendorAddress := recPurchInvoiceHeader."Buy-from Address" + ' ' + recPurchInvoiceHeader."Buy-from Address 2";
                    //-101
                    if recPurchInvoiceHeader."Currency Code" <> '' then
                        decCurrencyFactor := 1 / recPurchInvoiceHeader."Currency Factor"
                    else
                        decCurrencyFactor := 1;

                    recPurchInvoiceLines.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
                    recPurchInvoiceLines.CalcFields("Section Wise TDS Amount", "Section Wise TDS Base Amount");
                    recPurchInvoiceLines.CalcFields("IGST %", "CGST %", "SGST %");

                    decLineAmount := recPurchInvoiceLines."Line Amount" + recPurchInvoiceLines."Line Discount Amount";
                    decDiscountAmount := recPurchInvoiceLines."Line Discount Amount" + recPurchInvoiceLines."Inv. Discount Amount";
                    decTaxableAmount := recPurchInvoiceLines."Line Amount" - recPurchInvoiceLines."Inv. Discount Amount";
                    decCGSTAmount := recPurchInvoiceLines."CGST Amount";
                    decIGSTAmount := recPurchInvoiceLines."IGST Amount";
                    decSGSTAmount := recPurchInvoiceLines."SGST Amount";

                    if recPurchInvoiceLines."Section Wise TDS Base Amount" <> 0 then
                        decTDSAmount := Round(recPurchInvoiceLines."Section Wise TDS Amount" / recPurchInvoiceLines."Section Wise TDS Base Amount" * recPurchInvoiceLines."Line Amount", 0.01);

                    if recPurchInvoiceLines."Line Amount" < 0 then begin
                        decCGSTAmount := decCGSTAmount * -1;
                        decSGSTAmount := decSGSTAmount * -1;
                        decIGSTAmount := decIGSTAmount * -1;
                    end;

                    decInvoiceValue := decLineAmount - decDiscountAmount + decCGSTAmount + decSGSTAmount + decIGSTAmount - decTDSAmount;
                    decIGSTPerc := recPurchInvoiceLines."IGST %";
                    decCGSTPerc := recPurchInvoiceLines."CGST %";
                    decSGSTPerc := recPurchInvoiceLines."SGST %";

                end else begin
                    recPurchCrMemoLines.Get(recReportData."Document No.", recReportData."Line No.");
                    txtDocumentType := 'Credit Memo';
                    recPurchCrMemoHeader.Get(recReportData."Document No.");
                    recPurchCrMemoHeader.CalcFields("GST Reverse Charged");

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

                    txtInternalDocType := Format(recPurchCrMemoHeader."Internal Document Type");
                    txtBillFromName := recPurchCrMemoHeader."Buy-from Vendor Name";
                    cdVendorPostingGroup := recPurchCrMemoHeader."Vendor Posting Group";
                    cdLocationGSTRegNo := recPurchCrMemoHeader."Location GST Reg. No.";
                    cdVendorGSTRegNo := recPurchCrMemoHeader."Vendor GST Reg. No.";
                    cdCurrencyCode := recPurchCrMemoHeader."Currency Code";
                    cdVendorInvoiceNo := recPurchCrMemoHeader."Vendor Cr. Memo No.";
                    dtVendorInvoiceDate := recPurchCrMemoHeader."Document Date";
                    blnReverseCharge := recPurchCrMemoHeader."GST Reverse Charged";
                    txtVendorGSTStatus := Format(recPurchCrMemoHeader."GST Vendor Type");

                    txtPostingMonth := format(Date2DMY(recPurchCrMemoHeader."Posting Date", 2));
                    txtPostingYear := format(Date2DMY(recPurchCrMemoHeader."Posting Date", 3));
                    if StrLen(txtPostingMonth) = 1 then
                        txtPostingMonth := '0' + txtPostingMonth;
                    if StrLen(txtPostingYear) = 2 then
                        txtPostingMonth := '20' + txtPostingYear;

                    txtPostingMonth := txtPostingMonth + txtPostingYear;
                    recLocation.Get(recPurchCrMemoHeader."Location Code");
                    txtPlaceOfSupply := CopyStr(recLocation."GST Registration No.", 1, 2);

                    txtBillOfEntryNo := recPurchCrMemoHeader."Bill of Entry No.";
                    dtBillofEntryDate := recPurchCrMemoHeader."Bill of Entry Date";
                    dtBillofEntryDate := recPurchCrMemoHeader."Bill of Entry Date";

                    decTDSRate := 0;
                    cdTDSConcessionalCode := '';
                    recTDSDEntry.Reset();
                    recTDSDEntry.SetRange("Document No.", recPurchCrMemoHeader."No.");
                    recTDSDEntry.SetRange(Section, recPurchCrMemoLines."Iappc TDS Section");
                    if recTDSDEntry.FindFirst() then begin
                        decTDSRate := recTDSDEntry."TDS %";
                        cdTDSConcessionalCode := recTDSDEntry."Concessional Code";
                    end;

                    txtOriginalDocumentNo := recPurchCrMemoHeader."Reference Invoice No.";
                    recPurchInvoiceHeader.Reset();
                    recPurchInvoiceHeader.SetRange("No.", recPurchCrMemoHeader."Reference Invoice No.");
                    if recPurchInvoiceHeader.FindFirst() then
                        dtOriginalDocumentDate := recPurchInvoiceHeader."Posting Date";

                    txtVendorAddress := recPurchCrMemoHeader."Buy-from Address" + ' ' + recPurchCrMemoHeader."Buy-from Address 2";
                    if recPurchCrMemoHeader."Currency Code" <> '' then
                        decCurrencyFactor := 1 / recPurchCrMemoHeader."Currency Factor"
                    else
                        decCurrencyFactor := 1;

                    recPurchCrMemoLines.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
                    recPurchCrMemoLines.CalcFields("IGST %", "CGST %", "SGST %");

                    decLineAmount := recPurchCrMemoLines."Line Amount" + recPurchCrMemoLines."Line Discount Amount";
                    decDiscountAmount := recPurchCrMemoLines."Line Discount Amount" + recPurchCrMemoLines."Inv. Discount Amount";
                    decTaxableAmount := recPurchCrMemoLines."Line Amount" - recPurchCrMemoLines."Inv. Discount Amount";
                    decCGSTAmount := recPurchCrMemoLines."CGST Amount";
                    decIGSTAmount := recPurchCrMemoLines."IGST Amount";
                    decSGSTAmount := recPurchCrMemoLines."SGST Amount";

                    if recPurchCrMemoLines."Line Amount" < 0 then begin
                        decCGSTAmount := decCGSTAmount * -1;
                        decSGSTAmount := decSGSTAmount * -1;
                        decIGSTAmount := decIGSTAmount * -1;
                        decInvoiceValue := decLineAmount - decDiscountAmount - Abs(decCGSTAmount + decSGSTAmount + decIGSTAmount) - decTDSAmount;
                    end else
                        decInvoiceValue := decLineAmount - decDiscountAmount + Abs(decCGSTAmount + decSGSTAmount + decIGSTAmount) - decTDSAmount;

                    decIGSTPerc := recPurchCrMemoLines."IGST %";
                    decCGSTPerc := recPurchCrMemoLines."CGST %";
                    decSGSTPerc := recPurchCrMemoLines."SGST %";

                    decLineAmount := -decLineAmount;
                    decDiscountAmount := -decDiscountAmount;
                    decTaxableAmount := -decTaxableAmount;
                    decCGSTAmount := decCGSTAmount;
                    decSGSTAmount := decSGSTAmount;
                    decIGSTAmount := decIGSTAmount;
                    decTDSAmount := -decTDSAmount;
                    decInvoiceValue := -decInvoiceValue;
                end;

                decLineAmount := Round(decLineAmount * decCurrencyFactor, 0.01);
                decDiscountAmount := Round(decDiscountAmount * decCurrencyFactor, 0.01);
                decTaxableAmount := Round(decTaxableAmount * decCurrencyFactor, 0.01);
                //decCGSTAmount := Round(decCGSTAmount * decCurrencyFactor, 0.01);
                //decIGSTAmount := Round(decIGSTAmount * decCurrencyFactor, 0.01);
                //decSGSTAmount := Round(decSGSTAmount * decCurrencyFactor, 0.01);
                decTDSAmount := Round(decTDSAmount * decCurrencyFactor, 0.01);
                decInvoiceValue := decLineAmount + decIGSTAmount + decCGSTAmount + decSGSTAmount - decTDSAmount;

                if cdLocationGSTRegNo <> '' then
                    cdLocationStateCode := CopyStr(cdLocationGSTRegNo, 1, 2)
                else
                    cdLocationStateCode := '';

                if cdVendorGSTRegNo <> '' then
                    cdVendorStateCode := CopyStr(cdVendorGSTRegNo, 1, 2)
                else
                    cdVendorStateCode := '';

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
                        ApplicationArea = All;
                        Caption = 'From Date';
                    }
                    field(dtToDate; dtToDate)
                    {
                        ApplicationArea = all;
                        Caption = 'To Date';
                    }
                }
            }
        }
    }

    var
        dtFromDate: Date;
        dtToDate: Date;
        recCompanyInfo: Record "Company Information";
        recPurchInvoiceLines: Record "Purch. Inv. Line";
        recPurchCrMemoLines: Record "Purch. Cr. Memo Line";
        recReportData: Record "Purch. Inv. Line" temporary;
        recGLSetup: Record "General Ledger Setup";
        txtGlobalDim1Caption: Text[30];
        txtGlobalDim2Caption: Text[30];
        recDimensions: Record Dimension;
        intCounter: Integer;
        decCurrencyFactor: Decimal;
        txtDocumentType: Text[30];
        txtFilters: Text;
        cdLocationStateCode: Code[2];
        cdVendorStateCode: Code[2];
        decTaxableAmount: Decimal;
        decIGSTAmount: Decimal;
        decCGSTAmount: Decimal;
        decSGSTAmount: Decimal;
        decOtherCharges: Decimal;
        decTDSAmount: Decimal;
        decInvoiceValue: Decimal;
        decDiscountAmount: Decimal;
        decLineAmount: Decimal;
        recPurchInvoiceHeader: Record "Purch. Inv. Header";
        recPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        cdLocationGSTRegNo: Code[15];
        cdVendorGSTRegNo: Code[15];
        cdCurrencyCode: Code[10];
        txtBillFromName: Text[100];
        cdVendorPostingGroup: Code[20];
        decIGSTPerc: Decimal;
        decSGSTPerc: Decimal;
        decCGSTPerc: Decimal;
        blnReverseCharge: Boolean;
        cdVendorInvoiceNo: Code[50];
        dtVendorInvoiceDate: Date;
        txtVendorGSTStatus: Text[30];
        recILE: Record "Item Ledger Entry";
        txtPostingMonth: Text;
        txtPostingYear: Text;
        txtRCM: Text;
        txtPlaceOfSupply: Text;
        txtBillOfEntryNo: Text;
        dtBillofEntryDate: Date;
        txtGSTLedger: Text;
        decGSTRate: Decimal;
        txtTDSLedger: Text;
        txtTDSSection: Text;
        dtPaymentDate: Date;
        recGSTSetup: Record "GST Posting Setup";
        recLocation: Record Location;
        recTDSDEntry: Record "TDS Entry";
        decTDSRate: Decimal;
        txtOriginalDocumentNo: Text;
        dtOriginalDocumentDate: Date;
        txtVendorAddress: Text;
        recValueEntry: Record "Value Entry";
        txtInternalDocType: Text[30];
        cdTDSConcessionalCode: Code[20];
        recPurchCommentLine: Record "Purch. Comment Line";
        txtNarration: Text;
}