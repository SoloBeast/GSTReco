tableextension 50003 "Vendor Ext." extends Vendor
{
    fields
    {
        // Add changes to table fields here
        modify("P.A.N. No.")
        {
            trigger OnAfterValidate()
            var
                recVendor: Record Vendor;
            begin
                // if (Rec."P.A.N. No." <> '') and ("Skip PAN No. Validation" = false) then begin
                //     recVendor.Reset();
                //     recVendor.SetRange("P.A.N. No.", Rec."P.A.N. No.");
                //     recVendor.SetFilter("No.", '<>%1', Rec."P.A.N. No.");
                //     if recVendor.FindFirst() then
                //         Error('Vendor with P.A.N. No. %1 already exist with code %2', recVendor."P.A.N. No.", recVendor."No.");
                // end;
            end;
        }
        field(50000; "Trade Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Bank IFSC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Beneficiary Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Term Date Basis"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Ixigo Vendor Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "206 AB"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Due Date Calc. Basis"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Posting Date","Document Date";
        }
        field(50008; "Beneficiary Code"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "RCM Applicable"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Yes","No";
        }
        field(50010; "Skip PAN No. Validation"; Boolean)
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
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Currency Code" = FIELD("Currency Filter"), "Posting Date" = FIELD("Opening Date Filter"),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70002; "Opening Balance (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Currency Code" = FIELD("Currency Filter"), "Posting Date" = FIELD("Opening Date Filter"),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70003; "Closing Balance"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("No."),
                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                        "Currency Code" = FIELD("Currency Filter"), "Posting Date" = FIELD(Upperlimit("Date Filter")),
                                        "Entry Type" = FILTER(<> Application)));
        }
        field(70004; "Closing Balance (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
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
        field(70008; "MSME"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70009; "MSME Reg. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70010; "MSME Type"; Option)
        {
            OptionMembers = " ","Small","Medium","Micro";
        }
        field(70011; "Legal Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(71000; "GST Return Filling Frequency"; Option)
        {
            OptionMembers = " ","Monthly","Quarterly";
        }
    }

    trigger OnAfterInsert()
    begin
        recPurchSetup.GET;
        IF recPurchSetup."Vendor Dimension" <> '' THEN BEGIN
            recDimensionValue.RESET;
            recDimensionValue.SETRANGE("Dimension Code", recPurchSetup."Vendor Dimension");
            recDimensionValue.SETRANGE(Code, "No.");
            IF NOT recDimensionValue.FIND('-') THEN BEGIN
                recDimensionValue.INIT;
                recDimensionValue.VALIDATE("Dimension Code", recPurchSetup."Vendor Dimension");
                recDimensionValue.VALIDATE(Code, "No.");
                recDimensionValue.INSERT(TRUE);
            END;
            recDefaultDimension.RESET;
            recDefaultDimension.SETRANGE("Table ID", 23);
            recDefaultDimension.SETRANGE(recDefaultDimension."No.", "No.");
            recDefaultDimension.SETRANGE("Dimension Code", recPurchSetup."Vendor Dimension");
            IF NOT recDefaultDimension.FIND('-') THEN BEGIN
                recDefaultDimension.INIT;
                recDefaultDimension.VALIDATE("Table ID", 23);
                recDefaultDimension."No." := "No.";
                recDefaultDimension.VALIDATE("Dimension Code", recPurchSetup."Vendor Dimension");
                recDefaultDimension."Dimension Value Code" := "No.";
                recDefaultDimension."Value Posting" := recDefaultDimension."Value Posting"::"Same Code";
                recDefaultDimension.INSERT();
            END;
        END;
    end;

    trigger OnAfterModify()
    begin
        recPurchSetup.GET;
        IF recPurchSetup."Vendor Dimension" <> '' THEN BEGIN
            recDimensionValue.RESET;
            recDimensionValue.SETRANGE("Dimension Code", recPurchSetup."Vendor Dimension");
            recDimensionValue.SETRANGE(Code, "No.");
            IF NOT recDimensionValue.FIND('-') THEN BEGIN
                recDimensionValue.INIT;
                recDimensionValue.VALIDATE("Dimension Code", recPurchSetup."Vendor Dimension");
                recDimensionValue.VALIDATE(Code, "No.");
                recDimensionValue.VALIDATE(Name, CopyStr(rec.Name, 1, 50));
                recDimensionValue.INSERT(TRUE);
            END ELSE BEGIN
                recDimensionValue.VALIDATE(Name, CopyStr(rec.Name, 1, 50));
                recDimensionValue.MODIFY(TRUE);
            END;
            recDefaultDimension.RESET;
            recDefaultDimension.SETRANGE("Table ID", 23);
            recDefaultDimension.SETRANGE(recDefaultDimension."No.", "No.");
            recDefaultDimension.SETRANGE("Dimension Code", recPurchSetup."Vendor Dimension");
            IF NOT recDefaultDimension.FIND('-') THEN BEGIN
                recDefaultDimension.INIT;
                recDefaultDimension.VALIDATE("Table ID", 23);
                recDefaultDimension."No." := "No.";
                recDefaultDimension.VALIDATE("Dimension Code", recPurchSetup."Vendor Dimension");
                recDefaultDimension."Dimension Value Code" := "No.";
                recDefaultDimension."Value Posting" := recDefaultDimension."Value Posting"::"Same Code";
                recDefaultDimension.INSERT(TRUE);
            END;
        END;
    end;

    var
        recPurchSetup: Record "Purchases & Payables Setup";
        recDimensionValue: Record "Dimension Value";
        recDefaultDimension: Record "Default Dimension";
}