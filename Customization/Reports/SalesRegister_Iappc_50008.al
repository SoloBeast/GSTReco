report 50008 "Sales Register"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\SalesRegister_Iappc_50008.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; 'Sales Register for the Period Starting from ' + format(dtFromDate) + ' to ' + Format(dtToDate)) { }
            column(Filters; txtFilters) { }
            column(GlobalDim1Caption; txtGlobalDim1Caption) { }
            column(GlobalDim2Caption; txtGlobalDim2Caption) { }
            column(PostingDate; recReportData."Posting Date") { }
            column(DocumentType; txtDocumentType) { }
            column(DocumentNo; recReportData."No.") { }
            column(LocationCode; recReportData."Location Code") { }
            column(LocationGSTRegistrationNo; recReportData."Location GST Reg. No.") { }
            column(LocationStateCode; cdLocationStateCode) { }
            column(GlobalDimension1Code; recReportData."Shortcut Dimension 1 Code") { }
            column(GlobalDimension2Code; recReportData."Shortcut Dimension 2 Code") { }
            column(CustomerNo; recReportData."Bill-to Customer No.") { }
            column(CustomerName; recReportData."Bill-to Name") { }
            column(CustomerPostingGroup; recReportData."Customer Posting Group") { }
            column(CustomerGSTStatus; recReportData."GST Customer Type") { }
            column(CustomerGSTRegistrationNo; recReportData."Customer GST Reg. No.") { }
            column(StateCode; cdCustomerStateCode) { }
            column(ShipToCode; recReportData."Ship-to Code") { }
            column(ShipToName; recShipToAddress.Name) { }
            column(ShipToGSTRegistrationNo; recReportData."Ship-to GST Reg. No.") { }
            column(ShipToStateCode; cdShipToStateCode) { }
            column(CurrencyCode; recReportData."Currency Code") { }
            column(CurrencyFactor; decCurrencyFactor) { }
            column(LineAmount; decLineAmount) { }
            column(DiscountAmount; decDiscountAmount) { }
            column(TaxableValue; decTaxableAmount) { }
            column(IGSTAmount; decIGSTAmount) { }
            column(CGSTAmount; decCGSTAmount) { }
            column(SGSTAmount; decSGSTAmount) { }
            column(OtherCharges; decOtherCharges) { }
            column(TCSAmount; decTCSAmount) { }
            column(InvoiceValue; decInvoiceValue) { }

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
                recSalesInvoiceHeader.Reset();
                recSalesInvoiceHeader.SetRange("Posting Date", dtFromDate, dtToDate);
                if recSalesInvoiceHeader.FindFirst() then begin
                    //txtFilters := recSalesInvoiceHeader.GetFilters;
                    repeat
                        recReportData.Init();
                        recReportData.TransferFields(recSalesInvoiceHeader);
                        recReportData.Insert();
                    until recSalesInvoiceHeader.Next() = 0;
                end;

                recSalesCrMemoHeader.Reset();
                recSalesCrMemoHeader.SetRange("Posting Date", dtFromDate, dtToDate);
                if recSalesCrMemoHeader.FindFirst() then
                    repeat
                        recReportData.Init();
                        recReportData.TransferFields(recSalesCrMemoHeader);
                        recReportData.Insert();
                    until recSalesCrMemoHeader.Next() = 0;

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

                recReportData.Reset();
                recReportData.SetCurrentKey("Posting Date");
                recReportData.FindFirst();
                if recSalesInvoiceHeader.Get(recReportData."No.") then begin
                    txtDocumentType := 'Invoice';
                    recSalesInvoiceHeader.CalcFields("Total Line Amount", "Total Line Discount", "Total GST Base Amount");
                    recSalesInvoiceHeader.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
                    recSalesInvoiceHeader.CalcFields("TCS Amount", "Invoice Discount Amount");

                    decLineAmount := recSalesInvoiceHeader."Total Line Amount" + recSalesInvoiceHeader."Total Line Discount";
                    decDiscountAmount := recSalesInvoiceHeader."Total Line Discount" + recSalesInvoiceHeader."Invoice Discount Amount";
                    decTaxableAmount := recSalesInvoiceHeader."Total Line Amount" - recSalesInvoiceHeader."Invoice Discount Amount";
                    decCGSTAmount := recSalesInvoiceHeader."CGST Amount";
                    decIGSTAmount := recSalesInvoiceHeader."IGST Amount";
                    decSGSTAmount := recSalesInvoiceHeader."SGST Amount";
                    decTCSAmount := recSalesInvoiceHeader."TCS Amount";
                    decInvoiceValue := decLineAmount - decDiscountAmount + decCGSTAmount + decSGSTAmount + decIGSTAmount + decTCSAmount;

                    if recSalesInvoiceHeader."Ship-to Code" = '' then
                        recShipToAddress.Init()
                    else
                        recShipToAddress.Get(recSalesInvoiceHeader."Sell-to Customer No.", recSalesInvoiceHeader."Ship-to Code");
                end else begin
                    recSalesCrMemoHeader.Get(recReportData."No.");
                    txtDocumentType := 'Credit Memo';

                    recSalesCrMemoHeader.CalcFields("Total Line Amount", "Total Line Discount", "Total GST Base Amount");
                    recSalesCrMemoHeader.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
                    recSalesCrMemoHeader.CalcFields("TCS Amount", "Invoice Discount Amount");

                    decLineAmount := recSalesCrMemoHeader."Total Line Amount" + recSalesCrMemoHeader."Total Line Discount";
                    decDiscountAmount := recSalesCrMemoHeader."Total Line Discount" + recSalesCrMemoHeader."Invoice Discount Amount";
                    decTaxableAmount := recSalesCrMemoHeader."Total Line Amount" - recSalesCrMemoHeader."Invoice Discount Amount";
                    decCGSTAmount := recSalesCrMemoHeader."CGST Amount";
                    decIGSTAmount := recSalesCrMemoHeader."IGST Amount";
                    decSGSTAmount := recSalesCrMemoHeader."SGST Amount";
                    decTCSAmount := recSalesCrMemoHeader."TCS Amount";
                    decInvoiceValue := decLineAmount - decDiscountAmount + decCGSTAmount + decSGSTAmount + decIGSTAmount + decTCSAmount;

                    decLineAmount := -decLineAmount;
                    decDiscountAmount := -decDiscountAmount;
                    decTaxableAmount := -decTaxableAmount;
                    decCGSTAmount := -decCGSTAmount;
                    decSGSTAmount := -decSGSTAmount;
                    decIGSTAmount := -decIGSTAmount;
                    decTCSAmount := -decTCSAmount;
                    decInvoiceValue := -decInvoiceValue;

                    if recSalesCrMemoHeader."Ship-to Code" = '' then
                        recShipToAddress.Init()
                    else
                        recShipToAddress.Get(recSalesCrMemoHeader."Sell-to Customer No.", recSalesCrMemoHeader."Ship-to Code");
                end;

                if recReportData."Currency Code" <> '' then
                    decCurrencyFactor := 1 / recReportData."Currency Factor"
                else
                    decCurrencyFactor := 1;

                decLineAmount := Round(decLineAmount * decCurrencyFactor, 0.01);
                decDiscountAmount := Round(decDiscountAmount * decCurrencyFactor, 0.01);
                decTaxableAmount := Round(decTaxableAmount * decCurrencyFactor, 0.01);
                decCGSTAmount := Round(decCGSTAmount * decCurrencyFactor, 0.01);
                decIGSTAmount := Round(decIGSTAmount * decCurrencyFactor, 0.01);
                decSGSTAmount := Round(decSGSTAmount * decCurrencyFactor, 0.01);
                decTCSAmount := Round(decTCSAmount * decCurrencyFactor, 0.01);
                decInvoiceValue := Round(decInvoiceValue * decCurrencyFactor, 0.01);

                if recReportData."Location GST Reg. No." <> '' then
                    cdLocationStateCode := CopyStr(recReportData."Location GST Reg. No.", 1, 2)
                else
                    cdLocationStateCode := '';

                if recReportData."Customer GST Reg. No." <> '' then
                    cdCustomerStateCode := CopyStr(recReportData."Customer GST Reg. No.", 1, 2)
                else
                    cdCustomerStateCode := '';

                if recReportData."Ship-to GST Reg. No." <> '' then
                    cdShipToStateCode := CopyStr(recReportData."Ship-to GST Reg. No.", 1, 2)
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
        recSalesInvoiceHeader: Record "Sales Invoice Header";
        recSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        recReportData: Record "Sales Invoice Header" temporary;
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
}