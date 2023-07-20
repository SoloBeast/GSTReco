report 50020 "Sales Cr.Memo Portrait"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Sales Cr. Memo';
    RDLCLayout = 'Customization\Reports\SalesCrMemoPortrait_Iappc_50020.rdl';

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
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
            column(CustomerName; recCustomer.Name) { }
            column(CustomerAddress; recCustomer.Address) { }
            column(CustomerAddress1; recCustomer."Address 2") { }
            column(CustomerCity; recCustomer.City) { }
            column(CustomerPostCode; recCustomer."Post Code") { }
            column(CustomerState; txtCustomerState) { }
            column(CustomerStateGSTCode; txtCustomerStateGSTCode) { }
            column(CustomerCountry; txtCustomerCountry) { }
            column(CustomerPAN; recCustomer."P.A.N. No.") { }
            column(CustomerGST; "Sales Cr.Memo Header"."Customer GST Reg. No.") { }
            column(ShipToName; txtShipToAddress[1]) { }
            column(ShipToAddress; txtShipToAddress[2]) { }
            column(ShipToAddress1; txtShipToAddress[3]) { }
            column(ShipToCity; txtShipToAddress[4]) { }
            column(ShipToPostCode; txtShipToAddress[5]) { }
            column(ShipToState; txtShipToAddress[6]) { }
            column(ShipToCountry; txtShipToAddress[7]) { }
            column(ShipToGST; txtShipToAddress[8]) { }
            column(InvoiceNo; "Sales Cr.Memo Header"."No.") { }
            column(InvoiceDate; Format("Sales Cr.Memo Header"."Posting Date")) { }
            column(OrderNo; "Sales Cr.Memo Header"."Applies-to Doc. No.") { }
            column(RefInvoiceDate; Format(recSalesInvoiceHeader."Posting Date")) { }
            column(GRNo; '') { }
            column(GRDate; Format('')) { }
            column(Transporter; recShippingAgent.Name) { }
            column(VehicleNo; "Sales Cr.Memo Header"."Vehicle No.") { }
            column(PaymentTerm; recPaymentTerms.Description) { }
            column(RoundOffAmount; decRoundoffAmount) { }
            column(CurrencySymbol; txtCurrencySymbol) { }
            column(BankName; recCompanyInfo."Bank Name") { }
            column(BankAccountNo; recCompanyInfo."Bank Branch No.") { }
            column(IFSCCode; recCompanyInfo."IFSC Code") { }
            column(Declaration1; '1. Details given in the invoice are true and correct.') { }
            column(Declaration2; '2. All disputes subject to Delhji jurisdiction.') { }
            column(AmountInWords; txtAmountInWords[1] + txtAmountInWords[2]) { }

            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) where("System-Created Entry" = const(false), Quantity = filter(<> 0));
                DataItemLink = "Document No." = FIELD("No.");

                column(LineNo; "Sales Cr.Memo Line"."Line No.") { }
                column(SrNo; intSrNo) { }
                column(ItemDescription; "Sales Cr.Memo Line".Description) { }
                column(HSNSAC; "Sales Cr.Memo Line"."HSN/SAC Code") { }
                column(LineQuantity; "Sales Cr.Memo Line".Quantity) { }
                column(ItemUOM; "Sales Cr.Memo Line"."Unit of Measure Code") { }
                column(UnitPrice; "Sales Cr.Memo Line"."Unit Price") { }
                column(DiscountPerc; "Sales Cr.Memo Line"."Line Discount %") { }
                column(GSTPerc; "Sales Cr.Memo Line"."IGST %" + "Sales Cr.Memo Line"."CGST %" + "Sales Cr.Memo Line"."SGST %") { }
                column(GSTAmount; ABS("Sales Cr.Memo Line"."IGST Amount" + "Sales Cr.Memo Line"."CGST Amount" + "Sales Cr.Memo Line"."SGST Amount")) { }
                column(LineAmount; "Sales Cr.Memo Line"."Line Amount" + ABS("Sales Cr.Memo Line"."IGST Amount" + "Sales Cr.Memo Line"."SGST Amount" + "Sales Cr.Memo Line"."CGST Amount")) { }

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
                    "Sales Cr.Memo Line".CalcFields("GST Base Amount", "IGST %", "CGST %", "SGST %", "IGST Amount", "CGST Amount", "SGST Amount");

                    recGSTSummary.Reset();
                    recGSTSummary.SetRange("HSN/SAC Code", "Sales Cr.Memo Line"."HSN/SAC Code");
                    if recGSTSummary.FindFirst() then begin
                        recGSTSummary."GST Base Amount" += "Sales Cr.Memo Line"."GST Base Amount";
                        recGSTSummary."GST Amount" += "Sales Cr.Memo Line"."IGST Amount";
                        recGSTSummary."Custom Duty Amount (LCY)" += "Sales Cr.Memo Line"."CGST Amount";
                        recGSTSummary."Cess Amount Per Unit Factor" += "Sales Cr.Memo Line"."SGST Amount";
                        recGSTSummary.Modify();
                    end else begin
                        recGSTSummary.Init();
                        intEntryNo += 1;
                        recGSTSummary."Entry No." := intEntryNo;
                        recGSTSummary."HSN/SAC Code" := "Sales Cr.Memo Line"."HSN/SAC Code";
                        recGSTSummary."GST Base Amount" := "Sales Cr.Memo Line"."GST Base Amount";
                        recGSTSummary."GST %" := "Sales Cr.Memo Line"."IGST %";
                        recGSTSummary."GST Amount" := "Sales Cr.Memo Line"."IGST Amount";
                        recGSTSummary."Custom Duty Amount" := "Sales Cr.Memo Line"."CGST %";
                        recGSTSummary."Custom Duty Amount (LCY)" := "Sales Cr.Memo Line"."CGST Amount";
                        recGSTSummary."Cess Factor Quantity" := "Sales Cr.Memo Line"."SGST %";
                        recGSTSummary."Cess Amount Per Unit Factor" := "Sales Cr.Memo Line"."SGST Amount";
                        recGSTSummary.Insert();
                    end;
                end;
            }
            dataitem(GSTSummary; Integer)
            {
                DataItemTableView = sorting(Number) order(ascending);

                column(SummarySrNo; recGSTSummary."Entry No.") { }
                column(SummaryHSNSAC; recGSTSummary."HSN/SAC Code") { }
                column(TaxableValue; ABS(recGSTSummary."GST Base Amount")) { }
                column(IGSTPerc; recGSTSummary."GST %") { }
                column(IGSTAmount; ABS(recGSTSummary."GST Amount")) { }
                column(CGSTPerc; recGSTSummary."Custom Duty Amount") { }
                column(CGSTAmount; ABS(recGSTSummary."Custom Duty Amount (LCY)")) { }
                column(SGSTPerc; recGSTSummary."Cess Factor Quantity") { }
                column(SGSTAmount; ABS(recGSTSummary."Cess Amount Per Unit Factor")) { }

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
                recLocation.Get("Sales Cr.Memo Header"."Location Code");
                txtCompanyState := '';
                txtCompanyCountry := '';
                cdCompanyStateCode := '';
                if recState.Get(recLocation."State Code") then begin
                    txtCompanyState := recState.Description;
                    cdCompanyStateCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get(recLocation."Country/Region Code") then
                    txtCompanyCountry := recCountry.Name;

                recCustomer.Get("Sales Cr.Memo Header"."Bill-to Customer No.");
                txtCustomerCountry := '';
                txtCustomerState := '';
                if recState.Get("Sales Cr.Memo Header"."GST Bill-to State Code") then begin
                    txtCustomerState := recState.Description;
                    txtCustomerStateGSTCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get("Sales Cr.Memo Header"."Bill-to Country/Region Code") then
                    txtCustomerCountry := recCountry.Name;

                Clear(txtShipToAddress);
                if "Sales Cr.Memo Header"."Ship-to Code" = '' then begin
                    txtShipToAddress[1] := recCustomer.Name;
                    txtShipToAddress[2] := recCustomer.Address;
                    txtShipToAddress[3] := recCustomer."Address 2";
                    txtShipToAddress[4] := recCustomer.City;
                    txtShipToAddress[5] := recCustomer."Post Code";
                    txtShipToAddress[6] := txtCustomerState;
                    txtShipToAddress[7] := txtCustomerCountry;
                    txtShipToAddress[8] := "Sales Cr.Memo Header"."Customer GST Reg. No.";
                end;
                if "Sales Cr.Memo Header"."Ship-to Code" <> '' then begin
                    recShipToAddress.Get("Sales Cr.Memo Header"."Sell-to Customer No.", "Sales Cr.Memo Header"."Ship-to Code");
                    txtShipToAddress[1] := recShipToAddress.Name;
                    txtShipToAddress[2] := recShipToAddress.Address;
                    txtShipToAddress[3] := recShipToAddress."Address 2";
                    txtShipToAddress[4] := recShipToAddress.City;
                    txtShipToAddress[5] := recShipToAddress."Post Code";

                    if recState.Get("Sales Cr.Memo Header"."GST Ship-to State Code") then
                        txtShipToAddress[6] := recState.Description;
                    if recCountry.Get(recShipToAddress."Country/Region Code") then
                        txtShipToAddress[7] := recCountry.Name;
                    txtShipToAddress[8] := "Sales Cr.Memo Header"."Ship-to GST Reg. No.";
                end;

                if not recPaymentTerms.Get("Sales Cr.Memo Header"."Payment Terms Code") then
                    recPaymentTerms.Init();

                if not recShippingAgent.Get("Sales Cr.Memo Header"."Shipping Agent Code") then
                    recShippingAgent.Init();

                decTotalInvoiceValue := 0;
                decRoundoffAmount := 0;
                recSalesCrMemoLines.Reset();
                recSalesCrMemoLines.SetRange("Document No.", "Sales Cr.Memo Header"."No.");
                recSalesCrMemoLines.SetFilter(Quantity, '<>%1', 0);
                if recSalesCrMemoLines.FindFirst() then
                    repeat
                        recSalesCrMemoLines.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");

                        if recSalesCrMemoLines."System-Created Entry" then
                            decRoundoffAmount += recSalesCrMemoLines."Line Amount";
                        decTotalInvoiceValue += recSalesCrMemoLines."Line Amount" + recSalesCrMemoLines."IGST Amount" +
                                                recSalesCrMemoLines."CGST Amount" + recSalesCrMemoLines."SGST Amount";
                    until recSalesCrMemoLines.Next() = 0;

                cuProcess.InitTextVariable();
                Clear(txtAmountInWords);
                cuProcess.FormatNoText(txtAmountInWords, decTotalInvoiceValue, "Sales Cr.Memo Header"."Currency Code");

                if not recSalesInvoiceHeader.Get("Sales Cr.Memo Header"."Applies-to Doc. No.") then
                    recSalesInvoiceHeader.Init();

                if "Sales Cr.Memo Header"."Currency Code" = '' then
                    txtCurrencySymbol := 'Amount in ' + cuProcess.GetLocalCurrency()
                else
                    txtCurrencySymbol := 'Amount in ' + "Sales Cr.Memo Header"."Currency Code";
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
        txtCustomerState: Text[50];
        txtCustomerCountry: Text[50];
        cdCompanyStateCode: Code[2];
        recCustomer: Record Customer;
        recShipToAddress: Record "Ship-to Address";
        txtShipToAddress: array[10] of Text[100];
        recPaymentTerms: Record "Payment Terms";
        intSrNo: Integer;
        recGSTSummary: Record "Detailed GST Entry Buffer" temporary;
        intEntryNo: Integer;
        recSalesCrMemoLines: Record "Sales Cr.Memo Line";
        decTotalInvoiceValue: Decimal;
        decRoundoffAmount: Decimal;
        cuProcess: Codeunit "Process Flow";
        txtAmountInWords: array[2] of Text[80];
        recShippingAgent: Record "Shipping Agent";
        txtCurrencySymbol: Text[50];
        recSalesInvoiceHeader: Record "Sales Invoice Header";
        txtCustomerStateGSTCode: Text[20];
}