
table 50012 PurchaseTransactions
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
            Editable = False;

        }
        field(2; "Vendor GST No."; Code[16])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Vendor Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Vendor Name"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Document Type"; Text[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Invoice Value"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "CGST Value"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "SGST/UGST Value"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "IGST Value"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "External Document No"; Code[25])
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Bill to State"; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(14; "Taxable Value"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(15; "Place of Supply"; Text[60])
        {
            DataClassification = ToBeClassified;

        }
        field(16; "RCM"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(17; "GST Rate%"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(18; "Error Details"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Error"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Match"; Boolean)
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
        key(UK; "Vendor GST No.")
        {
            Clustered = false;
        }
    }

}