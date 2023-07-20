tableextension 50055 "Transfer Shipment Line Ext." extends "Transfer Shipment Line"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "GST Base Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - sum("Detailed GST Ledger Entry"."GST Base Amount" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('IGST|CGST')));
        }
        field(70001; "IGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('IGST')));
        }
        field(70002; "CGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('CGST')));
        }
        field(70003; "SGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('SGST')));
        }
        field(70004; "IGST %"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Detailed GST Ledger Entry"."GST %" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('IGST')));
        }
        field(70005; "CGST %"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Detailed GST Ledger Entry"."GST %" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('CGST')));
        }
        field(70006; "SGST %"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Detailed GST Ledger Entry"."GST %" where("Document No." = field("Document No."),
                                                                "Document Line No." = field("Line No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('SGST')));
        }
    }

    var
}