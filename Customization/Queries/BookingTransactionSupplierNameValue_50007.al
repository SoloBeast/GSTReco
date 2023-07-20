query 50007 "Booking - Supplier Name"
{
    elements
    {
        dataitem(Booking_Transactions; "Booking Transactions")
        {
            filter(Booking_Date; "Booking Date") { }
            column(Vendor_No_; "Vendor No.")
            { }
            column(Total_Fare; "Total Fare")
            {
                Method = Sum;
            }
            column(Comm__Earned__Base_Fare_; "Comm. Earned (Base Fare)")
            {
                Method = Sum;
            }
            column(Saas_Comm___CGW_; "Saas Comm. (CGW)")
            {
                Method = Sum;
            }
            column(Total_GST; "Total GST")
            {
                Method = Sum;
            }
            column(ECO_GST_by_CGW; "ECO GST by CGW")
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
            column(TDS_Amt___Base___Edge_offer_; "TDS Amt. (Base - Edge offer)")
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