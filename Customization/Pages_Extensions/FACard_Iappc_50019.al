pageextension 50019 "FA Card Ext." extends "Fixed Asset Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = all;
            }
            field("Tagging No."; Rec."Tagging No.")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }
            field("FA Insured"; Rec."FA Insured")
            {
                ApplicationArea = all;
            }
        }
        addafter("Vendor No.")
        {
            field(Manufacturer; Rec.Manufacturer)
            {
                ApplicationArea = all;
            }
        }
        modify("Budgeted Asset")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("C&opy Fixed Asset")
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
                    if cuIappcAppMgmt.CheckFAApprovalWorkflowEnabled(Rec) then
                        cuIappcAppMgmt.SendFAAccApprovalReq(Rec);
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
                    cuIappcAppMgmt.CancelFAAccApprovalReq(Rec);
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
        modify(Dimensions)
        {
            Visible = true;
        }
        modify("Maintenance &Registration")
        {
            Visible = false;
        }
        modify(Details)
        {
            Visible = false;
        }
        modify(Analysis)
        {
            Visible = false;
        }
        modify("Projected Value")
        {
            Visible = false;
        }
        modify(Acquire)
        {
            Visible = false;
        }
        modify("C&opy Fixed Asset")
        {
            Visible = false;
        }
        modify("Fixed &Asset")
        {
            Visible = false;
        }
        modify("Error Ledger Entries")
        {
            Visible = false;
        }
        modify("Main&tenance Ledger Entries")
        {
            Visible = false;
        }
        modify(Insurance)
        {
            Visible = false;
        }
        modify("FA Book Val. - Appr. & Write-D")
        {
            Visible = false;
        }
        modify("FA Book Value")
        {
            Visible = false;
        }
        modify(Register)
        {
            Visible = false;
        }
        modify("G/L Analysis")
        {
            Visible = false;
        }
    }

    var
}