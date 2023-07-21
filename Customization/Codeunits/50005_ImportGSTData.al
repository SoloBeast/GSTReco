codeunit 50005 "Import GST  Data"
{
    trigger OnRun()
    begin
        if File.UploadIntoStream('Select Billing File', '', '', txtFileName, ImportInstream) then begin
            tempExcelBuffer.Reset();
            tempExcelBuffer.DeleteAll();

            Evaluate(txtSheetname, tempExcelBuffer.SelectSheetsNameStream(ImportInstream));
            if txtSheetname = txtSheetname::B2B then
                ImportB2BFile(Format(txtSheetname));

            if txtSheetname = txtSheetname::"B2B-CDNR" then
                ImportB2B_CDNRFile(Format(txtSheetname));

            if txtSheetname = txtSheetname::IMPG then
                ImportIMPGFile(Format(txtSheetname));

        end
    end;

    local procedure ImportB2BFile(txtSheetName: Text)
    var
        intTotalColumn: Integer;
        intTotalRows: Integer;
        intLineNo: Integer;
    begin
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

        for intLineNo := 7 to intTotalRows do begin
            recGSTRDump.Init();

            if tempExcelBuffer.Get(intLineNo, 1) then
                recGSTRDump."GSTIN Supplier" := tempExcelBuffer."Cell Value as Text";
            if tempExcelBuffer.Get(intLineNo, 2) then
                recGSTRDump."Trade/Legal Name" := tempExcelBuffer."Cell Value as Text";
            if tempExcelBuffer.Get(intLineNo, 3) then
                recGSTRDump."Invoice No" := tempExcelBuffer."Cell Value as Text";
            if tempExcelBuffer.Get(intLineNo, 4) then
                recGSTRDump."Invoice Type" := tempExcelBuffer."Cell Value as Text";
            if tempExcelBuffer.Get(intLineNo, 5) then
                Evaluate(recGSTRDump."Invocie Date", tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 6) then
                Evaluate(recGSTRDump."Invoice Value", tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 7) then
                recGSTRDump."Place of Supply" := tempExcelBuffer."Cell Value as Text";
            if tempExcelBuffer.Get(intLineNo, 8) then
                Evaluate(recGSTRDump."Supply Attract Reverce Charge", tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 9) then
                Evaluate(recGSTRDump."Rate(%)", tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 10) then
                Evaluate(recGSTRDump."Taxable Value", tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 11) then
                Evaluate(recGSTRDump."Integrated Tax", tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 12) then
                Evaluate(recGSTRDump."Central Tax", tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 13) then
                Evaluate(recGSTRDump."State/UT Tax", tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 14) then
                Evaluate(recGSTRDump.Cess, tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 15) then
                Evaluate(recGSTRDump."GSTR-1/IFF/GSTR-5 Period", tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 16) then
                Evaluate(recGSTRDump."GSTR-1/IFF/GSTR-5 Date", tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 17) then
                Evaluate(recGSTRDump."ITC Availability", tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 18) then
                Evaluate(recGSTRDump.Reason, tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 19) then
                Evaluate(recGSTRDump."Applicable % of Tax Rate", tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 20) then
                Evaluate(recGSTRDump.Source, tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 21) then
                Evaluate(recGSTRDump.IRN, tempExcelBuffer."Cell Value as Text");
            if tempExcelBuffer.Get(intLineNo, 22) then
                Evaluate(recGSTRDump."IRN Date", tempExcelBuffer."Cell Value as Text");
            recGSTRDump."File Type." := recGSTRDump."File Type."::B2B;
            recGSTRDump.Insert();
        end;
    end;


    local procedure ImportB2B_CDNRFile(txtSheetName: Text)
    var
        intTotalColumn: Integer;
        intTotalRows: Integer;
        intLineNo: Integer;
    begin
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

        for intLineNo := 7 to intTotalRows do begin
            recGSTRDump.Reset();
            recGSTRDump.Init();

            if tempExcelBuffer.Get(intLineNo, 1) then
                recGSTRDump."GSTIN Supplier" := tempExcelBuffer."Cell Value as Text";

            if tempExcelBuffer.Get(intLineNo, 2) then
                recGSTRDump."Trade/Legal Name" := tempExcelBuffer."Cell Value as Text";

            if tempExcelBuffer.Get(intLineNo, 3) then
                recGSTRDump."Invoice No" := tempExcelBuffer."Cell Value as Text";

            if tempExcelBuffer.Get(intLineNo, 4) then
                Evaluate(recGSTRDump."Note Type", tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 5) then
                recGSTRDump."Invoice Type" := tempExcelBuffer."Cell Value as Text";

            if tempExcelBuffer.Get(intLineNo, 6) then
                Evaluate(recGSTRDump."Invocie Date", tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 7) then
                Evaluate(recGSTRDump."Invoice Value", tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 8) then
                recGSTRDump."Place of Supply" := tempExcelBuffer."Cell Value as Text";

            if tempExcelBuffer.Get(intLineNo, 9) then
                Evaluate(recGSTRDump."Supply Attract Reverce Charge", tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 10) then
                Evaluate(recGSTRDump."Rate(%)", tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 11) then
                Evaluate(recGSTRDump."Taxable Value", tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 12) then
                Evaluate(recGSTRDump."Integrated Tax", tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 13) then
                Evaluate(recGSTRDump."Central Tax", tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 14) then
                Evaluate(recGSTRDump."State/UT Tax", tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 15) then
                Evaluate(recGSTRDump.Cess, tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 16) then
                Evaluate(recGSTRDump."GSTR-1/IFF/GSTR-5 Period", tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 17) then
                Evaluate(recGSTRDump."GSTR-1/IFF/GSTR-5 Date", tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 18) then
                Evaluate(recGSTRDump."ITC Availability", tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 19) then
                Evaluate(recGSTRDump.Reason, tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 20) then
                Evaluate(recGSTRDump."Applicable % of Tax Rate", tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 21) then
                Evaluate(recGSTRDump.Source, tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 22) then
                Evaluate(recGSTRDump.IRN, tempExcelBuffer."Cell Value as Text");

            if tempExcelBuffer.Get(intLineNo, 23) then
                Evaluate(recGSTRDump."IRN Date", tempExcelBuffer."Cell Value as Text");

            recGSTRDump."File Type." := recGSTRDump."File Type."::"B2B-CDNR";
            recGSTRDump.Insert();

            intLineNo := 0;
        end;
    end;


    local procedure ImportIMPGFile(txtSheetName: Text)
    var
        intTotalColumn: Integer;
        intTotalRows: Integer;
        intLineNo: Integer;
    begin
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

        for intLineNo := 7 to intTotalRows do begin

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

                if tempExcelBuffer.Get(intLineNo, 1) then
                    Evaluate(recGSTRDump."Icegate Reference Date", tempExcelBuffer."Cell Value as Text");

                if tempExcelBuffer.Get(intLineNo, 2) then
                    Evaluate(recGSTRDump."Port Code", tempExcelBuffer."Cell Value as Text");

                if tempExcelBuffer.Get(intLineNo, 3) then
                    recGSTRDump."Invoice No" := tempExcelBuffer."Cell Value as Text";

                if tempExcelBuffer.Get(intLineNo, 4) then
                    Evaluate(recGSTRDump."Invocie Date", tempExcelBuffer."Cell Value as Text");

                if tempExcelBuffer.Get(intLineNo, 5) then
                    Evaluate(recGSTRDump."Taxable Value", tempExcelBuffer."Cell Value as Text");

                if tempExcelBuffer.Get(intLineNo, 6) then
                    Evaluate(recGSTRDump."Integrated Tax", tempExcelBuffer."Cell Value as Text");

                if tempExcelBuffer.Get(intLineNo, 7) then
                    Evaluate(recGSTRDump.Cess, tempExcelBuffer."Cell Value as Text");

                if tempExcelBuffer.Get(intLineNo, 8) then
                    Evaluate(recGSTRDump."Amended (Yes)", tempExcelBuffer."Cell Value as Text");

                recGSTRDump."File Type." := recGSTRDump."File Type."::IMPG;
                recGSTRDump.Insert();

                intLineNo := 0;

                for intLineNo := 7 to intTotalRows do begin

                end;
            end


        end;
    end;

    var
        tempExcelBuffer: Record "Excel Buffer" temporary;
        ImportInstream: InStream;
        txtFileName: Text;
        txtSheetname: Option "B2B","B2BA","B2B-CDNR","B2B-CDNRA","IMPG";
        recGSTRDump: Record GSTRDump;
}