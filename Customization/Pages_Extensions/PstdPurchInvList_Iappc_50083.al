pageextension 50083 "Pstd. Purch.Inv. List Ext." extends "Posted Purchase Invoices"
{
    layout
    {
        // Add changes to page layout here
        modify("Posting Date")
        {
            Visible = true;
        }
        addafter("Buy-from Vendor Name")
        {
            field("Internal Document Type"; Rec."Internal Document Type")
            {
                ApplicationArea = all;
            }
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
            field("Invoice Type"; Rec."Invoice Type")
            {
                ApplicationArea = all;
            }
            field("Vendor GST Reg. No."; Rec."Vendor GST Reg. No.")
            {
                ApplicationArea = all;
            }
        }
        modify("Buy-from Country/Region Code")
        {
            Visible = true;
        }
        moveafter("Buy-from City"; "Buy-from Country/Region Code")
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
            action(PrintPortrait)
            {
                ApplicationArea = all;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                begin
                    recPurchInvoiceHeader.Reset();
                    recPurchInvoiceHeader.SetRange("No.", Rec."No.");
                    recPurchInvoiceHeader.FindFirst();
                    Report.Run(50025, true, true, recPurchInvoiceHeader);
                end;
            }
            action(DownLoadInvoices)
            {
                ApplicationArea = all;
                Caption = 'Download Purchase Invoices';
                Image = Signature;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    OutS: OutStream;
                    InS: InStream;
                    RecRef: RecordRef;
                    FldRef: FieldRef;
                    PurchaseHeader: Record "Purch. Inv. Header";
                    DataCompression: Codeunit "Data Compression";
                    ZipFileName: Text[50];
                    PdfFileName: Text[50];
                    pdfStram: InStream;
                begin
                    ZipFileName := 'PruchaseInvoice_' + Format(CurrentDateTime) + '.zip';
                    DataCompression.CreateZipArchive();
                    PurchaseHeader.Reset;
                    PurchaseHeader.CopyFilters(Rec);
                    if PurchaseHeader.FindSet() then
                        repeat
                            TempBlob.CreateOutStream(OutS);
                            RecRef.GetTable(PurchaseHeader);
                            FldRef := RecRef.Field(PurchaseHeader.FieldNo("No."));
                            FldRef.SetRange(PurchaseHeader."No.");
                            if RecRef.FindFirst() then begin
                                Report.SaveAs(50025, '', ReportFormat::Pdf, OutS, RecRef);
                                TempBlob.CreateInStream(InS);
                                PdfFileName := PurchaseHeader."No." + '.pdf';
                                DataCompression.AddEntry(InS, PdfFileName);
                                //DataCompression.AddEntry(pdfStram, PdfFileName);
                            end
                        until PurchaseHeader.Next() = 0;
                    TempBlob.CreateOutStream(OutS);
                    DataCompression.SaveZipArchive(OutS);
                    TempBlob.CreateInStream(InS);
                    DownloadFromStream(InS, '', '', '', ZipFileName);
                end;
            }
        }
        modify("&Print")
        {
            Visible = false;
        }
    }

    var
        recPurchInvoiceHeader: Record "Purch. Inv. Header";
}