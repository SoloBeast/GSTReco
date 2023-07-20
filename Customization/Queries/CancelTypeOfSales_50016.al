query 50016 "Cancel - Type of Sales"
{
    elements
    {
        dataitem(Cancel_Transactions; "Cancel Transactions")
        {
            column(Type_of_Sales; "Type of Sales")
            { }
            column(Comm__Reversal__Base_Fare_; "Comm. Reversal (Base Fare)")
            {
                Method = Sum;
            }
            column(Comm__Earned_on_Cancellation; "Comm. Earned on Cancellation")
            {
                Method = Sum;
            }
            column(Net_Amount_Refunded_to_PG; "Net Amount Refunded to PG")
            {
                Method = Sum;
            }
            column(Abhicash_Non_Promo_Reversed; "Abhicash Non-Promo Reversed")
            {
                Method = Sum;
            }
            column(Instant_Discount_Reversal; "Instant Discount Reversal")
            {
                Method = Sum;
            }
            column(Abhicash_Promo_Reversed; "Abhicash Promo Reversed")
            {
                Method = Sum;
            }
            column(Edge_Discount_by_Operator; "Edge Discount by Operator")
            {
                Method = Sum;
            }
            column(Assured_Benefits; "Assured Benefits")
            {
                Method = Sum;
            }
            column(Free_Cancellation_Benefits; "Free Cancellation Benefits")
            {
                Method = Sum;
            }
            column(Prime_Membership_Benefits; "Prime Membership Benefits")
            {
                Method = Sum;
            }
            column(Abhibus_Cancellation_Charges; "Abhibus Cancellation Charges")
            {
                Method = Sum;
            }
            column(Round_Off_Income; "Round Off Income")
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