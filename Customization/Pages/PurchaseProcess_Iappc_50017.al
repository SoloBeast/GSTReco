page 50017 "Purchase Process"
{
    PageType = CardPart;
    SourceTable = "Purchase Cue";

    layout
    {
        area(Content)
        {
            cuegroup(SalesProcess)
            {
                ShowCaption = false;
                field("Open Indents"; Rec."Open Indents")
                {
                    ApplicationArea = all;
                    AccessByPermission = page "Indent List Open" = x;
                    DrillDownPageId = "Indent List Open";
                }
                field("Indents to Approve"; Rec."Indents to Approve")
                {
                    ApplicationArea = all;
                    AccessByPermission = page "Indent List to Approve" = x;
                    DrillDownPageId = "Indent List to Approve";
                }
                field("Approved Indents"; Rec."Approved Indents")
                {
                    ApplicationArea = all;
                    AccessByPermission = page "Indent List Approved" = x;
                    DrillDownPageId = "Indent List Approved";
                }
                field("Indents to Order"; Rec."Indents to Order")
                {
                    ApplicationArea = all;
                    AccessByPermission = page "Indents To Order" = x;
                    DrillDownPageId = "Indents To Order";
                }
                field("Open Orders"; Rec."Open Orders")
                {
                    ApplicationArea = All;
                    AccessByPermission = page "Purchase Order List" = x;
                    DrillDownPageId = "Purchase Order List";
                }
                field("Orders to Approve"; Rec."Orders to Approve")
                {
                    ApplicationArea = All;
                    AccessByPermission = page "Purchase Order List" = x;
                    DrillDownPageId = "Purchase Order List";
                }
                field("Approved Orders"; Rec."Approved Orders")
                {
                    ApplicationArea = All;
                    AccessByPermission = page "Purchase Order List" = x;
                    DrillDownPageId = "Purchase Order List";
                }
                field("Rcpt. not Invoiced"; Rec."Rcpt. not Invoiced")
                {
                    ApplicationArea = All;
                    AccessByPermission = page "Purch. Rcpt. Not Invoiced" = x;
                    DrillDownPageId = "Purch. Rcpt. Not Invoiced";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get then begin
            Rec.init;
            rec.Insert();
        end;
    end;

    var
        myInt: Integer;
}