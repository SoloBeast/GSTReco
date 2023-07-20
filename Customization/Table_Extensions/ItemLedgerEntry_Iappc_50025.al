tableextension 50025 "Item Ledger Entry Ext." extends "Item Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "Inventory Posting Group"; Code[20])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item."Inventory Posting Group" where("No." = field("Item No.")));
        }
        field(70001; "Rejected Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Rec."Rejected Quantity" > Rec.Quantity then
                    Error('Only %1 quantity can be rejected', Rec.Quantity);
                Rec."Approved Quantity" := Rec.Quantity - Rec."Rejected Quantity";
            end;
        }
        field(70002; "Approved Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70003; "QC Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70004; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(70005; "App. Remaining Qty."; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Item Application Entry".Quantity where("Inbound Item Entry No." = field("Entry No."), "Posting Date" = field("Date Filter")));
        }
    }

    var
}