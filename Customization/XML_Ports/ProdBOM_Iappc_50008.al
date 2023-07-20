xmlport 50008 "Prod. BOM Import"
{
    Caption = 'Prod. BOM Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    //FieldDelimiter = 'None';
    //FieldSeparator = 'TAB';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(ProdBOMImport)
        {
            MinOccurs = Zero;
            tableelement("Production BOM Header"; "Production BOM Header")
            {
                AutoSave = false;
                XmlName = 'ProdBOMImport';

                textelement(BOMNo) { MinOccurs = Zero; }
                textelement(BOMDescription) { MinOccurs = Zero; }
                textelement(UnitOfMeasure) { MinOccurs = Zero; }
                textelement(LineType) { MinOccurs = Zero; }
                textelement(ItemNo) { MinOccurs = Zero; }
                textelement(QtyPer) { MinOccurs = Zero; }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if (intCounter > 1) and (BOMNo <> '') then begin
                        if cdOldBOMBo <> BOMNo then begin
                            if cdOldBOMBo <> '' then begin
                                recProdBOMHeader.Reset();
                                recProdBOMHeader.SetRange("No.", cdOldBOMBo);
                                recProdBOMHeader.FindFirst();
                                recProdBOMHeader.Validate(Status, recProdBOMHeader.Status::Certified);
                                recProdBOMHeader.Modify(true);
                            end;

                            recProdBOMHeader.Init();
                            recProdBOMHeader."No." := BOMNo;
                            recProdBOMHeader.Insert(true);

                            recProdBOMHeader.Reset();
                            recProdBOMHeader.SetRange("No.", BOMNo);
                            recProdBOMHeader.FindFirst();
                            recProdBOMHeader.Validate(Description, BOMDescription);
                            recProdBOMHeader.Validate("Unit of Measure Code", UnitOfMeasure);
                            recProdBOMHeader.Modify(true);

                            intLineNo := 0;
                        end;

                        recProdBOMLine.Init();
                        recProdBOMLine."Production BOM No." := BOMNo;
                        intLineNo += 10000;
                        recProdBOMLine."Line No." := intLineNo;
                        recProdBOMLine.Insert(true);

                        recProdBOMLine.Reset();
                        recProdBOMLine.SetRange("Production BOM No.", BOMNo);
                        recProdBOMLine.SetRange("Line No.", intLineNo);
                        recProdBOMLine.FindFirst();
                        Evaluate(recProdBOMLine.Type, LineType);
                        recProdBOMLine.Validate(Type);
                        recProdBOMLine.Validate("No.", ItemNo);
                        Evaluate(recProdBOMLine."Quantity per", QtyPer);
                        recProdBOMLine.Validate("Quantity per");
                        recProdBOMLine.Modify(true);

                        cdOldBOMBo := BOMNo;
                    end;
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        intCounter := 0;
    end;

    trigger OnPostXmlPort()
    begin
        recProdBOMHeader.Reset();
        recProdBOMHeader.SetRange("No.", cdOldBOMBo);
        recProdBOMHeader.FindFirst();
        recProdBOMHeader.Validate(Status, recProdBOMHeader.Status::Certified);
        recProdBOMHeader.Modify(true);

        MESSAGE('Data has been successfully uploaded');
    end;

    var
        recProdBOMHeader: Record "Production BOM Header";
        recProdBOMLine: Record "Production BOM Line";
        intCounter: Integer;
        intLineNo: Integer;
        cdOldBOMBo: Code[20];
}