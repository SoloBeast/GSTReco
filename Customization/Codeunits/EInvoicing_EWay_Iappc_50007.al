codeunit 50007 "E-Invoicing / E-Way"
{
    Permissions = tabledata "Sales Invoice Header" = rm,
                    tabledata "Sales Cr.Memo Header" = rm;

    trigger OnRun()
    begin

    end;

    procedure ChangeEInvoiceStatus(var lrecSalesInvoiceHeader: Record "Sales Invoice Header")
    var
        recPostedSalesInvoices: Record "Sales Invoice Header";
    begin
        if not Confirm('Do you want to generate e-invoices for all selected invocies?', false) then
            exit;

        recPostedSalesInvoices.Reset();
        recPostedSalesInvoices.CopyFilters(lrecSalesInvoiceHeader);
        recPostedSalesInvoices.SetRange("E-Invoice Status", recPostedSalesInvoices."E-Invoice Status"::Error);
        if recPostedSalesInvoices.FindSet() then begin
            recPostedSalesInvoices.ModifyAll(recPostedSalesInvoices."E-Invoice Error", '');
            recPostedSalesInvoices.ModifyAll("E-Invoice Status", recPostedSalesInvoices."E-Invoice Status"::Open);
        end;


        Message('E-Invoice has been open for the selected invoices.');
    end;


    procedure GenerateEInvoiceSalesInvBulk(var lrecSalesInvoiceHeader: Record "Sales Invoice Header")
    var
        recPostedSalesInvoices: Record "Sales Invoice Header";
        recInvoiceToGenerate: Record "Sales Invoice Header";
        cuEInvoiceBulk: Codeunit "E-Invoice Bulk";
        recSalesInvHeader: Record "Sales Invoice Header";
    begin
        if not Confirm('Do you want to generate e-invoices for all selected invocies?', false) then
            exit;

        recPostedSalesInvoices.Reset();
        recPostedSalesInvoices.CopyFilters(lrecSalesInvoiceHeader);
        recPostedSalesInvoices.SetRange("E-Invoice Status", recPostedSalesInvoices."E-Invoice Status"::Open);
        if recPostedSalesInvoices.FindSet() then
            repeat
                if (recPostedSalesInvoices."Nature of Supply" <> recPostedSalesInvoices."Nature of Supply"::B2C) then begin
                    recInvoiceToGenerate.Reset();
                    recInvoiceToGenerate.SetRange("No.", recPostedSalesInvoices."No.");
                    recInvoiceToGenerate.FindFirst();
                    //GenerateEInvoiceSalesInvoiceClearTax(recInvoiceToGenerate);
                    Clear(cuEInvoiceBulk);
                    IF cuEInvoiceBulk.Run(recInvoiceToGenerate) then begin
                        recSalesInvHeader.Get(recInvoiceToGenerate."No.");
                        recSalesInvHeader."E-Invoice Error" := '';
                        recSalesInvHeader."E-Invoice Status" := recInvoiceToGenerate."E-Invoice Status"::Generated;
                        recSalesInvHeader.Modify();
                    end else begin
                        recSalesInvHeader.Get(recInvoiceToGenerate."No.");
                        recSalesInvHeader."E-Invoice Error" := CopyStr(GetLastErrorText(), 1, 250);
                        recSalesInvHeader."E-Invoice Status" := recSalesInvHeader."E-Invoice Status"::Error;
                        recSalesInvHeader.Modify();
                    end;
                    Commit();
                end;
            until recPostedSalesInvoices.Next() = 0;

        Message('E-Invoice has been generated for the selected invoices.');
    end;

    local procedure CallServiceClearTaxInvoice(ProjectName: Text; RequestUrl: Text; payload: Text; GSTIN: Text; Token: Text) ServiceResponse: Text
    var
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        contentHeaders: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        ResponseText: Text;

    begin
        RequestHeaders := Client.DefaultRequestHeaders();
        RequestContent.WriteFrom(payload);

        RequestContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        //contentHeaders.Add('gstin', '06AAFCD5862R017');
        contentHeaders.Add('gstin', GSTIN);
        //contentHeaders.Add('x-cleartax-auth-token', '1.c3a0b76e-4193-4857-9c7f-958f4214cf25_ea8626d412891c22863ac20f267c09250e6e28fbaf2a8b17847a4dfc29759423');
        contentHeaders.Add('x-cleartax-auth-token', Token);
        contentHeaders.Add('x-cleartax-product', 'E-Invoice');
        Client.Put(RequestURL, RequestContent, ResponseMessage);
        ResponseMessage.Content().ReadAs(ResponseText);
        exit(ResponseText);
    end;

    procedure GenerateEInvoiceSalesInvoiceClearTax(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        blnEinvoiceTesting: Boolean;
        txtAcessToken: Text;
        opInvoiceType: Option Registered,Export,SEZ;
        decCurrencyFactor: Decimal;
        recSalesInvoiceLines: Record "Sales Invoice Line";
        decTotalInvoiceAmount: Decimal;
        decTotalLineAmount: Decimal;
        decTotalDiscountAmount: Decimal;
        decTotalIGSTAmount: Decimal;
        decTotalCGSTAmount: Decimal;
        decTotalSGSTAmount: Decimal;
        decRoundOffAmount: Decimal;
        jsonInvoice: JsonObject;
        jsonInvoiceCT: JsonObject;
        jsonTranDetails: JsonObject;
        jsonDocumentDetails: JsonObject;
        jsonSellerDetails: JsonObject;
        recLocation: Record Location;
        recState: Record State;
        jsonBuyerDetails: JsonObject;
        recCustomer: Record Customer;
        jsonShipToDetails: JsonObject;
        recShipToAddress: Record "Ship-to Address";
        jsonExportDetails: JsonObject;
        jsonValueDetails: JsonObject;
        decFCYValue: Decimal;
        intEntryNo: Integer;
        jsonItemDetails: JsonObject;
        decTCSAmount: Decimal;
        jsonItemList: JsonArray;
        txtJsonText: Text;
        recSalesSetup: Record "Sales & Receivables Setup";
        cuJsonManagement: Codeunit "JSON Management";
        cuQRCodeGenerator: Codeunit "QR Generator";
        cuTempBlob: Codeunit "Temp Blob";
        FieldRef: FieldRef;
        RecRef: RecordRef;
        dtAckDate: Date;
        dtAckTime: Time;
        recSalesInvHeader: Record "Sales Invoice Header";
        recGSTGroup: Record "GST Group";
        recItem: Record Item;
        recGLAccount: Record "G/L Account";
        jsonInvoiceList: JsonArray;
        jToken: JsonToken;
        txtErrorMsg: Text;
    begin
        CheckEInvoiceGenerationPermission();

        SalesInvoiceHeader.TestField("E-Invoice Status", SalesInvoiceHeader."E-Invoice Status"::Open);
        recCustomer.Get(SalesInvoiceHeader."Bill-to Customer No.");
        if SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Registered then
            opInvoiceType := opInvoiceType::Registered;
        if SalesInvoiceHeader."GST Customer Type" in [SalesInvoiceHeader."GST Customer Type"::Export] then
            opInvoiceType := opInvoiceType::Export;
        If (SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::" ") AND (recCustomer."Country/Region Code" <> 'IN') then
            opInvoiceType := opInvoiceType::Export;
        if SalesInvoiceHeader."GST Customer Type" in [SalesInvoiceHeader."GST Customer Type"::"SEZ Unit", SalesInvoiceHeader."GST Customer Type"::"SEZ Development"] then
            opInvoiceType := opInvoiceType::SEZ;

        if SalesInvoiceHeader."Currency Code" <> '' then
            decCurrencyFactor := 1 / SalesInvoiceHeader."Currency Factor"
        else
            decCurrencyFactor := 1;

        SalesInvoiceHeader.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
        if opInvoiceType = opInvoiceType::Registered then begin
            SalesInvoiceHeader.TestField("Customer GST Reg. No.");
            if SalesInvoiceHeader."IGST Amount" + SalesInvoiceHeader."CGST Amount" + SalesInvoiceHeader."SGST Amount" = 0 then
                Error('GST Amount must not be zero.');
        end;

        SalesInvoiceHeader.CalcFields("Total Line Amount", "Total Line Discount");
        decTotalLineAmount := Round(SalesInvoiceHeader."Total Line Amount" * decCurrencyFactor, 0.01);
        decTotalDiscountAmount := Round(SalesInvoiceHeader."Total Line Discount" * decCurrencyFactor, 0.01);
        decTotalIGSTAmount := Round(SalesInvoiceHeader."IGST Amount" * decCurrencyFactor, 0.01);
        decTotalCGSTAmount := Round(SalesInvoiceHeader."CGST Amount" * decCurrencyFactor, 0.01);
        decTotalSGSTAmount := Round(SalesInvoiceHeader."SGST Amount" * decCurrencyFactor, 0.01);
        decTotalInvoiceAmount := decTotalLineAmount + decTotalIGSTAmount + decTotalSGSTAmount + decTotalCGSTAmount;
        decFCYValue := SalesInvoiceHeader."Total Line Amount" + SalesInvoiceHeader."IGST Amount" +
                                                    SalesInvoiceHeader."SGST Amount" + SalesInvoiceHeader."CGST Amount";

        decRoundOffAmount := 0;
        recSalesInvoiceLines.Reset();
        recSalesInvoiceLines.SetRange("Document No.", SalesInvoiceHeader."No.");
        recSalesInvoiceLines.SetRange("System-Created Entry", true);
        if recSalesInvoiceLines.FindSet() then begin
            decRoundOffAmount := Round(recSalesInvoiceLines."Line Amount" * decCurrencyFactor, 0.01);
            decFCYValue += recSalesInvoiceLines."Line Amount";
        end;

        recSalesSetup.Get();
        recSalesSetup.TestField("E-Invoice Generation API");
        blnEinvoiceTesting := false;
        if StrPos(UpperCase(recSalesSetup."E-Invoice Generation API"), 'SANDBOX') <> 0 then
            blnEinvoiceTesting := true;

        recLocation.Get(SalesInvoiceHeader."Location Code");
        recState.Get(recLocation."State Code");

        //Start Json Creation
        jsonInvoice.Add('Version', '1.1');

        //Transaction Details
        jsonTranDetails.Add('TaxSch', 'GST');
        if opInvoiceType = opInvoiceType::Registered then
            jsonTranDetails.Add('SupTyp', 'B2B');
        if (opInvoiceType = opInvoiceType::Export) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount <> 0) then
            jsonTranDetails.Add('SupTyp', 'EXPWP');
        if (opInvoiceType = opInvoiceType::Export) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount = 0) then
            jsonTranDetails.Add('SupTyp', 'EXPWOP');
        if (opInvoiceType = opInvoiceType::SEZ) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount <> 0) then
            jsonTranDetails.Add('SupTyp', 'SEZWP');
        if (opInvoiceType = opInvoiceType::SEZ) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount = 0) then
            jsonTranDetails.Add('SupTyp', 'SEZWOP');

        //jsonTranDetails.Add('RegRev', 'Y');
        //jsonTranDetails.Add('IgstOnIntra', 'N');
        jsonInvoice.Add('TranDtls', jsonTranDetails);

        //Document Details
        if SalesInvoiceHeader."Invoice Type" = SalesInvoiceHeader."Invoice Type"::"Debit Note" then
            jsonDocumentDetails.Add('Typ', 'DBN')
        else
            jsonDocumentDetails.Add('Typ', 'INV');
        jsonDocumentDetails.Add('No', SalesInvoiceheader."No.");

        if blnEinvoiceTesting then
            jsonDocumentDetails.Add('Dt', ConvertDate(Today))
        else
            jsonDocumentDetails.Add('Dt', ConvertDate(SalesInvoiceheader."Posting Date"));

        jsonInvoice.Add('DocDtls', jsonDocumentDetails);

        //Seller Details
        if blnEinvoiceTesting then begin
            jsonSellerDetails.Add('Gstin', '06AAFCD5862R017');
            jsonSellerDetails.Add('LglNm', recLocation.Name);
            jsonSellerDetails.Add('TrdNm', recLocation.Name);
            jsonSellerDetails.Add('Addr1', recLocation.Address);
            jsonSellerDetails.Add('Addr2', recLocation."Address 2");
            jsonSellerDetails.Add('Loc', 'GANDHINAGAR');
            jsonSellerDetails.Add('Pin', '121005');
            jsonSellerDetails.Add('Stcd', '06');
        end else begin
            jsonSellerDetails.Add('Gstin', recLocation."GST Registration No.");
            jsonSellerDetails.Add('LglNm', recLocation.Name);
            jsonSellerDetails.Add('TrdNm', recLocation.Name);
            jsonSellerDetails.Add('Addr1', recLocation.Address);
            jsonSellerDetails.Add('Addr2', recLocation."Address 2");
            jsonSellerDetails.Add('Loc', recLocation.City);
            jsonSellerDetails.Add('Pin', recLocation."Post Code");
            jsonSellerDetails.Add('Stcd', recState."State Code (GST Reg. No.)");
        end;
        jsonInvoice.Add('SellerDtls', jsonSellerDetails);

        //Buyer Details
        if blnEinvoiceTesting then begin
            jsonBuyerDetails.Add('Gstin', '07AAFCD5862R007');
            jsonBuyerDetails.Add('LglNm', 'XYZ company pvt ltd');
            jsonBuyerDetails.Add('TrdNm', 'XYZ Industries');
            jsonBuyerDetails.Add('Addr1', '7th block, kuvempu layout');
            jsonBuyerDetails.Add('Addr2', 'kuvempu layout');
            jsonBuyerDetails.Add('Loc', 'Delhi');
            jsonBuyerDetails.Add('Pin', '110091');
            jsonBuyerDetails.Add('Pos', '07');
            jsonBuyerDetails.Add('Stcd', '07');
        end else begin

            IF opInvoiceType = opInvoiceType::Export THEN
                jsonBuyerDetails.Add('Gstin', 'URP')
            ELSE
                jsonBuyerDetails.Add('Gstin', SalesInvoiceHeader."Customer GST Reg. No.");
            jsonBuyerDetails.Add('LglNm', recCustomer.Name);
            jsonBuyerDetails.Add('TrdNm', recCustomer.Name);
            jsonBuyerDetails.Add('Addr1', recCustomer.Address);
            jsonBuyerDetails.Add('Addr2', recCustomer."Address 2");
            jsonBuyerDetails.Add('Loc', recCustomer.City);


            IF opInvoiceType = opInvoiceType::Export THEN begin
                jsonBuyerDetails.Add('Pin', '999999');
                jsonBuyerDetails.Add('Pos', '96');
                jsonBuyerDetails.Add('Stcd', '96');
            end;
            IF opInvoiceType = opInvoiceType::SEZ THEN begin
                recState.Get(SalesInvoiceHeader."GST Bill-to State Code");
                jsonBuyerDetails.Add('Pin', recCustomer."Post Code");
                jsonBuyerDetails.Add('Pos', '96');
                jsonBuyerDetails.Add('Stcd', recState."State Code (GST Reg. No.)");
            end;
            IF opInvoiceType = opInvoiceType::Registered THEN begin
                recState.Get(SalesInvoiceHeader."GST Bill-to State Code");
                jsonBuyerDetails.Add('Pin', recCustomer."Post Code");
                jsonBuyerDetails.Add('Pos', recState."State Code (GST Reg. No.)");
                jsonBuyerDetails.Add('Stcd', recState."State Code (GST Reg. No.)");
            end;
        end;
        jsonInvoice.Add('BuyerDtls', jsonBuyerDetails);

        //Ship to Details
        IF SalesInvoiceheader."Ship-to Code" <> '' THEN BEGIN
            recShipToAddress.GET(SalesInvoiceheader."Sell-to Customer No.", SalesInvoiceheader."Ship-to Code");

            jsonShipToDetails.Add('Gstin', recShipToAddress."GST Registration No.");
            jsonShipToDetails.Add('LglNm', recShipToAddress.Name);
            jsonShipToDetails.Add('TrdNm', recShipToAddress.Name);
            jsonShipToDetails.Add('Addr1', recShipToAddress.Address);
            jsonShipToDetails.Add('Addr2', recShipToAddress."Address 2");
            jsonShipToDetails.Add('Loc', recShipToAddress.City);
            jsonShipToDetails.Add('Pin', recShipToAddress."Post Code");

            IF not (opInvoiceType = opInvoiceType::Export) THEN begin
                recState.GET(recShipToAddress.State);
                jsonShipToDetails.Add('state_code', recState."State Code (GST Reg. No.)");
                jsonInvoice.Add('Stcd', jsonShipToDetails);
            END;
        end;

        //Item Details
        intEntryNo := 0;
        recSalesInvoiceLines.RESET;
        recSalesInvoiceLines.SETRANGE("Document No.", SalesInvoiceheader."No.");
        recSalesInvoiceLines.SetRange("System-Created Entry", false);
        recSalesInvoiceLines.SETFILTER(Quantity, '<>%1', 0);
        IF recSalesInvoiceLines.FindSet() THEN BEGIN
            REPEAT
                recSalesInvoiceLines.CalcFields("NOC Wise TCS Amount", "NOC Wise TCS Base Amount");
                recSalesInvoiceLines.CalcFields("IGST %", "CGST %", "SGST %");
                recSalesInvoiceLines.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");

                Clear(jsonItemDetails);
                intEntryNo += 1;
                jsonItemDetails.Add('SlNo', intEntryNo);

                if recSalesInvoiceLines.Type = recSalesInvoiceLines.Type::Item then begin
                    recItem.Get(recSalesInvoiceLines."No.");
                    jsonItemDetails.Add('PrdDesc', recItem.Description);
                end else
                    if recSalesInvoiceLines.Type = recSalesInvoiceLines.Type::"G/L Account" then begin
                        recGLAccount.Get(recSalesInvoiceLines."No.");
                        jsonItemDetails.Add('PrdDesc', recGLAccount.Name);
                    end else
                        jsonItemDetails.Add('PrdDesc', recSalesInvoiceLines.Description);

                if blnEinvoiceTesting then
                    jsonItemDetails.Add('IsServc', 'Y')
                else begin
                    recGSTGroup.Get(recSalesInvoiceLines."GST Group Code");
                    if recGSTGroup."GST Group Type" = recGSTGroup."GST Group Type"::Goods then
                        jsonItemDetails.Add('IsServc', 'N')
                    else
                        jsonItemDetails.Add('IsServc', 'Y');

                end;
                if blnEinvoiceTesting then
                    jsonItemDetails.Add('HsnCd', '996601')//'300420'
                else
                    jsonItemDetails.Add('HsnCd', recSalesInvoiceLines."HSN/SAC Code");
                jsonItemDetails.Add('Barcde', recSalesInvoiceLines."No.");
                jsonItemDetails.Add('Qty', Round(recSalesInvoiceLines.Quantity, 0.001));
                jsonItemDetails.Add('FreeQty', 0);


                if recSalesInvoiceLines."Unit of Measure Code" = '' then
                    jsonItemDetails.Add('Unit', 'OTH')
                else
                    jsonItemDetails.Add('Unit', recSalesInvoiceLines."Unit of Measure Code");

                jsonItemDetails.Add('UnitPrice', Round(recSalesInvoiceLines."Unit Price" * decCurrencyFactor, 0.001));
                jsonItemDetails.Add('TotAmt', Round((recSalesInvoiceLines."Unit Price" * recSalesInvoiceLines.Quantity) * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('Discount', Round(recSalesInvoiceLines."Line Discount Amount" * decCurrencyFactor, 0.01));
                //PreTaxVal
                if recSalesInvoiceLines."NOC Wise TCS Base Amount" <> 0 then
                    decTCSAmount := Round(recSalesInvoiceLines."NOC Wise TCS Amount" / recSalesInvoiceLines."NOC Wise TCS Base Amount" * recSalesInvoiceLines."Line Amount", 0.01);
                jsonItemDetails.Add('OthChrg', Round(decTCSAmount * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('AssAmt', Round(recSalesInvoiceLines."Line Amount" * decCurrencyFactor, 0.01));

                jsonItemDetails.Add('GstRt', recSalesInvoiceLines."IGST %" + recSalesInvoiceLines."SGST %" + recSalesInvoiceLines."CGST %");
                jsonItemDetails.Add('IgstAmt', Round(recSalesInvoiceLines."IGST Amount" * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('CgstAmt', Round(recSalesInvoiceLines."CGST Amount" * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('SgstAmt', Round(recSalesInvoiceLines."SGST Amount" * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('CesRt', 0);
                jsonItemDetails.Add('CesAmt', 0);
                jsonItemDetails.Add('CesNonAdvlAmt', 0);
                jsonItemDetails.Add('StateCesRt', 0);
                jsonItemDetails.Add('StateCesAmt', 0);
                jsonItemDetails.Add('StateCesNonAdvlAmt', 0);
                jsonItemDetails.Add('TotItemVal', Round((recSalesInvoiceLines."Line Amount" + recSalesInvoiceLines."IGST Amount" +
                                                                    recSalesInvoiceLines."CGST Amount" + recSalesInvoiceLines."SGST Amount") * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('OrdLineRef', recSalesInvoiceLines."Line No.");
                //OrgCntry
                jsonItemDetails.Add('PrdSlNo', recSalesInvoiceLines."Line No.");

                jsonItemList.Add(jsonItemDetails);
            UNTIL recSalesInvoiceLines.NEXT = 0;
            jsonInvoice.Add('ItemList', jsonItemList);
        end;

        //Value Details
        jsonValueDetails.Add('AssVal', decTotalLineAmount);
        jsonValueDetails.Add('CgstVal', decTotalCGSTAmount);
        jsonValueDetails.Add('SgstVal', decTotalSGSTAmount);
        jsonValueDetails.Add('IgstVal', decTotalIGSTAmount);
        jsonValueDetails.Add('CesVal', 0);
        jsonValueDetails.Add('StCesVal', 0);
        jsonValueDetails.Add('RndOffAmt', decRoundOffAmount);
        jsonValueDetails.Add('Discount', 0);
        jsonValueDetails.Add('OthChrg', 0);
        jsonValueDetails.Add('TotInvVal', decTotalInvoiceAmount + decRoundOffAmount);
        jsonValueDetails.Add('TotInvValFc', decTotalInvoiceAmount);
        jsonInvoice.Add('ValDtls', jsonValueDetails);

        //Export Details
        IF opInvoiceType = opInvoiceType::Export THEN BEGIN
            jsonExportDetails.Add('ShipBNo', '');
            jsonExportDetails.Add('ShipBDt', '');
            jsonExportDetails.Add('CntCode', recCustomer."Country/Region Code");
            jsonExportDetails.Add('ForCur', SalesInvoiceheader."Currency Code");
            jsonExportDetails.Add('RefClm', '');
            jsonExportDetails.Add('Port', '');
            jsonInvoice.Add('ExpDtls', jsonExportDetails);
        END;

        jsonInvoiceCT.Add('transaction', jsonInvoice);
        jsonInvoiceList.Add(jsonInvoiceCT);
        jsonInvoiceList.WriteTo(txtJsonText);
        if recSalesSetup."Show Json" then
            Message(txtJsonText);

        txtJsonText := CallServiceClearTaxInvoice('', recSalesSetup."E-Invoice Generation API", txtJsonText, recLocation."GST Registration No.", recSalesSetup."E-Invoice Token");
        if recSalesSetup."Show Json" then
            Message(txtJsonText);
        //cuJsonManagement.InitializeCollectionFromJArray(txtJsonText);
        //jsonInvoiceList.ReadFrom(txtJsonText);
        jToken.ReadFrom(txtJsonText);
        if jToken.IsArray then
            jsonInvoiceList := jToken.AsArray()
        else
            Error(txtJsonText);

        foreach jToken in jsonInvoiceList do begin
            jsonInvoiceCT := jToken.AsObject();
            jToken.WriteTo(txtJsonText);
            cuJsonManagement.InitializeObject(txtJsonText);
        end;

        txtJsonText := cuJsonManagement.GetValue('govt_response.Irn');
        if txtJsonText <> '' then begin
            RecRef.Open(112);
            RecRef.GetTable(SalesInvoiceHeader);

            FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("IRN Hash"));
            FieldRef.Value := txtJsonText;

            FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("Acknowledgement No."));
            FieldRef.Value := cuJsonManagement.GetValue('govt_response.AckNo');

            txtJsonText := cuJsonManagement.GetValue('govt_response.AckDt');
            Evaluate(dtAckDate, CopyStr(txtJsonText, 1, 10));
            Evaluate(dtAckTime, CopyStr(txtJsonText, 11, 8));
            FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("Acknowledgement Date"));
            FieldRef.Value := CreateDateTime(dtAckDate, dtAckTime);

            cuQRCodeGenerator.GenerateQRCodeImage(cuJSONManagement.GetValue('govt_response.SignedQRCode'), cuTempBlob);
            FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("QR Code"));
            cuTempBlob.ToRecordRef(RecRef, SalesInvoiceHeader.FieldNo("QR Code"));
            RecRef.Modify();

            recSalesInvHeader.Get(SalesInvoiceHeader."No.");
            recSalesInvHeader."E-Invoice Status" := recSalesInvHeader."E-Invoice Status"::Generated;
            recSalesInvHeader.Modify();
            Message('E-Invoice Generated.');
        end else begin
            txtJsonText := cuJsonManagement.GetValue('govt_response.ErrorDetails');
            jToken.ReadFrom(txtJsonText);
            jsonInvoiceList := jToken.AsArray();
            foreach jToken in jsonInvoiceList do begin
                jsonInvoiceCT := jToken.AsObject();
                jToken.WriteTo(txtJsonText);
                cuJsonManagement.InitializeObject(txtJsonText);
                if txtErrorMsg = '' then
                    txtErrorMsg := cuJsonManagement.GetValue('error_message')
                else
                    txtErrorMsg := txtErrorMsg + ',' + cuJsonManagement.GetValue('error_message');
            end;
            ERROR('Please share this request ID for support %1', txtErrorMsg);
        end;
    end;



    procedure CancelEInvoiceSalesInvoiceClearTax(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        blnEinvoiceTesting: Boolean;
        txtAcessToken: Text;
        jsonInvoice: JsonObject;
        recSalesSetup: Record "Sales & Receivables Setup";
        txtJsonText: Text;
        dtCanDate: Date;
        dtCanTime: Time;
        cuJsonManagement: Codeunit "JSON Management";
        recSalesInvHeader: Record "Sales Invoice Header";
        recLocation: Record Location;
        jsonInvoiceList: JsonArray;
        jToken: JsonToken;
        txtErrorMsg: Text;
    begin
        CheckEInvoiceCancellationPermission();

        SalesInvoiceHeader.TestField("E-Invoice Status", SalesInvoiceHeader."E-Invoice Status"::Generated);

        recSalesSetup.Get();
        recSalesSetup.TestField("E-Invoice Cancellation API");
        blnEinvoiceTesting := false;
        if StrPos(UpperCase(recSalesSetup."E-Invoice Cancellation API"), 'SANDBOX') <> 0 then
            blnEinvoiceTesting := true;

        recLocation.Get(SalesInvoiceHeader."Location Code");

        // if blnEinvoiceTesting then
        //     jsonInvoice.Add('user_gstin', '06AAFCD5862R017')
        // else
        //     jsonInvoice.Add('user_gstin', recLocation."GST Registration No.");
        jsonInvoice.Add('irn', SalesInvoiceHeader."IRN Hash");
        jsonInvoice.Add('CnlRsn', '1');
        jsonInvoice.Add('CnlRem', 'wrong entry');

        jsonInvoiceList.Add(jsonInvoice);
        jsonInvoiceList.WriteTo(txtJsonText);

        //jsonInvoice.WriteTo(txtJsonText);
        txtJsonText := CallServiceClearTaxInvoice('', recSalesSetup."E-Invoice Cancellation API", txtJsonText, recLocation."GST Registration No.", recSalesSetup."E-Invoice Token");
        jToken.ReadFrom(txtJsonText);
        if jToken.IsArray then
            jsonInvoiceList := jToken.AsArray()
        else
            Error(txtJsonText);

        foreach jToken in jsonInvoiceList do begin
            //jsonInvoice := jToken.AsObject();
            jToken.WriteTo(txtJsonText);
            cuJsonManagement.InitializeObject(txtJsonText);
        end;


        cuJsonManagement.InitializeObject(txtJsonText);

        txtJsonText := cuJsonManagement.GetValue('document_status');
        if txtJsonText = 'IRN_CANCELLED' then begin
            recSalesInvHeader.Get(SalesInvoiceHeader."No.");

            txtJsonText := cuJsonManagement.GetValue('govt_response.CancelDate');
            Evaluate(dtCanDate, CopyStr(txtJsonText, 1, 10));
            Evaluate(dtCanTime, CopyStr(txtJsonText, 11, 8));
            recSalesInvHeader."E-Inv. Cancelled Date" := CreateDateTime(dtCanDate, dtCanTime);
            recSalesInvHeader."E-Invoice Status" := recSalesInvHeader."E-Invoice Status"::Cancelled;
            recSalesInvHeader.Modify();
            Message('E-Invoice Cancelled.');
        end else
            ERROR('%1 Please share this request ID for support %2', cuJsonManagement.GetValue('results.errorMessage'), cuJsonManagement.GetValue('results.code'));
    end;


    procedure GenerateEInvoiceSalesCreditMemoClearTax(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        blnEinvoiceTesting: Boolean;
        txtAcessToken: Text;
        opInvoiceType: Option Registered,Export,SEZ;
        decCurrencyFactor: Decimal;
        recSalesCrMemoLines: Record "Sales Cr.Memo Line";
        decTotalInvoiceAmount: Decimal;
        decTotalLineAmount: Decimal;
        decTotalDiscountAmount: Decimal;
        decTotalIGSTAmount: Decimal;
        decTotalCGSTAmount: Decimal;
        decTotalSGSTAmount: Decimal;
        decRoundOffAmount: Decimal;
        jsonInvoice: JsonObject;
        jsonInvoiceCT: JsonObject;
        jsonTranDetails: JsonObject;
        jsonDocumentDetails: JsonObject;
        jsonSellerDetails: JsonObject;
        recLocation: Record Location;
        recState: Record State;
        jsonBuyerDetails: JsonObject;
        recCustomer: Record Customer;
        jsonShipToDetails: JsonObject;
        recShipToAddress: Record "Ship-to Address";
        jsonExportDetails: JsonObject;
        jsonValueDetails: JsonObject;
        decFCYValue: Decimal;
        intEntryNo: Integer;
        jsonItemDetails: JsonObject;
        decTCSAmount: Decimal;
        jsonItemList: JsonArray;
        txtJsonText: Text;
        recSalesSetup: Record "Sales & Receivables Setup";
        cuJsonManagement: Codeunit "JSON Management";
        cuQRCodeGenerator: Codeunit "QR Generator";
        cuTempBlob: Codeunit "Temp Blob";
        FieldRef: FieldRef;
        RecRef: RecordRef;
        dtAckDate: Date;
        dtAckTime: Time;
        recSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        recGSTGroup: Record "GST Group";
        recItem: Record Item;
        recGLAccount: Record "G/L Account";
        jsonInvoiceList: JsonArray;
        jToken: JsonToken;
        txtErrorMsg: Text;
    begin
        CheckEInvoiceGenerationPermission();

        //SalesCrMemoHeader.TestField("E-Invoice Status", SalesCrMemoHeader."E-Invoice Status"::Open);

        if SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::Registered then
            opInvoiceType := opInvoiceType::Registered;
        if SalesCrMemoHeader."GST Customer Type" in [SalesCrMemoHeader."GST Customer Type"::Export] then
            opInvoiceType := opInvoiceType::Export;
        if SalesCrMemoHeader."GST Customer Type" in [SalesCrMemoHeader."GST Customer Type"::"SEZ Unit", SalesCrMemoHeader."GST Customer Type"::"SEZ Development"] then
            opInvoiceType := opInvoiceType::SEZ;

        if SalesCrMemoHeader."Currency Code" <> '' then
            decCurrencyFactor := 1 / SalesCrMemoHeader."Currency Factor"
        else
            decCurrencyFactor := 1;

        SalesCrMemoHeader.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
        if opInvoiceType = opInvoiceType::Registered then begin
            SalesCrMemoHeader.TestField("Customer GST Reg. No.");
            if SalesCrMemoHeader."IGST Amount" + SalesCrMemoHeader."CGST Amount" + SalesCrMemoHeader."SGST Amount" = 0 then
                Error('GST Amount must not be zero.');
        end;

        //txtAcessToken := GetAccessToken();

        SalesCrMemoHeader.CalcFields("Total Line Amount", "Total Line Discount");
        decTotalLineAmount := Round(SalesCrMemoHeader."Total Line Amount" * decCurrencyFactor, 0.01);
        decTotalDiscountAmount := Round(SalesCrMemoHeader."Total Line Discount" * decCurrencyFactor, 0.01);
        decTotalIGSTAmount := Round(SalesCrMemoHeader."IGST Amount" * decCurrencyFactor, 0.01);
        decTotalCGSTAmount := Round(SalesCrMemoHeader."CGST Amount" * decCurrencyFactor, 0.01);
        decTotalSGSTAmount := Round(SalesCrMemoHeader."SGST Amount" * decCurrencyFactor, 0.01);
        decTotalInvoiceAmount := decTotalLineAmount + decTotalIGSTAmount + decTotalSGSTAmount + decTotalCGSTAmount;
        decFCYValue := SalesCrMemoHeader."Total Line Amount" + SalesCrMemoHeader."IGST Amount" +
                                                    SalesCrMemoHeader."SGST Amount" + SalesCrMemoHeader."CGST Amount";

        decRoundOffAmount := 0;
        recSalesCrMemoLines.Reset();
        recSalesCrMemoLines.SetRange("Document No.", SalesCrMemoHeader."No.");
        recSalesCrMemoLines.SetRange("System-Created Entry", true);
        if recSalesCrMemoLines.FindSet() then begin
            decRoundOffAmount := Round(recSalesCrMemoLines."Line Amount" * decCurrencyFactor, 0.01);
            decFCYValue += recSalesCrMemoLines."Line Amount";
        end;

        recSalesSetup.Get();
        recSalesSetup.TestField("E-Invoice Generation API");
        blnEinvoiceTesting := false;
        if StrPos(UpperCase(recSalesSetup."E-Invoice Generation API"), 'SANDBOX') <> 0 then
            blnEinvoiceTesting := true;

        recLocation.Get(SalesCrMemoHeader."Location Code");
        recState.Get(recLocation."State Code");

        //Start Json Creation
        jsonInvoice.Add('Version', '1.1');

        // if blnEinvoiceTesting then
        //     jsonInvoice.Add('user_gstin', '09AAAPG7885R002')
        // else
        //     jsonInvoice.Add('user_gstin', recLocation."GST Registration No.");
        // jsonInvoice.Add('data_source', 'erp');

        //Transaction Details
        jsonTranDetails.Add('TaxSch', 'GST');
        if opInvoiceType = opInvoiceType::Registered then
            jsonTranDetails.Add('SupTyp', 'B2B');
        if (opInvoiceType = opInvoiceType::Export) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount <> 0) then
            jsonTranDetails.Add('SupTyp', 'EXPWP');
        if (opInvoiceType = opInvoiceType::Export) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount = 0) then
            jsonTranDetails.Add('SupTyp', 'EXPWOP');
        if (opInvoiceType = opInvoiceType::SEZ) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount <> 0) then
            jsonTranDetails.Add('SupTyp', 'SEZWP');
        if (opInvoiceType = opInvoiceType::SEZ) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount = 0) then
            jsonTranDetails.Add('SupTyp', 'SEZWOP');

        jsonTranDetails.Add('RegRev', 'Y');
        jsonTranDetails.Add('IgstOnIntra', 'N');
        jsonInvoice.Add('TranDtls', jsonTranDetails);

        //Document Details
        jsonDocumentDetails.Add('Typ', 'CRN');
        jsonDocumentDetails.Add('No', SalesCrMemoHeader."No.");

        if blnEinvoiceTesting then
            jsonDocumentDetails.Add('Dt', ConvertDate(Today))
        else
            jsonDocumentDetails.Add('Dt', ConvertDate(SalesCrMemoHeader."Posting Date"));

        jsonInvoice.Add('DocDtls', jsonDocumentDetails);

        //Seller Details
        if blnEinvoiceTesting then begin
            jsonSellerDetails.Add('Gstin', '06AAFCD5862R017');
            jsonSellerDetails.Add('LglNm', recLocation.Name);
            jsonSellerDetails.Add('TrdNm', recLocation.Name);
            jsonSellerDetails.Add('Addr1', recLocation.Address);
            jsonSellerDetails.Add('Addr2', recLocation."Address 2");
            jsonSellerDetails.Add('Loc', 'GANDHINAGAR');
            jsonSellerDetails.Add('Pin', '121005');
            jsonSellerDetails.Add('Stcd', '06');
        end else begin
            jsonSellerDetails.Add('Gstin', recLocation."GST Registration No.");
            jsonSellerDetails.Add('LglNm', recLocation.Name);
            jsonSellerDetails.Add('TrdNm', recLocation.Name);
            jsonSellerDetails.Add('Addr1', recLocation.Address);
            jsonSellerDetails.Add('Addr2', recLocation."Address 2");
            jsonSellerDetails.Add('Loc', recLocation.City);
            jsonSellerDetails.Add('Pin', recLocation."Post Code");
            jsonSellerDetails.Add('Stcd', recState."State Code (GST Reg. No.)");
        end;
        jsonInvoice.Add('SellerDtls', jsonSellerDetails);

        //Buyer Details
        if blnEinvoiceTesting then begin
            jsonBuyerDetails.Add('Gstin', '07AAFCD5862R007');
            jsonBuyerDetails.Add('LglNm', 'XYZ company pvt ltd');
            jsonBuyerDetails.Add('TrdNm', 'XYZ Industries');
            jsonBuyerDetails.Add('Addr1', '7th block, kuvempu layout');
            jsonBuyerDetails.Add('Addr2', 'kuvempu layout');
            jsonBuyerDetails.Add('Loc', 'Delhi');
            jsonBuyerDetails.Add('Pin', '110091');
            jsonBuyerDetails.Add('Pos', '07');
            jsonBuyerDetails.Add('Stcd', '07');
        end else begin
            recCustomer.Get(SalesCrMemoHeader."Bill-to Customer No.");
            IF opInvoiceType = opInvoiceType::Export THEN
                jsonBuyerDetails.Add('Gstin', 'URP')
            ELSE
                jsonBuyerDetails.Add('Gstin', SalesCrMemoHeader."Customer GST Reg. No.");
            jsonBuyerDetails.Add('LglNm', recCustomer.Name);
            jsonBuyerDetails.Add('TrdNm', recCustomer.Name);
            jsonBuyerDetails.Add('Addr1', recCustomer.Address);
            jsonBuyerDetails.Add('Addr2', recCustomer."Address 2");
            jsonBuyerDetails.Add('Loc', recCustomer.City);

            recState.Get(SalesCrMemoHeader."GST Bill-to State Code");
            IF opInvoiceType = opInvoiceType::Export THEN begin
                jsonBuyerDetails.Add('Pin', '999999');
                jsonBuyerDetails.Add('Pos', '96');
                jsonBuyerDetails.Add('Stcd', '96');
            end;
            IF opInvoiceType = opInvoiceType::SEZ THEN begin
                jsonBuyerDetails.Add('Pin', recCustomer."Post Code");
                jsonBuyerDetails.Add('Pos', '96');
                jsonBuyerDetails.Add('Stcd', recState."State Code (GST Reg. No.)");
            end;
            IF opInvoiceType = opInvoiceType::Registered THEN begin
                jsonBuyerDetails.Add('Pin', recCustomer."Post Code");
                jsonBuyerDetails.Add('Pos', recState."State Code (GST Reg. No.)");
                jsonBuyerDetails.Add('Stcd', recState."State Code (GST Reg. No.)");
            end;
        end;
        jsonInvoice.Add('BuyerDtls', jsonBuyerDetails);

        //Ship to Details
        IF SalesCrMemoHeader."Ship-to Code" <> '' THEN BEGIN
            recShipToAddress.GET(SalesCrMemoHeader."Sell-to Customer No.", SalesCrMemoHeader."Ship-to Code");

            jsonShipToDetails.Add('Gstin', recShipToAddress."GST Registration No.");
            jsonShipToDetails.Add('LglNm', recShipToAddress.Name);
            jsonShipToDetails.Add('TrdNm', recShipToAddress.Name);
            jsonShipToDetails.Add('Addr1', recShipToAddress.Address);
            jsonShipToDetails.Add('Addr2', recShipToAddress."Address 2");
            jsonShipToDetails.Add('Loc', recShipToAddress.City);
            jsonShipToDetails.Add('Pin', recShipToAddress."Post Code");

            IF not (opInvoiceType = opInvoiceType::Export) THEN begin
                recState.GET(recShipToAddress.State);
                jsonShipToDetails.Add('state_code', recState."State Code (GST Reg. No.)");
                jsonInvoice.Add('Stcd', jsonShipToDetails);
            END;
        end;

        //Item Details
        intEntryNo := 0;
        recSalesCrMemoLines.RESET;
        recSalesCrMemoLines.SETRANGE("Document No.", SalesCrMemoHeader."No.");
        recSalesCrMemoLines.SetRange("System-Created Entry", false);
        recSalesCrMemoLines.SETFILTER(Quantity, '<>%1', 0);
        IF recSalesCrMemoLines.FindSet() THEN BEGIN
            REPEAT
                recSalesCrMemoLines.CalcFields("NOC Wise TCS Amount", "NOC Wise TCS Base Amount");
                recSalesCrMemoLines.CalcFields("IGST %", "CGST %", "SGST %");
                recSalesCrMemoLines.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");

                Clear(jsonItemDetails);
                intEntryNo += 1;
                jsonItemDetails.Add('SlNo', intEntryNo);

                if recSalesCrMemoLines.Type = recSalesCrMemoLines.Type::Item then begin
                    recItem.Get(recSalesCrMemoLines."No.");
                    jsonItemDetails.Add('PrdDesc', recItem.Description);
                end else
                    if recSalesCrMemoLines.Type = recSalesCrMemoLines.Type::"G/L Account" then begin
                        recGLAccount.Get(recSalesCrMemoLines."No.");
                        jsonItemDetails.Add('PrdDesc', recGLAccount.Name);
                    end else
                        jsonItemDetails.Add('PrdDesc', recSalesCrMemoLines.Description);

                if blnEinvoiceTesting then
                    jsonItemDetails.Add('IsServc', 'Y')
                else begin
                    recGSTGroup.Get(recSalesCrMemoLines."GST Group Code");
                    if recGSTGroup."GST Group Type" = recGSTGroup."GST Group Type"::Goods then
                        jsonItemDetails.Add('IsServc', 'N')
                    else
                        jsonItemDetails.Add('IsServc', 'Y');

                end;
                if blnEinvoiceTesting then
                    jsonItemDetails.Add('HsnCd', '996601')//'300420'
                else
                    jsonItemDetails.Add('HsnCd', recSalesCrMemoLines."HSN/SAC Code");
                jsonItemDetails.Add('Barcde', recSalesCrMemoLines."No.");
                jsonItemDetails.Add('Qty', Round(recSalesCrMemoLines.Quantity, 0.001));
                jsonItemDetails.Add('FreeQty', 0);


                if recSalesCrMemoLines."Unit of Measure Code" = '' then
                    jsonItemDetails.Add('Unit', 'OTH')
                else
                    jsonItemDetails.Add('Unit', recSalesCrMemoLines."Unit of Measure Code");

                jsonItemDetails.Add('UnitPrice', Round(recSalesCrMemoLines."Unit Price" * decCurrencyFactor, 0.001));
                jsonItemDetails.Add('TotAmt', Round((recSalesCrMemoLines."Unit Price" * recSalesCrMemoLines.Quantity) * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('Discount', Round(recSalesCrMemoLines."Line Discount Amount" * decCurrencyFactor, 0.01));
                //PreTaxVal
                if recSalesCrMemoLines."NOC Wise TCS Base Amount" <> 0 then
                    decTCSAmount := Round(recSalesCrMemoLines."NOC Wise TCS Amount" / recSalesCrMemoLines."NOC Wise TCS Base Amount" * recSalesCrMemoLines."Line Amount", 0.01);
                jsonItemDetails.Add('OthChrg', Round(decTCSAmount * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('AssAmt', Round(recSalesCrMemoLines."Line Amount" * decCurrencyFactor, 0.01));

                jsonItemDetails.Add('GstRt', recSalesCrMemoLines."IGST %" + recSalesCrMemoLines."SGST %" + recSalesCrMemoLines."CGST %");
                jsonItemDetails.Add('IgstAmt', -Round(recSalesCrMemoLines."IGST Amount" * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('CgstAmt', -Round(recSalesCrMemoLines."CGST Amount" * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('SgstAmt', -Round(recSalesCrMemoLines."SGST Amount" * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('CesRt', 0);
                jsonItemDetails.Add('CesAmt', 0);
                jsonItemDetails.Add('CesNonAdvlAmt', 0);
                jsonItemDetails.Add('StateCesRt', 0);
                jsonItemDetails.Add('StateCesAmt', 0);
                jsonItemDetails.Add('StateCesNonAdvlAmt', 0);
                jsonItemDetails.Add('TotItemVal', Round((recSalesCrMemoLines."Line Amount" + recSalesCrMemoLines."IGST Amount" * -1 +
                                                                    recSalesCrMemoLines."CGST Amount" * -1 + recSalesCrMemoLines."SGST Amount" * -1) * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('OrdLineRef', recSalesCrMemoLines."Line No.");
                //OrgCntry
                jsonItemDetails.Add('PrdSlNo', recSalesCrMemoLines."Line No.");

                jsonItemList.Add(jsonItemDetails);
            UNTIL recSalesCrMemoLines.NEXT = 0;
            jsonInvoice.Add('ItemList', jsonItemList);
        end;

        //Value Details
        jsonValueDetails.Add('AssVal', decTotalLineAmount);
        jsonValueDetails.Add('CgstVal', decTotalCGSTAmount);
        jsonValueDetails.Add('SgstVal', decTotalSGSTAmount);
        jsonValueDetails.Add('IgstVal', decTotalIGSTAmount);
        jsonValueDetails.Add('CesVal', 0);
        jsonValueDetails.Add('StCesVal', 0);
        jsonValueDetails.Add('RndOffAmt', decRoundOffAmount);
        jsonValueDetails.Add('Discount', 0);
        jsonValueDetails.Add('OthChrg', 0);
        jsonValueDetails.Add('TotInvVal', decTotalInvoiceAmount + decRoundOffAmount);
        jsonValueDetails.Add('TotInvValFc', decTotalInvoiceAmount);


        // IF opInvoiceType = opInvoiceType::Export THEN
        //     jsonValueDetails.Add('total_invoice_value_additional_currency', decFCYValue)
        // ELSE BEGIN
        //     jsonValueDetails.Add('total_invoice_value_additional_currency', 0);
        // END;
        jsonInvoice.Add('ValDtls', jsonValueDetails);

        //Export Details
        IF opInvoiceType = opInvoiceType::Export THEN BEGIN
            jsonExportDetails.Add('ShipBNo', '');
            jsonExportDetails.Add('ShipBDt', '');
            jsonExportDetails.Add('CntCode', '');
            jsonExportDetails.Add('ForCur', SalesCrMemoHeader."Currency Code");
            jsonExportDetails.Add('RefClm', '');
            jsonExportDetails.Add('Port', '');
            jsonInvoice.Add('ExpDtls', jsonExportDetails);
        END;

        jsonInvoiceCT.Add('transaction', jsonInvoice);
        jsonInvoiceList.Add(jsonInvoiceCT);
        jsonInvoiceList.WriteTo(txtJsonText);
        if recSalesSetup."Show Json" then
            Message(txtJsonText);

        txtJsonText := CallServiceClearTaxInvoice('', recSalesSetup."E-Invoice Generation API", txtJsonText, recLocation."GST Registration No.", recSalesSetup."E-Invoice Token");
        //cuJsonManagement.InitializeCollectionFromJArray(txtJsonText);
        //jsonInvoiceList.ReadFrom(txtJsonText);
        if recSalesSetup."Show Json" then
            Message(txtJsonText);
        jToken.ReadFrom(txtJsonText);
        if jToken.IsArray then
            jsonInvoiceList := jToken.AsArray()
        else
            Error(txtJsonText);

        foreach jToken in jsonInvoiceList do begin
            jsonInvoiceCT := jToken.AsObject();
            jToken.WriteTo(txtJsonText);
            cuJsonManagement.InitializeObject(txtJsonText);
        end;

        txtJsonText := cuJsonManagement.GetValue('govt_response.Irn');
        if txtJsonText <> '' then begin
            RecRef.Open(112);
            RecRef.GetTable(SalesCrMemoHeader);

            FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("IRN Hash"));
            FieldRef.Value := txtJsonText;

            FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("Acknowledgement No."));
            FieldRef.Value := cuJsonManagement.GetValue('govt_response.AckNo');

            txtJsonText := cuJsonManagement.GetValue('govt_response.AckDt');
            Evaluate(dtAckDate, CopyStr(txtJsonText, 1, 10));
            Evaluate(dtAckTime, CopyStr(txtJsonText, 11, 8));
            FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("Acknowledgement Date"));
            FieldRef.Value := CreateDateTime(dtAckDate, dtAckTime);

            cuQRCodeGenerator.GenerateQRCodeImage(cuJSONManagement.GetValue('govt_response.SignedQRCode'), cuTempBlob);
            FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("QR Code"));
            cuTempBlob.ToRecordRef(RecRef, SalesCrMemoHeader.FieldNo("QR Code"));
            RecRef.Modify();

            recSalesCrMemoHeader.Get(SalesCrMemoHeader."No.");
            recSalesCrMemoHeader."E-Invoice Status" := recSalesCrMemoHeader."E-Invoice Status"::Generated;
            recSalesCrMemoHeader.Modify();
            Message('E-Invoice Generated.');
        end else begin

            txtJsonText := cuJsonManagement.GetValue('govt_response.ErrorDetails');
            jToken.ReadFrom(txtJsonText);
            jsonInvoiceList := jToken.AsArray();
            foreach jToken in jsonInvoiceList do begin
                jsonInvoiceCT := jToken.AsObject();
                jToken.WriteTo(txtJsonText);
                cuJsonManagement.InitializeObject(txtJsonText);
                if txtErrorMsg = '' then
                    txtErrorMsg := cuJsonManagement.GetValue('error_message')
                else
                    txtErrorMsg := txtErrorMsg + ',' + cuJsonManagement.GetValue('error_message');
            end;
            ERROR('Please share this request ID for support %1', txtErrorMsg);
        end;
    end;

    procedure CancelEInvoiceSalesCreditMemoClearTax(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        blnEinvoiceTesting: Boolean;
        txtAcessToken: Text;
        jsonInvoice: JsonObject;
        recSalesSetup: Record "Sales & Receivables Setup";
        txtJsonText: Text;
        dtCanDate: Date;
        dtCanTime: Time;
        cuJsonManagement: Codeunit "JSON Management";
        recSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        recLocation: Record Location;
        jsonInvoiceList: JsonArray;
        jToken: JsonToken;
        txtErrorMsg: Text;
    begin
        CheckEInvoiceCancellationPermission();

        SalesCrMemoHeader.TestField("E-Invoice Status", SalesCrMemoHeader."E-Invoice Status"::Generated);

        recSalesSetup.Get();
        recSalesSetup.TestField("E-Invoice Cancellation API");
        blnEinvoiceTesting := false;
        if StrPos(UpperCase(recSalesSetup."E-Invoice Cancellation API"), 'SANDBOX') <> 0 then
            blnEinvoiceTesting := true;

        recLocation.Get(SalesCrMemoHeader."Location Code");

        // if blnEinvoiceTesting then
        //     jsonInvoice.Add('user_gstin', '06AAFCD5862R017')
        // else
        //     jsonInvoice.Add('user_gstin', recLocation."GST Registration No.");
        jsonInvoice.Add('irn', SalesCrMemoHeader."IRN Hash");
        jsonInvoice.Add('CnlRsn', '1');
        jsonInvoice.Add('CnlRem', 'wrong entry');

        jsonInvoiceList.Add(jsonInvoice);
        jsonInvoiceList.WriteTo(txtJsonText);

        //jsonInvoice.WriteTo(txtJsonText);
        txtJsonText := CallServiceClearTaxInvoice('', recSalesSetup."E-Invoice Cancellation API", txtJsonText, recLocation."GST Registration No.", recSalesSetup."E-Invoice Token");
        jToken.ReadFrom(txtJsonText);
        if jToken.IsArray then
            jsonInvoiceList := jToken.AsArray()
        else
            Error(txtJsonText);

        foreach jToken in jsonInvoiceList do begin
            //jsonInvoice := jToken.AsObject();
            jToken.WriteTo(txtJsonText);
            cuJsonManagement.InitializeObject(txtJsonText);
        end;


        cuJsonManagement.InitializeObject(txtJsonText);

        txtJsonText := cuJsonManagement.GetValue('document_status');
        if txtJsonText = 'IRN_CANCELLED' then begin
            recSalesCrMemoHeader.Get(SalesCrMemoHeader."No.");

            txtJsonText := cuJsonManagement.GetValue('govt_response.CancelDate');
            Evaluate(dtCanDate, CopyStr(txtJsonText, 1, 10));
            Evaluate(dtCanTime, CopyStr(txtJsonText, 11, 8));
            recSalesCrMemoHeader."E-Inv. Cancelled Date" := CreateDateTime(dtCanDate, dtCanTime);
            recSalesCrMemoHeader."E-Invoice Status" := recSalesCrMemoHeader."E-Invoice Status"::Cancelled;
            recSalesCrMemoHeader.Modify();
            Message('E-Invoice Cancelled.');
        end else
            ERROR('%1 Please share this request ID for support %2', cuJsonManagement.GetValue('results.errorMessage'), cuJsonManagement.GetValue('results.code'));
    end;

    procedure GenerateEInvoiceSalesInvoice(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        blnEinvoiceTesting: Boolean;
        txtAcessToken: Text;
        opInvoiceType: Option Registered,Export,SEZ;
        decCurrencyFactor: Decimal;
        recSalesInvoiceLines: Record "Sales Invoice Line";
        decTotalInvoiceAmount: Decimal;
        decTotalLineAmount: Decimal;
        decTotalDiscountAmount: Decimal;
        decTotalIGSTAmount: Decimal;
        decTotalCGSTAmount: Decimal;
        decTotalSGSTAmount: Decimal;
        decRoundOffAmount: Decimal;
        jsonInvoice: JsonObject;
        jsonTranDetails: JsonObject;
        jsonDocumentDetails: JsonObject;
        jsonSellerDetails: JsonObject;
        recLocation: Record Location;
        recState: Record State;
        jsonBuyerDetails: JsonObject;
        recCustomer: Record Customer;
        jsonShipToDetails: JsonObject;
        recShipToAddress: Record "Ship-to Address";
        jsonExportDetails: JsonObject;
        jsonValueDetails: JsonObject;
        decFCYValue: Decimal;
        intEntryNo: Integer;
        jsonItemDetails: JsonObject;
        decTCSAmount: Decimal;
        jsonItemList: JsonArray;
        txtJsonText: Text;
        recSalesSetup: Record "Sales & Receivables Setup";
        cuJsonManagement: Codeunit "JSON Management";
        cuQRCodeGenerator: Codeunit "QR Generator";
        cuTempBlob: Codeunit "Temp Blob";
        FieldRef: FieldRef;
        RecRef: RecordRef;
        dtAckDate: Date;
        dtAckTime: Time;
        recSalesInvHeader: Record "Sales Invoice Header";
        recGSTGroup: Record "GST Group";
        recItem: Record Item;
        recGLAccount: Record "G/L Account";
    begin
        CheckEInvoiceGenerationPermission();

        SalesInvoiceHeader.TestField("E-Invoice Status", SalesInvoiceHeader."E-Invoice Status"::Open);

        if SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Registered then
            opInvoiceType := opInvoiceType::Registered;
        if SalesInvoiceHeader."GST Customer Type" in [SalesInvoiceHeader."GST Customer Type"::Export] then
            opInvoiceType := opInvoiceType::Export;
        if SalesInvoiceHeader."GST Customer Type" in [SalesInvoiceHeader."GST Customer Type"::"SEZ Unit", SalesInvoiceHeader."GST Customer Type"::"SEZ Development"] then
            opInvoiceType := opInvoiceType::SEZ;

        if SalesInvoiceHeader."Currency Code" <> '' then
            decCurrencyFactor := 1 / SalesInvoiceHeader."Currency Factor"
        else
            decCurrencyFactor := 1;

        SalesInvoiceHeader.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
        if opInvoiceType = opInvoiceType::Registered then begin
            SalesInvoiceHeader.TestField("Customer GST Reg. No.");
            if SalesInvoiceHeader."IGST Amount" + SalesInvoiceHeader."CGST Amount" + SalesInvoiceHeader."SGST Amount" = 0 then
                Error('GST Amount must not be zero.');
        end;

        txtAcessToken := GetAccessToken();

        SalesInvoiceHeader.CalcFields("Total Line Amount", "Total Line Discount");
        decTotalLineAmount := Round(SalesInvoiceHeader."Total Line Amount" * decCurrencyFactor, 0.01);
        decTotalDiscountAmount := Round(SalesInvoiceHeader."Total Line Discount" * decCurrencyFactor, 0.01);
        decTotalIGSTAmount := Round(SalesInvoiceHeader."IGST Amount" * decCurrencyFactor, 0.01);
        decTotalCGSTAmount := Round(SalesInvoiceHeader."CGST Amount" * decCurrencyFactor, 0.01);
        decTotalSGSTAmount := Round(SalesInvoiceHeader."SGST Amount" * decCurrencyFactor, 0.01);
        decTotalInvoiceAmount := decTotalLineAmount + decTotalIGSTAmount + decTotalSGSTAmount + decTotalCGSTAmount;
        decFCYValue := SalesInvoiceHeader."Total Line Amount" + SalesInvoiceHeader."IGST Amount" +
                                                    SalesInvoiceHeader."SGST Amount" + SalesInvoiceHeader."CGST Amount";

        decRoundOffAmount := 0;
        recSalesInvoiceLines.Reset();
        recSalesInvoiceLines.SetRange("Document No.", SalesInvoiceHeader."No.");
        recSalesInvoiceLines.SetRange("System-Created Entry", true);
        if recSalesInvoiceLines.FindSet() then begin
            decRoundOffAmount := Round(recSalesInvoiceLines."Line Amount" * decCurrencyFactor, 0.01);
            decFCYValue += recSalesInvoiceLines."Line Amount";
        end;

        recSalesSetup.Get();
        recSalesSetup.TestField("E-Invoice Generation API");
        blnEinvoiceTesting := false;
        if StrPos(UpperCase(recSalesSetup."E-Invoice Generation API"), 'CLIENTBASIC') <> 0 then
            blnEinvoiceTesting := true;

        recLocation.Get(SalesInvoiceHeader."Location Code");
        recState.Get(recLocation."State Code");

        //Start Json Creation
        jsonInvoice.Add('access_token', txtAcessToken);

        if blnEinvoiceTesting then
            jsonInvoice.Add('user_gstin', '09AAAPG7885R002')
        else
            jsonInvoice.Add('user_gstin', recLocation."GST Registration No.");
        jsonInvoice.Add('data_source', 'erp');

        //Transaction Details
        if opInvoiceType = opInvoiceType::Registered then
            jsonTranDetails.Add('supply_type', 'B2B');
        if (opInvoiceType = opInvoiceType::Export) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount <> 0) then
            jsonTranDetails.Add('supply_type', 'EXPWP');
        if (opInvoiceType = opInvoiceType::Export) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount = 0) then
            jsonTranDetails.Add('supply_type', 'EXPWOP');
        if (opInvoiceType = opInvoiceType::SEZ) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount <> 0) then
            jsonTranDetails.Add('supply_type', 'SEZWP');
        if (opInvoiceType = opInvoiceType::SEZ) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount = 0) then
            jsonTranDetails.Add('supply_type', 'SEZWOP');

        jsonTranDetails.Add('charge_type', 'N');
        jsonInvoice.Add('transaction_details', jsonTranDetails);

        //Document Details
        if SalesInvoiceHeader."Invoice Type" = SalesInvoiceHeader."Invoice Type"::"Debit Note" then
            jsonDocumentDetails.Add('document_type', 'DBN')
        else
            jsonDocumentDetails.Add('document_type', 'INV');
        jsonDocumentDetails.Add('document_number', SalesInvoiceheader."No.");

        if blnEinvoiceTesting then
            jsonDocumentDetails.Add('document_date', ConvertDate(Today))
        else
            jsonDocumentDetails.Add('document_date', ConvertDate(SalesInvoiceheader."Posting Date"));

        jsonInvoice.Add('document_details', jsonDocumentDetails);

        //Seller Details
        if blnEinvoiceTesting then begin
            jsonSellerDetails.Add('Gstin', '09AAAPG7885R002');
            jsonSellerDetails.Add('legal_name', recLocation.Name);
            jsonSellerDetails.Add('trade_name', recLocation.Name);
            jsonSellerDetails.Add('address1', recLocation.Address);
            jsonSellerDetails.Add('address2', recLocation."Address 2");
            jsonSellerDetails.Add('location', 'Noida');
            jsonSellerDetails.Add('pincode', '201301');
            jsonSellerDetails.Add('state_code', '09');
        end else begin
            jsonSellerDetails.Add('Gstin', recLocation."GST Registration No.");
            jsonSellerDetails.Add('legal_name', recLocation.Name);
            jsonSellerDetails.Add('trade_name', recLocation.Name);
            jsonSellerDetails.Add('address1', recLocation.Address);
            jsonSellerDetails.Add('address2', recLocation."Address 2");
            jsonSellerDetails.Add('location', recLocation.City);
            jsonSellerDetails.Add('pincode', recLocation."Post Code");
            jsonSellerDetails.Add('state_code', recState."State Code (GST Reg. No.)");
        end;
        jsonInvoice.Add('seller_details', jsonSellerDetails);

        //Buyer Details
        recCustomer.Get(SalesInvoiceHeader."Bill-to Customer No.");
        IF opInvoiceType = opInvoiceType::Export THEN
            jsonBuyerDetails.Add('Gstin', 'URP')
        ELSE
            jsonBuyerDetails.Add('Gstin', SalesInvoiceHeader."Customer GST Reg. No.");
        jsonBuyerDetails.Add('legal_name', recCustomer.Name);
        jsonBuyerDetails.Add('trade_name', recCustomer.Name);
        jsonBuyerDetails.Add('address1', recCustomer.Address);
        jsonBuyerDetails.Add('address2', recCustomer."Address 2");
        jsonBuyerDetails.Add('location', recCustomer.City);

        recState.Get(SalesInvoiceHeader."GST Bill-to State Code");
        IF opInvoiceType = opInvoiceType::Export THEN begin
            jsonBuyerDetails.Add('pincode', '999999');
            jsonBuyerDetails.Add('place_of_supply', '96');
            jsonBuyerDetails.Add('state_code', '96');
        end;
        IF opInvoiceType = opInvoiceType::SEZ THEN begin
            jsonBuyerDetails.Add('pincode', recCustomer."Post Code");
            jsonBuyerDetails.Add('place_of_supply', '96');
            jsonBuyerDetails.Add('state_code', recState."State Code (GST Reg. No.)");
        end;
        IF opInvoiceType = opInvoiceType::Registered THEN begin
            jsonBuyerDetails.Add('pincode', recCustomer."Post Code");
            jsonBuyerDetails.Add('place_of_supply', recState."State Code (GST Reg. No.)");
            jsonBuyerDetails.Add('state_code', recState."State Code (GST Reg. No.)");
        end;
        jsonInvoice.Add('buyer_details', jsonBuyerDetails);

        //Ship to Details
        IF SalesInvoiceheader."Ship-to Code" <> '' THEN BEGIN
            recShipToAddress.GET(SalesInvoiceheader."Sell-to Customer No.", SalesInvoiceheader."Ship-to Code");

            jsonShipToDetails.Add('Gstin', recShipToAddress."GST Registration No.");
            jsonShipToDetails.Add('legal_name', recShipToAddress.Name);
            jsonShipToDetails.Add('trade_name', recShipToAddress.Name);
            jsonShipToDetails.Add('address1', recShipToAddress.Address);
            jsonShipToDetails.Add('address2', recShipToAddress."Address 2");
            jsonShipToDetails.Add('location', recShipToAddress.City);
            jsonShipToDetails.Add('pincode', recShipToAddress."Post Code");

            IF not (opInvoiceType = opInvoiceType::Export) THEN begin
                recState.GET(recShipToAddress.State);
                jsonShipToDetails.Add('state_code', recState."State Code (GST Reg. No.)");
                jsonInvoice.Add('ship_details', jsonShipToDetails);
            END;
        end;

        //Export Details
        IF opInvoiceType = opInvoiceType::Export THEN BEGIN
            jsonExportDetails.Add('ship_bill_number', '');
            jsonExportDetails.Add('ship_bill_date', '');
            jsonExportDetails.Add('country_code', '');
            jsonExportDetails.Add('foreign_currency', SalesInvoiceheader."Currency Code");
            jsonExportDetails.Add('refund_claim', '');
            jsonExportDetails.Add('port_code', '');
            jsonExportDetails.Add('export_duty', 0);
            jsonInvoice.Add('export_details', jsonExportDetails);
        END;

        //Value Details
        jsonValueDetails.Add('total_assessable_value', decTotalLineAmount);
        jsonValueDetails.Add('total_cgst_value', decTotalCGSTAmount);
        jsonValueDetails.Add('total_sgst_value', decTotalSGSTAmount);
        jsonValueDetails.Add('total_igst_value', decTotalIGSTAmount);
        jsonValueDetails.Add('total_cess_value', 0);
        jsonValueDetails.Add('total_cess_nonadvol_value', 0);
        jsonValueDetails.Add('total_invoice_value', decTotalInvoiceAmount + decRoundOffAmount);
        jsonValueDetails.Add('total_cess_value_of_state', 0);
        jsonValueDetails.Add('round_off_amount', decRoundOffAmount);

        IF opInvoiceType = opInvoiceType::Export THEN
            jsonValueDetails.Add('total_invoice_value_additional_currency', decFCYValue)
        ELSE BEGIN
            jsonValueDetails.Add('total_invoice_value_additional_currency', 0);
        END;
        jsonInvoice.Add('value_details', jsonValueDetails);

        //Item Details
        intEntryNo := 0;
        recSalesInvoiceLines.RESET;
        recSalesInvoiceLines.SETRANGE("Document No.", SalesInvoiceheader."No.");
        recSalesInvoiceLines.SetRange("System-Created Entry", false);
        recSalesInvoiceLines.SETFILTER(Quantity, '<>%1', 0);
        IF recSalesInvoiceLines.FindSet() THEN BEGIN
            REPEAT
                recSalesInvoiceLines.CalcFields("NOC Wise TCS Amount", "NOC Wise TCS Base Amount");
                recSalesInvoiceLines.CalcFields("IGST %", "CGST %", "SGST %");
                recSalesInvoiceLines.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");

                Clear(jsonItemDetails);
                intEntryNo += 1;
                jsonItemDetails.Add('item_serial_number', intEntryNo);

                if recSalesInvoiceLines.Type = recSalesInvoiceLines.Type::Item then begin
                    recItem.Get(recSalesInvoiceLines."No.");
                    jsonItemDetails.Add('product_description', recItem.Description);
                end else
                    if recSalesInvoiceLines.Type = recSalesInvoiceLines.Type::"G/L Account" then begin
                        recGLAccount.Get(recSalesInvoiceLines."No.");
                        jsonItemDetails.Add('product_description', recGLAccount.Name);
                    end else
                        jsonItemDetails.Add('product_description', recSalesInvoiceLines.Description);
                jsonItemDetails.Add('bar_code', recSalesInvoiceLines."No.");
                jsonItemDetails.Add('free_quantity', 0);

                recGSTGroup.Get(recSalesInvoiceLines."GST Group Code");
                if recGSTGroup."GST Group Type" = recGSTGroup."GST Group Type"::Goods then
                    jsonItemDetails.Add('is_service', 'N')
                else
                    jsonItemDetails.Add('is_service', 'Y');

                jsonItemDetails.Add('hsn_code', recSalesInvoiceLines."HSN/SAC Code");
                jsonItemDetails.Add('quantity', Round(recSalesInvoiceLines.Quantity, 0.001));

                if recSalesInvoiceLines."Unit of Measure Code" = '' then
                    jsonItemDetails.Add('unit', 'OTH')
                else
                    jsonItemDetails.Add('unit', recSalesInvoiceLines."Unit of Measure Code");

                jsonItemDetails.Add('unit_price', Round(recSalesInvoiceLines."Unit Price" * decCurrencyFactor, 0.001));
                jsonItemDetails.Add('total_amount', Round((recSalesInvoiceLines."Unit Price" * recSalesInvoiceLines.Quantity) * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('discount', Round(recSalesInvoiceLines."Line Discount Amount" * decCurrencyFactor, 0.01));

                if recSalesInvoiceLines."NOC Wise TCS Base Amount" <> 0 then
                    decTCSAmount := Round(recSalesInvoiceLines."NOC Wise TCS Amount" / recSalesInvoiceLines."NOC Wise TCS Base Amount" * recSalesInvoiceLines."Line Amount", 0.01);
                jsonItemDetails.Add('other_charge', Round(decTCSAmount * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('assessable_value', Round(recSalesInvoiceLines."Line Amount" * decCurrencyFactor, 0.01));

                jsonItemDetails.Add('gst_rate', recSalesInvoiceLines."IGST %" + recSalesInvoiceLines."SGST %" + recSalesInvoiceLines."CGST %");
                jsonItemDetails.Add('igst_amount', Round(recSalesInvoiceLines."IGST Amount" * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('cgst_amount', Round(recSalesInvoiceLines."CGST Amount" * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('sgst_amount', Round(recSalesInvoiceLines."SGST Amount" * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('cess_rate', 0);
                jsonItemDetails.Add('cess_amount', 0);
                jsonItemDetails.Add('cess_nonadvol_amount', 0);
                jsonItemDetails.Add('state_cess_rate', 0);
                jsonItemDetails.Add('state_cess_amount', 0);
                jsonItemDetails.Add('state_cess_nonadvol_amount', 0);
                jsonItemDetails.Add('total_item_value', Round((recSalesInvoiceLines."Line Amount" + recSalesInvoiceLines."IGST Amount" +
                                                                    recSalesInvoiceLines."CGST Amount" + recSalesInvoiceLines."SGST Amount") * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('order_line_reference', recSalesInvoiceLines."Line No.");
                jsonItemDetails.Add('product_serial_number', recSalesInvoiceLines."Line No.");

                jsonItemList.Add(jsonItemDetails);
            UNTIL recSalesInvoiceLines.NEXT = 0;
            jsonInvoice.Add('item_list', jsonItemList);
        end;

        jsonInvoice.WriteTo(txtJsonText);
        txtJsonText := CallService('', recSalesSetup."E-Invoice Generation API", txtJsonText, '', '');
        cuJsonManagement.InitializeObject(txtJsonText);

        txtJsonText := cuJsonManagement.GetValue('results.message.Irn');
        if txtJsonText <> '' then begin
            RecRef.Open(112);
            RecRef.GetTable(SalesInvoiceHeader);

            FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("IRN Hash"));
            FieldRef.Value := txtJsonText;

            FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("Acknowledgement No."));
            FieldRef.Value := cuJsonManagement.GetValue('results.message.AckNo');

            txtJsonText := cuJsonManagement.GetValue('results.message.AckDt');
            Evaluate(dtAckDate, CopyStr(txtJsonText, 1, 10));
            Evaluate(dtAckTime, CopyStr(txtJsonText, 11, 8));
            FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("Acknowledgement Date"));
            FieldRef.Value := CreateDateTime(dtAckDate, dtAckTime);

            cuQRCodeGenerator.GenerateQRCodeImage(cuJSONManagement.GetValue('results.message.SignedQRCode'), cuTempBlob);
            FieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("QR Code"));
            cuTempBlob.ToRecordRef(RecRef, SalesInvoiceHeader.FieldNo("QR Code"));
            RecRef.Modify();

            recSalesInvHeader.Get(SalesInvoiceHeader."No.");
            recSalesInvHeader."E-Invoice Status" := recSalesInvHeader."E-Invoice Status"::Generated;
            recSalesInvHeader.Modify();
            Message('E-Invoice Generated.');
        end else
            ERROR('%1 Please share this request ID for support %2', cuJsonManagement.GetValue('results.errorMessage'), cuJsonManagement.GetValue('results.code'));
    end;

    procedure CancelEInvoiceSalesInvoice(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        blnEinvoiceTesting: Boolean;
        txtAcessToken: Text;
        jsonInvoice: JsonObject;
        recSalesSetup: Record "Sales & Receivables Setup";
        txtJsonText: Text;
        dtCanDate: Date;
        dtCanTime: Time;
        cuJsonManagement: Codeunit "JSON Management";
        recSalesInvHeader: Record "Sales Invoice Header";
        recLocation: Record Location;
    begin
        CheckEInvoiceCancellationPermission();

        SalesInvoiceHeader.TestField("E-Invoice Status", SalesInvoiceHeader."E-Invoice Status"::Generated);

        txtAcessToken := GetAccessToken();

        recSalesSetup.Get();
        recSalesSetup.TestField("E-Invoice Cancellation API");
        blnEinvoiceTesting := false;
        if StrPos(UpperCase(recSalesSetup."E-Invoice Cancellation API"), 'CLIENTBASIC') <> 0 then
            blnEinvoiceTesting := true;

        recLocation.Get(SalesInvoiceHeader."Location Code");

        //Start Json Creation
        jsonInvoice.Add('access_token', txtAcessToken);

        if blnEinvoiceTesting then
            jsonInvoice.Add('user_gstin', '09AAAPG7885R002')
        else
            jsonInvoice.Add('user_gstin', recLocation."GST Registration No.");
        jsonInvoice.Add('irn', SalesInvoiceHeader."IRN Hash");
        jsonInvoice.Add('cancel_reason', '1');
        jsonInvoice.Add('cancel_remarks', 'wrong entry');

        jsonInvoice.WriteTo(txtJsonText);
        txtJsonText := CallService('', recSalesSetup."E-Invoice Cancellation API", txtJsonText, '', '');
        cuJsonManagement.InitializeObject(txtJsonText);

        txtJsonText := cuJsonManagement.GetValue('results.status');
        if txtJsonText = 'Success' then begin
            recSalesInvHeader.Get(SalesInvoiceHeader."No.");

            txtJsonText := cuJsonManagement.GetValue('results.message.CancelDate');
            Evaluate(dtCanDate, CopyStr(txtJsonText, 1, 10));
            Evaluate(dtCanTime, CopyStr(txtJsonText, 11, 8));
            recSalesInvHeader."E-Inv. Cancelled Date" := CreateDateTime(dtCanDate, dtCanTime);
            recSalesInvHeader."E-Invoice Status" := recSalesInvHeader."E-Invoice Status"::Cancelled;
            recSalesInvHeader.Modify();
            Message('E-Invoice Cancelled.');
        end else
            ERROR('%1 Please share this request ID for support %2', cuJsonManagement.GetValue('results.errorMessage'), cuJsonManagement.GetValue('results.code'));
    end;

    procedure GenerateEInvoiceSalesCrMemo(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        blnEinvoiceTesting: Boolean;
        txtAcessToken: Text;
        opInvoiceType: Option Registered,Export,SEZ;
        decCurrencyFactor: Decimal;
        recSalesCrMemoLines: Record "Sales Cr.Memo Line";
        decTotalInvoiceAmount: Decimal;
        decTotalLineAmount: Decimal;
        decTotalDiscountAmount: Decimal;
        decTotalIGSTAmount: Decimal;
        decTotalCGSTAmount: Decimal;
        decTotalSGSTAmount: Decimal;
        decRoundOffAmount: Decimal;
        jsonInvoice: JsonObject;
        jsonTranDetails: JsonObject;
        jsonDocumentDetails: JsonObject;
        jsonSellerDetails: JsonObject;
        recLocation: Record Location;
        recState: Record State;
        jsonBuyerDetails: JsonObject;
        recCustomer: Record Customer;
        jsonShipToDetails: JsonObject;
        recShipToAddress: Record "Ship-to Address";
        jsonExportDetails: JsonObject;
        jsonValueDetails: JsonObject;
        decFCYValue: Decimal;
        intEntryNo: Integer;
        jsonItemDetails: JsonObject;
        decTCSAmount: Decimal;
        jsonItemList: JsonArray;
        txtJsonText: Text;
        recSalesSetup: Record "Sales & Receivables Setup";
        cuJsonManagement: Codeunit "JSON Management";
        cuQRCodeGenerator: Codeunit "QR Generator";
        cuTempBlob: Codeunit "Temp Blob";
        FieldRef: FieldRef;
        RecRef: RecordRef;
        dtAckDate: Date;
        dtAckTime: Time;
        recSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        recGSTGroup: Record "GST Group";
        recItem: Record Item;
        recGLAccount: Record "G/L Account";
    begin
        CheckEInvoiceGenerationPermission();

        SalesCrMemoHeader.TestField("E-Invoice Status", SalesCrMemoHeader."E-Invoice Status"::Open);

        if SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::Registered then
            opInvoiceType := opInvoiceType::Registered;
        if SalesCrMemoHeader."GST Customer Type" in [SalesCrMemoHeader."GST Customer Type"::Export] then
            opInvoiceType := opInvoiceType::Export;
        if SalesCrMemoHeader."GST Customer Type" in [SalesCrMemoHeader."GST Customer Type"::"SEZ Unit", SalesCrMemoHeader."GST Customer Type"::"SEZ Development"] then
            opInvoiceType := opInvoiceType::SEZ;

        if SalesCrMemoHeader."Currency Code" <> '' then
            decCurrencyFactor := 1 / SalesCrMemoHeader."Currency Factor"
        else
            decCurrencyFactor := 1;

        SalesCrMemoHeader.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
        if opInvoiceType = opInvoiceType::Registered then begin
            SalesCrMemoHeader.TestField("Customer GST Reg. No.");
            if SalesCrMemoHeader."IGST Amount" + SalesCrMemoHeader."CGST Amount" + SalesCrMemoHeader."SGST Amount" = 0 then
                Error('GST Amount must not be zero.');
        end;

        txtAcessToken := GetAccessToken();

        SalesCrMemoHeader.CalcFields("Total Line Amount", "Total Line Discount");
        decTotalLineAmount := Round(SalesCrMemoHeader."Total Line Amount" * decCurrencyFactor, 0.01);
        decTotalDiscountAmount := Round(SalesCrMemoHeader."Total Line Discount" * decCurrencyFactor, 0.01);
        decTotalIGSTAmount := Round(SalesCrMemoHeader."IGST Amount" * decCurrencyFactor, 0.01);
        decTotalCGSTAmount := Round(SalesCrMemoHeader."CGST Amount" * decCurrencyFactor, 0.01);
        decTotalSGSTAmount := Round(SalesCrMemoHeader."SGST Amount" * decCurrencyFactor, 0.01);
        decTotalInvoiceAmount := decTotalLineAmount + decTotalIGSTAmount + decTotalSGSTAmount + decTotalCGSTAmount;
        decFCYValue := SalesCrMemoHeader."Total Line Amount" + SalesCrMemoHeader."IGST Amount" +
                                                    SalesCrMemoHeader."SGST Amount" + SalesCrMemoHeader."CGST Amount";

        decRoundOffAmount := 0;
        recSalesCrMemoLines.Reset();
        recSalesCrMemoLines.SetRange("Document No.", SalesCrMemoHeader."No.");
        recSalesCrMemoLines.SetRange("System-Created Entry", true);
        if recSalesCrMemoLines.FindSet() then begin
            decRoundOffAmount := Round(recSalesCrMemoLines."Line Amount" * decCurrencyFactor, 0.01);
            decFCYValue += recSalesCrMemoLines."Line Amount";
        end;

        recSalesSetup.Get();
        recSalesSetup.TestField("E-Invoice Generation API");
        blnEinvoiceTesting := false;
        if StrPos(UpperCase(recSalesSetup."E-Invoice Generation API"), 'CLIENTBASIC') <> 0 then
            blnEinvoiceTesting := true;

        recLocation.Get(SalesCrMemoHeader."Location Code");
        recState.Get(recLocation."State Code");

        //Start Json Creation
        jsonInvoice.Add('access_token', txtAcessToken);

        if blnEinvoiceTesting then
            jsonInvoice.Add('user_gstin', '09AAAPG7885R002')
        else
            jsonInvoice.Add('user_gstin', recLocation."GST Registration No.");
        jsonInvoice.Add('data_source', 'erp');

        //Transaction Details
        if opInvoiceType = opInvoiceType::Registered then
            jsonTranDetails.Add('supply_type', 'B2B');
        if (opInvoiceType = opInvoiceType::Export) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount <> 0) then
            jsonTranDetails.Add('supply_type', 'EXPWP');
        if (opInvoiceType = opInvoiceType::Export) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount = 0) then
            jsonTranDetails.Add('supply_type', 'EXPWOP');
        if (opInvoiceType = opInvoiceType::SEZ) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount <> 0) then
            jsonTranDetails.Add('supply_type', 'SEZWP');
        if (opInvoiceType = opInvoiceType::SEZ) and (decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount = 0) then
            jsonTranDetails.Add('supply_type', 'SEZWOP');

        jsonTranDetails.Add('charge_type', 'N');
        jsonInvoice.Add('transaction_details', jsonTranDetails);

        //Document Details
        jsonDocumentDetails.Add('document_type', 'CRN');
        jsonDocumentDetails.Add('document_number', SalesCrMemoheader."No.");

        if blnEinvoiceTesting then
            jsonDocumentDetails.Add('document_date', ConvertDate(Today))
        else
            jsonDocumentDetails.Add('document_date', ConvertDate(SalesCrMemoheader."Posting Date"));

        jsonInvoice.Add('document_details', jsonDocumentDetails);

        //Seller Details
        if blnEinvoiceTesting then begin
            jsonSellerDetails.Add('Gstin', '09AAAPG7885R002');
            jsonSellerDetails.Add('legal_name', recLocation.Name);
            jsonSellerDetails.Add('trade_name', recLocation.Name);
            jsonSellerDetails.Add('address1', recLocation.Address);
            jsonSellerDetails.Add('address2', recLocation."Address 2");
            jsonSellerDetails.Add('location', 'Noida');
            jsonSellerDetails.Add('pincode', '201301');
            jsonSellerDetails.Add('state_code', '09');
        end else begin
            jsonSellerDetails.Add('Gstin', recLocation."GST Registration No.");
            jsonSellerDetails.Add('legal_name', recLocation.Name);
            jsonSellerDetails.Add('trade_name', recLocation.Name);
            jsonSellerDetails.Add('address1', recLocation.Address);
            jsonSellerDetails.Add('address2', recLocation."Address 2");
            jsonSellerDetails.Add('location', recLocation.City);
            jsonSellerDetails.Add('pincode', recLocation."Post Code");
            jsonSellerDetails.Add('state_code', recState."State Code (GST Reg. No.)");
        end;
        jsonInvoice.Add('seller_details', jsonSellerDetails);

        //Buyer Details
        recCustomer.Get(SalesCrMemoHeader."Bill-to Customer No.");
        IF opInvoiceType = opInvoiceType::Export THEN
            jsonBuyerDetails.Add('Gstin', 'URP')
        ELSE
            jsonBuyerDetails.Add('Gstin', SalesCrMemoHeader."Customer GST Reg. No.");
        jsonBuyerDetails.Add('legal_name', recCustomer.Name);
        jsonBuyerDetails.Add('trade_name', recCustomer.Name);
        jsonBuyerDetails.Add('address1', recCustomer.Address);
        jsonBuyerDetails.Add('address2', recCustomer."Address 2");
        jsonBuyerDetails.Add('location', recCustomer.City);

        recState.Get(SalesCrMemoHeader."GST Bill-to State Code");
        IF opInvoiceType = opInvoiceType::Export THEN begin
            jsonBuyerDetails.Add('pincode', '999999');
            jsonBuyerDetails.Add('place_of_supply', '96');
            jsonBuyerDetails.Add('state_code', '96');
        end;
        IF opInvoiceType = opInvoiceType::SEZ THEN begin
            jsonBuyerDetails.Add('pincode', recCustomer."Post Code");
            jsonBuyerDetails.Add('place_of_supply', '96');
            jsonBuyerDetails.Add('state_code', recState."State Code (GST Reg. No.)");
        end;
        IF opInvoiceType = opInvoiceType::Registered THEN begin
            jsonBuyerDetails.Add('pincode', recCustomer."Post Code");
            jsonBuyerDetails.Add('place_of_supply', recState."State Code (GST Reg. No.)");
            jsonBuyerDetails.Add('state_code', recState."State Code (GST Reg. No.)");
        end;
        jsonInvoice.Add('buyer_details', jsonBuyerDetails);

        //Ship to Details
        IF SalesCrMemoheader."Ship-to Code" <> '' THEN BEGIN
            recShipToAddress.GET(SalesCrMemoheader."Sell-to Customer No.", SalesCrMemoheader."Ship-to Code");

            jsonShipToDetails.Add('Gstin', recShipToAddress."GST Registration No.");
            jsonShipToDetails.Add('legal_name', recShipToAddress.Name);
            jsonShipToDetails.Add('trade_name', recShipToAddress.Name);
            jsonShipToDetails.Add('address1', recShipToAddress.Address);
            jsonShipToDetails.Add('address2', recShipToAddress."Address 2");
            jsonShipToDetails.Add('location', recShipToAddress.City);
            jsonShipToDetails.Add('pincode', recShipToAddress."Post Code");

            IF not (opInvoiceType = opInvoiceType::Export) THEN begin
                recState.GET(recShipToAddress.State);
                jsonShipToDetails.Add('state_code', recState."State Code (GST Reg. No.)");
                jsonInvoice.Add('ship_details', jsonShipToDetails);
            END;
        end;

        //Export Details
        IF opInvoiceType = opInvoiceType::Export THEN BEGIN
            jsonExportDetails.Add('ship_bill_number', '');
            jsonExportDetails.Add('ship_bill_date', '');
            jsonExportDetails.Add('country_code', '');
            jsonExportDetails.Add('foreign_currency', SalesCrMemoheader."Currency Code");
            jsonExportDetails.Add('refund_claim', '');
            jsonExportDetails.Add('port_code', '');
            jsonExportDetails.Add('export_duty', 0);
            jsonInvoice.Add('export_details', jsonExportDetails);
        END;

        //Value Details
        jsonValueDetails.Add('total_assessable_value', decTotalLineAmount);
        jsonValueDetails.Add('total_cgst_value', decTotalCGSTAmount);
        jsonValueDetails.Add('total_sgst_value', decTotalSGSTAmount);
        jsonValueDetails.Add('total_igst_value', decTotalIGSTAmount);
        jsonValueDetails.Add('total_cess_value', 0);
        jsonValueDetails.Add('total_cess_nonadvol_value', 0);
        jsonValueDetails.Add('total_invoice_value', decTotalInvoiceAmount + decRoundOffAmount);
        jsonValueDetails.Add('total_cess_value_of_state', 0);
        jsonValueDetails.Add('round_off_amount', decRoundOffAmount);

        IF opInvoiceType = opInvoiceType::Export THEN
            jsonValueDetails.Add('total_invoice_value_additional_currency', decFCYValue)
        ELSE BEGIN
            jsonValueDetails.Add('total_invoice_value_additional_currency', 0);
        END;
        jsonInvoice.Add('value_details', jsonValueDetails);

        //Item Details
        intEntryNo := 0;
        recSalesCrMemoLines.RESET;
        recSalesCrMemoLines.SETRANGE("Document No.", SalesCrMemoheader."No.");
        recSalesCrMemoLines.SetRange("System-Created Entry", false);
        recSalesCrMemoLines.SETFILTER(Quantity, '<>%1', 0);
        IF recSalesCrMemoLines.FindSet() THEN BEGIN
            REPEAT
                recSalesCrMemoLines.CalcFields("NOC Wise TCS Amount", "NOC Wise TCS Base Amount");
                recSalesCrMemoLines.CalcFields("IGST %", "CGST %", "SGST %");
                recSalesCrMemoLines.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");

                Clear(jsonItemDetails);
                intEntryNo += 1;
                jsonItemDetails.Add('item_serial_number', intEntryNo);

                if recSalesCrMemoLines.Type = recSalesCrMemoLines.Type::Item then begin
                    recItem.Get(recSalesCrMemoLines."No.");
                    jsonItemDetails.Add('product_description', recItem.Description);
                end else
                    if recSalesCrMemoLines.Type = recSalesCrMemoLines.Type::"G/L Account" then begin
                        recGLAccount.Get(recSalesCrMemoLines."No.");
                        jsonItemDetails.Add('product_description', recGLAccount.Name);
                    end else
                        jsonItemDetails.Add('product_description', recSalesCrMemoLines.Description);
                jsonItemDetails.Add('bar_code', recSalesCrMemoLines."No.");
                jsonItemDetails.Add('free_quantity', 0);

                recGSTGroup.Get(recSalesCrMemoLines."GST Group Code");
                if recGSTGroup."GST Group Type" = recGSTGroup."GST Group Type"::Goods then
                    jsonItemDetails.Add('is_service', 'N')
                else
                    jsonItemDetails.Add('is_service', 'Y');

                jsonItemDetails.Add('hsn_code', recSalesCrMemoLines."HSN/SAC Code");
                jsonItemDetails.Add('quantity', Round(recSalesCrMemoLines.Quantity, 0.001));

                if recSalesCrMemoLines."Unit of Measure Code" = '' then
                    jsonItemDetails.Add('unit', 'OTH')
                else
                    jsonItemDetails.Add('unit', recSalesCrMemoLines."Unit of Measure Code");

                jsonItemDetails.Add('unit_price', Round(recSalesCrMemoLines."Unit Price" * decCurrencyFactor, 0.001));
                jsonItemDetails.Add('total_amount', Round((recSalesCrMemoLines."Unit Price" * recSalesCrMemoLines.Quantity) * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('discount', Round(recSalesCrMemoLines."Line Discount Amount" * decCurrencyFactor, 0.01));

                if recSalesCrMemoLines."NOC Wise TCS Base Amount" <> 0 then
                    decTCSAmount := Round(recSalesCrMemoLines."NOC Wise TCS Amount" / recSalesCrMemoLines."NOC Wise TCS Base Amount" * recSalesCrMemoLines."Line Amount", 0.01);
                jsonItemDetails.Add('other_charge', Round(decTCSAmount * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('assessable_value', Round(recSalesCrMemoLines."Line Amount" * decCurrencyFactor, 0.01));

                jsonItemDetails.Add('gst_rate', recSalesCrMemoLines."IGST %" + recSalesCrMemoLines."SGST %" + recSalesCrMemoLines."CGST %");
                jsonItemDetails.Add('igst_amount', Round(-recSalesCrMemoLines."IGST Amount" * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('cgst_amount', Round(-recSalesCrMemoLines."CGST Amount" * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('sgst_amount', Round(-recSalesCrMemoLines."SGST Amount" * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('cess_rate', 0);
                jsonItemDetails.Add('cess_amount', 0);
                jsonItemDetails.Add('cess_nonadvol_amount', 0);
                jsonItemDetails.Add('state_cess_rate', 0);
                jsonItemDetails.Add('state_cess_amount', 0);
                jsonItemDetails.Add('state_cess_nonadvol_amount', 0);
                jsonItemDetails.Add('total_item_value', Round((recSalesCrMemoLines."Line Amount" + (recSalesCrMemoLines."IGST Amount" +
                                                                    recSalesCrMemoLines."CGST Amount" + recSalesCrMemoLines."SGST Amount") * -1) * decCurrencyFactor, 0.01));
                jsonItemDetails.Add('order_line_reference', recSalesCrMemoLines."Line No.");
                jsonItemDetails.Add('product_serial_number', recSalesCrMemoLines."Line No.");

                jsonItemList.Add(jsonItemDetails);
            UNTIL recSalesCrMemoLines.NEXT = 0;
            jsonInvoice.Add('item_list', jsonItemList);
        end;

        jsonInvoice.WriteTo(txtJsonText);
        Message('%1', txtJsonText);
        txtJsonText := CallService('', recSalesSetup."E-Invoice Generation API", txtJsonText, '', '');
        cuJsonManagement.InitializeObject(txtJsonText);

        txtJsonText := cuJsonManagement.GetValue('results.message.Irn');
        if txtJsonText <> '' then begin
            RecRef.Open(114);
            RecRef.GetTable(SalesCrMemoHeader);

            FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("IRN Hash"));
            FieldRef.Value := txtJsonText;

            FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("Acknowledgement No."));
            FieldRef.Value := cuJsonManagement.GetValue('results.message.AckNo');

            txtJsonText := cuJsonManagement.GetValue('results.message.AckDt');
            Evaluate(dtAckDate, CopyStr(txtJsonText, 1, 10));
            Evaluate(dtAckTime, CopyStr(txtJsonText, 11, 8));
            FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("Acknowledgement Date"));
            FieldRef.Value := CreateDateTime(dtAckDate, dtAckTime);

            cuQRCodeGenerator.GenerateQRCodeImage(cuJSONManagement.GetValue('results.message.SignedQRCode'), cuTempBlob);
            FieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo("QR Code"));
            cuTempBlob.ToRecordRef(RecRef, SalesCrMemoHeader.FieldNo("QR Code"));
            RecRef.Modify();

            recSalesCrMemoHeader.Get(SalesCrMemoHeader."No.");
            recSalesCrMemoHeader."E-Invoice Status" := recSalesCrMemoHeader."E-Invoice Status"::Generated;
            recSalesCrMemoHeader.Modify();
            Message('E-Invoice Generated.');
        end else
            ERROR('%1 Please share this request ID for support %2', cuJsonManagement.GetValue('results.errorMessage'), cuJsonManagement.GetValue('results.code'));
    end;

    procedure CancelEInvoiceSalesCrMemo(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        blnEinvoiceTesting: Boolean;
        txtAcessToken: Text;
        jsonInvoice: JsonObject;
        recSalesSetup: Record "Sales & Receivables Setup";
        txtJsonText: Text;
        dtCanDate: Date;
        dtCanTime: Time;
        cuJsonManagement: Codeunit "JSON Management";
        recSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        recLocation: Record Location;
    begin
        CheckEInvoiceCancellationPermission();

        SalesCrMemoHeader.TestField("E-Invoice Status", SalesCrMemoHeader."E-Invoice Status"::Generated);

        txtAcessToken := GetAccessToken();

        recSalesSetup.Get();
        recSalesSetup.TestField("E-Invoice Cancellation API");
        blnEinvoiceTesting := false;
        if StrPos(UpperCase(recSalesSetup."E-Invoice Cancellation API"), 'CLIENTBASIC') <> 0 then
            blnEinvoiceTesting := true;

        recLocation.Get(SalesCrMemoHeader."Location Code");

        //Start Json Creation
        jsonInvoice.Add('access_token', txtAcessToken);

        if blnEinvoiceTesting then
            jsonInvoice.Add('user_gstin', '09AAAPG7885R002')
        else
            jsonInvoice.Add('user_gstin', recLocation."GST Registration No.");
        jsonInvoice.Add('irn', SalesCrMemoHeader."IRN Hash");
        jsonInvoice.Add('cancel_reason', '1');
        jsonInvoice.Add('cancel_remarks', 'wrong entry');

        jsonInvoice.WriteTo(txtJsonText);
        txtJsonText := CallService('', recSalesSetup."E-Invoice Cancellation API", txtJsonText, '', '');
        cuJsonManagement.InitializeObject(txtJsonText);

        txtJsonText := cuJsonManagement.GetValue('results.status');
        if txtJsonText = 'Success' then begin
            recSalesCrMemoHeader.Get(SalesCrMemoHeader."No.");

            txtJsonText := cuJsonManagement.GetValue('results.message.CancelDate');
            Evaluate(dtCanDate, CopyStr(txtJsonText, 1, 10));
            Evaluate(dtCanTime, CopyStr(txtJsonText, 11, 8));
            recSalesCrMemoHeader."E-Inv. Cancelled Date" := CreateDateTime(dtCanDate, dtCanTime);
            recSalesCrMemoHeader."E-Invoice Status" := recSalesCrMemoHeader."E-Invoice Status"::Cancelled;
            recSalesCrMemoHeader.Modify();
            Message('E-Invoice Cancelled.');
        end else
            ERROR('%1 Please share this request ID for support %2', cuJsonManagement.GetValue('results.errorMessage'), cuJsonManagement.GetValue('results.code'));
    end;

    procedure GenerateEInvoiceTransferShipment(TransferShipmentHeadder: Record "Transfer Shipment Header")
    var
        blnEinvoiceTesting: Boolean;
        txtAcessToken: Text;
        recTrfShipmentLines: Record "Transfer Shipment Line";
        decTotalInvoiceAmount: Decimal;
        decTotalLineAmount: Decimal;
        decTotalIGSTAmount: Decimal;
        decTotalCGSTAmount: Decimal;
        decTotalSGSTAmount: Decimal;
        jsonInvoice: JsonObject;
        jsonTranDetails: JsonObject;
        jsonDocumentDetails: JsonObject;
        jsonSellerDetails: JsonObject;
        recState: Record State;
        jsonBuyerDetails: JsonObject;
        recFromLocation: Record Location;
        recToLocation: Record Location;
        jsonShipToDetails: JsonObject;
        jsonExportDetails: JsonObject;
        jsonValueDetails: JsonObject;
        intEntryNo: Integer;
        jsonItemDetails: JsonObject;
        decTCSAmount: Decimal;
        jsonItemList: JsonArray;
        txtJsonText: Text;
        recSalesSetup: Record "Sales & Receivables Setup";
        cuJsonManagement: Codeunit "JSON Management";
        cuQRCodeGenerator: Codeunit "QR Generator";
        cuTempBlob: Codeunit "Temp Blob";
        FieldRef: FieldRef;
        RecRef: RecordRef;
        dtAckDate: Date;
        dtAckTime: Time;
        recTrfShipmentHeader: Record "Transfer Shipment Header";
    begin
        CheckEInvoiceGenerationPermission();

        TransferShipmentHeadder.TestField("E-Invoice Status", TransferShipmentHeadder."E-Invoice Status"::Open);
        recFromLocation.Get(TransferShipmentHeadder."Transfer-from Code");
        recToLocation.Get(TransferShipmentHeadder."Transfer-to Code");
        recFromLocation.TestField("GST Registration No.");
        recToLocation.TestField("GST Registration No.");

        TransferShipmentHeadder.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
        if TransferShipmentHeadder."IGST Amount" + TransferShipmentHeadder."CGST Amount" + TransferShipmentHeadder."SGST Amount" = 0 then
            Error('GST Amount must not be zero.');

        txtAcessToken := GetAccessToken();

        TransferShipmentHeadder.CalcFields("Total Line Amount");
        decTotalLineAmount := TransferShipmentHeadder."Total Line Amount";
        decTotalIGSTAmount := TransferShipmentHeadder."IGST Amount";
        decTotalCGSTAmount := TransferShipmentHeadder."CGST Amount";
        decTotalSGSTAmount := TransferShipmentHeadder."SGST Amount";
        decTotalInvoiceAmount := decTotalLineAmount + decTotalIGSTAmount + decTotalSGSTAmount + decTotalCGSTAmount;

        recSalesSetup.Get();
        recSalesSetup.TestField("E-Invoice Generation API");
        blnEinvoiceTesting := false;
        if StrPos(UpperCase(recSalesSetup."E-Invoice Generation API"), 'CLIENTBASIC') <> 0 then
            blnEinvoiceTesting := true;

        //Start Json Creation
        jsonInvoice.Add('access_token', txtAcessToken);

        if blnEinvoiceTesting then
            jsonInvoice.Add('user_gstin', '09AAAPG7885R002')
        else
            jsonInvoice.Add('user_gstin', recFromLocation."GST Registration No.");
        jsonInvoice.Add('data_source', 'erp');

        //Transaction Details
        jsonTranDetails.Add('supply_type', 'B2B');
        jsonTranDetails.Add('charge_type', 'N');
        jsonInvoice.Add('transaction_details', jsonTranDetails);

        //Document Details
        jsonDocumentDetails.Add('document_type', 'INV');
        jsonDocumentDetails.Add('document_number', TransferShipmentHeadder."No.");

        if blnEinvoiceTesting then
            jsonDocumentDetails.Add('document_date', ConvertDate(Today))
        else
            jsonDocumentDetails.Add('document_date', ConvertDate(TransferShipmentHeadder."Posting Date"));

        jsonInvoice.Add('document_details', jsonDocumentDetails);

        //Seller Details
        recState.Get(recFromLocation."State Code");

        if blnEinvoiceTesting then begin
            jsonSellerDetails.Add('Gstin', '09AAAPG7885R002');
            jsonSellerDetails.Add('legal_name', recFromLocation.Name);
            jsonSellerDetails.Add('trade_name', recFromLocation.Name);
            jsonSellerDetails.Add('address1', recFromLocation.Address);
            jsonSellerDetails.Add('address2', recFromLocation."Address 2");
            jsonSellerDetails.Add('location', 'Noida');
            jsonSellerDetails.Add('pincode', '201301');
            jsonSellerDetails.Add('state_code', '09');
        end else begin
            jsonSellerDetails.Add('Gstin', recFromLocation."GST Registration No.");
            jsonSellerDetails.Add('legal_name', recFromLocation.Name);
            jsonSellerDetails.Add('trade_name', recFromLocation.Name);
            jsonSellerDetails.Add('address1', recFromLocation.Address);
            jsonSellerDetails.Add('address2', recFromLocation."Address 2");
            jsonSellerDetails.Add('location', recFromLocation.City);
            jsonSellerDetails.Add('pincode', recFromLocation."Post Code");
            jsonSellerDetails.Add('state_code', recState."State Code (GST Reg. No.)");
        end;
        jsonInvoice.Add('seller_details', jsonSellerDetails);

        //Buyer Details
        jsonBuyerDetails.Add('Gstin', recToLocation."GST Registration No.");
        jsonBuyerDetails.Add('legal_name', recToLocation.Name);
        jsonBuyerDetails.Add('trade_name', recToLocation.Name);
        jsonBuyerDetails.Add('address1', recToLocation.Address);
        jsonBuyerDetails.Add('address2', recToLocation."Address 2");
        jsonBuyerDetails.Add('location', recToLocation.City);

        recState.Get(recToLocation."State Code");
        jsonBuyerDetails.Add('pincode', recToLocation."Post Code");
        jsonBuyerDetails.Add('place_of_supply', recState."State Code (GST Reg. No.)");
        jsonBuyerDetails.Add('state_code', recState."State Code (GST Reg. No.)");
        jsonInvoice.Add('buyer_details', jsonBuyerDetails);

        //Value Details
        jsonValueDetails.Add('total_assessable_value', decTotalLineAmount);
        jsonValueDetails.Add('total_cgst_value', decTotalCGSTAmount);
        jsonValueDetails.Add('total_sgst_value', decTotalSGSTAmount);
        jsonValueDetails.Add('total_igst_value', decTotalIGSTAmount);
        jsonValueDetails.Add('total_cess_value', 0);
        jsonValueDetails.Add('total_cess_nonadvol_value', 0);
        jsonValueDetails.Add('total_invoice_value', decTotalInvoiceAmount);
        jsonValueDetails.Add('total_cess_value_of_state', 0);
        jsonValueDetails.Add('round_off_amount', 0);
        jsonValueDetails.Add('total_invoice_value_additional_currency', 0);
        jsonInvoice.Add('value_details', jsonValueDetails);

        //Item Details
        intEntryNo := 0;
        recTrfShipmentLines.RESET;
        recTrfShipmentLines.SETRANGE("Document No.", TransferShipmentHeadder."No.");
        recTrfShipmentLines.SETFILTER(Quantity, '<>%1', 0);
        IF recTrfShipmentLines.FindSet() THEN BEGIN
            REPEAT
                recTrfShipmentLines.CalcFields("IGST %", "CGST %", "SGST %");
                recTrfShipmentLines.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");

                Clear(jsonItemDetails);
                intEntryNo += 1;
                jsonItemDetails.Add('item_serial_number', intEntryNo);
                jsonItemDetails.Add('product_description', recTrfShipmentLines.Description);
                jsonItemDetails.Add('bar_code', recTrfShipmentLines."Item No.");
                jsonItemDetails.Add('free_quantity', 0);
                jsonItemDetails.Add('is_service', 'N');

                jsonItemDetails.Add('hsn_code', recTrfShipmentLines."HSN/SAC Code");
                jsonItemDetails.Add('quantity', Round(recTrfShipmentLines.Quantity, 0.001));
                jsonItemDetails.Add('unit', recTrfShipmentLines."Unit of Measure Code");
                jsonItemDetails.Add('unit_price', recTrfShipmentLines."Unit Price");
                jsonItemDetails.Add('total_amount', recTrfShipmentLines.Amount);
                jsonItemDetails.Add('discount', 0);

                jsonItemDetails.Add('other_charge', 0);
                jsonItemDetails.Add('assessable_value', recTrfShipmentLines.Amount);

                jsonItemDetails.Add('gst_rate', recTrfShipmentLines."IGST %" + recTrfShipmentLines."SGST %" + recTrfShipmentLines."CGST %");
                jsonItemDetails.Add('igst_amount', recTrfShipmentLines."IGST Amount");
                jsonItemDetails.Add('cgst_amount', recTrfShipmentLines."CGST Amount");
                jsonItemDetails.Add('sgst_amount', recTrfShipmentLines."SGST Amount");
                jsonItemDetails.Add('cess_rate', 0);
                jsonItemDetails.Add('cess_amount', 0);
                jsonItemDetails.Add('cess_nonadvol_amount', 0);
                jsonItemDetails.Add('state_cess_rate', 0);
                jsonItemDetails.Add('state_cess_amount', 0);
                jsonItemDetails.Add('state_cess_nonadvol_amount', 0);
                jsonItemDetails.Add('total_item_value', (recTrfShipmentLines.Amount + recTrfShipmentLines."IGST Amount" +
                                                                    recTrfShipmentLines."CGST Amount" + recTrfShipmentLines."SGST Amount"));
                jsonItemDetails.Add('order_line_reference', recTrfShipmentLines."Line No.");
                jsonItemDetails.Add('product_serial_number', recTrfShipmentLines."Line No.");

                jsonItemList.Add(jsonItemDetails);
            UNTIL recTrfShipmentLines.NEXT = 0;
            jsonInvoice.Add('item_list', jsonItemList);
        end;

        jsonInvoice.WriteTo(txtJsonText);
        txtJsonText := CallService('', recSalesSetup."E-Invoice Generation API", txtJsonText, '', '');
        cuJsonManagement.InitializeObject(txtJsonText);

        txtJsonText := cuJsonManagement.GetValue('results.message.Irn');
        if txtJsonText <> '' then begin
            RecRef.Open(5744);
            RecRef.GetTable(TransferShipmentHeadder);

            FieldRef := RecRef.Field(TransferShipmentHeadder.FieldNo("IRN Hash"));
            FieldRef.Value := txtJsonText;

            FieldRef := RecRef.Field(TransferShipmentHeadder.FieldNo("Acknowledgement No."));
            FieldRef.Value := cuJsonManagement.GetValue('results.message.AckNo');

            txtJsonText := cuJsonManagement.GetValue('results.message.AckDt');
            Evaluate(dtAckDate, CopyStr(txtJsonText, 1, 10));
            Evaluate(dtAckTime, CopyStr(txtJsonText, 11, 8));
            FieldRef := RecRef.Field(TransferShipmentHeadder.FieldNo("Acknowledgement Date"));
            FieldRef.Value := CreateDateTime(dtAckDate, dtAckTime);

            cuQRCodeGenerator.GenerateQRCodeImage(cuJSONManagement.GetValue('results.message.SignedQRCode'), cuTempBlob);
            FieldRef := RecRef.Field(TransferShipmentHeadder.FieldNo("QR Code"));
            cuTempBlob.ToRecordRef(RecRef, TransferShipmentHeadder.FieldNo("QR Code"));
            RecRef.Modify();

            recTrfShipmentHeader.Get(TransferShipmentHeadder."No.");
            recTrfShipmentHeader."E-Invoice Status" := recTrfShipmentHeader."E-Invoice Status"::Generated;
            recTrfShipmentHeader.Modify();
            Message('E-Invoice Generated.');
        end else
            ERROR('%1 Please share this request ID for support %2', cuJsonManagement.GetValue('results.errorMessage'), cuJsonManagement.GetValue('results.code'));
    end;

    procedure CancelEInvoiceTransferShipment(TransferShipmentHeader: Record "Transfer Shipment Header")
    var
        blnEinvoiceTesting: Boolean;
        txtAcessToken: Text;
        jsonInvoice: JsonObject;
        recSalesSetup: Record "Sales & Receivables Setup";
        recFromLocation: Record Location;
        txtJsonText: Text;
        dtCanDate: Date;
        dtCanTime: Time;
        cuJsonManagement: Codeunit "JSON Management";
        recTransferShipmentHeader: Record "Transfer Shipment Header";
    begin
        CheckEInvoiceCancellationPermission();

        TransferShipmentHeader.TestField("E-Invoice Status", TransferShipmentHeader."E-Invoice Status"::Generated);

        txtAcessToken := GetAccessToken();

        recSalesSetup.Get();
        recSalesSetup.TestField("E-Invoice Cancellation API");
        blnEinvoiceTesting := false;
        if StrPos(UpperCase(recSalesSetup."E-Invoice Cancellation API"), 'CLIENTBASIC') <> 0 then
            blnEinvoiceTesting := true;
        recFromLocation.Get(TransferShipmentHeader."Transfer-from Code");

        //Start Json Creation
        jsonInvoice.Add('access_token', txtAcessToken);

        if blnEinvoiceTesting then
            jsonInvoice.Add('user_gstin', '09AAAPG7885R002')
        else
            jsonInvoice.Add('user_gstin', recFromLocation."GST Registration No.");
        jsonInvoice.Add('irn', TransferShipmentHeader."IRN Hash");
        jsonInvoice.Add('cancel_reason', '1');
        jsonInvoice.Add('cancel_remarks', 'wrong entry');

        jsonInvoice.WriteTo(txtJsonText);
        txtJsonText := CallService('', recSalesSetup."E-Invoice Cancellation API", txtJsonText, '', '');
        cuJsonManagement.InitializeObject(txtJsonText);

        txtJsonText := cuJsonManagement.GetValue('results.status');
        if txtJsonText = 'Success' then begin
            recTransferShipmentHeader.Get(TransferShipmentHeader."No.");

            txtJsonText := cuJsonManagement.GetValue('results.message.CancelDate');
            Evaluate(dtCanDate, CopyStr(txtJsonText, 1, 10));
            Evaluate(dtCanTime, CopyStr(txtJsonText, 11, 8));
            recTransferShipmentHeader."E-Invoice Cancel Date" := CreateDateTime(dtCanDate, dtCanTime);
            recTransferShipmentHeader."E-Invoice Status" := recTransferShipmentHeader."E-Invoice Status"::Cancelled;
            recTransferShipmentHeader.Modify();
            Message('E-Invoice Cancelled.');
        end else
            ERROR('%1 Please share this request ID for support %2', cuJsonManagement.GetValue('results.errorMessage'), cuJsonManagement.GetValue('results.code'));
    end;

    procedure GenerateEWaySalesInvoice(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        txtAccessToken: Text;
        decCurrencyFactor: Decimal;
        decTotalInvoiceAmount: Decimal;
        decTotalLineAmount: Decimal;
        decTotalDiscountAmount: Decimal;
        decTotalIGSTAmount: Decimal;
        decTotalCGSTAmount: Decimal;
        decTotalSGSTAmount: Decimal;
        recSalesSetup: Record "Sales & Receivables Setup";
        blnEinvoiceTesting: Boolean;
        jsonInvoice: JsonObject;
        recLocation: Record Location;
        recState: Record State;
        recShipToAddress: Record "Ship-to Address";
        recTransportVendor: Record "Shipping Agent";
        recSalesInvoiceLines: Record "Sales Invoice Line";
        jsonItemDetails: JsonObject;
        jsonItemList: JsonArray;
        txtJsonText: Text;
        cuJsonManagement: Codeunit "JSON Management";
        recSalesInvoiceHeader: Record "Sales Invoice Header";
        txtEWayNo: Text[50];
    begin
        CheckEWayGenerationPermission();

        SalesInvoiceheader.TESTFIELD("E-Way Status", SalesInvoiceheader."E-Way Status"::Open);

        txtAccessToken := GetAccessToken();

        if SalesInvoiceHeader."Currency Code" <> '' then
            decCurrencyFactor := 1 / SalesInvoiceHeader."Currency Factor"
        else
            decCurrencyFactor := 1;

        SalesInvoiceHeader.CalcFields("IGST Amount", "CGST Amount", "SGST Amount");
        SalesInvoiceHeader.CalcFields("Total Line Amount", "Total Line Discount");
        decTotalLineAmount := Round(SalesInvoiceHeader."Total Line Amount" * decCurrencyFactor, 0.01);
        decTotalDiscountAmount := Round(SalesInvoiceHeader."Total Line Discount" * decCurrencyFactor, 0.01);
        decTotalIGSTAmount := Round(SalesInvoiceHeader."IGST Amount" * decCurrencyFactor, 0.01);
        decTotalCGSTAmount := Round(SalesInvoiceHeader."CGST Amount" * decCurrencyFactor, 0.01);
        decTotalSGSTAmount := Round(SalesInvoiceHeader."SGST Amount" * decCurrencyFactor, 0.01);
        decTotalInvoiceAmount := decTotalLineAmount + decTotalIGSTAmount + decTotalSGSTAmount + decTotalCGSTAmount;

        recSalesSetup.Get();
        recSalesSetup.TestField("E-Way Generation API");
        blnEinvoiceTesting := false;
        if StrPos(UpperCase(recSalesSetup."E-Way Generation API"), 'CLIENTBASIC') <> 0 then
            blnEinvoiceTesting := true;

        recLocation.GET(SalesInvoiceheader."Location Code");
        recState.GET(recLocation."State Code");

        //Start Json Creation
        jsonInvoice.Add('access_token', txtAccessToken);
        if blnEinvoiceTesting then
            jsonInvoice.Add('userGstin', '05AAABB0639G1Z8')
        else
            jsonInvoice.Add('userGstin', recLocation."GST Registration No.");

        jsonInvoice.Add('supply_type', 'outward');
        jsonInvoice.Add('sub_supply_type', 'Supply');
        jsonInvoice.Add('sub_supply_description', 'sales from other country');
        jsonInvoice.Add('document_type', 'tax invoice');
        jsonInvoice.Add('document_number', SalesInvoiceheader."No.");

        if blnEinvoiceTesting then
            jsonInvoice.Add('document_date', ConvertDate(Today))
        else
            jsonInvoice.Add('document_date', ConvertDate(SalesInvoiceheader."Posting Date"));

        if blnEinvoiceTesting then begin
            jsonInvoice.Add('gstin_of_consignor', '05AAABB0639G1Z8');
            jsonInvoice.Add('legal_name_of_consignor', recLocation.Name);
            jsonInvoice.Add('address1_of_consignor', recLocation.Address);
            jsonInvoice.Add('address2_of_consignor', recLocation."Address 2");
            jsonInvoice.Add('place_of_consignor', 'Dehradun');
            jsonInvoice.Add('pincode_of_consignor', '248001');
            jsonInvoice.Add('state_of_consignor', UPPERCASE(recState.Description));
            jsonInvoice.Add('actual_from_state_name', UPPERCASE(recState.Description));
        end else begin
            jsonInvoice.Add('gstin_of_consignor', recLocation."GST Registration No.");
            jsonInvoice.Add('legal_name_of_consignor', recLocation.Name);
            jsonInvoice.Add('address1_of_consignor', recLocation.Address);
            jsonInvoice.Add('address2_of_consignor', recLocation."Address 2");
            jsonInvoice.Add('place_of_consignor', recLocation.City);
            jsonInvoice.Add('pincode_of_consignor', recLocation."Post Code");
            jsonInvoice.Add('state_of_consignor', UPPERCASE(recState.Description));
            jsonInvoice.Add('actual_from_state_name', UPPERCASE(recState.Description));
        end;

        if SalesInvoiceHeader."Ship-to Code" = '' then begin
            IF SalesInvoiceheader."Customer GST Reg. No." <> '' THEN
                jsonInvoice.Add('gstin_of_consignee', SalesInvoiceheader."Customer GST Reg. No.")
            ELSE
                jsonInvoice.Add('gstin_of_consignee', 'URP');
            jsonInvoice.Add('legal_name_of_consignee', SalesInvoiceheader."Bill-to Name");
            jsonInvoice.Add('address1_of_consignee', SalesInvoiceheader."Bill-to Address");
            IF SalesInvoiceheader."Bill-to Address 2" = '' THEN
                jsonInvoice.Add('address2_of_consignee', SalesInvoiceheader."Bill-to Address")
            ELSE
                jsonInvoice.Add('address2_of_consignee', SalesInvoiceheader."Bill-to Address 2");
            jsonInvoice.Add('place_of_consignee', SalesInvoiceheader."Bill-to City");
            jsonInvoice.Add('pincode_of_consignee', SalesInvoiceheader."Bill-to Post Code");
            recState.GET(SalesInvoiceheader."GST Bill-to State Code");
            jsonInvoice.Add('state_of_supply', UPPERCASE(recState.Description));
            jsonInvoice.Add('actual_to_state_name', UPPERCASE(recState.Description));
            jsonInvoice.Add('transaction_type', '1');
        end;
        if SalesInvoiceHeader."Ship-to Code" <> '' then begin
            recShipToAddress.GET(SalesInvoiceheader."Sell-to Customer No.", SalesInvoiceheader."Ship-to Code");
            //Bill To Details
            IF SalesInvoiceheader."Customer GST Reg. No." <> '' THEN
                jsonInvoice.Add('gstin_of_consignee', SalesInvoiceheader."Customer GST Reg. No.")
            ELSE
                jsonInvoice.Add('gstin_of_consignee', 'URP');
            jsonInvoice.Add('legal_name_of_consignee', SalesInvoiceheader."Bill-to Name");
            recState.GET(SalesInvoiceheader."GST Bill-to State Code");
            jsonInvoice.Add('actual_to_state_name', UPPERCASE(recState.Description));

            //Ship to Details
            jsonInvoice.Add('address1_of_consignee', recShipToAddress.Name + ' GST No. ' + SalesInvoiceheader."Ship-to GST Reg. No.");
            jsonInvoice.Add('address2_of_consignee', recShipToAddress.Address + ' ' + recShipToAddress."Address 2");
            jsonInvoice.Add('place_of_consignee', recShipToAddress.City);
            jsonInvoice.Add('pincode_of_consignee', recShipToAddress."Post Code");

            recState.GET(SalesInvoiceheader."GST Ship-to State Code");
            jsonInvoice.Add('state_of_supply', UPPERCASE(recState.Description));
            jsonInvoice.Add('transaction_type', '2');
        end;

        jsonInvoice.Add('other_value', '0');
        jsonInvoice.Add('total_invoice_value', decTotalInvoiceAmount);
        jsonInvoice.Add('taxable_amount', decTotalLineAmount);
        jsonInvoice.Add('cgst_amount', decTotalCGSTAmount);
        jsonInvoice.Add('sgst_amount', decTotalSGSTAmount);
        jsonInvoice.Add('igst_amount', decTotalIGSTAmount);
        jsonInvoice.Add('cess_amount', '0');
        jsonInvoice.Add('cess_nonadvol_value', '0');

        recTransportVendor.Get(SalesInvoiceHeader."Shipping Agent Code");
        jsonInvoice.Add('transporter_id', recTransportVendor."GST Registration No.");
        jsonInvoice.Add('transporter_name', recTransportVendor.Name);
        jsonInvoice.Add('transporter_document_number', SalesInvoiceheader."LR/RR No.");
        jsonInvoice.Add('transporter_document_date', ConvertDateEWay(SalesInvoiceheader."Posting Date"));
        jsonInvoice.Add('transportation_mode', 'road');
        jsonInvoice.Add('transportation_distance', '0');

        jsonInvoice.Add('vehicle_number', DELCHR(SalesInvoiceheader."Vehicle No.", '=', ' '));
        jsonInvoice.Add('vehicle_type', 'Regular');
        jsonInvoice.Add('generate_status', '1');
        jsonInvoice.Add('data_source', 'erp');

        recSalesInvoiceLines.RESET;
        recSalesInvoiceLines.SETRANGE("Document No.", SalesInvoiceheader."No.");
        recSalesInvoiceLines.SetRange("System-Created Entry", false);
        recSalesInvoiceLines.SETFILTER(Quantity, '<>%1', 0);
        IF recSalesInvoiceLines.FINDFIRST THEN BEGIN
            REPEAT
                recSalesInvoiceLines.CalcFields("IGST %", "CGST %", "SGST %");
                Clear(jsonItemDetails);

                jsonItemDetails.Add('product_name', recSalesInvoiceLines."No.");
                jsonItemDetails.Add('product_description', recSalesInvoiceLines.Description);
                jsonItemDetails.Add('hsn_code', recSalesInvoiceLines."HSN/SAC Code");
                jsonItemDetails.Add('quantity', recSalesInvoiceLines.Quantity);
                jsonItemDetails.Add('unit', recSalesInvoiceLines."Unit of Measure Code");

                jsonItemDetails.Add('cgst_rate', recSalesInvoiceLines."CGST %");
                jsonItemDetails.Add('sgst_rate', recSalesInvoiceLines."SGST %");
                jsonItemDetails.Add('igst_rate', recSalesInvoiceLines."IGST %");

                jsonItemDetails.Add('cess_rate', '0');
                jsonItemDetails.Add('cessNonAdvol', '0');
                jsonItemDetails.Add('taxable_amount', recSalesInvoiceLines."Line Amount");

                jsonItemList.Add(jsonItemDetails);
            UNTIL recSalesInvoiceLines.NEXT = 0;
            jsonInvoice.Add('itemList', jsonItemList);
        END;

        jsonInvoice.WriteTo(txtJsonText);
        txtJsonText := CallService('', recSalesSetup."E-Way Generation API", txtJsonText, '', '');
        cuJsonManagement.InitializeObject(txtJsonText);

        txtEWayNo := cuJsonManagement.GetValue('results.message.ewayBillNo');
        if txtEWayNo <> '' then begin
            recSalesInvoiceHeader.Get(SalesInvoiceHeader."No.");
            recSalesInvoiceHeader."E-Way Bill No." := txtEWayNo;
            recSalesInvoiceHeader."E-Way Status" := recSalesInvoiceHeader."E-Way Status"::Generated;
            recSalesInvoiceHeader.Modify();
            MESSAGE('E-Way Generated');
        end else
            ERROR('Error - %1', cuJsonManagement.GetValue('results.message'));
    end;

    procedure CancelEWaySalesInvoice(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        txtAccessToken: Text;
        recSalesSetup: Record "Sales & Receivables Setup";
        blnEinvoiceTesting: Boolean;
        jsonInvoice: JsonObject;
        txtJsonText: Text;
        cuJsonManagement: Codeunit "JSON Management";
        recSalesInvHeader: Record "Sales Invoice Header";
        dtCanDate: Date;
        dtCanTime: Time;
        recLocation: Record Location;
    begin
        CheckEWayCancellationPermission();

        SalesInvoiceheader.TESTFIELD("E-Way Status", SalesInvoiceheader."E-Way Status"::Generated);
        txtAccessToken := GetAccessToken();

        recSalesSetup.Get();
        recSalesSetup.TestField("E-Invoice Cancellation API");
        blnEinvoiceTesting := false;
        if StrPos(UpperCase(recSalesSetup."E-Invoice Cancellation API"), 'CLIENTBASIC') <> 0 then
            blnEinvoiceTesting := true;

        recLocation.Get(SalesInvoiceHeader."Location Code");

        //Start Json Creation
        jsonInvoice.Add('access_token', txtAccessToken);

        if blnEinvoiceTesting then
            jsonInvoice.Add('userGstin', '09AAAPG7885R002')
        else
            jsonInvoice.Add('userGstin', recLocation."GST Registration No.");

        jsonInvoice.Add('eway_bill_number', SalesInvoiceheader."E-Way Bill No.");
        jsonInvoice.Add('reason_of_cancel', 'Others');
        jsonInvoice.Add('cancel_remark', 'Cancelled the order');
        jsonInvoice.Add('data_source', 'erp');

        jsonInvoice.WriteTo(txtJsonText);
        txtJsonText := CallService('', recSalesSetup."E-Invoice Cancellation API", txtJsonText, '', '');
        cuJsonManagement.InitializeObject(txtJsonText);

        txtJsonText := cuJsonManagement.GetValue('results.status');
        if txtJsonText = 'Success' then begin
            recSalesInvHeader.Get(SalesInvoiceHeader."No.");

            txtJsonText := cuJsonManagement.GetValue('results.message.cancelDate');
            Evaluate(dtCanDate, CopyStr(txtJsonText, 1, 10));
            Evaluate(dtCanTime, CopyStr(txtJsonText, 11, 8));
            recSalesInvHeader."E-Way Cancel Date" := CreateDateTime(dtCanDate, dtCanTime);
            recSalesInvHeader."E-Way Status" := recSalesInvHeader."E-Way Status"::Cancelled;
            recSalesInvHeader.Modify();
            Message('E-Way Cancelled.');
        end else
            ERROR('%1 Please share this request ID for support %2', cuJsonManagement.GetValue('results.errorMessage'), cuJsonManagement.GetValue('results.code'));
    end;

    local procedure ConvertDateEWay(PostingDate: Date) TextDate: Text
    var
        txtTemp: Text;
    begin
        txtTemp := FORMAT(DATE2DMY(PostingDate, 1));
        IF STRLEN(txtTemp) = 1 THEN
            TextDate := '0' + txtTemp
        ELSE
            TextDate := txtTemp;

        txtTemp := FORMAT(DATE2DMY(PostingDate, 2));
        IF STRLEN(txtTemp) = 1 THEN
            TextDate := TextDate + '/0' + txtTemp
        ELSE
            TextDate := TextDate + '/' + txtTemp;

        txtTemp := FORMAT(DATE2DMY(PostingDate, 3));
        IF STRLEN(txtTemp) = 2 THEN
            TextDate := TextDate + '/20' + txtTemp
        ELSE
            TextDate := TextDate + '/' + txtTemp;

    end;

    local procedure GetAccessToken() LoginToken: Text;
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        jsonLogin: JsonObject;
        jsonText: Text;
        txttoken: Text;
        jToken: JsonToken;
        jObject: JsonObject;
        jArray: JsonArray;
        intSeconds: Integer;
        txtSeconds: Text;

    begin
        recSalesSetup.GET;
        IF CURRENTDATETIME > recSalesSetup."E-Invoice Token Validity" THEN BEGIN
            jsonLogin.Add('username', recSalesSetup."E-Invoice User ID");
            jsonLogin.Add('password', recSalesSetup."E-Invoice Password");
            jsonLogin.Add('client_id', recSalesSetup."E-Invoicing Client ID");
            jsonLogin.Add('client_secret', recSalesSetup."E-Invoicing Client Secret");
            jsonLogin.Add('grant_type', 'password');
            jsonLogin.WriteTo(jsonText);
            txttoken := CallService('', recSalesSetup."E-Invoice Access Token API", jsonText, '', '');
            jToken.ReadFrom(txttoken);
            jObject := jToken.AsObject;

            jObject.SelectToken('access_token', jToken);
            recSalesSetup."E-Invoice Token" := jToken.AsValue().AsText();
            jObject.SelectToken('expires_in', jToken);
            txtSeconds := jToken.AsValue().AsText();
            Evaluate(intSeconds, txtSeconds);

            recSalesSetup."E-Invoice Token Validity" := CurrentDateTime + (intSeconds * 1000);
            recSalesSetup.Modify();
            exit(recSalesSetup."E-Invoice Token");
        end else
            exit(recSalesSetup."E-Invoice Token");
    end;

    local procedure ConvertDate(InputDate: Date) OutputDate: Text[11]
    var
        intDay: Integer;
        intYear: Integer;
        intMonth: Integer;
    begin
        OutputDate := '';

        IF FORMAT(InputDate) <> '' THEN BEGIN
            intDay := DATE2DMY(InputDate, 1);
            IF STRLEN(FORMAT(intDay)) = 1 THEN
                OutputDate := '0' + FORMAT(intDay)
            ELSE
                OutputDate := FORMAT(intDay);

            intMonth := Date2DMY(InputDate, 2);
            IF STRLEN(FORMAT(intMonth)) = 1 THEN
                OutputDate := OutputDate + '/' + '0' + FORMAT(intMonth)
            ELSE
                OutputDate := OutputDate + '/' + FORMAT(intMonth);

            intYear := DATE2DMY(InputDate, 3);
            IF STRLEN(FORMAT(intYear)) = 2 THEN
                OutputDate := OutputDate + '/20' + FORMAT(intYear)
            ELSE
                OutputDate := OutputDate + '/' + FORMAT(intYear);
        END;
    end;

    local procedure CallService(ProjectName: Text; RequestUrl: Text; payload: Text; Username: Text; Password: Text) ServiceResponse: Text
    var
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        contentHeaders: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        ResponseText: Text;

    begin
        RequestHeaders := Client.DefaultRequestHeaders();
        RequestContent.WriteFrom(payload);

        RequestContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        Client.Post(RequestURL, RequestContent, ResponseMessage);
        ResponseMessage.Content().ReadAs(ResponseText);
        exit(ResponseText);
    end;

    local procedure CheckEInvoiceGenerationPermission()
    var
        recUserPermission: Record "User Permission";
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 7);
        if not recUserPermission.FindFirst() then
            Error('You are not authorized to generate E Invoice, contact your system administrator.');
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to generate E Invoice, contact your system administrator.');
    end;

    procedure CheckEInvoiceCancellationPermission()
    var
        recUserPermission: Record "User Permission";
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 8);
        if not recUserPermission.FindFirst() then
            Error('You are not authorized to cancel E Invoice, contact your system administrator.');
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to cancel E Invoice, contact your system administrator.');
    end;

    procedure CheckEWayGenerationPermission()
    var
        recUserPermission: Record "User Permission";
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 5);
        if not recUserPermission.FindFirst() then
            Error('You are not authorized to generate E Way, contact your system administrator.');
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to generate E Way, contact your system administrator.');
    end;

    procedure CheckEWayCancellationPermission()
    var
        recUserPermission: Record "User Permission";
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 6);
        if not recUserPermission.FindFirst() then
            Error('You are not authorized to cancel E Way, contact your system administrator.');
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to cancel E Way, contact your system administrator.');
    end;
}
