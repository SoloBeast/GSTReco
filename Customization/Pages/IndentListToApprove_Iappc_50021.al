page 50021 "Indent List to Approve"
{
    PageType = List;
    ApplicationArea = Basic, Suit;
    UsageCategory = Administration;
    SourceTable = "Indent Header";
    Caption = 'Indent List';
    CardPageId = "Indent Card to Approve";
    Editable = false;
    SourceTableView = sorting("No.") where(Status = const("Pending Approval"));

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
                field("Submitted At"; Rec."Submitted At")
                {
                    ApplicationArea = All;
                }
                field("Submitted By"; Rec."Submitted By")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
}