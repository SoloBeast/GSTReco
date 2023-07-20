report 50009 "Detailed Sales Register"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\SalesRegisterDetailed_Iappc_50009.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; 'Detailed Sales Register for the Period Starting from ' + format(dtFromDate) + ' to ' + Format(dtToDate)) { }
            column(Filters; txtFilters) { }
            column(UserID; UserId) { }
            column(TimeStamp; Format(CurrentDateTime)) { }
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
            column(CustomerNo; recReportData."Bill-to Customer No.") { }
            column(CustomerName; txtBilltoName) { }
            column(CustomerPostingGroup; cdCustomerPostingGroup) { }
            column(CustomerGSTStatus; txtCustomerGSTStatus) { }
            column(CustomerGSTRegistrationNo; cdCustomerGSTRegNo) { }
            column(StateCode; cdCustomerStateCode) { }
            column(ShipToCode; recShipToAddress.Code) { }
            column(ShipToName; recShipToAddress.Name) { }
            column(ShipToGSTRegistrationNo; cdShipToGSTRegNo) { }
            column(ShipToStateCode; cdShipToStateCode) { }
            column(CurrencyCode; cdCurrencyCode) { }
            column(CurrencyFactor; decCurrencyFactor) { }
            column(SupplyType; cdSupplyType) { }
            column(LineType; recReportData.Type) { }
            column(AccountCode; recReportData."No.") { }
            column(AccountName; recReportData.Description) { }
            column(ItemCategory; recReportData."Item Category Code") { }
            column(PostingGroup; recReportData."Posting Group") { }
            column(GenProdGroup; recReportData."Gen. Prod. Posting Group") { }
            column(GSTGroupCode; recReportData."GST Group Code") { }
            column(HSNSACCode; recReportData."HSN/SAC Code") { }
            column(Quantity; recReportData.Quantity) { }
            column(UnitPrice; recReportData."Unit Price") { }
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
            column(TCSAmount; decTCSAmount) { }
            column(InvoiceValue; decInvoiceValue) { }
            column(PostingMonth; txtPositingMonth) { }
            column(Narration; txtNarration) { }
            column(lineNo; recReportData."Shipment Line No.") { }//recReportData."Line No.") { }
            column(txtIRN; txtIRN) { }
            column(txtIRNAckNo; txtIRNAckNo) { }
            column(dtIRNDate; Format(dtIRNDate)) { }
            column(txtOriginalDocumentNo; txtOriginalDocumentNo) { }
            column(txtOriginalDocumentDate; dtOriginalDocumentDate) { }
            column(txtCustomerAddresscode; recSalesInvoiceHeader."Bill-to Address") { }
            column(txtPlaceofsupply; cdCustomerStateCode) { }

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

                cdOldDocNo := '';
                recReportData.Reset();
                recReportData.DeleteAll();
                recSalesInvoiceLines.Reset();
                recSalesInvoiceLines.SetRange("System-Created Entry", false);
                recSalesInvoiceLines.SetFilter(Quantity, '<>%1', 0);
                recSalesInvoiceLines.SetRange("Posting Date", dtFromDate, dtToDate);
                if recSalesInvoiceLines.FindFirst() then begin
                    //txtFilters := recSalesInvoiceLines.GetFilters;
                    repeat
                        recReportData.Init();
                        recReportData.TransferFields(recSalesInvoiceLines);
                        if cdOldDocNo <> recReportData."Document No." then
                            intLineNo := 0;
                        intLineNo += 1;
                        cdOldDocNo := recReportData."Document No.";
                        recReportData."Shipment Line No." := intLineNo;
                        recReportData.Insert();
                    until recSalesInvoiceLines.Next() = 0;
                end;
                cdOldDocNo := '';
                recSalesCrMemoLines.Reset();
                recSalesCrMemoLines.SetRange("System-Created Entry", false);
                recSalesCrMemoLines.SetFilter(Quantity, '<>%1', 0);
                recSalesCrMemoLines.SetRange("Posting Date", dtFromDate, dtToDate);
                if recSalesCrMemoLines.FindFirst() then
                    repeat
                        recReportData.Init();
                        recReportData.TransferFields(recSalesCrMemoLines);
                        recReportData.Quantity := -recSalesCrMemoLines.Quantity;
                        if cdOldDocNo <> recReportData."Document No." then
                            intLineNo := 0;
                        intLineNo += 1;
                        cdOldDocNo := recReportData."Document No.";
                        recReportData."Shipment Line No." := intLineNo;
                        recReportData.Insert();
                    until recSalesCrMemoLines.Next() = 0;

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
                cdCustomerPostingGroup := '';
                txtBillToName := '';
                txtCustomerGSTStatus := '';
                txtInternalDocType := '';
                txtNarration := '';
                cdSupplyType := '';

                recReportData.Reset();
                recReportData.SetCurrentKey("Posting Date");
                recReportData.FindFirst();
                if recSalesInvoiceLines.Get(recReportData."Document No.", recReportData."Line No.") then begin
                    txtDocumentType := 'Invoice';
                    recSalesInvoiceHeader.Get(recReportData."Document No.");

                    if recState.Get(recSalesInvoiceHeader."GST Bill-to State Code") then
                        cdCustomerStateCode := recState."State Code (GST Reg. No.)";

                    if recSalesInvoiceHeader."GST Customer Type" in [recSalesInvoiceHeader."GST Customer Type"::"SEZ Development", recSalesInvoiceHeader."GST Customer Type"::"SEZ Unit"] then begin
                        cdSupplyType := 'SEZ';
                    end else
                        if recSalesInvoiceHeader."Currency Code" <> '' then begin
                            if recSalesInvoiceHeader."IGST Amount" + recSalesInvoiceHeader."CGST Amount" + recSalesInvoiceHeader."SGST Amount" <> 0 then begin
                                cdCustomerStateCode := '96';
                                cdSupplyType := 'EXPT'
                            end else begin
                                cdSupplyType := 'EXPWT';
                                cdCustomerStateCode := '96';
                            end;
                        end else
                            if recSalesInvoiceHeader."IGST Amount" + recSalesInvoiceHeader."CGST Amount" + recSalesInvoiceHeader."SGST Amount" <> 0 then
                                cdSupplyType := 'TAX'
                            else
                                if recSalesInvoiceLines."GST Group Code" <> '' then
                                    cdSupplyType := 'NIL'
                                else
                                    cdSupplyType := 'EXT';

                    recSalesCommentLine.Reset();
                    recSalesCommentLine.SetRange("Document Type", recSalesCommentLine."Document Type"::"Posted Invoice");
                    recSalesCommentLine.SetRange("No.", recSalesInvoiceHeader."No.");
                    recSalesCommentLine.SetRange("Document Line No.", 0);
                    if recSalesCommentLine.FindFirst() then
                        repeat
                            if txtNarration = '' then
                                txtNarration := recSalesCommentLine.Comment
                            else
                                txtNarration := txtNarration + ' ' + recSalesCommentLine.Comment;
                        until recSalesCommentLine.Next() = 0;

                    txtInternalDocType := Format(recSalesInvoiceHeader."Internal Document Type");
                    txtBillToName := recSalesInvoiceHeader."Bill-to Name";
                    cdCustomerPostingGroup := recSalesInvoiceHeader."Customer Posting Group";
                    cdLocationGSTRegNo := recSalesInvoiceHeader."Location GST Reg. No.";
                    cdCustomerGSTRegNo := recSalesInvoiceHeader."Customer GST Reg. No.";
                    cdShipToGSTRegNo := recSalesInvoiceHeader."Ship-to GST Reg. No.";
                    cdCurrencyCode := recSalesInvoiceHeader."Currency Code";
                    txtCustomerGSTStatus := Format(recSalesInvoiceHeader."GST Customer Type");
                    txtPositingMonth := format(Date2DMY(recSalesInvoiceHeader."Posting Date", 2));
                    txtPostingYear := format(Date2DMY(recSalesInvoiceHeader."Posting Date", 3));
                    if StrLen(txtPositingMonth) = 1 then
                        txtPositingMonth := '0' + txtPositingMonth;
                    if StrLen(txtPostingYear) = 2 then
                        txtPositingMonth := '20' + txtPostingYear;

                    txtPositingMonth := txtPositingMonth + txtPostingYear;
                    txtIRN := '';
                    txtIRNAckNo := '';
                    dtIRNDate := 0D;
                    txtOriginalDocumentNo := '';
                    dtOriginalDocumentDate := 0D;
                    txtCustomerAddresscode := recSalesInvoiceHeader."Bill-to Address" + ' ' + recSalesInvoiceHeader."Bill-to Address 2";

                    if recSalesInvoiceHeader."Currency Code" <> '' then
                        txtPlaceofsupply := '96'
                    else
                        txtPlaceofsupply := CopyStr(recSalesInvoiceHeader."Customer GST Reg. No.", 1, 2);

                    if recSalesInvoiceHeader."Currency Code" <> '' then
                        decCurrencyFactor := 1 / recSalesInvoiceHeader."Currency Factor"
                    else
                        decCurrencyFactor := 1;

                    recSalesInvoiceLines.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
                    recSalesInvoiceLines.CalcFields("NOC Wise TCS Amount", "NOC Wise TCS Base Amount");
                    recSalesInvoiceLines.CalcFields("IGST %", "CGST %", "SGST %");

                    decLineAmount := recSalesInvoiceLines."Line Amount" + recSalesInvoiceLines."Line Discount Amount";
                    decDiscountAmount := recSalesInvoiceLines."Line Discount Amount" + recSalesInvoiceLines."Inv. Discount Amount";
                    decTaxableAmount := recSalesInvoiceLines."Line Amount" - recSalesInvoiceLines."Inv. Discount Amount";
                    decCGSTAmount := recSalesInvoiceLines."CGST Amount";
                    decIGSTAmount := recSalesInvoiceLines."IGST Amount";
                    decSGSTAmount := recSalesInvoiceLines."SGST Amount";

                    if recSalesInvoiceLines."NOC Wise TCS Base Amount" <> 0 then
                        decTCSAmount := Round(recSalesInvoiceLines."NOC Wise TCS Amount" / recSalesInvoiceLines."NOC Wise TCS Base Amount" * recSalesInvoiceLines."Line Amount", 0.01);
                    decInvoiceValue := decLineAmount - decDiscountAmount + decCGSTAmount + decSGSTAmount + decIGSTAmount + decTCSAmount;
                    decIGSTPerc := recSalesInvoiceLines."IGST %";
                    decCGSTPerc := recSalesInvoiceLines."CGST %";
                    decSGSTPerc := recSalesInvoiceLines."SGST %";

                    if recSalesInvoiceHeader."Ship-to Code" = '' then
                        recShipToAddress.Init()
                    else
                        recShipToAddress.Get(recSalesInvoiceHeader."Sell-to Customer No.", recSalesInvoiceHeader."Ship-to Code");
                    if recSalesInvoiceHeader."IRN Hash" <> '' then begin
                        txtIRN := txtIRN + recSalesInvoiceHeader."IRN Hash";
                        txtIRNAckNo := txtIRNAckNo + recSalesInvoiceHeader."Acknowledgement No.";
                        dtIRNDate := DT2Date(recSalesInvoiceHeader."Acknowledgement Date")
                    end;
                end else begin
                    recSalesCrMemoLines.Get(recReportData."Document No.", recReportData."Line No.");
                    txtDocumentType := 'Credit Memo';
                    recSalesCrMemoHeader.Get(recReportData."Document No.");

                    if recState.Get(recSalesCrMemoHeader."GST Bill-to State Code") then
                        cdCustomerStateCode := recState."State Code (GST Reg. No.)";

                    if recSalesCrMemoHeader."GST Customer Type" in [recSalesCrMemoHeader."GST Customer Type"::"SEZ Development", recSalesCrMemoHeader."GST Customer Type"::"SEZ Unit"] then begin
                        cdSupplyType := 'SEZ';
                    end else
                        if recSalesCrMemoHeader."Currency Code" <> '' then begin
                            if recSalesCrMemoHeader."IGST Amount" + recSalesCrMemoHeader."CGST Amount" + recSalesCrMemoHeader."SGST Amount" <> 0 then
                                cdSupplyType := 'EXPT'
                            else
                                cdSupplyType := 'EXPWT';
                        end else
                            if recSalesCrMemoHeader."IGST Amount" + recSalesCrMemoHeader."CGST Amount" + recSalesCrMemoHeader."SGST Amount" <> 0 then
                                cdSupplyType := 'TAX'
                            else
                                if recSalesCrMemoLines."GST Group Code" <> '' then
                                    cdSupplyType := 'NIL'
                                else
                                    cdSupplyType := 'EXT';

                    recSalesCommentLine.Reset();
                    recSalesCommentLine.SetRange("Document Type", recSalesCommentLine."Document Type"::"Posted Credit Memo");
                    recSalesCommentLine.SetRange("No.", recSalesCrMemoHeader."No.");
                    recSalesCommentLine.SetRange("Document Line No.", 0);
                    if recSalesCommentLine.FindFirst() then
                        repeat
                            if txtNarration = '' then
                                txtNarration := recSalesCommentLine.Comment
                            else
                                txtNarration := txtNarration + ' ' + recSalesCommentLine.Comment;
                        until recSalesCommentLine.Next() = 0;

                    txtInternalDocType := Format(recSalesCrMemoHeader."Internal Document Type");
                    txtBillToName := recSalesCrMemoHeader."Bill-to Name";
                    cdCustomerPostingGroup := recSalesCrMemoHeader."Customer Posting Group";
                    cdLocationGSTRegNo := recSalesCrMemoHeader."Location GST Reg. No.";
                    cdCustomerGSTRegNo := recSalesCrMemoHeader."Customer GST Reg. No.";
                    cdShipToGSTRegNo := recSalesCrMemoHeader."Ship-to GST Reg. No.";
                    cdCurrencyCode := recSalesCrMemoHeader."Currency Code";
                    txtCustomerGSTStatus := Format(recSalesCrMemoHeader."GST Customer Type");
                    //+101
                    txtPositingMonth := format(Date2DMY(recSalesCrMemoHeader."Posting Date", 2));
                    txtPostingYear := format(Date2DMY(recSalesCrMemoHeader."Posting Date", 3));
                    if StrLen(txtPositingMonth) = 1 then
                        txtPositingMonth := '0' + txtPositingMonth;
                    if StrLen(txtPostingYear) = 2 then
                        txtPositingMonth := '20' + txtPostingYear;

                    txtPositingMonth := txtPositingMonth + txtPostingYear;
                    // txtOriginalDocumentNo := recSalesCrMemoHeader."Reference Invoice No.";
                    txtOriginalDocumentNo := recSalesCrMemoHeader."Applies-to Doc. No.";
                    recSalesInvoiceHeader.Reset();
                    // recSalesInvoiceHeader.SetRange("No.", recSalesCrMemoHeader."Reference Invoice No.");
                    recSalesInvoiceHeader.SetRange("No.", recSalesCrMemoHeader."Applies-to Doc. No.");
                    if recSalesInvoiceHeader.FindFirst() then
                        dtOriginalDocumentDate := recSalesInvoiceHeader."Posting Date";

                    txtIRN := '';
                    txtIRNAckNo := '';
                    dtIRNDate := 0D;
                    txtCustomerAddresscode := recSalesCrMemoHeader."Bill-to Address" + ' ' + recSalesCrMemoHeader."Bill-to Address 2";

                    if recSalesCrMemoHeader."Currency Code" <> '' then
                        txtPlaceofsupply := '96'
                    else
                        txtPlaceofsupply := CopyStr(recSalesCrMemoHeader."Customer GST Reg. No.", 1, 2);

                    if recSalesCrMemoHeader."Currency Code" <> '' then
                        decCurrencyFactor := 1 / recSalesCrMemoHeader."Currency Factor"
                    else
                        decCurrencyFactor := 1;

                    recSalesCrMemoLines.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
                    recSalesCrMemoLines.CalcFields("NOC Wise TCS Amount", "NOC Wise TCS Base Amount");
                    recSalesCrMemoLines.CalcFields("IGST %", "CGST %", "SGST %");

                    decLineAmount := recSalesCrMemoLines."Line Amount" + recSalesCrMemoLines."Line Discount Amount";
                    decDiscountAmount := recSalesCrMemoLines."Line Discount Amount" + recSalesCrMemoLines."Inv. Discount Amount";
                    decTaxableAmount := recSalesCrMemoLines."Line Amount" - recSalesCrMemoLines."Inv. Discount Amount";
                    decCGSTAmount := recSalesCrMemoLines."CGST Amount";
                    decIGSTAmount := recSalesCrMemoLines."IGST Amount";
                    decSGSTAmount := recSalesCrMemoLines."SGST Amount";

                    if recSalesCrMemoLines."NOC Wise TCS Base Amount" <> 0 then
                        decTCSAmount := Round(recSalesCrMemoLines."NOC Wise TCS Amount" / recSalesCrMemoLines."NOC Wise TCS Base Amount" * recSalesCrMemoLines."Line Amount", 0.01);
                    decInvoiceValue := decLineAmount - decDiscountAmount + Abs(decCGSTAmount + decSGSTAmount + decIGSTAmount) + decTCSAmount;
                    decIGSTPerc := recSalesCrMemoLines."IGST %";
                    decCGSTPerc := recSalesCrMemoLines."CGST %";
                    decSGSTPerc := recSalesCrMemoLines."SGST %";

                    decLineAmount := -decLineAmount;
                    decDiscountAmount := -decDiscountAmount;
                    decTaxableAmount := -decTaxableAmount;
                    decCGSTAmount := decCGSTAmount;
                    decSGSTAmount := decSGSTAmount;
                    decIGSTAmount := decIGSTAmount;
                    decTCSAmount := -decTCSAmount;
                    decInvoiceValue := -decInvoiceValue;

                    if recSalesCrMemoHeader."Ship-to Code" = '' then
                        recShipToAddress.Init()
                    else
                        recShipToAddress.Get(recSalesCrMemoHeader."Sell-to Customer No.", recSalesCrMemoHeader."Ship-to Code");
                    if recSalesCrMemoHeader."IRN Hash" <> '' then begin
                        txtIRN := txtIRN + recSalesCrMemoHeader."IRN Hash";
                        txtIRNAckNo := txtIRNAckNo + recSalesCrMemoHeader."Acknowledgement No.";
                        dtIRNDate := DT2Date(recSalesCrMemoHeader."Acknowledgement Date");
                    end;
                end;

                decLineAmount := Round(decLineAmount * decCurrencyFactor, 0.01);
                decDiscountAmount := Round(decDiscountAmount * decCurrencyFactor, 0.01);
                decTaxableAmount := Round(decTaxableAmount * decCurrencyFactor, 0.01);
                decCGSTAmount := Round(decCGSTAmount * decCurrencyFactor, 0.01);
                decIGSTAmount := Round(decIGSTAmount * decCurrencyFactor, 0.01);
                decSGSTAmount := Round(decSGSTAmount * decCurrencyFactor, 0.01);
                decTCSAmount := Round(decTCSAmount * decCurrencyFactor, 0.01);
                decInvoiceValue := Round(decInvoiceValue * decCurrencyFactor, 0.01);

                if cdLocationGSTRegNo <> '' then
                    cdLocationStateCode := CopyStr(cdLocationGSTRegNo, 1, 2)
                else
                    cdLocationStateCode := '';

                if cdShipToGSTRegNo <> '' then
                    cdShipToStateCode := CopyStr(cdShipToGSTRegNo, 1, 2)
                else
                    cdShipToStateCode := '';
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
        recSalesInvoiceLines: Record "Sales Invoice Line";
        recSalesCrMemoLines: Record "Sales Cr.Memo Line";
        recReportData: Record "Sales Invoice Line" temporary;
        recGLSetup: Record "General Ledger Setup";
        txtGlobalDim1Caption: Text[30];
        txtGlobalDim2Caption: Text[30];
        recDimensions: Record Dimension;
        intCounter: Integer;
        decCurrencyFactor: Decimal;
        txtDocumentType: Text[30];
        txtFilters: Text;
        cdLocationStateCode: Code[2];
        cdCustomerStateCode: Code[2];
        cdShipToStateCode: Code[2];
        recShipToAddress: Record "Ship-to Address";
        decTaxableAmount: Decimal;
        decIGSTAmount: Decimal;
        decCGSTAmount: Decimal;
        decSGSTAmount: Decimal;
        decOtherCharges: Decimal;
        decTCSAmount: Decimal;
        decInvoiceValue: Decimal;
        decDiscountAmount: Decimal;
        decLineAmount: Decimal;
        recSalesInvoiceHeader: Record "Sales Invoice Header";
        recSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        cdLocationGSTRegNo: Code[15];
        cdCustomerGSTRegNo: Code[15];
        cdShipToGSTRegNo: Code[15];
        cdCurrencyCode: Code[10];
        txtBillToName: Text[100];
        cdCustomerPostingGroup: Code[20];
        decIGSTPerc: Decimal;
        decSGSTPerc: Decimal;
        decCGSTPerc: Decimal;
        txtCustomerGSTStatus: Text[30];
        txtIRN: Text;
        txtIRNAckNo: Text;
        dtIRNDate: Date;
        txtOriginalDocumentNo: Text;
        dtOriginalDocumentDate: Date;
        txtCustomerAddresscode: Text;
        txtPlaceofsupply: Text;
        txtPositingMonth: Text;
        txtPostingYear: Text;
        intLineNo: Integer;
        cdOldDocNo: Code[20];
        txtNarration: Text;
        txtInternalDocType: Text[30];
        recSalesCommentLine: Record "Sales Comment Line";
        cdSupplyType: Code[10];
        recState: Record State;
}