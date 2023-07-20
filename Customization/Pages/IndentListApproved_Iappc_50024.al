page 50024 "Indent List Approved"
{
    PageType = List;
    ApplicationArea = Basic, Suit;
    UsageCategory = Administration;
    SourceTable = "Indent Header";
    Caption = 'Indent List';
    CardPageId = "Indent Card Approved";
    Editable = false;
    SourceTableView = sorting("No.") where(Status = const(Approved));

    layout
    {
        area(Content)
        {
            repeater(IndentList)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Last Remarks"; Rec."Last Remarks")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    var
}