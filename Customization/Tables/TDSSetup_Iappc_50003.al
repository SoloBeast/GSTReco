table 50003 "Iappc TDS Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "TDS Section"; Code[10])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "TDS Section";
        }
        field(2; "Assessee Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Assessee Code".Code;
        }
        field(3; "Concessional Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Concessional Code".Code;
        }
        field(4; "Effective Date"; Date)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(5; "TDS %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "TDS Section", "Assessee Code", "Concessional Code", "Effective Date")
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