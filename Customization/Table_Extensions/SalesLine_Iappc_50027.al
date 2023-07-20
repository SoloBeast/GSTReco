tableextension 50027 "Sales Line Ext." extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Narration"; Text[250])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                recStandardText: Record "Standard Text";
            begin
                if Page.RunModal(0, recStandardText) = Action::LookupOK then
                    Narration := recStandardText.Description;
            end;
        }
        field(70000; "Order Status"; Enum "Sales Document Status")
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header".Status where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Editable = false;
        }
        field(70010; "Customer Name"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
        }
    }

    var
}