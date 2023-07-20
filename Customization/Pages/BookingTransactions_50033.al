page 50033 "Booking Transactions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Booking Transactions";
    Caption = 'Booking Transactions';
    //Editable = false;
    //InsertAllowed = false;
    //DeleteAllowed = false;
    //ModifyAllowed = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(BookingTransactions)
            {
                Editable = false;
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Created At"; Rec."Created At")
                {
                    ApplicationArea = All;
                }
                field("Booking Date"; Rec."Booking Date")
                {
                    ApplicationArea = All;
                }
                field("Journey Date"; Rec."Journey Date")
                {
                    ApplicationArea = All;
                }
                field("PNR No."; Rec."PNR No.")
                {
                    ApplicationArea = All;
                }
                field("Collection Mode"; Rec."Collection Mode")
                {
                    ApplicationArea = All;
                }
                field("Collect Ref.-Tally"; Rec."Collect Ref.-Tally")
                {
                    ApplicationArea = All;
                }
                field("Supplier Type"; Rec."Supplier Type")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Supplier Name - Technical"; Rec."Supplier Name - Technical")
                {
                    ApplicationArea = All;
                }
                field("Operator Name"; Rec."Operator Name")
                {
                    ApplicationArea = All;
                }
                field("Type of Sales"; Rec."Type of Sales")
                {
                    ApplicationArea = All;
                }
                field("Seller Name / Order ID"; Rec."Seller Name / Order ID")
                {
                    ApplicationArea = All;
                }
                field("PG Reference No."; Rec."PG Reference No.")
                {
                    ApplicationArea = All;
                }
                field("Mode of Payment"; Rec."Mode of Payment")
                {
                    ApplicationArea = All;
                }
                field(ECO; Rec.ECO)
                {
                    ApplicationArea = All;
                }
                field("ECO GSTIN"; Rec."ECO GSTIN")
                {
                    ApplicationArea = All;
                }
                field("Operator GSTIN"; Rec."Operator GSTIN")
                {
                    ApplicationArea = All;
                }
                field("Operator PAN"; Rec."Operator PAN")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Abhibus ECO Invoice No."; Rec."Abhibus ECO Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Abhibus ECO Invoice Date"; Rec."Abhibus ECO Invoice Date")
                {
                    ApplicationArea = All;
                }
                field("Base Fare"; Rec."Base Fare")
                {
                    ApplicationArea = All;
                }
                field("Edge Discount by Operator"; Rec."Edge Discount by Operator")
                {
                    ApplicationArea = All;
                }
                field("Lavy Fee by Operator"; Rec."Lavy Fee by Operator")
                {
                    ApplicationArea = All;
                }
                field("Toll Fee by Operator"; Rec."Toll Fee by Operator")
                {
                    ApplicationArea = All;
                }
                field("Service Fee by Operator"; Rec."Service Fee by Operator")
                {
                    ApplicationArea = All;
                }
                field("Total Fare"; Rec."Total Fare")
                {
                    ApplicationArea = All;
                }
                field("Comm.% (Base fare) Excl. GST"; Rec."Comm.% (Base fare) Excl. GST")
                {
                    ApplicationArea = All;
                }
                field("Comm. Earned (Base Fare)"; Rec."Comm. Earned (Base Fare)")
                {
                    ApplicationArea = All;
                }
                field("Saas Charges (CGW Comm) %"; Rec."Saas Charges (CGW Comm) %")
                {
                    ApplicationArea = All;
                }
                field("Saas Comm. (CGW)"; Rec."Saas Comm. (CGW)")
                {
                    ApplicationArea = All;
                }
                field("GST On Comm. IGST @18%"; Rec."GST On Comm. IGST @18%")
                {
                    ApplicationArea = All;
                }
                field("GST On Comm. CGST @9%"; Rec."GST On Comm. CGST @9%")
                {
                    ApplicationArea = All;
                }
                field("GST On Comm. SGST @9%"; Rec."GST On Comm. SGST @9%")
                {
                    ApplicationArea = All;
                }
                field("Total GST"; Rec."Total GST")
                {
                    ApplicationArea = All;
                }
                field("TDS Rate 1% U/S 194-O"; Rec."TDS Rate 1% U/S 194-O")
                {
                    ApplicationArea = All;
                }
                field("TDS Amt. (Base - Edge offer)"; Rec."TDS Amt. (Base - Edge offer)")
                {
                    ApplicationArea = All;
                }
                field("Net Payable to Operator"; Rec."Net Payable to Operator")
                {
                    ApplicationArea = All;
                }
                field("Tax Rate (on Base fare)"; Rec."Tax Rate (on Base fare)")
                {
                    ApplicationArea = All;
                }
                field("ECO GST Amount by Aggregator"; Rec."ECO GST Amount by Aggregator")
                {
                    ApplicationArea = All;
                }
                field("ECO GST Amt. Paid (Irctc)"; Rec."ECO GST Amt. Paid (Irctc)")
                {
                    ApplicationArea = All;
                }
                field("ECO GST by CGW"; Rec."ECO GST by CGW")
                {
                    ApplicationArea = All;
                }
                field("ECO IGST (@5%) Amt. by Abhibus"; Rec."ECO IGST (@5%) Amt. by Abhibus")
                {
                    ApplicationArea = All;
                }
                field("ECO CGST (@2.5%) Amt.(Abhibus)"; Rec."ECO CGST (@2.5%) Amt.(Abhibus)")
                {
                    ApplicationArea = All;
                }
                field("ECO SGST (@2.5%) Amt.(Abhibus)"; Rec."ECO SGST (@2.5%) Amt.(Abhibus)")
                {
                    ApplicationArea = All;
                }
                field("Total Tax on Fare"; Rec."Total Tax on Fare")
                {
                    ApplicationArea = All;
                }
                field("SAC Code"; Rec."SAC Code")
                {
                    ApplicationArea = All;
                }
                field("Pickup Place"; Rec."Pickup Place")
                {
                    ApplicationArea = All;
                }
                field("Customer GSTIN"; Rec."Customer GSTIN")
                {
                    ApplicationArea = All;
                }
                field("Pickup State"; Rec."Pickup State")
                {
                    ApplicationArea = All;
                }
                field("Abhibus Tax Invoice No."; Rec."Abhibus Tax Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Abhibus Tax Invoice Date"; Rec."Abhibus Tax Invoice Date")
                {
                    ApplicationArea = All;
                }
                field("Abhibus SAC Code"; Rec."Abhibus SAC Code")
                {
                    ApplicationArea = All;
                }
                field("Customer GSTIN if Provided"; Rec."Customer GSTIN if Provided")
                {
                    ApplicationArea = All;
                }
                field("Place of supply"; Rec."Place of supply")
                {
                    ApplicationArea = All;
                }
                field("IRN No."; Rec."IRN No.")
                {
                    ApplicationArea = All;
                }
                field("IRN Date"; Rec."IRN Date")
                {
                    ApplicationArea = All;
                }
                field("Service Charge"; Rec."Service Charge")
                {
                    ApplicationArea = All;
                }
                field("Free Cancellation Fee"; Rec."Free Cancellation Fee")
                {
                    ApplicationArea = All;
                }
                field("Prime Membership Fee"; Rec."Prime Membership Fee")
                {
                    ApplicationArea = All;
                }
                field("Assured Subscrption Fee"; Rec."Assured Subscrption Fee")
                {
                    ApplicationArea = All;
                }
                field("Round Off Amount"; Rec."Round Off Amount")
                {
                    ApplicationArea = All;
                }
                field("Gross Income"; Rec."Gross Income")
                {
                    ApplicationArea = All;
                }
                field("Instant Discount"; Rec."Instant Discount")
                {
                    ApplicationArea = All;
                }
                field("Taxable Value (Incl. Tax)"; Rec."Taxable Value (Incl. Tax)")
                {
                    ApplicationArea = All;
                }
                field("Taxable Value (Excl. Tax)"; Rec."Taxable Value (Excl. Tax)")
                {
                    ApplicationArea = All;
                }
                field("Tax Rate"; Rec."Tax Rate")
                {
                    ApplicationArea = All;
                }
                field("IGST Amount"; Rec."IGST Amount")
                {
                    ApplicationArea = All;
                }
                field("CGST Amount"; Rec."CGST Amount")
                {
                    ApplicationArea = All;
                }
                field("SGST Amount"; Rec."SGST Amount")
                {
                    ApplicationArea = All;
                }
                field("Travel Insurance"; Rec."Travel Insurance")
                {
                    ApplicationArea = All;
                }
                field("Insurance Benfit (Prime Users)"; Rec."Insurance Benfit (Prime Users)")
                {
                    ApplicationArea = All;
                }
                field("Abhicash Used Promo"; Rec."Abhicash Used Promo")
                {
                    ApplicationArea = All;
                }
                field("Abhicash Used Non Promo"; Rec."Abhicash Used Non Promo")
                {
                    ApplicationArea = All;
                }
                field("Net PG/ Agent Amt. Collected"; Rec."Net PG/ Agent Amt. Collected")
                {
                    ApplicationArea = All;
                }
                field("GST on FC"; Rec."GST on FC")
                {
                    ApplicationArea = All;
                }
                field("GST on Asssured"; Rec."GST on Asssured")
                {
                    ApplicationArea = All;
                }
                field("GST on Prime"; Rec."GST on Prime")
                {
                    ApplicationArea = All;
                }
                field("GST on Service charges"; Rec."GST on Service charges")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = xmlport "Booking Transactions";
            }
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Rec.PostBookingTransactions();
                    CurrPage.Update();
                end;
            }
        }
    }

    var
}