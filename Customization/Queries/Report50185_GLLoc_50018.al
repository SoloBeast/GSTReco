query 50018 "Report 50185 GL / LOC"
{
    elements
    {
        dataitem(G_L_Entry; "G/L Entry")
        {
            filter(Posting_Date; "Posting Date") { }
            column(G_L_Account_No_; "G/L Account No.") { }
            column(LOC; LOC) { }
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