query 50011 "Booking - PG Collection"
{
    elements
    {
        dataitem(Booking_Transactions; "Booking Transactions")
        {
            filter(Booking_Date; "Booking Date") { }
            column(Type_of_Sales; "Type of Sales") { }
            column(ECO; ECO) { }
            column(Location_Code; "Location Code") { }
            column(Total_Fare; "Total Fare")
            {
                Method = Sum;
            }
            column(Total_Tax_on_Fare; "Total Tax on Fare")
            {
                Method = Sum;
            }
            column(Travel_Insurance; "Travel Insurance")
            {
                Method = Sum;
            }
            column(Service_Charge; "Service Charge")
            {
                Method = Sum;
            }
            column(Free_Cancellation_Fee; "Free Cancellation Fee")
            {
                Method = Sum;
            }
            column(Prime_Membership_Fee; "Prime Membership Fee")
            {
                Method = Sum;
            }
            column(Assured_Subscrption_Fee; "Assured Subscrption Fee")
            {
                Method = Sum;
            }
            column(Round_Off_Amount; "Round Off Amount")
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