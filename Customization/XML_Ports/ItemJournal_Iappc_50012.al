xmlport 50012 "Item Journal Import"
{
    FieldDelimiter = '<NONE>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(OpeningInventory)
        {
            tableelement(Table83; "Item Journal Line")
            {
                AutoSave = false;
                XmlName = 'ItemJournalImport';
                textelement(EntryType)
                {
                    MinOccurs = Zero;
                }
                textelement(InputDate)
                {
                    MinOccurs = Zero;
                }
                textelement(InputDocNo)
                {
                    MinOccurs = Zero;
                }
                textelement(InputItemCode)
                {
                    MinOccurs = Zero;
                }
                textelement(InputVariantCode)
                {
                    MinOccurs = Zero;
                }
                textelement(InputLocation)
                {
                    MinOccurs = Zero;
                }
                textelement(InputQuantity)
                {
                    MinOccurs = Zero;
                }
                textelement(InputLotNo)
                {
                    MinOccurs = Zero;
                }
                textelement(InputSerialNo)
                {
                    MinOccurs = Zero;
                }
                textelement(InputUnitCost)
                {
                    MinOccurs = Zero;
                }
                textelement(InputLineAmount)
                {
                    MinOccurs = Zero;
                }
                textelement(InputGD1)
                {
                    MinOccurs = Zero;
                }
                textelement(InputGD2)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if intCounter > 1 then begin
                        EVALUATE(dtPostingDate, InputDate);
                        EVALUATE(decQuantity, InputQuantity);
                        EVALUATE(decUnitRate, InputUnitCost);
                        EVALUATE(decLineAmount, InputLineAmount);

                        recItemJournal.INIT;
                        recItemJournal.VALIDATE("Journal Template Name", cdTemplate);
                        recItemJournal.VALIDATE("Journal Batch Name", cdBatch);
                        intLineNo += 10000;
                        recItemJournal."Line No." := intLineNo;
                        IF EntryType = '1' THEN
                            recItemJournal.VALIDATE("Entry Type", recItemJournal."Entry Type"::"Positive Adjmt.")
                        ELSE
                            recItemJournal.VALIDATE("Entry Type", recItemJournal."Entry Type"::"Negative Adjmt.");
                        recItemJournal.VALIDATE("Item No.", InputItemCode);
                        recItemJournal.VALIDATE("Variant Code", InputVariantCode);
                        recItemJournal.VALIDATE("Posting Date", dtPostingDate);
                        recItemJournal.VALIDATE("Document No.", InputDocNo);
                        recItemJournal.VALIDATE("Location Code", InputLocation);
                        recItemJournal.VALIDATE(Quantity, decQuantity);
                        recItemJournal.VALIDATE("Unit Cost", decUnitRate);
                        recItemJournal.VALIDATE(Amount, decLineAmount);
                        recItemJournal.VALIDATE("Shortcut Dimension 1 Code", InputGD1);
                        recItemJournal.VALIDATE("Shortcut Dimension 2 Code", InputGD2);
                        recItemJournal.INSERT;

                        IF (InputLotNo <> '') AND (InputSerialNo <> '') THEN
                            ERROR('Both Lot and Serial no. can not be assigned on one item.');

                        IF InputLotNo <> '' THEN BEGIN
                            recReservationEntry.INIT;
                            intEntryNo += 1;
                            recReservationEntry."Entry No." := intEntryNo;
                            recReservationEntry.Positive := TRUE;
                            recReservationEntry."Item No." := InputItemCode;
                            recReservationEntry."Location Code" := InputLocation;

                            if recItemJournal."Entry Type" = recItemJournal."Entry Type"::"Positive Adjmt." then
                                recReservationEntry.VALIDATE("Quantity (Base)", decQuantity)
                            else
                                recReservationEntry.VALIDATE("Quantity (Base)", -decQuantity);
                            recReservationEntry."Reservation Status" := recReservationEntry."Reservation Status"::Prospect;
                            recReservationEntry."Creation Date" := TODAY;
                            recReservationEntry."Source Type" := 83;

                            if recItemJournal."Entry Type" = recItemJournal."Entry Type"::"Positive Adjmt." then
                                recReservationEntry."Source Subtype" := 2
                            else
                                recReservationEntry."Source Subtype" := 3;
                            recReservationEntry."Source ID" := cdTemplate;
                            recReservationEntry."Source Batch Name" := cdBatch;
                            recReservationEntry."Source Ref. No." := intLineNo;
                            recReservationEntry."Shipment Date" := TODAY;
                            recReservationEntry."Created By" := USERID;
                            recReservationEntry."Lot No." := InputLotNo;
                            recReservationEntry."Variant Code" := InputVariantCode;
                            recReservationEntry.INSERT;
                        END;

                        IF InputSerialNo <> '' THEN BEGIN
                            recReservationEntry.INIT;
                            intEntryNo += 1;
                            recReservationEntry."Entry No." := intEntryNo;
                            recReservationEntry.Positive := TRUE;
                            recReservationEntry."Item No." := InputItemCode;
                            recReservationEntry."Location Code" := InputLocation;

                            if recItemJournal."Entry Type" = recItemJournal."Entry Type"::"Positive Adjmt." then
                                recReservationEntry.VALIDATE("Quantity (Base)", decQuantity)
                            else
                                recReservationEntry.VALIDATE("Quantity (Base)", -decQuantity);
                            recReservationEntry."Reservation Status" := recReservationEntry."Reservation Status"::Prospect;
                            recReservationEntry."Creation Date" := TODAY;
                            recReservationEntry."Source Type" := 83;

                            if recItemJournal."Entry Type" = recItemJournal."Entry Type"::"Positive Adjmt." then
                                recReservationEntry."Source Subtype" := 2
                            else
                                recReservationEntry."Source Subtype" := 3;
                            recReservationEntry."Source ID" := cdTemplate;
                            recReservationEntry."Source Batch Name" := cdBatch;
                            recReservationEntry."Source Ref. No." := intLineNo;
                            recReservationEntry."Shipment Date" := TODAY;
                            recReservationEntry."Created By" := USERID;
                            recReservationEntry."Serial No." := InputSerialNo;
                            recReservationEntry."Variant Code" := InputVariantCode;
                            recReservationEntry.INSERT;
                        END;
                    end;

                    InputDate := '';
                    InputDocNo := '';
                    InputItemCode := '';
                    InputLocation := '';
                    InputQuantity := '';
                    InputLotNo := '';
                    InputUnitCost := '';
                    InputGD1 := '';
                    InputGD2 := '';
                    InputSerialNo := '';
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        IF (cdTemplate = '') OR (cdBatch = '') THEN
            ERROR('The Template or Batch code must not be blank.');

        recItemJournal.RESET;
        recItemJournal.SETRANGE("Journal Template Name", cdTemplate);
        recItemJournal.SETRANGE("Journal Batch Name", cdBatch);
        IF recItemJournal.FIND('+') THEN
            intLineNo := recItemJournal."Line No."
        ELSE
            intLineNo := 10000;

        recReservationEntry.RESET;
        IF recReservationEntry.FIND('+') THEN
            intEntryNo := recReservationEntry."Entry No."
        ELSE
            intEntryNo := 0;
    end;

    trigger OnPostXmlPort()
    begin
        MESSAGE('Data has been successfully uploaded');
    end;

    procedure SetTemplateBatch(TemplateCode: Code[10]; BatchName: Code[10])
    begin
        cdTemplate := TemplateCode;
        cdBatch := BatchName;
    end;

    var
        intLineNo: Integer;
        dtPostingDate: Date;
        decQuantity: Decimal;
        decUnitRate: Decimal;
        recReservationEntry: Record "Reservation Entry";
        intEntryNo: Integer;
        cdTemplate: Code[20];
        cdBatch: Code[20];
        recItemJournal: Record "Item Journal Line";
        decLineAmount: Decimal;
        intCounter: Integer;
}