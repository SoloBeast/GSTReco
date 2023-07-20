page 50025 "Indent Card Approved"
{
    PageType = Document;
    UsageCategory = Administration;
    SourceTable = "Indent Header";
    Caption = 'Indent Card';
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            group(GroupName)
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
                    ApplicationArea = All;
                }
            }
            part(IndentLine; "Indent Line to Approve")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Indent Lines';
                SubPageView = sorting("Indent No.", "Line No.");
                SubPageLink = "Indent No." = field("No.");
                Editable = false;
            }
        }
    }

    var
}