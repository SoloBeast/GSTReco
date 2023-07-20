pageextension 50030 "Sales Invoice List Ext." extends "Sales Invoice List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Address"; Rec."Sell-to Address")
            {
                ApplicationArea = all;
            }
            field("Sell-to Address 2"; Rec."Sell-to Address 2")
            {
                ApplicationArea = all;
            }
            field("Sell-to City"; Rec."Sell-to City")
            {
                ApplicationArea = all;
            }
            field("Customer GST Reg. No."; Rec."Customer GST Reg. No.")
            {
                ApplicationArea = all;
            }
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("External Document No.")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Dimensions)
        {
            action(SalesDocImport)
            {
                Caption = 'Import Documents';
                Image = Import;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = New;

                trigger OnAction()
                var
                    xmlSalesDocImport: XmlPort "Sales Document Import";
                begin
                    Clear(xmlSalesDocImport);
                    xmlSalesDocImport.SetDocumentType(Rec."Document Type"::Invoice);
                    xmlSalesDocImport.Run();
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
                    recSalesHeader: Record "Sales Header";
                begin
                    recSalesHeader.Reset();
                    recSalesHeader.CopyFilters(Rec);
                    Report.Run(Report::"Sales Invoice Summary", true, true, recSalesHeader);
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
                    recSalesHeader: Record "Sales Header";
                begin
                    recSalesHeader.Reset();
                    recSalesHeader.CopyFilters(Rec);
                    if recSalesHeader.FindSet() then
                        Rec.DeleteAll(recSalesHeader);
                end;
            }
        }
        modify("Test Report")
        {
            Visible = false;
        }
        modify(Reports)
        {
            Visible = false;
        }
    }

    var
}