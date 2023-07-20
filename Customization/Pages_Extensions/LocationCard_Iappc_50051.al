pageextension 50051 "Location Card" extends "Location Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("GST Registration No.")
        {
            field("GST Registration Type"; Rec."GST Registration Type")
            {
                ApplicationArea = all;
            }
            field("LUT / Bond No."; Rec."LUT / Bond No.")
            {
                ApplicationArea = all;
            }
            field("Lut / Bond From Date"; Rec."Lut / Bond From Date")
            {
                ApplicationArea = all;
            }
            field("Lut / Bond To Date"; Rec."Lut / Bond To Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Use As In-Transit")
        {
            field("QC Rejection Location"; Rec."QC Rejection Location")
            {
                ApplicationArea = all;
            }
            field("Prod. Floor Code"; Rec."Prod. Floor Code")
            {
                ApplicationArea = all;
            }
            field("Prod. Trf. Template"; Rec."Prod. Trf. Template")
            {
                ApplicationArea = all;
            }
            field("Prod. Trf. Batch"; Rec."Prod. Trf. Batch")
            {
                ApplicationArea = all;
            }
            field("Job Work Receipt Template"; Rec."Job Work Receipt Template")
            {
                ApplicationArea = all;
            }
            field("Job Work Receipt Batch"; Rec."Job Work Receipt Batch")
            {
                ApplicationArea = all;
            }
            field("Job Work Consumption Template"; Rec."Job Work Consumption Template")
            {
                ApplicationArea = all;
            }
            field("Job Work Consumption Batch"; Rec."Job Work Consumption Batch")
            {
                ApplicationArea = all;
            }
            field("Job Work Location"; Rec."Job Work Location")
            {
                ApplicationArea = all;
            }
            field("JW Outward Issue Template"; Rec."JW Outward Issue Template")
            {
                ApplicationArea = all;
            }
            field("JW Outward Issue Batch"; Rec."JW Outward Issue Batch")
            {
                ApplicationArea = all;
            }
            field("Pstd. JW Inward Rcpt. Nos."; Rec."Pstd. JW Inward Rcpt. Nos.")
            {
                ApplicationArea = all;
            }
            field("Pstd. JW Inward Issue Nos."; Rec."Pstd. JW Inward Issue Nos.")
            {
                ApplicationArea = all;
            }
            field("Pstd. JW Outward Issue Nos."; Rec."Pstd. JW Outward Issue Nos.")
            {
                ApplicationArea = all;
            }
            field("Pstd. JW Outward Rcpt. Nos."; Rec."Pstd. JW Outward Rcpt. Nos.")
            {
                ApplicationArea = all;
            }
            field("RGP Posting Template"; Rec."RGP Posting Template")
            {
                ApplicationArea = all;
            }
            field("RGP Posting Batch"; Rec."RGP Posting Batch")
            {
                ApplicationArea = all;
            }
            field("Posted RGP Issue Nos."; Rec."Posted RGP Issue Nos.")
            {
                ApplicationArea = all;
            }
            field("Posted RGP Rcpt. Nos."; Rec."Posted RGP Rcpt. Nos.")
            {
                ApplicationArea = all;
            }
            field("Posted NRGP Nos."; Rec."Posted NRGP Nos.")
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