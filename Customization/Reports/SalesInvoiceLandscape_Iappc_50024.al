report 50024 "Sales Invoice LandScape"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Sales Invoice';
    RDLCLayout = 'Customization\Reports\SalesInvoiceLandScape_Iappc_50024.rdl';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
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
            column(CustomerCountry; txtCustomerCountry) { }
            column(CustomerPAN; recCustomer."P.A.N. No.") { }
            column(CustomerGST; "Sales Invoice Header"."Customer GST Reg. No.") { }
            column(ShipToName; txtShipToAddress[1]) { }
            column(ShipToAddress; txtShipToAddress[2]) { }
            column(ShipToAddress1; txtShipToAddress[3]) { }
            column(ShipToCity; txtShipToAddress[4]) { }
            column(ShipToPostCode; txtShipToAddress[5]) { }
            column(ShipToState; txtShipToAddress[6]) { }
            column(ShipToCountry; txtShipToAddress[7]) { }
            column(ShipToGST; txtShipToAddress[8]) { }
            column(InvoiceNo; "Sales Invoice Header"."No.") { }
            column(InvoiceDate; Format("Sales Invoice Header"."Posting Date")) { }
            column(OrderNo; "Sales Invoice Header"."Your Reference") { }
            column(GRNo; "Sales Invoice Header"."LR/RR No.") { }
            column(GRDate; Format("Sales Invoice Header"."LR/RR Date")) { }
            column(Transporter; recShippingAgent.Name) { }
            column(VehicleNo; "Sales Invoice Header"."Vehicle No.") { }
            column(PaymentTerm; recPaymentTerms.Description) { }
            column(RoundOffAmount; decRoundoffAmount) { }
            column(CurrencySymbol; txtCurrencySymbol) { }
            column(BankName; recCompanyInfo."Bank Name") { }
            column(BankAccountNo; recCompanyInfo."Bank Branch No.") { }
            column(IFSCCode; recCompanyInfo."IFSC Code") { }
            column(Declaration1; '1. Details given in the invoice are true and correct.') { }
            column(Declaration2; '2. All disputes subject to Delhji jurisdiction.') { }
            column(AmountInWords; txtAmountInWords[1] + txtAmountInWords[2]) { }
            column(EwayBillNo; 'E-Way Bill No') { }
            column(EwayBillDate; 'E-Way Bill Date') { }
            column(DueDate; "Sales Invoice Header"."Due Date") { }
            column(CustomerCode; "Sales Invoice Header"."Bill-to Customer No.") { }
            column(ModeOfDelivery; 'Mode Of Delivery') { }
            column(CustomerPoNo; "Sales Invoice Header"."External Document No.") { }
            column(DateOfSupply; "Sales Invoice Header"."Posting Date") { }
            column(Address; 'Address') { }
            column(SalesPersonCode; "Sales Invoice Header"."Salesperson Code") { }

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) where("System-Created Entry" = const(false), Quantity = filter(<> 0));
                DataItemLink = "Document No." = FIELD("No.");

                column(LineNo; "Sales Invoice Line"."Line No.") { }
                column(SrNo; intSrNo) { }
                column(ItemDescription; "Sales Invoice Line".Description) { }
                column(HSNSAC; "Sales Invoice Line"."HSN/SAC Code") { }
                column(LineQuantity; "Sales Invoice Line".Quantity) { }
                column(ItemUOM; "Sales Invoice Line"."Unit of Measure Code") { }
                column(UnitPrice; "Sales Invoice Line"."Unit Price") { }
                column(DiscountPerc; "Sales Invoice Line"."Line Discount %") { }
                column(GSTPerc; "Sales Invoice Line"."IGST %" + "Sales Invoice Line"."CGST %" + "Sales Invoice Line"."SGST %") { }
                column(GSTAmount; "Sales Invoice Line"."IGST Amount" + "Sales Invoice Line"."CGST Amount" + "Sales Invoice Line"."SGST Amount") { }
                column(LineAmount; "Sales Invoice Line"."Line Amount" + "Sales Invoice Line"."IGST Amount" + "Sales Invoice Line"."SGST Amount" + "Sales Invoice Line"."CGST Amount") { }
                column(LCGSTPer; "Sales Invoice Line"."CGST %") { }
                column(LCGSTAmt; "Sales Invoice Line"."CGST Amount") { }
                column(LSGSTPer; "Sales Invoice Line"."SGST %") { }
                column(LSGSTAmt; "Sales Invoice Line"."SGST Amount") { }
                column(LIGSTPer; "Sales Invoice Line"."IGST %") { }
                column(LIGSTAmt; "Sales Invoice Line"."IGST Amount") { }
                column(TaxableValueLinee; abs("Sales Invoice Line"."GST Base Amount")) { }

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
                    "Sales Invoice Line".CalcFields("GST Base Amount", "IGST %", "CGST %", "SGST %", "IGST Amount", "CGST Amount", "SGST Amount");

                    recGSTSummary.Reset();
                    recGSTSummary.SetRange("HSN/SAC Code", "Sales Invoice Line"."HSN/SAC Code");
                    if recGSTSummary.FindFirst() then begin
                        recGSTSummary."GST Base Amount" += abs("Sales Invoice Line"."GST Base Amount");
                        recGSTSummary."GST Amount" += "Sales Invoice Line"."IGST Amount";
                        recGSTSummary."Custom Duty Amount (LCY)" += "Sales Invoice Line"."CGST Amount";
                        recGSTSummary."Cess Amount Per Unit Factor" += "Sales Invoice Line"."SGST Amount";
                        recGSTSummary.Modify();
                    end else begin
                        recGSTSummary.Init();
                        intEntryNo += 1;
                        recGSTSummary."Entry No." := intEntryNo;
                        recGSTSummary."HSN/SAC Code" := "Sales Invoice Line"."HSN/SAC Code";
                        recGSTSummary."GST Base Amount" := abs("Sales Invoice Line"."GST Base Amount");
                        recGSTSummary."GST %" := "Sales Invoice Line"."IGST %";
                        recGSTSummary."GST Amount" := "Sales Invoice Line"."IGST Amount";
                        recGSTSummary."Custom Duty Amount" := "Sales Invoice Line"."CGST %";
                        recGSTSummary."Custom Duty Amount (LCY)" := "Sales Invoice Line"."CGST Amount";
                        recGSTSummary."Cess Factor Quantity" := "Sales Invoice Line"."SGST %";
                        recGSTSummary."Cess Amount Per Unit Factor" := "Sales Invoice Line"."SGST Amount";
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
                recLocation.Get("Sales Invoice Header"."Location Code");
                txtCompanyState := '';
                txtCompanyCountry := '';
                cdCompanyStateCode := '';
                if recState.Get(recLocation."State Code") then begin
                    txtCompanyState := recState.Description;
                    cdCompanyStateCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get(recLocation."Country/Region Code") then
                    txtCompanyCountry := recCountry.Name;

                recCustomer.Get("Sales Invoice Header"."Bill-to Customer No.");
                txtCustomerCountry := '';
                txtCustomerState := '';
                if recState.Get("Sales Invoice Header"."GST Bill-to State Code") then
                    txtCustomerState := recState.Description;
                if recCountry.Get("Sales Invoice Header"."Bill-to Country/Region Code") then
                    txtCustomerCountry := recCountry.Name;

                Clear(txtShipToAddress);
                if "Sales Invoice Header"."Ship-to Code" = '' then begin
                    txtShipToAddress[1] := recCustomer.Name;
                    txtShipToAddress[2] := recCustomer.Address;
                    txtShipToAddress[3] := recCustomer."Address 2";
                    txtShipToAddress[4] := recCustomer.City;
                    txtShipToAddress[5] := recCustomer."Post Code";
                    txtShipToAddress[6] := txtCustomerState;
                    txtShipToAddress[7] := txtCustomerCountry;
                    txtShipToAddress[8] := "Sales Invoice Header"."Customer GST Reg. No.";
                end;
                if "Sales Invoice Header"."Ship-to Code" <> '' then begin
                    recShipToAddress.Get("Sales Invoice Header"."Sell-to Customer No.", "Sales Invoice Header"."Ship-to Code");
                    txtShipToAddress[1] := recShipToAddress.Name;
                    txtShipToAddress[2] := recShipToAddress.Address;
                    txtShipToAddress[3] := recShipToAddress."Address 2";
                    txtShipToAddress[4] := recShipToAddress.City;
                    txtShipToAddress[5] := recShipToAddress."Post Code";

                    if recState.Get("Sales Invoice Header"."GST Ship-to State Code") then
                        txtShipToAddress[6] := recState.Description;
                    if recCountry.Get(recShipToAddress."Country/Region Code") then
                        txtShipToAddress[7] := recCountry.Name;
                    txtShipToAddress[8] := "Sales Invoice Header"."Ship-to GST Reg. No.";
                end;

                if not recPaymentTerms.Get("Sales Invoice Header"."Payment Terms Code") then
                    recPaymentTerms.Init();

                if not recShippingAgent.Get("Sales Invoice Header"."Shipping Agent Code") then
                    recShippingAgent.Init();

                decTotalInvoiceValue := 0;
                decRoundoffAmount := 0;
                recSalesInvoiceLines.Reset();
                recSalesInvoiceLines.SetRange("Document No.", "Sales Invoice Header"."No.");
                recSalesInvoiceLines.SetFilter(Quantity, '<>%1', 0);
                if recSalesInvoiceLines.FindFirst() then
                    repeat
                        recSalesInvoiceLines.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");

                        if recSalesInvoiceLines."System-Created Entry" then
                            decRoundoffAmount += recSalesInvoiceLines."Line Amount";
                        decTotalInvoiceValue += recSalesInvoiceLines."Line Amount" + recSalesInvoiceLines."IGST Amount" +
                                                recSalesInvoiceLines."CGST Amount" + recSalesInvoiceLines."SGST Amount";
                    until recSalesInvoiceLines.Next() = 0;

                cuProcess.InitTextVariable();
                Clear(txtAmountInWords);
                cuProcess.FormatNoText(txtAmountInWords, decTotalInvoiceValue, "Sales Invoice Header"."Currency Code");

                if "Sales Invoice Header"."Currency Code" = '' then
                    txtCurrencySymbol := 'Amount in ' + cuProcess.GetLocalCurrency()
                else
                    txtCurrencySymbol := 'Amount in ' + "Sales Invoice Header"."Currency Code";
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
        recSalesInvoiceLines: Record "Sales Invoice Line";
        decTotalInvoiceValue: Decimal;
        decRoundoffAmount: Decimal;
        cuProcess: Codeunit "Process Flow";
        txtAmountInWords: array[2] of Text[80];
        recShippingAgent: Record "Shipping Agent";
        txtCurrencySymbol: Text[50];
}