pageextension 50031 "Sales Inv. Card Ext." extends "Sales Invoice"
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
        modify(Trading)
        {
            Visible = false;
        }
        modify("TDS Certificate Receivable")
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
        modify("Shipping Agent Service Code")
        {
            Visible = false;
        }
        modify("Package Tracking No.")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Prices Including VAT")
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
        modify(Control174)
        {
            Visible = false;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Company Bank Account Code")
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
        addafter(PostAndNew)
        {
            action(TestReport)
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
                    rptTestReport.SetDocumentDetails('SI', Rec."No.", '', '');
                    rptTestReport.Run();
                end;
            }
        }
        modify("Update Reference Invoice No.")
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
        modify("F&unctions")
        {
            Visible = false;
        }
        modify(DraftInvoice)
        {
            Visible = false;
        }
        modify(ProformaInvoice)
        {
            Visible = false;
        }
        modify("Test Report")
        {
            Visible = false;
        }
        modify("Remove From Job Queue")
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