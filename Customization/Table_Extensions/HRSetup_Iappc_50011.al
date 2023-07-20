tableextension 50011 "HR Setup Ext." extends "Human Resources Setup"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "Employee Dimension"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
        }
        field(70001; "Expense Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    var
}