page 50197 "GST Reco Compare"
{
    ApplicationArea = all;
    PageType = List;
    layout
    {
        area(Content)
        {
            part(Purchasetransactions; Purchasetransactions)
            {
                Caption = 'Purchase Transactions';
                ApplicationArea = all;
            }
            part(GSTReco; GSTRDump)
            {
                Caption = 'GSTR Data';
                ApplicationArea = all;
            }
        }
    }
}