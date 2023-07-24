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
    actions
    {
        area(Processing)
        {
            action(CheckData)
            {
                Caption = 'Reconcile Data';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = codeunit "GST Reco";
            }
        }
    }
}