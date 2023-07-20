page 50020 "Indent Line Open"
{
    PageType = ListPart;
    UsageCategory = Administration;
    SourceTable = "Indent Line";
    Caption = 'Indent Lines';
    DelayedInsert = true;
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
            }
        }
    }

    var
}