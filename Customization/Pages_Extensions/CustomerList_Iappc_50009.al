pageextension 50009 "Customer List Ext." extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Technical Name"; Rec."Technical Name")
            {
                ApplicationArea = all;
            }
            field(Address; Rec.Address)
            {
                ApplicationArea = all;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
            }
            field(City; Rec.City)
            {
                ApplicationArea = all;
            }
            field("State Code"; Rec."State Code")
            {
                ApplicationArea = all;
            }
            field("Mobile Phone No."; Rec."Mobile Phone No.")
            {
                ApplicationArea = all;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = all;
            }
            field("P.A.N. No."; Rec."P.A.N. No.")
            {
                ApplicationArea = all;
            }
            field("GST Customer Type"; Rec."GST Customer Type")
            {
                ApplicationArea = all;
            }
            field("GST Registration No."; Rec."GST Registration No.")
            {
                ApplicationArea = all;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;
            }
            field("Created At"; Rec."Created At")
            {
                ApplicationArea = all;
            }
            field("Modified By"; Rec."Modified By")
            {
                ApplicationArea = all;
            }
        }

        modify("IC Partner Code")
        {
            Visible = true;
        }
        modify("Last Date Modified")
        {
            Visible = true;
        }
        modify("Payment Terms Code")
        {
            Visible = true;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify("Sales (LCY)")
        {
            Visible = false;
        }
        modify("Payments (LCY)")
        {
            Visible = false;
        }
        modify("Country/Region Code")
        {
            Visible = true;
        }
        modify("Post Code")
        {
            Visible = true;
        }
        modify("Phone No.")
        {
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Customer Posting Group")
        {
            Visible = true;
        }
        modify("Currency Code")
        {
            Visible = true;
        }
        modify("Ship-to Code")
        {
            Visible = true;
        }

        moveafter("State Code"; "Country/Region Code")
        moveafter("Country/Region Code"; "Post Code")
        moveafter("Post Code"; "Phone No.")
        moveafter("E-Mail"; "Gen. Bus. Posting Group")
        moveafter("Gen. Bus. Posting Group"; "Customer Posting Group")
        moveafter("Customer Posting Group"; "Currency Code")
        moveafter("Currency Code"; "Ship-to Code")
    }

    actions
    {
        // Add changes to page actions here
        addafter("Customer List")
        {
            action(AccountLedger)
            {
                Caption = 'Customer Ledger';
                Image = LedgerEntries;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    recCustomer.Reset();
                    recCustomer.SetRange("No.", Rec."No.");
                    recCustomer.FindFirst();
                    Clear(rptLedgerReport);
                    rptLedgerReport.SetTableView(recCustomer);
                    rptLedgerReport.Run();
                end;
            }
        }

        modify(Documents)
        {
            Visible = false;
        }
        modify(NewSalesQuote)
        {
            Visible = false;
        }
        modify(NewSalesInvoice)
        {
            Visible = false;
        }
        modify(NewSalesOrder)
        {
            Visible = false;
        }
        modify(PaymentRegistration)
        {
            Visible = false;
        }
        modify("Customer - Order Summary")
        {
            Visible = false;
        }
        modify("Customer - Sales List")
        {
            Visible = false;
        }
        modify(NewSalesCrMemo)
        {
            Visible = false;
        }
        modify(NewReminder)
        {
            Visible = false;
        }
        modify(WordTemplate)
        {
            Visible = false;
        }
        modify(Coupling)
        {
            Visible = false;
        }
        modify(CRMSynchronizeNow)
        {
            Visible = false;
        }
        modify("Cash Receipt Journal")
        {
            Visible = false;
        }
        modify("Sales Journal")
        {
            Visible = false;
        }
        modify(Quotes)
        {
            Visible = false;
        }
        modify(Orders)
        {
            Visible = false;
        }
        modify("Return Orders")
        {
            Visible = false;
        }
        modify(PricesAndDiscounts)
        {
            Visible = false;
        }
        modify(Statement)
        {
            Visible = false;
        }
        modify(ManageCRMCoupling)
        {
            Visible = false;
        }
        modify(Sales_Prices)
        {
            Visible = false;
        }
        modify(Sales_LineDiscounts)
        {
            Visible = false;
        }
        modify(ReportFactBoxVisibility)
        {
            Visible = false;
        }
        modify(ApplyTemplate)
        {
            Visible = false;
        }
        modify("Issued &Finance Charge Memos")
        {
            Visible = false;
        }
        modify(NewServiceCrMemo)
        {
            Visible = false;
        }
        modify("Service Orders")
        {
            Visible = false;
        }
        modify(NewServiceInvoice)
        {
            Visible = false;
        }
        modify(NewServiceQuote)
        {
            Visible = false;
        }
        modify(NewSalesBlanketOrder)
        {
            Visible = false;
        }
        modify(NewSalesReturnOrder)
        {
            Visible = false;
        }
        modify("Direct Debit Mandates")
        {
            Visible = false;
        }
        modify("Item &Tracking Entries")
        {
            Visible = false;
        }
        modify(Sales)
        {
            Visible = false;
        }
        modify(Service)
        {
            Visible = false;
        }
        modify(BackgroundStatement)
        {
            Visible = false;
        }
        modify(Reminder)
        {
            Visible = false;
        }
        modify(Prices_Prices)
        {
            Visible = false;
        }
        modify(Prices_LineDiscounts)
        {
            Visible = false;
        }
        modify(PriceListsDiscounts)
        {
            Visible = false;
        }
        modify(NewFinChargeMemo)
        {
            Visible = false;
        }
        modify(NewServiceOrder)
        {
            Visible = false;
        }
        modify("Prepa&yment Percentages")
        {
            Visible = false;
        }
        modify("Recurring Sales Lines")
        {
            Visible = false;
        }
    }

    var
        rptLedgerReport: Report "Customer Ledger";
        recCustomer: Record Customer;
}