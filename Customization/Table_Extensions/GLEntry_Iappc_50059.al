tableextension 50059 "G/L Entry Ext." extends "G/L Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Transaction Nature"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Payment","Invoice","Credit Memo","Reecipt";
        }
        field(50001; "Currency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(50002; "Currency Excharge Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "LOC"; Code[20])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = const('LOC')));
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