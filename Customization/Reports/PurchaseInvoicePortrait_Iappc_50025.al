report 50025 "Purchase Invoice Portrait"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Purchase Invoice';
    RDLCLayout = 'Customization\Reports\PurchaseInvoicePortrait_Iappc_50025.rdl';

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = SORTING("No.");

            column(CompanyName; recCompanyInfo.Name) { }
            column(CompanyLogo; recCompanyInfo.Picture) { }
            column(CompanyAddress; recLocation.Address) { }
            column(CompanyAddress1; recLocation."Address 2") { }
            column(CompanyCity; recLocation.City) { }
            column(CompanyPostCode; recLocation."Post Code") { }
            column(CompanyState; txtCompanyState) { }
            column(CompanyCountry; txtCompanyCountry) { }
            column(CompanyPhoneNo; recLocation."Phone No.") { }
            column(CompanyEmail; recLocation."E-Mail") { }
            column(CompanyCIN; recCompanyInfo."C.I.N. No.") { }
            column(CompanyPAN; recCompanyInfo."P.A.N. No.") { }
            column(CompanyGST; recLocation."GST Registration No.") { }
            column(CompanyStateCode; cdCompanyStateCode + ' (' + txtCompanyState + ')') { }
            column(VendorName; txtVendorDetail[1]) { }
            column(VendorAddress; txtVendorDetail[2]) { }
            column(VendorAddress1; txtVendorDetail[3]) { }
            column(VendorCity; txtVendorDetail[4]) { }
            column(VendorPostCode; txtVendorDetail[5]) { }
            column(VendorState; txtVendorDetail[6]) { }
            column(VendorCountry; txtVendorDetail[7]) { }
            column(VendorPAN; txtVendorDetail[8]) { }
            column(VendorGST; txtVendorDetail[9]) { }
            column(VendorGSTStateCode; txtVendorDetail[10]) { }

            column(ShipFromName; txtOrderAddress[1]) { }
            column(ShipFromAddress; txtOrderAddress[2]) { }
            column(ShipFromAddress1; txtOrderAddress[3]) { }
            column(ShipFromCity; txtOrderAddress[4]) { }
            column(ShipFromPostCode; txtOrderAddress[5]) { }
            column(ShipFromState; txtOrderAddress[6]) { }
            column(ShipFromCountry; txtOrderAddress[7]) { }
            column(ShipFromGST; txtOrderAddress[8]) { }
            column(InvoiceNo; "Purch. Inv. Header"."No.") { }
            column(InvoiceDate; Format("Purch. Inv. Header"."Posting Date")) { }
            column(OrderNo; "Purch. Inv. Header"."Order No.") { }
            column(VendorInvoiceNo; "Purch. Inv. Header"."Vendor Invoice No.") { }
            column(VendorInvoiceDate; Format("Purch. Inv. Header"."Document Date")) { }
            column(Transporter; recShippingAgent.Name) { }
            column(VehicleNo; "Purch. Inv. Header"."Vehicle No.") { }
            column(PaymentTerm; recPaymentTerms.Description) { }
            column(RoundOffAmount; decRoundoffAmount) { }
            column(CurrencySymbol; txtCurrencySymbol) { }
            column(AmountInWords; txtAmountInWords[1] + txtAmountInWords[2]) { }
            column(InvoiceType; txtInvoiceType) { }
            column(Created_By; "Purch. Inv. Header"."Created By") { }
            column(Posted_By; "Purch. Inv. Header"."Posted By") { }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) where("System-Created Entry" = const(false), Quantity = filter(<> 0));
                DataItemLink = "Document No." = FIELD("No.");

                column(LineNo; "Purch. Inv. Line"."Line No.") { }
                column(SrNo; intSrNo) { }
                column(ItemDescription; "Purch. Inv. Line".Description) { }
                column(HSNSAC; "Purch. Inv. Line"."HSN/SAC Code") { }
                column(LineQuantity; "Purch. Inv. Line".Quantity) { }
                column(ItemUOM; "Purch. Inv. Line"."Unit of Measure Code") { }
                column(UnitCost; "Purch. Inv. Line"."Direct Unit Cost") { }
                column(DiscountPerc; "Purch. Inv. Line"."Line Discount %") { }
                column(GSTPerc; "Purch. Inv. Line"."IGST %" + "Purch. Inv. Line"."CGST %" + "Purch. Inv. Line"."SGST %") { }
                column(GSTAmount; (("Purch. Inv. Line"."IGST Amount" + "Purch. Inv. Line"."CGST Amount" + "Purch. Inv. Line"."SGST Amount") / decCurrencyFactor) * decSignFactor) { }
                column(LineAmount; "Purch. Inv. Line"."Line Amount" + (("Purch. Inv. Line"."IGST Amount" + "Purch. Inv. Line"."CGST Amount" + "Purch. Inv. Line"."SGST Amount") / decCurrencyFactor) * decSignFactor) { }

                trigger OnPreDataItem()
                begin
                    intSrNo := 0;
                    recGSTSummary.Reset();
                    recGSTSummary.DeleteAll();
                    intEntryNo := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    intSrNo += 1;
                    "Purch. Inv. Line".CalcFields("GST Base Amount", "IGST %", "CGST %", "SGST %", "IGST Amount", "CGST Amount", "SGST Amount");

                    if "Purch. Inv. Line"."Line Amount" < 0 then
                        decSignFactor := -1
                    else
                        decSignFactor := 1;

                    recGSTSummary.Reset();
                    recGSTSummary.SetRange("HSN/SAC Code", "Purch. Inv. Line"."HSN/SAC Code");
                    if recGSTSummary.FindFirst() then begin
                        recGSTSummary."GST Base Amount" += "Purch. Inv. Line"."GST Base Amount" / decCurrencyFactor;
                        recGSTSummary."GST Amount" += ("Purch. Inv. Line"."IGST Amount" / decCurrencyFactor) * decSignFactor;
                        recGSTSummary."Custom Duty Amount (LCY)" += ("Purch. Inv. Line"."CGST Amount" / decCurrencyFactor) * decSignFactor;
                        recGSTSummary."Cess Amount Per Unit Factor" += ("Purch. Inv. Line"."SGST Amount" / decCurrencyFactor) * decSignFactor;
                        recGSTSummary.Modify();
                    end else begin
                        recGSTSummary.Init();
                        intEntryNo += 1;
                        recGSTSummary."Entry No." := intEntryNo;
                        recGSTSummary."HSN/SAC Code" := "Purch. Inv. Line"."HSN/SAC Code";
                        recGSTSummary."GST Base Amount" := "Purch. Inv. Line"."GST Base Amount" / decCurrencyFactor;
                        recGSTSummary."GST %" := "Purch. Inv. Line"."IGST %";
                        recGSTSummary."GST Amount" := ("Purch. Inv. Line"."IGST Amount" / decCurrencyFactor) * decSignFactor;
                        recGSTSummary."Custom Duty Amount" := "Purch. Inv. Line"."CGST %";
                        recGSTSummary."Custom Duty Amount (LCY)" := ("Purch. Inv. Line"."CGST Amount" / decCurrencyFactor) * decSignFactor;
                        recGSTSummary."Cess Factor Quantity" := "Purch. Inv. Line"."SGST %";
                        recGSTSummary."Cess Amount Per Unit Factor" := ("Purch. Inv. Line"."SGST Amount" / decCurrencyFactor) * decSignFactor;
                        recGSTSummary.Insert();
                    end;
                end;
            }
            dataitem(GSTSummary; Integer)
            {
                DataItemTableView = sorting(Number) order(ascending);

                column(SummarySrNo; recGSTSummary."Entry No.") { }
                column(SummaryHSNSAC; recGSTSummary."HSN/SAC Code") { }
                column(TaxableValue; recGSTSummary."GST Base Amount") { }
                column(IGSTPerc; recGSTSummary."GST %") { }
                column(IGSTAmount; recGSTSummary."GST Amount") { }
                column(CGSTPerc; recGSTSummary."Custom Duty Amount") { }
                column(CGSTAmount; recGSTSummary."Custom Duty Amount (LCY)") { }
                column(SGSTPerc; recGSTSummary."Cess Factor Quantity") { }
                column(SGSTAmount; recGSTSummary."Cess Amount Per Unit Factor") { }

                trigger OnPreDataItem()
                begin
                    recGSTSummary.Reset();
                    GSTSummary.SetRange(Number, 1, recGSTSummary.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    recGSTSummary.Get(GSTSummary.Number);
                end;
            }

            trigger OnPreDataItem()
            begin
                recCompanyInfo.Get();
                recCompanyInfo.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                recLocation.Get("Purch. Inv. Header"."Location Code");
                if "Purch. Inv. Header"."Currency Code" <> '' then
                    decCurrencyFactor := 1 / "Purch. Inv. Header"."Currency Factor"
                else
                    decCurrencyFactor := 1;

                txtCompanyState := '';
                txtCompanyCountry := '';
                cdCompanyStateCode := '';
                if recState.Get(recLocation."State Code") then begin
                    txtCompanyState := recState.Description;
                    cdCompanyStateCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get(recLocation."Country/Region Code") then
                    txtCompanyCountry := recCountry.Name;

                recVendor.Get("Purch. Inv. Header"."Buy-from Vendor No.");
                txtVendorCountry := '';
                txtVendorState := '';
                txtVendorStateCode := '';
                if recState.Get(recVendor."State Code") then begin
                    txtVendorState := recState.Description;
                    txtVendorStateCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get(recVendor."Country/Region Code") then
                    txtVendorCountry := recCountry.Name;

                Clear(txtOrderAddress);
                if "Purch. Inv. Header"."Order Address Code" = '' then begin
                    txtOrderAddress[1] := recVendor.Name;
                    txtOrderAddress[2] := recVendor.Address;
                    txtOrderAddress[3] := recVendor."Address 2";
                    txtOrderAddress[4] := recVendor.City;
                    txtOrderAddress[5] := recVendor."Post Code";
                    txtOrderAddress[6] := txtVendorState;
                    txtOrderAddress[7] := txtVendorCountry;
                    txtOrderAddress[8] := "Purch. Inv. Header"."Vendor GST Reg. No.";
                end;
                if "Purch. Inv. Header"."Order Address Code" <> '' then begin
                    recOrderAddress.Get("Purch. Inv. Header"."Buy-from Vendor No.", "Purch. Inv. Header"."Order Address Code");
                    txtOrderAddress[1] := recOrderAddress.Name;
                    txtOrderAddress[2] := recOrderAddress.Address;
                    txtOrderAddress[3] := recOrderAddress."Address 2";
                    txtOrderAddress[4] := recOrderAddress.City;
                    txtOrderAddress[5] := recOrderAddress."Post Code";

                    if recState.Get("Purch. Inv. Header"."GST Order Address State") then
                        txtOrderAddress[6] := recState.Description;
                    if recCountry.Get(recOrderAddress."Country/Region Code") then
                        txtOrderAddress[7] := recCountry.Name;
                    txtOrderAddress[8] := "Purch. Inv. Header"."Order Address GST Reg. No.";
                end;

                if not recPaymentTerms.Get("Purch. Inv. Header"."Payment Terms Code") then
                    recPaymentTerms.Init();

                if not recShippingAgent.Get("Purch. Inv. Header"."Shipping Agent Code") then
                    recShippingAgent.Init();

                decTotalInvoiceValue := 0;
                decRoundoffAmount := 0;
                blnRCMInvoice := false;
                recPurchaseInvoiceLines.Reset();
                recPurchaseInvoiceLines.SetRange("Document No.", "Purch. Inv. Header"."No.");
                recPurchaseInvoiceLines.SetFilter(Quantity, '<>%1', 0);
                if recPurchaseInvoiceLines.FindFirst() then begin
                    IF recGSTGroup.Get(recPurchaseInvoiceLines."GST Group Code") then begin
                        if recGSTGroup."Reverse Charge" then
                            blnRCMInvoice := true;
                    end;

                    repeat
                        recPurchaseInvoiceLines.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
                        if recPurchaseInvoiceLines."Line Amount" < 0 then
                            decSignFactor := -1
                        else
                            decSignFactor := 1;

                        if recPurchaseInvoiceLines."System-Created Entry" then
                            decRoundoffAmount += recPurchaseInvoiceLines."Line Amount";
                        decTotalInvoiceValue += recPurchaseInvoiceLines."Line Amount" + ((recPurchaseInvoiceLines."IGST Amount" +
                                                recPurchaseInvoiceLines."CGST Amount" + recPurchaseInvoiceLines."SGST Amount") / decCurrencyFactor) * decSignFactor;
                    until recPurchaseInvoiceLines.Next() = 0;
                end;

                cuProcess.InitTextVariable();
                Clear(txtAmountInWords);
                Clear(txtVendorDetail);
                cuProcess.FormatNoText(txtAmountInWords, Round(decTotalInvoiceValue, 0.01), "Purch. Inv. Header"."Currency Code");

                if not blnRCMInvoice then begin
                    txtInvoiceType := 'Original Purchase Invoice';
                    txtVendorDetail[1] := recVendor.Name;
                    txtVendorDetail[2] := recVendor.Address;
                    txtVendorDetail[3] := recVendor."Address 2";
                    txtVendorDetail[4] := recVendor.City;
                    txtVendorDetail[5] := recVendor."Post Code";
                    txtVendorDetail[6] := txtVendorState;
                    txtVendorDetail[7] := txtVendorCountry;
                    txtVendorDetail[8] := recVendor."P.A.N. No.";
                    txtVendorDetail[9] := "Purch. Inv. Header"."Vendor GST Reg. No.";
                    txtVendorDetail[10] := txtVendorStateCode;
                end else begin
                    txtInvoiceType := 'Self Invoice';
                    txtVendorDetail[1] := recCompanyInfo.Name;
                    txtVendorDetail[2] := recLocation.Address;
                    txtVendorDetail[3] := recLocation."Address 2";
                    txtVendorDetail[4] := recLocation.City;
                    txtVendorDetail[5] := recLocation."Post Code";
                    recState.Get(recLocation."State Code");
                    txtVendorDetail[6] := recState.Description;
                    txtVendorDetail[7] := recLocation."Country/Region Code";
                    txtVendorDetail[8] := recCompanyInfo."P.A.N. No.";
                    txtVendorDetail[9] := recLocation."GST Registration No.";

                    txtVendorDetail[10] := recState."State Code (GST Reg. No.)";
                end;

                if "Purch. Inv. Header"."Currency Code" = '' then
                    txtCurrencySymbol := 'Amount in ' + cuProcess.GetLocalCurrency()
                else
                    txtCurrencySymbol := 'Amount in ' + "Purch. Inv. Header"."Currency Code";
            end;
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        recLocation: Record Location;
        recState: Record State;
        recCountry: Record "Country/Region";
        txtCompanyState: Text[50];
        txtCompanyCountry: Text[50];
        txtVendorState: Text[50];
        txtVendorStateCode: Text;
        txtVendorCountry: Text[50];
        cdCompanyStateCode: Code[2];
        recVendor: Record Vendor;
        recOrderAddress: Record "Order Address";
        txtOrderAddress: array[10] of Text[100];
        recPaymentTerms: Record "Payment Terms";
        intSrNo: Integer;
        recGSTSummary: Record "Detailed GST Entry Buffer" temporary;
        intEntryNo: Integer;
        recPurchaseInvoiceLines: Record "Purch. Inv. Line";
        decTotalInvoiceValue: Decimal;
        decRoundoffAmount: Decimal;
        cuProcess: Codeunit "Process Flow";
        txtAmountInWords: array[2] of Text[80];
        recShippingAgent: Record "Shipping Agent";
        txtCurrencySymbol: Text[50];
        blnRCMInvoice: Boolean;
        txtInvoiceType: Text;
        recGSTGroup: Record "GST Group";
        txtVendorDetail: array[10] of Text[100];
        decCurrencyFactor: Decimal;
        decSignFactor: Decimal;
}