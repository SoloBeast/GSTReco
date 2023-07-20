tableextension 50041 "Company Info. Ext." extends "Company Information"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "C.I.N. No."; Code[25])
        {
            DataClassification = ToBeClassified;
        }
        field(70001; "IFSC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
}