query 50002 "Bank Ledger Report"
{
    elements
    {
        dataitem(Bank_Account_Ledger_Entry; "Bank Account Ledger Entry")
        {
            filter(Posting_Date; "Posting Date")
            { }
            filter(Global_Dimension_1_Code; "Global Dimension 1 Code")
            { }
            filter(Global_Dimension_2_Code; "Global Dimension 2 Code")
            { }
            column(Bank_Account_No_; "Bank Account No.")
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