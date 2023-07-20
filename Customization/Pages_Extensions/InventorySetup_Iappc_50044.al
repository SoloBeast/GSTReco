pageextension 50044 "Inventory Setup Ext." extends "Inventory Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Nonstock Item Nos.")
        {
            field("Indent Nos."; Rec."Indent Nos.")
            {
                ApplicationArea = all;
            }
            field("Job Work Inward Nos."; Rec."Job Work Inward Nos.")
            {
                ApplicationArea = all;
            }
            field("Job Work Outward Nos."; Rec."Job Work Outward Nos.")
            {
                ApplicationArea = all;
            }
            field("RGP Nos."; Rec."RGP Nos.")
            {
                ApplicationArea = all;
            }
            field("NRGP Nos."; Rec."NRGP Nos.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Location Mandatory")
        {
            field("QC Rejection Template"; Rec."QC Rejection Template")
            {
                ApplicationArea = all;
            }
            field("QC Rejection Batch"; Rec."QC Rejection Batch")
            {
                ApplicationArea = all;
            }
            field("Job Work Location"; Rec."Job Work Location")
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