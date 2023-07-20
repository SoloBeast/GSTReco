pageextension 50000 "Sales Setup Ext." extends "Sales & Receivables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group(BookingCancellation)
            {
                Caption = 'Booking / Cancellation A/c';
                field("Total Fare Account"; Rec."Total Fare Account")
                {
                    ApplicationArea = all;
                }
                field("Commission Earned A/c"; Rec."Commission Earned A/c")
                {
                    ApplicationArea = all;
                }
                field("SaaS Commission CGW A/c"; Rec."SaaS Commission CGW A/c")
                {
                    ApplicationArea = all;
                }
                field("GST Account"; Rec."GST Account")
                {
                    ApplicationArea = all;
                }
                field("Total Tax on Fare"; Rec."Total Tax on Fare")
                {
                    ApplicationArea = all;
                }
                field("ECO IGST Account"; Rec."ECO IGST Account")
                {
                    ApplicationArea = all;
                }
                field("ECO CGST Account"; Rec."ECO CGST Account")
                {
                    ApplicationArea = all;
                }
                field("ECO SGST Account"; Rec."ECO SGST Account")
                {
                    ApplicationArea = all;
                }
                field("ECO GST Aggregator A/c"; Rec."ECO GST Aggregator A/c")
                {
                    ApplicationArea = all;
                }
                field("Edge Discount Offer A/c"; Rec."Edge Discount Offer A/c")
                {
                    ApplicationArea = all;
                }
                field("TDS Payable ECO A/c"; Rec."TDS Payable ECO A/c")
                {
                    ApplicationArea = all;
                }
                field("Net PG/Agent Amt. Collected"; Rec."Net PG/Agent Amt. Collected")
                {
                    ApplicationArea = all;
                }
                field("Abhicash Non Promo"; Rec."Abhicash Non Promo")
                {
                    ApplicationArea = all;
                }
                field("Instant Discount"; Rec."Instant Discount")
                {
                    ApplicationArea = all;
                }
                field("Abhicash Promo"; Rec."Abhicash Promo")
                {
                    ApplicationArea = all;
                }
                field("Edge Discount by Operator"; Rec."Edge Discount by Operator")
                {
                    ApplicationArea = all;
                }
                field("Insurance Benfit (Prime User)"; Rec."Insurance Benfit (Prime User)")
                {
                    ApplicationArea = all;
                }
                field("Service Charge"; Rec."Service Charge")
                {
                    ApplicationArea = all;
                }
                field("Free Cancellation Fee"; Rec."Free Cancellation Fee")
                {
                    ApplicationArea = all;
                }
                field("Prime Membership Fee"; Rec."Prime Membership Fee")
                {
                    ApplicationArea = all;
                }
                field("Assured Subscription Fee"; Rec."Assured Subscription Fee")
                {
                    ApplicationArea = all;
                }
                field("Round Off Income"; Rec."Round Off Income")
                {
                    ApplicationArea = all;
                }

            }
        }
        addafter("Salesperson Dimension Code")
        {
            field("Customer Dimension"; Rec."Customer Dimension")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}