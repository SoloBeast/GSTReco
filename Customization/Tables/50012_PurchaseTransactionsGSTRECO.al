table 50012 PurchaseTransactions
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
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
        field(14; "Taxable Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }

    }
    var
        myInt: Integer;

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