pageextension 50045 "Purch. Order List Ext." extends "Purchase Order List"
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
            field("Completely Received"; Rec."Completely Received")
            {
                ApplicationArea = all;
            }
            field("Short Closed"; Rec."Short Closed")
            {
                ApplicationArea = all;
            }
        }
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify(Status)
        {
            Visible = false;
        }
        modify("Amount Including VAT")
        {
            Visible = false;
        }
        addafter(Amount)
        {
            field("Amt. Rcd. Not Invoiced (LCY)"; Rec."Amt. Rcd. Not Invoiced (LCY)")
            {
                ApplicationArea = all;
            }
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
                    xmlPurchaseDocImport.SetDocumentType(Rec."Document Type"::Order);
                    xmlPurchaseDocImport.Run();
                    CurrPage.Update();
                end;
            }
        }
        addafter("Print")
        {
            action(PrintPOPort)
            {
                ApplicationArea = all;
                Caption = 'Print Order';
                Image = Print;

                trigger OnAction()
                var
                begin
                    recPurchHeader.Reset();
                    recPurchHeader.SetRange("Document Type", Rec."Document Type");
                    recPurchHeader.SetRange("No.", Rec."No.");
                    recPurchHeader.FindFirst();
                    Report.Run(Report::"Purchase Order Portrait", true, true, recPurchHeader);
                end;
            }
        }

        modify(Print)
        {
            Visible = false;
        }
        modify(Send)
        {
            Visible = false;
        }
        modify(AttachAsPDF)
        {
            Visible = false;
        }
        modify("F&unctions")
        {
            Visible = false;
        }
        modify(Warehouse)
        {
            Visible = false;
        }
        modify(TestReport)
        {
            Visible = false;
        }
        modify("Prepayment Credi&t Memos")
        {
            Visible = false;
        }
        modify(PostedPurchasePrepmtInvoices)
        {
            Visible = false;
        }
        modify("Whse. Receipt Lines")
        {
            Visible = false;
        }
        modify("Create &Whse. Receipt")
        {
            Visible = false;
        }
        modify("Create Inventor&y Put-away/Pick")
        {
            Visible = false;
        }
    }

    var
        recPurchHeader: Record "Purchase Header";
}