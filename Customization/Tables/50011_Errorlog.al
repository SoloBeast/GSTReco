table 50011 "Error Log"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Error Id"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "GST Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Purchase Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Error Description"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Pending","Solved";
            Editable = false;
        }
        field(7; "Error Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Reco By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Partially Matched"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

}