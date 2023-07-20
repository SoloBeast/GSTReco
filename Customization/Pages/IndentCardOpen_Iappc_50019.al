page 50019 "Indent Card Open"
{
    PageType = Document;
    UsageCategory = Administration;
    SourceTable = "Indent Header";
    Caption = 'Indent Card';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
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
            part(IndentLine; "Indent Line Open")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Indent Lines';
                SubPageView = sorting("Indent No.", "Line No.");
                SubPageLink = "Indent No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SubmitForApproval)
            {
                ApplicationArea = All;
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.SubmitForApproval();
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    var
}