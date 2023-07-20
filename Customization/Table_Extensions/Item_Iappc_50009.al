tableextension 50009 "Item Ext." extends Item
{
    fields
    {
        // Add changes to table fields here
        field(70000; "Opening Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(70001; "Opening Quantity"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                            "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                            "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                            "Posting Date" = FIELD("Opening Date Filter"),
                                            "Location Code" = FIELD("Location Filter")));
        }
        field(70002; "Inward Quantity"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                            "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                            "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                            "Posting Date" = FIELD("Date Filter"),
                                            "Location Code" = FIELD("Location Filter"),
                                            Positive = const(true)));
        }
        field(70003; "Outward Quantity"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                            "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                            "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                            "Posting Date" = FIELD("Date Filter"),
                                            "Location Code" = FIELD("Location Filter"),
                                            Positive = const(false)));
        }
        field(70004; "Closing Quantity"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                            "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                            "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                            "Posting Date" = FIELD(Upperlimit("Date Filter")),
                                            "Location Code" = FIELD("Location Filter")));
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

    var
}