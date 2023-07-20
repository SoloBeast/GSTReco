codeunit 50006 "Custom Work Flow Management"
{
    trigger OnRun()
    begin

    end;

    //Workflow for G/L Account Approval Begin
    procedure CheckGLApprovalWorkflowEnabled(var GLAcc: Record "G/L Account"): Boolean
    var
    begin
        if not cuWorkflowManagement.CanExecuteWorkflow(GLAcc, RunWorkflowOnSendGLAccForApprovalCode()) then
            Error('This record is not supported by related approval workflow.');

        exit(true);
    end;

    local procedure RunWorkflowOnSendGLAccForApprovalCode(): Code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendGLAccForApproval'));
    end;

    local procedure RunWorkflowOnCancelGLAccForApprovalCode(): Code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnCancelGLAccForApproval'));
    end;

    procedure SendGLAccApprovalReq(var GLAcc: Record "G/L Account")
    var
    begin
        cuWorkflowManagement.HandleEvent(RunWorkflowOnSendGLAccForApprovalCode, GLAcc);
    end;

    procedure CancelGLAccApprovalReq(var GLAcc: Record "G/L Account")
    var
    begin
        cuWorkflowManagement.HandleEvent(RunWorkflowOnCancelGLAccForApprovalCode(), GLAcc);
    end;
    //Workflow for G/L Account Approval End

    //Workflow for Bank Account Approval Begin
    procedure CheckBankApprovalWorkflowEnabled(var BankAcc: Record "Bank Account"): Boolean
    var
    begin
        if not cuWorkflowManagement.CanExecuteWorkflow(BankAcc, RunWorkflowOnSendBankAccForApprovalCode()) then
            Error('This record is not supported by related approval workflow.');

        exit(true);
    end;

    local procedure RunWorkflowOnSendBankAccForApprovalCode(): Code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendBankAccForApproval'));
    end;

    local procedure RunWorkflowOnCancelBankAccForApprovalCode(): Code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnCancelBankAccForApproval'));
    end;

    procedure SendBankAccApprovalReq(var BankAcc: Record "Bank Account")
    var
    begin
        cuWorkflowManagement.HandleEvent(RunWorkflowOnSendBankAccForApprovalCode, BankAcc);
    end;

    procedure CancelBankAccApprovalReq(var BankAcc: Record "Bank Account")
    var
    begin
        cuWorkflowManagement.HandleEvent(RunWorkflowOnCancelBankAccForApprovalCode(), BankAcc);
    end;
    //Workflow for G/L Account Approval End

    //Workflow for FA Account Approval Begin
    procedure CheckFAApprovalWorkflowEnabled(var FAAcc: Record "Fixed Asset"): Boolean
    var
    begin
        if not cuWorkflowManagement.CanExecuteWorkflow(FAAcc, RunWorkflowOnSendFAAccForApprovalCode()) then
            Error('This record is not supported by related approval workflow.');

        exit(true);
    end;

    local procedure RunWorkflowOnSendFAAccForApprovalCode(): Code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendFAAccForApproval'));
    end;

    local procedure RunWorkflowOnCancelFAAccForApprovalCode(): Code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnCancelFAAccForApproval'));
    end;

    procedure SendFAAccApprovalReq(var FAAcc: Record "Fixed Asset")
    var
    begin
        cuWorkflowManagement.HandleEvent(RunWorkflowOnSendFAAccForApprovalCode, FAAcc);
    end;

    procedure CancelFAAccApprovalReq(var FAAcc: Record "Fixed Asset")
    var
    begin
        cuWorkflowManagement.HandleEvent(RunWorkflowOnCancelFAAccForApprovalCode(), FAAcc);
    end;
    //Workflow for FA Account Approval End

    //Common Changes Begin
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowTableRelationsToLibrary', '', true, true)]
    local procedure CreateEventLiabrary()
    var
        cuWorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        cuWorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendGLAccForApprovalCode(), Database::"G/L Account",
                                            'Approval of Chart of Account is requested.', 0, false);
        cuWorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelGLAccForApprovalCode(), Database::"G/L Account",
                                            'Approval request of Chart of Account is cancelled.', 0, false);

        cuWorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendBankAccForApprovalCode(), Database::"Bank Account",
                                            'Approval of Bank Account is requested.', 0, false);
        cuWorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelBankAccForApprovalCode(), Database::"Bank Account",
                                            'Approval request of Bank Account is cancelled.', 0, false);

        cuWorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendFAAccForApprovalCode(), Database::"Fixed Asset",
                                            'Approval of Fixed Asset is requested.', 0, false);
        cuWorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelFAAccForApprovalCode(), Database::"Fixed Asset",
                                            'Approval request of Fixed Asset is cancelled.', 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure AddResponsePredecessors(ResponseFunctionName: Code[128])
    var
        cuWorkflowResponseHandling: Codeunit "Workflow Response Handling";
        cuWorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        case ResponseFunctionName of
            cuWorkflowResponseHandling.CreateApprovalRequestsCode():
                begin
                    cuWorkflowResponseHandling.AddResponsePredecessor(cuWorkflowResponseHandling.CreateApprovalRequestsCode(), RunWorkflowOnSendGLAccForApprovalCode());
                    cuWorkflowResponseHandling.AddResponsePredecessor(cuWorkflowResponseHandling.CreateApprovalRequestsCode(), RunWorkflowOnSendBankAccForApprovalCode());
                    cuWorkflowResponseHandling.AddResponsePredecessor(cuWorkflowResponseHandling.CreateApprovalRequestsCode(), RunWorkflowOnSendFAAccForApprovalCode());
                end;
            cuWorkflowResponseHandling.SendApprovalRequestForApprovalCode():
                begin
                    cuWorkflowResponseHandling.AddResponsePredecessor(cuWorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnSendGLAccForApprovalCode());
                    cuWorkflowResponseHandling.AddResponsePredecessor(cuWorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnSendBankAccForApprovalCode());
                    cuWorkflowResponseHandling.AddResponsePredecessor(cuWorkflowResponseHandling.SendApprovalRequestForApprovalCode(), RunWorkflowOnSendFAAccForApprovalCode());
                end;
            cuWorkflowResponseHandling.OpenDocumentCode():
                begin
                    cuWorkflowResponseHandling.AddResponsePredecessor(cuWorkflowResponseHandling.OpenDocumentCode(), RunWorkflowOnCancelGLAccForApprovalCode());
                    cuWorkflowResponseHandling.AddResponsePredecessor(cuWorkflowResponseHandling.OpenDocumentCode(), RunWorkflowOnCancelBankAccForApprovalCode());
                    cuWorkflowResponseHandling.AddResponsePredecessor(cuWorkflowResponseHandling.OpenDocumentCode(), RunWorkflowOnCancelFAAccForApprovalCode());
                end;
            cuWorkflowResponseHandling.CancelAllApprovalRequestsCode():
                begin
                    cuWorkflowResponseHandling.AddResponsePredecessor(cuWorkflowResponseHandling.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelGLAccForApprovalCode());
                    cuWorkflowResponseHandling.AddResponsePredecessor(cuWorkflowResponseHandling.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelBankAccForApprovalCode());
                    cuWorkflowResponseHandling.AddResponsePredecessor(cuWorkflowResponseHandling.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelFAAccForApprovalCode());
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::Workflows, 'OnOpenPageEvent', '', true, true)]
    local procedure CheckAndInsertCustomWorkflowEvents()
    begin
        InsertWorkFlowData();
    end;

    local procedure InsertWorkFlowData()
    var
        recWorkFlowTableRelation: Record "Workflow - Table Relation";
        recWorkFlowEvent: Record "Workflow Event";
    begin
        recWorkFlowTableRelation.Reset();
        recWorkFlowTableRelation.SetRange("Table ID", 15);
        recWorkFlowTableRelation.SetRange("Field ID", 0);
        recWorkFlowTableRelation.SetRange("Related Table ID", 454);
        recWorkFlowTableRelation.SetRange("Related Field ID", 22);
        if not recWorkFlowTableRelation.FindFirst() then begin
            recWorkFlowTableRelation.Init();
            recWorkFlowTableRelation."Table ID" := 15;
            recWorkFlowTableRelation."Related Table ID" := 454;
            recWorkFlowTableRelation."Related Field ID" := 22;
            recWorkFlowTableRelation.Insert();
        end;

        recWorkFlowTableRelation.Reset();
        recWorkFlowTableRelation.SetRange("Table ID", 270);
        recWorkFlowTableRelation.SetRange("Field ID", 0);
        recWorkFlowTableRelation.SetRange("Related Table ID", 454);
        recWorkFlowTableRelation.SetRange("Related Field ID", 22);
        if not recWorkFlowTableRelation.FindFirst() then begin
            recWorkFlowTableRelation.Init();
            recWorkFlowTableRelation."Table ID" := 270;
            recWorkFlowTableRelation."Related Table ID" := 454;
            recWorkFlowTableRelation."Related Field ID" := 22;
            recWorkFlowTableRelation.Insert();
        end;

        recWorkFlowTableRelation.Reset();
        recWorkFlowTableRelation.SetRange("Table ID", 5600);
        recWorkFlowTableRelation.SetRange("Field ID", 0);
        recWorkFlowTableRelation.SetRange("Related Table ID", 454);
        recWorkFlowTableRelation.SetRange("Related Field ID", 22);
        if not recWorkFlowTableRelation.FindFirst() then begin
            recWorkFlowTableRelation.Init();
            recWorkFlowTableRelation."Table ID" := 5600;
            recWorkFlowTableRelation."Related Table ID" := 454;
            recWorkFlowTableRelation."Related Field ID" := 22;
            recWorkFlowTableRelation.Insert();
        end;

        if not recWorkFlowEvent.Get(UpperCase('RunWorkflowOnSendGLAccForApproval')) then begin
            recWorkFlowEvent.Init();
            recWorkFlowEvent."Function Name" := UpperCase('RunWorkflowOnSendGLAccForApproval');
            recWorkFlowEvent."Table ID" := 15;
            recWorkFlowEvent.Description := 'Approval of a G/L Account is requested.';
            recWorkFlowEvent.Insert();
        end;
        if not recWorkFlowEvent.Get(UpperCase('RunWorkflowOnCancelGLAccForApproval')) then begin
            recWorkFlowEvent.Init();
            recWorkFlowEvent."Function Name" := UpperCase('RunWorkflowOnCancelGLAccForApproval');
            recWorkFlowEvent."Table ID" := 15;
            recWorkFlowEvent.Description := 'An approval request for a G/L Account is canceled.';
            recWorkFlowEvent.Insert();
        end;

        if not recWorkFlowEvent.Get(UpperCase('RunWorkflowOnSendBankAccForApproval')) then begin
            recWorkFlowEvent.Init();
            recWorkFlowEvent."Function Name" := UpperCase('RunWorkflowOnSendBankAccForApproval');
            recWorkFlowEvent."Table ID" := 270;
            recWorkFlowEvent.Description := 'Approval of a Bank Account is requested.';
            recWorkFlowEvent.Insert();
        end;
        if not recWorkFlowEvent.Get(UpperCase('RunWorkflowOnCancelBankAccForApproval')) then begin
            recWorkFlowEvent.Init();
            recWorkFlowEvent."Function Name" := UpperCase('RunWorkflowOnCancelBankAccForApproval');
            recWorkFlowEvent."Table ID" := 270;
            recWorkFlowEvent.Description := 'An approval request for a Bank Account is canceled.';
            recWorkFlowEvent.Insert();
        end;

        if not recWorkFlowEvent.Get(UpperCase('RunWorkflowOnSendFAAccForApproval')) then begin
            recWorkFlowEvent.Init();
            recWorkFlowEvent."Function Name" := UpperCase('RunWorkflowOnSendFAAccForApproval');
            recWorkFlowEvent."Table ID" := 5600;
            recWorkFlowEvent.Description := 'Approval of a Fixed Asset is requested.';
            recWorkFlowEvent.Insert();
        end;
        if not recWorkFlowEvent.Get(UpperCase('RunWorkflowOnCancelFAAccForApproval')) then begin
            recWorkFlowEvent.Init();
            recWorkFlowEvent."Function Name" := UpperCase('RunWorkflowOnCancelFAAccForApproval');
            recWorkFlowEvent."Table ID" := 5600;
            recWorkFlowEvent.Description := 'An approval request for a Fixed Asset is canceled.';
            recWorkFlowEvent.Insert();
        end;
    end;
    //Common Changes Begin

    var
        cuWorkflowManagement: Codeunit "Workflow Management";
}