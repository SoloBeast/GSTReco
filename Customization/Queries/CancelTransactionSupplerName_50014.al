query 50014 "Cancel - Supplier Name"
{
    elements
    {
        dataitem(Cancel_Transactions; "Cancel Transactions")
        {
            column(Supplier_Name___Technical; "Supplier Name - Technical")
            { }
            column(Total_Fare_Refund; "Total Fare Refund")
            {
                Method = Sum;
            }
            column(Comm__Reversal__Base_Fare_; "Comm. Reversal (Base Fare)")
            {
                Method = Sum;
            }
            column(Comm__Earned_on_Cancellation; "Comm. Earned on Cancellation")
            {
                Method = Sum;
            }
            column(Total_GST; "Total GST")
            {
                Method = Sum;
            }
            column(Total_GST_On_Earned_Comm_; "Total GST On Earned Comm.")
            {
                Method = Sum;
            }
            column(ECO_GST_Reversed_by_CGW; "ECO GST Reversed by CGW")
            {
                Method = Sum;
            }
            column(Total_Tax_on_Fare; "Total Tax on Fare")
            {
                Method = Sum;
            }
            column(Edge_Discount_by_Operator; "Edge Discount by Operator")
            {
                Method = Sum;
            }
            column(TDS_U_S_194O; "TDS U/S 194O")
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