xmlport 50010 "Sales Document Import"
{
    Caption = 'Sales Document Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    //FieldDelimiter = 'None';
    //FieldSeparator = 'TAB';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(SalesDocImport)
        {
            MinOccurs = Zero;
            tableelement("Sales Header"; "Sales Header")
            {
                AutoSave = false;
                XmlName = 'SalesDocImport';

                textelement(CustomerNo)
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
                textelement(YourRef)
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
                textelement(TCSNature)
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
                textelement(CompBankAccountCode)
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
                textelement(SalesPersonCode)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if (intCounter > 1) and (CustomerNo <> '') then begin
                        if PostingDate = '' then
                            Error('Posting Date must not be blank for line no. %1', intCounter);
                        Evaluate(dtPostingDate, PostingDate);
                        if (CustomerNo <> cdOldCustomerNo) or (dtPostingDate <> dtOldPostingDate) or (ExternalDocNo <> cdOldExternalDocNo) then begin
                            recSalesHeader.Init();
                            recSalesHeader."Document Type" := opDocumentType;
                            recSalesHeader."No." := '';
                            recSalesHeader.Insert(true);
                            cdDocumentNo := recSalesHeader."No.";
                            intLineNo := 0;

                            recSalesHeader.Validate("Sell-to Customer No.", CustomerNo);
                            recSalesHeader.Validate("Posting Date", dtPostingDate);
                            recSalesHeader.Validate("External Document No.", ExternalDocNo);
                            recSalesHeader.Validate("Your Reference", YourRef);
                            recSalesHeader.Validate("Location Code", LocationCode);
                            recSalesHeader.Validate("Currency Code", CurrencyCode);
                            recSalesHeader.Validate("Shortcut Dimension 1 Code", Dimension1);
                            recSalesHeader.Validate("Shortcut Dimension 2 Code", Dimension2);
                            //Hemant
                            Evaluate(optInternalDocType, InternalDocType);
                            recSalesHeader.Validate("Internal Document Type", optInternalDocType);
                            recSalesHeader.Validate("Company Bank Account Code", CompBankAccountCode);
                            Evaluate(enumApplyToDocType, ApplyToDocType);
                            recSalesHeader.Validate("Applies-to Doc. Type", enumApplyToDocType);
                            recSalesHeader.Validate("Applies-to Doc. No.", ApplyToDocNo);
                            recSalesHeader.Validate("Salesperson Code", SalesPersonCode);
                            recSalesHeader.Modify(true);

                            if HeaderComment <> '' then begin
                                recSalesCommentLine.Init();
                                recSalesCommentLine."Document Type" := opDocumentType;
                                recSalesCommentLine."No." := cdDocumentNo;
                                recSalesCommentLine."Document Line No." := 0;
                                recSalesCommentLine."Line No." := 10000;
                                recSalesCommentLine.Comment := HeaderComment;
                                recSalesCommentLine.Insert();
                            end;

                            if (Dimension3 <> '') or (Dimension4 <> '') or (Dimension5 <> '') or (Dimension6 <> '') or (Dimension7 <> '') or (Dimension8 <> '') then begin
                                tempDimensionSetEntry.Reset();
                                tempDimensionSetEntry.DeleteAll();
                                recDimensionSetEntry.Reset();
                                recDimensionSetEntry.SetRange("Dimension Set ID", recSalesHeader."Dimension Set ID");
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

                                recSalesHeader."Dimension Set ID" := cuDimensionMgmt.GetDimensionSetID(tempDimensionSetEntry);
                                recSalesHeader.Modify(true);
                            end;
                        end;

                        recSalesLine.Init();
                        recSalesLine."Document Type" := opDocumentType;
                        recSalesLine."Document No." := cdDocumentNo;
                        intLineNo += 10000;
                        recSalesLine."Line No." := intLineNo;
                        recSalesLine.Insert(true);

                        if AccountType = '' then
                            Error('Account Type must not be blank for line no. %1', intCounter);
                        Evaluate(recSalesLine.Type, AccountType);
                        recSalesLine.Validate(Type);
                        recSalesLine.Validate("No.", AccountNO);
                        if LineQuantity = '' then
                            Error('Line Qauntity must not be blank for line no. %1', intCounter);

                        Evaluate(recSalesLine.Quantity, LineQuantity);
                        recSalesLine.Validate(Quantity);
                        if UnitRate = '' then
                            Error('Unit Rate must not be blank for line no. %1', intCounter);
                        Evaluate(recSalesLine."Unit Price", UnitRate);
                        recSalesLine.Validate("Unit Price");
                        if GenProdGroup <> '' then
                            recSalesLine.Validate("Gen. Prod. Posting Group", GenProdGroup);
                        recSalesLine.Validate("GST Group Code", GSTGroup);
                        recSalesLine.Validate("HSN/SAC Code", HSNCode);

                        if GSTCredit <> '' then
                            Evaluate(recSalesLine."GST Credit", GSTCredit);
                        recSalesLine.Validate("GST Credit");
                        if TCSNature <> '' then
                            recSalesLine.Validate("TCS Nature of Collection", TCSNature);

                        recSalesLine.Validate("Shortcut Dimension 1 Code", Dimension1);
                        recSalesLine.Validate("Shortcut Dimension 2 Code", Dimension2);
                        recSalesLine.Modify(true);

                        if LineComment <> '' then begin
                            recSalesCommentLine.Init();
                            recSalesCommentLine."Document Type" := opDocumentType;
                            recSalesCommentLine."No." := cdDocumentNo;
                            recSalesCommentLine."Document Line No." := intLineNo;
                            recSalesCommentLine."Line No." := 10000;
                            recSalesCommentLine.Comment := LineComment;
                            recSalesCommentLine.Insert();
                        end;

                        if intLineNo = 10000 then begin
                            recSalesLine."Dimension Set ID" := recSalesHeader."Dimension Set ID";
                            recSalesLine.Modify(true);
                        end else begin
                            if (Dimension3 <> '') or (Dimension4 <> '') or (Dimension5 <> '') or (Dimension6 <> '') or (Dimension7 <> '') or (Dimension8 <> '') then begin
                                tempDimensionSetEntry.Reset();
                                tempDimensionSetEntry.DeleteAll();
                                recDimensionSetEntry.Reset();
                                recDimensionSetEntry.SetRange("Dimension Set ID", recSalesLine."Dimension Set ID");
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
                                recSalesLine."Dimension Set ID" := cuDimensionMgmt.GetDimensionSetID(tempDimensionSetEntry);
                                recSalesLine.Modify(true);
                            end;
                        end;

                        Clear(cuTaxCalculation);
                        cuTaxCalculation.CallTaxEngineOnSalesLine(recSalesLine, recSalesLine);

                        cdOldCustomerNo := CustomerNo;
                        dtOldPostingDate := dtPostingDate;
                        cdOldExternalDocNo := ExternalDocNo;
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

    procedure SetDocumentType(DocumentType: Enum "Sales Document Type")
    begin
        opDocumentType := DocumentType;
    end;

    var
        opDocumentType: Enum "Sales Document Type";
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        intLineNo: Integer;
        intCounter: Integer;
        cdDocumentNo: Code[20];
        cdOldCustomerNo: Code[20];
        dtOldPostingDate: Date;
        dtOldExternalDocNo: Code[20];
        dtPostingDate: Date;
        tempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        cuDimensionMgmt: Codeunit DimensionManagement;
        recGLSetup: Record "General Ledger Setup";
        recDimensionSetEntry: Record "Dimension Set Entry";
        recSalesCommentLine: Record "Sales Comment Line";
        cuTaxCalculation: Codeunit "Calculate Tax";
        cdOldExternalDocNo: Text;//Code[50];
        optInternalDocType: Option " ","Actual","Cancel";
        enumApplyToDocType: Enum "Gen. Journal Document Type";
}