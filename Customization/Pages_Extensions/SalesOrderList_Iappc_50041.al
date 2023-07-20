pageextension 50041 "Sales Order List Ext." extends "Sales Order List"
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
        modify("Requested Delivery Date")
        {
            Visible = true;
        }
        modify("Sell-to Contact")
        {
            Visible = true;
        }
        modify("Due Date")
        {
            Visible = true;
        }
        modify("External Document No.")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Document Date")
        {
            Visible = false;
        }
        modify(Status)
        {
            Visible = false;
        }
        modify("Completely Shipped")
        {
            Visible = false;
        }
        modify("Amt. Ship. Not Inv. (LCY)")
        {
            Visible = true;
        }
        moveafter(Amount; "Amt. Ship. Not Inv. (LCY)")
        modify("Amt. Ship. Not Inv. (LCY) Base")
        {
            Visible = false;
        }
        modify("Amount Including VAT")
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
                    xmlSalesDocImport.SetDocumentType(Rec."Document Type"::Order);
                    xmlSalesDocImport.Run();
                    CurrPage.Update();
                end;
            }
        }
        modify("Sales Reservation Avail.")
        {
            Visible = false;
        }
        modify("Email Confirmation")
        {
            Visible = false;
        }
        modify("Print Confirmation")
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
        modify("Test Report")
        {
            Visible = false;
        }
        modify("&Print")
        {
            Visible = false;
        }
        modify("&Order Confirmation")
        {
            Visible = false;
        }
        modify(Display)
        {
            Visible = false;
        }
        modify("Prepayment Credi&t Memos")
        {
            Visible = false;
        }
        modify(PostedSalesPrepmtInvoices)
        {
            Visible = false;
        }
        modify("Create &Warehouse Shipment")
        {
            Visible = false;
        }
        modify("Create Inventor&y Put-away/Pick")
        {
            Visible = false;
        }
    }

    var
}