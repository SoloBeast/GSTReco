pageextension 50037 "Purchase Inv. Card Ext." extends "Purchase Invoice"
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
            field("Document Basis"; Rec."Document Basis")
            {
                ApplicationArea = all;
            }
            field("Purch. Order No."; Rec."Purch. Order No.")
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
        modify("VAT Reporting Date")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Buy-from Contact No.")
        {
            Visible = false;
        }
        modify("Buy-from Contact")
        {
            Visible = false;
        }
        modify("Ship-to Contact")
        {
            Visible = false;
        }
        modify("Pay-to Contact No.")
        {
            Visible = false;
        }
        modify("Pay-to Contact")
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
        modify("Associated Enterprises")
        {
            Visible = false;
        }
        modify("Rate Change Applicable")
        {
            Visible = false;
        }
        modify("Supply Finish Date")
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
        addafter("RCM Applicable")
        {
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
        addafter(Post)
        {
            action(TestVoucherReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Test Report';
                Image = TestReport;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    rptTestReport: Report "Voucher Test Report";

                begin
                    Clear(rptTestReport);
                    rptTestReport.SetDocumentDetails('PI', Rec."No.", '', '');
                    rptTestReport.Run();
                end;
            }
        }
        modify("Update Reference Invoice No.")
        {
            Visible = false;
        }
        modify(SeeFlows)
        {
            Visible = false;
        }
        modify(IncomingDocument)
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
        modify(TestReport)
        {
            Visible = false;
        }
        modify(IncomingDocAttachFile)
        {
            Visible = false;
        }
        modify(IncomingDocCard)
        {
            Visible = false;
        }
        modify(RemoveIncomingDoc)
        {
            Visible = false;
        }
        modify(SelectIncomingDoc)
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
        ShipToOptions := ShipToOptions::Location;
    end;

    var
}