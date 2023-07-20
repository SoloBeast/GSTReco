query 50024 "Cancel - Entry 5 Debit"
{
    elements
    {
        dataitem(Cancel_Transactions; "Cancel Transactions")
        {
            column(Type_of_Sales; "Type of Sales")
            { }
            column(Seller_Name___Order_ID; "Seller Name / Order ID")
            { }
            column(Total_Fare_Refund; "Total Fare Refund")
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