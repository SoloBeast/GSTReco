tableextension 50040 "Dimension Value Ext." extends "Dimension Value"
{
    fields
    {
        // Add changes to table fields here
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