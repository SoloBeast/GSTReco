report 50014 "Purchase Order Portrait"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\PurchaseOrderPortrait_Iappc_50014.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));

            column(CompanyName; recCompanyInfo.Name) { }
            column(CompanyLogo; recCompanyInfo.Picture) { }
            column(CompanyAddress; recCompanyInfo.Address) { }
            column(CompanyAddress2; recCompanyInfo."Address 2") { }
            column(CompanyCity; recCompanyInfo.City) { }
            column(CompanyPostCode; recCompanyInfo."Post Code") { }
            column(CompanyState; txtCompanyState) { }
            column(CompanyCountry; txtCompanyCountry) { }
            column(CompanyPhone; recCompanyInfo."Phone No.") { }
            column(CompanyEmail; recCompanyInfo."E-Mail") { }
            column(CompanyCIN; recCompanyInfo."C.I.N. No.") { }
            column(CompanyPAN; recCompanyInfo."P.A.N. No.") { }
            column(CompanyHomePage; recCompanyInfo."Home Page") { }
            column(ShiptoCode; "Purchase Header"."Location Code") { }
            column(ShipToName; recLocation.Name) { }
            column(ShipToAddress; recLocation.Address) { }
            column(ShipToAddress2; recLocation."Address 2") { }
            column(ShipToCity; recLocation.City) { }
            column(ShipToPostCode; recLocation."Post Code") { }
            column(ShipToState; txtShipToState) { }
            column(ShipToCountry; txtShipToCountry) { }
            column(ShipToGSTRegNo; "Purchase Header"."Location GST Reg. No.") { }
            column(PlaceOfSupply; cdPlaceOfSupply) { }
            column(Heading; txtHeading) { }
            column(DocumentNo; "Purchase Header"."No.") { }
            column(DocumentDate; Format("Purchase Header"."Order Date")) { }
            column(CurrencyCode; txtCurrency) { }
            column(PaymentTerm; txtPaymentTerms) { }
            column(PartyNo; "Purchase Header"."Buy-from Vendor No.") { }
            column(PartyName; "Purchase Header"."Buy-from Vendor Name") { }
            column(PartyAddress; "Purchase Header"."Buy-from Address") { }
            column(PartyAddress2; "Purchase Header"."Buy-from Address 2") { }
            column(PartyCity; "Purchase Header"."Buy-from City") { }
            column(PartyPostCode; "Purchase Header"."Buy-from Post Code") { }
            column(PartyState; txtVendorState) { }
            column(PartyStateGSTCode; txtVendorGSTStateCode) { }
            column(PartyCountry; txtVendorCountry) { }
            column(PartyPANNo; recVendor."P.A.N. No.") { }
            column(PartyGSTRegNo; "Purchase Header"."Vendor GST Reg. No.") { }
            column(VendorEmail; recVendor."E-Mail") { }
            column(IGST_Amount; decTotalIGSTAmount) { }
            column(CGST_Amount; decTotalCGSTAmount) { }
            column(SGST_Amount; decTotalSGSTAmount) { }
            column(AmountInWords; txtAmountInWords[1] + txtAmountInWords[2]) { }
            column(Term1; recPurchSetup."Term 1") { }
            column(Term2; recPurchSetup."Term 2") { }
            column(Term3; recPurchSetup."Term 3") { }
            column(Term4; "Purchase Header"."PO Term 1") { }
            column(Term5; "Purchase Header"."PO Term 2") { }
            column(RoundOff; decRoundOff) { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending);
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");

                column(SrNo; intSrNo) { }
                column(ItemNo; "Purchase Line"."No.") { }
                column(ItemName; txtLineDescription) { }
                column(LineQuantity; "Purchase Line".Quantity) { }
                column(UnitOfMeasure; "Purchase Line"."Unit of Measure Code") { }
                column(UnitRate; "Purchase Line"."Direct Unit Cost") { }
                column(LineAmount; "Purchase Line".Quantity * "Purchase Line"."Direct Unit Cost") { }
                column(DiscountAmount; "Purchase Line"."Line Discount Amount") { }
                column(TaxableAmount; "Purchase Line"."Line Amount") { }
                column(IGSTPerc; decGSTPerc) { }
                column(LineGSTAmount; decLineGSTAmount) { }
                column(HSNSACCode; "Purchase Line"."HSN/SAC Code") { }
                column(TotalAmount; "Purchase Line"."Line Amount") { }
                column(TotalOrderValue; decTotalOrderValueh) { }

                trigger OnPreDataItem()
                begin
                    intSrNo := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    intSrNo += 1;

                    if "Purchase Line"."Description 2" = '' then
                        txtLineDescription := "Purchase Line".Description
                    else
                        txtLineDescription := "Purchase Line"."Description 2";

                    decGSTPerc := 0;
                    decLineGSTAmount := 0;
                    recTaxTransactions.Reset();
                    recTaxTransactions.SetRange("Tax Record ID", "Purchase Line".RecordId);
                    recTaxTransactions.SetRange("Tax Type", 'GST');
                    recTaxTransactions.SetRange("Value Type", recTaxTransactions."Value Type"::COMPONENT);
                    recTaxTransactions.SetRange("Value ID", 2);
                    if recTaxTransactions.FindFirst() then begin
                        decGSTPerc := recTaxTransactions.Percent;
                        decLineGSTAmount := recTaxTransactions."Amount (LCY)";
                    end;
                    recTaxTransactions.SetRange("Value ID", 3);
                    if recTaxTransactions.FindFirst() then begin
                        decGSTPerc += recTaxTransactions.Percent;
                        decLineGSTAmount += recTaxTransactions."Amount (LCY)";
                    end;
                    recTaxTransactions.SetRange("Value ID", 6);
                    if recTaxTransactions.FindFirst() then begin
                        decGSTPerc += recTaxTransactions.Percent;
                        decLineGSTAmount += recTaxTransactions."Amount (LCY)";
                    end;
                end;
            }
            trigger OnPreDataItem()
            begin
                recCompanyInfo.Get();
                recCompanyInfo.CalcFields(Picture);
                recPurchSetup.Get();

                txtCompanyCountry := '';
                txtCompanyState := '';
                if recState.Get(recCompanyInfo."State Code") then
                    txtCompanyState := recState.Description;
                if recCountry.Get(recCompanyInfo."Country/Region Code") then
                    txtCompanyCountry := recCountry.Name;
            end;

            trigger OnAfterGetRecord()
            begin
                recLocation.Get("Purchase Header"."Location Code");
                recVendor.Get("Buy-from Vendor No.");

                if recLocation."GST Registration No." <> '' then
                    cdPlaceOfSupply := CopyStr(recLocation."GST Registration No.", 1, 2);

                txtShipToCountry := '';
                txtShipToState := '';

                if recState.Get(recLocation."State Code") then begin
                    txtShipToState := recState.Description;

                end;
                if recCountry.Get(recLocation."Country/Region Code") then
                    txtShipToCountry := recCountry.Name;

                txtVendorCountry := '';
                txtVendorState := '';
                txtVendorGSTStateCode := '';
                if recState.Get(recVendor."State Code") then begin
                    txtVendorState := recState.Description;
                    txtVendorGSTStateCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get(recVendor."Country/Region Code") then
                    txtVendorCountry := recCountry.Name;

                if "Purchase Header".Status <> "Purchase Header".Status::Released then
                    txtHeading := 'Draft Purchase Order'
                else
                    txtHeading := 'Purchase Order';

                if "Currency Code" = '' then
                    txtCurrency := 'Amount in INR'
                else
                    txtCurrency := 'Amount in ' + "Currency Code";

                txtPaymentTerms := '';
                if recPaymentTerm.Get("Payment Terms Code") then
                    txtPaymentTerms := recPaymentTerm.Description;

                decTotalOrderValue := 0;
                decTotalIGSTAmount := 0;
                decTotalSGSTAmount := 0;
                decTotalCGSTAmount := 0;
                recPurchaseLine.Reset();
                recPurchaseLine.SetRange("Document Type", "Purchase Header"."Document Type");
                recPurchaseLine.SetRange("Document No.", "Purchase Header"."No.");
                recPurchaseLine.FindFirst();
                repeat
                    recTaxTransactions.Reset();
                    recTaxTransactions.SetRange("Tax Record ID", recPurchaseLine.RecordId);
                    recTaxTransactions.SetRange("Tax Type", 'GST');
                    recTaxTransactions.SetRange("Value Type", recTaxTransactions."Value Type"::COMPONENT);
                    recTaxTransactions.SetRange("Value ID", 2);
                    if recTaxTransactions.FindFirst() then begin
                        decTotalCGSTAmount += recTaxTransactions."Amount (LCY)";
                    end;
                    recTaxTransactions.SetRange("Value ID", 3);
                    if recTaxTransactions.FindFirst() then begin
                        decTotalIGSTAmount += recTaxTransactions."Amount (LCY)";
                    end;
                    recTaxTransactions.SetRange("Value ID", 6);
                    if recTaxTransactions.FindFirst() then begin
                        decTotalSGSTAmount += recTaxTransactions."Amount (LCY)";
                    end;
                    decTotalOrderValue += recPurchaseLine."Line Amount";
                until recPurchaseLine.Next() = 0;
                decTotalOrderValue += decTotalCGSTAmount + decTotalIGSTAmount + decTotalSGSTAmount;

                decTotalOrderValueh := Round(decTotalOrderValue, 1, '=');
                decRoundOff := decTotalOrderValueh - decTotalOrderValue;
                Clear(cuProcess);
                cuProcess.InitTextVariable();
                cuProcess.FormatNoText(txtAmountInWords, decTotalOrderValueh, "Purchase Header"."Currency Code");
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
        txtAmountInWords: array[2] of Text[80];
        txtCurrency: Text[30];
        txtShipToState: Text[50];
        txtShipToCountry: Text[50];
        txtVendorState: Text[50];
        txtVendorCountry: Text[50];
        recVendor: Record Vendor;
        recPaymentTerm: Record "Payment Terms";
        txtPaymentTerms: Text[50];
        intSrNo: Integer;
        cuProcess: Codeunit "Process Flow";
        recPurchaseLine: Record "Purchase Line";
        decTotalOrderValue: Decimal;
        decGSTPerc: Decimal;
        decTotalIGSTAmount: Decimal;
        decTotalCGSTAmount: Decimal;
        decTotalSGSTAmount: Decimal;
        recTaxTransactions: Record "Tax Transaction Value";
        recPurchSetup: Record "Purchases & Payables Setup";
        txtHeading: Text[30];
        txtLineDescription: Text[100];
        txtVendorGSTStateCode: Text;
        decLineGSTAmount: Decimal;
        cdPlaceOfSupply: Code[20];
        decTotalOrderValueh: Decimal;
        decRoundOff: Decimal;
}