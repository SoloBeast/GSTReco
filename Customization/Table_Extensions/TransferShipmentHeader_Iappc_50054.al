tableextension 50054 "Transfer Shipment Header Ext." extends "Transfer Shipment Header"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "E-Invoice Status"; Option)
        {
            OptionMembers = "Open","Generated","Cancelled";
        }
        field(70001; "E-Way Status"; Option)
        {
            OptionMembers = "Open","Generated","Cancelled";
        }
        field(70002; "IGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('IGST')));
        }
        field(70003; "CGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('CGST')));
        }
        field(70004; "SGST Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - sum("Detailed GST Ledger Entry"."GST Amount" where("Document No." = field("No."),
                                                                "Entry Type" = const("Initial Entry"),
                                                                "GST Component Code" = filter('SGST')));
        }
        field(70005; "Total Line Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Transfer Shipment Line".Amount where("Document No." = field("No."), Quantity = filter(<> 0)));
        }
        field(70006; "IRN Hash"; Text[70])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70007; "Acknowledgement No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70008; "Acknowledgement Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70009; "QR Code"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(70010; "E-Invoice Cancel Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    var
}