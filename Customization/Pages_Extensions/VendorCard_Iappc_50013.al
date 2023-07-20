pageextension 50013 "Vendor Card Ext." extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field("Ixigo Vendor Code"; Rec."Ixigo Vendor Code")
            {
                ApplicationArea = all;
            }
            field("Created At"; Rec."Created At")
            {
                ApplicationArea = all;
            }
        }
        addafter("Payment Terms Code")
        {
            field("Due Date Calc. Basis"; Rec."Due Date Calc. Basis")
            {
                ApplicationArea = all;
            }
        }
        addafter("Assessee Code")
        {
            field("206 AB"; Rec."206 AB")
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
            field("Beneficiary Code"; Rec."Beneficiary Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("GST vendor Type")
        {
            field("RCM Applicable"; Rec."RCM Applicable")
            {
                ApplicationArea = all;
            }
        }
        modify("Payment Method Code")
        {
            Visible = false;
        }
        modify("Preferred Bank Account Code")
        {
            Visible = false;
        }
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
        }
        addafter("P.A.N. Reference No.")
        {
            field("Skip PAN No. Validation"; Rec."Skip PAN No. Validation")
            {
                ApplicationArea = all;
            }
            group(MSMEInfo)
            {
                Caption = 'MSME';
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
            }
        }
        addafter("GST vendor Type")
        {
            field("GST Return Filling Frequency"; Rec."GST Return Filling Frequency")
            {
                ApplicationArea = all;
            }
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify(BalanceAsCustomer)
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Document Sending Profile")
        {
            Visible = false;
        }
        modify("IC Partner Code")
        {
            Importance = Standard;
            Visible = true;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Our Account No.")
        {
            Visible = false;
        }
        modify("Language Code")
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
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Liable")
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
        modify(Priority)
        {
            Visible = false;
        }
        modify("Block Payment Tolerance")
        {
            Visible = false;
        }
        modify("Partner Type")
        {
            Visible = false;
        }
        modify("Cash Flow Payment Terms Code")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
        modify("Prepayment %")
        {
            Visible = false;
        }
        modify("Lead Time Calculation")
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
        modify("Over-Receipt Code")
        {
            Visible = false;
        }
        modify("Commissioner's Permission No.")
        {
            Visible = false;
        }

        moveafter("Address 2"; "State Code")
    }

    actions
    {
        // Add changes to page actions here
        modify(ApplyTemplate)
        {
            Visible = false;
        }
        modify(PayVendor)
        {
            Visible = false;
        }
        modify("Create Payments")
        {
            Visible = false;
        }
        modify(SeeFlows)
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
        modify(Quotes)
        {
            Visible = false;
        }
        modify(Orders)
        {
            Visible = false;
        }
        modify("Blanket Orders")
        {
            Visible = false;
        }
        modify("Return Orders")
        {
            Visible = false;
        }
        modify(VendorReportSelections)
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
        modify(PriceListsDiscounts)
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
        modify(Purchases)
        {
            Visible = false;
        }
        modify(WordTemplate)
        {
            Visible = false;
        }
        modify("Purchase Journal")
        {
            Visible = false;
        }
        modify(Templates)
        {
            Visible = false;
        }
        modify(SaveAsTemplate)
        {
            Visible = false;
        }
        modify(MergeDuplicate)
        {
            Visible = false;
        }
        modify(OrderAddresses)
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
        modify("Item &Tracking Entries")
        {
            Visible = false;
        }
        modify("Vendor - Labels")
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

    }

    var
}