page 50035 "Cancel Transactions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cancel Transactions";
    Caption = 'Cancel Transactions';
    //Editable = false;
    //InsertAllowed = false;
    //DeleteAllowed = false;
    //ModifyAllowed = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(CancelTransactions)
            {
                ShowCaption = false;
                Editable = false;

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created At"; Rec."Created At")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Cancellation Date"; Rec."Cancellation Date")
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
                field("Refund Mode"; Rec."Refund Mode")
                {
                    ApplicationArea = All;
                }
                field("Supplier Type"; Rec."Supplier Type")
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
                field("ECO"; Rec."ECO")
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
                field("Abhibus Credit Note No."; Rec."Abhibus Credit Note No.")
                {
                    ApplicationArea = All;
                }
                field("Abhibus Credit Note Date"; Rec."Abhibus Credit Note Date")
                {
                    ApplicationArea = All;
                }
                field("Abhibus Org. Inv. No."; Rec."Abhibus Org. Inv. No.")
                {
                    ApplicationArea = All;
                }
                field("Abhibus Org. Inv. Date"; Rec."Abhibus Org. Inv. Date")
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
                field("Base Fare Refunded"; Rec."Base Fare Refunded")
                {
                    ApplicationArea = All;
                }
                field("Lavy Fee Refund"; Rec."Lavy Fee Refund")
                {
                    ApplicationArea = All;
                }
                field("Toll Fee Refund"; Rec."Toll Fee Refund")
                {
                    ApplicationArea = All;
                }
                field("Service Fee Refund"; Rec."Service Fee Refund")
                {
                    ApplicationArea = All;
                }
                field("Total Fare Refund"; Rec."Total Fare Refund")
                {
                    ApplicationArea = All;
                }
                field("Operator Cancellation Charges"; Rec."Operator Cancellation Charges")
                {
                    ApplicationArea = All;
                }
                field("Comm.% (Base fare) Excl. GST"; Rec."Comm.% (Base fare) Excl. GST")
                {
                    ApplicationArea = All;
                }
                field("Comm% (Cancellation) Excl. GST"; Rec."Comm% (Cancellation) Excl. GST")
                {
                    ApplicationArea = All;
                }
                field("Comm. Reversal (Base Fare)"; Rec."Comm. Reversal (Base Fare)")
                {
                    ApplicationArea = All;
                }
                field("Comm. Earned on Cancellation"; Rec."Comm. Earned on Cancellation")
                {
                    ApplicationArea = All;
                }
                field("GST On Comm. Reversal IGST"; Rec."GST On Comm. Reversal IGST")
                {
                    ApplicationArea = All;
                }
                field("GST On Comm. Reversal CGST"; Rec."GST On Comm. Reversal CGST")
                {
                    ApplicationArea = All;
                }
                field("GST On Comm. Reversal SGST"; Rec."GST On Comm. Reversal SGST")
                {
                    ApplicationArea = All;
                }
                field("Total GST"; Rec."Total GST")
                {
                    ApplicationArea = All;
                }
                field("GST On Comm. Earned IGST"; Rec."GST On Comm. Earned IGST")
                {
                    ApplicationArea = All;
                }
                field("GST On Comm. Earned CGST"; Rec."GST On Comm. Earned CGST")
                {
                    ApplicationArea = All;
                }
                field("GST On Comm. Earned SGST"; Rec."GST On Comm. Earned SGST")
                {
                    ApplicationArea = All;
                }
                field("Total GST On Earned Comm."; Rec."Total GST On Earned Comm.")
                {
                    ApplicationArea = All;
                }
                field("TDS Rate U/S 194O"; Rec."TDS Rate U/S 194O")
                {
                    ApplicationArea = All;
                }
                field("TDS U/S 194O"; Rec."TDS U/S 194O")
                {
                    ApplicationArea = All;
                }
                field("Net Payable to Operator"; Rec."Net Payable to Operator")
                {
                    ApplicationArea = All;
                }
                field("ECO GST Amt. Rvd. Aggregator"; Rec."ECO GST Amt. Rvd. Aggregator")
                {
                    Caption = 'ECO GST Amt. Reversed by Aggregator';
                    ApplicationArea = All;
                }
                field("ECO GST Amount Rvd. Seller"; Rec."ECO GST Amount Rvd. Seller")
                {
                    Caption = 'ECO GST Amount reversed by Seller (Irctc)';
                    ApplicationArea = All;
                }
                field("ECO GST Reversed by CGW"; Rec."ECO GST Reversed by CGW")
                {
                    ApplicationArea = All;
                }
                field("ECO IGST Amount Rvd. Abhibus"; Rec."ECO IGST Amount Rvd. Abhibus")
                {
                    ApplicationArea = All;
                }
                field("ECO CGST Amount Rvd. Abhibus"; Rec."ECO CGST Amount Rvd. Abhibus")
                {
                    ApplicationArea = All;
                }
                field("ECO SGST Amount Rvd. Abhibus"; Rec."ECO SGST Amount Rvd. Abhibus")
                {
                    ApplicationArea = All;
                }
                field("Total Tax on Fare"; Rec."Total Tax on Fare")
                {
                    ApplicationArea = All;
                }
                field("Tax Rate"; Rec."Tax Rate")
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
                field("Place of Supply"; Rec."Place of Supply")
                {
                    ApplicationArea = All;
                }
                field("Abhibus Tax Credit Note No."; Rec."Abhibus Tax Credit Note No.")
                {
                    ApplicationArea = All;
                }
                field("Abhibus Tax Credit Note Date"; Rec."Abhibus Tax Credit Note Date")
                {
                    ApplicationArea = All;
                }
                field("Abhibus Tax Original Inv. No."; Rec."Abhibus Tax Original Inv. No.")
                {
                    ApplicationArea = All;
                }
                field("Abhibus Tax Original Inv. date"; Rec."Abhibus Tax Original Inv. date")
                {
                    ApplicationArea = All;
                }
                field("Customer SAC Code"; Rec."Customer SAC Code")
                {
                    ApplicationArea = All;
                }
                field("Customer GSTIN 1"; Rec."Customer GSTIN 1")
                {
                    ApplicationArea = All;
                }
                field("Place of Supply 1"; Rec."Place of Supply 1")
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
                field("Abhibus Cancellation Charges"; Rec."Abhibus Cancellation Charges")
                {
                    ApplicationArea = All;
                }
                field("Instant Discount Reversal"; Rec."Instant Discount Reversal")
                {
                    ApplicationArea = All;
                }
                field("Round Off Income"; Rec."Round Off Income")
                {
                    ApplicationArea = All;
                }
                field("Total Charges Net of Discount"; Rec."Total Charges Net of Discount")
                {
                    ApplicationArea = All;
                }
                field("Taxable Value"; Rec."Taxable Value")
                {
                    ApplicationArea = All;
                }
                field("IGST"; Rec."IGST")
                {
                    ApplicationArea = All;
                }
                field("CGST"; Rec."CGST")
                {
                    ApplicationArea = All;
                }
                field("SGST"; Rec."SGST")
                {
                    ApplicationArea = All;
                }
                field("Abhicash Promo Reversed"; Rec."Abhicash Promo Reversed")
                {
                    ApplicationArea = All;
                }
                field("Abhicash Non-Promo Reversed"; Rec."Abhicash Non-Promo Reversed")
                {
                    ApplicationArea = All;
                }
                field("Prime Membership Benefits"; Rec."Prime Membership Benefits")
                {
                    ApplicationArea = All;
                }
                field("Free Cancellation Benefits"; Rec."Free Cancellation Benefits")
                {
                    ApplicationArea = All;
                }
                field("Assured Benefits"; Rec."Assured Benefits")
                {
                    ApplicationArea = All;
                }
                field("Net Amount Refunded to PG"; Rec."Net Amount Refunded to PG")
                {
                    ApplicationArea = All;
                }
                field("Refund PG Reference No."; Rec."Refund PG Reference No.")
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
                RunObject = xmlport "Cancel Transactions";
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
                    Rec.PostCancelTransactions();
                    CurrPage.Update();
                end;
            }
        }
    }

    var
}