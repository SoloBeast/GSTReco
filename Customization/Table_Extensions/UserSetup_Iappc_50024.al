tableextension 50024 "User Setup Ext." extends "User Setup"
{
    fields
    {
        field(50000; "Print Export Invoice"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        // Add changes to table fields here
        field(70000; "Default Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code where("Use As In-Transit" = const(false));
        }
        field(70001; "Default Global Dimension 1"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
    }

    var
}