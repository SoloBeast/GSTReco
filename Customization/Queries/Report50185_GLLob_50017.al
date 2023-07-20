query 50017 "Report 50185 GL / LOB"
{
    elements
    {
        dataitem(G_L_Entry; "G/L Entry")
        {
            filter(Posting_Date; "Posting Date") { }
            column(G_L_Account_No_; "G/L Account No.") { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
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