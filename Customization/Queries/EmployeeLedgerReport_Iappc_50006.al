query 50006 "Employee Ledger Report"
{
    elements
    {
        dataitem(Employee_Ledger_Entry; "Employee Ledger Entry")
        {
            filter(Posting_Date; "Posting Date")
            { }
            filter(Global_Dimension_1_Code; "Global Dimension 1 Code")
            { }
            filter(Global_Dimension_2_Code; "Global Dimension 2 Code")
            { }
            column(Employee_No_; "Employee No.")
            { }
            column(Amount__LCY_; "Amount (LCY)")
            {
                Method = Sum;
            }
        }
    }

    var

    trigger OnBeforeOpen()
    begin

    end;
}