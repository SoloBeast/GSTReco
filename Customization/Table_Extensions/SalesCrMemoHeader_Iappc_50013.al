tableextension 50013 "Sales Cr.Memo Header Ext." extends "Sales Cr.Memo Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Internal Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Actual","Cancel";
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
            CalcFormula = sum("Sales Cr.Memo Line"."Line Amount" where("System-Created Entry" = const(false),
                                                                "Document No." = field("No."), Quantity = filter(<> 0)));
        }
        field(70002; "Total Line Discount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Sales Cr.Memo Line"."Line Discount Amount" where("System-Created Entry" = const(false),
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
        field(70007; "TCS Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TCS Entry"."Total TCS Including SHE CESS" where("Document No." = field("No.")));
        }
        field(60100; "E-Invoice Status"; Option)
        {
            OptionMembers = "Open","Generated","Cancelled";
        }
    }

    var
}