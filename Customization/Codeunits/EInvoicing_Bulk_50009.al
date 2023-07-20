codeunit 50009 "E-Invoice Bulk"
{
    TableNo = 112;
    Permissions = tabledata "Sales Invoice Header" = rm,
                    tabledata "Sales Cr.Memo Header" = rm;

    trigger OnRun()
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
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        CheckEInvoiceGenerationPermission();

        SalesInvoiceHeader.Get(Rec."No.");

        SalesInvoiceHeader.TestField("E-Invoice Status", SalesInvoiceHeader."E-Invoice Status"::Open);
        recCustomer.Get(SalesInvoiceHeader."Bill-to Customer No.");
        if SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Registered then
            opInvoiceType := opInvoiceType::Registered;
        //if SalesInvoiceHeader."GST Customer Type" in [SalesInvoiceHeader."GST Customer Type"::Export] then
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
            Commit();
            // recSalesInvHeader.Get(SalesInvoiceHeader."No.");
            // recSalesInvHeader."E-Invoice Status" := recSalesInvHeader."E-Invoice Status"::Generated;
            // recSalesInvHeader.Modify();
            //Message('E-Invoice Generated.');
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
            ERROR(txtErrorMsg);
        end;
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

}