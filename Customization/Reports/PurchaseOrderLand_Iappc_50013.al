report 50013 "Purchase Order Landscape"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\PurchaseOrderLand_Iappc_50013.rdl';

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
            column(CompanyCIN; recCompanyInfo."Registration No.") { }
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
            column(PartyCountry; txtVendorCountry) { }
            column(PartyPANNo; recVendor."P.A.N. No.") { }
            column(PartyGSTRegNo; "Purchase Header"."Vendor GST Reg. No.") { }
            column(AmountInWords; txtAmountInWords[1] + txtAmountInWords[2]) { }
            column(Term1; 'Term 1') { }
            column(Term2; 'Term 2') { }
            column(Term3; 'Term 3') { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending);
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");

                column(SrNo; intSrNo) { }
                column(ItemNo; "Purchase Line"."No.") { }
                column(ItemName; "Purchase Line".Description) { }
                column(LineQuantity; "Purchase Line".Quantity) { }
                column(UnitOfMeasure; "Purchase Line"."Unit of Measure Code") { }
                column(UnitRate; "Purchase Line"."Direct Unit Cost") { }
                column(LineAmount; "Purchase Line".Quantity * "Purchase Line"."Direct Unit Cost") { }
                column(DiscountAmount; "Purchase Line"."Line Discount Amount") { }
                column(TaxableAmount; "Purchase Line"."Line Amount") { }
                column(IGSTPerc; decIGSTPerc) { }
                column(IGSTAmount; decIGSTAmount) { }
                column(CGSTPerc; decCGSTPerc) { }
                column(CGSTAmount; decCGSTAmount) { }
                column(SGSTPerc; decSGSTPerc) { }
                column(SGSTAmount; decSGSTAmount) { }
                column(TotalAmount; "Purchase Line"."Line Amount" + decIGSTAmount + decCGSTAmount + decSGSTAmount) { }

                trigger OnPreDataItem()
                begin
                    intSrNo := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    intSrNo += 1;
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
            trigger OnPreDataItem()
            begin
                recCompanyInfo.Get();
                recCompanyInfo.CalcFields(Picture);
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

                txtShipToCountry := '';
                txtShipToState := '';
                if recState.Get(recLocation."State Code") then
                    txtShipToState := recState.Description;
                if recCountry.Get(recLocation."Country/Region Code") then
                    txtShipToCountry := recCountry.Name;

                txtVendorCountry := '';
                txtVendorState := '';
                if recState.Get(recVendor."State Code") then
                    txtVendorState := recState.Description;
                if recCountry.Get(recVendor."Country/Region Code") then
                    txtVendorCountry := recCountry.Name;

                if "Currency Code" = '' then
                    txtCurrency := 'Amount in INR'
                else
                    txtCurrency := 'Amount in ' + "Currency Code";

                txtPaymentTerms := '';
                if recPaymentTerm.Get("Payment Terms Code") then
                    txtPaymentTerms := recPaymentTerm.Description;

                decTotalOrderValue := 0;
                recPurchaseLine.Reset();
                recPurchaseLine.SetRange("Document Type", "Purchase Header"."Document Type");
                recPurchaseLine.SetRange("Document No.", "Purchase Header"."No.");
                recPurchaseLine.FindFirst();
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
                    decTotalOrderValue += recPurchaseLine."Line Amount" + decIGSTAmount + decCGSTAmount + decSGSTAmount;
                until recPurchaseLine.Next() = 0;

                Clear(cuProcess);
                cuProcess.InitTextVariable();
                cuProcess.FormatNoText(txtAmountInWords, decTotalOrderValue, "Purchase Header"."Currency Code");
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
        decIGSTPerc: Decimal;
        decSGSTPerc: Decimal;
        decCGSTPerc: Decimal;
        recTaxTransactions: Record "Tax Transaction Value";
        decIGSTAmount: Decimal;
        decCGSTAmount: Decimal;
        decSGSTAmount: Decimal;
}