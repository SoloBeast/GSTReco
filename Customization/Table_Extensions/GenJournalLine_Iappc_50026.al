tableextension 50026 "Gen. Journal Line Ext." extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Transaction Nature"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Payment","Invoice","Credit Memo","Receipt","Journal","Refund";
        }
        field(50001; "Type of Transaction"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Purch. Order","Non-Purch. Order";
        }
        field(50002; "Purch. Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order), "Buy-from Vendor No." = field("Account No."), Status = const(Released));
        }
        field(50003; "Advance Payment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "UTR No."; Code[30])
        {
            DataClassification = ToBeClassified;
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
        field(70000; "Record ID"; RecordId)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70001; "TDS Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Tax Transaction Value"."Amount (LCY)" where("Tax Record ID" = field("Record ID"),
                                                                            "Tax Type" = const('TDS'),
                                                                            "Value ID" = const(7)));
        }
        field(71000; "GST Amount on Hold"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(71001; "Pay GST"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(71002; "GST Payment Approval Status"; Option)
        {
            OptionMembers = "Open","Approved","Rejected","Pending Approval";
            Editable = false;
        }
        field(71003; "GST Payment Forced"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(71004; "GSTR2 Status"; Option)
        {
            OptionMembers = " ","Matched","Accepted","Mis-Matched";
        }
        field(71005; "GST Pymt. User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(71006; "GST Pymt. User Remarks"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(71007; "GST Pymt. Approver ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(71008; "GST Pymt. Approver Remarks"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    trigger OnAfterInsert()
    begin
        Rec."Record ID" := Rec.RecordId;
        Rec.Modify();
    end;

    var
}