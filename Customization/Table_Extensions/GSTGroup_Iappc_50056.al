tableextension 50056 "GST Group Ext." extends "GST Group"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "GST %"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            DecimalPlaces = 2 : 2;
        }
    }

    var
}