tableextension 50032 "Purch. Rcpt. Line Ext." extends "Purch. Rcpt. Line"
{
    fields
    {
        // Add changes to table fields here
        field(70001; "Indent No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Indent Header";
            Editable = false;
        }
        field(70002; "Indent Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Indent Line"."Line No." WHERE("Indent No." = FIELD("Indent No."));
            Editable = false;
        }
        field(70004; "QC Pending"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    var
}