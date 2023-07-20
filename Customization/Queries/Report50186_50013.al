query 50013 "Report 50186"
{

    elements
    {
        dataitem(G_L_Entry; "G/L Entry")
        {
            column(Posting_Date; "Posting Date") { }
            column(G_L_Account_No_; "G/L Account No.") { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(LOC; LOC) { }
            column(Amount; Amount)
            {
                Method = Sum;
            }

            /*
            dataitem(Dimension_Set_Entry; "Dimension Set Entry")
            {
                DataItemLink = "Dimension Set ID" = G_L_Entry."Dimension Set ID";
                DataItemTableFilter = "Dimension Code" = const('DEPT');

                column(Dimension_Value_Code; "Dimension Value Code") { }
            }
            */
        }
    }

    var

    trigger OnBeforeOpen()
    begin

    end;
}