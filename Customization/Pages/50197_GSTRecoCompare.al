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
                Image = Reconcile;

                trigger OnAction()
                var
                    cuGStReconcile: Codeunit "GST Reco";
                begin
                    Clear(cuGStReconcile);
                    if cdGstNo <> '' then
                        cuGStReconcile.setParameter(cdGstNo);
                    cuGStReconcile.Run();
                end;
            }
            action(ErrorLog)
            {
                Caption = 'Error Log';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                Image = Log;
                RunObject = page "GST Reco Error Log";
            }
        }
    }
    var
        cdGstNo: Code[15];
}