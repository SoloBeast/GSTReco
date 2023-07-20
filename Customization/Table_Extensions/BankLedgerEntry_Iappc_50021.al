tableextension 50021 "Bank Ledger Entry Ext." extends "Bank Account Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Transaction Nature"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Payment","Invoice","Credit Memo","Reecipt";
        }
        field(50001; "UTR No."; Code[30])
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
        field(70000; "Value Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Bank Account Statement Line"."Value Date" where("Bank Account No." = field("Bank Account No."),
                                                                        "Statement No." = field("Statement No."),
                                                                        "Statement Line No." = field("Statement Line No.")));
        }
    }

    var
}