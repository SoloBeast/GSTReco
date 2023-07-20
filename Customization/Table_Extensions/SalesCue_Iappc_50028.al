tableextension 50028 "Sales Cue Ext." extends "Sales Cue"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "Open Orders"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Sales Header" where("Document Type" = const(Order), Status = const(Open)));
        }
        field(70001; "Orders to Approve"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Sales Header" where("Document Type" = const(Order), Status = const("Pending Approval")));
        }
        field(70002; "Approved Orders"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Sales Header" where("Document Type" = const(Order), Status = const(Released)));
        }
    }

    var
}