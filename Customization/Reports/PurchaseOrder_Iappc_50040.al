report 50040 "Purchase Order"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Purchase Order';
    RDLCLayout = 'Customization\Reports\PurchaseOrder_Iappc_50040.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");

            column(CompanyLogo; recCompanyInfo.Picture) { }
            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; txtHeading) { }
            column(OrderStatus; '') { }
            column(FormalName; 'Formerly known as ' + recCompanyInfo."Name 2") { }
            column(CompanyAddress; recLocation.Address) { }
            column(CompanyAddress1; recLocation."Address 2") { }
            column(CompanyCity; recLocation.City) { }
            column(CompanyPostCode; recLocation."Post Code") { }
            column(CompanyState; txtCompanyState) { }
            column(CompanyCountry; txtCompanyCountry) { }
            column(CompanyPhoneNo; 'Phone No. : ' + recCompanyInfo."Phone No.") { }
            column(CompanyGST; "Purchase Header"."Location GST Reg. No.") { }
            column(CompanyCIN; recCompanyInfo."C.I.N. No.") { }
            column(CompanyStateCode; cdCompanyStateCode) { }
            column(CompanyPAN; recCompanyInfo."P.A.N. No.") { }
            column(DeliveryAddress; txtDeliveryAddress[1]) { }
            column(DeliveryAddress1; txtDeliveryAddress[2]) { }
            column(DeliveryCity; txtDeliveryAddress[3]) { }
            column(DeliveryPostCode; txtDeliveryAddress[4]) { }
            column(DeliveryState; txtDeliveryAddress[5]) { }
            column(DeliveryCountry; txtDeliveryAddress[6]) { }
            column(DeliveryPhoneNo; 'Phone No. : ' + txtDeliveryAddress[7]) { }
            column(VendorNo; "Purchase Header"."Buy-from Vendor No.") { }
            column(VendorName; recVendor.Name) { }
            column(VendorAddress; recVendor.Address) { }
            column(VendorAddress1; recVendor."Address 2") { }
            column(VendorCity; recVendor.City) { }
            column(VendorPostCode; recVendor."Post Code") { }
            column(VendorState; txtVendorState) { }
            column(VendorCountry; txtVendorCountry) { }
            column(VendorPAN; recVendor."P.A.N. No.") { }
            column(VendorGST; "Purchase Header"."Vendor GST Reg. No.") { }
            column(VendorStateCode; cdVendorStateCode) { }
            column(VendorPhone; 'Phone No. : ' + recVendor."Phone No.") { }
            column(VendorContact; recVendor.Contact) { }
            column(PurchOrderNo; "Purchase Header"."No.") { }
            column(PurchOrderDate; Format("Purchase Header"."Order Date")) { }
            column(AmendmentVersionNo; cdAmendmentNo) { }
            column(AmendmentDate; Format(dtAmendmentDate)) { }
            column(PaymentTerm; recPaymentTerm.Description) { }
            column(FreightType; '') { }
            column(AmountInWords; txtAmountInWords[1] + ' ' + txtAmountInWords[2]) { }
            column(GeneralTerm1; txtGeneralTerms[1]) { }
            column(GeneralTerm2; txtGeneralTerms[2]) { }
            column(GeneralTerm3; txtGeneralTerms[3]) { }
            column(GeneralTerm4; txtGeneralTerms[4]) { }
            column(GeneralTerm5; txtGeneralTerms[5]) { }
            column(GeneralTerm6; txtGeneralTerms[6]) { }
            column(GeneralTerm7; txtGeneralTerms[7]) { }
            column(GeneralTerm8; txtGeneralTerms[8]) { }
            column(PORemarks; '') { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending);
                DataItemLink = "Document Type" = Field("Document Type"), "Document No." = FIELD("No.");

                column(LineNo; "Purchase Line"."Line No.") { }
                column(SrNo; intLineCounter) { }
                column(LineDescription; "Purchase Line"."No." + ' - ' + "Purchase Line".Description) { }
                column(PartNo; 'Item No. : ' + "Purchase Line"."No.") { }
                column(HSNCocde; "Purchase Line"."HSN/SAC Code") { }
                column(DeliveryDate; Format("Purchase Line"."Requested Receipt Date")) { }
                column(LineQuantity; "Purchase Line".Quantity) { }
                column(UOM; "Purchase Line"."Unit of Measure Code") { }
                column(UnitRate; "Purchase Line"."Direct Unit Cost") { }
                column(DiscountAmount; "Purchase Line"."Line Discount Amount") { }
                column(TaxableValue; "Purchase Line"."Line Amount") { }
                column(IGSTPerc; decIGSTPerc) { }
                column(CGSTPerc; decCGSTPerc) { }
                column(SGSTPerc; decSGSTPerc) { }
                column(ISGTAmount; decIGSTAmount) { }
                column(CSGTAmount; decCGSTAmount) { }
                column(SSGTAmount; decSGSTAmount) { }
                column(TotalLiveValue; "Purchase Line"."Line Amount" + decIGSTAmount + decCGSTAmount + decSGSTAmount) { }

                trigger OnPreDataItem()
                begin
                    intLineCounter := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    intLineCounter += 1;

                    if not recItem.Get("Purchase Line"."No.") then
                        recItem.Init();
                    if "Purchase Line".Type = "Purchase Line".Type::Item then
                        "Purchase Line".TestField("Requested Receipt Date");

                    decCGSTPerc := 0;
                    decIGSTPerc := 0;
                    decSGSTPerc := 0;
                    decIGSTAmount := 0;
                    decCGSTAmount := 0;
                    decSGSTAmount := 0;
                    recTaxTransactions.Reset();
                    recTaxTransactions.SetRange("Tax Record ID", "Purchase Line".RecordId);
                    recTaxTransactions.SetRange("Tax Type", 'GST');
                    recTaxTransactions.SetRange("Value Type", recTaxTransactions."Value Type"::COMPONENT);
                    recTaxTransactions.SetRange("Value ID", 2);
                    if recTaxTransactions.FindFirst() then begin
                        decCGSTAmount := recTaxTransactions."Amount (LCY)";
                        decCGSTPerc := recTaxTransactions.Percent;
                    end;
                    recTaxTransactions.SetRange("Value ID", 3);
                    if recTaxTransactions.FindFirst() then begin
                        decIGSTAmount := recTaxTransactions."Amount (LCY)";
                        decIGSTPerc := recTaxTransactions.Percent;
                    end;
                    recTaxTransactions.SetRange("Value ID", 6);
                    if recTaxTransactions.FindFirst() then begin
                        decSGSTAmount := recTaxTransactions."Amount (LCY)";
                        decSGSTPerc := recTaxTransactions.Percent;
                    end;
                end;
            }
            dataitem(BlankLines; Integer)
            {
                DataItemTableView = sorting(Number);

                column(BlankLineNo; BlankLines.Number) { }

                trigger OnAfterGetRecord()
                begin
                    intLineCounter += 1;
                    if intLineCounter > 3 then
                        CurrReport.Break();
                end;
            }

            trigger OnPreDataItem()
            begin
                recCompanyInfo.Get();
                recCompanyInfo.CalcFields(Picture);
                txtGeneralTerms[1] := '1. Time is essence of this order and delivery must be made as per delivery schedules unless otherwise deferred by us in writing.';
                txtGeneralTerms[2] := '2. Please acknowledge the acceptance on receipt of our purchase order.';
                txtGeneralTerms[3] := '3. It is sole responsibility of suppliers to deliver the consignment material in good condition at consignee location.';
                txtGeneralTerms[4] := '4. In the event, the supplier fails to deliver the Goods of the ordered quantity or deliver different and / ' +
                'or substandard make / quality, the company reserves the right to reject the Material and inform the supplier to lift the material from our site at his own cost.' +
                ' Incoming freight, if any, paid for these shall also be recovered. Breakage / Loss if any during transit due to poor packing or handling shall be on suppliers account.';
                txtGeneralTerms[5] := '5. PO no, GST no & Pan no should be mentioned on all respective consignment documents.';
                txtGeneralTerms[6] := '6. Test certificates /Certificate of analysis should accompany the goods as applicable. The material should be RoHS compliant where ever it''''s applicable.';
                txtGeneralTerms[7] := '7. All Documents / Queries should be sent to Correspondence address as given above.';
                txtGeneralTerms[8] := '8. Subject To Exclusive Jurisdiction at Alwar';
            end;

            trigger OnAfterGetRecord()
            begin
                txtHeading := 'Purchase Order';
                if "Purchase Header".Status <> "Purchase Header".Status::Released then begin
                    txtHeading := 'Draft - Purchase Order';
                    //recCompanyInfo.CalcFields("Draft Image");
                end;

                Clear(txtDeliveryAddress);
                if "Purchase Header"."Location Code" <> '' then begin
                    recLocation.Get("Purchase Header"."Location Code");
                    txtDeliveryAddress[1] := recLocation.Address;
                    txtDeliveryAddress[2] := recLocation."Address 2";
                    txtDeliveryAddress[3] := recLocation.City;
                    txtDeliveryAddress[4] := recLocation."Post Code";

                    if recState.Get(recLocation."State Code") then
                        txtDeliveryAddress[5] := recState.Description;
                    if recCountry.Get(recLocation."Country/Region Code") then
                        txtDeliveryAddress[6] := txtCompanyCountry;
                    txtDeliveryAddress[7] := recLocation."Phone No.";
                end;

                recLocation.Get("Purchase Header"."Location Code");
                recVendor.Get("Purchase Header"."Buy-from Vendor No.");
                cdAmendmentNo := '';
                dtAmendmentDate := 0D;
                "Purchase Header".CalcFields("No. of Archived Versions");
                if "Purchase Header"."No. of Archived Versions" <> 0 then begin
                    cdAmendmentNo := Format("Purchase Header"."No. of Archived Versions");

                    recPurchHeaderArchive.Reset();
                    recPurchHeaderArchive.SetRange("Document Type", "Purchase Header"."Document Type");
                    recPurchHeaderArchive.SetRange("No.", "Purchase Header"."No.");
                    recPurchHeaderArchive.FindLast();
                    dtAmendmentDate := recPurchHeaderArchive."Date Archived";
                end;

                if not recPaymentTerm.Get("Purchase Header"."Payment Terms Code") then
                    recPaymentTerm.Init();

                txtCompanyState := '';
                txtCompanyCountry := '';
                cdCompanyStateCode := '';
                if recState.Get(recLocation."State Code") then begin
                    txtCompanyState := recState.Description;
                    cdCompanyStateCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get(recLocation."Country/Region Code") then
                    txtCompanyCountry := recCountry.Name;

                if "Purchase Header"."Location Code" = '' then begin
                    txtDeliveryAddress[1] := recLocation.Address;
                    txtDeliveryAddress[2] := recLocation."Address 2";
                    txtDeliveryAddress[3] := recLocation.City;
                    txtDeliveryAddress[4] := recLocation."Post Code";
                    txtDeliveryAddress[5] := txtCompanyState;
                    txtDeliveryAddress[6] := txtCompanyCountry;
                    txtDeliveryAddress[7] := recLocation."Phone No.";
                end;

                txtVendorState := '';
                txtVendorCountry := '';
                cdVendorStateCode := '';
                if recState.Get("Purchase Header".State) then begin
                    txtVendorState := recState.Description;
                    cdVendorStateCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get("Purchase Header"."Buy-from Country/Region Code") then
                    txtVendorCountry := recCountry.Name;

                decCGSTAmount := 0;
                decSGSTAmount := 0;
                decIGSTAmount := 0;
                decTotalValue := 0;
                intLineCounter := 0;
                recPurchaseLine.Reset();
                recPurchaseLine.SetRange("Document Type", "Purchase Header"."Document Type");
                recPurchaseLine.SetRange("Document No.", "Purchase Header"."No.");
                if recPurchaseLine.FindFirst() then begin
                    repeat
                        decIGSTAmount := 0;
                        decCGSTAmount := 0;
                        decSGSTAmount := 0;
                        recTaxTransactions.Reset();
                        recTaxTransactions.SetRange("Tax Record ID", recPurchaseLine.RecordId);
                        recTaxTransactions.SetRange("Tax Type", 'GST');
                        recTaxTransactions.SetRange("Value Type", recTaxTransactions."Value Type"::COMPONENT);
                        recTaxTransactions.SetRange("Value ID", 2);
                        if recTaxTransactions.FindFirst() then begin
                            decCGSTAmount := recTaxTransactions."Amount (LCY)";
                        end;
                        recTaxTransactions.SetRange("Value ID", 3);
                        if recTaxTransactions.FindFirst() then begin
                            decIGSTAmount := recTaxTransactions."Amount (LCY)";
                        end;
                        recTaxTransactions.SetRange("Value ID", 6);
                        if recTaxTransactions.FindFirst() then begin
                            decSGSTAmount := recTaxTransactions."Amount (LCY)";
                        end;
                        decTotalValue += recPurchaseLine."Line Amount" + Round(decIGSTAmount + decCGSTAmount + decSGSTAmount, 0.01);
                    until recPurchaseLine.Next() = 0;

                    cuProcess.InitTextVariable();
                    Clear(txtAmountInWords);
                    cuProcess.FormatNoText(txtAmountInWords, decTotalValue, "Purchase Header"."Currency Code");
                end;
            end;
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        recLocation: Record Location;
        txtCompanyState: Text[50];
        txtCompanyCountry: Text[50];
        cdCompanyStateCode: Code[2];
        recVendor: Record Vendor;
        txtVendorState: Text[50];
        txtVendorCountry: Text[50];
        cdVendorStateCode: Code[2];
        intLineCounter: Integer;
        recState: Record State;
        recCountry: Record "Country/Region";
        decTotalValue: Decimal;
        recPurchaseLine: Record "Purchase Line";
        cuProcess: Codeunit "Process Flow";
        txtAmountInWords: array[2] of Text[80];
        txtGeneralTerms: array[8] of Text;
        cdAmendmentNo: Code[10];
        dtAmendmentDate: Date;
        recPurchHeaderArchive: Record "Purchase Header Archive";
        recPaymentTerm: Record "Payment Terms";
        recItem: Record Item;
        decIGSTPerc: Decimal;
        decSGSTPerc: Decimal;
        decCGSTPerc: Decimal;
        recTaxTransactions: Record "Tax Transaction Value";
        decIGSTAmount: Decimal;
        decCGSTAmount: Decimal;
        decSGSTAmount: Decimal;
        txtHeading: Text;
        txtDeliveryAddress: array[7] of Text[100];
}