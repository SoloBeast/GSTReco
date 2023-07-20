report 50010 "Purchase Register"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\PurchaseRegister_Iappc_50010.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; 'Purchase Register for the Period Starting from ' + format(dtFromDate) + ' to ' + Format(dtToDate)) { }
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
            column(VendorNo; recReportData."Buy-from Vendor No.") { }
            column(VendorName; recReportData."Buy-from Vendor Name") { }
            column(VendorPostingGroup; recReportData."Vendor Posting Group") { }
            column(VendorGSTStatus; recReportData."GST Vendor Type") { }
            column(VendorGSTRegistrationNo; recReportData."Vendor GST Reg. No.") { }
            column(StateCode; cdVendorStateCode) { }
            column(VendorInvoiceNo; recReportData."Vendor Invoice No.") { }
            column(VendorInvoiceDate; recReportData."Document Date") { }
            column(ReverseCharge; Format(blnReverseCharge)) { }
            column(CurrencyCode; recReportData."Currency Code") { }
            column(CurrencyFactor; decCurrencyFactor) { }
            column(LineAmount; decLineAmount) { }
            column(DiscountAmount; decDiscountAmount) { }
            column(TaxableValue; decTaxableAmount) { }
            column(IGSTAmount; decIGSTAmount) { }
            column(CGSTAmount; decCGSTAmount) { }
            column(SGSTAmount; decSGSTAmount) { }
            column(OtherCharges; decOtherCharges) { }
            column(TDSAmount; decTDSAmount) { }
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
                recPurchaseInvHeader.Reset();
                recPurchaseInvHeader.SetRange("Posting Date", dtFromDate, dtToDate);
                if recPurchaseInvHeader.FindFirst() then begin
                    //txtFilters := recPurchaseInvHeader.GetFilters;
                    repeat
                        recReportData.Init();
                        recReportData.TransferFields(recPurchaseInvHeader);
                        recReportData.Insert();
                    until recPurchaseInvHeader.Next() = 0;
                end;

                recPurchaseCrMemoHeader.Reset();
                recPurchaseCrMemoHeader.SetRange("Posting Date", dtFromDate, dtToDate);
                if recPurchaseCrMemoHeader.FindFirst() then
                    repeat
                        recReportData.Init();
                        recReportData.TransferFields(recPurchaseCrMemoHeader);
                        recReportData.Insert();
                    until recPurchaseCrMemoHeader.Next() = 0;

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
                if recPurchaseInvHeader.Get(recReportData."No.") then begin
                    txtDocumentType := 'Invoice';
                    recPurchaseInvHeader.CalcFields("Total Line Amount", "Total Line Discount", "Total GST Base Amount");
                    recPurchaseInvHeader.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
                    recPurchaseInvHeader.CalcFields("TDS Amount", "Invoice Discount Amount");
                    recPurchaseInvHeader.CalcFields("GST Reverse Charged");

                    decLineAmount := recPurchaseInvHeader."Total Line Amount" + recPurchaseInvHeader."Total Line Discount";
                    decDiscountAmount := recPurchaseInvHeader."Total Line Discount" + recPurchaseInvHeader."Invoice Discount Amount";
                    decTaxableAmount := recPurchaseInvHeader."Total Line Amount" - recPurchaseInvHeader."Invoice Discount Amount";
                    decCGSTAmount := recPurchaseInvHeader."CGST Amount";
                    decIGSTAmount := recPurchaseInvHeader."IGST Amount";
                    decSGSTAmount := recPurchaseInvHeader."SGST Amount";
                    decTDSAmount := recPurchaseInvHeader."TDS Amount";
                    decInvoiceValue := decLineAmount - decDiscountAmount + decCGSTAmount + decSGSTAmount + decIGSTAmount - decTDSAmount;
                    blnReverseCharge := recPurchaseInvHeader."GST Reverse Charged";

                end else begin
                    recPurchaseCrMemoHeader.Get(recReportData."No.");
                    txtDocumentType := 'Credit Memo';

                    recPurchaseCrMemoHeader.CalcFields("Total Line Amount", "Total Line Discount", "Total GST Base Amount");
                    recPurchaseCrMemoHeader.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
                    recPurchaseCrMemoHeader.CalcFields("TDS Amount", "Invoice Discount Amount");
                    recPurchaseCrMemoHeader.CalcFields("GST Reverse Charged");

                    decLineAmount := recPurchaseCrMemoHeader."Total Line Amount" + recPurchaseCrMemoHeader."Total Line Discount";
                    decDiscountAmount := recPurchaseCrMemoHeader."Total Line Discount" + recPurchaseCrMemoHeader."Invoice Discount Amount";
                    decTaxableAmount := recPurchaseCrMemoHeader."Total Line Amount" - recPurchaseCrMemoHeader."Invoice Discount Amount";
                    decCGSTAmount := recPurchaseCrMemoHeader."CGST Amount";
                    decIGSTAmount := recPurchaseCrMemoHeader."IGST Amount";
                    decSGSTAmount := recPurchaseCrMemoHeader."SGST Amount";
                    decTDSAmount := recPurchaseCrMemoHeader."TDS Amount";
                    decInvoiceValue := decLineAmount - decDiscountAmount + decCGSTAmount + decSGSTAmount + decIGSTAmount - decTDSAmount;
                    blnReverseCharge := recPurchaseCrMemoHeader."GST Reverse Charged";

                    decLineAmount := -decLineAmount;
                    decDiscountAmount := -decDiscountAmount;
                    decTaxableAmount := -decTaxableAmount;
                    decCGSTAmount := -decCGSTAmount;
                    decSGSTAmount := -decSGSTAmount;
                    decIGSTAmount := -decIGSTAmount;
                    decTDSAmount := -decTDSAmount;
                    decInvoiceValue := -decInvoiceValue;
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
                decTDSAmount := Round(decTDSAmount * decCurrencyFactor, 0.01);
                decInvoiceValue := Round(decInvoiceValue * decCurrencyFactor, 0.01);

                if recReportData."Location GST Reg. No." <> '' then
                    cdLocationStateCode := CopyStr(recReportData."Location GST Reg. No.", 1, 2)
                else
                    cdLocationStateCode := '';

                if recReportData."Vendor GST Reg. No." <> '' then
                    cdVendorStateCode := CopyStr(recReportData."Vendor GST Reg. No.", 1, 2)
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
        recPurchaseInvHeader: Record "Purch. Inv. Header";
        recPurchaseCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        recReportData: Record "Purch. Inv. Header" temporary;
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
        blnReverseCharge: Boolean;
}