page 50197 "GST Reco Compare"
{
    ApplicationArea = all;
    PageType = Card;
    layout
    {
        area(Content)
        {
            field(cdGstNo; cdGstNo)
            {
                Caption = 'GST No.';
                ApplicationArea = all;
                TableRelation = "GST Registration Nos.";
            }

            group(ComparePart)
            {
                Caption = 'GST Reco';
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
    var
        cdGstNo: Code[15];
}