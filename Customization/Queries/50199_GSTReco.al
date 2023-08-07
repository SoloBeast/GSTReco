query 50199 "GST Reco"
{

    elements
    {
        dataitem(GSTRDump; GSTRDump)
        {
            column(Entry_No_; "Entry No.") { }
            column(GSTIN_Supplier; "GSTIN Supplier") { }
            column(Invoice_No; "Invoice No") { }
            column(Invocie_Date; "Invocie Date") { }
            column(Rate___; "Rate(%)") { }
            column(Taxable_Value; "Taxable Value")
            {
                Method = Sum;
            }
            column(Integrated_Tax; "Integrated Tax")
            {
                Method = Sum;
            }
            column(Central_Tax; "Central Tax")
            {
                Method = Sum;
            }
            column(State_UT_Tax; "State/UT Tax")
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