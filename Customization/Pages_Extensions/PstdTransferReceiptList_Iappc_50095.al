pageextension 50095 "Pstd.Trf. Receipt List Ext." extends "Posted Transfer Receipts"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Print")
        {
            action(PrintReceipt)
            {
                ApplicationArea = all;
                Caption = 'Print GRN';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    recTransferReceipt.Reset();
                    recTransferReceipt.SetRange("No.", Rec."No.");
                    recTransferReceipt.FindFirst();
                    Report.Run(50019, true, true, recTransferReceipt);
                end;
            }
        }

        modify("&Print")
        {
            Visible = false;
        }
    }

    var
        recTransferReceipt: Record "Transfer Receipt Header";
}