pageextension 50046 "Purch. Order Card Ext." extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
        modify("Prepmt. Payment Terms Code")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Prepayment Due Date")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Prepmt. Payment Discount %")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Prepmt. Pmt. Discount Date")
        {
            Visible = true;
            ApplicationArea = all;
        }
        addafter(Status)
        {
            field("Internal Document Type"; Rec."Internal Document Type")
            {
                ApplicationArea = all;
            }
            field("PO Term 1"; Rec."PO Term 1")
            {
                ApplicationArea = all;
            }
            field("PO Term 2"; Rec."PO Term 2")
            {
                ApplicationArea = all;
            }
            field("RCM Applicable"; Rec."RCM Applicable")
            {
                ApplicationArea = all;
            }
            field("206 AB"; Rec."206 AB")
            {
                ApplicationArea = all;
            }
        }
        // addafter("Payment Terms Code")
        // {
        //     field("Due Date Calc. Basis"; Rec."Due Date Calc. Basis")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
        modify("Document Date")
        {
            Visible = false;
        }
        modify("VAT Reporting Date")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Vendor Shipment No.")
        {
            Visible = false;
        }
        modify("Order Address Code")
        {
            Visible = false;
        }
        modify("Remit-to")
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
        modify("Shipping Agent Code")
        {
            Visible = false;
        }
        modify("Quote No.")
        {
            Visible = false;
        }
        modify("Pay-to Contact")
        {
            Visible = false;
        }
        modify("Pay-to Contact No.")
        {
            Visible = false;
        }
        modify("Ship-to Contact")
        {
            Visible = false;
        }
        modify("Buy-from Contact")
        {
            Visible = false;
        }
        modify("Buy-from Contact No.")
        {
            Visible = false;
        }
        modify("Vendor Order No.")
        {
            Visible = false;
        }
        modify("Vendor Invoice No.")
        {
            Visible = true;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify(Subcontracting)
        {
            Visible = false;
        }
        modify("Payment Date")
        {
            Visible = false;
        }
        modify("Supply Finish Date")
        {
            Visible = false;
        }
        modify("Rate Change Applicable")
        {
            Visible = false;
        }
        modify("Foreign Trade")
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
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
        }
        modify("Shipment Method Code")
        {
            Visible = false;
        }
        modify("Payment Reference")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
        modify("On Hold")
        {
            Visible = false;
        }
        modify("Inbound Whse. Handling Time")
        {
            Visible = false;
        }
        modify("Lead Time Calculation")
        {
            Visible = false;
        }
        modify("Requested Receipt Date")
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }

        addafter("RCM Applicable")
        {
            field("Document Basis"; Rec."Document Basis")
            {
                ApplicationArea = all;
            }
            field("Purch. Order No."; Rec."Purch. Order No.")
            {
                ApplicationArea = all;
            }
            field("Due Date Calc. Basis"; Rec."Due Date Calc. Basis")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Due Date Calc. Basis"; "Invoice Type")
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
                    cuReleasePurchDoc.PerformManualRelease(Rec);
                    CurrPage.Close();
                end;
            }
            action(IappcReopen)
            {
                ApplicationArea = Suite;
                Caption = 'Re&open';
                Enabled = Rec.Status <> Rec.Status::Open;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;
                ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

                trigger OnAction()
                var
                begin
                    cuReleasePurchDoc.PerformManualReopen(Rec);
                    CurrPage.Close();
                end;
            }
            action(ShortClose)
            {
                Caption = 'Short Close';
                Image = Close;
                Promoted = true;
                PromotedCategory = New;
                PromotedOnly = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    recPurchHeader: Record "Purchase Header";
                begin
                    if not Confirm('Do you want to short close the purchase order?', false) then
                        exit;

                    recPurchHeader.Get(Rec."Document Type", Rec."No.");
                    recPurchHeader."Short Closed" := true;
                    recPurchHeader.Modify();

                    Message('The purchase order has been short closed.');
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
                    if cuApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) then
                        cuApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
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
                    cuApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                    cuWorkflowWebhookMgt.FindAndCancel(Rec.RecordId);
                    CurrPage.Close();
                end;
            }
        }
        addafter(Approve)
        {
            action(IappcApprove)
            {
                ApplicationArea = Suite;
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
                ApplicationArea = Suite;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Reject the requested changes.';
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
                ApplicationArea = Suite;
                Caption = 'Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Delegate the requested changes to the substitute approver.';
                Visible = blnOpenApprovalEntriesExistForCurrUser;

                trigger OnAction()
                var
                begin
                    cuApprovalsMgmt.DelegateRecordApprovalRequest(rec.RecordId);
                    CurrPage.Close();
                end;
            }
        }
        addafter(CopyDocument)
        {
            action(GetIndentLines)
            {
                ApplicationArea = all;
                Caption = 'Get Indent Lines';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                begin
                    Rec.TESTFIELD("Buy-from Vendor No.");
                    Rec.TESTFIELD("Location Code");

                    CODEUNIT.RUN(50004, Rec);
                end;
            }
        }
        addafter("&Print")
        {
            action(PrintPOPort)
            {
                ApplicationArea = all;
                Caption = 'Print Order';
                Image = Print;

                trigger OnAction()
                var
                begin
                    recPurchHeader.Reset();
                    recPurchHeader.SetRange("Document Type", Rec."Document Type");
                    recPurchHeader.SetRange("No.", Rec."No.");
                    recPurchHeader.FindFirst();
                    Report.Run(Report::"Purchase Order Portrait", true, true, recPurchHeader);
                end;
            }
        }

        modify("F&unctions")
        {
            Visible = true;
        }
        modify("Send Intercompany Purchase Order")
        {
            Visible = true;
        }
        modify(Action225)
        {
            Visible = false;
        }
        modify("Archive Document")
        {
            Visible = false;
        }
        modify("&Print")
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
        modify(Release)
        {
            Visible = false;
        }
        modify(Reopen)
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
        modify(SeeFlows)
        {
            Visible = false;
        }
        modify(AttachAsPDF)
        {
            Visible = false;
        }
        modify(SendCustom)
        {
            Visible = false;
        }
        modify(CalculateInvoiceDiscount)
        {
            Visible = false;
        }
        modify(GetRecurringPurchaseLines)
        {
            Visible = false;
        }
        modify("Create Tracking Information")
        {
            Visible = false;
        }
        modify(MoveNegativeLines)
        {
            Visible = false;
        }
        modify("Dr&op Shipment")
        {
            Visible = false;
        }
        modify("Speci&al Order")
        {
            Visible = false;
        }
        modify(IncomingDocument)
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
        modify("Prepa&yment")
        {
            Visible = true;
        }
        modify(PostPrepaymentInvoice)
        {
            Visible = true;
        }
        modify(PostPrepaymentCreditMemo)
        {
            Visible = true;
        }
        modify("Create &Whse. Receipt")
        {
            Visible = false;
        }
        modify(PostedPrepaymentInvoices)
        {
            Visible = true;
        }
        modify(PostedPrepaymentCrMemos)
        {
            Visible = true;
        }
        modify("Get &Sales Order")
        {
            Visible = false;
        }
        modify("Get Gate Entry Lines")
        {
            Visible = false;
        }
        modify("Attached Gate Entry")
        {
            Visible = false;
        }
        modify(Functions_GetSalesOrder)
        {
            Visible = false;
        }
        modify(Warehouse_GetSalesOrder)
        {
            Visible = false;
        }
        modify(Action186)
        {
            Visible = false;
        }
        modify(Action187)
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ShipToOptions := ShipToOptions::Location;
    end;

    trigger OnAfterGetRecord()
    begin
        blnOpenOrder := Rec.Status = Rec.Status::Open;
        blnOpenApprovalEntriesExistForCurrUser := cuApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);

        blnOpenApprovalEntriesExist := cuApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        blnCanCancelApprovalForRecord := cuApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        cuWorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, blnCanRequestApprovalForFlow, blnCanCancelApprovalForFlow);

        ShipToOptions := ShipToOptions::Location;
    end;

    var
        cuReleasePurchDoc: Codeunit "Release Purchase Document";
        blnOpenApprovalEntriesExist: Boolean;
        blnCanRequestApprovalForFlow: Boolean;
        blnOpenOrder: Boolean;
        cuApprovalsMgmt: Codeunit "Approvals Mgmt.";
        blnCanCancelApprovalForRecord: Boolean;
        blnCanCancelApprovalForFlow: Boolean;
        cuWorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        blnOpenApprovalEntriesExistForCurrUser: Boolean;
        recPurchHeader: Record "Purchase Header";
}