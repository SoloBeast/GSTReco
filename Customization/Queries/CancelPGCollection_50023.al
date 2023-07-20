query 50023 "Cancel - PG Collection"
{
    elements
    {
        dataitem(Cancel_Transactions; "Cancel Transactions")
        {
            column(Type_of_Sales; "Type of Sales") { }
            column(ECO; ECO) { }
            column(Location_Code; "Location Code") { }
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