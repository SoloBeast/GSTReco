pageextension 50034 "Sales Cr.Memo Card Ext." extends "Sales Credit Memo"
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
        modify("Location Code")
        {
            Importance = Standard;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("E-Comm. Merchant Id")
        {
            Visible = false;
        }
        modify("e-Commerce Customer")
        {
            Visible = false;
        }
        modify("e-Commerce Merchant Id")
        {
            Visible = false;
        }
        modify("Distance (Km)")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Work Description")
        {
            Visible = false;
        }
        modify("TDS Certificate Receivable")
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
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
        }
        modify("EU 3-Party Trade")
        {
            Visible = false;
        }

        moveafter(Status; "Location Code")
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
                    rptTestReport.SetDocumentDetails('SCM', Rec."No.", '', '');
                    rptTestReport.Run();
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    recSalesHeader.Reset();
                    recSalesHeader.SetRange("Document Type", Rec."Document Type");
                    recSalesHeader.SetRange("No.", Rec."No.");
                    recSalesHeader.FindFirst();
                    Report.Run(50023, true, true, recSalesHeader);
                end;
            }
        }
        modify("Update Reference Invoice No.")
        {
            Visible = true;
        }
        modify(GetStdCustSalesCodes)
        {
            Visible = false;
        }
        modify(SeeFlows)
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
        recSalesHeader: Record "Sales Header";
}