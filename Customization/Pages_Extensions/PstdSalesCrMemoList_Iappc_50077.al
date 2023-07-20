pageextension 50077 "Pstd. Sales Cr.Memo List Ext." extends "Posted Sales Credit Memos"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sell-to Customer Name")
        {
            field("Internal Document Type"; Rec."Internal Document Type")
            {
                ApplicationArea = all;
            }
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
        addafter(Amount)
        {
            field("IGST Amount"; Rec."IGST Amount")
            {
                ApplicationArea = all;
            }
            field("CGST Amount"; Rec."CGST Amount")
            {
                ApplicationArea = all;
            }
            field("SGST Amount"; Rec."SGST Amount")
            {
                ApplicationArea = all;
            }
        }
        addafter("Location Code")
        {
            field("E-Invoice Status"; Rec."E-Invoice Status")
            {
                ApplicationArea = all;
            }
            field("IRN Hash"; Rec."IRN Hash")
            {
                ApplicationArea = all;
            }
            field("Acknowledgement No."; Rec."Acknowledgement No.")
            {
                ApplicationArea = all;
            }
            field("Acknowledgement Date"; Rec."Acknowledgement Date")
            {
                ApplicationArea = all;
            }
            field("E-Inv. Cancelled Date"; Rec."E-Inv. Cancelled Date")
            {
                ApplicationArea = all;
            }
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Due Date")
        {
            Visible = false;
        }
        modify("Amount Including VAT")
        {
            Visible = false;
        }
        modify("No. Printed")
        {
            Visible = false;
        }
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
                Visible = false;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    recSalesCrMemoHeader.Reset();
                    recSalesCrMemoHeader.SetRange("No.", Rec."No.");
                    recSalesCrMemoHeader.FindFirst();
                    Report.Run(50018, true, true, recSalesCrMemoHeader);
                end;
            }
            action(GenerateEInvoice)
            {
                ApplicationArea = all;
                Caption = 'Generate E Invoice';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                begin
                    Clear(cuEInvoiceEWay);
                    cuEInvoiceEWay.GenerateEInvoiceSalesCreditMemoClearTax(Rec);
                end;
            }
            action(CancelEInvoice)
            {
                ApplicationArea = all;
                Caption = 'Cancel E Invoice';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                begin
                    Clear(cuEInvoiceEWay);
                    cuEInvoiceEWay.CancelEInvoiceSalesCreditMemoClearTax(Rec);
                end;
            }
            // action(PrintCrMemo)
            // {
            //     ApplicationArea = all;
            //     Caption = 'Print Credit Memo';
            //     Image = Print;
            //     Promoted = true;
            //     PromotedCategory = Category4;

            //     trigger OnAction()
            //     begin
            //         recSalesCrMemoHeader.Reset();
            //         recSalesCrMemoHeader.SetRange("No.", Rec."No.");
            //         recSalesCrMemoHeader.FindFirst();
            //         Report.Run(50020, true, true, recSalesCrMemoHeader);
            //     end;
            // }
            action(PrintCrMemoNew)
            {
                ApplicationArea = all;
                Caption = 'Print Credit Memo New';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    recSalesCrMemoHeader.Reset();
                    recSalesCrMemoHeader.SetRange("No.", Rec."No.");
                    recSalesCrMemoHeader.FindFirst();
                    Report.Run(50181, true, true, recSalesCrMemoHeader);
                end;
            }
            action(DigiSignInvoice)
            {
                ApplicationArea = all;
                Caption = 'Digital Sign Credit Memo';
                Image = Signature;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                var
                    pdfStram: InStream;
                    filename: Text;
                    recSalesInvoice: record "Sales Cr.Memo Header";
                    RecRef: RecordRef;
                begin
                    Clear(cuDigitalSign);
                    filename := Rec."No." + '.pdf';
                    recSalesInvoice.Reset();
                    recSalesInvoice.SetRange("No.", Rec."No.");
                    recSalesInvoice.FindFirst();
                    RecRef.Open(112);
                    RecRef.GetTable(recSalesInvoice);
                    cuDigitalSign.DigitallySignDocument(Rec."No.", RecRef, 50020);
                    //DownloadFromStream(pdfStram, 'Export', '', 'All Files (*.*)|*.*', filename);
                end;
            }
        }

        modify(IncomingDoc)
        {
            Visible = false;
        }
        modify("&Print")
        {
            Visible = false;
        }
        modify(ActivityLog)
        {
            Visible = false;
        }
    }

    var
        recSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        cuEInvoiceEWay: Codeunit "E-Invoicing / E-Way";
        cuDigitalSign: Codeunit DigiSign;
}