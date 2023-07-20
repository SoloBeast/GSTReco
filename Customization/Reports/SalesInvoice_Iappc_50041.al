report 50041 "Posted Sales Invoice"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Posted Sales Invoice';
    RDLCLayout = 'Customization\Reports\SalesInvoice_Iappc_50041.rdl';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");

            column(blnSampleInvoice; Format(blnSampleInvoice)) { }
            column(txtInvoiceType; txtInvoiceType) { }
            column(CompanyLogo; recCompanyInfo.Picture) { }
            column(CompanyName; recCompanyInfo.Name) { }
            column(FormalName; recCompanyInfo."Name 2") { }
            column(CompanyAddress; recLocation.Address) { }
            column(CompanyAddress1; recLocation."Address 2") { }
            column(CompanyCity; recLocation.City) { }
            column(CompanyPostCode; recLocation."Post Code") { }
            column(CompanyState; txtCompanyState) { }
            column(CompanyCountry; txtCompanyCountry) { }
            column(CompanyPhoneNo; recCompanyInfo."Phone No.") { }
            column(CompanyGST; "Sales Invoice Header"."Location GST Reg. No.") { }
            column(CompanyCIN; recCompanyInfo."C.I.N. No.") { }
            column(CompanyStateCode; cdCompanyStateCode) { }
            column(CompanyPAN; recCompanyInfo."P.A.N. No.") { }
            column(EInvoiceQRCode; "Sales Invoice Header"."QR Code") { }
            column(EInvoiceNo; txtEInvoiceNo) { }
            column(CustomerCode; "Sales Invoice Header"."Bill-to Customer No.") { }
            column(CustomerName; recCustomer.Name) { }
            column(CustomerAddress; recCustomer.Address) { }
            column(CustomerAddress1; recCustomer."Address 2") { }
            column(CustomerCity; recCustomer.City) { }
            column(CustomerPostCode; recCustomer."Post Code") { }
            column(CustomerState; txtCustomerState) { }
            column(CustomerCountry; txtCustomerCountry) { }
            column(CustomerPAN; recCustomer."P.A.N. No.") { }
            column(CustomerGST; "Sales Invoice Header"."Customer GST Reg. No.") { }
            column(CustomerStateCode; cdBillToStateCode) { }
            column(ShipToName; txtCustomerInfo[1]) { }
            column(ShipToAddress; txtCustomerInfo[2]) { }
            column(ShipToAddress1; txtCustomerInfo[3]) { }
            column(ShipToCity; txtCustomerInfo[4]) { }
            column(ShipToPostCode; txtCustomerInfo[5]) { }
            column(ShipToState; txtShipToState) { }
            column(ShipToCountry; txtShipToCountry) { }
            column(ShipToGST; txtCustomerInfo[6]) { }
            column(ShipToStateCode; cdShipToStateCode) { }
            column(InvoiceNo; "Sales Invoice Header"."No.") { }
            column(InvoiceDate; Format("Sales Invoice Header"."Posting Date")) { }
            column(DateTimePrepration; Format("Sales Invoice Header"."Posting Date") + ' ' + Format("Sales Invoice Header"."Time of Removal")) { }
            column(CustomerPONo; "Sales Invoice Header"."External Document No.") { }
            column(CustomerPODate; Format("Sales Invoice Header"."Document Date")) { }
            column(SONo; "Sales Invoice Header"."Order No.") { }
            column(SODate; Format("Sales Invoice Header"."Order Date")) { }
            column(PaymentDueDate; Format("Sales Invoice Header"."Due Date")) { }
            column(CreditTerm; recPaymentTerm.Description) { }
            column(EwayBillNo; "Sales Invoice Header"."E-Way Bill No.") { }
            column(RegOffAddress; txtRegisteredOfficeAddress) { }
            column(Term1; '') { }
            column(AmountInWords; txtAmountInWords[1] + ' ' + txtAmountInWords[2]) { }
            column(TransporterName; recShippingAgent.Name) { }
            column(VehicleNo; "Sales Invoice Header"."Vehicle No.") { }
            column(RemovalDateTime; Format("Sales Invoice Header"."Posting Date") + ' ' + Format("Sales Invoice Header"."Time of Removal")) { }
            column(TransportMode; "Sales Invoice Header"."Mode of Transport") { }
            column(FreightTerm; '') { }
            column(NetWeight; decNetWeight) { }
            column(RoundOff; decRoundOff) { }
            column(TCSAmount; 0) { }

            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(LoopNo; CopyLoop.Number) { }
                column(LoopName; txtLoopName) { }

                dataitem("Sales Invoice Line"; "Sales Invoice Line")
                {
                    DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) where("System-Created Entry" = const(false), Quantity = filter(<> 0));
                    DataItemLinkReference = "Sales Invoice Header";
                    DataItemLink = "Document No." = FIELD("No.");

                    column(LineNo; "Sales Invoice Line"."Line No.") { }
                    column(SrNo; intLineCounter) { }
                    column(PartNo; '') { }
                    column(LineDescription; "Sales Invoice Line".Description) { }
                    column(HSNCocde; "Sales Invoice Line"."HSN/SAC Code") { }
                    column(Packages; intPackages) { }
                    column(NoOfCases; "Sales Invoice Line".Quantity) { }
                    column(UOM; "Sales Invoice Line"."Unit of Measure Code") { }
                    column(UnitRate; "Sales Invoice Line"."Unit Price") { }
                    column(DiscountAmount; "Sales Invoice Line"."Line Discount Amount") { }
                    column(IGSTPerc; "Sales Invoice Line"."IGST %") { }
                    column(CGSTPerc; "Sales Invoice Line"."CGST %") { }
                    column(SGSTPerc; "Sales Invoice Line"."SGST %") { }
                    column(IGSTAmt; "Sales Invoice Line"."IGST Amount") { }
                    column(CGSTAmt; "Sales Invoice Line"."CGST Amount") { }
                    column(SGSTAmt; "Sales Invoice Line"."SGST Amount") { }
                    column(LineAmount; "Sales Invoice Line"."Line Amount") { }

                    trigger OnPreDataItem()
                    begin
                        intLineCounter := 0;
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        "Sales Invoice Line".CalcFields("IGST %", "CGST %", "SGST %", "IGST Amount", "SGST Amount", "CGST Amount");
                        intLineCounter += 1;

                        if not recItem.Get("Sales Invoice Line"."No.") then
                            recItem.Init();

                        intPackages := 0;
                    end;
                }
                dataitem(BlankLines; Integer)
                {
                    DataItemTableView = sorting(Number);

                    column(BlankLineNo; BlankLines.Number) { }

                    trigger OnAfterGetRecord()
                    begin
                        intLineCounter += 1;
                        if intLineCounter > intLineBreakCounter then
                            CurrReport.Break();
                    end;
                }


                trigger OnPreDataItem()
                begin
                    if opPrintCopyOption = 0 then
                        CopyLoop.SetRange(Number, 1, 3)
                    else
                        CopyLoop.SetRange(Number, 1);
                end;

                trigger OnAfterGetRecord()
                begin
                    if opPrintCopyOption = 0 then begin
                        if CopyLoop.Number = 1 then
                            txtLoopName := 'Original for Receipient';
                        if CopyLoop.Number = 2 then
                            txtLoopName := 'Duplicate for Transporter';
                        if CopyLoop.Number = 3 then
                            txtLoopName := 'Triplicate Copy';
                    end;
                    if opPrintCopyOption = 1 then
                        txtLoopName := 'Original for Receipient';
                    if opPrintCopyOption = 2 then
                        txtLoopName := 'Duplicate for Transporter';
                    if opPrintCopyOption = 3 then
                        txtLoopName := 'Triplicate Copy';
                end;
            }

            trigger OnPreDataItem()
            begin
                recCompanyInfo.Get();
                recCompanyInfo.CalcFields(Picture);
                recSalesSetup.Get();

                txtRegisteredOfficeAddress := recCompanyInfo.Address + ' ' + recCompanyInfo."Address 2" + ' ' +
                                                recCompanyInfo.City + ' ' + recCompanyInfo."Post Code";
                if recState.Get(recCompanyInfo."State Code") then
                    txtRegisteredOfficeAddress := txtRegisteredOfficeAddress + ' ' + recState.Description;
                if recCountry.Get(recCompanyInfo."Country/Region Code") then
                    txtRegisteredOfficeAddress := txtRegisteredOfficeAddress + ' ' + recCountry.Name;
            end;

            trigger OnAfterGetRecord()
            begin
                blnSampleInvoice := false;

                recLocation.Get("Sales Invoice Header"."Location Code");
                recCustomer.Get("Sales Invoice Header"."Bill-to Customer No.");
                "Sales Invoice Header".CalcFields("QR Code");

                if not recPaymentTerm.Get("Sales Invoice Header"."Payment Terms Code") then
                    recPaymentTerm.Init();

                if not recShippingAgent.Get("Sales Invoice Header"."Shipping Agent Code") then
                    recShippingAgent.Init();

                txtEInvoiceNo := 'IRN No. : ';
                if "Sales Invoice Header"."IRN Hash" <> '' then
                    txtEInvoiceNo := txtEInvoiceNo + "Sales Invoice Header"."IRN Hash" + '   Dated : ' + Format(DT2Date("Sales Invoice Header"."Acknowledgement Date"));

                txtCompanyState := '';
                txtCompanyCountry := '';
                cdCompanyStateCode := '';
                if recState.Get(recLocation."State Code") then begin
                    txtCompanyState := recState.Description;
                    cdCompanyStateCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get(recLocation."Country/Region Code") then
                    txtCompanyCountry := recCountry.Name;

                txtCustomerState := '';
                txtCustomerCountry := '';
                cdBillToStateCode := '';
                if recState.Get("Sales Invoice Header"."GST Bill-to State Code") then begin
                    txtCustomerState := recState.Description;
                    cdBillToStateCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get("Sales Invoice Header"."Bill-to Country/Region Code") then
                    txtCustomerCountry := recCountry.Name;

                Clear(txtCustomerInfo);
                if "Sales Invoice Header"."Ship-to Code" = '' then begin
                    txtCustomerInfo[1] := recCustomer.Name;
                    txtCustomerInfo[2] := recCustomer.Address;
                    txtCustomerInfo[3] := recCustomer."Address 2";
                    txtCustomerInfo[4] := recCustomer.City;
                    txtCustomerInfo[5] := recCustomer."Post Code";
                    txtCustomerInfo[6] := "Sales Invoice Header"."Customer GST Reg. No.";
                    txtShipToState := txtCustomerState;
                    txtShipToCountry := txtCustomerCountry;
                    cdShipToStateCode := cdBillToStateCode;
                end;
                if "Sales Invoice Header"."Ship-to Code" <> '' then begin
                    recShipToAddress.Get("Sales Invoice Header"."Sell-to Customer No.", "Sales Invoice Header"."Ship-to Code");
                    txtCustomerInfo[1] := recShipToAddress.Name;
                    txtCustomerInfo[2] := recShipToAddress.Address;
                    txtCustomerInfo[3] := recShipToAddress."Address 2";
                    txtCustomerInfo[4] := recShipToAddress.City;
                    txtCustomerInfo[5] := recShipToAddress."Post Code";
                    txtCustomerInfo[6] := "Sales Invoice Header"."Ship-to GST Reg. No.";

                    txtShipToState := '';
                    txtShipToCountry := '';
                    cdShipToStateCode := '';
                    if recState.Get("Sales Invoice Header"."GST Ship-to State Code") then begin
                        txtShipToState := recState.Description;
                        cdShipToStateCode := recState."State Code (GST Reg. No.)";
                    end;
                    if recCountry.Get("Sales Invoice Header"."Ship-to Country/Region Code") then
                        txtShipToCountry := recCountry.Name;
                end;

                decTotalInvoiceValue := 0;
                decRoundOff := 0;
                intLineCounter := 0;
                decNetWeight := 0;
                decTCSAmount := 0;
                recSalesInvoiceLine.Reset();
                recSalesInvoiceLine.SetRange("Document No.", "Sales Invoice Header"."No.");
                recSalesInvoiceLine.SetFilter(Quantity, '<>%1', 0);
                if recSalesInvoiceLine.FindFirst() then begin
                    if recSalesInvoiceLine.Count > 4 then
                        intLineBreakCounter := 6
                    else
                        intLineBreakCounter := 7;

                    repeat
                        recSalesInvoiceLine.CalcFields("NOC Wise TCS Amount", "NOC Wise TCS Base Amount");

                        if (recItem.Get(recSalesInvoiceLine."No.")) and (recItem."Net Weight" <> 0) then
                            decNetWeight += recSalesInvoiceLine.Quantity * recItem."Net Weight";

                        if recSalesInvoiceLine."System-Created Entry" then
                            decRoundOff += recSalesInvoiceLine."Line Amount"
                        else begin
                            recSalesInvoiceLine.CalcFields("CGST Amount", "SGST Amount", "IGST Amount");
                            decTotalInvoiceValue += recSalesInvoiceLine."Line Amount" + recSalesInvoiceLine."IGST Amount" +
                                                    recSalesInvoiceLine."CGST Amount" + recSalesInvoiceLine."SGST Amount";
                        end;

                        if recSalesInvoiceLine."NOC Wise TCS Base Amount" <> 0 then
                            decTCSAmount += Round(recSalesInvoiceLine."NOC Wise TCS Amount" / recSalesInvoiceLine."NOC Wise TCS Base Amount" * recSalesInvoiceLine."Line Amount", 0.01);
                    until recSalesInvoiceLine.Next() = 0;

                    cuProcess.InitTextVariable();
                    Clear(txtAmountInWords);
                    cuProcess.FormatNoText(txtAmountInWords, decTotalInvoiceValue, "Sales Invoice Header"."Currency Code");
                end;

                if "Sales Invoice Header"."Invoice Type" = "Sales Invoice Header"."Invoice Type"::"Debit Note" then
                    txtInvoiceType := 'Debit Note';
                if txtInvoiceType = '' then
                    txtInvoiceType := 'Tax Invoice';
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(FilterOptions)
                {
                    Caption = 'Options';
                    field(opPrintCopyOption; opPrintCopyOption)
                    {
                        Caption = 'Print Copy';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        txtLoopName: Text[30];
        recCustomer: Record Customer;
        recState: Record State;
        recCountry: Record "Country/Region";
        txtCustomerState: Text[50];
        txtCustomerCountry: Text[50];
        cdCompanyStateCode: Code[2];
        cdBillToStateCode: Code[2];
        recSalesInvoiceLine: Record "Sales Invoice Line";
        recSalesSetup: Record "Sales & Receivables Setup";
        recLocation: Record Location;
        txtCompanyState: Text[50];
        txtCompanyCountry: Text[50];
        intLineCounter: Integer;
        txtEInvoiceNo: Text;
        cuProcess: Codeunit "Process Flow";
        txtAmountInWords: array[2] of Text[80];
        decTotalInvoiceValue: Decimal;
        decRoundOff: Decimal;
        txtCustomerInfo: array[10] of Text[100];
        recShipToAddress: Record "Ship-to Address";
        txtShipToState: Text[50];
        txtShipToCountry: Text[50];
        cdShipToStateCode: Code[10];
        intLineBreakCounter: Integer;
        recPaymentTerm: Record "Payment Terms";
        txtRegisteredOfficeAddress: Text;
        recShippingAgent: Record "Shipping Agent";
        intPackages: Integer;
        recItem: Record Item;
        decNetWeight: Decimal;
        opPrintCopyOption: Option "All","Original","Duplicate","Triplicate";
        decTCSAmount: Decimal;
        txtInvoiceType: Text;
        blnSampleInvoice: Boolean;
}