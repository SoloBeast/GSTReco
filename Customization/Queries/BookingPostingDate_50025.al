query 50025 "Booking - Posting Date"
{
    elements
    {
        dataitem(Booking_Transactions; "Booking Transactions")
        {
            column(Booking_Date; "Booking Date") { }
            column(RecordCount)
            {
                Method = Count;
            }
        }
    }

    var

    trigger OnBeforeOpen()
    begin

    end;
}