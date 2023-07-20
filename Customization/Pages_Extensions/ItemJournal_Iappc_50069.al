pageextension 50069 "Item Journal Ext." extends "Item Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Discount Amount")
        {
            Visible = false;
        }
        modify("Unit Cost")
        {
            Visible = false;
        }
        modify("Applies-to Entry")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("E&xplode BOM")
        {
            action(FileImport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    xmlItemJournalImport: XmlPort "Item Journal Import";
                begin
                    Clear(xmlItemJournalImport);
                    xmlItemJournalImport.SetTemplateBatch(Rec."Journal Template Name", Rec."Journal Batch Name");
                    xmlItemJournalImport.Run();
                    CurrPage.Update();
                end;
            }
        }
        modify("E&xplode BOM")
        {
            Visible = false;
        }
        modify("&Get Standard Journals")
        {
            Visible = false;
        }
        modify("Bin Contents")
        {
            Visible = false;
        }
        modify("&Recalculate Unit Amount")
        {
            Visible = false;
        }
        modify("F&unctions")
        {
            Visible = false;
        }
    }

    var
}