tableextension 50046 "Purch. Rcpt. Header Ext." extends "Purch. Rcpt. Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "RCM Applicable"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Yes","No";
        }
        field(50001; "PO Term 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "PO Term 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Due Date Calc. Basis"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Posting Date","Document Date";
        }
        field(50004; "Internal Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Actual","Cancel";
        }
        field(50005; "206 AB"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50006; "Document Basis"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","PO Base","Non-PO";
        }
        field(50007; "Purch. Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));
        }
        field(50008; "Short Closed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60000; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60001; "Created At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60002; "Approved By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60003; "Approved At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60004; "Posted By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60005; "Posted At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70000; "Manually Closed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
}