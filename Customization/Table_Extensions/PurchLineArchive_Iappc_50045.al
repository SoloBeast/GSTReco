tableextension 50045 "Purchase Line Archive Ext." extends "Purchase Line Archive"
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
        field(70003; "Order Status"; Enum "Purchase Document Status")
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".Status where("Document Type" = field("Document Type"), "No." = field("Document No.")));
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