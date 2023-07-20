tableextension 50007 "Fixed Asset Ext." extends "Fixed Asset"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Tagging No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Manufacturer"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "FA Insured"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Yes","No";
        }
        field(70000; "Opening Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(70001; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(70002; "Depreciation Book Filter"; code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Depreciation Book";
        }
        field(70003; "Global Dimension 1 Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(70004; "Global Dimension 2 Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(70005; "Opening Balance"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("FA Ledger Entry"."Amount (LCY)" WHERE("FA No." = FIELD("No."),
                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD("Opening Date Filter"),
                                        "Depreciation Book Code" = field("Depreciation Book Filter"),
                                        "FA Posting Type" = filter(<> "Proceeds on Disposal" & <> "Gain/Loss" & <> "Salvage Value")));
        }
        field(70006; "Debit Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("FA Ledger Entry"."Amount (LCY)" WHERE("FA No." = FIELD("No."),
                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD("Date Filter"),
                                        "Depreciation Book Code" = field("Depreciation Book Filter"),
                                        "FA Posting Type" = filter(<> "Proceeds on Disposal" & <> "Gain/Loss" & <> "Salvage Value"),
                                        "Amount (LCY)" = filter(> 0)));
        }
        field(70007; "Credit Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - Sum("FA Ledger Entry"."Amount (LCY)" WHERE("FA No." = FIELD("No."),
                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                        "Posting Date" = FIELD("Date Filter"),
                                        "Depreciation Book Code" = field("Depreciation Book Filter"),
                                        "FA Posting Type" = filter(<> "Proceeds on Disposal" & <> "Gain/Loss" & <> "Salvage Value"),
                                        "Amount (LCY)" = filter(< 0)));
        }
        field(70008; "Closing Balance"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("FA Ledger Entry"."Amount (LCY)" WHERE("FA No." = FIELD("No."),
                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                        "Depreciation Book Code" = field("Depreciation Book Filter"),
                                        "FA Posting Type" = filter(<> "Proceeds on Disposal" & <> "Gain/Loss" & <> "Salvage Value"),
                                        "Posting Date" = FIELD(Upperlimit("Date Filter"))));
        }
        field(70009; "Acquisition Cost"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("FA Ledger Entry"."Amount (LCY)" WHERE("FA No." = FIELD("No."),
                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                        "FA Posting Type" = const("Acquisition Cost"),
                                        "Posting Date" = FIELD("Opening Date Filter")));
        }
        field(70010; "Depreciation"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("FA Ledger Entry"."Amount (LCY)" WHERE("FA No." = FIELD("No."),
                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                        "FA Posting Type" = const(Depreciation),
                                        "Posting Date" = FIELD("Opening Date Filter")));
        }
        field(70011; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70012; "Created At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70013; "Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    trigger OnAfterInsert()
    begin
        recFASetup.GET;
        if recFASetup."FA Dimension" <> '' then begin
            recDimensionValue.RESET;
            recDimensionValue.SETRANGE("Dimension Code", recFASetup."FA Dimension");
            recDimensionValue.SETRANGE(Code, "No.");
            IF NOT recDimensionValue.FIND('-') THEN BEGIN
                recDimensionValue.INIT;
                recDimensionValue.VALIDATE("Dimension Code", recFASetup."FA Dimension");
                recDimensionValue.VALIDATE(Code, "No.");
                recDimensionValue.INSERT(TRUE);
            END;
            recDefaultDimension.RESET;
            recDefaultDimension.SETRANGE("Table ID", 5600);
            recDefaultDimension.SETRANGE(recDefaultDimension."No.", "No.");
            recDefaultDimension.SETRANGE("Dimension Code", recFASetup."FA Dimension");
            IF NOT recDefaultDimension.FIND('-') THEN BEGIN
                recDefaultDimension.INIT;
                recDefaultDimension.VALIDATE("Table ID", 5600);
                recDefaultDimension."No." := "No.";
                recDefaultDimension.VALIDATE("Dimension Code", recFASetup."FA Dimension");
                recDefaultDimension."Dimension Value Code" := "No.";
                recDefaultDimension."Value Posting" := recDefaultDimension."Value Posting"::"Same Code";
                recDefaultDimension.INSERT();
            END;
        end;
    end;

    trigger OnAfterModify()
    begin
        recFASetup.Get();
        if recFASetup."FA Dimension" <> '' then begin
            recDimensionValue.RESET;
            recDimensionValue.SETRANGE("Dimension Code", recFASetup."FA Dimension");
            recDimensionValue.SETRANGE(Code, "No.");
            IF NOT recDimensionValue.FIND('-') THEN BEGIN
                recDimensionValue.INIT;
                recDimensionValue.VALIDATE("Dimension Code", recFASetup."FA Dimension");
                recDimensionValue.VALIDATE(Code, "No.");
                recDimensionValue.INSERT(TRUE);
            END ELSE BEGIN
                recDimensionValue.VALIDATE(recDimensionValue.Name, Description);
                recDimensionValue.MODIFY(TRUE);
            END;
            recDefaultDimension.RESET;
            recDefaultDimension.SETRANGE("Table ID", 5600);
            recDefaultDimension.SETRANGE(recDefaultDimension."No.", "No.");
            recDefaultDimension.SETRANGE("Dimension Code", recFASetup."FA Dimension");
            IF NOT recDefaultDimension.FIND('-') THEN BEGIN
                recDefaultDimension.INIT;
                recDefaultDimension.VALIDATE("Table ID", 5600);
                recDefaultDimension."No." := "No.";
                recDefaultDimension.VALIDATE("Dimension Code", recFASetup."FA Dimension");
                recDefaultDimension."Dimension Value Code" := "No.";
                recDefaultDimension."Value Posting" := recDefaultDimension."Value Posting"::"Same Code";
                recDefaultDimension.INSERT();
            END;
        end;
    end;

    var
        recFASetup: Record "FA Setup";
        recDimensionValue: Record "Dimension Value";
        recDefaultDimension: Record "Default Dimension";
}