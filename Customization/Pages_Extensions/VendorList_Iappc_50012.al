pageextension 50012 "Vendor List Ext." extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Legal Name"; Rec."Legal Name")
            {
                ApplicationArea = all;
            }
            field("Trade Name"; Rec."Trade Name")
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
            field("GST Vendor Type"; Rec."GST Vendor Type")
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
        addafter("GST Registration No.")
        {
            field(MSME; Rec.MSME)
            {
                ApplicationArea = all;
            }
            field("MSME Reg. No."; Rec."MSME Reg. No.")
            {
                ApplicationArea = all;
            }
            field("MSME Type"; Rec."MSME Type")
            {
                ApplicationArea = all;
            }
            field("Bank Account No."; Rec."Bank Account No.")
            {
                ApplicationArea = all;
            }
            field("Bank IFSC Code"; Rec."Bank IFSC Code")
            {
                ApplicationArea = all;
            }
            field("Beneficiary Name"; Rec."Beneficiary Name")
            {
                ApplicationArea = all;
            }
        }
        addafter("Payment Terms Code")
        {
            field("Term Date Basis"; Rec."Term Date Basis")
            {
                ApplicationArea = all;
            }
            field("Assessee Code"; Rec."Assessee Code")
            {
                ApplicationArea = all;
            }
            field("Ixigo Vendor Code"; Rec."Ixigo Vendor Code")
            {
                ApplicationArea = all;
            }
            field("206 AB"; Rec."206 AB")
            {
                ApplicationArea = all;
            }
        }
        modify(Blocked)
        {
            Visible = true;
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
        modify("Post Code")
        {
            Visible = true;
        }
        modify("Country/Region Code")
        {
            Visible = true;
        }
        modify("Vendor Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Search Name")
        {
            Visible = false;
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify("Payments (LCY)")
        {
            Visible = false;
        }

        moveafter(City; "Post Code")
        moveafter("Post Code"; "Country/Region Code")
    }

    actions
    {
        // Add changes to page actions here
        addafter("Vendor - List")
        {
            action(AccountLedger)
            {
                Caption = 'Vendor Ledger';
                Image = LedgerEntries;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    recVendor.Reset();
                    recVendor.SetRange("No.", Rec."No.");
                    recVendor.FindFirst();
                    Clear(rptLedgerReport);
                    rptLedgerReport.SetTableView(recVendor);
                    rptLedgerReport.Run();
                end;
            }
        }
        modify(ApplyTemplate)
        {
            Visible = false;
        }
        modify(PayVendor)
        {
            Visible = false;
        }
        modify(NewBlanketPurchaseOrder)
        {
            Visible = false;
        }
        modify(NewPurchaseCrMemo)
        {
            Visible = false;
        }
        modify(NewPurchaseInvoice)
        {
            Visible = false;
        }
        modify(NewPurchaseOrder)
        {
            Visible = false;
        }
        modify(NewPurchaseQuote)
        {
            Visible = false;
        }
        modify(NewPurchaseReturnOrder)
        {
            Visible = false;
        }
        modify(WordTemplate)
        {
            Visible = false;
        }
        modify("Payment Journal")
        {
            Visible = false;
        }
        modify("Purchase Journal")
        {
            Visible = false;
        }
        modify(Prices)
        {
            Visible = false;
        }
        modify("Line Discounts")
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
        modify(ReportFactBoxVisibility)
        {
            Visible = false;
        }
        modify(OrderAddresses)
        {
            Visible = false;
        }
        modify(Items)
        {
            Visible = false;
        }
        modify("Invoice &Discounts")
        {
            Visible = false;
        }
        modify(PriceLines)
        {
            Visible = false;
        }
        modify(PriceLists)
        {
            Visible = false;
        }
        modify(DiscountLines)
        {
            Visible = false;
        }
        modify("Prepa&yment Percentages")
        {
            Visible = false;
        }
        modify("Recurring Purchase Lines")
        {
            Visible = false;
        }
        modify("Mapping Text to Account")
        {
            Visible = false;
        }
        modify("Return Orders")
        {
            Visible = false;
        }
        modify("Blanket Orders")
        {
            Visible = false;
        }
        modify("Item &Tracking Entries")
        {
            Visible = false;
        }
        modify("Vendor Item Catalog")
        {
            Visible = false;
        }
        modify("Vendor - Labels")
        {
            Visible = false;
        }
        modify("Payments on Hold")
        {
            Visible = false;
        }
    }

    var
        recVendor: Record Vendor;
        rptLedgerReport: Report "Vendor Ledger";
}