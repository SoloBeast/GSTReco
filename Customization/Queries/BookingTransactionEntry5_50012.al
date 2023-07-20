query 50012 "Booking - Entry 5 Debit"
{
    elements
    {
        dataitem(Booking_Transactions; "Booking Transactions")
        {
            filter(Booking_Date; "Booking Date") { }
            column(Type_of_Sales; "Type of Sales")
            { }
            column(Seller_Name___Order_ID; "Seller Name / Order ID")
            { }
            column(Total_Fare; "Total Fare")
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