tableextension 50049 "Sales Shipment Line Ext." extends "Sales Shipment Line"
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