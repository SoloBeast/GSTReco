xmlport 50011 "Purchase Document Import"
{
    Caption = 'Purchase Document Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    //FieldDelimiter = 'None';
    //FieldSeparator = 'TAB';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(PurchaseDocImport)
        {
            MinOccurs = Zero;
            tableelement("Purchase Header"; "Purchase Header")
            {
                AutoSave = false;
                XmlName = 'PurchaseDocImport';

                textelement(VendorNo)
                {
                    MinOccurs = Zero;
                }
                textelement(PostingDate)
                {
                    MinOccurs = Zero;
                }
                textelement(ExternalDocNo)
                {
                    MinOccurs = Zero;
                }
                textelement(LocationCode)
                {
                    MinOccurs = Zero;
                }
                textelement(CurrencyCode)
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
                textelement(LineQuantity)
                {
                    MinOccurs = Zero;
                }
                textelement(UnitRate)
                {
                    MinOccurs = Zero;
                }
                textelement(GenProdGroup)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTGroup)
                {
                    MinOccurs = Zero;
                }
                textelement(HSNCode)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTCredit)
                {
                    MinOccurs = Zero;
                }
                textelement(TDSNature)
                {
                    MinOccurs = Zero;
                }
                textelement(HeaderComment)
                {
                    MinOccurs = Zero;
                }
                textelement(LineComment)
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
                textelement(InternalDocType)
                {
                    MinOccurs = Zero;
                }
                textelement(DocumentBasis)
                {
                    MinOccurs = Zero;
                }
                textelement(PurchOrderNo)
                {
                    MinOccurs = Zero;
                }
                textelement(RCMApplicable)
                {
                    MinOccurs = Zero;
                }
                textelement(DueDateCalcBasis)
                {
                    MinOccurs = Zero;
                }
                textelement(InvoiceType)
                {
                    MinOccurs = Zero;
                }
                textelement(ApplyToDocType)
                {
                    MinOccurs = Zero;
                }
                textelement(ApplyToDocNo)
                {
                    MinOccurs = Zero;
                }
                textelement(DocumentDate)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if (intCounter > 1) and (VendorNo <> '') then begin
                        if PostingDate = '' then
                            Error('Posting Date must not be blank for line no. %1', intCounter);
                        Evaluate(dtPostingDate, PostingDate);
                        if (VendorNo <> cdOldVendorNo) or (dtPostingDate <> dtOldPostingDate) or (cdOldVendorInvoiceNo <> ExternalDocNo) then begin
                            recPurchaseHeader.Init();
                            recPurchaseHeader."Document Type" := opDocumentType;
                            recPurchaseHeader."No." := '';
                            recPurchaseHeader.Insert(true);
                            cdDocumentNo := recPurchaseHeader."No.";
                            intLineNo := 0;

                            recPurchaseHeader.Validate("Buy-from Vendor No.", VendorNo);
                            recPurchaseHeader.Validate("Posting Date", dtPostingDate);

                            if opDocumentType in [opDocumentType::Order, opDocumentType::Invoice] then
                                recPurchaseHeader.Validate("Vendor Invoice No.", ExternalDocNo);
                            if opDocumentType in [opDocumentType::"Return Order", opDocumentType::"Credit Memo"] then
                                recPurchaseHeader.Validate("Vendor Cr. Memo No.", ExternalDocNo);
                            recPurchaseHeader.Validate("Location Code", LocationCode);
                            recPurchaseHeader.Validate("Currency Code", CurrencyCode);
                            recPurchaseHeader.Validate("Shortcut Dimension 1 Code", Dimension1);
                            recPurchaseHeader.Validate("Shortcut Dimension 2 Code", Dimension2);
                            Evaluate(optInternalDocType, InternalDocType);
                            recPurchaseHeader.Validate("Internal Document Type", optInternalDocType);
                            Evaluate(optDocumentBasis, DocumentBasis);
                            recPurchaseHeader.Validate("Document Basis", optDocumentBasis);
                            recPurchaseHeader.Validate("Purch. Order No.", PurchOrderNo);
                            Evaluate(optRCMApplicable, RCMApplicable);
                            recPurchaseHeader.Validate("RCM Applicable", optRCMApplicable);
                            Evaluate(DueDateCalcBasis, DueDateCalcBasis);
                            recPurchaseHeader.Validate("Due Date Calc. Basis", optDueDateCalcBasis);
                            Evaluate(enumInvType, InvoiceType);
                            recPurchaseHeader.Validate("Invoice Type", enumInvType);
                            Evaluate(enumApplyToDocType, ApplyToDocType);
                            recPurchaseHeader.Validate("Applies-to Doc. Type", enumApplyToDocType);
                            recPurchaseHeader.Validate("Applies-to Doc. No.", ApplyToDocNo);
                            Evaluate(dtDocumentDate, DocumentDate);
                            recPurchaseHeader.Validate("Document Date", dtDocumentDate);
                            recPurchaseHeader.Modify(true);

                            if HeaderComment <> '' then begin
                                recPurchaseCommentLine.Init();
                                recPurchaseCommentLine."Document Type" := opDocumentType;
                                recPurchaseCommentLine."No." := cdDocumentNo;
                                recPurchaseCommentLine."Document Line No." := 0;
                                recPurchaseCommentLine."Line No." := 10000;
                                recPurchaseCommentLine.Comment := HeaderComment;
                                recPurchaseCommentLine.Insert();
                            end;

                            if (Dimension3 <> '') or (Dimension4 <> '') or (Dimension5 <> '') or (Dimension6 <> '') or (Dimension7 <> '') or (Dimension8 <> '') then begin
                                tempDimensionSetEntry.Reset();
                                tempDimensionSetEntry.DeleteAll();
                                recDimensionSetEntry.Reset();
                                recDimensionSetEntry.SetRange("Dimension Set ID", recPurchaseHeader."Dimension Set ID");
                                if recDimensionSetEntry.FindFirst() then
                                    repeat
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recDimensionSetEntry."Dimension Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", recDimensionSetEntry."Dimension Value Code");
                                        tempDimensionSetEntry.Insert(true);
                                    until recDimensionSetEntry.Next() = 0;

                                if Dimension3 <> '' then begin
                                    tempDimensionSetEntry.Reset();
                                    tempDimensionSetEntry.SetRange("Dimension Code", recGLSetup."Shortcut Dimension 3 Code");
                                    if tempDimensionSetEntry.FindFirst() then begin
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension3);
                                        tempDimensionSetEntry.Modify(true);
                                    end else begin
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recGLSetup."Shortcut Dimension 3 Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension3);
                                        tempDimensionSetEntry.Insert(true);
                                    end;
                                end;
                                if Dimension4 <> '' then begin
                                    tempDimensionSetEntry.Reset();
                                    tempDimensionSetEntry.SetRange("Dimension Code", recGLSetup."Shortcut Dimension 4 Code");
                                    if tempDimensionSetEntry.FindFirst() then begin
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension4);
                                        tempDimensionSetEntry.Modify(true);
                                    end else begin
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recGLSetup."Shortcut Dimension 4 Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension4);
                                        tempDimensionSetEntry.Insert(true);
                                    end;
                                end;
                                if Dimension5 <> '' then begin
                                    tempDimensionSetEntry.Reset();
                                    tempDimensionSetEntry.SetRange("Dimension Code", recGLSetup."Shortcut Dimension 5 Code");
                                    if tempDimensionSetEntry.FindFirst() then begin
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension5);
                                        tempDimensionSetEntry.Modify(true);
                                    end else begin
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recGLSetup."Shortcut Dimension 5 Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension5);
                                        tempDimensionSetEntry.Insert(true);
                                    end;
                                end;
                                if Dimension6 <> '' then begin
                                    tempDimensionSetEntry.Reset();
                                    tempDimensionSetEntry.SetRange("Dimension Code", recGLSetup."Shortcut Dimension 6 Code");
                                    if tempDimensionSetEntry.FindFirst() then begin
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension6);
                                        tempDimensionSetEntry.Modify(true);
                                    end else begin
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recGLSetup."Shortcut Dimension 6 Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension6);
                                        tempDimensionSetEntry.Insert(true);
                                    end;
                                end;
                                if Dimension7 <> '' then begin
                                    tempDimensionSetEntry.Reset();
                                    tempDimensionSetEntry.SetRange("Dimension Code", recGLSetup."Shortcut Dimension 7 Code");
                                    if tempDimensionSetEntry.FindFirst() then begin
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension7);
                                        tempDimensionSetEntry.Modify(true);
                                    end else begin
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recGLSetup."Shortcut Dimension 7 Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension7);
                                        tempDimensionSetEntry.Insert(true);
                                    end;
                                end;
                                if Dimension8 <> '' then begin
                                    tempDimensionSetEntry.Reset();
                                    tempDimensionSetEntry.SetRange("Dimension Code", recGLSetup."Shortcut Dimension 8 Code");
                                    if tempDimensionSetEntry.FindFirst() then begin
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension8);
                                        tempDimensionSetEntry.Modify(true);
                                    end else begin
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recGLSetup."Shortcut Dimension 8 Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension8);
                                        tempDimensionSetEntry.Insert(true);
                                    end;
                                end;

                                recPurchaseHeader."Dimension Set ID" := cuDimensionMgmt.GetDimensionSetID(tempDimensionSetEntry);
                                recPurchaseHeader.Modify(true);
                            end;
                        end;

                        recPurchaseLine.Init();
                        recPurchaseLine."Document Type" := opDocumentType;
                        recPurchaseLine."Document No." := cdDocumentNo;
                        intLineNo += 10000;
                        recPurchaseLine."Line No." := intLineNo;
                        recPurchaseLine.Insert(true);

                        if AccountType = '' then
                            Error('Account Type must not be blank for line no. %1', intCounter);
                        Evaluate(recPurchaseLine.Type, AccountType);
                        recPurchaseLine.Validate(Type);
                        recPurchaseLine.Validate("No.", AccountNO);
                        if LineQuantity = '' then
                            Error('Line Qauntity must not be blank for line no. %1', intCounter);

                        Evaluate(recPurchaseLine.Quantity, LineQuantity);
                        recPurchaseLine.Validate(Quantity);
                        if UnitRate = '' then
                            Error('Unit Rate must not be blank for line no. %1', intCounter);
                        Evaluate(recPurchaseLine."Direct Unit Cost", UnitRate);
                        recPurchaseLine.Validate("Direct Unit Cost");
                        if GenProdGroup <> '' then
                            recPurchaseLine.Validate("Gen. Prod. Posting Group", GenProdGroup);
                        recPurchaseLine.Validate("GST Group Code", GSTGroup);
                        recPurchaseLine.Validate("HSN/SAC Code", HSNCode);

                        if GSTCredit <> '' then
                            Evaluate(recPurchaseLine."GST Credit", GSTCredit);
                        recPurchaseLine.Validate("GST Credit");
                        if TDSNature <> '' then
                            recPurchaseLine.Validate("TDS Section Code", TDSNature);

                        recPurchaseLine.Validate("Shortcut Dimension 1 Code", Dimension1);
                        recPurchaseLine.Validate("Shortcut Dimension 2 Code", Dimension2);
                        recPurchaseLine.Modify(true);

                        if LineComment <> '' then begin
                            recPurchaseCommentLine.Init();
                            recPurchaseCommentLine."Document Type" := opDocumentType;
                            recPurchaseCommentLine."No." := cdDocumentNo;
                            recPurchaseCommentLine."Document Line No." := intLineNo;
                            recPurchaseCommentLine."Line No." := 10000;
                            recPurchaseCommentLine.Comment := LineComment;
                            recPurchaseCommentLine.Insert();
                        end;

                        if intLineNo = 10000 then begin
                            recPurchaseLine."Dimension Set ID" := recPurchaseHeader."Dimension Set ID";
                            recPurchaseLine.Modify(true);
                        end else begin
                            if (Dimension3 <> '') or (Dimension4 <> '') or (Dimension5 <> '') or (Dimension6 <> '') or (Dimension7 <> '') or (Dimension8 <> '') then begin
                                tempDimensionSetEntry.Reset();
                                tempDimensionSetEntry.DeleteAll();
                                recDimensionSetEntry.Reset();
                                recDimensionSetEntry.SetRange("Dimension Set ID", recPurchaseLine."Dimension Set ID");
                                if recDimensionSetEntry.FindFirst() then
                                    repeat
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recDimensionSetEntry."Dimension Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", recDimensionSetEntry."Dimension Value Code");
                                        tempDimensionSetEntry.Insert(true);
                                    until recDimensionSetEntry.Next() = 0;

                                if Dimension3 <> '' then begin
                                    tempDimensionSetEntry.Reset();
                                    tempDimensionSetEntry.SetRange("Dimension Code", recGLSetup."Shortcut Dimension 3 Code");
                                    if tempDimensionSetEntry.FindFirst() then begin
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension3);
                                        tempDimensionSetEntry.Modify(true);
                                    end else begin
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recGLSetup."Shortcut Dimension 3 Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension3);
                                        tempDimensionSetEntry.Insert(true);
                                    end;
                                end;
                                if Dimension4 <> '' then begin
                                    tempDimensionSetEntry.Reset();
                                    tempDimensionSetEntry.SetRange("Dimension Code", recGLSetup."Shortcut Dimension 4 Code");
                                    if tempDimensionSetEntry.FindFirst() then begin
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension4);
                                        tempDimensionSetEntry.Modify(true);
                                    end else begin
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recGLSetup."Shortcut Dimension 4 Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension4);
                                        tempDimensionSetEntry.Insert(true);
                                    end;
                                end;
                                if Dimension5 <> '' then begin
                                    tempDimensionSetEntry.Reset();
                                    tempDimensionSetEntry.SetRange("Dimension Code", recGLSetup."Shortcut Dimension 5 Code");
                                    if tempDimensionSetEntry.FindFirst() then begin
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension5);
                                        tempDimensionSetEntry.Modify(true);
                                    end else begin
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recGLSetup."Shortcut Dimension 5 Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension5);
                                        tempDimensionSetEntry.Insert(true);
                                    end;
                                end;
                                if Dimension6 <> '' then begin
                                    tempDimensionSetEntry.Reset();
                                    tempDimensionSetEntry.SetRange("Dimension Code", recGLSetup."Shortcut Dimension 6 Code");
                                    if tempDimensionSetEntry.FindFirst() then begin
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension6);
                                        tempDimensionSetEntry.Modify(true);
                                    end else begin
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recGLSetup."Shortcut Dimension 6 Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension6);
                                        tempDimensionSetEntry.Insert(true);
                                    end;
                                end;
                                if Dimension7 <> '' then begin
                                    tempDimensionSetEntry.Reset();
                                    tempDimensionSetEntry.SetRange("Dimension Code", recGLSetup."Shortcut Dimension 7 Code");
                                    if tempDimensionSetEntry.FindFirst() then begin
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension7);
                                        tempDimensionSetEntry.Modify(true);
                                    end else begin
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recGLSetup."Shortcut Dimension 7 Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension7);
                                        tempDimensionSetEntry.Insert(true);
                                    end;
                                end;
                                if Dimension8 <> '' then begin
                                    tempDimensionSetEntry.Reset();
                                    tempDimensionSetEntry.SetRange("Dimension Code", recGLSetup."Shortcut Dimension 8 Code");
                                    if tempDimensionSetEntry.FindFirst() then begin
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension8);
                                        tempDimensionSetEntry.Modify(true);
                                    end else begin
                                        tempDimensionSetEntry.Init();
                                        tempDimensionSetEntry.Validate("Dimension Code", recGLSetup."Shortcut Dimension 8 Code");
                                        tempDimensionSetEntry.Validate("Dimension Value Code", Dimension8);
                                        tempDimensionSetEntry.Insert(true);
                                    end;
                                end;
                                recPurchaseLine."Dimension Set ID" := cuDimensionMgmt.GetDimensionSetID(tempDimensionSetEntry);
                                recPurchaseLine.Modify(true);
                            end;
                        end;

                        Clear(cuTaxCalculation);
                        cuTaxCalculation.CallTaxEngineOnPurchaseLine(recPurchaseLine, recPurchaseLine);

                        cdOldVendorNo := VendorNo;
                        dtOldPostingDate := dtPostingDate;
                        cdOldVendorInvoiceNo := ExternalDocNo;
                    end;
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        intCounter := 0;
        recGLSetup.Get();
    end;

    trigger OnPostXmlPort()
    begin
        MESSAGE('Data has been successfully uploaded');
    end;

    procedure SetDocumentType(DocumentType: Enum "Purchase Document Type")
    begin
        opDocumentType := DocumentType;
    end;

    var
        opDocumentType: Enum "Purchase Document Type";
        recPurchaseHeader: Record "Purchase Header";
        recPurchaseLine: Record "Purchase Line";
        intLineNo: Integer;
        intCounter: Integer;
        cdDocumentNo: Code[20];
        cdOldVendorNo: Code[20];
        dtOldPostingDate: Date;
        dtPostingDate: Date;
        tempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        cuDimensionMgmt: Codeunit DimensionManagement;
        recGLSetup: Record "General Ledger Setup";
        recDimensionSetEntry: Record "Dimension Set Entry";
        recPurchaseCommentLine: Record "Purch. Comment Line";
        cuTaxCalculation: Codeunit "Calculate Tax";
        cdOldVendorInvoiceNo: Text;
        optInternalDocType: Option " ","Actual","Cancel";
        optDocumentBasis: Option " ","PO Base","Non-PO";
        optRCMApplicable: Option " ","Yes","No";
        optDueDateCalcBasis: Option " ","Posting Date","Document Date";
        enumInvType: Enum "GST Invoice Type";
        enumApplyToDocType: Enum "Gen. Journal Document Type";
        dtDocumentDate: Date;
}