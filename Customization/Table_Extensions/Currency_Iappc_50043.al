tableextension 50043 "Currency Ext." extends Currency
{
    fields
    {
        // Add changes to table fields here
        field(70000; "Currency Numeric Description"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70001; "Currency Decimal Description"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
}