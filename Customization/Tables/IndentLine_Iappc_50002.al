table 50002 "Indent Line"
{
    DataClassification = ToBeClassified;
    CompressionType = Page;

    fields
    {
        field(1; "Indent No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Indent Header";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Date; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Location.Code where("Use As In-Transit" = const(false));
        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,1';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(6; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,2';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(7; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Status"; Option)
        {
            OptionMembers = "Open","Pending Approval","Approved";
            Editable = false;
        }
        field(9; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Item";
        }
        field(10; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;

            trigger OnValidate()
            begin
                IF Rec.Type = Rec.Type::Item THEN BEGIN
                    IF recItem.GET(Rec."No.") THEN BEGIN
                        Rec.Description := recItem.Description;
                        Rec."Unit of Measure" := recItem."Base Unit of Measure";
                    END ELSE BEGIN
                        Description := '';
                        "Unit of Measure" := '';
                    END;
                END ELSE BEGIN
                    Description := '';
                    "Unit of Measure" := '';
                END;
            end;
        }
        field(11; Description; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Unit of Measure"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
            Editable = false;
        }
        field(13; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Approved Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Remaining Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Approved / Rejected At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "Approved / Rejected By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; "Variant Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Variant".Code where("Item No." = field("No."));
        }
    }

    keys
    {
        key(Key1; "Indent No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        recIndentLine: Record "Indent Line";
        recItem: Record Item;

    trigger OnInsert()
    begin
        recIndentLine.RESET;
        recIndentLine.SETRANGE("Indent No.", Rec."Indent No.");
        IF recIndentLine.FINDLAST THEN
            Rec."Line No." := recIndentLine."Line No." + 10000
        ELSE
            Rec."Line No." := 10000;

        Rec.TestField("No.");
        Rec.TESTFIELD(Quantity);
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