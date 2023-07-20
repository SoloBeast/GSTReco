tableextension 50018 "Purch. Inv. Line Ext." extends "Purch. Inv. Line"
{
    fields
    {
        // Add changes to table fields here
        field(70001; "Indent No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Indent Header";
            Editable = false;
        }
        field(70002; "Indent Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Indent Line"."Line No." WHERE("Indent No." = FIELD("Indent No."));
            Editable = false;
        }
        field(70004; "QC Pending"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70005; "GST Base Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Base Amount" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('IGST|CGST')));
        }
        field(70006; "IGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('IGST')));
        }
        field(70007; "CGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('CGST')));
        }
        field(70008; "SGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('SGST')));
        }
        field(70009; "IGST %"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Detailed GST Ledger Entry"."GST %" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('IGST')));
        }
        field(70010; "CGST %"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Detailed GST Ledger Entry"."GST %" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('CGST')));
        }
        field(70011; "SGST %"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Detailed GST Ledger Entry"."GST %" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('SGST')));
        }
        field(70012; "Section Wise TDS Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TDS Entry"."Total TDS Including SHE CESS" where("Document No." = field("Document No."),
                                                            Section = field("TDS Section Code")));
        }
        field(70013; "Section Wise TDS Base Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TDS Entry"."TDS Base Amount" where("Document No." = field("Document No."),
                                                            Section = field("TDS Section Code")));
        }
    }

    var
}