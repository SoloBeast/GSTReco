pageextension 50038 "Purch. Cr.Memo List Ext." extends "Purchase Credit Memos"
{
    layout
    {
        // Add changes to page layout here
        addafter("Buy-from Vendor Name")
        {
            field("Buy-from Address"; Rec."Buy-from Address")
            {
                ApplicationArea = all;
            }
            field("Buy-from Address 2"; Rec."Buy-from Address 2")
            {
                ApplicationArea = all;
            }
            field("Buy-from City"; Rec."Buy-from City")
            {
                ApplicationArea = all;
            }
            field("Vendor GST Reg. No."; Rec."Vendor GST Reg. No.")
            {
                ApplicationArea = all;
            }
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Dimensions)
        {
            action(PurchaseDocImport)
            {
                Caption = 'Import Documents';
                Image = Import;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = New;

                trigger OnAction()
                var
                    xmlPurchaseDocImport: XmlPort "Purchase Document Import";
                begin
                    Clear(xmlPurchaseDocImport);
                    xmlPurchaseDocImport.SetDocumentType(Rec."Document Type"::"Credit Memo");
                    xmlPurchaseDocImport.Run();
                    CurrPage.Update();
                end;
            }
            action(PrintSummary)
            {
                Caption = 'Summary Report';
                Image = Report;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Report;
                PromotedOnly = true;

                trigger OnAction()
                var
                    recPurchaseHeader: Record "Purchase Header";
                begin
                    recPurchaseHeader.Reset();
                    recPurchaseHeader.CopyFilters(Rec);
                    Report.Run(Report::"Purchase Document Summary", true, true, recPurchaseHeader);
                end;
            }
            action(DeleteAll)
            {
                Caption = 'Delete All';
                Image = Delete;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Category5;

                trigger OnAction()
                var
                    recPurchHeader: Record "Purchase Header";
                begin
                    recPurchHeader.Reset();
                    recPurchHeader.CopyFilters(Rec);
                    if recPurchHeader.FindSet() then
                        Rec.DeleteAll(recPurchHeader);
                end;
            }
        }
        modify(TestReport)
        {
            Visible = false;
        }
        modify(Sales)
        {
            Visible = false;
        }
        modify(Finance)
        {
            Visible = false;
        }
    }

    var
}