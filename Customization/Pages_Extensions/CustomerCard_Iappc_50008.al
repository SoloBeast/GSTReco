pageextension 50008 "Customer Card Ext." extends "Customer Card"
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
        }
        addbefore("P.A.N. No.")
        {
            field("TCS Applicable"; Rec."TCS Applicable")
            {
                ApplicationArea = all;
            }
        }
        modify("Assessee Code")
        {
            Visible = true;
        }
        modify("IC Partner Code")
        {
            Importance = Standard;
            Visible = true;
        }
        modify(BalanceAsVendor)
        {
            Visible = false;
        }
        modify("Salesperson Code")
        {
            Visible = false;
        }
        modify("EORI Number")
        {
            Visible = false;
        }
        modify("Prepayment %")
        {
            Visible = false;
        }
        modify("Partner Type")
        {
            Visible = false;
        }
        modify("Reminder Terms Code")
        {
            Visible = false;
        }
        modify("Fin. Charge Terms Code")
        {
            Visible = false;
        }
        modify("Cash Flow Payment Terms Code")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Service Zone Code")
        {
            Visible = false;
        }
        modify("Document Sending Profile")
        {
            Visible = false;
        }
        modify("VAT Registration No.")
        {
            Visible = false;
        }
        modify(GLN)
        {
            Visible = false;
        }
        modify("Use GLN in Electronic Document")
        {
            Visible = false;
        }
        modify("Combine Shipments")
        {
            Visible = false;
        }
        modify(Reserve)
        {
            Visible = false;
        }
        modify("Shipping Advice")
        {
            Visible = false;
        }
        modify("Base Calendar Code")
        {
            Visible = false;
        }
        modify("Customized Calendar")
        {
            Visible = false;
        }
        modify("Copy Sell-to Addr. to Qte From")
        {
            Visible = false;
        }
        modify("Tax Liable")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Allow Line Disc.")
        {
            Visible = false;
        }
        modify("Prices Including VAT")
        {
            Visible = false;
        }
        modify(TotalSales2)
        {
            Visible = false;
        }
        modify(AdjCustProfit)
        {
            Visible = false;
        }
        modify(AdjProfitPct)
        {
            Visible = false;
        }
        modify("CustSalesLCY - CustProfit - AdjmtCostLCY")
        {
            Visible = false;
        }
        moveafter("Address 2"; "State Code")
    }

    actions
    {
        // Add changes to page actions here
        modify(Documents)
        {
            Visible = false;
        }
        modify("Report Statement")
        {
            Visible = false;
        }
        modify(NewSalesQuote)
        {
            Visible = false;
        }
        modify(NewSalesOrder)
        {
            Visible = false;
        }
        modify("&Jobs")
        {
            Visible = false;
        }
        modify(BackgroundStatement)
        {
            Visible = false;
        }
        modify(NewSalesInvoice)
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
        modify(WordTemplate)
        {
            Visible = false;
        }
        modify("Report Customer Detailed Aging")
        {
            Visible = false;
        }
        modify("Report Customer - Labels")
        {
            Visible = false;
        }
        modify("Report Customer - Balance to Date")
        {
            Visible = false;
        }
        modify(NewSalesCreditMemo)
        {
            Visible = false;
        }
        modify(NewReminder)
        {
            Visible = false;
        }
        modify("Prices and Discounts")
        {
            Visible = false;
        }
        modify("S&ales")
        {
            Visible = false;
        }
        modify(Quotes)
        {
            Visible = false;
        }
        modify(Invoices)
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
        modify(Templates)
        {
            Visible = false;
        }
        modify(MergeDuplicate)
        {
            Visible = false;
        }
        modify(ApplyTemplate)
        {
            Visible = false;
        }
        modify(SaveAsTemplate)
        {
            Visible = false;
        }
        modify("Post Cash Receipts")
        {
            Visible = false;
        }
        modify("Sales Journal")
        {
            Visible = false;
        }
        modify(PaymentRegistration)
        {
            Visible = false;
        }
        modify("Recurring Sales Lines")
        {
            Visible = false;
        }
        modify("Prepa&yment Percentages")
        {
            Visible = false;
        }
        modify(Service)
        {
            Visible = false;
        }
        modify(PriceListsDiscounts)
        {
            Visible = false;
        }
        modify("Prices and Discounts Overview")
        {
            Visible = false;
        }
        modify("Line Discounts")
        {
            Visible = false;
        }
        modify(Prices)
        {
            Visible = false;
        }
        modify(CustomerReportSelections)
        {
            Visible = false;
        }
        modify("Blanket Orders")
        {
            Visible = false;
        }
        modify(NewBlanketSalesOrder)
        {
            Visible = false;
        }
        modify(NewServiceQuote)
        {
            Visible = false;
        }
        modify(NewServiceInvoice)
        {
            Visible = false;
        }
        modify("Service Orders")
        {
            Visible = false;
        }
        modify(NewServiceOrder)
        {
            Visible = false;
        }
        modify(NewServiceCreditMemo)
        {
            Visible = false;
        }
        modify(NewFinanceChargeMemo)
        {
            Visible = false;
        }
        modify("Issued &Finance Charge Memos")
        {
            Visible = false;
        }
        modify(SeeFlows)
        {
            Visible = false;
        }
        modify("Item &Tracking Entries")
        {
            Visible = false;
        }
    }

    var
}