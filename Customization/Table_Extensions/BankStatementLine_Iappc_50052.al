tableextension 50052 "Bank Statement Line Ext." extends "Bank Account Statement Line"
{
    fields
    {
        // Add changes to table fields here
        field(71000; "Remarks"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(71001; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
}