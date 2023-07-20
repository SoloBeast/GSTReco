pageextension 50039 "Purch. Cr.Memo Card Ext." extends "Purchase Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
            field("Internal Document Type"; Rec."Internal Document Type")
            {
                ApplicationArea = all;
            }
            field("RCM Applicable"; Rec."RCM Applicable")
            {
                ApplicationArea = all;
            }
            field("Due Date Calc. Basis"; Rec."Due Date Calc. Basis")
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
        modify("Order Address Code")
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
        modify("Location Code")
        {
            Importance = Standard;
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
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }
        modify("Campaign No.")
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
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify(Subcontracting)
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
        modify("GST Reason Type")
        {
            Visible = false;
        }
        addafter("Due Date Calc. Basis")
        {
            field("Document Basis"; Rec."Document Basis")
            {
                ApplicationArea = all;
            }
            field("Purch. Order No."; Rec."Purch. Order No.")
            {
                ApplicationArea = all;
            }
        }

        moveafter(Status; "Location Code")
        moveafter("Purch. Order No."; "Invoice Type")

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
                    rptTestReport.SetDocumentDetails('PCM', Rec."No.", '', '');
                    rptTestReport.Run();
                end;
            }
        }
        modify("Update Reference Invoice No.")
        {
            Visible = true;
        }
        modify(SeeFlows)
        {
            Visible = false;
        }
        modify("Get St&d. Vend. Purchase Codes")
        {
            Visible = false;
        }
        modify("Move Negative Lines")
        {
            Visible = false;
        }
        modify(IncomingDocument)
        {
            Visible = false;
        }
        modify(TestReport)
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

    var
}