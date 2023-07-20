table 50005 "Cancel Transactions"
{
    DataClassification = ToBeClassified;
    CompressionType = Page;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Created At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(100; "Cancellation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(101; "Booking Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Journey Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(103; "PNR No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(104; "Refund Mode"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(105; "Supplier Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(106; "Supplier Name - Technical"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(107; "Operator Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(108; "Type of Sales"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(109; "Seller Name / Order ID"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(110; "PG Reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(111; "Mode of Payment"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(112; "ECO"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(113; "ECO GSTIN"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(114; "Operator GSTIN"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(115; "Operator PAN"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(116; "Location Code"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(117; "Abhibus Credit Note No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(118; "Abhibus Credit Note Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(119; "Abhibus Org. Inv. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(120; "Abhibus Org. Inv. Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(121; "Base Fare"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(122; "Edge Discount by Operator"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(123; "Base Fare Refunded"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(124; "Lavy Fee Refund"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(125; "Toll Fee Refund"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(126; "Service Fee Refund"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(127; "Total Fare Refund"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(128; "Operator Cancellation Charges"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(129; "Comm.% (Base fare) Excl. GST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(130; "Comm% (Cancellation) Excl. GST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(131; "Comm. Reversal (Base Fare)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(132; "Comm. Earned on Cancellation"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(133; "GST On Comm. Reversal IGST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(134; "GST On Comm. Reversal CGST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(135; "GST On Comm. Reversal SGST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(136; "Total GST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(137; "GST On Comm. Earned IGST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(138; "GST On Comm. Earned CGST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(139; "GST On Comm. Earned SGST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(140; "Total GST On Earned Comm."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(141; "TDS Rate U/S 194O"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(142; "TDS U/S 194O"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(143; "Net Payable to Operator"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(144; "ECO GST Amt. Rvd. Aggregator"; Decimal)
        {
            Caption = 'ECO GST Amt. Reversed by Aggregator';
            DataClassification = ToBeClassified;
        }
        field(145; "ECO GST Amount Rvd. Seller"; Decimal)
        {
            Caption = 'ECO GST Amount reversed by Seller (Irctc)';
            DataClassification = ToBeClassified;
        }
        field(146; "ECO GST Reversed by CGW"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(147; "ECO IGST Amount Rvd. Abhibus"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(148; "ECO CGST Amount Rvd. Abhibus"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(149; "ECO SGST Amount Rvd. Abhibus"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(150; "Total Tax on Fare"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(151; "Tax Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(152; "SAC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(153; "Pickup Place"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(154; "Customer GSTIN"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(155; "Place of Supply"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(156; "Abhibus Tax Credit Note No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(157; "Abhibus Tax Credit Note Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(158; "Abhibus Tax Original Inv. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(159; "Abhibus Tax Original Inv. date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(160; "Customer SAC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(161; "Customer GSTIN 1"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(162; "Place of Supply 1"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(163; "IRN No."; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(164; "IRN Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(165; "Abhibus Cancellation Charges"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(166; "Instant Discount Reversal"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(167; "Round Off Income"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(168; "Total Charges Net of Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(169; "Taxable Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(170; "IGST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(171; "CGST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(172; "SGST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(173; "Abhicash Promo Reversed"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(174; "Abhicash Non-Promo Reversed"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(175; "Prime Membership Benefits"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(176; "Free Cancellation Benefits"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(177; "Assured Benefits"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(178; "Net Amount Refunded to PG"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(179; "Refund PG Reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    var

    trigger OnInsert()
    var
        recCancelTran: Record "Cancel Transactions";
    begin
        recCancelTran.Reset();
        if recCancelTran.FindLast() then
            Rec."Entry No." := recCancelTran."Entry No." + 1
        else
            Rec."Entry No." := 1;

        "Created At" := CurrentDateTime;
        "Created By" := UserId;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure PostCancelTransactions()
    var
        recCancelTransactions: Record "Cancel Transactions";
        blnTestEntries: Boolean;
        qryCancelSupplierEntry: Query "Cancel - Supplier Name";
        qryCancelECO: Query "Cancel - ECO";
        qryCancelTypeofSales: Query "Cancel - Type of Sales";
        qryCancelPGCollection: Query "Cancel - PG Collection";
        qryCancelEntry5Debit: Query "Cancel - Entry 5 Debit";
        recGenLine: Record "Gen. Journal Line" temporary;
        intLineNo: Integer;
        decTempValue: Decimal;
        decECOSellerAggregator: Decimal;
        decECOOperator: Decimal;
        decGSTECOSellerAggregator: Decimal;
        decGSTECOOperator: Decimal;
        decGSTOnCommission: Decimal;
        decOperatorECOGST: Decimal;
        recEntryData: Record "Gen. Journal Line" temporary;
        intEntryNo: Integer;
        decNetPGAgentCollected: Decimal;
        decInsuranceBenefitPrimeUser: Decimal;
        decEdgeDiscountByOperator: Decimal;
        decAbhicashUsedNonPromo: Decimal;
        decAbhicashUsedPromo: Decimal;
        decInstantDiscount: Decimal;
        decAggregatorECOCollection: Decimal;
        decInsurnceControl: Decimal;
        decBusConvenienceFee: Decimal;
        decBusFreeCollection: Decimal;
        decPrimeMembershipFee: Decimal;
        decBusAssuredIncome: Decimal;
        decBusRoundedOff: Decimal;
        decCancellationFeeIncome: Decimal;
        decFreeCancellationBenefits: Decimal;
        decPrimeCost: Decimal;
    begin
        if not Confirm('Do you want to post the cancel transctons?', false) then
            exit;

        recCancelTransactions.Reset();
        if recCancelTransactions.FindSet() then begin
            recCancelTransactions.LockTable();

            recGenLine.Reset();
            recGenLine.DeleteAll();
            intLineNo := 0;
            decTempValue := 0;
            blnTestEntries := StrMenu('Preview,Post') = 1;
            recEntryData.Reset();
            recEntryData.DeleteAll();
            intEntryNo := 0;

            //Supplier Liability
            decGSTOnCommission := 0;
            decOperatorECOGST := 0;
            Clear(qryCancelSupplierEntry);
            qryCancelSupplierEntry.Open();
            while qryCancelSupplierEntry.Read() do begin
                decTempValue := qryCancelSupplierEntry.Total_Fare_Refund - qryCancelSupplierEntry.Comm__Reversal__Base_Fare_ +
                                    qryCancelSupplierEntry.Comm__Earned_on_Cancellation - qryCancelSupplierEntry.Total_GST +
                                    qryCancelSupplierEntry.Total_GST_On_Earned_Comm_ + qryCancelSupplierEntry.ECO_GST_Reversed_by_CGW;
                decGSTOnCommission += qryCancelSupplierEntry.Total_GST - qryCancelSupplierEntry.Total_GST_On_Earned_Comm_;
                decOperatorECOGST += qryCancelSupplierEntry.Total_Tax_on_Fare - qryCancelSupplierEntry.ECO_GST_Reversed_by_CGW;

                if decTempValue <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '1';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine.Description := qryCancelSupplierEntry.Supplier_Name___Technical;
                        recGenLine."Debit Amount" := decTempValue;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;
                if qryCancelSupplierEntry.Edge_Discount_by_Operator + qryCancelSupplierEntry.TDS_U_S_194O <> 0 then begin
                    recEntryData.Init();
                    intEntryNo += 1;
                    recEntryData."Line No." := intEntryNo;
                    recEntryData.Description := qryCancelSupplierEntry.Supplier_Name___Technical;
                    recEntryData."Debit Amount" := qryCancelSupplierEntry.Edge_Discount_by_Operator;
                    recEntryData."Credit Amount" := qryCancelSupplierEntry.TDS_U_S_194O;
                    recEntryData.Insert();
                end;
            end;
            qryCancelSupplierEntry.Close();

            //Operator Control Account
            decECOSellerAggregator := 0;
            decECOOperator := 0;
            decGSTECOSellerAggregator := 0;
            decGSTECOOperator := 0;
            Clear(qryCancelECO);
            qryCancelECO.SetFilter(Total_Fare_Refund, '<>%1', 0);
            qryCancelECO.Open();
            while qryCancelECO.Read() do begin
                if qryCancelECO.ECO = 'Abhibus' then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '1';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine.Description := qryCancelECO.ECO + qryCancelECO.Location_Code;
                        recGenLine."Credit Amount" := qryCancelECO.Total_Fare_Refund;
                        recGenLine.Insert();

                        if qryCancelECO.ECO_IGST_Amount_Rvd__Abhibus <> 0 then begin
                            recGenLine.Init();
                            recGenLine."Journal Template Name" := '1';
                            intLineNo += 1;
                            recGenLine."Line No." := intLineNo;
                            recGenLine.Description := 'ECO GST IGST Payable' + qryCancelECO.Location_Code;
                            recGenLine."Debit Amount" := qryCancelECO.ECO_IGST_Amount_Rvd__Abhibus;
                            recGenLine.Insert();
                        end;
                        if qryCancelECO.ECO_CGST_Amount_Rvd__Abhibus <> 0 then begin
                            recGenLine.Init();
                            recGenLine."Journal Template Name" := '1';
                            intLineNo += 1;
                            recGenLine."Line No." := intLineNo;
                            recGenLine.Description := 'ECO GST CGST Payable' + qryCancelECO.Location_Code;
                            recGenLine."Debit Amount" := qryCancelECO.ECO_CGST_Amount_Rvd__Abhibus;
                            recGenLine.Insert();
                        end;
                        if qryCancelECO.ECO_SGST_Amount_Rvd__Abhibus <> 0 then begin
                            recGenLine.Init();
                            recGenLine."Journal Template Name" := '1';
                            intLineNo += 1;
                            recGenLine."Line No." := intLineNo;
                            recGenLine.Description := 'ECO GST SGST Payable' + qryCancelECO.Location_Code;
                            recGenLine."Debit Amount" := qryCancelECO.ECO_SGST_Amount_Rvd__Abhibus;
                            recGenLine.Insert();
                        end;
                    end else begin

                    end;
                end;
                if qryCancelECO.ECO = 'Aggregator' then begin
                    decECOSellerAggregator += qryCancelECO.Total_Fare_Refund;
                    decGSTECOSellerAggregator += qryCancelECO.Total_Tax_on_Fare;
                end;
                if qryCancelECO.ECO = 'Seller' then begin
                    decECOSellerAggregator += qryCancelECO.Total_Fare_Refund;
                    decGSTECOSellerAggregator += qryCancelECO.Total_Tax_on_Fare;
                end;
                if qryCancelECO.ECO = 'Operator' then begin

                    decECOOperator += qryCancelECO.Total_Fare_Refund + qryCancelECO.ECO_GST_Reversed_by_CGW;
                end;
            end;
            qryCancelECO.Close();

            if decECOSellerAggregator <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '1';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Aggregator / Seller';
                    recGenLine."Credit Amount" := decECOSellerAggregator;
                    recGenLine.Insert();
                end else begin

                end;
            end;
            if decECOOperator <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '1';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Operator';
                    recGenLine."Credit Amount" := decECOOperator;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            //Commission Liability
            decNetPGAgentCollected := 0;
            decAbhicashUsedNonPromo := 0;
            decAbhicashUsedPromo := 0;
            decInstantDiscount := 0;
            decInsuranceBenefitPrimeUser := 0;
            decEdgeDiscountByOperator := 0;
            decCancellationFeeIncome := 0;
            decFreeCancellationBenefits := 0;
            decPrimeCost := 0;
            decBusRoundedOff := 0;
            Clear(qryCancelTypeofSales);
            qryCancelTypeofSales.Open();
            while qryCancelTypeofSales.Read() do begin
                if (qryCancelTypeofSales.Type_of_Sales = 'Agent') and (qryCancelTypeofSales.Comm__Earned_on_Cancellation - qryCancelTypeofSales.Comm__Reversal__Base_Fare_ <> 0) then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '1';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine.Description := qryCancelTypeofSales.Type_of_Sales;
                        recGenLine."Debit Amount" := qryCancelTypeofSales.Comm__Reversal__Base_Fare_ - qryCancelTypeofSales.Comm__Earned_on_Cancellation;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;
                if (qryCancelTypeofSales.Type_of_Sales = 'Online') and (qryCancelTypeofSales.Comm__Earned_on_Cancellation - qryCancelTypeofSales.Comm__Reversal__Base_Fare_ <> 0) then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '1';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine.Description := qryCancelTypeofSales.Type_of_Sales;
                        recGenLine."Debit Amount" := qryCancelTypeofSales.Comm__Reversal__Base_Fare_ - qryCancelTypeofSales.Comm__Earned_on_Cancellation;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;
                if qryCancelTypeofSales.Type_of_Sales in ['Online', 'CGW'] then begin
                    decNetPGAgentCollected += qryCancelTypeofSales.Net_Amount_Refunded_to_PG;
                    decBusRoundedOff += qryCancelTypeofSales.Round_Off_Income;
                end;
                decAbhicashUsedNonPromo += qryCancelTypeofSales.Abhicash_Non_Promo_Reversed;
                decInstantDiscount += qryCancelTypeofSales.Instant_Discount_Reversal;
                decAbhicashUsedPromo += qryCancelTypeofSales.Abhicash_Promo_Reversed;
                decEdgeDiscountByOperator += qryCancelTypeofSales.Edge_Discount_by_Operator;
                decCancellationFeeIncome += qryCancelTypeofSales.Abhibus_Cancellation_Charges;
                decInsuranceBenefitPrimeUser += qryCancelTypeofSales.Assured_Benefits;
                decFreeCancellationBenefits += qryCancelTypeofSales.Free_Cancellation_Benefits;
                decPrimeCost += qryCancelTypeofSales.Prime_Membership_Benefits;
            end;
            qryCancelTypeofSales.Close();

            //GST Liability
            if decGSTOnCommission <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '1';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'GST on Commission';
                    recGenLine."Debit Amount" := decGSTOnCommission;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            //Operator GST ECO
            if decOperatorECOGST <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '1';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Operator ECO GST';
                    recGenLine."Credit Amount" := decOperatorECOGST;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            //Aggregator / Seller GST ECO
            if decGSTECOSellerAggregator <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '1';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Aggregator / Seller ECO GST';
                    recGenLine."Debit Amount" := decGSTECOSellerAggregator;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            //Entry - 2 Edge Discount
            intLineNo := 0;
            recEntryData.Reset();
            recEntryData.SetFilter("Debit Amount", '<>%1', 0);
            if recEntryData.FindFirst() then begin
                decTempValue := 0;

                repeat
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '2';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine.Description := recEntryData.Description;
                        recGenLine."Credit Amount" := recEntryData."Debit Amount";
                        recGenLine.Insert();
                    end else begin

                    end;
                    decTempValue += recEntryData."Debit Amount";
                until recEntryData.Next() = 0;

                if decTempValue <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '2';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine.Description := 'Discount Edge Offer';
                        recGenLine."Debit Amount" := decTempValue;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;
            end;

            //Entry - 3 TDS Entry
            intLineNo := 0;
            recEntryData.Reset();
            recEntryData.SetFilter("Credit Amount", '<>%1', 0);
            if recEntryData.FindFirst() then begin
                decTempValue := 0;

                repeat
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '3';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine.Description := recEntryData.Description;
                        recGenLine."Credit Amount" := recEntryData."Credit Amount";
                        recGenLine.Insert();
                    end else begin

                    end;
                    decTempValue += recEntryData."Credit Amount";
                until recEntryData.Next() = 0;

                if decTempValue <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '3';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine.Description := 'TDS Payable';
                        recGenLine."Debit Amount" := decTempValue;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;
            end;

            //Entry - 4 PG Collection
            intLineNo := 0;
            if decNetPGAgentCollected <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '4';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Gateway Collection A/c (Control Account)';
                    recGenLine."Credit Amount" := decNetPGAgentCollected;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            if decAbhicashUsedNonPromo <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '4';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'AbhiCash Collection A/C';
                    recGenLine."Credit Amount" := decAbhicashUsedNonPromo;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            if decInstantDiscount <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '4';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Instant Discount';
                    recGenLine."Credit Amount" := decInstantDiscount;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            if decAbhicashUsedPromo <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '4';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Discount - abhicashpromo';
                    recGenLine."Credit Amount" := decAbhicashUsedPromo;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            if decEdgeDiscountByOperator <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '4';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Discount - Edge offer';
                    recGenLine."Credit Amount" := decEdgeDiscountByOperator;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            if decCancellationFeeIncome <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '4';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Cancellation Fee Income';
                    recGenLine."Credit Amount" := decCancellationFeeIncome;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            if decInsuranceBenefitPrimeUser <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '4';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Assured Benefit';
                    recGenLine."Debit Amount" := decInsuranceBenefitPrimeUser;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            if decFreeCancellationBenefits <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '4';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Free Cancellation Benefits';
                    recGenLine."Debit Amount" := decFreeCancellationBenefits;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            if decPrimeCost <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '4';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Prime Cost';
                    recGenLine."Debit Amount" := decPrimeCost;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            if decECOOperator <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '4';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Common Gateway Control Ledger';
                    recGenLine."Debit Amount" := decECOOperator;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            if decBusRoundedOff <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '4';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Bus Rounded Off Income';
                    recGenLine."Credit Amount" := -decBusRoundedOff;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            decECOOperator := 0;
            decOperatorECOGST := 0;
            Clear(qryCancelPGCollection);
            qryCancelPGCollection.Open();
            while qryCancelPGCollection.Read() do begin
                if (qryCancelPGCollection.Type_of_Sales = 'Online') and (qryCancelPGCollection.ECO = 'Abhibus') then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine.Description := qryCancelPGCollection.Type_of_Sales + qryCancelPGCollection.ECO + qryCancelPGCollection.Location_Code;
                        recGenLine."Debit Amount" := qryCancelPGCollection.Total_Fare_Refund;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;
                if (qryCancelPGCollection.Type_of_Sales = 'Online') and (qryCancelPGCollection.ECO in ['Aggregator']) then begin
                    decECOOperator += qryCancelPGCollection.Total_Fare_Refund;
                end;
                if qryCancelPGCollection.Type_of_Sales = 'Online' then
                    decOperatorECOGST += qryCancelPGCollection.Total_Tax_on_Fare;
            end;
            qryCancelPGCollection.Close();

            if decECOOperator <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '4';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Online Aggregator ECO collection control a/c';
                    recGenLine."Debit Amount" := decECOOperator;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            if decOperatorECOGST <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '4';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Operator ECO GST';
                    recGenLine."Debit Amount" := decOperatorECOGST;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            //Entry 5
            intLineNo := 0;
            decOperatorECOGST := 0;
            Clear(qryCancelEntry5Debit);
            qryCancelEntry5Debit.Open();
            while qryCancelEntry5Debit.Read() do begin
                if qryCancelEntry5Debit.Type_of_Sales = 'Agent' then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '5';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine.Description := qryCancelEntry5Debit.Seller_Name___Order_ID;
                        recGenLine."Credit Amount" := qryCancelEntry5Debit.Total_Fare_Refund + qryCancelEntry5Debit.Total_Tax_on_Fare;
                        recGenLine.Insert();
                    end else begin

                    end;

                    decOperatorECOGST += qryCancelEntry5Debit.Total_Tax_on_Fare;
                end;
            end;
            qryCancelEntry5Debit.Close();

            if decOperatorECOGST <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '5';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Operator ECO GST';
                    recGenLine."Debit Amount" := decOperatorECOGST;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            decECOOperator := 0;
            Clear(qryCancelPGCollection);
            qryCancelPGCollection.Open();
            while qryCancelPGCollection.Read() do begin
                if (qryCancelPGCollection.Type_of_Sales = 'Agent') and (qryCancelPGCollection.ECO = 'Abhibus') then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '5';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine.Description := qryCancelPGCollection.Type_of_Sales + qryCancelPGCollection.ECO + qryCancelPGCollection.Location_Code;
                        recGenLine."Debit Amount" := qryCancelPGCollection.Total_Fare_Refund;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;
                if (qryCancelPGCollection.Type_of_Sales = 'Agent') and (qryCancelPGCollection.ECO in ['Aggregator', 'Seller']) then begin
                    decECOOperator += qryCancelPGCollection.Total_Fare_Refund;
                end;
            end;
            qryCancelPGCollection.Close();

            if decECOOperator <> 0 then begin
                if blnTestEntries then begin
                    recGenLine.Init();
                    recGenLine."Journal Template Name" := '5';
                    intLineNo += 1;
                    recGenLine."Line No." := intLineNo;
                    recGenLine.Description := 'Aggregator ECO collection control a/c';
                    recGenLine."Debit Amount" := decECOOperator;
                    recGenLine.Insert();
                end else begin

                end;
            end;

            if blnTestEntries then begin
                recGenLine.Reset();
                Page.Run(Page::"Transaction Test", recGenLine);
            end else begin
                Message('The entries has been posted.');
            end;
        end else
            Error('Nothing is pending to post.');
    end;

}