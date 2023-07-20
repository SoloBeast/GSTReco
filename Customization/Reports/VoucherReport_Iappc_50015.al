report 50015 "Voucher Test Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\VoucherReport_Iappc_50015.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);

            column(CompanyName; recCompanyInfo.Name) { }
            column(CompanyAddress; txtCompanyAddress) { }
            column(Heading; txtHeding) { }
            column(DocumentNo; recDataToPrint."Document No.") { }
            column(PostingDate; Format(recDataToPrint."Posting Date")) { }
            column(ExternalDocNo; recDataToPrint."External Document No.") { }
            column(DocumentDate; Format(recDataToPrint."Document Date")) { }
            column(LineType; recDataToPrint."Data Exch. Entry No.") { }
            column(AccountCode; recDataToPrint."Account No.") { }
            column(AccountName; recDataToPrint.Description) { }
            column(DimensionName; recDataToPrint."Message to Recipient") { }
            column(DrCrText; txtDrCr) { }
            column(CurrencyCaption; txtCurrencyCaption) { }
            column(FCYAmountCaption; txtCurrencyAmtCaption) { }
            column(CurrencyCode; recDataToPrint."Currency Code") { }
            column(CurrencyAmount; recDataToPrint."Amount (LCY)") { }
            column(DrAmount; recDataToPrint."Debit Amount") { }
            column(CrAmount; recDataToPrint."Credit Amount") { }
            column(VoucherNarration; txtNarration) { }
            column(PreparedBy; recDataToPrint."Created By") { }
            column(ApprovedBy; recDataToPrint."Approved By") { }
            column(PostedBy; recDataToPrint."Posted By") { }

            trigger OnPreDataItem()
            begin
                recDataToPrint.Reset();
                recDataToPrint.DeleteAll();
                intLineNo := 0;
                recCompanyInfo.Get();
                txtCompanyAddress := '';

                if txtDocumentType IN ['BP', 'BR', 'CP', 'CR', 'JV', 'CT', 'GJ'] then
                    FillGenLine();
                if txtDocumentType IN ['PO', 'PI', 'PRO', 'PCM'] then
                    FillPurchaseLine();
                if txtDocumentType IN ['SO', 'SI', 'SRO', 'SCM'] then
                    FillSalesLine();
                if txtDocumentType = 'PV' then
                    FillPostedVoucher();

                if txtCompanyAddress = '' then begin
                    txtCompanyAddress := recCompanyInfo.Address + ' ' + recCompanyInfo."Address 2" + ' ' + recCompanyInfo.City +
                                         ' ' + recCompanyInfo."Post Code";
                    if recState.Get(recCompanyInfo."State Code") then
                        txtCompanyAddress := txtCompanyAddress + ', ' + recState.Description;
                    if recCountry.Get(recCompanyInfo."Country/Region Code") then
                        txtCompanyAddress := txtCompanyAddress + ', ' + recCountry.Name;
                end;

                Integer.SetRange(Number, 1, intLineNo);
            end;

            trigger OnAfterGetRecord()
            begin
                recDataToPrint.Reset();
                recDataToPrint.SetRange("Line No.", Integer.Number);
                recDataToPrint.FindFirst();

                if recDataToPrint.Amount > 0 then
                    txtDrCr := 'Dr'
                else
                    txtDrCr := 'Cr';
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

    procedure SetDocumentDetails(DocumentType: Text[30]; DocumentNo: Code[20]; TemplateNo: Code[20]; BatchNo: Code[20])
    var
    begin
        txtDocumentType := DocumentType;
        cdDocumentNo := DocumentNo;
        cdTemplateNo := TemplateNo;
        cdBatchNo := BatchNo;
    end;

    local procedure FillGenLine()
    var
        recGenLine: Record "Gen. Journal Line";
        recReportData: Record "Gen. Journal Line" temporary;
        decTempValue: Decimal;
        decCurrencyFactor: Decimal;
        decTDSAmount: Decimal;
        decTDSFCYAmount: Decimal;
        recJournalBatch: Record "Gen. Journal Batch";
    begin
        if txtDocumentType = 'BP' then
            txtHeding := 'Test Report - Bank Payment Voucher';
        if txtDocumentType = 'BR' then
            txtHeding := 'Test Report - Bank Receipt Voucher';
        if txtDocumentType = 'CP' then
            txtHeding := 'Test Report - Cash Payment Voucher';
        if txtDocumentType = 'CR' then
            txtHeding := 'Test Report - Cash Receipt Voucher';
        if txtDocumentType = 'JV' then
            txtHeding := 'Test Report - Journal Voucher';
        if txtDocumentType = 'CT' then
            txtHeding := 'Test Report - Contra Voucher';
        if txtDocumentType = 'GJ' then
            txtHeding := 'Test Report - General Journal';

        recReportData.Reset();
        recReportData.DeleteAll();

        recGenLine.Reset();
        recGenLine.SetRange("Journal Template Name", cdTemplateNo);
        recGenLine.SetRange("Journal Batch Name", cdBatchNo);
        recGenLine.SetRange("Document No.", cdDocumentNo);
        if recGenLine.FindSet() then begin
            recJournalBatch.Get(cdTemplateNo, cdBatchNo);
            if recLocation.Get(recJournalBatch."Location Code") then begin
                txtCompanyAddress := recLocation.Address + ' ' + recLocation."Address 2" + ' ' + recLocation.City +
                                     ' ' + recLocation."Post Code";
                if recState.Get(recLocation."State Code") then
                    txtCompanyAddress := txtCompanyAddress + ', ' + recState.Description;
                if recCountry.Get(recLocation."Country/Region Code") then
                    txtCompanyAddress := txtCompanyAddress + ', ' + recCountry.Name;
            end;

            txtNarration := '';
            recGenNarration.Reset();
            recGenNarration.SetRange("Journal Template Name", cdTemplateNo);
            recGenNarration.SetRange("Journal Batch Name", cdBatchNo);
            recGenNarration.SetRange("Document No.", cdDocumentNo);
            if recGenNarration.FindFirst() then begin
                repeat
                    txtNarration := txtNarration + ' ' + recGenNarration.Narration;
                until recGenNarration.Next() = 0;
            end;

            repeat
                decTDSAmount := 0;
                decTDSFCYAmount := 0;
                recTaxTransactions.Reset();
                recTaxTransactions.SetRange("Tax Record ID", recGenLine.RecordId);
                recTaxTransactions.SetRange("Tax Type", 'TDS');
                recTaxTransactions.SetRange("Value Type", recTaxTransactions."Value Type"::COMPONENT);
                recTaxTransactions.SetRange("Value ID", 7);
                if recTaxTransactions.FindFirst() then begin
                    decTDSAmount := Round(recTaxTransactions."Amount (LCY)", 0.01);
                    decTDSFCYAmount := round(recTaxTransactions.Amount, 0.01);
                end;
                if recGenLine."Currency Code" <> '' then begin
                    decCurrencyFactor := 1 / recGenLine."Currency Factor";
                    txtCurrencyAmtCaption := 'FCY Amt.';
                    txtCurrencyCaption := 'Currency';
                end else begin
                    decCurrencyFactor := 1;
                    txtCurrencyAmtCaption := '   ';
                    txtCurrencyCaption := '   ';
                end;

                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recGenLine."Document No.";
                recReportData."Posting Date" := recGenLine."Posting Date";
                recReportData."External Document No." := recGenLine."External Document No.";
                recReportData."Document Date" := recGenLine."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := GetGLAccountNo(recGenLine."Account Type", recGenLine."Account No.");

                GenJnlManagement.GetAccounts(recGenLine, recReportData.Description, recGenLine."Transaction Information");
                recReportData.Description := recGenLine."Account No." + ' - ' + recReportData.Description;
                recReportData."Transaction Information" := recGenLine.Description;

                if recGenLine."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recGenLine."Currency Code";
                    if recGenLine."Document Type" = recGenLine."Document Type"::Invoice then
                        recReportData."Amount (LCY)" := Abs(recGenLine.Amount) - decTDSFCYAmount
                    else
                        recReportData."Amount (LCY)" := Abs(recGenLine.Amount);
                end;

                if (decTDSAmount <> 0) and (recGenLine."Document Type" = recGenLine."Document Type"::Invoice) then begin
                    recReportData."Debit Amount" := Round(recGenLine."Debit Amount" * decCurrencyFactor, 0.01);
                    recReportData."Credit Amount" := Round(recGenLine."Credit Amount" * decCurrencyFactor, 0.01) - decTDSAmount;
                    recReportData.Amount := Round((recReportData."Debit Amount" - recReportData."Credit Amount") * decCurrencyFactor, 0.01);
                end else begin
                    recReportData."Debit Amount" := Round(recGenLine."Debit Amount" * decCurrencyFactor, 0.01);
                    recReportData."Credit Amount" := Round(recGenLine."Credit Amount" * decCurrencyFactor, 0.01);
                    recReportData.Amount := Round(recGenLine.Amount * decCurrencyFactor, 0.01);
                end;
                decTempValue := recReportData.Amount;
                recReportData."Created By" := recGenLine."Created By";
                recReportData."Approved By" := recGenLine."Approved By";
                recReportData."Posted By" := recGenLine."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recGenLine."Dimension Set ID", recReportData, recGenLine."Document No.", recGenLine."Posting Date",
                                                        recGenLine."External Document No.", recGenLine."Document Date", decTempValue, 0);

                if recGenLine."Bal. Account No." <> '' then begin
                    recReportData.Init();
                    intLineNo += 1;
                    recReportData."Line No." := intLineNo;
                    recReportData."Document No." := recGenLine."Document No.";
                    recReportData."Posting Date" := recGenLine."Posting Date";
                    recReportData."External Document No." := recGenLine."External Document No.";
                    recReportData."Document Date" := recGenLine."Document Date";

                    recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                    recReportData."Account No." := GetGLAccountNo(recGenLine."Bal. Account Type", recGenLine."Bal. Account No.");
                    recReportData.Description := recGenLine."Bal. Account No." + ' - ' + recGenLine."Transaction Information";
                    recReportData."Transaction Information" := recGenLine.Description;

                    if (decTDSAmount <> 0) and (recGenLine."Document Type" = recGenLine."Document Type"::Payment) then begin
                        recReportData."Debit Amount" := Round(recGenLine."Credit Amount" * decCurrencyFactor, 0.01);
                        recReportData."Credit Amount" := Round(recGenLine."Debit Amount" * decCurrencyFactor, 0.01) - decTDSAmount;
                        recReportData.Amount := Round(recReportData."Debit Amount" - recReportData."Credit Amount", 0.01);
                    end else begin
                        recReportData."Debit Amount" := Round(recGenLine."Credit Amount" * decCurrencyFactor, 0.01);
                        recReportData."Credit Amount" := Round(recGenLine."Debit Amount" * decCurrencyFactor, 0.01);
                        recReportData.Amount := -Round(recGenLine.Amount * decCurrencyFactor, 0.01);
                    end;

                    if recGenLine."Currency Code" <> '' then begin
                        recReportData."Currency Code" := recGenLine."Currency Code";
                        if recGenLine."Document Type" = recGenLine."Document Type"::Payment then
                            recReportData."Amount (LCY)" := Abs(recGenLine.Amount) - decTDSFCYAmount
                        else
                            recReportData."Amount (LCY)" := Abs(recGenLine.Amount);
                    end;

                    decTempValue := recReportData.Amount;
                    recReportData."Created By" := recGenLine."Created By";
                    recReportData."Approved By" := recGenLine."Approved By";
                    recReportData."Posted By" := recGenLine."Posted By";
                    recReportData.Insert();

                    FillDimensionSetEntry(recGenLine."Dimension Set ID", recReportData, recGenLine."Document No.", recGenLine."Posting Date",
                                                            recGenLine."External Document No.", recGenLine."Document Date", decTempValue, 0);
                end;

                if decTDSAmount <> 0 then begin
                    recReportData.Init();
                    intLineNo += 1;
                    recReportData."Line No." := intLineNo;
                    recReportData."Document No." := recGenLine."Document No.";
                    recReportData."Posting Date" := recGenLine."Posting Date";
                    recReportData."External Document No." := recGenLine."External Document No.";
                    recReportData."Document Date" := recGenLine."Document Date";
                    recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                    recReportData."Account No." := 'TDS';
                    recReportData.Description := 'TDS Payable Account';
                    recReportData."Debit Amount" := 0;
                    recReportData."Credit Amount" := decTDSAmount;
                    recReportData.Amount := -decTDSAmount;

                    if recGenLine."Currency Code" <> '' then begin
                        recReportData."Currency Code" := recGenLine."Currency Code";
                        recReportData."Amount (LCY)" := decTDSFCYAmount;
                    end;
                    recReportData."Created By" := recGenLine."Created By";
                    recReportData."Approved By" := recGenLine."Approved By";
                    recReportData."Posted By" := recGenLine."Posted By";
                    recReportData.Insert();

                    FillDimensionSetEntry(recGenLine."Dimension Set ID", recReportData, recGenLine."Document No.", recGenLine."Posting Date",
                                                            recGenLine."External Document No.", recGenLine."Document Date", -decTDSAmount, 0);
                end;
            until recGenLine.Next() = 0;

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

    local procedure FillPurchaseLine()
    var
        recPurchaseHeader: Record "Purchase Header";
        recPurchaseLine: Record "Purchase Line";
        recReportData: Record "Gen. Journal Line" temporary;
        decTotalInvAmount: Decimal;
        decIGSTAmount: Decimal;
        decCGSTAmount: Decimal;
        decSGSTAmount: Decimal;
        decTempValue: Decimal;
        decCurrencyFactor: Decimal;
        decTDSAmount: Decimal;
        decTDSFCYAmount: Decimal;
        decTempValue1: Decimal;
        decIGSTFCYAmount: Decimal;
        decCGSTFCYAmount: Decimal;
        decSGSTFCYAmount: Decimal;
        decTotalFCYAmount: Decimal;
        recPurchComments: Record "Purch. Comment Line";
        decRCMIGSTAmt: Decimal;
        decRCMCGSTAmount: Decimal;
        decRCMSGSTAmount: Decimal;
        decRCMFCYIGSTAmt: Decimal;
        decRCMFCYCGSTAmount: Decimal;
        decRCMFCYSGSTAmount: Decimal;
        recGSTGroup: Record "GST Group";
    begin
        if txtDocumentType in ['PI', 'PO'] then
            txtHeding := 'Test Report - Purchase Invoice Voucher';
        if txtDocumentType in ['PRO', 'PCM'] then
            txtHeding := 'Test Report - Purchase Credit Memo Voucher';

        recPurchaseHeader.Reset();
        if txtDocumentType = 'PI' then
            recPurchaseHeader.SetRange("Document Type", recPurchaseHeader."Document Type"::Invoice);
        if txtDocumentType = 'PO' then
            recPurchaseHeader.SetRange("Document Type", recPurchaseHeader."Document Type"::Order);
        if txtDocumentType = 'PCM' then
            recPurchaseHeader.SetRange("Document Type", recPurchaseHeader."Document Type"::"Credit Memo");
        if txtDocumentType = 'PRO' then
            recPurchaseHeader.SetRange("Document Type", recPurchaseHeader."Document Type"::"Return Order");
        recPurchaseHeader.SetRange("No.", cdDocumentNo);
        recPurchaseHeader.FindFirst();
        if recPurchaseHeader."Currency Code" <> '' then begin
            decCurrencyFactor := 1 / recPurchaseHeader."Currency Factor";
            txtCurrencyAmtCaption := 'FCY Amt.';
            txtCurrencyCaption := 'Currency';
        end else begin
            decCurrencyFactor := 1;
            txtCurrencyAmtCaption := '   ';
            txtCurrencyCaption := '   ';
        end;

        recLocation.Get(recPurchaseHeader."Location Code");
        txtCompanyAddress := recLocation.Address + ' ' + recLocation."Address 2" + ' ' + recLocation.City +
                             ' ' + recLocation."Post Code";
        if recState.Get(recLocation."State Code") then
            txtCompanyAddress := txtCompanyAddress + ', ' + recState.Description;
        if recCountry.Get(recLocation."Country/Region Code") then
            txtCompanyAddress := txtCompanyAddress + ', ' + recCountry.Name;

        txtNarration := '';
        recPurchComments.Reset();
        recPurchComments.SetRange("Document Type", recPurchaseHeader."Document Type");
        recPurchComments.SetRange("No.", recPurchaseHeader."No.");
        recPurchComments.SetRange("Document Line No.", 0);
        if recPurchComments.FindFirst() then begin
            repeat
                txtNarration := txtNarration + ' ' + recPurchComments.Comment;
            until recPurchComments.Next() = 0;
        end;

        recReportData.Reset();
        recReportData.DeleteAll();

        recPurchaseLine.Reset();
        recPurchaseLine.SetRange("Document Type", recPurchaseHeader."Document Type");
        recPurchaseLine.SetRange("Document No.", cdDocumentNo);
        recPurchaseLine.SetFilter("Qty. to Invoice", '<>%1', 0);
        if recPurchaseLine.FindFirst() then begin
            decTotalInvAmount := 0;
            decTotalFCYAmount := 0;
            decTempValue := 0;
            decIGSTAmount := 0;
            decCGSTAmount := 0;
            decSGSTAmount := 0;
            decIGSTFCYAmount := 0;
            decCGSTFCYAmount := 0;
            decSGSTFCYAmount := 0;
            decTDSAmount := 0;
            decTDSFCYAmount := 0;
            decTempValue1 := 0;
            decRCMCGSTAmount := 0;
            decRCMIGSTAmt := 0;
            decRCMSGSTAmount := 0;
            decRCMFCYCGSTAmount := 0;
            decRCMFCYIGSTAmt := 0;
            decRCMFCYSGSTAmount := 0;

            repeat
                if not recGSTGroup.Get(recPurchaseLine."GST Group Code") then
                    recGSTGroup.Init();

                decTempValue := 0;
                decTempValue1 := 0;
                recTaxTransactions.Reset();
                recTaxTransactions.SetRange("Tax Record ID", recPurchaseLine.RecordId);
                recTaxTransactions.SetRange("Tax Type", 'GST');
                recTaxTransactions.SetRange("Value Type", recTaxTransactions."Value Type"::COMPONENT);
                recTaxTransactions.SetRange("Value ID", 2);
                if recTaxTransactions.FindFirst() then begin
                    decTempValue := recTaxTransactions."Amount (LCY)";
                    decTempValue1 := recTaxTransactions.Amount;
                end;
                decTempValue := Round(decTempValue / recPurchaseLine.Quantity * recPurchaseLine."Qty. to Invoice", 0.01);
                decTempValue1 := Round(decTempValue1 / recPurchaseLine.Quantity * recPurchaseLine."Qty. to Invoice", 0.01);
                decCGSTAmount += decTempValue;
                decCGSTFCYAmount += decTempValue1;
                if recGSTGroup."Reverse Charge" then begin
                    decRCMCGSTAmount += decTempValue;
                    decRCMFCYCGSTAmount += decTempValue1;
                end;

                decTempValue := 0;
                decTempValue1 := 0;
                recTaxTransactions.SetRange("Value ID", 3);
                if recTaxTransactions.FindFirst() then begin
                    decTempValue := recTaxTransactions."Amount (LCY)";
                    decTempValue1 := recTaxTransactions.Amount;
                end;
                decTempValue := Round(decTempValue / recPurchaseLine.Quantity * recPurchaseLine."Qty. to Invoice", 0.01);
                decTempValue1 := Round(decTempValue1 / recPurchaseLine.Quantity * recPurchaseLine."Qty. to Invoice", 0.01);
                decIGSTAmount += decTempValue;
                decIGSTFCYAmount += decTempValue1;
                if recGSTGroup."Reverse Charge" then begin
                    decRCMIGSTAmt += decTempValue;
                    decRCMFCYIGSTAmt += decTempValue1;
                end;

                decTempValue := 0;
                decTempValue1 := 0;
                recTaxTransactions.SetRange("Value ID", 6);
                if recTaxTransactions.FindFirst() then begin
                    decTempValue := recTaxTransactions."Amount (LCY)";
                    decTempValue1 := recTaxTransactions.Amount;
                end;
                decTempValue := Round(decTempValue / recPurchaseLine.Quantity * recPurchaseLine."Qty. to Invoice", 0.01);
                decTempValue1 := Round(decTempValue1 / recPurchaseLine.Quantity * recPurchaseLine."Qty. to Invoice", 0.01);
                decSGSTAmount += decTempValue;
                decCGSTFCYAmount += decTempValue1;
                if recGSTGroup."Reverse Charge" then begin
                    decRCMSGSTAmount += decTempValue;
                    decRCMFCYSGSTAmount += decTempValue1;
                end;

                decTempValue := 0;
                decTempValue1 := 0;
                recTaxTransactions.SetRange("Tax Type", 'TDS');
                recTaxTransactions.SetRange("Value ID", 7);
                if recTaxTransactions.FindFirst() then begin
                    decTempValue := recTaxTransactions."Amount (LCY)";
                    decTempValue1 := recTaxTransactions.Amount;
                end;
                decTempValue := Round(decTempValue / recPurchaseLine.Quantity * recPurchaseLine."Qty. to Invoice", 0.01);
                decTempValue1 := Round(decTempValue1 / recPurchaseLine.Quantity * recPurchaseLine."Qty. to Invoice", 0.01);
                decTDSAmount += decTempValue;
                decTDSFCYAmount += decTempValue1;

                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recPurchaseLine."Document No.";
                recReportData."Posting Date" := recPurchaseHeader."Posting Date";
                recReportData."External Document No." := recPurchaseHeader."Vendor Invoice No.";
                recReportData."Document Date" := recPurchaseHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := GetSalesAccount(recPurchaseLine.Type, recPurchaseLine."No.", recPurchaseLine."Gen. Bus. Posting Group", recPurchaseLine."Gen. Prod. Posting Group");
                recReportData.Description := recPurchaseLine."No." + ' - ' + recPurchaseLine.Description;

                if txtDocumentType in ['PRO', 'PCM'] then begin
                    recReportData."Credit Amount" := recPurchaseLine."Line Amount" - recPurchaseLine."Inv. Discount Amount";
                    recReportData."Credit Amount" := Round(recReportData."Credit Amount" / recPurchaseLine.Quantity * recPurchaseLine."Qty. to Invoice", 0.01);

                    if recPurchaseHeader."Currency Code" <> '' then begin
                        recReportData."Currency Code" := recPurchaseHeader."Currency Code";
                        recReportData."Amount (LCY)" := recReportData."Credit Amount";
                    end;

                    recReportData.Amount := -recReportData."Credit Amount";
                end;
                if txtDocumentType in ['PI', 'PO'] then begin
                    recReportData."Debit Amount" := recPurchaseLine."Line Amount" - recPurchaseLine."Inv. Discount Amount";
                    recReportData."Debit Amount" := Round(recReportData."Debit Amount" / recPurchaseLine.Quantity * recPurchaseLine."Qty. to Invoice", 0.01);

                    if recPurchaseHeader."Currency Code" <> '' then begin
                        recReportData."Currency Code" := recPurchaseHeader."Currency Code";
                        recReportData."Amount (LCY)" := recReportData."Debit Amount";
                    end;

                    recReportData.Amount := recReportData."Debit Amount";
                end;
                decTotalFCYAmount += recReportData."Debit Amount" + recReportData."Credit Amount";

                recReportData."Credit Amount" := Round(recReportData."Credit Amount" * decCurrencyFactor, 0.01);
                recReportData."Debit Amount" := Round(recReportData."Debit Amount" * decCurrencyFactor, 0.01);
                recReportData."Amount" := Round(recReportData."Amount" * decCurrencyFactor, 0.01);
                decTempValue := recReportData.Amount;
                recReportData."Created By" := recPurchaseHeader."Created By";
                recReportData."Approved By" := recPurchaseHeader."Approved By";
                recReportData."Posted By" := recPurchaseHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recPurchaseLine."Dimension Set ID", recReportData, recPurchaseLine."Document No.", recPurchaseHeader."Posting Date",
                                                    recPurchaseHeader."Vendor Invoice No.", recPurchaseHeader."Document Date", decTempValue, 0);

                decTotalInvAmount += recReportData.Amount;
            until recPurchaseLine.Next() = 0;

            if decIGSTAmount <> 0 then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recPurchaseLine."Document No.";
                recReportData."Posting Date" := recPurchaseHeader."Posting Date";
                recReportData."External Document No." := recPurchaseHeader."Vendor Invoice No.";
                recReportData."Document Date" := recPurchaseHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := 'GST';
                recReportData.Description := 'IGST Receivable Account';

                if txtDocumentType in ['PRO', 'PCM'] then begin
                    recReportData."Credit Amount" := decIGSTAmount;
                    recReportData.Amount := -recReportData."Credit Amount";
                end;
                if txtDocumentType in ['PI', 'PO'] then begin
                    recReportData."Debit Amount" := decIGSTAmount;
                    recReportData.Amount := recReportData."Debit Amount";
                end;

                if recPurchaseHeader."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recPurchaseHeader."Currency Code";
                    recReportData."Amount (LCY)" := decIGSTFCYAmount;
                end;

                decTempValue := recReportData.Amount;
                recReportData."Created By" := recPurchaseHeader."Created By";
                recReportData."Approved By" := recPurchaseHeader."Approved By";
                recReportData."Posted By" := recPurchaseHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recPurchaseLine."Dimension Set ID", recReportData, recPurchaseLine."Document No.", recPurchaseHeader."Posting Date",
                                                    recPurchaseHeader."Vendor Invoice No.", recPurchaseHeader."Document Date", decTempValue, 0);

                decTotalInvAmount += recReportData.Amount;
                decTotalFCYAmount += decIGSTFCYAmount;
            end;
            if decRCMIGSTAmt <> 0 then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recPurchaseLine."Document No.";
                recReportData."Posting Date" := recPurchaseHeader."Posting Date";
                recReportData."External Document No." := recPurchaseHeader."Vendor Invoice No.";
                recReportData."Document Date" := recPurchaseHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := 'GST';
                recReportData.Description := 'IGST Payable Account';

                if txtDocumentType in ['PI', 'PO'] then begin
                    recReportData."Credit Amount" := decRCMIGSTAmt;
                    recReportData.Amount := -recReportData."Credit Amount";
                end;
                if txtDocumentType in ['PRO', 'PCM'] then begin
                    recReportData."Debit Amount" := decRCMIGSTAmt;
                    recReportData.Amount := recReportData."Debit Amount";
                end;

                if recPurchaseHeader."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recPurchaseHeader."Currency Code";
                    recReportData."Amount (LCY)" := decRCMFCYIGSTAmt;
                end;

                decTempValue := recReportData.Amount;
                recReportData."Created By" := recPurchaseHeader."Created By";
                recReportData."Approved By" := recPurchaseHeader."Approved By";
                recReportData."Posted By" := recPurchaseHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recPurchaseLine."Dimension Set ID", recReportData, recPurchaseLine."Document No.", recPurchaseHeader."Posting Date",
                                                    recPurchaseHeader."Vendor Invoice No.", recPurchaseHeader."Document Date", decTempValue, 0);

                decTotalInvAmount += recReportData.Amount;
                decTotalFCYAmount -= decRCMFCYIGSTAmt;
            end;

            if decCGSTAmount <> 0 then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recPurchaseLine."Document No.";
                recReportData."Posting Date" := recPurchaseHeader."Posting Date";
                recReportData."External Document No." := recPurchaseHeader."Vendor Invoice No.";
                recReportData."Document Date" := recPurchaseHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := 'GST';
                recReportData.Description := 'CGST Receivable Account';

                if txtDocumentType in ['PRO', 'PCM'] then begin
                    recReportData."Credit Amount" := decCGSTAmount;
                    recReportData.Amount := -recReportData."Credit Amount";
                end;
                if txtDocumentType in ['PI', 'PO'] then begin
                    recReportData."Debit Amount" := decCGSTAmount;
                    recReportData.Amount := recReportData."Debit Amount";
                end;

                if recPurchaseHeader."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recPurchaseHeader."Currency Code";
                    recReportData."Amount (LCY)" := decCGSTFCYAmount;
                end;

                decTempValue := recReportData.Amount;
                recReportData."Data Exch. Line No." := -1;
                recReportData."Created By" := recPurchaseHeader."Created By";
                recReportData."Approved By" := recPurchaseHeader."Approved By";
                recReportData."Posted By" := recPurchaseHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recPurchaseLine."Dimension Set ID", recReportData, recPurchaseLine."Document No.", recPurchaseHeader."Posting Date",
                                                    recPurchaseHeader."Vendor Invoice No.", recPurchaseHeader."Document Date", decTempValue, -1);

                decTotalInvAmount += recReportData.Amount;
                decTotalFCYAmount += decCGSTFCYAmount;
            end;
            if decRCMCGSTAmount <> 0 then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recPurchaseLine."Document No.";
                recReportData."Posting Date" := recPurchaseHeader."Posting Date";
                recReportData."External Document No." := recPurchaseHeader."Vendor Invoice No.";
                recReportData."Document Date" := recPurchaseHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := 'GST';
                recReportData.Description := 'CGST Payable Account';

                if txtDocumentType in ['PI', 'PO'] then begin
                    recReportData."Credit Amount" := decRCMCGSTAmount;
                    recReportData.Amount := -recReportData."Credit Amount";
                end;
                if txtDocumentType in ['PRO', 'PCM'] then begin
                    recReportData."Debit Amount" := decRCMCGSTAmount;
                    recReportData.Amount := recReportData."Debit Amount";
                end;

                if recPurchaseHeader."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recPurchaseHeader."Currency Code";
                    recReportData."Amount (LCY)" := decRCMFCYCGSTAmount;
                end;

                decTempValue := recReportData.Amount;
                recReportData."Data Exch. Line No." := -1;
                recReportData."Created By" := recPurchaseHeader."Created By";
                recReportData."Approved By" := recPurchaseHeader."Approved By";
                recReportData."Posted By" := recPurchaseHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recPurchaseLine."Dimension Set ID", recReportData, recPurchaseLine."Document No.", recPurchaseHeader."Posting Date",
                                                    recPurchaseHeader."Vendor Invoice No.", recPurchaseHeader."Document Date", decTempValue, -1);

                decTotalInvAmount += recReportData.Amount;
                decTotalFCYAmount -= decRCMFCYCGSTAmount;
            end;

            if decSGSTAmount <> 0 then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recPurchaseLine."Document No.";
                recReportData."Posting Date" := recPurchaseHeader."Posting Date";
                recReportData."External Document No." := recPurchaseHeader."Vendor Invoice No.";
                recReportData."Document Date" := recPurchaseHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := 'GST';
                recReportData.Description := 'SGST Receivable Account';

                if txtDocumentType in ['PRO', 'PCM'] then begin
                    recReportData."Credit Amount" := decSGSTAmount;
                    recReportData.Amount := -recReportData."Credit Amount";
                end;
                if txtDocumentType in ['PI', 'PO'] then begin
                    recReportData."Debit Amount" := decSGSTAmount;
                    recReportData.Amount := recReportData."Debit Amount";
                end;

                if recPurchaseHeader."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recPurchaseHeader."Currency Code";
                    recReportData."Amount (LCY)" := decSGSTFCYAmount;
                end;

                decTempValue := recReportData.Amount;
                recReportData."Data Exch. Line No." := -2;
                recReportData."Created By" := recPurchaseHeader."Created By";
                recReportData."Approved By" := recPurchaseHeader."Approved By";
                recReportData."Posted By" := recPurchaseHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recPurchaseLine."Dimension Set ID", recReportData, recPurchaseLine."Document No.", recPurchaseHeader."Posting Date",
                                                    recPurchaseHeader."Vendor Invoice No.", recPurchaseHeader."Document Date", decTempValue, -2);

                decTotalInvAmount += recReportData.Amount;
                decTotalFCYAmount += decSGSTFCYAmount;
            end;
            if decRCMSGSTAmount <> 0 then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recPurchaseLine."Document No.";
                recReportData."Posting Date" := recPurchaseHeader."Posting Date";
                recReportData."External Document No." := recPurchaseHeader."Vendor Invoice No.";
                recReportData."Document Date" := recPurchaseHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := 'GST';
                recReportData.Description := 'SGST Payable Account';

                if txtDocumentType in ['PI', 'PO'] then begin
                    recReportData."Credit Amount" := decRCMSGSTAmount;
                    recReportData.Amount := -recReportData."Credit Amount";
                end;
                if txtDocumentType in ['PRO', 'PCM'] then begin
                    recReportData."Debit Amount" := decRCMSGSTAmount;
                    recReportData.Amount := recReportData."Debit Amount";
                end;

                if recPurchaseHeader."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recPurchaseHeader."Currency Code";
                    recReportData."Amount (LCY)" := decRCMFCYSGSTAmount;
                end;

                decTempValue := recReportData.Amount;
                recReportData."Data Exch. Line No." := -2;
                recReportData."Created By" := recPurchaseHeader."Created By";
                recReportData."Approved By" := recPurchaseHeader."Approved By";
                recReportData."Posted By" := recPurchaseHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recPurchaseLine."Dimension Set ID", recReportData, recPurchaseLine."Document No.", recPurchaseHeader."Posting Date",
                                                    recPurchaseHeader."Vendor Invoice No.", recPurchaseHeader."Document Date", decTempValue, -2);

                decTotalInvAmount += recReportData.Amount;
                decTotalFCYAmount -= decRCMFCYSGSTAmount;
            end;

            if decTDSAmount <> 0 then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recPurchaseLine."Document No.";
                recReportData."Posting Date" := recPurchaseHeader."Posting Date";
                recReportData."External Document No." := recPurchaseHeader."Vendor Invoice No.";
                recReportData."Document Date" := recPurchaseHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := 'TDS';
                recReportData.Description := 'TDS Payable Account';

                if txtDocumentType in ['PI', 'PO'] then begin
                    recReportData."Credit Amount" := decTDSAmount;
                    recReportData.Amount := -recReportData."Credit Amount";
                end else begin
                    recReportData."Debit Amount" := decTDSAmount;
                    recReportData.Amount := recReportData."Debit Amount";
                end;

                if recPurchaseHeader."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recPurchaseHeader."Currency Code";
                    recReportData."Amount (LCY)" := decTDSFCYAmount;
                end;

                decTempValue := recReportData.Amount;
                recReportData."Created By" := recPurchaseHeader."Created By";
                recReportData."Approved By" := recPurchaseHeader."Approved By";
                recReportData."Posted By" := recPurchaseHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recPurchaseLine."Dimension Set ID", recReportData, recPurchaseLine."Document No.", recPurchaseHeader."Posting Date",
                                                    recPurchaseHeader."Vendor Invoice No.", recPurchaseHeader."Document Date", decTempValue, 0);

                decTotalInvAmount += recReportData.Amount;
                decTotalFCYAmount -= decTDSFCYAmount;
            end;

            if decTotalInvAmount <> 0 then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recPurchaseLine."Document No.";
                recReportData."Posting Date" := recPurchaseHeader."Posting Date";
                recReportData."External Document No." := recPurchaseHeader."Vendor Invoice No.";
                recReportData."Document Date" := recPurchaseHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::Vendor;
                recReportData."Account No." := GetGLAccountNo(recReportData."Account Type", recPurchaseHeader."Buy-from Vendor No.");
                recReportData.Description := recPurchaseHeader."Buy-from Vendor No." + ' - ' + recPurchaseHeader."Buy-from Vendor Name";

                if txtDocumentType in ['PRO', 'PCM'] then begin
                    recReportData."Debit Amount" := -decTotalInvAmount;
                    recReportData.Amount := recReportData."Debit Amount";
                end;
                if txtDocumentType in ['PI', 'PO'] then begin
                    recReportData."Credit Amount" := decTotalInvAmount;
                    recReportData.Amount := -recReportData."Credit Amount";
                end;

                if recPurchaseHeader."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recPurchaseHeader."Currency Code";
                    recReportData."Amount (LCY)" := decTotalFCYAmount;
                end;

                decTempValue := recReportData.Amount;
                recReportData."Created By" := recPurchaseHeader."Created By";
                recReportData."Approved By" := recPurchaseHeader."Approved By";
                recReportData."Posted By" := recPurchaseHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recPurchaseLine."Dimension Set ID", recReportData, recPurchaseLine."Document No.", recPurchaseHeader."Posting Date",
                                                    recPurchaseHeader."Vendor Invoice No.", recPurchaseHeader."Document Date", decTempValue, 0);
            end;

            intLineNo := 0;
            recReportData.Reset();
            recReportData.SetCurrentKey(Amount, "Data Exch. Line No.", "Data Exch. Entry No.");
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

    local procedure FillSalesLine()
    var
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recReportData: Record "Gen. Journal Line" temporary;
        decTotalInvAmount: Decimal;
        decIGSTAmount: Decimal;
        decCGSTAmount: Decimal;
        decSGSTAmount: Decimal;
        decTempValue: Decimal;
        decCurrencyFactor: Decimal;
        decTDSAmount: Decimal;
        decTDSFCYAmount: Decimal;
        decTempValue1: Decimal;
        decIGSTFCYAmount: Decimal;
        decCGSTFCYAmount: Decimal;
        decSGSTFCYAmount: Decimal;
        decTotalFCYAmount: Decimal;
        recSalesComment: Record "Sales Comment Line";
    begin
        if txtDocumentType in ['SI', 'SO'] then
            txtHeding := 'Test Report - Sales Invoice Voucher';
        if txtDocumentType in ['SRO', 'SCM'] then
            txtHeding := 'Test Report - Sales Credit Memo Voucher';

        recSalesHeader.Reset();
        if txtDocumentType = 'SI' then
            recSalesHeader.SetRange("Document Type", recSalesHeader."Document Type"::Invoice);
        if txtDocumentType = 'SO' then
            recSalesHeader.SetRange("Document Type", recSalesHeader."Document Type"::Order);
        if txtDocumentType = 'SCM' then
            recSalesHeader.SetRange("Document Type", recSalesHeader."Document Type"::"Credit Memo");
        if txtDocumentType = 'SRO' then
            recSalesHeader.SetRange("Document Type", recSalesHeader."Document Type"::"Return Order");
        recSalesHeader.SetRange("No.", cdDocumentNo);
        recSalesHeader.FindFirst();
        if recSalesHeader."Currency Code" <> '' then begin
            decCurrencyFactor := 1 / recSalesHeader."Currency Factor";
            txtCurrencyAmtCaption := 'FCY Amt.';
            txtCurrencyCaption := 'Currency';
        end else begin
            decCurrencyFactor := 1;
            txtCurrencyAmtCaption := '   ';
            txtCurrencyCaption := '   ';
        end;

        recLocation.Get(recSalesHeader."Location Code");
        txtCompanyAddress := recLocation.Address + ' ' + recLocation."Address 2" + ' ' + recLocation.City +
                             ' ' + recLocation."Post Code";
        if recState.Get(recLocation."State Code") then
            txtCompanyAddress := txtCompanyAddress + ', ' + recState.Description;
        if recCountry.Get(recLocation."Country/Region Code") then
            txtCompanyAddress := txtCompanyAddress + ', ' + recCountry.Name;

        txtNarration := '';
        recSalesComment.Reset();
        recSalesComment.SetRange("Document Type", recSalesHeader."Document Type");
        recSalesComment.SetRange("No.", recSalesHeader."No.");
        recSalesComment.SetRange("Document Line No.", 0);
        if recSalesComment.FindFirst() then begin
            repeat
                txtNarration := txtNarration + ' ' + recSalesComment.Comment;
            until recSalesComment.Next() = 0;
        end;

        recReportData.Reset();
        recReportData.DeleteAll();

        recSalesLine.Reset();
        recSalesLine.SetRange("Document Type", recSalesHeader."Document Type");
        recSalesLine.SetRange("Document No.", cdDocumentNo);
        recSalesLine.SetFilter("Qty. to Invoice", '<>%1', 0);
        if recSalesLine.FindFirst() then begin
            decTotalInvAmount := 0;
            decTotalFCYAmount := 0;
            decTempValue := 0;
            decIGSTAmount := 0;
            decCGSTAmount := 0;
            decSGSTAmount := 0;
            decIGSTFCYAmount := 0;
            decCGSTFCYAmount := 0;
            decSGSTFCYAmount := 0;
            decTDSAmount := 0;
            decTDSFCYAmount := 0;
            decTempValue1 := 0;

            repeat
                decTempValue := 0;
                decTempValue1 := 0;
                recTaxTransactions.Reset();
                recTaxTransactions.SetRange("Tax Record ID", recSalesLine.RecordId);
                recTaxTransactions.SetRange("Tax Type", 'GST');
                recTaxTransactions.SetRange("Value Type", recTaxTransactions."Value Type"::COMPONENT);
                recTaxTransactions.SetRange("Value ID", 2);
                if recTaxTransactions.FindFirst() then begin
                    decTempValue := recTaxTransactions."Amount (LCY)";
                    decTempValue1 := recTaxTransactions.Amount;
                end;
                decTempValue := Round(decTempValue / recSalesLine.Quantity * recSalesLine."Qty. to Invoice", 0.01);
                decTempValue1 := Round(decTempValue1 / recSalesLine.Quantity * recSalesLine."Qty. to Invoice", 0.01);
                decCGSTAmount += decTempValue;
                decCGSTFCYAmount += decTempValue1;

                decTempValue := 0;
                decTempValue1 := 0;
                recTaxTransactions.SetRange("Value ID", 3);
                if recTaxTransactions.FindFirst() then begin
                    decTempValue := recTaxTransactions."Amount (LCY)";
                    decTempValue1 := recTaxTransactions.Amount;
                end;
                decTempValue := Round(decTempValue / recSalesLine.Quantity * recSalesLine."Qty. to Invoice", 0.01);
                decTempValue1 := Round(decTempValue1 / recSalesLine.Quantity * recSalesLine."Qty. to Invoice", 0.01);
                decIGSTAmount += decTempValue;
                decIGSTFCYAmount += decTempValue1;

                decTempValue := 0;
                decTempValue1 := 0;
                recTaxTransactions.SetRange("Value ID", 6);
                if recTaxTransactions.FindFirst() then begin
                    decTempValue := recTaxTransactions."Amount (LCY)";
                    decTempValue1 := recTaxTransactions.Amount;
                end;
                decTempValue := Round(decTempValue / recSalesLine.Quantity * recSalesLine."Qty. to Invoice", 0.01);
                decTempValue1 := Round(decTempValue1 / recSalesLine.Quantity * recSalesLine."Qty. to Invoice", 0.01);
                decSGSTAmount += decTempValue;
                decCGSTFCYAmount += decTempValue1;

                decTempValue := 0;
                decTempValue1 := 0;
                recTaxTransactions.SetRange("Tax Type", 'TCS');
                recTaxTransactions.SetRange("Value ID", 7);
                if recTaxTransactions.FindFirst() then begin
                    decTempValue := recTaxTransactions."Amount (LCY)";
                    decTempValue1 := recTaxTransactions.Amount;
                end;
                decTempValue := Round(decTempValue / recSalesLine.Quantity * recSalesLine."Qty. to Invoice", 0.01);
                decTempValue1 := Round(decTempValue1 / recSalesLine.Quantity * recSalesLine."Qty. to Invoice", 0.01);
                decTDSAmount += decTempValue;
                decTDSFCYAmount += decTempValue1;

                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recSalesLine."Document No.";
                recReportData."Posting Date" := recSalesHeader."Posting Date";
                if recSalesHeader."Your Reference" <> '' then
                    recReportData."External Document No." := recSalesHeader."Your Reference"
                else
                    recReportData."External Document No." := recSalesHeader."External Document No.";
                recReportData."Document Date" := recSalesHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := GetSalesAccount(recSalesLine.Type, recSalesLine."No.", recSalesLine."Gen. Bus. Posting Group", recSalesLine."Gen. Prod. Posting Group");

                recReportData.Description := recSalesLine."No." + ' - ' + recSalesLine.Description;

                if txtDocumentType in ['SI', 'SO'] then begin
                    recReportData."Credit Amount" := recSalesLine."Line Amount" - recSalesLine."Inv. Discount Amount";
                    recReportData."Credit Amount" := Round(recReportData."Credit Amount" / recSalesLine.Quantity * recSalesLine."Qty. to Invoice", 0.01);
                    recReportData.Amount := -recReportData."Credit Amount";

                    if recSalesHeader."Currency Code" <> '' then begin
                        recReportData."Currency Code" := recSalesHeader."Currency Code";
                        recReportData."Amount (LCY)" := recReportData."Credit Amount";
                    end;
                end;
                if txtDocumentType in ['SRO', 'SCM'] then begin
                    recReportData."Debit Amount" := recSalesLine."Line Amount" - recSalesLine."Inv. Discount Amount";
                    recReportData."Debit Amount" := Round(recReportData."Debit Amount" / recSalesLine.Quantity * recSalesLine."Qty. to Invoice", 0.01);
                    recReportData.Amount := recReportData."Debit Amount";

                    if recSalesHeader."Currency Code" <> '' then begin
                        recReportData."Currency Code" := recSalesHeader."Currency Code";
                        recReportData."Amount (LCY)" := recReportData."Debit Amount";
                    end;
                end;
                decTotalFCYAmount += recReportData."Debit Amount" + recReportData."Credit Amount";

                recReportData."Credit Amount" := Round(recReportData."Credit Amount" * decCurrencyFactor, 0.01);
                recReportData."Debit Amount" := Round(recReportData."Debit Amount" * decCurrencyFactor, 0.01);
                recReportData."Amount" := Round(recReportData."Amount" * decCurrencyFactor, 0.01);
                decTempValue := recReportData.Amount;
                recReportData."Created By" := recSalesHeader."Created By";
                recReportData."Approved By" := recSalesHeader."Approved By";
                recReportData."Posted By" := recSalesHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recSalesLine."Dimension Set ID", recReportData, recSalesHeader."No.", recSalesHeader."Posting Date",
                                                    recSalesHeader."External Document No.", recSalesHeader."Document Date", decTempValue, 0);

                decTotalInvAmount += recReportData.Amount;
            until recSalesLine.Next() = 0;

            if decIGSTAmount <> 0 then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recSalesLine."Document No.";
                recReportData."Posting Date" := recSalesHeader."Posting Date";
                if recSalesHeader."Your Reference" <> '' then
                    recReportData."External Document No." := recSalesHeader."Your Reference"
                else
                    recReportData."External Document No." := recSalesHeader."External Document No.";
                recReportData."Document Date" := recSalesHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := 'GST';
                recReportData.Description := 'IGST Payable Account';

                if txtDocumentType in ['SI', 'SO'] then begin
                    recReportData."Credit Amount" := decIGSTAmount;
                    recReportData.Amount := -recReportData."Credit Amount";
                end;
                if txtDocumentType in ['SRO', 'SCM'] then begin
                    recReportData."Debit Amount" := decIGSTAmount;
                    recReportData.Amount := recReportData."Debit Amount";
                end;

                if recSalesHeader."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recSalesHeader."Currency Code";
                    recReportData."Amount (LCY)" := decIGSTFCYAmount;
                end;

                decTempValue := recReportData.Amount;
                recReportData."Created By" := recSalesHeader."Created By";
                recReportData."Approved By" := recSalesHeader."Approved By";
                recReportData."Posted By" := recSalesHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recSalesLine."Dimension Set ID", recReportData, recSalesHeader."No.", recSalesHeader."Posting Date",
                                                    recSalesHeader."External Document No.", recSalesHeader."Document Date", decTempValue, 0);

                decTotalInvAmount += recReportData.Amount;
                decTotalFCYAmount += decIGSTFCYAmount;
            end;

            if decCGSTAmount <> 0 then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recSalesLine."Document No.";
                recReportData."Posting Date" := recSalesHeader."Posting Date";
                if recSalesHeader."Your Reference" <> '' then
                    recReportData."External Document No." := recSalesHeader."Your Reference"
                else
                    recReportData."External Document No." := recSalesHeader."External Document No.";
                recReportData."Document Date" := recSalesHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := 'GST';
                recReportData.Description := 'CGST Payable Account';

                if txtDocumentType in ['SI', 'SO'] then begin
                    recReportData."Credit Amount" := decCGSTAmount;
                    recReportData.Amount := -recReportData."Credit Amount";
                end;
                if txtDocumentType in ['SRO', 'SCM'] then begin
                    recReportData."Debit Amount" := decCGSTAmount;
                    recReportData.Amount := recReportData."Debit Amount";
                end;

                if recSalesHeader."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recSalesHeader."Currency Code";
                    recReportData."Amount (LCY)" := decCGSTFCYAmount;
                end;

                decTempValue := recReportData.Amount;
                recReportData."Data Exch. Line No." := -1;
                recReportData."Created By" := recSalesHeader."Created By";
                recReportData."Approved By" := recSalesHeader."Approved By";
                recReportData."Posted By" := recSalesHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recSalesLine."Dimension Set ID", recReportData, recSalesHeader."No.", recSalesHeader."Posting Date",
                                                    recSalesHeader."External Document No.", recSalesHeader."Document Date", decTempValue, -1);

                decTotalInvAmount += recReportData.Amount;
                decTotalFCYAmount += decCGSTFCYAmount;
            end;

            if decSGSTAmount <> 0 then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recSalesLine."Document No.";
                recReportData."Posting Date" := recSalesHeader."Posting Date";
                if recSalesHeader."Your Reference" <> '' then
                    recReportData."External Document No." := recSalesHeader."Your Reference"
                else
                    recReportData."External Document No." := recSalesHeader."External Document No.";
                recReportData."Document Date" := recSalesHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := 'GST';
                recReportData.Description := 'SGST Payable Account';

                if txtDocumentType in ['SI', 'SO'] then begin
                    recReportData."Credit Amount" := decSGSTAmount;
                    recReportData.Amount := -recReportData."Credit Amount";
                end;
                if txtDocumentType in ['SRO', 'SCM'] then begin
                    recReportData."Debit Amount" := decSGSTAmount;
                    recReportData.Amount := recReportData."Debit Amount";
                end;

                if recSalesHeader."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recSalesHeader."Currency Code";
                    recReportData."Amount (LCY)" := decSGSTFCYAmount;
                end;

                decTempValue := recReportData.Amount;
                recReportData."Data Exch. Line No." := -2;
                recReportData."Created By" := recSalesHeader."Created By";
                recReportData."Approved By" := recSalesHeader."Approved By";
                recReportData."Posted By" := recSalesHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recSalesLine."Dimension Set ID", recReportData, recSalesHeader."No.", recSalesHeader."Posting Date",
                                                    recSalesHeader."External Document No.", recSalesHeader."Document Date", decTempValue, -2);

                decTotalInvAmount += recReportData.Amount;
                decTotalFCYAmount += decSGSTFCYAmount;
            end;

            if decTDSAmount <> 0 then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recSalesLine."Document No.";
                recReportData."Posting Date" := recSalesHeader."Posting Date";
                recReportData."External Document No." := recSalesHeader."External Document No.";
                recReportData."Document Date" := recSalesHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::"G/L Account";
                recReportData."Account No." := 'TCS';
                recReportData.Description := 'TCS Payable Account';

                if txtDocumentType in ['SI', 'SO'] then begin
                    recReportData."Credit Amount" := decTDSAmount;
                    recReportData.Amount := -recReportData."Credit Amount";
                end;

                if recSalesHeader."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recSalesHeader."Currency Code";
                    recReportData."Amount (LCY)" := decTDSFCYAmount;
                end;

                decTempValue := recReportData.Amount;
                recReportData."Created By" := recSalesHeader."Created By";
                recReportData."Approved By" := recSalesHeader."Approved By";
                recReportData."Posted By" := recSalesHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recSalesLine."Dimension Set ID", recReportData, recSalesLine."Document No.", recSalesHeader."Posting Date",
                                                    recSalesHeader."External Document No.", recSalesHeader."Document Date", decTempValue, 0);

                decTotalInvAmount += recReportData.Amount;
                decTotalFCYAmount += decTDSFCYAmount;
            end;

            if decTotalInvAmount <> 0 then begin
                recReportData.Init();
                intLineNo += 1;
                recReportData."Line No." := intLineNo;
                recReportData."Document No." := recSalesLine."Document No.";
                recReportData."Posting Date" := recSalesHeader."Posting Date";
                if recSalesHeader."Your Reference" <> '' then
                    recReportData."External Document No." := recSalesHeader."Your Reference"
                else
                    recReportData."External Document No." := recSalesHeader."External Document No.";
                recReportData."Document Date" := recSalesHeader."Document Date";

                recReportData."Account Type" := recReportData."Account Type"::Customer;
                recReportData."Account No." := GetGLAccountNo(recReportData."Account Type", recSalesHeader."Bill-to Customer No.");
                recReportData.Description := recSalesHeader."Bill-to Customer No." + ' - ' + recSalesHeader."Bill-to Name";

                if txtDocumentType in ['SI', 'SO'] then begin
                    recReportData."Debit Amount" := -decTotalInvAmount;
                    recReportData.Amount := recReportData."Debit Amount";
                end;
                if txtDocumentType in ['SRO', 'SCM'] then begin
                    recReportData."Credit Amount" := decTotalInvAmount;
                    recReportData.Amount := -recReportData."Credit Amount";
                end;

                if recSalesHeader."Currency Code" <> '' then begin
                    recReportData."Currency Code" := recSalesHeader."Currency Code";
                    recReportData."Amount (LCY)" := decTotalFCYAmount;
                end;

                decTempValue := recReportData.Amount;
                recReportData."Created By" := recSalesHeader."Created By";
                recReportData."Approved By" := recSalesHeader."Approved By";
                recReportData."Posted By" := recSalesHeader."Posted By";
                recReportData.Insert();

                FillDimensionSetEntry(recSalesLine."Dimension Set ID", recReportData, recSalesHeader."No.", recSalesHeader."Posting Date",
                                                    recSalesHeader."External Document No.", recSalesHeader."Document Date", decTempValue, 0);
            end;

            intLineNo := 0;
            recReportData.Reset();
            recReportData.SetCurrentKey(Amount, "Data Exch. Line No.", "Data Exch. Entry No.");
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

    local procedure GetGLAccountNo(AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[20]) GLAccountNo: Code[20]
    var
        recVendor: Record Vendor;
        recVendorPostingGroup: Record "Vendor Posting Group";
        recCustomer: Record Customer;
        recCustomerPostingGroup: Record "Customer Posting Group";
        recBankAccount: Record "Bank Account";
        recBankPostingGroup: Record "Bank Account Posting Group";
        recFADepreciationBook: Record "FA Depreciation Book";
        recFAPostingGroup: Record "FA Posting Group";
        recEmployee: Record Employee;
        recEmployeePostingGroup: Record "Employee Posting Group";

    begin
        GLAccountNo := '';
        if AccountType = AccountType::"G/L Account" then begin
            GLAccountNo := AccountNo;
            exit;
        end;
        if AccountType = AccountType::Customer then begin
            recCustomer.Get(AccountNo);
            recCustomerPostingGroup.Get(recCustomer."Customer Posting Group");
            GLAccountNo := recCustomerPostingGroup."Receivables Account";
            exit;
        end;
        if AccountType = AccountType::Vendor then begin
            recVendor.Get(AccountNo);
            recVendorPostingGroup.Get(recVendor."Vendor Posting Group");
            GLAccountNo := recVendorPostingGroup."Payables Account";
            exit;
        end;
        if AccountType = AccountType::"Bank Account" then begin
            recBankAccount.Get(AccountNo);
            recBankPostingGroup.Get(recBankAccount."Bank Acc. Posting Group");
            GLAccountNo := recBankPostingGroup."G/L Account No.";
            exit;
        end;
        if AccountType = AccountType::"Fixed Asset" then begin
            recFADepreciationBook.Reset();
            recFADepreciationBook.SetRange("FA No.", AccountNo);
            recFADepreciationBook.FindFirst();
            recFAPostingGroup.Get(recFADepreciationBook."FA Posting Group");
            GLAccountNo := recFAPostingGroup."Acquisition Cost Account";
            exit;
        end;
        if AccountType = AccountType::Employee then begin
            recEmployee.Get(AccountNo);
            recEmployeePostingGroup.Get(recEmployee."Employee Posting Group");
            GLAccountNo := recEmployeePostingGroup."Payables Account";
            exit;
        end;
    end;

    local procedure GetSalesAccount(LineItemType: Enum "Sales Line Type"; LineItemNo: Code[20];
                                                      GenBusGroup: Code[20];
                                                      GenProdGroup: Code[20]) GLAccountNo: Code[20];
    var
        recGenPostingSetup: Record "General Posting Setup";
        recFADepreciationBook: Record "FA Depreciation Book";
        recFAPostingGroup: Record "FA Posting Group";

    begin
        if LineItemType = LineItemType::"G/L Account" then begin
            GLAccountNo := LineItemNo;
            exit;
        end;
        if LineItemType = LineItemType::Item then begin
            recGenPostingSetup.Reset();
            recGenPostingSetup.SetRange("Gen. Bus. Posting Group", GenBusGroup);
            recGenPostingSetup.SetRange("Gen. Prod. Posting Group", GenProdGroup);
            recGenPostingSetup.FindFirst();
            GLAccountNo := recGenPostingSetup."Sales Account";
            exit;
        end;
        if LineItemType = LineItemType::"Fixed Asset" then begin
            recFADepreciationBook.Reset();
            recFADepreciationBook.SetRange("FA No.", LineItemNo);
            recFADepreciationBook.FindFirst();
            recFAPostingGroup.Get(recFADepreciationBook."FA Posting Group");
            GLAccountNo := recFAPostingGroup."Accum. Depr. Acc. on Disposal";
            exit;
        end;
        if LineItemType = LineItemType::Resource then begin
            recGenPostingSetup.Reset();
            recGenPostingSetup.SetRange("Gen. Bus. Posting Group", GenBusGroup);
            recGenPostingSetup.SetRange("Gen. Prod. Posting Group", GenProdGroup);
            recGenPostingSetup.FindFirst();
            GLAccountNo := recGenPostingSetup."Sales Account";
            exit;
        end;
        if LineItemType = LineItemType::"Charge (Item)" then begin
            recGenPostingSetup.Reset();
            recGenPostingSetup.SetRange("Gen. Bus. Posting Group", GenBusGroup);
            recGenPostingSetup.SetRange("Gen. Prod. Posting Group", GenProdGroup);
            recGenPostingSetup.FindFirst();
            GLAccountNo := recGenPostingSetup."Sales Account";
            exit;
        end;
    end;

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