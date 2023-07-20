tableextension 50029 "Inventory Setup Ext." extends "Inventory Setup"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "Indent Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(70001; "QC Rejection Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Template" WHERE(Type = FILTER(Transfer));
        }
        field(70002; "QC Rejection Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("QC Rejection Template"));
        }
        field(70003; "Job Work Inward Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(70004; "Job Work Outward Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(70005; "Job Work Location"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code where("Use As In-Transit" = const(false));
        }
        field(70006; "RGP Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(70007; "NRGP Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    var
}