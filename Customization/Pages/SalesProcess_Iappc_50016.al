page 50016 "Sales Process"
{
    PageType = CardPart;
    SourceTable = "Sales Cue";

    layout
    {
        area(Content)
        {
            cuegroup(SalesProcess)
            {
                ShowCaption = false;
                field("Open Orders"; Rec."Open Orders")
                {
                    ApplicationArea = All;
                    AccessByPermission = page "Sales Order List" = x;
                    DrillDownPageId = "Sales Order List";
                }
                field("Orders to Approve"; Rec."Orders to Approve")
                {
                    ApplicationArea = All;
                    AccessByPermission = page "Sales Order List" = x;
                    DrillDownPageId = "Sales Order List";
                }
                field("Approved Orders"; Rec."Approved Orders")
                {
                    ApplicationArea = All;
                    AccessByPermission = page "Sales Order List" = x;
                    DrillDownPageId = "Sales Order List";
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
}