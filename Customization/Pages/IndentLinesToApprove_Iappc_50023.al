page 50023 "Indent Line to Approve"
{
    PageType = ListPart;
    UsageCategory = Administration;
    SourceTable = "Indent Line";
    Caption = 'Indent Lines';
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(IndentLines)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approved Quantity"; Rec."Approved Quantity")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    var
}