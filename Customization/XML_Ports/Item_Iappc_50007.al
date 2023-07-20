xmlport 50007 "Item Import"
{
    Caption = 'Item Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    //FieldDelimiter = 'None';
    //FieldSeparator = 'TAB';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(ItemImport)
        {
            MinOccurs = Zero;
            tableelement(Item; Item)
            {
                AutoSave = false;
                XmlName = 'ItemImport';

                textelement(ItemNo) { MinOccurs = Zero; }
                textelement(ItemName) { MinOccurs = Zero; }
                textelement(UnitOfMeasure) { MinOccurs = Zero; }
                textelement(ItemCategory) { MinOccurs = Zero; }
                textelement(InventoryPostingGroup) { MinOccurs = Zero; }
                textelement(GenProductPostingGroup) { MinOccurs = Zero; }
                textelement(ItemTracking) { MinOccurs = Zero; }
                textelement(ReplenishmentMethod) { MinOccurs = Zero; }
                textelement(ProdBomNo) { MinOccurs = Zero; }
                textelement(ProdRoutingNo) { MinOccurs = Zero; }
                textelement(GSTCredit) { MinOccurs = Zero; }
                textelement(GSTGroupCode) { MinOccurs = Zero; }
                textelement(HSNCode) { MinOccurs = Zero; }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if (intCounter > 1) and (ItemNo <> '') then begin
                        recItem.Init();
                        recItem."No." := ItemNo;
                        recItem.Insert(true);

                        recItem.Reset();
                        recItem.SetRange("No.", ItemNo);
                        recItem.FindFirst();
                        recItem.Validate(Description, ItemName);
                        recItem."Base Unit of Measure" := UnitOfMeasure;
                        recItem."Purch. Unit of Measure" := UnitOfMeasure;
                        recItem."Sales Unit of Measure" := UnitOfMeasure;
                        recItem.Validate("Item Category Code", ItemCategory);
                        recItem.Validate("Inventory Posting Group", InventoryPostingGroup);
                        recItem.Validate("Gen. Prod. Posting Group", GenProductPostingGroup);
                        recItem.Validate("Item Tracking Code", ItemTracking);
                        if ReplenishmentMethod <> '' then
                            Evaluate(recItem."Replenishment System", ReplenishmentMethod);
                        recItem.Validate("Production BOM No.", ProdBomNo);
                        recItem.Validate("Routing No.", ProdRoutingNo);
                        if GSTCredit <> '' then
                            Evaluate(recItem."GST Credit", GSTCredit);
                        recItem.Validate("GST Group Code", GSTGroupCode);
                        recItem.Validate("HSN/SAC Code", HSNCode);
                        recItem.Modify(true);

                        recItemUOM.Init();
                        recItemUOM."Item No." := ItemNo;
                        recItemUOM.Code := UnitOfMeasure;
                        recItemUOM."Qty. per Unit of Measure" := 1;
                        recItemUOM.Insert();
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
        MESSAGE('Data has been successfully uploaded');
    end;

    var
        recItem: Record Item;
        recItemUOM: Record "Item Unit of Measure";
        intCounter: Integer;
}