pageextension 50042 "Sales Order Ext." extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("Internal Document Type"; Rec."Internal Document Type")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Internal Document Type"; "Company Bank Account Code")

        modify("Prepayment %")
        {
            Visible = true;
            ApplicationArea = all;
            Importance = Standard;
        }
        modify("Compress Prepayment")
        {
            Visible = true;
            ApplicationArea = all;
            Importance = Standard;
        }
        modify("Prepmt. Payment Terms Code")
        {
            Visible = true;
            ApplicationArea = all;
            Importance = Standard;
        }
        modify("Prepayment Due Date")
        {
            Visible = true;
            Importance = Standard;
            ApplicationArea = all;
        }
        modify("Prepmt. Payment Discount %")
        {
            Visible = true;
            Importance = Standard;
            ApplicationArea = all;
        }
        modify("Prepmt. Pmt. Discount Date")
        {
            Visible = true;
            Importance = Standard;
            ApplicationArea = all;
        }
        moveafter(Status; "Location Code")
        modify("Document Date")
        {
            Visible = false;
        }
        modify("Requested Delivery Date")
        {
            Visible = false;
        }
        modify("Company Bank Account Code")
        {
            Visible = true;
        }
        modify("LR/RR No.")
        {
            Visible = false;
        }
        modify("LR/RR Date")
        {
            Visible = false;
        }
        modify("E-Comm. Merchant Id")
        {
            Visible = false;
        }
        modify("E-Commerce Customer")
        {
            Visible = false;
        }
        modify("E-Commerce Merchant Id")
        {
            Visible = false;
        }
        modify("Vehicle No.")
        {
            Visible = false;
        }
        modify("Vehicle Type")
        {
            Visible = false;
        }
        modify("Distance (Km)")
        {
            Visible = false;
        }
        modify("Date of Removal")
        {
            Visible = false;
        }
        modify("Time of Removal")
        {
            Visible = false;
        }
        modify("Mode of Transport")
        {
            Visible = false;
        }
        modify("Supply Finish Date")
        {
            Visible = false;
        }
        modify("Payment Date")
        {
            Visible = false;
        }
        modify("Promised Delivery Date")
        {
            Visible = false;
        }
        modify("Language Code")
        {
            Visible = false;
        }
        modify("Posting Description")
        {
            Visible = false;
        }
        modify("Your Reference")
        {
            Importance = Standard;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Opportunity No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Work Description")
        {
            Visible = false;
        }
        modify("Prices Including VAT")
        {
            Visible = false;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Payment Method Code")
        {
            Visible = false;
        }
        modify("EU 3-Party Trade")
        {
            Visible = false;
        }
        modify(Control76)
        {
            Visible = false;
        }
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
        }
        modify("Direct Debit Mandate ID")
        {
            Visible = false;
        }
        modify("Shipment Method")
        {
            Visible = false;
        }
        modify("Shipping Advice")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Outbound Whse. Handling Time")
        {
            Visible = false;
        }
        modify("Shipping Time")
        {
            Visible = false;
        }
        modify("Late Order Shipping")
        {
            Visible = false;
        }
        modify("Combine Shipments")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify(Trading)
        {
            Visible = false;
        }
        modify("Reference Invoice No.")
        {
            Visible = false;
        }
        modify("Shipping Agent Code")
        {
            Visible = true;
        }

        moveafter("Internal Document Type"; "Location Code")
        moveafter("Location Code"; "Shipping Agent Code")
        moveafter("Shipping Agent Code"; "Currency Code")
        moveafter("Currency Code"; "Company Bank Account Code")
    }

    actions
    {
        // Add changes to page actions here
        addafter(Release)
        {
            action(IappcRelease)
            {
                ApplicationArea = Suite;
                Caption = 'Re&lease';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'Ctrl+F9';
                ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';

                trigger OnAction()
                var
                begin
                    cuReleaseSalesDoc.PerformManualRelease(Rec);
                    CurrPage.Close();
                end;
            }
            action(IappcReopen)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Re&open';
                Enabled = Rec.Status <> Rec.Status::Open;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;
                ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                trigger OnAction()
                var
                begin
                    cuReleaseSalesDoc.PerformManualReopen(Rec);
                    CurrPage.Close();
                end;
            }
        }
        addafter(SendApprovalRequest)
        {
            action(IappcSendApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Enabled = NOT blnOpenApprovalEntriesExist AND blnCanRequestApprovalForFlow AND blnOpenOrder;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                ToolTip = 'Request approval of the document.';

                trigger OnAction()
                var
                begin
                    if cuApprovalsMgmt.CheckSalesApprovalPossible(Rec) then
                        cuApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                    CurrPage.Close();
                end;
            }
            action(IappcCancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Enabled = blnCanCancelApprovalForRecord OR blnCanCancelApprovalForFlow;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category9;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction()
                var
                begin
                    cuApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                    cuWorkflowWebhookMgt.FindAndCancel(Rec.RecordId);
                    CurrPage.Close();
                end;
            }
        }
        addafter(Approve)
        {
            action(IappcApprove)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Approve the requested changes.';
                Visible = blnOpenApprovalEntriesExistForCurrUser;

                trigger OnAction()
                var
                begin
                    cuApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    CurrPage.Close();
                end;
            }
            action(IappcReject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Reject the approval request.';
                Visible = blnOpenApprovalEntriesExistForCurrUser;

                trigger OnAction()
                var
                begin
                    cuApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    CurrPage.Close();
                end;
            }
            action(IappcDelegate)
            {
                ApplicationArea = All;
                Caption = 'Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Delegate the approval to a substitute approver.';
                Visible = blnOpenApprovalEntriesExistForCurrUser;

                trigger OnAction()
                var
                begin
                    cuApprovalsMgmt.DelegateRecordApprovalRequest(rec.RecordId);
                    CurrPage.Close();
                end;
            }
        }
        addafter("&Print")
        {
            action(PrintProforma)
            {
                ApplicationArea = all;
                Caption = 'Print Sales Order';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                begin
                    recSalesHeader.Reset();
                    recSalesHeader.SetRange("Document Type", Rec."Document Type");
                    recSalesHeader.SetRange("No.", Rec."No.");
                    recSalesHeader.FindFirst();
                    Report.Run(50021, true, true, recSalesHeader);
                end;
            }
        }
        modify("Send IC Sales Order")
        {
            Visible = true;
        }
        modify(Approve)
        {
            Visible = false;
        }
        modify(Reject)
        {
            Visible = false;
        }
        modify(Delegate)
        {
            Visible = false;
        }
        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        modify(CancelApprovalRequest)
        {
            Visible = false;
        }
        modify(Release)
        {
            Visible = false;
        }
        modify(Reopen)
        {
            Visible = false;
        }
        modify("Update Reference Invoice No.")
        {
            Visible = false;
        }
        modify("Create Inventor&y Put-away/Pick")
        {
            Visible = false;
        }
        modify(GetRecurringSalesLines)
        {
            Visible = false;
        }
        modify(SeeFlows)
        {
            Visible = false;
        }
        modify(SendEmailConfirmation)
        {
            Visible = false;
        }
        modify("Print Confirmation")
        {
            Visible = false;
        }
        modify(AttachAsPDF)
        {
            Visible = false;
        }
        modify(CreatePurchaseOrder)
        {
            Visible = false;
        }
        modify(CreatePurchaseInvoice)
        {
            Visible = false;
        }
        modify(CalculateInvoiceDiscount)
        {
            Visible = false;
        }
        modify(CopyDocument)
        {
            Visible = false;
        }
        modify(MoveNegativeLines)
        {
            Visible = false;
        }
        modify("Archive Document")
        {
            Visible = false;
        }
        modify(IncomingDocument)
        {
            Visible = false;
        }
        modify(Plan)
        {
            Visible = false;
        }
        modify(Warehouse)
        {
            Visible = false;
        }
        modify("Test Report")
        {
            Visible = false;
        }
        modify(ProformaInvoice)
        {
            Visible = false;
        }
        modify("&Print")
        {
            Visible = false;
        }
        modify("&Order Confirmation")
        {
            Visible = false;
        }
        modify(AssemblyOrders)
        {
            Visible = false;
        }
        modify("In&vt. Put-away/Pick Lines")
        {
            Visible = false;
        }
        modify("Warehouse Shipment Lines")
        {
            Visible = false;
        }
        modify(Prepayment)
        {
            Visible = true;
        }
        modify(History)
        {
            Visible = false;
        }
        modify("Create &Warehouse Shipment")
        {
            Visible = false;
        }
        modify(CreateFlow)
        {
            Visible = false;
        }
        modify(Flow)
        {
            Visible = false;
        }
    }

    trigger OnAfterGetRecord()
    begin
        blnOpenOrder := Rec.Status = Rec.Status::Open;
        blnOpenApprovalEntriesExistForCurrUser := cuApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);

        blnOpenApprovalEntriesExist := cuApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        blnCanCancelApprovalForRecord := cuApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        cuWorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, blnCanRequestApprovalForFlow, blnCanCancelApprovalForFlow);
    end;

    var
        blnOpenApprovalEntriesExistForCurrUser: Boolean;
        cuApprovalsMgmt: Codeunit "Approvals Mgmt.";
        blnOpenApprovalEntriesExist: Boolean;
        blnCanRequestApprovalForFlow: Boolean;
        blnCanCancelApprovalForFlow: Boolean;
        cuWorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        blnCanCancelApprovalForRecord: Boolean;
        cuReleaseSalesDoc: Codeunit "Release Sales Document";
        blnOpenOrder: Boolean;
        recSalesHeader: Record "Sales Header";
}