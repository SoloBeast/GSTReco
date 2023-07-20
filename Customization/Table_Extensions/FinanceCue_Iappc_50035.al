tableextension 50035 "Finance Cue Ext." extends "Finance Cue"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "Purchase Invoice to Book"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Count("Purchase Line" WHERE("Qty. Rcd. Not Invoiced" = FILTER(<> 0)));
        }
        field(70001; "Sales Invoice to Book"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Count("Sales Line" WHERE("Qty. Shipped Not Invoiced" = FILTER(<> 0)));
        }
        field(70002; "Purchase Documents Overdue"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Overdue Purchase Documents';
            Editable = false;
            CalcFormula = Count("Vendor Ledger Entry" WHERE("Document Type" = FILTER(Invoice | "Credit Memo"),
                                                             "Due Date" = FIELD("Overdue Date Filter"),
                                                             Open = CONST(true)));
        }
    }

    var
}