tableextension 50001 "Customer Ext." extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(50000; "TCS Applicable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70000; "Opening Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(70001; "Opening Balance"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Currency Code" = FIELD("Currency Filter"), "Posting Date" = FIELD("Opening Date Filter"),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70002; "Opening Balance (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Currency Code" = FIELD("Currency Filter"), "Posting Date" = FIELD("Opening Date Filter"),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70003; "Closing Balance"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Currency Code" = FIELD("Currency Filter"), "Posting Date" = FIELD(Upperlimit("Date Filter")),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70004; "Closing Balance (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Currency Code" = FIELD("Currency Filter"), "Posting Date" = FIELD(upperlimit("Date Filter")),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70005; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70006; "Created At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70007; "Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70008; "Technical Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    trigger OnAfterInsert()
    begin
        recSalesSetup.GET;
        IF recSalesSetup."Customer Dimension" <> '' THEN BEGIN
            recDimensionValue.RESET;
            recDimensionValue.SETRANGE("Dimension Code", recSalesSetup."Customer Dimension");
            recDimensionValue.SETRANGE(Code, "No.");
            IF NOT recDimensionValue.FIND('-') THEN BEGIN
                recDimensionValue.INIT;
                recDimensionValue.VALIDATE("Dimension Code", recSalesSetup."Customer Dimension");
                recDimensionValue.VALIDATE(Code, "No.");
                recDimensionValue.INSERT(TRUE);
            END;
            recDefaultDimension.RESET;
            recDefaultDimension.SETRANGE("Table ID", 18);
            recDefaultDimension.SETRANGE(recDefaultDimension."No.", "No.");
            recDefaultDimension.SETRANGE("Dimension Code", recSalesSetup."Customer Dimension");
            IF NOT recDefaultDimension.FIND('-') THEN BEGIN
                recDefaultDimension.INIT;
                recDefaultDimension.VALIDATE("Table ID", 18);
                recDefaultDimension."No." := "No.";
                recDefaultDimension.VALIDATE("Dimension Code", recSalesSetup."Customer Dimension");
                recDefaultDimension."Dimension Value Code" := "No.";
                recDefaultDimension."Value Posting" := recDefaultDimension."Value Posting"::"Same Code";
                recDefaultDimension.INSERT();
            END;
        END;
    end;

    trigger OnAfterModify()
    begin
        recSalesSetup.GET;
        IF recSalesSetup."Customer Dimension" <> '' THEN BEGIN
            recDimensionValue.RESET;
            recDimensionValue.SETRANGE("Dimension Code", recSalesSetup."Customer Dimension");
            recDimensionValue.SETRANGE(Code, "No.");
            IF NOT recDimensionValue.FIND('-') THEN BEGIN
                recDimensionValue.INIT;
                recDimensionValue.VALIDATE("Dimension Code", recSalesSetup."Customer Dimension");
                recDimensionValue.VALIDATE(Code, "No.");
                recDimensionValue.VALIDATE(Name, CopyStr(rec.Name, 1, 50));
                recDimensionValue.INSERT(TRUE);
            END ELSE BEGIN
                recDimensionValue.VALIDATE(Name, CopyStr(rec.Name, 1, 50));
                recDimensionValue.MODIFY(TRUE);
            END;
            recDefaultDimension.RESET;
            recDefaultDimension.SETRANGE("Table ID", 18);
            recDefaultDimension.SETRANGE(recDefaultDimension."No.", "No.");
            recDefaultDimension.SETRANGE("Dimension Code", recSalesSetup."Customer Dimension");
            IF NOT recDefaultDimension.FIND('-') THEN BEGIN
                recDefaultDimension.INIT;
                recDefaultDimension.VALIDATE("Table ID", 18);
                recDefaultDimension."No." := "No.";
                recDefaultDimension.VALIDATE("Dimension Code", recSalesSetup."Customer Dimension");
                recDefaultDimension."Dimension Value Code" := "No.";
                recDefaultDimension."Value Posting" := recDefaultDimension."Value Posting"::"Same Code";
                recDefaultDimension.INSERT();
            END;
        END;
    end;

    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recDimensionValue: Record "Dimension Value";
        recDefaultDimension: Record "Default Dimension";
}