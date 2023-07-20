tableextension 50010 "Employee Ext." extends Employee
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Department"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Project Assigned"; Text[30])
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
            CalcFormula = Sum("Detailed Employee Ledger Entry".Amount WHERE("Employee No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD("Opening Date Filter"),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70002; "Opening Balance (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Employee Ledger Entry"."Amount (LCY)" WHERE("Employee No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD("Opening Date Filter"),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70003; "Debit Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Employee Ledger Entry"."Debit Amount" WHERE("Employee No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD("Date Filter"),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70004; "Debit Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Employee Ledger Entry"."Debit Amount (LCY)" WHERE("Employee No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD("Date Filter"),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70005; "Credit Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Employee Ledger Entry"."Credit Amount" WHERE("Employee No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD("Date Filter"),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70006; "Credit Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Employee Ledger Entry"."Credit Amount (LCY)" WHERE("Employee No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD("Date Filter"),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70007; "Closing Balance"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Employee Ledger Entry".Amount WHERE("Employee No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD(Upperlimit("Date Filter")),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70008; "Closing Balance (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Employee Ledger Entry"."Amount (LCY)" WHERE("Employee No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD(upperlimit("Date Filter")),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70009; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70010; "Created At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70011; "Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    trigger OnAfterInsert()
    begin
        recHRSetup.GET;
        IF recHRSetup."Employee Dimension" <> '' THEN BEGIN
            recDimensionValue.RESET;
            recDimensionValue.SETRANGE("Dimension Code", recHRSetup."Employee Dimension");
            recDimensionValue.SETRANGE(Code, "No.");
            IF NOT recDimensionValue.FIND('-') THEN BEGIN
                recDimensionValue.INIT;
                recDimensionValue.VALIDATE("Dimension Code", recHRSetup."Employee Dimension");
                recDimensionValue.VALIDATE(Code, "No.");
                recDimensionValue.INSERT(TRUE);
            END;
            recDefaultDimension.RESET;
            recDefaultDimension.SETRANGE("Table ID", Database::Employee);
            recDefaultDimension.SETRANGE(recDefaultDimension."No.", "No.");
            recDefaultDimension.SETRANGE("Dimension Code", recHRSetup."Employee Dimension");
            IF NOT recDefaultDimension.FIND('-') THEN BEGIN
                recDefaultDimension.INIT;
                recDefaultDimension.VALIDATE("Table ID", Database::Employee);
                recDefaultDimension."No." := "No.";
                recDefaultDimension.VALIDATE("Dimension Code", recHRSetup."Employee Dimension");
                recDefaultDimension."Dimension Value Code" := "No.";
                recDefaultDimension."Value Posting" := recDefaultDimension."Value Posting"::"Same Code";
                recDefaultDimension.INSERT();
            END;
        END;
    end;

    trigger OnAfterModify()
    begin
        recHRSetup.GET;
        IF recHRSetup."Employee Dimension" <> '' THEN BEGIN
            recDimensionValue.RESET;
            recDimensionValue.SETRANGE("Dimension Code", recHRSetup."Employee Dimension");
            recDimensionValue.SETRANGE(Code, "No.");
            IF NOT recDimensionValue.FIND('-') THEN BEGIN
                recDimensionValue.INIT;
                recDimensionValue.VALIDATE("Dimension Code", recHRSetup."Employee Dimension");
                recDimensionValue.VALIDATE(Code, "No.");
                recDimensionValue.VALIDATE(Name, CopyStr(rec.FullName(), 1, 50));
                recDimensionValue.INSERT(TRUE);
            END ELSE BEGIN
                recDimensionValue.VALIDATE(Name, CopyStr(rec.FullName(), 1, 50));
                recDimensionValue.MODIFY(TRUE);
            END;
            recDefaultDimension.RESET;
            recDefaultDimension.SETRANGE("Table ID", Database::Employee);
            recDefaultDimension.SETRANGE(recDefaultDimension."No.", "No.");
            recDefaultDimension.SETRANGE("Dimension Code", recHRSetup."Employee Dimension");
            IF NOT recDefaultDimension.FIND('-') THEN BEGIN
                recDefaultDimension.INIT;
                recDefaultDimension.VALIDATE("Table ID", Database::Employee);
                recDefaultDimension."No." := "No.";
                recDefaultDimension.VALIDATE("Dimension Code", recHRSetup."Employee Dimension");
                recDefaultDimension."Dimension Value Code" := "No.";
                recDefaultDimension."Value Posting" := recDefaultDimension."Value Posting"::"Same Code";
                recDefaultDimension.INSERT();
            END;
        END;
    end;

    var
        recHRSetup: Record "Human Resources Setup";
        recDimensionValue: Record "Dimension Value";
        recDefaultDimension: Record "Default Dimension";
}