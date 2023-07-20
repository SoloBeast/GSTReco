tableextension 50051 "Bank Acc. Reco Line Ext." extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        field(50000; "UTR No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        // Add changes to table fields here
        field(71000; "Remarks"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(71001; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    procedure ImportValueDate()
    var
        txtFileName: Text;
        tempExcelBuffer: Record "Excel Buffer" temporary;
        txtSheetName: Text;
        intTotalColumn: Integer;
        intTotalRows: Integer;
        ImportInstream: InStream;
        intLineNo: Integer;
        recBankRecoLines: Record "Bank Acc. Reconciliation Line";
        intRecoLineNo: Integer;
        intBankAccColumnNo: Integer;
        intBankStatementColumnNo: Integer;
        intBankStatementLineColumnNo: Integer;
        intValueDateColumnNo: Integer;
        intRemarksColumnNo: Integer;
    begin
        if File.UploadIntoStream('Select Bank Reco File', '', '', txtFileName, ImportInstream) then begin
            tempExcelBuffer.Reset();
            tempExcelBuffer.DeleteAll();

            txtSheetName := tempExcelBuffer.SelectSheetsNameStream(ImportInstream);
            tempExcelBuffer.LockTable();
            tempExcelBuffer.OpenBookStream(ImportInstream, txtSheetName);
            tempExcelBuffer.SetReadDateTimeInUtcDate(true);
            tempExcelBuffer.ReadSheet();

            intTotalColumn := 0;
            intTotalRows := 0;
            tempExcelBuffer.Reset();
            if tempExcelBuffer.FindLast() then
                intTotalRows := tempExcelBuffer."Row No.";
            tempExcelBuffer.SetRange("Row No.", 1);
            intTotalColumn := tempExcelBuffer.Count;

            intLineNo := 0;
            intBankAccColumnNo := 0;
            intBankStatementColumnNo := 0;
            intBankStatementLineColumnNo := 0;
            intValueDateColumnNo := 0;
            intRemarksColumnNo := 0;
            for intLineNo := 1 to intTotalColumn do begin
                tempExcelBuffer.Get(1, intLineNo);
                if (tempExcelBuffer."Cell Value as Text" = 'Bank Account No.') and (intBankAccColumnNo = 0) then
                    intBankAccColumnNo := intLineNo;
                if (tempExcelBuffer."Cell Value as Text" = 'Statement No.') and (intBankStatementColumnNo = 0) then
                    intBankStatementColumnNo := intLineNo;
                if (tempExcelBuffer."Cell Value as Text" = 'Statement Line No.') and (intBankStatementLineColumnNo = 0) then
                    intBankStatementLineColumnNo := intLineNo;
                if (tempExcelBuffer."Cell Value as Text" = 'Value Date') and (intValueDateColumnNo = 0) then
                    intValueDateColumnNo := intLineNo;
                if (tempExcelBuffer."Cell Value as Text" = 'Remarks') and (intRemarksColumnNo = 0) then
                    intRemarksColumnNo := intLineNo;
            end;

            intLineNo := 0;
            for intLineNo := 2 to intTotalRows do begin
                recBankRecoLines.Reset();
                tempExcelBuffer.Get(intLineNo, intBankAccColumnNo);
                recBankRecoLines.SetRange("Bank Account No.", tempExcelBuffer."Cell Value as Text");
                tempExcelBuffer.Get(intLineNo, intBankStatementColumnNo);
                recBankRecoLines.SetRange("Statement No.", tempExcelBuffer."Cell Value as Text");
                tempExcelBuffer.Get(intLineNo, intBankStatementLineColumnNo);
                Evaluate(intRecoLineNo, tempExcelBuffer."Cell Value as Text");
                recBankRecoLines.SetRange("Statement Line No.", intRecoLineNo);
                recBankRecoLines.FindFirst();

                if tempExcelBuffer.Get(intLineNo, intValueDateColumnNo) then begin
                    Evaluate(recBankRecoLines."Value Date", tempExcelBuffer."Cell Value as Text");
                    recBankRecoLines.Validate("Value Date");
                end;
                if tempExcelBuffer.Get(intLineNo, intRemarksColumnNo) then begin
                    recBankRecoLines.Remarks := tempExcelBuffer."Cell Value as Text";
                end;
                recBankRecoLines.Modify();
            end;
            Message('Value Date import completed.');
        end;
    end;

    var
}