pageextension 50007 "COA Ext." extends "Chart of Accounts"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Group Name"; Rec."Group Name")
            {
                ApplicationArea = all;
            }
            field("Sub Group Name"; Rec."Sub Group Name")
            {
                ApplicationArea = all;
            }
        }
        modify("Account Category")
        {
            Visible = true;
        }
        modify("Direct Posting")
        {
            Visible = true;
        }
        modify("Cost Type No.")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }

        moveafter("Income/Balance"; "Account Category")
        moveafter("Gen. Prod. Posting Group"; "Direct Posting")
        moveafter("Direct Posting"; "Net Change")
        moveafter("Net Change"; Balance)
    }

    actions
    {
        // Add changes to page actions here
        addafter(IndentChartOfAccounts)
        {
            action(SendApprovalReq)
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    cuIappcAppMgmt: Codeunit "Custom Work Flow Management";
                begin
                    Clear(cuIappcAppMgmt);
                    if cuIappcAppMgmt.CheckGLApprovalWorkflowEnabled(Rec) then
                        cuIappcAppMgmt.SendGLAccApprovalReq(Rec);
                end;
            }
            action(CancelAppReq)
            {
                Caption = 'Cancel Approval Request';
                Image = CancelApprovalRequest;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    cuIappcAppMgmt: Codeunit "Custom Work Flow Management";
                begin
                    Clear(cuIappcAppMgmt);
                    cuIappcAppMgmt.CancelGLAccApprovalReq(Rec);
                end;
            }
            action(ApproveAppReq)
            {
                Caption = 'Approve';
                Image = Approve;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    cuApprovalMgmt: Codeunit "Approvals Mgmt.";
                begin
                    Clear(cuApprovalMgmt);
                    cuApprovalMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                end;
            }
            action(RejectAppReq)
            {
                Caption = 'Reject';
                Image = Reject;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    cuApprovalMgmt: Codeunit "Approvals Mgmt.";
                begin
                    Clear(cuApprovalMgmt);
                    cuApprovalMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                end;
            }
        }
        modify("General Journal")
        {
            Visible = false;
        }
        modify("Close Income Statement")
        {
            Visible = false;
        }
        modify("G/L Register")
        {
            Visible = false;
        }
        modify("Periodic Activities")
        {
            Visible = false;
        }
        modify("E&xtended Texts")
        {
            Visible = false;
        }
        modify("Receivables-Payables")
        {
            Visible = false;
        }
        modify("Where-Used List")
        {
            Visible = false;
        }
        modify(Action1900210206)
        {
            Visible = false;
        }
    }

    var
}