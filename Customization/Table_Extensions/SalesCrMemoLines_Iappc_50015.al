tableextension 50015 "Sales Cr.Memo Line Ext." extends "Sales Cr.Memo Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Narration"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(70001; "GST Base Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - sum("Detailed GST Ledger Entry"."GST Base Amount" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('IGST|CGST')));
        }
        field(70002; "IGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('IGST')));
        }
        field(70003; "CGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('CGST')));
        }
        field(70004; "SGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('SGST')));
        }
        field(70005; "IGST %"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Detailed GST Ledger Entry"."GST %" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('IGST')));
        }
        field(70006; "CGST %"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Detailed GST Ledger Entry"."GST %" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('CGST')));
        }
        field(70007; "SGST %"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Detailed GST Ledger Entry"."GST %" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('SGST')));
        }
        field(70008; "NOC Wise TCS Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TCS Entry"."Total TCS Including SHE CESS" where("Document No." = field("Document No."),
                                                        "TCS Nature of Collection" = field("TCS Nature of Collection")));
        }
        field(70009; "NOC Wise TCS Base Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TCS Entry"."TCS Base Amount" where("Document No." = field("Document No."),
                                                        "TCS Nature of Collection" = field("TCS Nature of Collection")));
        }
    }

    var
}