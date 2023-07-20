tableextension 50005 "GL Setup Ext." extends "General Ledger Setup"
{
    fields
    {
        //Digital Sign
        field(50001; "Signer"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Pfxid"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Pfxpwd"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Signloc"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Signannotation"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Digital Sign URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "API Key"; Text[40])
        {
            DataClassification = ToBeClassified;
        }
        // Add changes to table fields here
        field(70000; "Bank Dimension"; Code[20])
        {
            TableRelation = Dimension;
        }
    }

    var
}