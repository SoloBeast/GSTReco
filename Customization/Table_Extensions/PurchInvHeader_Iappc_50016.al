tableextension 50016 "Purch. Inv. Header Ext." extends "Purch. Inv. Header"
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
        field(70001; "Total Line Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Purch. Inv. Line"."Line Amount" where("System-Created Entry" = const(false),
                                                                "Document No." = field("No."), Quantity = filter(<> 0)));
        }
        field(70002; "Total Line Discount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Purch. Inv. Line"."Line Discount Amount" where("System-Created Entry" = const(false),
                                                                "Document No." = field("No."), Quantity = filter(<> 0)));
        }
        field(70003; "Total GST Base Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Base Amount" where("Document No." = field("No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('IGST|CGST')));
        }
        field(70004; "IGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('IGST')));
        }
        field(70005; "CGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('CGST')));
        }
        field(70006; "SGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('SGST')));
        }
        field(70007; "TDS Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TDS Entry"."Total TDS Including SHE CESS" where("Document No." = field("No.")));
        }
        field(70008; "GST Reverse Charged"; Boolean)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Detailed GST Ledger Entry"."Reverse Charge" where("Document No." = field("No."),
                                                                "Entry Type" = const("Initial Entry")));
        }
        field(71000; "GSTR 2 Exported"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(71001; "GSTR2 Status"; Option)
        {
            OptionMembers = " ","Matched","Accepted","Mis-Matched";
        }
    }

    var
}