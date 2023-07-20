pageextension 50023 "General Ledger Entries Ext." extends "General Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document No.")
        {
            field("Transaction Nature"; Rec."Transaction Nature")
            {
                ApplicationArea = all;
            }
        }
        addafter("Entry No.")
        {
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;
            }
        }
        modify("Debit Amount")
        {
            Visible = true;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 3 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 4 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 5 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 6 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 7 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 8 Code")
        {
            Visible = true;
        }
        modify("User ID")
        {
            Visible = true;
        }

        movebefore("Posting Date"; "G/L Account No.")
        moveafter(Amount; "Debit Amount")
        moveafter("Debit Amount"; "Credit Amount")
        moveafter("External Document No."; "Shortcut Dimension 3 Code")
        moveafter("Shortcut Dimension 3 Code"; "Shortcut Dimension 4 Code")
        moveafter("Shortcut Dimension 4 Code"; "Shortcut Dimension 5 Code")
        moveafter("Shortcut Dimension 5 Code"; "Shortcut Dimension 6 Code")
        moveafter("Shortcut Dimension 6 Code"; "Shortcut Dimension 7 Code")
        moveafter("Shortcut Dimension 7 Code"; "Shortcut Dimension 8 Code")
        moveafter("Shortcut Dimension 8 Code"; "User ID")
    }

    actions
    {
        // Add changes to page actions here
        addafter("Print Voucher")
        {
            action(PrintVoucher)
            {
                Caption = 'Print Voucher';
                ApplicationArea = all;
                Image = PrintVoucher;
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    rptVoucherReport: Report "Voucher Test Report";
                begin
                    Clear(rptVoucherReport);
                    rptVoucherReport.SetDocumentDetails('PV', Rec."Document No.", '', '');
                    rptVoucherReport.Run();

                end;
            }
            action(PrintVoucherExport)
            {
                Caption = 'Print Voucher Export';
                ApplicationArea = all;
                Image = PrintVoucher;
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    rptVoucherReport: Report "Voucher Test Report Export";
                    recGLEntry: Record "G/L Entry";
                begin
                    recGLEntry.Reset();
                    recGLEntry.SetRange("Document No.", Rec."Document No.");
                    recGLEntry.FindFirst();
                    Report.Run(50184, false, false, recGLEntry);
                    //rptVoucherReport.SetDocumentDetails('PV', Rec."Document No.", '', '');
                    //rptVoucherReport.Run();

                end;
            }
            action(DownLoadInvoices)
            {
                ApplicationArea = all;
                Caption = 'Download Vocuhers';
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
                    recGLEntry: Record "G/L Entry";
                    DataCompression: Codeunit "Data Compression";
                    ZipFileName: Text[50];
                    PdfFileName: Text[50];
                    pdfStram: InStream;
                begin
                    ZipFileName := 'Vouchers_' + Format(CurrentDateTime) + '.zip';
                    DataCompression.CreateZipArchive();
                    recGLEntry.Reset;
                    recGLEntry.CopyFilters(Rec);
                    if recGLEntry.FindSet() then
                        repeat
                            TempBlob.CreateOutStream(OutS);
                            RecRef.GetTable(recGLEntry);
                            FldRef := RecRef.Field(recGLEntry.FieldNo("Document No."));
                            FldRef.SetRange(recGLEntry."Document No.");
                            if RecRef.FindFirst() then begin
                                Report.SaveAs(50184, '', ReportFormat::Pdf, OutS, RecRef);
                                TempBlob.CreateInStream(InS);
                                PdfFileName := recGLEntry."Document No." + '.pdf';
                                DataCompression.AddEntry(InS, PdfFileName);
                            end
                        until recGLEntry.Next() = 0;
                    TempBlob.CreateOutStream(OutS);
                    DataCompression.SaveZipArchive(OutS);
                    TempBlob.CreateInStream(InS);
                    DownloadFromStream(InS, '', '', '', ZipFileName);
                end;
            }
        }
        modify("Print Voucher")
        {
            Visible = false;
        }
    }

    var
}