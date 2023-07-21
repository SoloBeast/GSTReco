codeunit 50005 "Import GST  Data"
{
    trigger OnRun()
    begin
        if File.UploadIntoStream('Select Billing File', '', '', txtFileName, ImportInstream) then begin
            tempExcelBuffer.Reset();
            tempExcelBuffer.DeleteAll();

            Evaluate(txtSheetname, tempExcelBuffer.SelectSheetsNameStream(ImportInstream));
        end
    end;

    local procedure ImportB2BFile()
    var
        intTotalColumn: Integer;
        intTotalRows: Integer;
        intLineNo: Integer;
    begin
        tempExcelBuffer.LockTable();
        tempExcelBuffer.OpenBookStream(ImportInstream, Format(txtSheetname));
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

        for intLineNo := 7 to intTotalRows do begin
            recGSTRDump.Reset();
            recGSTRDump.Init();

            tempExcelBuffer.Get(intLineNo, 1);
            recGSTRDump."GSTIN Supplier" := tempExcelBuffer."Cell Value as Text";
            tempExcelBuffer.Get(intLineNo, 2);
            recGSTRDump."Trade/Legal Name" := tempExcelBuffer."Cell Value as Text";
            tempExcelBuffer.Get(intLineNo, 3);
            recGSTRDump."Invoice No" := tempExcelBuffer."Cell Value as Text";
            tempExcelBuffer.Get(intLineNo, 4);
            recGSTRDump."Invoice Type" := tempExcelBuffer."Cell Value as Text";
            tempExcelBuffer.Get(intLineNo, 5);
            Evaluate(recGSTRDump."Invocie Date", tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 6);
            Evaluate(recGSTRDump."Invoice Value", tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 7);
            recGSTRDump."Place of Supply" := tempExcelBuffer."Cell Value as Text";
            tempExcelBuffer.Get(intLineNo, 8);
            Evaluate(recGSTRDump."Supply Attract Reverce Charge", tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 9);
            Evaluate(recGSTRDump."Rate(%)", tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 10);
            Evaluate(recGSTRDump."Taxable Value", tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 11);
            Evaluate(recGSTRDump."Integrated Tax", tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 12);
            Evaluate(recGSTRDump."Central Tax", tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 13);
            Evaluate(recGSTRDump."State/UT Tax", tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 14);
            Evaluate(recGSTRDump.Cess, tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 15);
            Evaluate(recGSTRDump."GSTR-1/IFF/GSTR-5 Period", tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 16);
            Evaluate(recGSTRDump."GSTR-1/IFF/GSTR-5 Date", tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 17);
            Evaluate(recGSTRDump."ITC Availability", tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 18);
            Evaluate(recGSTRDump.Reason, tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 19);
            Evaluate(recGSTRDump."Applicable % of Tax Rate", tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 20);
            Evaluate(recGSTRDump.Source, tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 21);
            Evaluate(recGSTRDump.IRN, tempExcelBuffer."Cell Value as Text");
            tempExcelBuffer.Get(intLineNo, 22);
            Evaluate(recGSTRDump."IRN Date", tempExcelBuffer."Cell Value as Text");
            recGSTRDump."File Type." := recGSTRDump."File Type."::B2B;
            recGSTRDump.Insert();
        end;
    end;

    local procedure ImportB2BAFile()
    var
        intTotalColumn: Integer;
        intTotalRows: Integer;
        intLineNo: Integer;
    begin
        tempExcelBuffer.LockTable();
        tempExcelBuffer.OpenBookStream(ImportInstream, Format(txtSheetname));
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

        for intLineNo := 7 to intTotalRows do begin

        end;
    end;

    local procedure ImportB2B_CDNRFile()
    var
        intTotalColumn: Integer;
        intTotalRows: Integer;
        intLineNo: Integer;
    begin
        tempExcelBuffer.LockTable();
        tempExcelBuffer.OpenBookStream(ImportInstream, Format(txtSheetname));
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

        for intLineNo := 7 to intTotalRows do begin

        end;
    end;

    local procedure ImportB2B_CDNRAFile()
    var
        intTotalColumn: Integer;
        intTotalRows: Integer;
        intLineNo: Integer;
    begin
        tempExcelBuffer.LockTable();
        tempExcelBuffer.OpenBookStream(ImportInstream, Format(txtSheetname));
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

        for intLineNo := 7 to intTotalRows do begin

        end;
    end;

    local procedure ImportIMPGFile()
    var
        intTotalColumn: Integer;
        intTotalRows: Integer;
        intLineNo: Integer;
    begin
        tempExcelBuffer.LockTable();
        tempExcelBuffer.OpenBookStream(ImportInstream, Format(txtSheetname));
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

        for intLineNo := 7 to intTotalRows do begin

        end;
    end;

    var
        tempExcelBuffer: Record "Excel Buffer" temporary;
        ImportInstream: InStream;
        txtFileName: Text;
        txtSheetname: Option "B2B","B2BA","B2B-CDNR","B2B-CDNRA","IMPG";
        recGSTRDump: Record GSTRDump;
}