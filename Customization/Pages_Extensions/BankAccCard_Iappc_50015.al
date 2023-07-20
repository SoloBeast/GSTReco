pageextension 50015 "Bank Account Card Ext." extends "Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        modify("SEPA Direct Debit Exp. Format")
        {
            Visible = false;
        }
        modify("Credit Transfer Msg. Nos.")
        {
            Visible = false;
        }
        modify("Direct Debit Msg. Nos.")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
        modify("Bank Clearing Standard")
        {
            Visible = false;
        }
        modify("Bank Clearing Code")
        {
            Visible = false;
        }
        modify("Payment Matching")
        {
            Visible = false;
        }
        modify("Disable Automatic Pmt Matching")
        {
            Visible = false;
        }
        modify("Payment Match Tolerance")
        {
            Visible = false;
        }
        modify("Match Tolerance Type")
        {
            Visible = false;
        }
        modify("Match Tolerance Value")
        {
            Visible = false;
        }
        modify("Last Check No.")
        {
            Visible = false;
        }
        modify("Transit No.")
        {
            Visible = false;
        }
        modify("Last Payment Statement No.")
        {
            Visible = false;
        }
        modify("SWIFT Code")
        {
            Visible = true;
        }
        modify(IBAN)
        {
            Visible = false;
        }
        modify("Bank Statement Import Format")
        {
            Visible = false;
        }
        modify("Payment Export Format")
        {
            Visible = false;
        }
        modify(Transfer)
        {
            Visible = false;
        }
        modify("Transit No.2")
        {
            Visible = false;
        }
        moveafter("IFSC Code"; "SWIFT Code")
        addafter("SWIFT Code")
        {
            field("MICR Code"; Rec."MICR Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Bank Account Balance")
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
                    if cuIappcAppMgmt.CheckBankApprovalWorkflowEnabled(Rec) then
                        cuIappcAppMgmt.SendBankAccApprovalReq(Rec);
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
                    cuIappcAppMgmt.CancelBankAccApprovalReq(Rec);
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
        modify("Detail Trial Balance")
        {
            Visible = false;
        }
        modify("Check Details")
        {
            Visible = false;
        }
        modify("Chec&k Ledger Entries")
        {
            Visible = false;
        }
        modify("Cash Receipt Journals")
        {
            Visible = false;
        }
        modify("Payment Journals")
        {
            Visible = false;
        }
        modify("Receivables-Payables")
        {
            Visible = false;
        }
        modify("Online Map")
        {
            Visible = false;
        }
        modify(List)
        {
            Visible = false;
        }
        modify("Bank Account Balance")
        {
            Visible = false;
        }
        modify(BankAccountReconciliations)
        {
            Visible = false;
        }
        modify(Action1906306806)
        {
            Visible = false;
        }
    }

    var
}