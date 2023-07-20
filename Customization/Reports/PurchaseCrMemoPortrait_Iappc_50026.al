report 50026 "Purchase Cr. Memo Portrait"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Purchase Credit Memo';
    RDLCLayout = 'Customization\Reports\PurchaseCrMemoPortrait_Iappc_50026.rdl';

    dataset
    {
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
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
            column(VendorName; recVendor.Name) { }
            column(VendorAddress; recVendor.Address) { }
            column(VendorAddress1; recVendor."Address 2") { }
            column(VendorCity; recVendor.City) { }
            column(VendorPostCode; recVendor."Post Code") { }
            column(VendorState; txtVendorState) { }
            column(VendorStateGSTCode; txtVendorStateGSTCode) { }
            column(VendorCountry; txtVendorCountry) { }
            column(VendorPAN; recVendor."P.A.N. No.") { }
            column(VendorGST; "Purch. Cr. Memo Hdr."."Vendor GST Reg. No.") { }
            column(ShipFromName; txtOrderAddress[1]) { }
            column(ShipFromAddress; txtOrderAddress[2]) { }
            column(ShipFromAddress1; txtOrderAddress[3]) { }
            column(ShipFromCity; txtOrderAddress[4]) { }
            column(ShipFromPostCode; txtOrderAddress[5]) { }
            column(ShipFromState; txtOrderAddress[6]) { }
            column(ShipFromCountry; txtOrderAddress[7]) { }
            column(ShipFromGST; txtOrderAddress[8]) { }
            column(InvoiceNo; "Purch. Cr. Memo Hdr."."No.") { }
            column(InvoiceDate; Format("Purch. Cr. Memo Hdr."."Posting Date")) { }
            column(OrderNo; '') { }
            column(VendorInvoiceNo; "Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.") { }
            column(VendorInvoiceDate; Format("Purch. Cr. Memo Hdr."."Document Date")) { }
            column(Transporter; recShippingAgent.Name) { }
            column(VehicleNo; "Purch. Cr. Memo Hdr."."Vehicle No.") { }
            column(PaymentTerm; recPaymentTerms.Description) { }
            column(RoundOffAmount; decRoundoffAmount) { }
            column(CurrencySymbol; txtCurrencySymbol) { }
            column(AmountInWords; txtAmountInWords[1] + txtAmountInWords[2]) { }
            column(PreparedBy; "Purch. Cr. Memo Hdr."."Created By") { }
            column(PostedBy; "Purch. Cr. Memo Hdr."."Posted By") { }
            column(TotalInvValue; decTotalInvoiceValue) { }//Hemant

            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) where("System-Created Entry" = const(false), Quantity = filter(<> 0));
                DataItemLink = "Document No." = FIELD("No.");

                column(LineNo; "Purch. Cr. Memo Line"."Line No.") { }
                column(SrNo; intSrNo) { }
                column(ItemDescription; "Purch. Cr. Memo Line".Description) { }
                column(HSNSAC; "Purch. Cr. Memo Line"."HSN/SAC Code") { }
                column(LineQuantity; "Purch. Cr. Memo Line".Quantity) { }
                column(ItemUOM; "Purch. Cr. Memo Line"."Unit of Measure Code") { }
                column(UnitCost; "Purch. Cr. Memo Line"."Direct Unit Cost") { }
                column(DiscountPerc; "Purch. Cr. Memo Line"."Line Discount %") { }
                column(GSTPerc; "Purch. Cr. Memo Line"."IGST %" + "Purch. Cr. Memo Line"."CGST %" + "Purch. Cr. Memo Line"."SGST %") { }
                column(GSTAmount; -("Purch. Cr. Memo Line"."IGST Amount" + "Purch. Cr. Memo Line"."CGST Amount" + "Purch. Cr. Memo Line"."SGST Amount")) { }
                column(LineAmount; "Purch. Cr. Memo Line"."Line Amount" - ("Purch. Cr. Memo Line"."IGST Amount" + "Purch. Cr. Memo Line"."SGST Amount" + "Purch. Cr. Memo Line"."CGST Amount")) { }

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
                    "Purch. Cr. Memo Line".CalcFields("GST Base Amount", "IGST %", "CGST %", "SGST %", "IGST Amount", "CGST Amount", "SGST Amount");

                    recGSTSummary.Reset();
                    recGSTSummary.SetRange("HSN/SAC Code", "Purch. Cr. Memo Line"."HSN/SAC Code");
                    if recGSTSummary.FindFirst() then begin
                        recGSTSummary."GST Base Amount" += -"Purch. Cr. Memo Line"."GST Base Amount";
                        recGSTSummary."GST Amount" += -"Purch. Cr. Memo Line"."IGST Amount";
                        recGSTSummary."Custom Duty Amount (LCY)" += -"Purch. Cr. Memo Line"."CGST Amount";
                        recGSTSummary."Cess Amount Per Unit Factor" += -"Purch. Cr. Memo Line"."SGST Amount";
                        recGSTSummary.Modify();
                    end else begin
                        recGSTSummary.Init();
                        intEntryNo += 1;
                        recGSTSummary."Entry No." := intEntryNo;
                        recGSTSummary."HSN/SAC Code" := "Purch. Cr. Memo Line"."HSN/SAC Code";
                        recGSTSummary."GST Base Amount" := -"Purch. Cr. Memo Line"."GST Base Amount";
                        recGSTSummary."GST %" := "Purch. Cr. Memo Line"."IGST %";
                        recGSTSummary."GST Amount" := -"Purch. Cr. Memo Line"."IGST Amount";
                        recGSTSummary."Custom Duty Amount" := "Purch. Cr. Memo Line"."CGST %";
                        recGSTSummary."Custom Duty Amount (LCY)" := -"Purch. Cr. Memo Line"."CGST Amount";
                        recGSTSummary."Cess Factor Quantity" := "Purch. Cr. Memo Line"."SGST %";
                        recGSTSummary."Cess Amount Per Unit Factor" := -"Purch. Cr. Memo Line"."SGST Amount";
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
                recLocation.Get("Purch. Cr. Memo Hdr."."Location Code");
                txtCompanyState := '';
                txtCompanyCountry := '';
                cdCompanyStateCode := '';
                if recState.Get(recLocation."State Code") then begin
                    txtCompanyState := recState.Description;
                    cdCompanyStateCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get(recLocation."Country/Region Code") then
                    txtCompanyCountry := recCountry.Name;

                recVendor.Get("Purch. Cr. Memo Hdr."."Buy-from Vendor No.");
                txtVendorCountry := '';
                txtVendorState := '';
                if recState.Get(recVendor."State Code") then begin
                    txtVendorState := recState.Description;
                    txtVendorStateGSTCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get(recVendor."Country/Region Code") then
                    txtVendorCountry := recCountry.Name;

                Clear(txtOrderAddress);
                if "Purch. Cr. Memo Hdr."."Order Address Code" = '' then begin
                    txtOrderAddress[1] := recVendor.Name;
                    txtOrderAddress[2] := recVendor.Address;
                    txtOrderAddress[3] := recVendor."Address 2";
                    txtOrderAddress[4] := recVendor.City;
                    txtOrderAddress[5] := recVendor."Post Code";
                    txtOrderAddress[6] := txtVendorState;
                    txtOrderAddress[7] := txtVendorCountry;
                    txtOrderAddress[8] := "Purch. Cr. Memo Hdr."."Vendor GST Reg. No.";
                end;
                if "Purch. Cr. Memo Hdr."."Order Address Code" <> '' then begin
                    recOrderAddress.Get("Purch. Cr. Memo Hdr."."Buy-from Vendor No.", "Purch. Cr. Memo Hdr."."Order Address Code");
                    txtOrderAddress[1] := recOrderAddress.Name;
                    txtOrderAddress[2] := recOrderAddress.Address;
                    txtOrderAddress[3] := recOrderAddress."Address 2";
                    txtOrderAddress[4] := recOrderAddress.City;
                    txtOrderAddress[5] := recOrderAddress."Post Code";

                    if recState.Get("Purch. Cr. Memo Hdr."."GST Order Address State") then
                        txtOrderAddress[6] := recState.Description;
                    if recCountry.Get(recOrderAddress."Country/Region Code") then
                        txtOrderAddress[7] := recCountry.Name;
                    txtOrderAddress[8] := "Purch. Cr. Memo Hdr."."Order Address GST Reg. No.";
                end;

                if not recPaymentTerms.Get("Purch. Cr. Memo Hdr."."Payment Terms Code") then
                    recPaymentTerms.Init();

                if not recShippingAgent.Get("Purch. Cr. Memo Hdr."."Shipping Agent Code") then
                    recShippingAgent.Init();

                decTotalInvoiceValue := 0;
                decRoundoffAmount := 0;
                recPurchaseInvoiceLines.Reset();
                recPurchaseInvoiceLines.SetRange("Document No.", "Purch. Cr. Memo Hdr."."No.");
                recPurchaseInvoiceLines.SetFilter(Quantity, '<>%1', 0);
                if recPurchaseInvoiceLines.FindFirst() then
                    repeat
                        recPurchaseInvoiceLines.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");

                        if recPurchaseInvoiceLines."System-Created Entry" then
                            decRoundoffAmount += recPurchaseInvoiceLines."Line Amount";
                        decTotalInvoiceValue += recPurchaseInvoiceLines."Line Amount" - (recPurchaseInvoiceLines."IGST Amount" +
                                                recPurchaseInvoiceLines."CGST Amount" + recPurchaseInvoiceLines."SGST Amount");
                    until recPurchaseInvoiceLines.Next() = 0;

                cuProcess.InitTextVariable();
                Clear(txtAmountInWords);
                cuProcess.FormatNoText(txtAmountInWords, decTotalInvoiceValue, "Purch. Cr. Memo Hdr."."Currency Code");

                if "Purch. Cr. Memo Hdr."."Currency Code" = '' then
                    txtCurrencySymbol := 'Amount in ' + cuProcess.GetLocalCurrency()
                else
                    txtCurrencySymbol := 'Amount in ' + "Purch. Cr. Memo Hdr."."Currency Code";
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
        txtVendorCountry: Text[50];
        cdCompanyStateCode: Code[2];
        recVendor: Record Vendor;
        recOrderAddress: Record "Order Address";
        txtOrderAddress: array[10] of Text[100];
        recPaymentTerms: Record "Payment Terms";
        intSrNo: Integer;
        recGSTSummary: Record "Detailed GST Entry Buffer" temporary;
        intEntryNo: Integer;
        recPurchaseInvoiceLines: Record "Purch. Cr. Memo Line";
        decTotalInvoiceValue: Decimal;
        decRoundoffAmount: Decimal;
        cuProcess: Codeunit "Process Flow";
        txtAmountInWords: array[2] of Text[80];
        recShippingAgent: Record "Shipping Agent";
        txtCurrencySymbol: Text[50];
        txtVendorStateGSTCode: Text[20];
}