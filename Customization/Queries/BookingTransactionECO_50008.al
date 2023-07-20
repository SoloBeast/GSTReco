query 50008 "Booking - ECO"
{
    elements
    {
        dataitem(Booking_Transactions; "Booking Transactions")
        {
            filter(Booking_Date; "Booking Date") { }
            column(ECO; ECO)
            { }
            column(Location_Code; "Location Code")
            { }
            column(Total_Fare; "Total Fare")
            {
                Method = Sum;
            }
            column(ECO_GST_by_CGW; "ECO GST by CGW")
            {
                Method = Sum;
            }
            column(ECO_IGST___5___Amt__by_Abhibus; "ECO IGST (@5%) Amt. by Abhibus")
            {
                Method = Sum;
            }
            column(ECO_CGST___2_5___Amt__Abhibus_; "ECO CGST (@2.5%) Amt.(Abhibus)")
            {
                Method = Sum;
            }
            column(ECO_SGST___2_5___Amt__Abhibus_; "ECO SGST (@2.5%) Amt.(Abhibus)")
            {
                Method = Sum;
            }
            column(ECO_GST_Amount_by_Aggregator; "ECO GST Amount by Aggregator")
            {
                Method = Sum;
            }
            column(ECO_GST_Amt__Paid__Irctc_; "ECO GST Amt. Paid (Irctc)")
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