tableextension 50030 "Purchase Cue Ext." extends "Purchase Cue"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "Open Indents"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Indent Header" where(Status = const(Open)));
        }
        field(70001; "Indents to Approve"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Indent Header" where(Status = const("Pending Approval")));
        }
        field(70002; "Approved Indents"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Indent Header" where(Status = const(Approved)));
        }
        field(70003; "Indents to Order"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Indent Line" where(Status = const(Approved), "Remaining Quantity" = filter(<> 0)));
        }
        field(70004; "Open Orders"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Purchase Header" where("Document Type" = const(Order), Status = const(Open)));
        }
        field(70005; "Orders to Approve"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Purchase Header" where("Document Type" = const(Order), Status = const("Pending Approval")));
        }
        field(70006; "Approved Orders"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Purchase Header" where("Document Type" = const(Order), Status = const(Released)));
        }
        field(70007; "Rcpt. not Invoiced"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Purchase Line" where("Qty. Rcd. Not Invoiced" = filter(<> 0)));
        }
    }

    var
}