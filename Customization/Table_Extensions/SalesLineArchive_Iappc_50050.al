tableextension 50050 "Sales Line Archive Ext." extends "Sales Line Archive"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Narration"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
}