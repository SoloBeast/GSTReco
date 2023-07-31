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
        recGSTData.Reset();
        recGSTData.SetRange(Match, false);

        if cdUserInputGST <> '' then
            recGSTData.SetRange("GSTIN Supplier", cdUserInputGST);

        if recGSTData.FindSet() then begin
            repeat
                recPurchTransaction1.Reset();
                recPurchTransaction1.SetRange("Vendor GST No.", recGSTData."GSTIN Supplier");
                if recPurchTransaction1.FindSet() then begin
                    repeat
                        //Extact GST Number
                        recPurchTransaction2.Reset();
                        recPurchTransaction2.SetRange("Vendor GST No.", recPurchTransaction1."Vendor GST No.");
                        recPurchTransaction2.SetRange("External Document No", recGSTData."Invoice No");
                        if recPurchTransaction2.FindFirst() then begin
                            repeat
                                if (recPurchTransaction2."Document Date" <> recGSTData."Invocie Date") and (recPurchTransaction2."Taxable Value" <> recGSTData."Taxable Value") then
                                    DML_ErrorLog(recGSTData."Entry No.", recGSTData."Invoice No", 'Date and Amount Mismatched in Purchase Data.', Format(recErrorLog.Status::Pending), false);

                                if (recPurchTransaction2."Document Date" = recGSTData."Invocie Date") and (recPurchTransaction2."Taxable Value" <> recGSTData."Taxable Value") then
                                    DML_ErrorLog(recGSTData."Entry No.", recGSTData."Invoice No", 'Amount Mismatched  in Purchase Data.', Format(recErrorLog.Status::Pending), false);

                                if (recPurchTransaction2."Document Date" <> recGSTData."Invocie Date") and (recPurchTransaction2."Taxable Value" = recGSTData."Taxable Value") then
                                    DML_ErrorLog(recGSTData."Entry No.", recGSTData."Invoice No", 'Date Mismatched in Purchase Data.', Format(recErrorLog.Status::Pending), false);

                                if (recPurchTransaction2."Document Date" = recGSTData."Invocie Date") and (recPurchTransaction2."Taxable Value" = recGSTData."Taxable Value") then begin
                                    recGSTData.Match := true;
                                    recPurchTransaction2.Match := true;
                                end;
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
                    until recPurchTransaction1.Next() = 0;
                end
                else
                    DML_ErrorLog(recGSTData."Entry No.", recGSTData."Invoice No", 'Gst number not found  in Purchase Transaction.', Format(recErrorLog.Status::Pending), false);
            until recGSTData.Next() = 0;
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
}