query 50003 "GL Ledger Report"
{
    elements
    {
        dataitem(G_L_Entry; "G/L Entry")
        {
            filter(Posting_Date; "Posting Date")
            { }
            filter(Global_Dimension_1_Code; "Global Dimension 1 Code")
            { }
            filter(Global_Dimension_2_Code; "Global Dimension 2 Code")
            { }
            column(G_L_Account_No_; "G/L Account No.")
            { }
            column(Amount; Amount)
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