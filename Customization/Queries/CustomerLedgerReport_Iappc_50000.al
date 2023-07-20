query 50000 "Customer Ledger Report"
{
    elements
    {
        dataitem(Cust__Ledger_Entry; "Cust. Ledger Entry")
        {
            filter(Posting_Date; "Posting Date")
            { }
            filter(Global_Dimension_1_Code; "Global Dimension 1 Code")
            { }
            filter(Global_Dimension_2_Code; "Global Dimension 2 Code")
            { }
            column(Customer_No_; "Customer No.")
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