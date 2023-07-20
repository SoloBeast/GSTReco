tableextension 50057 "Cust. Ledger Ext." extends "Cust. Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Transaction Nature"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Payment","Invoice","Credit Memo","Reecipt";
        }
        field(50001; "Currency Excharge Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Advance Payment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60000; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60001; "Created At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60002; "Approved By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60003; "Approved At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60004; "Posted By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60005; "Posted At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    var
}