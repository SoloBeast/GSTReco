query 50009 "Booking - Type of Sales"
{
    elements
    {
        dataitem(Booking_Transactions; "Booking Transactions")
        {
            filter(Booking_Date; "Booking Date") { }
            column(Type_of_Sales; "Type of Sales")
            { }
            column(Comm__Earned__Base_Fare_; "Comm. Earned (Base Fare)")
            {
                Method = Sum;
            }
            column(Saas_Comm___CGW_; "Saas Comm. (CGW)")
            {
                Method = Sum;
            }
            column(Net_PG__Agent_Amt__Collected; "Net PG/ Agent Amt. Collected")
            {
                Method = Sum;
            }
            column(Abhicash_Used_Non_Promo; "Abhicash Used Non Promo")
            {
                Method = Sum;
            }
            column(Instant_Discount; "Instant Discount")
            {
                Method = Sum;
            }
            column(Abhicash_Used_Promo; "Abhicash Used Promo")
            {
                Method = Sum;
            }
            column(Edge_Discount_by_Operator; "Edge Discount by Operator")
            {
                Method = Sum;
            }
            column(Insurance_Benfit__Prime_Users_; "Insurance Benfit (Prime Users)")
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