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
        recPurchTransaction3: Record PurchaseTransactions;
        recGSTData: Record GSTRDump;
    begin
        recGSTData.Reset();
        if recGSTData.FindSet() then begin
            repeat
                recPurchTransaction1.Reset();
                recPurchTransaction1.SetRange("Vendor GST No.", recGSTData."GSTIN Supplier");
                if recPurchTransaction1.FindSet() then begin
                    repeat
                        //Extact Invoice Number
                        recPurchTransaction2.Reset();//GST Filter
                        recPurchTransaction2.SetRange("External Document No", recGSTData."Invoice No");
                        if recPurchTransaction2.FindFirst() then begin
                            if (recPurchTransaction2."Document Date" <> recGSTData."Invocie Date") and (recPurchTransaction2."Taxable Amount" <> recGSTData."Taxable Amount") then
                                DML_ErrorLog(recGSTData."Entry No.", recGSTData."Invoice No", 'Date and Amount Mismatched. ' + txtMultipleInvNo, Format(recErrorLog.Status::Pending))
                            else begin
                                if (recPurchTransaction2."Document Date" = recGSTData."Invocie Date") and (recPurchTransaction2."Taxable Amount" <> recGSTData."Taxable Amount") then
                                    DML_ErrorLog(recGSTData."Entry No.", recGSTData."Invoice No", 'Date Mismatched. ' + txtMultipleInvNo, Format(recErrorLog.Status::Pending))
                            end;

                        end
                        Else begin
                            //Partial Invoice Number
                            recPurchTransaction2.Reset();
                            recPurchTransaction2.SetFilter("External Document No", '@*%1', recGSTData."Invoice No");
                            if recPurchTransaction2.FindSet() then begin
                                repeat
                                    if txtMultipleInvNo <> '' then
                                        txtMultipleInvNo += ', ' + recPurchTransaction2."External Document No"
                                    else
                                        txtMultipleInvNo := recPurchTransaction2."External Document No";
                                until recPurchTransaction2.Next() = 0;
                                DML_ErrorLog(recGSTData."Entry No.", recGSTData."Invoice No", 'Partial Matched with Document No: ' + txtMultipleInvNo, Format(recErrorLog.Status::Pending));
                            end;
                        end;
                    until recPurchTransaction1.Next() = 0;
                end
                else
                    DML_ErrorLog(recGSTData."Entry No.", recGSTData."Invoice No", 'Gst number not found  in Purchase Transaction.', Format(recErrorLog.Status::Pending));
            until recGSTData.Next() = 0;
        end
    end;

    procedure DML_ErrorLog(EntryNo: Integer; InvNo: Code[20]; ErrorDesc: Text[250]; Status: Text[20])
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
        recErrorLog.Insert();
    end;

    var
        recErrorLog: Record "Error Log";
        txtMultipleInvNo: Text;
}