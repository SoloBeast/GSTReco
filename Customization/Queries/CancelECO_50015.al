query 50015 "Cancel - ECO"
{
    elements
    {
        dataitem(Cancel_Transactions; "Cancel Transactions")
        {
            column(ECO; ECO)
            { }
            column(Location_Code; "Location Code")
            { }
            column(Total_Fare_Refund; "Total Fare Refund")
            {
                Method = Sum;
            }
            column(ECO_GST_Reversed_by_CGW; "ECO GST Reversed by CGW")
            {
                Method = Sum;
            }
            column(ECO_IGST_Amount_Rvd__Abhibus; "ECO IGST Amount Rvd. Abhibus")
            {
                Method = Sum;
            }
            column(ECO_CGST_Amount_Rvd__Abhibus; "ECO CGST Amount Rvd. Abhibus")
            {
                Method = Sum;
            }
            column(ECO_SGST_Amount_Rvd__Abhibus; "ECO SGST Amount Rvd. Abhibus")
            {
                Method = Sum;
            }
            column(Total_Tax_on_Fare; "Total Tax on Fare")
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