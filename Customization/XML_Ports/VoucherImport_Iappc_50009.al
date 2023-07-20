xmlport 50009 "Voucher Import"
{
    Caption = 'Voucher Import';
    //Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    //FieldDelimiter = 'None';
    //FieldSeparator = 'TAB';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(VoucherImport)
        {
            MinOccurs = Zero;
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                AutoSave = false;
                XmlName = 'VoucherImport';

                textelement(DocumentNo)
                {
                    MinOccurs = Zero;
                }
                textelement(PostingDate)
                {
                    MinOccurs = Zero;
                }
                textelement(DocumentType)
                {
                    MinOccurs = Zero;
                }
                //Hemant
                textelement(TransactionNature)
                {
                    MinOccurs = Zero;
                }
                textelement(DocumentDate)
                {
                    MinOccurs = Zero;
                }
                textelement(ExternalDocNo)
                {
                    MinOccurs = Zero;
                }
                textelement(AccountType)
                {
                    MinOccurs = Zero;
                }
                textelement(AccountNo)
                {
                    MinOccurs = Zero;
                }
                // Hemant
                textelement(Description)
                {
                    MinOccurs = Zero;
                }
                textelement(FAPostingType)
                {
                    MinOccurs = Zero;
                }
                textelement(TranAmount)
                {
                    MinOccurs = Zero;
                }
                textelement(SalvageValue)
                {
                    MinOccurs = Zero;
                }
                textelement(CurrencyCode)
                {
                    MinOccurs = Zero;
                }
                textelement(FCYAmount)
                {
                    MinOccurs = Zero;
                }
                textelement(BalAccountType)
                {
                    MinOccurs = Zero;
                }
                textelement(BalAccountNo)
                {
                    MinOccurs = Zero;
                }
                textelement(TDSSection)
                {
                    MinOccurs = Zero;
                }
                textelement(TranNarration)
                {
                    MinOccurs = Zero;
                }
                textelement(AppToDocType)
                {
                    MinOccurs = Zero;
                }
                textelement(AppToDocNo)
                {
                    MinOccurs = Zero;
                }
                textelement(Dimension1)
                {
                    MinOccurs = Zero;
                }
                textelement(Dimension2)
                {
                    MinOccurs = Zero;
                }
                textelement(Dimension3)
                {
                    MinOccurs = Zero;
                }
                textelement(Dimension4)
                {
                    MinOccurs = Zero;
                }
                textelement(Dimension5)
                {
                    MinOccurs = Zero;
                }
                textelement(Dimension6)
                {
                    MinOccurs = Zero;
                }
                textelement(Dimension7)
                {
                    MinOccurs = Zero;
                }
                textelement(Dimension8)
                {
                    MinOccurs = Zero;
                }

                //Hemant
                textelement(TypeOfTransaction)
                {
                    MinOccurs = Zero;
                }
                textelement(PurchOrderNO)
                {
                    MinOccurs = Zero;
                }
                textelement(AdvancePayment)
                {
                    MinOccurs = Zero;
                }
                textelement(UTRNo)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if (intCounter > 1) and (AccountType <> '') then begin
                        recGenLine.INIT;
                        recGenLine.VALIDATE("Journal Template Name", cdTemplateCode);
                        recGenLine.VALIDATE("Journal Batch Name", cdBatchCode);
                        intLineNo += 10000;
                        recGenLine.VALIDATE("Line No.", intLineNo);
                        recGenLine.INSERT(TRUE);

                        recGenLine.RESET;
                        recGenLine.SETRANGE("Journal Template Name", cdTemplateCode);
                        recGenLine.SETRANGE("Journal Batch Name", cdBatchCode);
                        recGenLine.SETRANGE("Line No.", intLineNo);
                        recGenLine.FINDFIRST;

                        EVALUATE(recGenLine."Posting Date", PostingDate);
                        recGenLine.VALIDATE("Posting Date");

                        if DocumentType <> '' then
                            Evaluate(recGenLine."Document Type", DocumentType);
                        recGenLine.Validate("Document Type");

                        if DocumentNo <> '' then
                            cdDocumentNo := DocumentNo;
                        recGenLine.VALIDATE("Document No.", cdDocumentNo);

                        if DocumentDate <> '' then
                            Evaluate(recGenLine."Document Date", DocumentDate);
                        recGenLine.Validate("Document Date");

                        recGenLine."External Document No." := ExternalDocNo;

                        EVALUATE(recGenLine."Account Type", AccountType);
                        recGenLine.VALIDATE("Account Type");
                        recGenLine.VALIDATE("Account No.", AccountNo);
                        //Hemant
                        recGenLine.Description := Description;
                        Evaluate(optTransactionNature, TransactionNature);
                        recGenLine."Transaction Nature" := optTransactionNature;

                        if FAPostingType <> '' then
                            Evaluate(recGenLine."FA Posting Type", FAPostingType);
                        recGenLine.Validate("FA Posting Type");

                        if SalvageValue <> '' then
                            Evaluate(recGenLine."Salvage Value", SalvageValue);
                        recGenLine.Validate("Salvage Value");

                        IF BalAccountType <> '' THEN
                            EVALUATE(recGenLine."Bal. Account Type", BalAccountType);
                        recGenLine.VALIDATE("Bal. Account Type");
                        recGenLine.VALIDATE("Bal. Account No.", BalAccountNo);
                        recGenLine.Validate("Currency Code", CurrencyCode);
                        if CurrencyCode <> '' then begin
                            EVALUATE(recGenLine.Amount, FCYAmount);
                            recGenLine.VALIDATE(Amount);
                            Evaluate(recGenLine."Amount (LCY)", TranAmount);
                            recGenLine.Validate("Amount (LCY)");
                        end else begin
                            EVALUATE(recGenLine.Amount, TranAmount);
                            recGenLine.VALIDATE(Amount);
                        end;

                        if TDSSection <> '' then
                            recGenLine.Validate("TDS Section Code", TDSSection);

                        if AppToDocType <> '' then
                            Evaluate(recGenLine."Applies-to Doc. Type", AppToDocType);
                        recGenLine.Validate("Applies-to Doc. Type");
                        recGenLine.Validate("Applies-to Doc. No.", AppToDocNo);

                        recGenLine.Validate("Shortcut Dimension 1 Code", Dimension1);
                        recGenLine.Validate("Shortcut Dimension 2 Code", Dimension2);
                        cdTempCode := Dimension3;
                        recGenLine.ValidateShortcutDimCode(3, cdTempCode);
                        cdTempCode := Dimension4;
                        recGenLine.ValidateShortcutDimCode(4, cdTempCode);
                        cdTempCode := Dimension5;
                        recGenLine.ValidateShortcutDimCode(5, cdTempCode);
                        cdTempCode := Dimension6;
                        recGenLine.ValidateShortcutDimCode(6, cdTempCode);
                        cdTempCode := Dimension7;
                        recGenLine.ValidateShortcutDimCode(7, cdTempCode);
                        cdTempCode := Dimension8;
                        recGenLine.ValidateShortcutDimCode(8, cdTempCode);
                        //Hemant
                        Evaluate(optTypeOfTransaction, TypeOfTransaction);
                        recGenLine.Validate("Type of Transaction", optTypeOfTransaction);
                        recGenLine.Validate("Purch. Order No.", PurchOrderNO);
                        Evaluate(boolAdvancePayment, AdvancePayment);
                        recGenLine.Validate("Advance Payment", boolAdvancePayment);
                        recGenLine.Validate("UTR No.", UTRNo);
                        recGenLine.MODIFY(TRUE);

                        Clear(cuCalculateTax);
                        cuCalculateTax.CallTaxEngineOnGenJnlLine(recGenLine, recGenLine);

                        if BalAccountNo = '' then
                            decTotalAmount += recGenLine.Amount;
                        if decTotalAmount = 0 then begin
                            if TranNarration <> '' then begin
                                recGenNarration.Reset();
                                recGenNarration.SetRange("Journal Template Name", cdTemplateCode);
                                recGenNarration.SetRange("Journal Batch Name", cdBatchCode);
                                recGenNarration.SetRange("Document No.", cdDocumentNo);
                                recGenNarration.SetRange("Gen. Journal Line No.", 0);
                                if recGenNarration.FindFirst() then
                                    recGenNarration.DeleteAll();

                                recGenNarration.Init();
                                recGenNarration."Journal Template Name" := cdTemplateCode;
                                recGenNarration."Journal Batch Name" := cdBatchCode;
                                recGenNarration."Document No." := cdDocumentNo;
                                recGenNarration."Gen. Journal Line No." := 0;
                                recGenNarration."Line No." := 10000;
                                recGenNarration.Narration := TranNarration;
                                recGenNarration.Insert();
                            end;
                            cdDocumentNo := IncStr(cdDocumentNo);
                        end;
                    end;
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        IF (cdTemplateCode = '') OR (cdBatchCode = '') THEN
            ERROR('The Template or Batch code must not be blank.');

        recGenLine.RESET;
        recGenLine.SETRANGE("Journal Template Name", cdTemplateCode);
        recGenLine.SETRANGE("Journal Batch Name", cdBatchCode);
        IF recGenLine.FINDLAST THEN begin
            intLineNo := recGenLine."Line No.";
            cdDocumentNo := IncStr(recGenLine."Document No.");
        end ELSE begin
            intLineNo := 0;
            recGenBatch.Get(cdTemplateCode, cdBatchCode);
            if recGenBatch."No. Series" <> '' then begin
                recGenBatch.TestField("No. Series");

                recNoSeriesLine.Reset();
                recNoSeriesLine.SetRange("Series Code", recGenBatch."No. Series");
                recNoSeriesLine.SetFilter("Starting Date", '..%1', WorkDate());
                recNoSeriesLine.FindLast();
                if recNoSeriesLine."Last No. Used" = '' then
                    cdDocumentNo := recNoSeriesLine."Starting No."
                else
                    cdDocumentNo := IncStr(recNoSeriesLine."Last No. Used");
            end else
                cdDocumentNo := '1';
        end;

        intCounter := 0;
        decTotalAmount := 0;
    end;

    trigger OnPostXmlPort()
    begin
        MESSAGE('Data has been successfully uploaded');
    end;

    procedure SetTemplateBatch(TemplateCode: Code[10]; BatchName: Code[10])
    begin
        cdTemplateCode := TemplateCode;
        cdBatchCode := BatchName;
    end;

    var
        cdTemplateCode: Code[10];
        cdBatchCode: Code[10];
        recGenLine: Record "Gen. Journal Line";
        intLineNo: Integer;
        intCounter: Integer;
        cdDocumentNo: Code[20];
        recGenBatch: Record "Gen. Journal Batch";
        recNoSeriesLine: Record "No. Series Line";
        decTotalAmount: Decimal;
        cdTempCode: Code[20];
        recGenNarration: Record "Gen. Journal Narration";
        cuCalculateTax: Codeunit "Calculate Tax";
        optTransactionNature: Option " ","Payment","Invoice","Credit Memo","Receipt","Journal","Refund";
        optTypeOfTransaction: Option " ","Purch. Order","Non-Purch. Order";
        boolAdvancePayment: Boolean;
}