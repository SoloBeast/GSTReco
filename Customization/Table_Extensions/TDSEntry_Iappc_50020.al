tableextension 50020 "TDS Entry Ext." extends "TDS Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Narration"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Expense G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50002; "External Doc. No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(70000; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
        }
    }

    var
}