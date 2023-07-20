report 50016 "Sales Invoice Portrait"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Sales Invoice';
    RDLCLayout = 'Customization\Reports\SalesInvoicePortrait_Iappc_50016.rdl';

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
            column(EInvoiceQRCode; "Sales Invoice Header"."QR Code") { }
            column(EInvoiceNo; txtEInvoiceNo) { }
            column(CompanyGST; recLocation."GST Registration No.") { }
            column(CompanyStateCode; cdCompanyStateCode + ' (' + txtCompanyState + ')') { }
            column(CustomerName; recCustomer.Name) { }
            column(CustomerAddress; recCustomer.Address) { }
            column(CustomerAddress1; recCustomer."Address 2") { }
            column(CustomerCity; recCustomer.City) { }
            column(CustomerPostCode; recCustomer."Post Code") { }
            column(CustomerState; txtCustomerState) { }
            column(CustomerStateGSTCode; txtStateGSTCode) { }
            column(CustomerCountry; txtCustomerCountry) { }
            column(CustomerPAN; recCustomer."P.A.N. No.") { }
            column(CustomerGST; "Sales Invoice Header"."Customer GST Reg. No.") { }
            column(CustomerEmail; recCustomer."E-Mail") { }
            column(CustomerPhone; recCustomer."Phone No.") { }
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
            column(OrderNo; "Sales Invoice Header"."External Document No.") { }
            column(DueDate; Format("Sales Invoice Header"."Due Date")) { }
            column(GRNo; "Sales Invoice Header"."LR/RR No.") { }
            column(GRDate; Format("Sales Invoice Header"."LR/RR Date")) { }
            column(Transporter; recShippingAgent.Name) { }
            column(VehicleNo; "Sales Invoice Header"."Vehicle No.") { }
            column(PaymentTerm; recPaymentTerms.Description) { }
            column(RoundOffAmount; decRoundoffAmount) { }
            column(CurrencySymbol; txtCurrencySymbol) { }
            column(BankName; txtBankDetails[1]) { }
            column(BankAccountNo; txtBankDetails[2]) { }
            column(BankAddress; txtBnkAddress) { }
            column(TCSAmount; decTCSAmount) { }
            column(IFSCCode; txtBankDetails[3]) { }
            column(Declaration1; '1. Details given in the invoice are true and correct.') { }
            column(Declaration2; '2. All disputes subject to ' + txtDeclaration2State + ' jurisdiction.') { }
            column(AmountInWords; txtAmountInWords[1] + txtAmountInWords[2]) { }
            column(GSTAmountInWords; txtGSTAmountInWords[1] + txtGSTAmountInWords[2]) { }
            column(CompaignName; '') { }
            column(RemitencInstruction; txtRemittenaceInstruction) { }
            column(HeaderComments; txtComments) { }
            column(AcknowledgementNo; txtAcknowledgementNo) { }

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
                    column(LineType; 'SALES') { }
                    column(SrNo; intSrNo) { }
                    column(ItemDescription; txtlineDescription) { }
                    column(HSNSAC; "Sales Invoice Line"."HSN/SAC Code") { }
                    column(LineQuantity; "Sales Invoice Line".Quantity) { }
                    column(ItemUOM; "Sales Invoice Line"."Unit of Measure") { }
                    column(UnitPrice; "Sales Invoice Line"."Unit Price") { }
                    column(DiscountPerc; "Sales Invoice Line"."Line Discount %") { }
                    column(GSTPerc; "Sales Invoice Line"."IGST %" + "Sales Invoice Line"."CGST %" + "Sales Invoice Line"."SGST %") { }
                    column(GSTAmount; "Sales Invoice Line"."IGST Amount" + "Sales Invoice Line"."CGST Amount" + "Sales Invoice Line"."SGST Amount") { }
                    column(LineAmount; "Sales Invoice Line"."Line Amount" + "Sales Invoice Line"."IGST Amount" + "Sales Invoice Line"."SGST Amount" + "Sales Invoice Line"."CGST Amount") { }

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

                        if "Sales Invoice Line".Narration = '' then
                            txtlineDescription := "Sales Invoice Line".Description
                        else
                            txtlineDescription := "Sales Invoice Line".Narration;

                        recGSTSummary.Reset();
                        recGSTSummary.SetRange("HSN/SAC Code", "Sales Invoice Line"."HSN/SAC Code");
                        if recGSTSummary.FindFirst() then begin
                            recGSTSummary."GST Base Amount" += "Sales Invoice Line"."GST Base Amount";
                            recGSTSummary."GST Amount" += "Sales Invoice Line"."IGST Amount";
                            recGSTSummary."Custom Duty Amount (LCY)" += "Sales Invoice Line"."CGST Amount";
                            recGSTSummary."Cess Amount Per Unit Factor" += "Sales Invoice Line"."SGST Amount";
                            recGSTSummary.Modify();
                        end else begin
                            recGSTSummary.Init();
                            intEntryNo += 1;
                            recGSTSummary."Entry No." := intEntryNo;
                            recGSTSummary."HSN/SAC Code" := "Sales Invoice Line"."HSN/SAC Code";
                            recGSTSummary."GST Base Amount" := "Sales Invoice Line"."GST Base Amount";
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
                    if opPrintCopyOption = 0 then
                        CopyLoop.SetRange(Number, 1, 3)
                    else
                        CopyLoop.SetRange(Number, 1);
                end;

                trigger OnAfterGetRecord()
                begin
                    if opPrintCopyOption = 0 then begin
                        if CopyLoop.Number = 1 then
                            txtLoopName := 'Original for Recipient';
                        if CopyLoop.Number = 2 then
                            txtLoopName := 'Duplicate for Transporter';
                        if CopyLoop.Number = 3 then
                            txtLoopName := 'Triplicate Copy';
                    end;
                    if opPrintCopyOption = 1 then
                        txtLoopName := 'Original for Recipient';
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
                    //Hemant
                    txtDeclaration2State := recState.Description;
                end;
                txtRemittenaceInstruction := 'To ensure that we correctly match your payment, always reference invoice numbers when making your payment. If paying for multiple' +
                                                ' invoices, send an email to ' + recLocation."E-Mail" + ' with your company name and total payment amount in the subject line, and list the' +
                                                ' invoice numbers and respective amounts in the email.Please send your payments only to the bank account listed below on this official invoice.';
                if recCountry.Get(recLocation."Country/Region Code") then
                    txtCompanyCountry := recCountry.Name;

                "Sales Invoice Header".CalcFields("QR Code");
                txtEInvoiceNo := '';
                if "Sales Invoice Header"."IRN Hash" <> '' then begin
                    txtEInvoiceNo := txtEInvoiceNo + "Sales Invoice Header"."IRN Hash";
                    txtAcknowledgementNo := txtAcknowledgementNo + "Sales Invoice Header"."Acknowledgement No." + '   Dated : ' + Format(DT2Date("Sales Invoice Header"."Acknowledgement Date"));
                end;

                recCustomer.Get("Sales Invoice Header"."Bill-to Customer No.");
                txtCustomerCountry := '';
                txtCustomerState := '';
                if recState.Get("Sales Invoice Header"."GST Bill-to State Code") then begin
                    txtCustomerState := recState.Description;
                    txtStateGSTCode := recState."State Code (GST Reg. No.)";
                end;
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

                decTCSAmount := 0;
                recTCSEntry.Reset();
                recTCSEntry.SetRange("Document No.", "Sales Invoice Header"."No.");
                if recTCSEntry.FindFirst() then
                    repeat
                        decTCSAmount += recTCSEntry."Total TCS Including SHE CESS";
                    until recTCSEntry.Next() = 0;
                decTCSAmount := Abs(decTCSAmount);

                decTotalInvoiceValue := 0;
                decRoundoffAmount := 0;
                decTotalGSTAmount := 0;
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
                        decTotalGSTAmount += recSalesInvoiceLines."IGST Amount" +
                                                recSalesInvoiceLines."CGST Amount" + recSalesInvoiceLines."SGST Amount";
                    until recSalesInvoiceLines.Next() = 0;
                decTotalInvoiceValue := decTotalInvoiceValue + decTCSAmount;

                cuProcess.InitTextVariable();
                Clear(txtAmountInWords);
                cuProcess.FormatNoText(txtAmountInWords, decTotalInvoiceValue, "Sales Invoice Header"."Currency Code");

                cuProcess.InitTextVariable();
                Clear(txtGSTAmountInWords);
                cuProcess.FormatNoText(txtGSTAmountInWords, decTotalGSTAmount, "Sales Invoice Header"."Currency Code");

                if "Sales Invoice Header"."Currency Code" = '' then
                    txtCurrencySymbol := 'Amount in ' + cuProcess.GetLocalCurrency()
                else
                    txtCurrencySymbol := 'Amount in ' + "Sales Invoice Header"."Currency Code";

                Clear(txtBankDetails);
                if recBankAccount.Get("Sales Invoice Header"."Company Bank Account Code") then begin
                    txtBankDetails[1] := recBankAccount.Name;
                    txtBankDetails[2] := recBankAccount."Bank Account No.";
                    txtBankDetails[3] := recBankAccount."IFSC Code";
                    txtBnkAddress := recBankAccount.Address;
                end else begin
                    txtBankDetails[1] := recCompanyInfo."Bank Name";
                    txtBankDetails[2] := recCompanyInfo."Bank Account No.";
                    txtBankDetails[3] := recCompanyInfo."IFSC Code";
                    txtBnkAddress := '';
                end;

                Clear(txtComments);
                intEntryNo := 0;
                recSalesComment.Reset();
                recSalesComment.SetRange("Document Type", recSalesComment."Document Type"::"Posted Invoice");
                recSalesComment.SetRange("No.", "Sales Invoice Header"."No.");
                recSalesComment.SetRange("Document Line No.", 0);
                if recSalesComment.FindFirst() then
                    repeat
                        intEntryNo += 1;
                        if intEntryNo < 4 then begin
                            if txtComments = '' then
                                txtComments := recSalesComment.Comment
                            else
                                txtComments := txtComments + ' ' + recSalesComment.Comment;
                        end;
                    until recSalesComment.Next() = 0;
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
                    field(opPrintCopyOption; opPrintCopyOption)
                    {
                        ApplicationArea = All;
                        Caption = 'Print Type';
                    }
                }
            }
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
        txtGSTAmountInWords: array[2] of Text[80];
        recShippingAgent: Record "Shipping Agent";
        txtCurrencySymbol: Text[50];
        opPrintCopyOption: Option "All","Original","Duplicate","Triplicate";
        txtLoopName: Text[30];
        decTCSAmount: Decimal;
        recTCSEntry: Record "TCS Entry";
        decGSTAmount: Decimal;
        decCurrencyFactor: Decimal;
        txtStateGSTCode: Text[50];
        txtEInvoiceNo: Text;
        txtRemittenaceInstruction: Text;
        decTotalGSTAmount: Decimal;
        recBankAccount: Record "Bank Account";
        txtBankDetails: array[3] of Text[50];
        txtComments: Text;
        recSalesComment: Record "Sales Comment Line";
        txtlineDescription: Text[100];
        txtDeclaration2State: Text;
        txtAcknowledgementNo: Text;
        txtBnkAddress: Text[100];
}