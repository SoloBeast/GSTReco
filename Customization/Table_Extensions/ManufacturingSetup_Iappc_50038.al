tableextension 50038 "Manufacturing Setup Ext." extends "Manufacturing Setup"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "Requisition Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    var
}