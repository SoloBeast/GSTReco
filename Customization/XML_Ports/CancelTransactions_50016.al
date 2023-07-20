xmlport 50016 "Cancel Transactions"
{
    Caption = 'Cancel Transactions';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(CancelTransctions)
        {
            MinOccurs = Zero;
            tableelement("Cancel Transactions"; "Cancel Transactions")
            {
                AutoSave = false;
                XmlName = 'CancelTransctions';

                textelement(CancellationDate)
                {
                    MinOccurs = Zero;
                }
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
                textelement(RefundMode)
                {
                    MinOccurs = Zero;
                }
                textelement(SupplierType)
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
                textelement(AbhibusCreditNoteNo)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhibusCreditNoteDate)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhibusOrgInvNo)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhibusOrgInvDate)
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
                textelement(BaseFateRefunded)
                {
                    MinOccurs = Zero;
                }
                textelement(LavyFeeRefund)
                {
                    MinOccurs = Zero;
                }
                textelement(TollFeeRefund)
                {
                    MinOccurs = Zero;
                }
                textelement(ServiceFeeRefund)
                {
                    MinOccurs = Zero;
                }
                textelement(TotalFareRefund)
                {
                    MinOccurs = Zero;
                }
                textelement(OperatorCancellationCharges)
                {
                    MinOccurs = Zero;
                }
                textelement(CommBasefareExclGST)
                {
                    MinOccurs = Zero;
                }
                textelement(CommCancellationExclGST)
                {
                    MinOccurs = Zero;
                }
                textelement(CommReversalBaseFare)
                {
                    MinOccurs = Zero;
                }
                textelement(CommEarnedonCancellation)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTOnCommReversalIGST)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTOnCommReversalCGST)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTOnCommReversalSGST)
                {
                    MinOccurs = Zero;
                }
                textelement(TotalGST)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTOnCommEarnedIGST)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTOnCommEarnedCGST)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTOnCommEarnedSGST)
                {
                    MinOccurs = Zero;
                }
                textelement(TotalGSTOnEarnedComm)
                {
                    MinOccurs = Zero;
                }
                textelement(TaxRateUS194O)
                {
                    MinOccurs = Zero;
                }
                textelement(TaxUS194O)
                {
                    MinOccurs = Zero;
                }
                textelement(NetPayabletoOperator)
                {
                    MinOccurs = Zero;
                }
                textelement(ECOGSTAmtRvdAggregator)
                {
                    MinOccurs = Zero;
                }
                textelement(ECOGSTAmountRvdSeller)
                {
                    MinOccurs = Zero;
                }
                textelement(ECOGSTReversedbyCGW)
                {
                    MinOccurs = Zero;
                }
                textelement(ECOIGSTAmountRvdAbhibus)
                {
                    MinOccurs = Zero;
                }
                textelement(ECOCGSTAmountRvdAbhibus)
                {
                    MinOccurs = Zero;
                }
                textelement(ECOSGSTAmountRvdAbhibus)
                {
                    MinOccurs = Zero;
                }
                textelement(TotalTaxonFare)
                {
                    MinOccurs = Zero;
                }
                textelement(TaxRate)
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
                textelement(PlaceofSupply)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhibusTaxCreditNoteNo)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhibusTaxCreditNoteDate)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhibusTaxOriginalInvNo)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhibusTaxOriginalInvdate)
                {
                    MinOccurs = Zero;
                }
                textelement(CustomerSACCode)
                {
                    MinOccurs = Zero;
                }
                textelement(CustomerGSTIN1)
                {
                    MinOccurs = Zero;
                }
                textelement(PlaceofSupply1)
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
                textelement(AbhibusCancellationCharges)
                {
                    MinOccurs = Zero;
                }
                textelement(InstantDiscountReversal)
                {
                    MinOccurs = Zero;
                }
                textelement(RoundOffIncome)
                {
                    MinOccurs = Zero;
                }
                textelement(TotalChargesNetofDiscount)
                {
                    MinOccurs = Zero;
                }
                textelement(TaxableValue)
                {
                    MinOccurs = Zero;
                }
                textelement(IGST)
                {
                    MinOccurs = Zero;
                }
                textelement(CGST)
                {
                    MinOccurs = Zero;
                }
                textelement(SGST)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhicashPromoReversed)
                {
                    MinOccurs = Zero;
                }
                textelement(AbhicashNonPromoReversed)
                {
                    MinOccurs = Zero;
                }
                textelement(PrimeMembershipBenefits)
                {
                    MinOccurs = Zero;
                }
                textelement(FreeCancellationBenefits)
                {
                    MinOccurs = Zero;
                }
                textelement(AssuredBenefits)
                {
                    MinOccurs = Zero;
                }
                textelement(NetAmountRefundedtoPG)
                {
                    MinOccurs = Zero;
                }
                textelement(RefundPGReferenceNo)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if intCounter > 1 then begin
                        recCancelTransactions.Init();
                        intEntryNo += 1;
                        recCancelTransactions."Entry No." := intEntryNo;
                        recCancelTransactions."Created At" := CurrentDateTime;
                        recCancelTransactions."Created By" := UserId;

                        Evaluate(recCancelTransactions."Cancellation Date", CancellationDate);
                        Evaluate(recCancelTransactions."Booking Date", BookingDate);
                        Evaluate(recCancelTransactions."Journey Date", JourneyDate);
                        Evaluate(recCancelTransactions."PNR No.", PNRNo);
                        Evaluate(recCancelTransactions."Refund Mode", RefundMode);
                        Evaluate(recCancelTransactions."Supplier Type", SupplierType);
                        Evaluate(recCancelTransactions."Supplier Name - Technical", SupplierNameTechnical);
                        Evaluate(recCancelTransactions."Operator Name", OperatorName);
                        Evaluate(recCancelTransactions."Type of Sales", TypeofSales);
                        Evaluate(recCancelTransactions."Seller Name / Order ID", SellerNameOrderID);
                        Evaluate(recCancelTransactions."PG Reference No.", PGReferenceNo);
                        Evaluate(recCancelTransactions."Mode of Payment", ModeofPayment);
                        Evaluate(recCancelTransactions."ECO", ECO);
                        Evaluate(recCancelTransactions."ECO GSTIN", ECOGSTIN);
                        Evaluate(recCancelTransactions."Operator GSTIN", OperatorGSTIN);
                        Evaluate(recCancelTransactions."Operator PAN", OperatorPAN);
                        Evaluate(recCancelTransactions."Location Code", LocationCode);
                        Evaluate(recCancelTransactions."Abhibus Credit Note No.", AbhibusCreditNoteNo);
                        Evaluate(recCancelTransactions."Abhibus Credit Note Date", AbhibusCreditNoteDate);
                        Evaluate(recCancelTransactions."Abhibus Org. Inv. No.", AbhibusOrgInvNo);
                        Evaluate(recCancelTransactions."Abhibus Org. Inv. Date", AbhibusOrgInvDate);
                        Evaluate(recCancelTransactions."Base Fare", BaseFare);
                        Evaluate(recCancelTransactions."Edge Discount by Operator", EdgeDiscountbyOperator);
                        Evaluate(recCancelTransactions."Base Fare Refunded", BaseFateRefunded);
                        Evaluate(recCancelTransactions."Lavy Fee Refund", LavyFeeRefund);
                        Evaluate(recCancelTransactions."Toll Fee Refund", TollFeeRefund);
                        Evaluate(recCancelTransactions."Service Fee Refund", ServiceFeeRefund);
                        Evaluate(recCancelTransactions."Total Fare Refund", TotalFareRefund);
                        Evaluate(recCancelTransactions."Operator Cancellation Charges", OperatorCancellationCharges);
                        Evaluate(recCancelTransactions."Comm.% (Base fare) Excl. GST", CommBasefareExclGST);
                        Evaluate(recCancelTransactions."Comm% (Cancellation) Excl. GST", CommCancellationExclGST);
                        Evaluate(recCancelTransactions."Comm. Reversal (Base Fare)", CommReversalBaseFare);
                        Evaluate(recCancelTransactions."Comm. Earned on Cancellation", CommEarnedonCancellation);
                        Evaluate(recCancelTransactions."GST On Comm. Reversal IGST", GSTOnCommReversalIGST);
                        Evaluate(recCancelTransactions."GST On Comm. Reversal CGST", GSTOnCommReversalCGST);
                        Evaluate(recCancelTransactions."GST On Comm. Reversal SGST", GSTOnCommReversalSGST);
                        Evaluate(recCancelTransactions."Total GST", TotalGST);
                        Evaluate(recCancelTransactions."GST On Comm. Earned IGST", GSTOnCommEarnedIGST);
                        Evaluate(recCancelTransactions."GST On Comm. Earned CGST", GSTOnCommEarnedCGST);
                        Evaluate(recCancelTransactions."GST On Comm. Earned SGST", GSTOnCommEarnedSGST);
                        Evaluate(recCancelTransactions."Total GST On Earned Comm.", TotalGSTOnEarnedComm);
                        Evaluate(recCancelTransactions."TDS Rate U/S 194O", TaxRateUS194O);
                        Evaluate(recCancelTransactions."TDS U/S 194O", TaxUS194O);
                        Evaluate(recCancelTransactions."Net Payable to Operator", NetPayabletoOperator);
                        Evaluate(recCancelTransactions."ECO GST Amt. Rvd. Aggregator", ECOGSTAmtRvdAggregator);
                        Evaluate(recCancelTransactions."ECO GST Amount Rvd. Seller", ECOGSTAmountRvdSeller);
                        Evaluate(recCancelTransactions."ECO GST Reversed by CGW", ECOGSTReversedbyCGW);
                        Evaluate(recCancelTransactions."ECO IGST Amount Rvd. Abhibus", ECOIGSTAmountRvdAbhibus);
                        Evaluate(recCancelTransactions."ECO CGST Amount Rvd. Abhibus", ECOCGSTAmountRvdAbhibus);
                        Evaluate(recCancelTransactions."ECO SGST Amount Rvd. Abhibus", ECOSGSTAmountRvdAbhibus);
                        Evaluate(recCancelTransactions."Total Tax on Fare", TotalTaxonFare);
                        Evaluate(recCancelTransactions."Tax Rate", TaxRate);
                        Evaluate(recCancelTransactions."SAC Code", SACCode);
                        Evaluate(recCancelTransactions."Pickup Place", PickupPlace);
                        Evaluate(recCancelTransactions."Customer GSTIN", CustomerGSTIN);
                        Evaluate(recCancelTransactions."Place of Supply", PlaceofSupply);
                        Evaluate(recCancelTransactions."Abhibus Tax Credit Note No.", AbhibusTaxCreditNoteNo);
                        Evaluate(recCancelTransactions."Abhibus Tax Credit Note Date", AbhibusCreditNoteDate);
                        Evaluate(recCancelTransactions."Abhibus Tax Original Inv. No.", AbhibusTaxOriginalInvNo);
                        Evaluate(recCancelTransactions."Abhibus Tax Original Inv. date", AbhibusTaxOriginalInvdate);
                        Evaluate(recCancelTransactions."Customer SAC Code", CustomerSACCode);
                        Evaluate(recCancelTransactions."Customer GSTIN 1", CustomerGSTIN1);
                        Evaluate(recCancelTransactions."Place of Supply 1", PlaceofSupply1);
                        Evaluate(recCancelTransactions."IRN No.", IRNNo);
                        Evaluate(recCancelTransactions."IRN Date", IRNDate);
                        Evaluate(recCancelTransactions."Abhibus Cancellation Charges", AbhibusCancellationCharges);
                        Evaluate(recCancelTransactions."Instant Discount Reversal", InstantDiscountReversal);
                        Evaluate(recCancelTransactions."Round Off Income", RoundOffIncome);
                        Evaluate(recCancelTransactions."Total Charges Net of Discount", TotalChargesNetofDiscount);
                        Evaluate(recCancelTransactions."Taxable Value", TaxableValue);
                        Evaluate(recCancelTransactions."IGST", IGST);
                        Evaluate(recCancelTransactions."CGST", CGST);
                        Evaluate(recCancelTransactions."SGST", SGST);
                        Evaluate(recCancelTransactions."Abhicash Promo Reversed", AbhicashPromoReversed);
                        Evaluate(recCancelTransactions."Abhicash Non-Promo Reversed", AbhicashNonPromoReversed);
                        Evaluate(recCancelTransactions."Prime Membership Benefits", PrimeMembershipBenefits);
                        Evaluate(recCancelTransactions."Free Cancellation Benefits", FreeCancellationBenefits);
                        Evaluate(recCancelTransactions."Assured Benefits", AssuredBenefits);
                        Evaluate(recCancelTransactions."Net Amount Refunded to PG", NetAmountRefundedtoPG);
                        Evaluate(recCancelTransactions."Refund PG Reference No.", RefundPGReferenceNo);

                        recCancelTransactions.Insert();
                    end;
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        intCounter := 0;
        recCancelTransactions.Reset();
        intEntryNo := 0;
        if recCancelTransactions.FindLast() then
            intEntryNo := recCancelTransactions."Entry No.";
    end;

    trigger OnPostXmlPort()
    begin
        MESSAGE('Data has been successfully updated');
    end;

    var
        intCounter: Integer;
        recCancelTransactions: Record "Cancel Transactions";
        intEntryNo: Integer;
}