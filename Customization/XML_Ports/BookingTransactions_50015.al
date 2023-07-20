xmlport 50015 "Booking Transactions"
{
    Caption = 'Booking Transactions';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(BookingTransctions)
        {
            MinOccurs = Zero;
            tableelement("Booking Transactions"; "Booking Transactions")
            {
                AutoSave = false;
                XmlName = 'BookingTransctions';

                textelement(BookingDate)
                {
                    MinOccurs = Zero;
                }
                textelement(JourneyDate)
                {
                    MinOccurs = Zero;
                }
                textelement(PNRNo)
                {
                    MinOccurs = Zero;
                }
                textelement(CollectionMode)
                {
                    MinOccurs = Zero;
                }
                textelement(CollectRefTally)
                {
                    MinOccurs = Zero;
                }
                textelement(SupplierType)
                {
                    MinOccurs = Zero;
                }
                textelement(VendorNo)
                {
                    MinOccurs = Zero;
                }
                textelement(SupplierNameTechnical)
                {
                    MinOccurs = Zero;
                }
                textelement(OperatorName)
                {
                    MinOccurs = Zero;
                }
                textelement(TypeofSales)
                {
                    MinOccurs = Zero;
                }
                textelement(SellerNameOrderID)
                {
                    MinOccurs = Zero;
                }
                textelement(PGReferenceNo)
                {
                    MinOccurs = Zero;
                }
                textelement(ModeofPayment)
                {
                    MinOccurs = Zero;
                }
                textelement(ECO)
                {
                    MinOccurs = Zero;
                }
                textelement(ECOGSTIN)
                {
                    MinOccurs = Zero;
                }
                textelement(OperatorGSTIN)
                {
                    MinOccurs = Zero;
                }
                textelement(OperatorPAN)
                {
                    MinOccurs = Zero;
                }
                textelement(LocationCode)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhibusECOInvoiceNo)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhibusECOInvoiceDate)
                {
                    MinOccurs = Zero;
                }
                textelement(BaseFare)
                {
                    MinOccurs = Zero;
                }
                textelement(EdgeDiscountbyOperator)
                {
                    MinOccurs = Zero;
                }
                textelement(LavyFeebyOperator)
                {
                    MinOccurs = Zero;
                }
                textelement(TollFeebyOperator)
                {
                    MinOccurs = Zero;
                }
                textelement(ServiceFeebyOperator)
                {
                    MinOccurs = Zero;
                }
                textelement(TotalFare)
                {
                    MinOccurs = Zero;
                }
                textelement(CommPercBasefareExclGST)
                {
                    MinOccurs = Zero;
                }
                textelement(CommEarnedBaseFare)
                {
                    MinOccurs = Zero;
                }
                textelement(SaasChargesCGWCommPerc)
                {
                    MinOccurs = Zero;
                }
                textelement(SaasCommCGW)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTOnCommIGST18Perc)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTOnCommCGST9Perc)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTOnCommSGST9Perc)
                {
                    MinOccurs = Zero;
                }
                textelement(TotalGST)
                {
                    MinOccurs = Zero;
                }
                textelement(TDSRate1PercUS194O)
                {
                    MinOccurs = Zero;
                }
                textelement(TDSAmtBaseEdgeoffer)
                {
                    MinOccurs = Zero;
                }
                textelement(NetPayabletoOperator)
                {
                    MinOccurs = Zero;
                }
                textelement(TaxRateonBasefare)
                {
                    MinOccurs = Zero;
                }
                textelement(ECOGSTAmountbyAggregator)
                {
                    MinOccurs = Zero;
                }
                textelement(ECOGSTAmtPaidIrctc)
                {
                    MinOccurs = Zero;
                }
                textelement(ECOGSTbyCGW)
                {
                    MinOccurs = Zero;
                }
                textelement(ECOIGST5PercAmtbyAbhibus)
                {
                    MinOccurs = Zero;
                }
                textelement(ECOCGST25PercAmtAbhibus)
                {
                    MinOccurs = Zero;
                }
                textelement(ECOSGST25PercAmtAbhibus)
                {
                    MinOccurs = Zero;
                }
                textelement(TotalTaxonFare)
                {
                    MinOccurs = Zero;
                }
                textelement(SACCode)
                {
                    MinOccurs = Zero;
                }
                textelement(PickupPlace)
                {
                    MinOccurs = Zero;
                }
                textelement(CustomerGSTIN)
                {
                    MinOccurs = Zero;
                }
                textelement(PickupState)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhibusTaxInvoiceNo)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhibusTaxInvoiceDate)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhibusSACCode)
                {
                    MinOccurs = Zero;
                }
                textelement(CustomerGSTINifProvided)
                {
                    MinOccurs = Zero;
                }
                textelement(Placeofsupply)
                {
                    MinOccurs = Zero;
                }
                textelement(IRNNo)
                {
                    MinOccurs = Zero;
                }
                textelement(IRNDate)
                {
                    MinOccurs = Zero;
                }
                textelement(ServiceCharge)
                {
                    MinOccurs = Zero;
                }
                textelement(FreeCancellationFee)
                {
                    MinOccurs = Zero;
                }
                textelement(PrimeMembershipFee)
                {
                    MinOccurs = Zero;
                }
                textelement(AssuredSubscrptionFee)
                {
                    MinOccurs = Zero;
                }
                textelement(RoundOffAmount)
                {
                    MinOccurs = Zero;
                }
                textelement(GrossIncome)
                {
                    MinOccurs = Zero;
                }
                textelement(InstantDiscount)
                {
                    MinOccurs = Zero;
                }
                textelement(TaxableValueInclTax)
                {
                    MinOccurs = Zero;
                }
                textelement(TaxableValueExclTax)
                {
                    MinOccurs = Zero;
                }
                textelement(TaxRate)
                {
                    MinOccurs = Zero;
                }
                textelement(IGSTAmount)
                {
                    MinOccurs = Zero;
                }
                textelement(CGSTAmount)
                {
                    MinOccurs = Zero;
                }
                textelement(SGSTAmount)
                {
                    MinOccurs = Zero;
                }
                textelement(TravelInsurance)
                {
                    MinOccurs = Zero;
                }
                textelement(InsuranceBenfitPrimeUsers)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhicashUsedPromo)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhicashUsedNonPromo)
                {
                    MinOccurs = Zero;
                }
                textelement(NetPGAgentAmtCollected)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTonFC)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTonAsssured)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTonPrime)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTonServicecharges)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if intCounter > 1 then begin
                        recBookingTransactions.Init();
                        intEntryNo += 1;
                        recBookingTransactions."Entry No." := intEntryNo;
                        recBookingTransactions."Created At" := CurrentDateTime;
                        recBookingTransactions."Created By" := UserId;

                        Evaluate(recBookingTransactions."Booking Date", BookingDate);
                        Evaluate(recBookingTransactions."Journey Date", JourneyDate);
                        Evaluate(recBookingTransactions."PNR No.", PNRNo);
                        Evaluate(recBookingTransactions."Collection Mode", CollectionMode);
                        Evaluate(recBookingTransactions."Collect Ref.-Tally", CollectRefTally);
                        Evaluate(recBookingTransactions."Supplier Type", SupplierType);
                        Evaluate(recBookingTransactions."Vendor No.", VendorNo);
                        recBookingTransactions.Validate("Vendor No.");
                        Evaluate(recBookingTransactions."Supplier Name - Technical", SupplierNameTechnical);
                        Evaluate(recBookingTransactions."Operator Name", OperatorName);
                        Evaluate(recBookingTransactions."Type of Sales", TypeofSales);
                        Evaluate(recBookingTransactions."Seller Name / Order ID", SellerNameOrderID);
                        Evaluate(recBookingTransactions."PG Reference No.", PGReferenceNo);
                        Evaluate(recBookingTransactions."Mode of Payment", ModeofPayment);
                        Evaluate(recBookingTransactions."ECO", ECO);
                        Evaluate(recBookingTransactions."ECO GSTIN", ECOGSTIN);
                        Evaluate(recBookingTransactions."Operator GSTIN", OperatorGSTIN);
                        Evaluate(recBookingTransactions."Operator PAN", OperatorPAN);
                        Evaluate(recBookingTransactions."Location Code", LocationCode);
                        Evaluate(recBookingTransactions."Abhibus ECO Invoice No.", AbhibusECOInvoiceNo);
                        Evaluate(recBookingTransactions."Abhibus ECO Invoice Date", AbhibusECOInvoiceDate);
                        Evaluate(recBookingTransactions."Base Fare", BaseFare);
                        Evaluate(recBookingTransactions."Edge Discount by Operator", EdgeDiscountbyOperator);
                        Evaluate(recBookingTransactions."Lavy Fee by Operator", LavyFeebyOperator);
                        Evaluate(recBookingTransactions."Toll Fee by Operator", TollFeebyOperator);
                        Evaluate(recBookingTransactions."Service Fee by Operator", ServiceFeebyOperator);
                        Evaluate(recBookingTransactions."Total Fare", TotalFare);
                        Evaluate(recBookingTransactions."Comm.% (Base fare) Excl. GST", CommPercBasefareExclGST);
                        Evaluate(recBookingTransactions."Comm. Earned (Base Fare)", CommEarnedBaseFare);
                        Evaluate(recBookingTransactions."Saas Charges (CGW Comm) %", SaasChargesCGWCommPerc);
                        Evaluate(recBookingTransactions."Saas Comm. (CGW)", SaasCommCGW);
                        Evaluate(recBookingTransactions."GST On Comm. IGST @18%", GSTOnCommIGST18Perc);
                        Evaluate(recBookingTransactions."GST On Comm. CGST @9%", GSTOnCommCGST9Perc);
                        Evaluate(recBookingTransactions."GST On Comm. SGST @9%", GSTOnCommSGST9Perc);
                        Evaluate(recBookingTransactions."Total GST", TotalGST);
                        Evaluate(recBookingTransactions."TDS Rate 1% U/S 194-O", TDSRate1PercUS194O);
                        Evaluate(recBookingTransactions."TDS Amt. (Base - Edge offer)", TDSAmtBaseEdgeoffer);
                        Evaluate(recBookingTransactions."Net Payable to Operator", NetPayabletoOperator);
                        Evaluate(recBookingTransactions."Tax Rate (on Base fare)", TaxRateonBasefare);
                        Evaluate(recBookingTransactions."ECO GST Amount by Aggregator", ECOGSTAmountbyAggregator);
                        Evaluate(recBookingTransactions."ECO GST Amt. Paid (Irctc)", ECOGSTAmtPaidIrctc);
                        Evaluate(recBookingTransactions."ECO GST by CGW", ECOGSTbyCGW);
                        Evaluate(recBookingTransactions."ECO IGST (@5%) Amt. by Abhibus", ECOIGST5PercAmtbyAbhibus);
                        Evaluate(recBookingTransactions."ECO CGST (@2.5%) Amt.(Abhibus)", ECOCGST25PercAmtAbhibus);
                        Evaluate(recBookingTransactions."ECO SGST (@2.5%) Amt.(Abhibus)", ECOSGST25PercAmtAbhibus);
                        Evaluate(recBookingTransactions."Total Tax on Fare", TotalTaxonFare);
                        Evaluate(recBookingTransactions."SAC Code", SACCode);
                        Evaluate(recBookingTransactions."Pickup Place", PickupPlace);
                        Evaluate(recBookingTransactions."Customer GSTIN", CustomerGSTIN);
                        Evaluate(recBookingTransactions."Pickup State", PickupState);
                        Evaluate(recBookingTransactions."Abhibus Tax Invoice No.", AbhibusTaxInvoiceNo);
                        Evaluate(recBookingTransactions."Abhibus Tax Invoice Date", AbhibusTaxInvoiceDate);
                        Evaluate(recBookingTransactions."Abhibus SAC Code", AbhibusSACCode);
                        Evaluate(recBookingTransactions."Customer GSTIN if Provided", CustomerGSTINifProvided);
                        Evaluate(recBookingTransactions."Place of supply", Placeofsupply);
                        Evaluate(recBookingTransactions."IRN No.", IRNNo);
                        Evaluate(recBookingTransactions."IRN Date", IRNDate);
                        Evaluate(recBookingTransactions."Service Charge", ServiceCharge);
                        Evaluate(recBookingTransactions."Free Cancellation Fee", FreeCancellationFee);
                        Evaluate(recBookingTransactions."Prime Membership Fee", PrimeMembershipFee);
                        Evaluate(recBookingTransactions."Assured Subscrption Fee", AssuredSubscrptionFee);
                        Evaluate(recBookingTransactions."Round Off Amount", RoundOffAmount);
                        Evaluate(recBookingTransactions."Gross Income", GrossIncome);
                        Evaluate(recBookingTransactions."Instant Discount", InstantDiscount);
                        Evaluate(recBookingTransactions."Taxable Value (Incl. Tax)", TaxableValueInclTax);
                        Evaluate(recBookingTransactions."Taxable Value (Excl. Tax)", TaxableValueExclTax);
                        Evaluate(recBookingTransactions."Tax Rate", TaxRate);
                        Evaluate(recBookingTransactions."IGST Amount", IGSTAmount);
                        Evaluate(recBookingTransactions."CGST Amount", CGSTAmount);
                        Evaluate(recBookingTransactions."SGST Amount", SGSTAmount);
                        Evaluate(recBookingTransactions."Travel Insurance", TravelInsurance);
                        Evaluate(recBookingTransactions."Insurance Benfit (Prime Users)", InsuranceBenfitPrimeUsers);
                        Evaluate(recBookingTransactions."Abhicash Used Promo", AbhicashUsedPromo);
                        Evaluate(recBookingTransactions."Abhicash Used Non Promo", AbhicashUsedNonPromo);
                        Evaluate(recBookingTransactions."Net PG/ Agent Amt. Collected", NetPGAgentAmtCollected);
                        Evaluate(recBookingTransactions."GST on FC", GSTonFC);
                        Evaluate(recBookingTransactions."GST on Asssured", GSTonAsssured);
                        Evaluate(recBookingTransactions."GST on Prime", GSTonPrime);
                        Evaluate(recBookingTransactions."GST on Service charges", GSTonServicecharges);

                        recBookingTransactions.Insert();
                    end;
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        intCounter := 0;
        recBookingTransactions.Reset();
        intEntryNo := 0;
        if recBookingTransactions.FindLast() then
            intEntryNo := recBookingTransactions."Entry No.";
    end;

    trigger OnPostXmlPort()
    begin
        MESSAGE('Data has been successfully updated');
    end;

    var
        intCounter: Integer;
        recBookingTransactions: Record "Booking Transactions";
        intEntryNo: Integer;
}