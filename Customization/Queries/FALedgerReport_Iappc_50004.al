query 50004 "FA Ledger Report"
{
    elements
    {
        dataitem(FA_Ledger_Entry; "FA Ledger Entry")
        {
            filter(Posting_Date; "Posting Date")
            { }
            filter(Global_Dimension_1_Code; "Global Dimension 1 Code")
            { }
            filter(Global_Dimension_2_Code; "Global Dimension 2 Code")
            { }
            column(FA_No_; "FA No.")
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