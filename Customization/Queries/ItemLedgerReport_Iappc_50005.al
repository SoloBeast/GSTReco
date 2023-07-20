query 50005 "Item Ledger Report"
{
    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            filter(Posting_Date; "Posting Date")
            { }
            filter(Location_Code; "Location Code")
            { }
            filter(Global_Dimension_1_Code; "Global Dimension 1 Code")
            { }
            filter(Global_Dimension_2_Code; "Global Dimension 2 Code")
            { }
            column(Item_No_; "Item No.")
            { }
            column(Quantity; Quantity)
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