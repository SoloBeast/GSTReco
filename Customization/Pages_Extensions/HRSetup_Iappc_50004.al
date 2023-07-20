pageextension 50004 "HR Setup Ext." extends "Human Resources Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Base Unit of Measure")
        {
            field("Employee Dimension"; Rec."Employee Dimension")
            {
                ApplicationArea = all;
            }
            field("Expense Nos."; Rec."Expense Nos.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}