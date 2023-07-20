pageextension 50115 "Recurring General Journal Ext." extends "Recurring General Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document Type")
        {
            field("Transaction Nature"; Rec."Transaction Nature")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Allocations)
        {
            action(VoucherUploader)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Voucher Import';
                Image = Import;
                // Promoted = true;
                // PromotedCategory = Process;

                trigger OnAction()
                var
                    xmlVoucherImport: XmlPort "Recurring Journal Import";
                begin
                    Clear(xmlVoucherImport);
                    xmlVoucherImport.SetTemplateBatch(Rec."Journal Template Name", Rec."Journal Batch Name");
                    xmlVoucherImport.Run();
                    CurrPage.Update();
                end;
            }
        }
    }

    var
}