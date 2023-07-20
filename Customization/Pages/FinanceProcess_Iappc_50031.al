page 50031 "Finance Process"
{
    PageType = CardPart;
    SourceTable = "Finance Cue";

    layout
    {
        area(Content)
        {
            cuegroup(FinanceProcess)
            {
                ShowCaption = false;
                field("Purchase Invoice to Book"; Rec."Purchase Invoice to Book")
                {
                    ApplicationArea = All;
                    AccessByPermission = page "Purchase Lines" = x;
                }
                field("Sales Invoice to Book"; Rec."Sales Invoice to Book")
                {
                    ApplicationArea = All;
                    AccessByPermission = page "Sales Lines" = x;
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

        Rec.SETFILTER("Due Date Filter", '<=%1', WORKDATE);
        Rec.SETFILTER("Overdue Date Filter", '<%1', WORKDATE);
    end;

    var
}