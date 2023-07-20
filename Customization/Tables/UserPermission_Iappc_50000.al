table 50000 "User Permission"
{
    DataClassification = ToBeClassified;
    CompressionType = Page;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            Editable = false;
        }
        field(2; "Type"; Option)
        {
            OptionMembers = " ","Master","Transaction","Posting";
            Editable = false;
        }
        field(3; "Sub Type"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Editable = false;
        }
        field(4; "Document Type"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Editable = false;
        }
        field(50; "Sub Type Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51; "Document Type Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(100; "Allow Creation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(101; "Allow Modification"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Allow Deletion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "User ID", Type, "Sub Type", "Document Type")
        {
            Clustered = true;
        }
    }

    var

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;
}