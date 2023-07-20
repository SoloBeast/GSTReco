tableextension 50002 "Purchase Setup Ext." extends "Purchases & Payables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "Vendor Dimension"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(70001; "Term 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(70002; "Term 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(70003; "Term 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(71000; "GSTR Reco. Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(71001; "GSTR 2 FTP Input"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(71002; "GSTR 2 Client ID"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(71003; "GSTR 2 FTP Error Path"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(71004; "GSTR 2 FTP Error ProcessedPath"; Text[100])
        {
            Caption = 'GSTR 2 FTP Error Processed Path';
            DataClassification = ToBeClassified;
        }
        field(71005; "GSTR 2 FTP Status Path"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(71006; "GSTR 2 FTP Status Processed"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(71007; "GSTR 2 E-mail User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(71008; "GST Forced Pymt. Approval ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(71009; "GSTR 2 Local Folder"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(71010; "FTP User ID"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(71011; "FTP Password"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
}