page 50027 "Get Indent Lines"
{
    PageType = List;
    UsageCategory = Administration;
    SourceTable = "Indent Line";
    SourceTableView = sorting("Indent No.", "Line No.") where(Status = const(Approved), "Remaining Quantity" = filter(<> 0));
    Editable = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(PendingIndent)
            {
                field("Indent No."; Rec."Indent No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Approved Quantity"; Rec."Approved Quantity")
                {
                    ApplicationArea = All;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN
            CreateLines;
    end;

    procedure SetPurchHeader(var recPurchHeader2: Record "Purchase Header")
    var
    begin
        recPurchHeader.GET(recPurchHeader2."Document Type", recPurchHeader2."No.");
        recPurchHeader.TESTFIELD("Document Type", recPurchHeader."Document Type"::Order);
    end;

    local procedure CreateLines()
    var
    begin
        IF NOT Rec.ISEMPTY THEN BEGIN
            CurrPage.SETSELECTIONFILTER(Rec);
            cuGetIndentLines.SetPurchHeader(recPurchHeader);
            cuGetIndentLines.CreatePurchLines(Rec);
        END;
    end;

    var
        recPurchHeader: Record "Purchase Header";
        cuGetIndentLines: Codeunit "Get Indent Lines";
}