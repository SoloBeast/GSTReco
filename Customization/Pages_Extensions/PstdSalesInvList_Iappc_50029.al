pageextension 50029 "Pstd. Sales Inv. List Ext." extends "Posted Sales Invoices"
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
            field("E-Invoice Error"; Rec."E-Invoice Error")
            {
                ApplicationArea = All;
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
        modify("No. Printed")
        {
            Visible = false;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Ship-to Code")
        {
            Visible = true;
        }
        modify("Amount Including VAT")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Print)
        {
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
                    cuEInvoiceEWay.GenerateEInvoiceSalesInvoiceClearTax(Rec);
                end;
            }
            action(GenerateEInvoiceBulk)
            {
                ApplicationArea = all;
                Caption = 'Generate E Invoice Bulk';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                var
                begin
                    If Rec.GetFilters = '' then
                        Error('Please apply atleast one filter');

                    recSalesInvoiceHeader.Reset();
                    recSalesInvoiceHeader.CopyFilters(Rec);
                    recSalesInvoiceHeader.SetRange("E-Invoice Status", recSalesInvoiceHeader."E-Invoice Status"::Open);
                    if recSalesInvoiceHeader.FindFirst() then begin
                        cuEInvoiceEWay.GenerateEInvoiceSalesInvBulk(recSalesInvoiceHeader);
                    end else
                        Error('Nothing to generate.');
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
                    cuEInvoiceEWay.CancelEInvoiceSalesInvoiceClearTax(Rec);
                end;
            }
            action(OpenEInvoice)
            {
                ApplicationArea = all;
                Caption = 'Change Status of E-Invoice Error';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                begin
                    Clear(cuEInvoiceEWay);
                    cuEInvoiceEWay.ChangeEInvoiceStatus(Rec);
                end;
            }
            action(GenerateEWay)
            {
                ApplicationArea = all;
                Caption = 'Generate E Way';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                begin
                    Clear(cuEInvoiceEWay);
                    cuEInvoiceEWay.GenerateEWaySalesInvoice(Rec);
                end;
            }
            action(CancelEWay)
            {
                ApplicationArea = all;
                Caption = 'Cancel E Way';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                begin
                    Clear(cuEInvoiceEWay);
                    cuEInvoiceEWay.CancelEWaySalesInvoice(Rec);
                end;
            }
            action(PrintInvoice)
            {
                ApplicationArea = all;
                Caption = 'Print Invoice';
                Image = Print;
                Visible = false;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                begin
                    recSalesInvoiceHeader.Reset();
                    recSalesInvoiceHeader.SetRange("No.", Rec."No.");
                    recSalesInvoiceHeader.FindFirst();
                    Report.Run(50041, true, true, recSalesInvoiceHeader);
                end;
            }
            action(PrintInvoiceP)
            {
                ApplicationArea = all;
                Caption = 'Print Invoice';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                begin
                    recSalesInvoiceHeader.Reset();
                    recSalesInvoiceHeader.SetRange("No.", Rec."No.");
                    recSalesInvoiceHeader.FindFirst();
                    Report.Run(50016, true, true, recSalesInvoiceHeader);
                end;
            }
            action(PrintInvoiceExport)
            {
                ApplicationArea = all;
                Caption = 'Print Export Invoice';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                var
                    recUserSetup: Record "User Setup";
                begin
                    recUserSetup.Get(UserId);


                    recSalesInvoiceHeader.Reset();
                    recSalesInvoiceHeader.SetRange("No.", Rec."No.");
                    recSalesInvoiceHeader.FindFirst();
                    Report.Run(50188, true, true, recSalesInvoiceHeader);

                end;
            }
            action(DigiSignInvoice)
            {
                ApplicationArea = all;
                Caption = 'Digital Sign Invoice';
                Image = Signature;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                var
                    pdfStram: InStream;
                    filename: Text;
                    recSalesInvoice: Record "Sales Invoice Header";
                    RecRef: RecordRef;
                begin
                    Clear(cuDigitalSign);
                    filename := Rec."No." + '.pdf';
                    recSalesInvoice.Reset();
                    recSalesInvoice.SetRange("No.", Rec."No.");
                    recSalesInvoice.FindFirst();
                    RecRef.Open(112);
                    RecRef.GetTable(recSalesInvoice);
                    cuDigitalSign.DigitallySignDocument(Rec."No.", RecRef, 50016);
                    //DownloadFromStream(pdfStram, 'Export', '', 'All Files (*.*)|*.*', filename);
                end;
            }
            action(DigiSignInvoiceExport)
            {
                ApplicationArea = all;
                Caption = 'Digital Sign Invoice Export';
                Image = Signature;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                var
                    pdfStram: InStream;
                    filename: Text;
                    recSalesInvoice: Record "Sales Invoice Header";
                    RecRef: RecordRef;
                begin
                    Clear(cuDigitalSign);
                    filename := Rec."No." + '.pdf';
                    recSalesInvoice.Reset();
                    recSalesInvoice.SetRange("No.", Rec."No.");
                    recSalesInvoice.FindFirst();
                    RecRef.Open(112);
                    RecRef.GetTable(recSalesInvoice);
                    cuDigitalSign.DigitallySignDocument(Rec."No.", RecRef, 50188);
                    //DownloadFromStream(pdfStram, 'Export', '', 'All Files (*.*)|*.*', filename);
                end;
            }
            action(DownLoadInvoices)
            {
                ApplicationArea = all;
                Caption = 'Download Invoices';
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
                    //FileManagement: Codeunit "File Management";
                    SalesHeader: Record "Sales Invoice Header";
                    DataCompression: Codeunit "Data Compression";
                    ZipFileName: Text[50];
                    PdfFileName: Text[50];
                    pdfStram: InStream;
                    recUserSetup: Record "User Setup";
                begin
                    recUserSetup.Get(UserId);
                    recUserSetup."Print Export Invoice" := 1;
                    recUserSetup.Modify();

                    ZipFileName := 'SalesInvoice_' + Format(CurrentDateTime) + '.zip';
                    DataCompression.CreateZipArchive();
                    SalesHeader.Reset;
                    SalesHeader.CopyFilters(Rec);
                    if SalesHeader.FindSet() then
                        repeat
                            TempBlob.CreateOutStream(OutS);
                            RecRef.GetTable(SalesHeader);
                            FldRef := RecRef.Field(SalesHeader.FieldNo("No."));
                            FldRef.SetRange(SalesHeader."No.");
                            if RecRef.FindFirst() then begin
                                Report.SaveAs(50016, '', ReportFormat::Pdf, OutS, RecRef);

                                TempBlob.CreateInStream(InS);
                                PdfFileName := SalesHeader."No." + '.pdf';

                                // Clear(cuDigitalSign);
                                // pdfStram := cuDigitalSign.DigitallySignDocument(SalesHeader."No.");
                                //DownloadFromStream(pdfStram, 'Export', '', 'All Files (*.*)|*.*', PdfFileName);

                                DataCompression.AddEntry(InS, PdfFileName);
                                //DataCompression.AddEntry(pdfStram, PdfFileName);
                            end
                        until SalesHeader.Next() = 0;
                    TempBlob.CreateOutStream(OutS);
                    DataCompression.SaveZipArchive(OutS);
                    TempBlob.CreateInStream(InS);
                    DownloadFromStream(InS, '', '', '', ZipFileName);

                    recUserSetup."Print Export Invoice" := 0;
                    recUserSetup.Modify();
                end;
            }
        }

        modify(Print)
        {
            Visible = false;
        }
        modify(IncomingDoc)
        {
            Visible = false;
        }
        modify(ActivityLog)
        {
            Visible = false;
        }
    }

    var
        recSalesInvoiceHeader: Record "Sales Invoice Header";
        cuEInvoiceEWay: Codeunit "E-Invoicing / E-Way";
        cuDigitalSign: Codeunit DigiSign;
}