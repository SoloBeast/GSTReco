tableextension 50006 "G/L Account Ext." extends "G/L Account"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Group Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Sub Group Name"; Text[100])
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
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Opening Date Filter")));
        }
        field(70002; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70003; "Created At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70004; "Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                if Rec.Name <> '' then begin
                    recGLAccount.Reset();
                    recGLAccount.SetRange(Name, Rec.Name);
                    recGLAccount.SetFilter("No.", '<>%1', Rec."No.");
                    if recGLAccount.FindFirst() then
                        Error('The G/L Account alredy exist with the Name %1 having No. %2', Rec.Name, recGLAccount."No.");
                end;
            end;
        }
    }

    var
        recGLAccount: Record "G/L Account";
}