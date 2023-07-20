tableextension 50019 "Purch. Cr.Memo Line Ext." extends "Purch. Cr. Memo Line"
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
        field(71000; "Iappc TDS Section"; Code[20])
        {
            Caption = 'TDS Section';
            DataClassification = ToBeClassified;
            TableRelation = "Allowed Sections"."TDS Section" where("Vendor No" = field("Pay-to Vendor No."));
        }
        field(71001; "TDS %"; Decimal)
        {
            Editable = false;
            DataClassification = ToBeClassified;
            MinValue = 0;
            DecimalPlaces = 2 : 2;
        }
        field(71002; "TDS Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            MinValue = 0;
            DecimalPlaces = 2 : 2;
        }
        field(71003; "TDS Base Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            MinValue = 0;
            DecimalPlaces = 2 : 2;
        }
        field(71004; "TDS to Post"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'TDS Amount';
            Editable = false;
            MinValue = 0;
            DecimalPlaces = 2 : 2;
        }
        field(71005; "Concessional Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Concessional Code".Code;
        }
    }

    var
}