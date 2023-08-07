codeunit 50010 "GST Reco"
{
    trigger OnRun()
    begin
        checkData();
    end;

    local procedure checkData()
    var
        recPurchTransaction1: Record PurchaseTransactions;
        recPurchTransaction2: Record PurchaseTransactions;
        recGSTData: Record GSTRDump;
    begin
        Clear(qryGSTReco);
        qryGSTReco.Open();
        while qryGSTReco.Read() do begin
            blnGSTExist := false;
            recGSTData.Reset();
            recGSTData.SetRange("Entry No.", qryGSTReco.Entry_No_);
            recGSTData.FindFirst();
            // end;
            // recGSTData.Reset();
            // recGSTData.SetRange(Match, false);
            // if cdUserInputGST <> '' then
            //     recGSTData.SetRange("GSTIN Supplier", cdUserInputGST);
            // if recGSTData.FindSet() then begin
            // repeat
            recPurchTransaction1.Reset();
            recPurchTransaction1.SetRange("Vendor GST No.", qryGSTReco.GSTIN_Supplier);
            if recPurchTransaction1.FindFirst() then begin
                blnGSTExist := true;
            End
            else
                DML_ErrorLog(qryGSTReco.Entry_No_, qryGSTReco.Invoice_No, 'Gst number not found  in Purchase Transaction.', Format(recErrorLog.Status::Pending), false);

            if blnGSTExist = true then begin

                //Extact GST Number
                // if qryGSTReco.Invoice_No = 'CR947' then
                //     Message('CR947');

                recPurchTransaction2.Reset();
                recPurchTransaction2.SetRange("Vendor GST No.", qryGSTReco.GSTIN_Supplier);
                recPurchTransaction2.SetRange("External Document No", qryGSTReco.Invoice_No);
                recPurchTransaction2.SetRange(Match, false);
                if recPurchTransaction2.FindFirst() then begin
                    repeat
                        if (recPurchTransaction2."Document Date" = qryGSTReco.Invocie_Date) and (recPurchTransaction2."Taxable Value" = qryGSTReco.Taxable_Value) then begin
                            recGSTData.Match := true;
                            recPurchTransaction2.Match := true;

                            recGSTData.Modify();
                            recPurchTransaction2.Modify();
                            break;
                        end;

                        if (recPurchTransaction2."Document Date" <> qryGSTReco.Invocie_Date) and (recPurchTransaction2."Taxable Value" <> qryGSTReco.Taxable_Value) then
                            DML_ErrorLog(qryGSTReco.Entry_No_, qryGSTReco.Invoice_No, 'Date and Amount Mismatched in Purchase Data.', Format(recErrorLog.Status::Pending), false);

                        if (recPurchTransaction2."Document Date" = qryGSTReco.Invocie_Date) and (recPurchTransaction2."Taxable Value" <> qryGSTReco.Taxable_Value) then
                            DML_ErrorLog(qryGSTReco.Entry_No_, qryGSTReco.Invoice_No, 'Amount Mismatched  in Purchase Data.', Format(recErrorLog.Status::Pending), false);

                        if (recPurchTransaction2."Document Date" <> qryGSTReco.Invocie_Date) and (recPurchTransaction2."Taxable Value" = qryGSTReco.Taxable_Value) then
                            DML_ErrorLog(qryGSTReco.Entry_No_, qryGSTReco.Invoice_No, 'Date Mismatched in Purchase Data.', Format(recErrorLog.Status::Pending), false);

                        recGSTData.Modify();
                        recPurchTransaction2.Modify();
                    until recPurchTransaction2.Next() = 0;
                end
                Else begin
                    recGSTData.Error := true;
                    recGSTData.Match := false;
                    recGSTData."Error Description" := 'Invoice No. Not found in Purchase Transaction';
                    recGSTData.Modify();
                end;
            end;
            // end

            // until recGSTData.Next() = 0;
        end;
        CheckDataPurchInGST();
    end;

    local procedure CheckDataPurchInGST()
    var
        recGSTDataP: Record GSTRDump;
        recGSTDataP2: Record GSTRDump;
        recPurchTransactionP: Record PurchaseTransactions;
    begin
        recPurchTransactionP.Reset();
        recPurchTransactionP.SetRange(Match, false);

        if cdUserInputGST <> '' then
            recPurchTransactionP.SetRange("Vendor GST No.", cdUserInputGST);

        if recPurchTransactionP.FindSet() then begin
            repeat
                recGSTDataP.Reset();
                recGSTDataP.SetRange(Match, false);
                recGSTDataP.SetRange("GSTIN Supplier", recPurchTransactionP."Vendor GST No.");
                if recGSTDataP.FindSet() then begin
                    repeat
                        recGSTDataP2.Reset();
                        recGSTDataP2.SetRange("GSTIN Supplier", recGSTDataP."GSTIN Supplier");
                        recGSTDataP2.SetFilter("Invoice No", '@*%1', recPurchTransactionP."External Document No");
                        if recGSTDataP2.FindSet() then begin
                            repeat
                                if (recGSTDataP2."Invocie Date" = recPurchTransactionP."Document Date") and (recGSTDataP2."Taxable Value" = recPurchTransactionP."Taxable Value") then
                                    DML_ErrorLog(recPurchTransactionP."Entry No.", recPurchTransactionP."External Document No", 'Invoice No. (' + recPurchTransactionP."External Document No" + ') Partially Matched in GST Data.', Format(recErrorLog.Status::Pending), true);

                                if (recGSTDataP2."Invocie Date" <> recPurchTransactionP."Document Date") and (recGSTDataP2."Taxable Value" = recPurchTransactionP."Taxable Value") then
                                    DML_ErrorLog(recPurchTransactionP."Entry No.", recPurchTransactionP."External Document No", 'Invoice No.(' + recPurchTransactionP."External Document No" + ') Partially Matched with amount in GST Data.', Format(recErrorLog.Status::Pending), true);

                                if (recGSTDataP2."Invocie Date" = recPurchTransactionP."Document Date") and (recGSTDataP2."Taxable Value" <> recPurchTransactionP."Taxable Value") then
                                    DML_ErrorLog(recPurchTransactionP."Entry No.", recPurchTransactionP."External Document No", 'Invoice No.(' + recPurchTransactionP."External Document No" + ') Partially Matched with Date in GST Data.', Format(recErrorLog.Status::Pending), true);

                            until recGSTDataP2.Next() = 0;
                        end
                        else
                            DML_ErrorLog(recPurchTransactionP."Entry No.", recPurchTransactionP."External Document No", 'Invoice No. not found in GST Data.', Format(recErrorLog.Status::Pending), false);

                    until recGSTDataP.Next() = 0;
                end
                else
                    DML_ErrorLog(recPurchTransactionP."Entry No.", recPurchTransactionP."External Document No", 'GST No. not found in GST Data.', Format(recErrorLog.Status::Pending), false);
            until recPurchTransactionP.Next() = 0;
        end;

    end;

    procedure DML_ErrorLog(EntryNo: Integer; InvNo: Code[20]; ErrorDesc: Text[250]; Status: Text[20]; PartialyMatched: Boolean)
    var
        recErrorLog: Record "Error Log";
    begin
        recErrorLog.Init();
        recErrorLog."GST Entry No" := EntryNo;
        recErrorLog."Invoice No." := InvNo;
        recErrorLog."Error Description" := ErrorDesc;
        Evaluate(recErrorLog.Status, Status);
        recErrorLog."Error Time" := CurrentDateTime;
        recErrorLog."Reco By" := UserId;
        recErrorLog."Partially Matched" := PartialyMatched;
        recErrorLog.Insert();
    end;

    procedure setParameter(InputGSTNo: Code[15])
    begin
        cdUserInputGST := InputGSTNo;
    end;

    procedure deleteErrorLog()
    var
        recErrorLogdel: Record "Error Log";
        recGSTR: Record GSTRDump;
        recpur: Record PurchaseTransactions;
    begin
        recErrorLogdel.Reset();
        recErrorLogdel.DeleteAll();

        recGSTR.Reset();
        recGSTR.ModifyAll(Match, false);
        recpur.Reset();
        recpur.ModifyAll(Match, false);
    end;

    var
        recErrorLog: Record "Error Log";
        cdUserInputGST: Code[15];
        qryGSTReco: Query "GST Reco";
        blnGSTExist: Boolean;
}