report 50198 "GST Outward Report"
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
            column(GLAccountCode; cdGLAccountNo) { }
            column(ReturnPeriod; cdReturnPeriod) { }
            column(SupplierGSTIN; cdLocationGSTRegNo) { }
            column(DocumentType; cdDocumentType) { }
            column(SupplyType; cdSupplyType) { }
            column(txtInternalDocType; txtInternalDocType) { }
            column(DocumentNumber; recReportData."Document No.") { }
            column(DocumentDate; Format(recReportData."Posting Date")) { }
            column(OriginalDocumentNumber; cdOriginalInvNo) { }
            column(OriginalDocumentDate; Format(dtOriginalInvDate)) { }
            column(LineNumber; intSrNo) { }
            column(CustomerGSTIN; cdCustomerGST) { }
            column(OriginalCustomerGSTIN; '') { }
            column(CustomerName; txtCustomerName) { }
            column(POS; cdPOS) { }
            column(HSNorSAC; recReportData."HSN/SAC Code") { }
            column(ItemDescription; recReportData.Description) { }
            column(UnitOfMeasurement; recReportData."Unit of Measure Code") { }
            column(Quantity; recReportData.Quantity) { }
            column(TaxableValue; Round(decTaxableAmount * decCurrencyFactor, 0.01)) { }
            column(IntegratedTaxRate; decIGSTPerc) { }
            column(IntegratedTaxAmount; Round(decIGSTAmount * decCurrencyFactor, 0.01)) { }
            column(CentralTaxRate; decCGSTPerc) { }
            column(CentralTaxAmount; Round(decCGSTAmount * decCurrencyFactor, 0.01)) { }
            column(StateUTTaxRate; decSGSTPerc) { }
            column(StateUTTaxAmount; Round(decSGSTAmount * decCurrencyFactor, 0.01)) { }
            column(CessRateAdvalorem; 0) { }
            column(CessAmountAdvalorem; 0) { }
            column(InvoiceValue; Round(decInvoiceValue * decCurrencyFactor, 0.01)) { }
            column(ReverseChargeFlag; cdReverseCharge) { }
            column(TCSFlag; cdTCSFlag) { }
            column(ECommerceGSTIN; cdECommGST) { }
            column(ReasonCrDrNote; '') { }
            column(AccountingVoucherNumber; recReportData."Document No.") { }
            column(AccountingVoucherDate; Format(recReportData."Posting Date")) { }
            column(Narration; txtNarration) { }

            trigger OnPreDataItem()
            begin
                if (Format(dtFromDate) = '') and (Format(dtToDate) = '') then
                    Error('The From or To Date must not be blank.');

                recCompanyInfo.Get();

                recReportData.Reset();
                recReportData.DeleteAll();
                recSalesInvoiceLines.Reset();
                recSalesInvoiceLines.SetRange("System-Created Entry", false);
                recSalesInvoiceLines.SetFilter(Quantity, '<>%1', 0);
                recSalesInvoiceLines.SetRange("Posting Date", dtFromDate, dtToDate);
                if recSalesInvoiceLines.FindFirst() then begin
                    repeat
                        recReportData.Init();
                        recReportData.TransferFields(recSalesInvoiceLines);
                        recReportData.Insert();
                    until recSalesInvoiceLines.Next() = 0;
                end;

                recSalesCrMemoLines.Reset();
                recSalesCrMemoLines.SetRange("System-Created Entry", false);
                recSalesCrMemoLines.SetFilter(Quantity, '<>%1', 0);
                recSalesCrMemoLines.SetRange("Posting Date", dtFromDate, dtToDate);
                if recSalesCrMemoLines.FindFirst() then
                    repeat
                        recReportData.Init();
                        recReportData.TransferFields(recSalesCrMemoLines);
                        recReportData.Quantity := -recSalesCrMemoLines.Quantity;
                        recReportData.Insert();
                    until recSalesCrMemoLines.Next() = 0;

                txtHeading := 'GST Outward Report for the period from ' + Format(dtFromDate) + ' to ' + Format(dtToDate);

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
                cdCustomerGST := '';
                cdPOS := '';
                decTaxableAmount := 0;
                decIGSTAmount := 0;
                decCGSTAmount := 0;
                decSGSTAmount := 0;
                decIGSTPerc := 0;
                decSGSTPerc := 0;
                decCGSTPerc := 0;
                decInvoiceValue := 0;
                cdReverseCharge := 'N';
                cdTCSFlag := '';
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
                recCustomer.Get(recReportData."Bill-to Customer No.");

                if recSalesInvoiceLines.Get(recReportData."Document No.", recReportData."Line No.") then begin
                    recSalesInvoiceLines.CalcFields("GST Base Amount", "IGST Amount", "CGST Amount", "SGST Amount");
                    recSalesInvoiceLines.CalcFields("IGST %", "CGST %", "SGST %");
                    recSalesInvoiceLines.CalcFields("NOC Wise TCS Amount", "NOC Wise TCS Base Amount");

                    if recSalesInvoiceLines."NOC Wise TCS Base Amount" <> 0 then begin
                        if Round(recSalesInvoiceLines."NOC Wise TCS Amount" / recSalesInvoiceLines."NOC Wise TCS Base Amount" * recSalesInvoiceLines."Line Amount", 0.01) <> 0 then
                            cdTCSFlag := 'Y'
                        else
                            cdTCSFlag := 'N';
                    end else
                        cdTCSFlag := 'N';

                    recSalesInvoiceHeader.Get(recReportData."Document No.");
                    recSalesInvoiceHeader.CalcFields("IGST Amount", "CGST Amount", "SGST Amount", "Total Line Amount");
                    cdLocationGSTRegNo := recSalesInvoiceHeader."Location GST Reg. No.";
                    cdCustomerGST := recSalesInvoiceHeader."Customer GST Reg. No.";
                    txtCustomerName := recSalesInvoiceHeader."Bill-to Name";
                    txtInternalDocType := Format(recSalesInvoiceHeader."Internal Document Type");

                    if recState.Get(recSalesInvoiceHeader."GST Bill-to State Code") then
                        cdPOS := recState."State Code (GST Reg. No.)";

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

                    if recSalesInvoiceHeader."Currency Code" <> '' then
                        decCurrencyFactor := 1 / recSalesInvoiceHeader."Currency Factor"
                    else
                        decCurrencyFactor := 1;

                    if recSalesInvoiceHeader."Invoice Type" = recSalesInvoiceHeader."Invoice Type"::"Debit Note" then
                        cdDocumentType := 'DR'
                    else
                        cdDocumentType := 'INV';

                    if recSalesInvoiceLines.Type = recSalesInvoiceLines.Type::"G/L Account" then
                        cdGLAccountNo := recSalesInvoiceLines."No."
                    else begin
                        recGeneralPostingSetup.Reset();
                        recGeneralPostingSetup.SetRange("Gen. Bus. Posting Group", recSalesInvoiceLines."Gen. Bus. Posting Group");
                        recGeneralPostingSetup.SetRange("Gen. Prod. Posting Group", recSalesInvoiceLines."Gen. Prod. Posting Group");
                        recGeneralPostingSetup.FindFirst();
                        cdGLAccountNo := recGeneralPostingSetup."Purch. Account";
                    end;

                    if recSalesInvoiceHeader."GST Customer Type" in [recSalesInvoiceHeader."GST Customer Type"::"SEZ Development", recSalesInvoiceHeader."GST Customer Type"::"SEZ Unit"] then begin
                        cdSupplyType := 'SEZ';
                    end else
                        if recSalesInvoiceHeader."GST Customer Type" = recSalesInvoiceHeader."GST Customer Type"::Export then begin
                            cdPOS := '96';
                            if recSalesInvoiceHeader."IGST Amount" + recSalesInvoiceHeader."CGST Amount" + recSalesInvoiceHeader."SGST Amount" <> 0 then begin
                                cdSupplyType := 'EXPT';
                            end else
                                cdSupplyType := 'EXPWT';
                        end else
                            if recCustomer."Country/Region Code" <> 'IN' then begin
                                cdPOS := '96';
                                if recSalesInvoiceHeader."IGST Amount" + recSalesInvoiceHeader."CGST Amount" + recSalesInvoiceHeader."SGST Amount" <> 0 then begin
                                    cdSupplyType := 'EXPT';
                                end else
                                    cdSupplyType := 'EXPWT';
                            end else
                                if recSalesInvoiceHeader."IGST Amount" + recSalesInvoiceHeader."CGST Amount" + recSalesInvoiceHeader."SGST Amount" <> 0 then
                                    cdSupplyType := 'TAX'
                                else
                                    if recSalesInvoiceLines."GST Group Code" <> '' then
                                        cdSupplyType := 'NIL'
                                    else
                                        cdSupplyType := 'EXT';

                    decTaxableAmount := recSalesInvoiceLines."Line Amount";
                    decIGSTAmount := recSalesInvoiceLines."IGST Amount";
                    decSGSTAmount := recSalesInvoiceLines."SGST Amount";
                    decCGSTAmount := recSalesInvoiceLines."CGST Amount";
                    decIGSTPerc := recSalesInvoiceLines."IGST %";
                    decSGSTPerc := recSalesInvoiceLines."SGST %";
                    decCGSTPerc := recSalesInvoiceLines."CGST %";
                    decInvoiceValue := recSalesInvoiceLines."Line Amount" + recSalesInvoiceLines."IGST Amount" + recSalesInvoiceLines."CGST Amount" + recSalesInvoiceLines."SGST Amount";

                    recRefInvNo.Reset();
                    recRefInvNo.SetRange("Document No.", recSalesInvoiceHeader."No.");
                    if recRefInvNo.FindFirst() then begin
                        cdOriginalInvNo := recRefInvNo."Reference Invoice Nos.";
                        recSalesInvoiceHeader.Get(cdOriginalInvNo);
                        dtOriginalInvDate := recSalesInvoiceHeader."Document Date";
                    end;
                end else begin
                    recSalesCrMemoLines.Get(recReportData."Document No.", recReportData."Line No.");
                    recSalesCrMemoLines.CalcFields("GST Base Amount", "IGST Amount", "CGST Amount", "SGST Amount");
                    recSalesCrMemoLines.CalcFields("IGST %", "CGST %", "SGST %");
                    recSalesCrMemoLines.CalcFields("NOC Wise TCS Amount", "NOC Wise TCS Base Amount");

                    if recSalesCrMemoLines."NOC Wise TCS Base Amount" <> 0 then begin
                        if Round(recSalesCrMemoLines."NOC Wise TCS Amount" / recSalesCrMemoLines."NOC Wise TCS Base Amount" * recSalesCrMemoLines."Line Amount", 0.01) <> 0 then
                            cdTCSFlag := 'Y'
                        else
                            cdTCSFlag := 'N';
                    end else
                        cdTCSFlag := 'N';

                    recSalesCrMemoHeader.Get(recReportData."Document No.");
                    recSalesCrMemoHeader.CalcFields("IGST Amount", "CGST Amount", "SGST Amount", "Total Line Amount");
                    cdLocationGSTRegNo := recSalesCrMemoHeader."Location GST Reg. No.";
                    cdDocumentType := 'CR';
                    cdCustomerGST := recSalesCrMemoHeader."Customer GST Reg. No.";
                    txtCustomerName := recSalesCrMemoHeader."Bill-to Name";
                    txtInternalDocType := Format(recSalesCrMemoHeader."Internal Document Type");

                    if recState.Get(recSalesCrMemoHeader."GST Bill-to State Code") then
                        cdPOS := recState."State Code (GST Reg. No.)";

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

                    if recSalesCrMemoHeader."Currency Code" <> '' then
                        decCurrencyFactor := 1 / recSalesCrMemoHeader."Currency Factor"
                    else
                        decCurrencyFactor := 1;

                    if recSalesCrMemoLines.Type = recSalesCrMemoLines.Type::"G/L Account" then
                        cdGLAccountNo := recSalesCrMemoLines."No."
                    else begin
                        recGeneralPostingSetup.Reset();
                        recGeneralPostingSetup.SetRange("Gen. Bus. Posting Group", recSalesCrMemoLines."Gen. Bus. Posting Group");
                        recGeneralPostingSetup.SetRange("Gen. Prod. Posting Group", recSalesCrMemoLines."Gen. Prod. Posting Group");
                        recGeneralPostingSetup.FindFirst();
                        cdGLAccountNo := recGeneralPostingSetup."Purch. Account";
                    end;

                    if recSalesCrMemoHeader."GST Customer Type" in [recSalesCrMemoHeader."GST Customer Type"::"SEZ Development", recSalesCrMemoHeader."GST Customer Type"::"SEZ Unit"] then begin
                        cdSupplyType := 'SEZ';
                    end else
                        if recSalesCrMemoHeader."GST Customer Type" = recSalesCrMemoHeader."GST Customer Type"::Export then begin
                            if recSalesCrMemoHeader."IGST Amount" + recSalesCrMemoHeader."CGST Amount" + recSalesCrMemoHeader."SGST Amount" <> 0 then
                                cdSupplyType := 'EXPT'
                            else
                                cdSupplyType := 'EXPWT';
                            cdPOS := '96';
                        end else
                            if recCustomer."Country/Region Code" <> 'IN' then begin
                                cdPOS := '96';
                                if recSalesCrMemoHeader."IGST Amount" + recSalesCrMemoHeader."CGST Amount" + recSalesCrMemoHeader."SGST Amount" <> 0 then begin
                                    cdSupplyType := 'EXPT';
                                end else
                                    cdSupplyType := 'EXPWT';
                            end else
                                if recSalesCrMemoHeader."IGST Amount" + recSalesCrMemoHeader."SGST Amount" + recSalesCrMemoHeader."CGST Amount" <> 0 then
                                    cdSupplyType := 'TAX'
                                else
                                    if recSalesCrMemoLines."GST Group Code" <> '' then
                                        cdSupplyType := 'NIL'
                                    else
                                        cdSupplyType := 'EXT';

                    decTaxableAmount := -recSalesCrMemoLines."Line Amount";
                    decIGSTAmount := recSalesCrMemoLines."IGST Amount";
                    decSGSTAmount := recSalesCrMemoLines."SGST Amount";
                    decCGSTAmount := recSalesCrMemoLines."CGST Amount";
                    decIGSTPerc := recSalesCrMemoLines."IGST %";
                    decSGSTPerc := recSalesCrMemoLines."SGST %";
                    decCGSTPerc := recSalesCrMemoLines."CGST %";
                    decInvoiceValue := -(recSalesCrMemoLines."Line Amount" + Abs(recSalesCrMemoLines."IGST Amount" + recSalesCrMemoLines."CGST Amount" + recSalesCrMemoLines."SGST Amount"));

                    recRefInvNo.Reset();
                    recRefInvNo.SetRange("Document No.", recSalesCrMemoHeader."No.");
                    if recRefInvNo.FindFirst() then begin
                        cdOriginalInvNo := recRefInvNo."Reference Invoice Nos.";
                        recSalesInvoiceHeader.Get(cdOriginalInvNo);
                        dtOriginalInvDate := recSalesInvoiceHeader."Document Date";
                    end;
                end;

                if recCustomer."E-Commerce Operator" then
                    cdECommGST := cdCustomerGST
                else
                    cdECommGST := '';
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
            LayoutFile = 'Customization\Reports\50198_GSTOutward.rdl';
        }
    }

    var
        dtFromDate: Date;
        dtToDate: Date;
        recCompanyInfo: Record "Company Information";
        recReportData: Record "Sales Invoice Line" temporary;
        recSalesInvoiceHeader: Record "Sales Invoice Header";
        recSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        intCounter: Integer;
        recSalesInvoiceLines: Record "Sales Invoice Line";
        recSalesCrMemoLines: Record "Sales Cr.Memo Line";
        decCurrencyFactor: Decimal;
        cdGLAccountNo: Code[20];
        recGeneralPostingSetup: Record "General Posting Setup";
        txtHeading: Text;
        cdReturnPeriod: Code[10];
        cdLocationGSTRegNo: Code[20];
        cdDocumentType: Code[10];
        cdSupplyType: Code[10];
        cdOriginalInvNo: Code[20];
        dtOriginalInvDate: Date;
        recRefInvNo: Record "Reference Invoice No.";
        cdCustomerGST: Code[20];
        txtCustomerName: Text[100];
        cdPOS: Code[10];
        decTaxableAmount: Decimal;
        decIGSTAmount: Decimal;
        decCGSTAmount: Decimal;
        decSGSTAmount: Decimal;
        decIGSTPerc: Decimal;
        decSGSTPerc: Decimal;
        decCGSTPerc: Decimal;
        decInvoiceValue: Decimal;
        cdReverseCharge: Code[10];
        cdTCSFlag: Code[10];
        recCustomer: Record Customer;
        cdECommGST: Code[20];
        txtInternalDocType: Text[30];
        recSalesCommentLine: Record "Sales Comment Line";
        txtNarration: Text;
        intSrNo: Integer;
        cdOldDocNo: Code[20];
        cdOldHSNSAC: Code[20];
        recState: Record State;
}