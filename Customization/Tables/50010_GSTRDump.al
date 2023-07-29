table 50010 GSTRDump
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            // AutoIncrement = true;
            // Editable = false;

        }
        field(2; "File Type."; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "B2B","B2BA","B2B-CDNR","B2B-CDNRA","IMPG";

        }
        field(3; "GSTIN Supplier"; Code[15])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Trade/Legal Name"; Text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Invoice No"; Code[16])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Invoice Type"; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Invocie Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Invoice Value"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Place of Supply"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Supply Attract Reverce Charge"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Rate(%)"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Taxable Value"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Integrated Tax"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(14; "Central Tax"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(15; "State/UT Tax"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(16; "Cess"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(17; "GSTR-1/IFF/GSTR-5 Period"; Text[15])
        {
            DataClassification = ToBeClassified;

        }
        field(18; "GSTR-1/IFF/GSTR-5 Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(19; "ITC Availability"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(20; "Reason"; Text[150])
        {
            DataClassification = ToBeClassified;

        }
        field(21; "Applicable % of Tax Rate"; Text[10])
        {
            DataClassification = ToBeClassified;

        }
        field(22; "Source"; Text[150])
        {
            DataClassification = ToBeClassified;

        }
        field(23; "IRN"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(24; "IRN Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(25; "Note Type"; Text[15])
        {
            DataClassification = ToBeClassified;

        }
        field(26; "Icegate Reference Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(27; "Note Type1"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(28; "Port Code"; Code[50])
        {
            DataClassification = ToBeClassified;

        }
        field(29; "Amended (Yes)"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(30; "Taxable Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(31; "Error"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Error Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Match"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(UK; "GSTIN Supplier")
        {
            Clustered = false;
        }
    }

    var
        myInt: Integer;


}