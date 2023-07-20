tableextension 50034 "Location Ext." extends Location
{
    fields
    {
        // Add changes to table fields here
        field(50000; "GST Registration Type"; Option)
        {
            OptionMembers = "Regular","TCS";
        }
        field(50001; "LUT / Bond No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Lut / Bond From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Lut / Bond To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(70000; "QC Rejection Location"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code where("Use As In-Transit" = const(false));
        }
        field(70001; "Prod. Floor Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code where("Use As In-Transit" = const(false));
        }
        field(70002; "Prod. Trf. Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Template".Name WHERE(Type = FILTER(Transfer));
        }
        field(70003; "Prod. Trf. Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Prod. Trf. Template"));
        }
        field(70004; "Job Work Receipt Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Template".Name WHERE(Type = FILTER(Item));
        }
        field(70005; "Job Work Receipt Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Job Work Receipt Template"));
        }
        field(70006; "Job Work Consumption Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Template".Name WHERE(Type = FILTER(Item));
        }
        field(70007; "Job Work Consumption Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Job Work Consumption Template"));
        }
        field(70008; "JW Outward Issue Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Template".Name WHERE(Type = FILTER(Transfer));
        }
        field(70009; "JW Outward Issue Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("JW Outward Issue Template"));
        }
        field(70010; "Pstd. JW Inward Rcpt. Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(70011; "Pstd. JW Inward Issue Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(70012; "RGP Posting Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Template".Name WHERE(Type = FILTER(Item));
        }
        field(70013; "RGP Posting Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("RGP Posting Template"));
        }
        field(70014; "Posted RGP Issue Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(70015; "Posted RGP Rcpt. Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(70016; "Posted NRGP Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(70017; "Pstd. JW Outward Issue Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(70018; "Job Work Location"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(70019; "Pstd. JW Outward Rcpt. Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    var
}