xmlport 50004 "Dimension Value Import"
{
    Caption = 'Dimension Value Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    //FieldDelimiter = 'None';
    //FieldSeparator = 'TAB';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(DimensionValueImport)
        {
            MinOccurs = Zero;
            tableelement("Dimension Value"; "Dimension Value")
            {
                AutoSave = false;
                XmlName = 'DimensionImport';

                textelement(DimensionCode)
                {
                    MinOccurs = Zero;
                }
                textelement(DimensionValueCode)
                {
                    MinOccurs = Zero;
                }
                textelement(DimensionValueName)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if (intCounter > 1) and (DimensionCode <> '') and (DimensionValueCode <> '') then begin
                        recDimensionValue.Init();
                        recDimensionValue.Validate("Dimension Code", DimensionCode);
                        recDimensionValue.Validate(Code, DimensionValueCode);
                        recDimensionValue.Name := DimensionValueName;
                        recDimensionValue.Insert(true);
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
        recDimensionValue: Record "Dimension Value";
        intCounter: Integer;
}