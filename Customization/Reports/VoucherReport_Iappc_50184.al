report 50184 "Voucher Test Report Export"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\VoucherReport_Iappc_50184.rdl';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            //DataItemTableView = sorting(Number);

            column(CompanyName; recCompanyInfo.Name) { }
            column(CompanyAddress; txtCompanyAddress) { }
            column(Heading; txtHeding) { }
            column(DocumentNo; "G/L Entry"."Document No.") { }
            column(PostingDate; Format("G/L Entry"."Posting Date")) { }
            column(ExternalDocNo; "G/L Entry"."External Document No.") { }
            column(DocumentDate; Format("G/L Entry"."Document Date")) { }
            column(LineType; 10) { }// "G/L Entry"."Data Exch. Entry No.") { }//Domension
            column(AccountCode; "G/L Entry"."G/L Account No.") { }
            column(AccountName; txtDescription) { }
            // column(DimensionName; 'DimensionCOdeValue') { }// "G/L Entry"."Message to Recipient") { }
            column(DrCrText; txtDrCr) { }
            column(CurrencyCaption; txtCurrencyCaption) { }
            column(FCYAmountCaption; txtCurrencyAmtCaption) { }
            column(CurrencyCode; "G/L Entry"."Currency Code") { }
            column(CurrencyAmount; 0) { }// "G/L Entry"."Amount (LCY)") { }//CurrencyAmount
            column(DrAmount; "G/L Entry"."Debit Amount") { }
            column(CrAmount; "G/L Entry"."Credit Amount") { }
            column(VoucherNarration; txtNarration) { }
            column(PreparedBy; "G/L Entry"."Created By") { }
            column(ApprovedBy; "G/L Entry"."Approved By") { }
            column(PostedBy; "G/L Entry"."Posted By") { }

            dataitem("Dimension Set Entry"; "Dimension Set Entry")
            {
                DataItemLinkReference = "G/L Entry";
                DataItemLink = "Dimension Set ID" = field("Dimension Set ID");
                column(DimensionName; "Dimension Value Code" + ' - ' + "Dimension Value Name") { }// "G/L Entry"."Message to Recipient") { }

                trigger OnAfterGetRecord()
                begin
                    if blnPrintDimension then begin
                        //recReportData.Description := recDimensionSetEntry."Dimension Name";
                        //             recReportData."Message to Recipient" := recDimensionSetEntry."Dimension Value Code" + ' - ' + recDimensionSetEntry."Dimension Value Name";
                        //             
                    end;
                end;
            }
            trigger OnPreDataItem()
            begin
                recDataToPrint.Reset();
                recDataToPrint.DeleteAll();
                intLineNo := 0;
                recCompanyInfo.Get();
                txtCompanyAddress := '';

                // if txtDocumentType IN ['BP', 'BR', 'CP', 'CR', 'JV', 'CT', 'GJ'] then
                //     FillGenLine();
                // if txtDocumentType IN ['PO', 'PI', 'PRO', 'PCM'] then
                //     FillPurchaseLine();
                // if txtDocumentType IN ['SO', 'SI', 'SRO', 'SCM'] then
                //     FillSalesLine();
                // if txtDocumentType = 'PV' then
                //FillPostedVoucher();

                if txtCompanyAddress = '' then begin
                    txtCompanyAddress := recCompanyInfo.Address + ' ' + recCompanyInfo."Address 2" + ' ' + recCompanyInfo.City +
                                         ' ' + recCompanyInfo."Post Code";
                    if recState.Get(recCompanyInfo."State Code") then
                        txtCompanyAddress := txtCompanyAddress + ', ' + recState.Description;
                    if recCountry.Get(recCompanyInfo."Country/Region Code") then
                        txtCompanyAddress := txtCompanyAddress + ', ' + recCountry.Name;
                end;

                //Integer.SetRange(Number, 1, intLineNo);
            end;

            trigger OnAfterGetRecord()
            var
                recJournalBatch: Record "Gen. Journal Batch";
            begin
                // recDataToPrint.Reset();
                // recDataToPrint.SetRange("Line No.", Integer.Number);
                // recDataToPrint.FindFirst();

                // if recDataToPrint.Amount > 0 then
                //     txtDrCr := 'Dr'
                // else
                //     txtDrCr := 'Cr';
                if "G/L Entry".Amount > 0 then
                    txtDrCr := 'Dr'
                else
                    txtDrCr := 'Cr';


                if ("G/L Entry"."Journal Batch Name" <> '') and (txtCompanyAddress = '') then begin
                    recJournalBatch.Reset();
                    recJournalBatch.SetRange(Name, "G/L Entry"."Journal Batch Name");
                    if recJournalBatch.FindFirst() then begin
                        if recLocation.Get(recJournalBatch."Location Code") then begin
                            txtCompanyAddress := recLocation.Address + ' ' + recLocation."Address 2" + ' ' + recLocation.City +
                                                 ' ' + recLocation."Post Code";
                            if recState.Get(recLocation."State Code") then
                                txtCompanyAddress := txtCompanyAddress + ', ' + recState.Description;
                            if recCountry.Get(recLocation."Country/Region Code") then
                                txtCompanyAddress := txtCompanyAddress + ', ' + recCountry.Name;
                        end;
                    end;
                end;

                // recReportData.Init();
                // intLineNo += 1;
                // recReportData."Line No." := intLineNo;
                // recReportData."Document No." := recGLEntry."Document No.";
                // recReportData."Posting Date" := recGLEntry."Posting Date";
                // recReportData."External Document No." := recGLEntry."External Document No.";
                // recReportData."Document Date" := recGLEntry."Document Date";

                // recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                // recReportData."Account No." := recGLEntry."G/L Account No.";

                txtDescription := FindGLAccName("G/L Entry"."Source Type", "G/L Entry"."Entry No.", "G/L Entry"."Source No.", "G/L Entry"."G/L Account No.");

                // recReportData."Debit Amount" := recGLEntry."Debit Amount";
                // recReportData."Credit Amount" := recGLEntry."Credit Amount";
                // recReportData.Amount := recGLEntry.Amount;
                // recReportData."Created By" := recGLEntry."Created By";
                // recReportData."Approved By" := recGLEntry."Approved By";
                // recReportData."Posted By" := recGLEntry."Posted By";
                // recReportData.Insert();

                // if blnPrintDimension then begin
                //     recDimensionSetEntry.Reset();
                //     recDimensionSetEntry.SetRange("Dimension Set ID", recGLEntry."Dimension Set ID");
                //     if recDimensionSetEntry.FindFirst() then begin
                //         recReportData.Init();
                //         intLineNo += 1;
                //         recReportData."Line No." := intLineNo;
                //         recReportData."Document No." := recGLEntry."Document No.";
                //         recReportData."Posting Date" := recGLEntry."Posting Date";
                //         recReportData."External Document No." := recGLEntry."External Document No.";
                //         recReportData."Document Date" := recGLEntry."Document Date";
                //         recReportData.Description := 'Dimension Values';
                //         recReportData."Data Exch. Entry No." := -1;
                //         recReportData.Amount := recGLEntry.Amount;
                //         recReportData.Insert();

                //         repeat
                //             recDimensionSetEntry.CalcFields("Dimension Name", "Dimension Value Name");

                //             recReportData.Init();
                //             intLineNo += 1;
                //             recReportData."Line No." := intLineNo;
                //             recReportData."Document No." := recGLEntry."Document No.";
                //             recReportData."Posting Date" := recGLEntry."Posting Date";
                //             recReportData."External Document No." := recGLEntry."External Document No.";
                //             recReportData."Document Date" := recGLEntry."Document Date";
                //             recReportData.Description := recDimensionSetEntry."Dimension Name";
                //             recReportData."Message to Recipient" := recDimensionSetEntry."Dimension Value Code" + ' - ' + recDimensionSetEntry."Dimension Value Name";
                //             recReportData."Data Exch. Entry No." := -2;
                //             recReportData.Amount := recGLEntry.Amount;
                //             recReportData.Insert();
                //         until recDimensionSetEntry.Next() = 0;
                //     end;
                // end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(blnPrintDimension; blnPrintDimension)
                    {
                        ApplicationArea = All;
                        Caption = 'Print Dimensions';
                    }
                }
            }
        }
    }

    var

        txtDocumentType: Text[30];
        cdDocumentNo: Code[20];
        cdTemplateNo: Code[20];
        cdBatchNo: Code[20];
        recDataToPrint: Record "Gen. Journal Line" temporary;
        intLineNo: Integer;
        recCompanyInfo: Record "Company Information";
        recLocation: Record Location;
        txtHeding: Text[50];
        txtDrCr: Text[10];
        GenJnlManagement: Codeunit GenJnlManagement;
        recGenNarration: Record "Gen. Journal Narration";
        txtNarration: Text;
        recTaxTransactions: Record "Tax Transaction Value";
        recDimensionSetEntry: Record "Dimension Set Entry";
        txtCompanyAddress: Text;
        recState: Record State;
        recCountry: Record "Country/Region";
        txtCurrencyCaption: Text;
        txtCurrencyAmtCaption: Text;
        blnPrintDimension: Boolean;
        txtDescription: Text;

    local procedure FillPostedVoucher()
    var
        recReportData: Record "Gen. Journal Line" temporary;
        recGLEntry: Record "G/L Entry";
        recPostedNarration: Record "Posted Narration";
        recPurchComments: Record "Purch. Comment Line";
        recSalesComments: Record "Sales Comment Line";
        recJournalBatch: Record "Gen. Journal Batch";
    begin
        if txtDocumentType = 'PV' then
            txtHeding := 'Posted Voucher';

        recReportData.Reset();
        recReportData.DeleteAll();

        recGLEntry.Reset();
        recGLEntry.SetRange("Document No.", cdDocumentNo);
        if recGLEntry.FindSet() then begin
            txtCurrencyAmtCaption := '   ';
            txtCurrencyCaption := '   ';
            txtNarration := '';
            recPostedNarration.Reset();
            recPostedNarration.SetRange("Document No.", cdDocumentNo);
            recPostedNarration.SetRange("Entry No.", 0);
            if recPostedNarration.FindFirst() then begin
                repeat
                    txtNarration := txtNarration + ' ' + recPostedNarration.Narration;
                until recPostedNarration.Next() = 0;
            end;

            recPurchComments.Reset();
            recPurchComments.SetRange("No.", recGLEntry."Document No.");
            recPurchComments.SetRange("Document Line No.", 0);
            if recPurchComments.FindFirst() then begin
                repeat
                    txtNarration := txtNarration + ' ' + recPurchComments.Comment;
                until recPurchComments.Next() = 0;
            end;

            recSalesComments.Reset();
            recSalesComments.SetRange("No.", recGLEntry."Document No.");
            recSalesComments.SetRange("Document Line No.", 0);
            if recSalesComments.FindFirst() then begin
                repeat
                    txtNarration := txtNarration + ' ' + recSalesComments.Comment;
                until recSalesComments.Next() = 0;
            end;

            repeat
                if (recGLEntry."Journal Batch Name" <> '') and (txtCompanyAddress = '') then begin
                    recJournalBatch.Reset();
                    recJournalBatch.SetRange(Name, recGLEntry."Journal Batch Name");
                    if recJournalBatch.FindFirst() then begin
                        if recLocation.Get(recJournalBatch."Location Code") then begin
                            txtCompanyAddress := recLocation.Address + ' ' + recLocation."Address 2" + ' ' + recLocation.City +
                                                 ' ' + recLocation."Post Code";
                            if recState.Get(recLocation."State Code") then
                                txtCompanyAddress := txtCompanyAddress + ', ' + recState.Description;
                            if recCountry.Get(recLocation."Country/Region Code") then
                                txtCompanyAddress := txtCompanyAddress + ', ' + recCountry.Name;
                        end;
                    end;
                end;

                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recGLEntry."Document No.";
                recReportData."Posting Date" := recGLEntry."Posting Date";
                recReportData."External Document No." := recGLEntry."External Document No.";
                recReportData."Document Date" := recGLEntry."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := recGLEntry."G/L Account No.";

                recReportData.Description := FindGLAccName(recGLEntry."Source Type", recGLEntry."Entry No.", recGLEntry."Source No.", recGLEntry."G/L Account No.");

                recReportData."Debit Amount" := recGLEntry."Debit Amount";
                recReportData."Credit Amount" := recGLEntry."Credit Amount";
                recReportData.Amount := recGLEntry.Amount;
                recReportData."Created By" := recGLEntry."Created By";
                recReportData."Approved By" := recGLEntry."Approved By";
                recReportData."Posted By" := recGLEntry."Posted By";
                recReportData.Insert();

                if blnPrintDimension then begin
                    recDimensionSetEntry.Reset();
                    recDimensionSetEntry.SetRange("Dimension Set ID", recGLEntry."Dimension Set ID");
                    if recDimensionSetEntry.FindFirst() then begin
                        recReportData.Init();
                        intLineNo += 1;
                        recReportData."Line No." := intLineNo;
                        recReportData."Document No." := recGLEntry."Document No.";
                        recReportData."Posting Date" := recGLEntry."Posting Date";
                        recReportData."External Document No." := recGLEntry."External Document No.";
                        recReportData."Document Date" := recGLEntry."Document Date";
                        recReportData.Description := 'Dimension Values';
                        recReportData."Data Exch. Entry No." := -1;
                        recReportData.Amount := recGLEntry.Amount;
                        recReportData.Insert();

                        repeat
                            recDimensionSetEntry.CalcFields("Dimension Name", "Dimension Value Name");

                            recReportData.Init();
                            intLineNo += 1;
                            recReportData."Line No." := intLineNo;
                            recReportData."Document No." := recGLEntry."Document No.";
                            recReportData."Posting Date" := recGLEntry."Posting Date";
                            recReportData."External Document No." := recGLEntry."External Document No.";
                            recReportData."Document Date" := recGLEntry."Document Date";
                            recReportData.Description := recDimensionSetEntry."Dimension Name";
                            recReportData."Message to Recipient" := recDimensionSetEntry."Dimension Value Code" + ' - ' + recDimensionSetEntry."Dimension Value Name";
                            recReportData."Data Exch. Entry No." := -2;
                            recReportData.Amount := recGLEntry.Amount;
                            recReportData.Insert();
                        until recDimensionSetEntry.Next() = 0;
                    end;
                end;
            until recGLEntry.Next() = 0;

            intLineNo := 0;
            recReportData.Reset();
            recReportData.SetCurrentKey(Amount, "Data Exch. Entry No.");
            recReportData.Ascending(false);
            if recReportData.FindSet() then begin
                repeat
                    recDataToPrint.Init();
                    recDataToPrint.TransferFields(recReportData);
                    intLineNo += 1;
                    recDataToPrint."Line No." := intLineNo;
                    recDataToPrint.Insert();
                until recReportData.Next() = 0;
            end;
        end;
    end;

    local procedure FindGLAccName("Source Type": Enum "Gen. Journal Source Type"; "Entry No.": Integer;
                                                     "Source No.": Code[20];
                                                     "G/L Account No.": Code[20]): Text[50]
    var
        AccName: Text[100];
        VendLedgerEntry: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        GLAccount: Record "G/L Account";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        Bank: Record "Bank Account";
    begin
        IF "Source Type" = "Source Type"::Vendor THEN
            IF VendLedgerEntry.GET("Entry No.") THEN BEGIN
                Vend.GET("Source No.");
                AccName := Vend.Name;
            END ELSE BEGIN
                GLAccount.GET("G/L Account No.");
                AccName := GLAccount.Name;
            END
        ELSE
            IF "Source Type" = "Source Type"::Customer THEN
                IF CustLedgerEntry.GET("Entry No.") THEN BEGIN
                    Cust.GET("Source No.");
                    AccName := Cust.Name;
                END ELSE BEGIN
                    GLAccount.GET("G/L Account No.");
                    AccName := GLAccount.Name;
                END
            ELSE
                IF "Source Type" = "Source Type"::"Bank Account" THEN
                    IF BankLedgerEntry.GET("Entry No.") THEN BEGIN
                        Bank.GET("Source No.");
                        AccName := Bank.Name;
                    END ELSE BEGIN
                        GLAccount.GET("G/L Account No.");
                        AccName := GLAccount.Name;
                    END
                ELSE BEGIN
                    GLAccount.GET("G/L Account No.");
                    AccName := GLAccount.Name;
                END;

        IF "Source Type" = "Source Type"::" " THEN BEGIN
            GLAccount.GET("G/L Account No.");
            AccName := GLAccount.Name;
        END;

        EXIT(AccName);
    end;

    local procedure FillDimensionSetEntry(DimensionSetID: Integer; var recReportData: Record "Gen. Journal Line" temporary; DocumentNo: Code[20]; PostingDate: Date;
                                                ExtDocNo: Code[20]; DocumentDate: Date; TempValue: Decimal; RefLineNo: Integer)
    var
    begin
        if blnPrintDimension then begin
            recDimensionSetEntry.Reset();
            recDimensionSetEntry.SetRange("Dimension Set ID", DimensionSetID);
            if recDimensionSetEntry.FindFirst() then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := DocumentNo;
                recReportData."Posting Date" := PostingDate;
                recReportData."External Document No." := ExtDocNo;
                recReportData."Document Date" := DocumentDate;
                recReportData.Description := 'Dimension Values';
                recReportData."Data Exch. Line No." := RefLineNo;
                recReportData."Data Exch. Entry No." := -1;
                recReportData.Amount := TempValue;
                recReportData.Insert();

                repeat
                    recDimensionSetEntry.CalcFields("Dimension Name", "Dimension Value Name");

                    recReportData.Init();
                    intLineNo += 1;
                    recReportData."Line No." := intLineNo;
                    recReportData."Document No." := DocumentNo;
                    recReportData."Posting Date" := PostingDate;
                    recReportData."External Document No." := ExtDocNo;
                    recReportData."Document Date" := DocumentDate;
                    recReportData.Description := recDimensionSetEntry."Dimension Name";
                    recReportData."Message to Recipient" := recDimensionSetEntry."Dimension Value Code" + ' - ' + recDimensionSetEntry."Dimension Value Name";
                    recReportData."Data Exch. Line No." := RefLineNo;
                    recReportData."Data Exch. Entry No." := -2;
                    recReportData.Amount := TempValue;
                    recReportData.Insert();
                until recDimensionSetEntry.Next() = 0;
            end;
        end;
    end;
}