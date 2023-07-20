table 50004 "Booking Transactions"
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
        field(100; "Booking Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(101; "Journey Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(102; "PNR No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(103; "Collection Mode"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(104; "Collect Ref.-Tally"; Code[20])
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
        field(117; "Abhibus ECO Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(118; "Abhibus ECO Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(119; "Base Fare"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(120; "Edge Discount by Operator"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(121; "Lavy Fee by Operator"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(122; "Toll Fee by Operator"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(123; "Service Fee by Operator"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(124; "Total Fare"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(125; "Comm.% (Base fare) Excl. GST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(126; "Comm. Earned (Base Fare)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(127; "Saas Charges (CGW Comm) %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(128; "Saas Comm. (CGW)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(129; "GST On Comm. IGST @18%"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(130; "GST On Comm. CGST @9%"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(131; "GST On Comm. SGST @9%"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(132; "Total GST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(133; "TDS Rate 1% U/S 194-O"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(134; "TDS Amt. (Base - Edge offer)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(135; "Net Payable to Operator"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(136; "Tax Rate (on Base fare)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(137; "ECO GST Amount by Aggregator"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(138; "ECO GST Amt. Paid (Irctc)"; Decimal)
        {
            Caption = 'ECO GST Amt. Paid by Seller (Irctc)';
            DataClassification = ToBeClassified;
        }
        field(139; "ECO GST by CGW"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(140; "ECO IGST (@5%) Amt. by Abhibus"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(141; "ECO CGST (@2.5%) Amt.(Abhibus)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(142; "ECO SGST (@2.5%) Amt.(Abhibus)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(143; "Total Tax on Fare"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(144; "SAC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(145; "Pickup Place"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(146; "Customer GSTIN"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(147; "Pickup State"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(148; "Abhibus Tax Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(149; "Abhibus Tax Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(150; "Abhibus SAC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(151; "Customer GSTIN if Provided"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(152; "Place of supply"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(153; "IRN No."; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(154; "IRN Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(155; "Service Charge"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(156; "Free Cancellation Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(157; "Prime Membership Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(158; "Assured Subscrption Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(159; "Round Off Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(160; "Gross Income"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(161; "Instant Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(162; "Taxable Value (Incl. Tax)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(163; "Taxable Value (Excl. Tax)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(164; "Tax Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(165; "IGST Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(166; "CGST Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(167; "SGST Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(168; "Travel Insurance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(169; "Insurance Benfit (Prime Users)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(170; "Abhicash Used Promo"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(171; "Abhicash Used Non Promo"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(172; "Net PG/ Agent Amt. Collected"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(173; "GST on FC"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(174; "GST on Asssured"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(175; "GST on Prime"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(176; "GST on Service charges"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(177; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
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
        recBookingTran: Record "Booking Transactions";
    begin
        recBookingTran.Reset();
        if recBookingTran.FindLast() then
            Rec."Entry No." := recBookingTran."Entry No." + 1
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

    procedure PostBookingTransactions()
    var
        recBookingTransactions: Record "Booking Transactions";
        blnTestEntries: Boolean;
        qryBookingPostingDate: Query "Booking - Posting Date";
        qryBookingSupplierEntry: Query "Booking - Supplier Name";
        qryBookingECO: Query "Booking - ECO";
        qryBookingTypeofSales: Query "Booking - Type of Sales";
        qryBookingPGCollection: Query "Booking - PG Collection";
        qryBookingEntry5Debit: Query "Booking - Entry 5 Debit";
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
        recSalesSetup: Record "Sales & Receivables Setup";
        recVendor: Record Vendor;
        cdDocumentNo: Code[20];
    begin
        if not Confirm('Do you want to post the booking transctons?', false) then
            exit;

        recBookingTransactions.Reset();
        if recBookingTransactions.FindSet() then begin
            recBookingTransactions.LockTable();

            recGenLine.Reset();
            recGenLine.DeleteAll();
            intLineNo := 0;
            decTempValue := 0;
            blnTestEntries := StrMenu('Preview,Post') = 1;
            recEntryData.Reset();
            recEntryData.DeleteAll();
            intEntryNo := 0;

            recSalesSetup.Get();

            Clear(qryBookingPostingDate);
            qryBookingPostingDate.Open();
            while qryBookingPostingDate.Read() do begin
                cdDocumentNo := 'B' + Format(Date2DMY(qryBookingPostingDate.Booking_Date, 1)).PadLeft(2, '0') +
                                        Format(Date2DMY(qryBookingPostingDate.Booking_Date, 2)).PadLeft(2, '0') +
                                        Format(Date2DMY(qryBookingPostingDate.Booking_Date, 3));

                //Supplier Liability
                decGSTOnCommission := 0;
                decOperatorECOGST := 0;
                Clear(qryBookingSupplierEntry);
                qryBookingSupplierEntry.SetRange(Booking_Date, qryBookingPostingDate.Booking_Date);
                qryBookingSupplierEntry.Open();
                while qryBookingSupplierEntry.Read() do begin
                    if qryBookingSupplierEntry.Vendor_No_ = '' then
                        Error('The Vendor No. must not be blank, check the data.');
                    recVendor.Get(qryBookingSupplierEntry.Vendor_No_);

                    decTempValue := qryBookingSupplierEntry.Total_Fare - qryBookingSupplierEntry.Comm__Earned__Base_Fare_ -
                                        qryBookingSupplierEntry.Saas_Comm___CGW_ - qryBookingSupplierEntry.Total_GST +
                                        qryBookingSupplierEntry.ECO_GST_by_CGW;
                    decGSTOnCommission += qryBookingSupplierEntry.Total_GST;
                    decOperatorECOGST += qryBookingSupplierEntry.Total_Tax_on_Fare - qryBookingSupplierEntry.ECO_GST_by_CGW;

                    if decTempValue <> 0 then begin
                        if blnTestEntries then begin
                            recGenLine.Init();
                            recGenLine."Journal Template Name" := '1';
                            intLineNo += 1;
                            recGenLine."Line No." := intLineNo;
                            recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                            recGenLine."Document No." := cdDocumentNo;
                            recGenLine."Account No." := qryBookingSupplierEntry.Vendor_No_;
                            recGenLine.Description := recVendor.Name;
                            recGenLine."Credit Amount" := decTempValue;
                            recGenLine.Insert();
                        end else begin

                        end;
                    end;
                    if qryBookingSupplierEntry.Edge_Discount_by_Operator + qryBookingSupplierEntry.TDS_Amt___Base___Edge_offer_ <> 0 then begin
                        recEntryData.Init();
                        intEntryNo += 1;
                        recEntryData."Line No." := intEntryNo;
                        recEntryData."Account No." := qryBookingSupplierEntry.Vendor_No_;
                        recEntryData.Description := recVendor.Name;
                        recEntryData."Debit Amount" := qryBookingSupplierEntry.Edge_Discount_by_Operator;
                        recEntryData."Credit Amount" := qryBookingSupplierEntry.TDS_Amt___Base___Edge_offer_;
                        recEntryData.Insert();
                    end;
                end;
                qryBookingSupplierEntry.Close();

                //Operator Control Account
                decECOSellerAggregator := 0;
                decECOOperator := 0;
                decGSTECOSellerAggregator := 0;
                decGSTECOOperator := 0;

                recSalesSetup.TestField("Total Fare Account");
                recSalesSetup.TestField("ECO IGST Account");
                recSalesSetup.TestField("ECO SGST Account");
                recSalesSetup.TestField("ECO CGST Account");
                recSalesSetup.TestField("ECO GST Aggregator A/c");

                Clear(qryBookingECO);
                qryBookingECO.SetRange(Booking_Date, qryBookingPostingDate.Booking_Date);
                qryBookingECO.SetFilter(Total_Fare, '<>%1', 0);
                qryBookingECO.Open();
                while qryBookingECO.Read() do begin
                    if qryBookingECO.ECO = 'Abhibus' then begin
                        if blnTestEntries then begin
                            recGenLine.Init();
                            recGenLine."Journal Template Name" := '1';
                            intLineNo += 1;
                            recGenLine."Line No." := intLineNo;
                            recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                            recGenLine."Document No." := cdDocumentNo;
                            recGenLine."Account No." := recSalesSetup."Total Fare Account";
                            recGenLine.Description := qryBookingECO.ECO + qryBookingECO.Location_Code;
                            recGenLine."Debit Amount" := qryBookingECO.Total_Fare;
                            recGenLine.Insert();

                            if qryBookingECO.ECO_IGST___5___Amt__by_Abhibus <> 0 then begin
                                recGenLine.Init();
                                recGenLine."Journal Template Name" := '1';
                                intLineNo += 1;
                                recGenLine."Line No." := intLineNo;
                                recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                                recGenLine."Document No." := cdDocumentNo;
                                recGenLine."Account No." := recSalesSetup."ECO IGST Account";
                                recGenLine.Description := 'ECO GST IGST Payable' + qryBookingECO.Location_Code;
                                recGenLine."Credit Amount" := qryBookingECO.ECO_IGST___5___Amt__by_Abhibus;
                                recGenLine.Insert();
                            end;
                            if qryBookingECO.ECO_CGST___2_5___Amt__Abhibus_ <> 0 then begin
                                recGenLine.Init();
                                recGenLine."Journal Template Name" := '1';
                                intLineNo += 1;
                                recGenLine."Line No." := intLineNo;
                                recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                                recGenLine."Document No." := cdDocumentNo;
                                recGenLine."Account No." := recSalesSetup."ECO CGST Account";
                                recGenLine.Description := 'ECO GST CGST Payable' + qryBookingECO.Location_Code;
                                recGenLine."Credit Amount" := qryBookingECO.ECO_CGST___2_5___Amt__Abhibus_;
                                recGenLine.Insert();
                            end;
                            if qryBookingECO.ECO_SGST___2_5___Amt__Abhibus_ <> 0 then begin
                                recGenLine.Init();
                                recGenLine."Journal Template Name" := '1';
                                intLineNo += 1;
                                recGenLine."Line No." := intLineNo;
                                recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                                recGenLine."Document No." := cdDocumentNo;
                                recGenLine."Account No." := recSalesSetup."ECO SGST Account";
                                recGenLine.Description := 'ECO GST SGST Payable' + qryBookingECO.Location_Code;
                                recGenLine."Credit Amount" := qryBookingECO.ECO_SGST___2_5___Amt__Abhibus_;
                                recGenLine.Insert();
                            end;
                        end else begin

                        end;
                    end;
                    if qryBookingECO.ECO = 'Aggregator' then begin
                        decECOSellerAggregator += qryBookingECO.Total_Fare;
                        decGSTECOSellerAggregator += qryBookingECO.ECO_GST_Amount_by_Aggregator + qryBookingECO.ECO_GST_Amt__Paid__Irctc_;
                    end;
                    if qryBookingECO.ECO = 'Seller' then begin
                        decECOSellerAggregator += qryBookingECO.Total_Fare;
                        decGSTECOSellerAggregator += qryBookingECO.ECO_GST_Amount_by_Aggregator + qryBookingECO.ECO_GST_Amt__Paid__Irctc_;
                    end;
                    if qryBookingECO.ECO = 'Operator' then begin
                        decECOOperator += qryBookingECO.Total_Fare + qryBookingECO.ECO_GST_by_CGW;
                        decGSTECOOperator += qryBookingECO.ECO_GST_Amount_by_Aggregator + qryBookingECO.ECO_GST_Amt__Paid__Irctc_;
                    end;
                end;
                qryBookingECO.Close();

                if decECOSellerAggregator <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '1';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Total Fare Account";
                        recGenLine.Description := 'Aggregator / Seller';
                        recGenLine."Debit Amount" := decECOSellerAggregator;
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
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Total Fare Account";
                        recGenLine.Description := 'Operator';
                        recGenLine."Debit Amount" := decECOOperator;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;
                if decGSTECOSellerAggregator <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '1';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."ECO GST Aggregator A/c";
                        recGenLine.Description := 'Aggregator / Seller GST';
                        recGenLine."Credit Amount" := decGSTECOSellerAggregator;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;
                if decGSTECOOperator <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '1';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."ECO GST Aggregator A/c";
                        recGenLine.Description := 'Operator GST';
                        recGenLine."Credit Amount" := decGSTECOOperator;
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

                recSalesSetup.TestField("Commission Earned A/c");
                recSalesSetup.TestField("SaaS Commission CGW A/c");
                recSalesSetup.TestField("GST Account");

                Clear(qryBookingTypeofSales);
                qryBookingTypeofSales.SetRange(Booking_Date, qryBookingPostingDate.Booking_Date);
                qryBookingTypeofSales.Open();
                while qryBookingTypeofSales.Read() do begin
                    if (qryBookingTypeofSales.Type_of_Sales = 'Agent') and (qryBookingTypeofSales.Comm__Earned__Base_Fare_ <> 0) then begin
                        if blnTestEntries then begin
                            recGenLine.Init();
                            recGenLine."Journal Template Name" := '1';
                            intLineNo += 1;
                            recGenLine."Line No." := intLineNo;
                            recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                            recGenLine."Document No." := cdDocumentNo;
                            recGenLine."Account No." := recSalesSetup."Commission Earned A/c";
                            recGenLine.Description := qryBookingTypeofSales.Type_of_Sales;
                            recGenLine."Credit Amount" := qryBookingTypeofSales.Comm__Earned__Base_Fare_;
                            recGenLine.Insert();
                        end else begin

                        end;
                    end;
                    if (qryBookingTypeofSales.Type_of_Sales = 'Online') and (qryBookingTypeofSales.Comm__Earned__Base_Fare_ <> 0) then begin
                        if blnTestEntries then begin
                            recGenLine.Init();
                            recGenLine."Journal Template Name" := '1';
                            intLineNo += 1;
                            recGenLine."Line No." := intLineNo;
                            recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                            recGenLine."Document No." := cdDocumentNo;
                            recGenLine."Account No." := recSalesSetup."Commission Earned A/c";
                            recGenLine.Description := qryBookingTypeofSales.Type_of_Sales;
                            recGenLine."Credit Amount" := qryBookingTypeofSales.Comm__Earned__Base_Fare_;
                            recGenLine.Insert();
                        end else begin

                        end;
                    end;
                    if (qryBookingTypeofSales.Type_of_Sales = 'CGW') and (qryBookingTypeofSales.Saas_Comm___CGW_ <> 0) then begin
                        if blnTestEntries then begin
                            recGenLine.Init();
                            recGenLine."Journal Template Name" := '1';
                            intLineNo += 1;
                            recGenLine."Line No." := intLineNo;
                            recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                            recGenLine."Document No." := cdDocumentNo;
                            recGenLine."Account No." := recSalesSetup."SaaS Commission CGW A/c";
                            recGenLine.Description := qryBookingTypeofSales.Type_of_Sales;
                            recGenLine."Credit Amount" := qryBookingTypeofSales.Saas_Comm___CGW_;
                            recGenLine.Insert();
                        end else begin

                        end;
                    end;
                    if qryBookingTypeofSales.Type_of_Sales in ['Online', 'CGW'] then begin
                        decNetPGAgentCollected += qryBookingTypeofSales.Net_PG__Agent_Amt__Collected;
                    end;
                    decAbhicashUsedNonPromo += qryBookingTypeofSales.Abhicash_Used_Non_Promo;
                    decInstantDiscount += qryBookingTypeofSales.Instant_Discount;
                    decAbhicashUsedPromo += qryBookingTypeofSales.Abhicash_Used_Promo;
                    decInsuranceBenefitPrimeUser += qryBookingTypeofSales.Insurance_Benfit__Prime_Users_;
                    decEdgeDiscountByOperator += qryBookingTypeofSales.Edge_Discount_by_Operator;
                end;
                qryBookingTypeofSales.Close();

                //GST Liability
                if decGSTOnCommission <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '1';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."GST Account";
                        recGenLine.Description := 'GST on Commission';
                        recGenLine."Credit Amount" := decGSTOnCommission;
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
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."GST Account";
                        recGenLine.Description := 'Operator ECO GST';
                        recGenLine."Debit Amount" := decOperatorECOGST;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                //Entry - 2 Edge Discount
                recSalesSetup.TestField("Edge Discount by Operator");

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
                            recGenLine."Account No." := recEntryData."Account No.";
                            recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                            recGenLine."Document No." := cdDocumentNo;
                            recGenLine.Description := recEntryData.Description;
                            recGenLine."Debit Amount" := recEntryData."Debit Amount";
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
                            recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                            recGenLine."Document No." := cdDocumentNo;
                            recGenLine."Account No." := recSalesSetup."Edge Discount by Operator";
                            recGenLine.Description := 'Discount Edge Offer';
                            recGenLine."Credit Amount" := decTempValue;
                            recGenLine.Insert();
                        end else begin

                        end;
                    end;
                end;

                //Entry - 3 TDS Entry
                recSalesSetup.TestField("TDS Payable ECO A/c");

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
                            recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                            recGenLine."Document No." := cdDocumentNo;
                            recGenLine."Account No." := recEntryData."Account No.";
                            recGenLine.Description := recEntryData.Description;
                            recGenLine."Debit Amount" := recEntryData."Credit Amount";
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
                            recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                            recGenLine."Document No." := cdDocumentNo;
                            recGenLine."Account No." := recSalesSetup."TDS Payable ECO A/c";
                            recGenLine.Description := 'TDS Payable';
                            recGenLine."Credit Amount" := decTempValue;
                            recGenLine.Insert();
                        end else begin

                        end;
                    end;
                end;

                //Entry - 4 PG Collection
                recSalesSetup.TestField("Net PG/Agent Amt. Collected");

                if decNetPGAgentCollected <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Net PG/Agent Amt. Collected";
                        recGenLine.Description := 'Gateway Collection A/c (Control Account)';
                        recGenLine."Debit Amount" := decNetPGAgentCollected;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                recSalesSetup.TestField("Abhicash Non Promo");
                if decAbhicashUsedNonPromo <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Abhicash Non Promo";
                        recGenLine.Description := 'AbhiCash Collection A/C';
                        recGenLine."Debit Amount" := decAbhicashUsedNonPromo;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                recSalesSetup.TestField("Instant Discount");
                if decInstantDiscount <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Instant Discount";
                        recGenLine.Description := 'Instant Discount';
                        recGenLine."Debit Amount" := decInstantDiscount;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                recSalesSetup.TestField("Abhicash Promo");
                if decAbhicashUsedPromo <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Abhicash Promo";
                        recGenLine.Description := 'Discount - abhicashpromo';
                        recGenLine."Debit Amount" := decAbhicashUsedPromo;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                recSalesSetup.TestField("Edge Discount by Operator");
                if decEdgeDiscountByOperator <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Edge Discount by Operator";
                        recGenLine.Description := 'Discount - Edge offer';
                        recGenLine."Debit Amount" := decEdgeDiscountByOperator;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                recSalesSetup.TestField("Insurance Benfit (Prime User)");
                if decInsuranceBenefitPrimeUser <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Insurance Benfit (Prime User)";
                        recGenLine.Description := 'Insurance Benefit';
                        recGenLine."Debit Amount" := decInsuranceBenefitPrimeUser;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                recSalesSetup.TestField("Total Fare Account");
                if decECOOperator <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Total Fare Account";
                        recGenLine.Description := 'Common Gateway Control Ledger';
                        recGenLine."Credit Amount" := decECOOperator;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                decECOSellerAggregator := 0;
                decOperatorECOGST := 0;
                decInsurnceControl := 0;
                decBusConvenienceFee := 0;
                decBusFreeCollection := 0;
                decPrimeMembershipFee := 0;
                decBusAssuredIncome := 0;
                decBusRoundedOff := 0;
                Clear(qryBookingPGCollection);
                qryBookingPGCollection.SetRange(Booking_Date, qryBookingPostingDate.Booking_Date);
                qryBookingPGCollection.Open();
                while qryBookingPGCollection.Read() do begin
                    if (qryBookingPGCollection.Type_of_Sales = 'Online') and (qryBookingPGCollection.ECO = 'Abhibus') then begin
                        if blnTestEntries then begin
                            recGenLine.Init();
                            recGenLine."Journal Template Name" := '4';
                            intLineNo += 1;
                            recGenLine."Line No." := intLineNo;
                            recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                            recGenLine."Document No." := cdDocumentNo;
                            recGenLine."Account No." := recSalesSetup."Total Fare Account";
                            recGenLine.Description := qryBookingPGCollection.Type_of_Sales + qryBookingPGCollection.ECO + qryBookingPGCollection.Location_Code;
                            recGenLine."Credit Amount" := qryBookingPGCollection.Total_Fare;
                            recGenLine.Insert();
                        end else begin

                        end;
                    end;
                    if (qryBookingPGCollection.Type_of_Sales = 'Online') and (qryBookingPGCollection.ECO = 'Aggregator') then begin
                        decAggregatorECOCollection += qryBookingPGCollection.Total_Fare;
                    end;
                    if qryBookingPGCollection.Type_of_Sales = 'Online' then begin
                        decOperatorECOGST += qryBookingPGCollection.Total_Tax_on_Fare;
                    end;
                    decInsurnceControl += qryBookingPGCollection.Travel_Insurance;
                    decBusConvenienceFee += qryBookingPGCollection.Service_Charge;
                    decBusFreeCollection += qryBookingPGCollection.Free_Cancellation_Fee;
                    decPrimeMembershipFee += qryBookingPGCollection.Prime_Membership_Fee;
                    decBusAssuredIncome += qryBookingPGCollection.Assured_Subscrption_Fee;
                    decBusRoundedOff += qryBookingPGCollection.Round_Off_Amount;
                end;
                qryBookingPGCollection.Close();

                if decAggregatorECOCollection <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Total Fare Account";
                        recGenLine.Description := 'Aggregator ECO collection control a/c';
                        recGenLine."Credit Amount" := decAggregatorECOCollection;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                recSalesSetup.TestField("Total Tax on Fare");
                if decOperatorECOGST <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Total Tax on Fare";
                        recGenLine.Description := 'Operator ECO GST @5% Payable Control A/c';
                        recGenLine."Credit Amount" := decOperatorECOGST;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                recSalesSetup.TestField("Net PG/Agent Amt. Collected");
                if decInsurnceControl <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Net PG/Agent Amt. Collected";
                        recGenLine.Description := 'Insurance Control A/c';
                        recGenLine."Credit Amount" := decInsurnceControl;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                recSalesSetup.TestField("Service Charge");
                if decBusConvenienceFee <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Service Charge";
                        recGenLine.Description := 'Bus-Convenience Fee Income';
                        recGenLine."Credit Amount" := decBusConvenienceFee;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                recSalesSetup.TestField("Free Cancellation Fee");
                if decBusFreeCollection <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Free Cancellation Fee";
                        recGenLine.Description := 'Free Cancellation Fee';
                        recGenLine."Credit Amount" := decBusFreeCollection;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                recSalesSetup.TestField("Prime Membership Fee");
                if decPrimeMembershipFee <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Prime Membership Fee";
                        recGenLine.Description := 'Prime Membership Fee';
                        recGenLine."Credit Amount" := decPrimeMembershipFee;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                recSalesSetup.TestField("Assured Subscription Fee");
                if decBusAssuredIncome <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Assured Subscription Fee";
                        recGenLine.Description := 'Assured Income';
                        recGenLine."Credit Amount" := decBusAssuredIncome;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                recSalesSetup.TestField("Round Off Income");
                if decBusRoundedOff <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '4';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Round Off Income";
                        recGenLine.Description := 'Round off Amount';
                        recGenLine."Credit Amount" := decBusRoundedOff;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                //Entry 5
                decOperatorECOGST := 0;
                Clear(qryBookingEntry5Debit);
                qryBookingEntry5Debit.SetRange(Booking_Date, qryBookingPostingDate.Booking_Date);
                qryBookingEntry5Debit.Open();
                while qryBookingEntry5Debit.Read() do begin
                    if qryBookingEntry5Debit.Type_of_Sales = 'Agent' then begin
                        if blnTestEntries then begin
                            recGenLine.Init();
                            recGenLine."Journal Template Name" := '5';
                            intLineNo += 1;
                            recGenLine."Line No." := intLineNo;
                            recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                            recGenLine."Document No." := cdDocumentNo;
                            recGenLine."Account No." := recSalesSetup."Total Fare Account";
                            recGenLine.Description := qryBookingEntry5Debit.Seller_Name___Order_ID;
                            recGenLine."Debit Amount" := qryBookingEntry5Debit.Total_Fare + qryBookingEntry5Debit.Total_Tax_on_Fare;
                            recGenLine.Insert();
                        end else begin

                        end;

                        decOperatorECOGST += qryBookingEntry5Debit.Total_Tax_on_Fare;
                    end;
                end;
                qryBookingEntry5Debit.Close();

                if decOperatorECOGST <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '5';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Total Tax on Fare";
                        recGenLine.Description := 'Operator ECO GST';
                        recGenLine."Credit Amount" := decOperatorECOGST;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;

                decECOOperator := 0;
                Clear(qryBookingPGCollection);
                qryBookingPGCollection.Open();
                while qryBookingPGCollection.Read() do begin
                    if (qryBookingPGCollection.Type_of_Sales = 'Agent') and (qryBookingPGCollection.ECO = 'Abhibus') then begin
                        if blnTestEntries then begin
                            recGenLine.Init();
                            recGenLine."Journal Template Name" := '5';
                            intLineNo += 1;
                            recGenLine."Line No." := intLineNo;
                            recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                            recGenLine."Document No." := cdDocumentNo;
                            recGenLine."Account No." := recSalesSetup."Total Fare Account";
                            recGenLine.Description := qryBookingPGCollection.Type_of_Sales + qryBookingPGCollection.ECO + qryBookingPGCollection.Location_Code;
                            recGenLine."Credit Amount" := qryBookingPGCollection.Total_Fare;
                            recGenLine.Insert();
                        end else begin

                        end;
                    end;
                    if (qryBookingPGCollection.Type_of_Sales = 'Agent') and (qryBookingPGCollection.ECO in ['Aggregator', 'Seller']) then begin
                        decECOOperator += qryBookingPGCollection.Total_Fare;
                    end;
                end;
                qryBookingPGCollection.Close();

                if decECOOperator <> 0 then begin
                    if blnTestEntries then begin
                        recGenLine.Init();
                        recGenLine."Journal Template Name" := '5';
                        intLineNo += 1;
                        recGenLine."Line No." := intLineNo;
                        recGenLine."Posting Date" := qryBookingPostingDate.Booking_Date;
                        recGenLine."Document No." := cdDocumentNo;
                        recGenLine."Account No." := recSalesSetup."Total Fare Account";
                        recGenLine.Description := 'Aggregator ECO collection control a/c';
                        recGenLine."Credit Amount" := decECOOperator;
                        recGenLine.Insert();
                    end else begin

                    end;
                end;
            end;
            qryBookingPostingDate.Close();

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