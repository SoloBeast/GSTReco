tableextension 50004 "Bank Account Ext." extends "Bank Account"
{
    fields
    {
        // Add changes to table fields here

        field(50001; "MICR Code"; Text[10])
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
            CalcFormula = Sum("Bank Account Ledger Entry".Amount WHERE("Bank Account No." = FIELD("No."),
                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD("Opening Date Filter")));
        }
        field(70002; "Opening Balance (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Bank Account Ledger Entry"."Amount (LCY)" WHERE("Bank Account No." = FIELD("No."),
                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD("Opening Date Filter")));
        }
        field(70003; "Closing Balance"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Bank Account Ledger Entry".Amount WHERE("Bank Account No." = FIELD("No."),
                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD(Upperlimit("Date Filter"))));
        }
        field(70004; "Closing Balance (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Bank Account Ledger Entry"."Amount (LCY)" WHERE("Bank Account No." = FIELD("No."),
                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD(upperlimit("Date Filter"))));
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
    }
    trigger OnAfterInsert()
    begin
        recGLSetup.GET;
        if recGLSetup."Bank Dimension" <> '' then begin
            recDimensionValue.RESET;
            recDimensionValue.SETRANGE("Dimension Code", recGLSetup."Bank Dimension");
            recDimensionValue.SETRANGE(Code, "No.");
            IF NOT recDimensionValue.FIND('-') THEN BEGIN
                recDimensionValue.INIT;
                recDimensionValue.VALIDATE("Dimension Code", recGLSetup."Bank Dimension");
                recDimensionValue.VALIDATE(Code, "No.");
                recDimensionValue.INSERT(TRUE);
            END;

            recDefaultDimension.RESET;
            recDefaultDimension.SETRANGE("Table ID", 270);
            recDefaultDimension.SETRANGE(recDefaultDimension."No.", "No.");
            recDefaultDimension.SETRANGE("Dimension Code", recGLSetup."Bank Dimension");
            IF NOT recDefaultDimension.FIND('-') THEN BEGIN
                recDefaultDimension.INIT;
                recDefaultDimension.VALIDATE("Table ID", 270);
                recDefaultDimension."No." := "No.";
                recDefaultDimension.VALIDATE("Dimension Code", recGLSetup."Bank Dimension");
                recDefaultDimension."Dimension Value Code" := "No.";
                recDefaultDimension."Value Posting" := recDefaultDimension."Value Posting"::"Same Code";
                recDefaultDimension.INSERT();
            END;
        end;
    end;

    trigger OnAfterModify()
    begin
        recGLSetup.GET;
        if recGLSetup."Bank Dimension" <> '' then begin
            recDimensionValue.RESET;
            recDimensionValue.SETRANGE("Dimension Code", recGLSetup."Bank Dimension");
            recDimensionValue.SETRANGE(Code, "No.");
            IF NOT recDimensionValue.FIND('-') THEN BEGIN
                recDimensionValue.INIT;
                recDimensionValue.VALIDATE("Dimension Code", recGLSetup."Bank Dimension");
                recDimensionValue.VALIDATE(Code, "No.");
                recDimensionValue.VALIDATE(Name, Rec.Name);
                recDimensionValue.INSERT(TRUE);
            END ELSE BEGIN
                recDimensionValue.VALIDATE(recDimensionValue.Name, Rec.Name);
                recDimensionValue.MODIFY(TRUE);
            END;

            recDefaultDimension.RESET;
            recDefaultDimension.SETRANGE("Table ID", 270);
            recDefaultDimension.SETRANGE(recDefaultDimension."No.", "No.");
            recDefaultDimension.SETRANGE("Dimension Code", recGLSetup."Bank Dimension");
            IF NOT recDefaultDimension.FIND('-') THEN BEGIN
                recDefaultDimension.INIT;
                recDefaultDimension.VALIDATE("Table ID", 270);
                recDefaultDimension."No." := "No.";
                recDefaultDimension.VALIDATE("Dimension Code", recGLSetup."Bank Dimension");
                recDefaultDimension."Dimension Value Code" := "No.";
                recDefaultDimension."Value Posting" := recDefaultDimension."Value Posting"::"Same Code";
                recDefaultDimension.INSERT();
            END;
        end;
    end;

    var
        recGLSetup: Record "General Ledger Setup";
        recDimensionValue: Record "Dimension Value";
        recDefaultDimension: Record "Default Dimension";
}