tableextension 50031 "Vendor Bank Account Ext." extends "Vendor Bank Account"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Vendor Name"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
        }
        field(50001; "IFSC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70000; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70001; "Created At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70002; "Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70003; "Modified At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    var
}