page 50022 "Indent Card to Approve"
{
    PageType = Document;
    UsageCategory = Administration;
    SourceTable = "Indent Header";
    Caption = 'Indent Card';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Remarks)
            {
                field("Approval / Rejection Remarks"; txtRemarks)
                {
                    ApplicationArea = all;
                }
            }
            group(GroupName)
            {
                Editable = false;
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
                field("Submitted At"; Rec."Submitted At")
                {
                    ApplicationArea = All;
                }
                field("Submitted By"; Rec."Submitted By")
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
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Visible = blnCanApprove;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Approve(txtRemarks);
                    CurrPage.CLOSE;
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Visible = blnCanApprove;
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Reject(txtRemarks);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        recUserSetup.Get(Rec."Created By");
        recUserSetup.TestField("Approver ID");
        if recUserSetup."Approver ID" = UserId then
            blnCanApprove := true
        else
            blnCanApprove := false;
    end;

    var
        txtRemarks: Text[250];
        blnCanApprove: Boolean;
        recUserSetup: Record "User Setup";
}