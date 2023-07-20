page 50018 "Indent List Open"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Administration;
    SourceTable = "Indent Header";
    Caption = 'Indent List';
    CardPageId = "Indent Card Open";
    Editable = false;
    SourceTableView = sorting("No.") where(Status = const(Open));

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
            }
        }
    }

    var
}