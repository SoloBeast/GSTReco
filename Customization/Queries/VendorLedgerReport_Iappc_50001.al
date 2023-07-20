query 50001 "Vendor Ledger Report"
{
    elements
    {
        dataitem(Vendor_Ledger_Entry; "Vendor Ledger Entry")
        {
            filter(Posting_Date; "Posting Date")
            { }
            filter(Global_Dimension_1_Code; "Global Dimension 1 Code")
            { }
            filter(Global_Dimension_2_Code; "Global Dimension 2 Code")
            { }
            column(Vendor_No_; "Vendor No.")
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