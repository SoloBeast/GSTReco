codeunit 50004 "Get Indent Lines"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    begin
        CLEAR(pgGetIndentToOrder);
        RecPurchHeader.GET(Rec."Document Type", Rec."No.");
        RecPurchHeader.TESTFIELD("Document Type", RecPurchHeader."Document Type"::Order);
        RecPurchHeader.TESTFIELD(Status, RecPurchHeader.Status::Open);
        RecPurchHeader.TESTFIELD("Buy-from Vendor No.");
        RecPurchHeader.TESTFIELD("Location Code");

        recIndentLine.RESET;
        recIndentLine.FILTERGROUP(2);
        recIndentLine.SETRANGE(Status, recIndentLine.Status::Approved);
        recIndentLine.SETFILTER("Remaining Quantity", '<>%1', 0);
        recIndentLine.SETRANGE("Location Code", RecPurchHeader."Location Code");
        recIndentLine.FILTERGROUP(0);

        pgGetIndentToOrder.SetPurchHeader(RecPurchHeader);
        pgGetIndentToOrder.LOOKUPMODE := TRUE;
        pgGetIndentToOrder.RUNMODAL;
    end;

    procedure CreatePurchLines(VAR lrecIndentLines: Record "Indent Line")
    var
    begin
        //Put Filters if required
        lrecIndentLines.SETFILTER("Remaining Quantity", '<>0');
        IF lrecIndentLines.FindSet() THEN BEGIN
            recPurchLine.LOCKTABLE;
            recPurchLine.RESET;
            recPurchLine.SETRANGE("Document Type", recPurchHeader."Document Type");
            recPurchLine.SETRANGE("Document No.", recPurchHeader."No.");
            IF recPurchLine.FINDLAST THEN
                intLineNo := recPurchLine."Line No."
            ELSE
                intLineNo := 0;

            REPEAT
                recPurchLine.INIT;
                recPurchLine.VALIDATE("Document Type", recPurchHeader."Document Type");
                recPurchLine.VALIDATE("Document No.", recPurchHeader."No.");
                intLineNo += 10000;
                recPurchLine.VALIDATE("Line No.", intLineNo);
                recPurchLine.INSERT(TRUE);

                IF lrecIndentLines.Type = lrecIndentLines.Type::Item THEN
                    recPurchLine.VALIDATE(Type, recPurchLine.Type::Item);

                recPurchLine.VALIDATE("No.", lrecIndentLines."No.");
                recPurchLine.VALIDATE(Quantity, lrecIndentLines."Remaining Quantity");
                recPurchLine."Indent No." := lrecIndentLines."Indent No.";
                recPurchLine."Indent Line No." := lrecIndentLines."Line No.";
                recPurchLine.MODIFY(TRUE);

                lrecIndentLines."Remaining Quantity" := 0;
                lrecIndentLines.MODIFY;
            UNTIL lrecIndentLines.Next() = 0;
        END;
    end;

    procedure SetPurchHeader(VAR recPurchHeader2: Record "Purchase Header")
    var
    begin
        recPurchHeader.GET(recPurchHeader2."Document Type", recPurchHeader2."No.");
        recPurchHeader.TESTFIELD("Document Type", recPurchHeader."Document Type"::Order);
    end;

    var
        pgGetIndentToOrder: Page "Get Indent Lines";
        RecPurchHeader: Record "Purchase Header";
        recIndentLine: Record "Indent Line";
        recPurchLine: Record "Purchase Line";
        intLineNo: Integer;
}