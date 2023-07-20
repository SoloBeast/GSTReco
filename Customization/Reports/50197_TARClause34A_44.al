report 50197 "TAR Clause 34A / 44"
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
            column(DocumentNo; recReportData."Document No.") { }
            column(BookingDate; Format(recReportData."Posting Date")) { }
            column(VoucherDate; Format(recReportData."Posting Date")) { }
            column(VendorName; txtSupplierName) { }
            column(VendorGSTIN; cdSupplierGSTRegNo) { }
            column(VendorPAN; cdVendorPAN) { }
            column(VendorStatus; txtVendorStatus) { }
            column(SupplyType; cdSupplyType) { }
            column(VendorAddress; recVendor.Address + ' ' + recVendor."Address 2") { }
            column(LedgerName; recGLAccount.Name) { }
            column(LedgerNo; cdGLAccountNo) { }
            column(InvoiceJVNo; cdVendorInvoiceNo) { }
            column(NarrationDescription; recReportData.Description) { }
            column(ExpenseAmount; Round(recReportData."Line Amount" * decCurrencyFactor, 0.01)) { }
            column(TDSSection; recReportData."TDS Section Code") { }
            column(TDSRate; decTDSRate) { }
            column(TDSAmount; decTDSAmount) { }
            column(IGSTAmount; decIGSTAmount) { }
            column(CGSTAmount; decCGSTAmount) { }
            column(SGSTAmount; decSGSTAmount) { }

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

                txtHeading := 'TAR Clause 34A / 44 Report for the period from ' + Format(dtFromDate) + ' to ' + Format(dtToDate);

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

                cdGLAccountNo := '';
                cdSupplyType := '';
                decIGSTAmount := 0;
                decCGSTAmount := 0;
                decSGSTAmount := 0;
                txtVendorStatus := '';
                decTDSAmount := 0;
                decTDSRate := 0;

                recReportData.Reset();
                recReportData.SetCurrentKey("Posting Date");
                recReportData.FindFirst();

                if recPurchInvoiceLines.Get(recReportData."Document No.", recReportData."Line No.") then begin
                    recPurchInvoiceLines.CalcFields("GST Base Amount", "IGST Amount", "CGST Amount", "SGST Amount");

                    recPurchInvoiceHeader.Get(recReportData."Document No.");
                    txtVendorStatus := Format(recPurchInvoiceHeader."GST Vendor Type");
                    cdSupplierGSTRegNo := recPurchInvoiceHeader."Vendor GST Reg. No.";

                    recTDSEntry.Reset();
                    recTDSEntry.SetRange("Document No.", recPurchInvoiceHeader."No.");
                    if recTDSEntry.FindFirst() then
                        decTDSRate := recTDSEntry."TDS %";
                    if recPurchInvoiceLines."Section Wise TDS Base Amount" <> 0 then
                        decTDSAmount := Round(recPurchInvoiceLines."Section Wise TDS Amount" / recPurchInvoiceLines."Section Wise TDS Base Amount" * recPurchInvoiceLines."Line Amount", 0.01);

                    cdVendorInvoiceNo := recPurchInvoiceHeader."Vendor Invoice No.";
                    txtSupplierName := recPurchInvoiceHeader."Buy-from Vendor Name";

                    if recPurchInvoiceHeader."Currency Code" <> '' then
                        decCurrencyFactor := 1 / recPurchInvoiceHeader."Currency Factor"
                    else
                        decCurrencyFactor := 1;

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

                    decIGSTAmount := recPurchInvoiceLines."IGST Amount";
                    decSGSTAmount := recPurchInvoiceLines."SGST Amount";
                    decCGSTAmount := recPurchInvoiceLines."CGST Amount";

                end else begin
                    recPurchCrMemoLines.Get(recReportData."Document No.", recReportData."Line No.");
                    recPurchCrMemoLines.CalcFields("GST Base Amount", "IGST Amount", "CGST Amount", "SGST Amount");

                    recPurchCrMemoHeader.Get(recReportData."Document No.");
                    txtVendorStatus := Format(recPurchCrMemoHeader."GST Vendor Type");
                    cdSupplierGSTRegNo := recPurchCrMemoHeader."Vendor GST Reg. No.";

                    decTDSRate := recPurchCrMemoLines."TDS %";
                    decTDSAmount := recPurchCrMemoLines."TDS Amount";

                    cdVendorInvoiceNo := recPurchCrMemoHeader."Vendor Cr. Memo No.";
                    txtSupplierName := recPurchCrMemoHeader."Buy-from Vendor Name";

                    if recPurchCrMemoHeader."Currency Code" <> '' then
                        decCurrencyFactor := 1 / recPurchCrMemoHeader."Currency Factor"
                    else
                        decCurrencyFactor := 1;

                    if recPurchCrMemoLines.Type = recPurchCrMemoLines.Type::"G/L Account" then
                        cdGLAccountNo := recPurchCrMemoLines."No."//;

                    // if recPurchCrMemoLines.Type = recPurchCrMemoLines.Type::"Fixed Asset" then
                    //     cdGLAccountNo := recPurchCrMemoLines."No."
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

                    decIGSTAmount := recPurchCrMemoLines."IGST Amount";
                    decSGSTAmount := recPurchCrMemoLines."SGST Amount";
                    decCGSTAmount := recPurchCrMemoLines."CGST Amount";
                end;

                recVendor.Get(recReportData."Buy-from Vendor No.");
                cdVendorPAN := recVendor."P.A.N. No.";
                recGLAccount.Get(cdGLAccountNo);
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
            LayoutFile = 'Customization\Reports\50197_TARClause34A_44.rdl';
        }
    }

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
        cdSupplyType: Code[10];
        cdVendorInvoiceNo: Code[20];
        cdSupplierGSTRegNo: Code[15];
        txtSupplierName: Text[100];
        decIGSTAmount: Decimal;
        decCGSTAmount: Decimal;
        decSGSTAmount: Decimal;
        cdVendorPAN: Code[20];
        recVendor: Record Vendor;
        txtVendorStatus: Text[30];
        recGLAccount: Record "G/L Account";
        decTDSRate: Decimal;
        decTDSAmount: Decimal;
        recTDSEntry: Record "TDS Entry";
}