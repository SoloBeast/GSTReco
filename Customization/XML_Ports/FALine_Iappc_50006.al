xmlport 50006 "FA Lines Import"
{
    Caption = 'FA Lines Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(FALinesImport)
        {
            MinOccurs = Zero;
            tableelement("FA Depreciation Book"; "FA Depreciation Book")
            {
                AutoSave = false;
                XmlName = 'FALinesImport';

                textelement(FANo)
                {
                    MinOccurs = Zero;
                }
                textelement(DepreciationBook)
                {
                    MinOccurs = Zero;
                }
                textelement(FAPostingGroup)
                {
                    MinOccurs = Zero;
                }
                textelement(DepreciationMethod)
                {
                    MinOccurs = Zero;
                }
                textelement(DepreciationStartDate)
                {
                    MinOccurs = Zero;
                }
                textelement(DepreciationEndDate)
                {
                    MinOccurs = Zero;
                }
                textelement(DepreciationYears)
                {
                    MinOccurs = Zero;
                }
                textelement(DepreciationPerc)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if (intCounter > 1) and (FANo <> '') then begin
                        if not recFADepreciaionBook.Get(FANo, DepreciationBook) then begin
                            recFADepreciaionBook.Init();
                            recFADepreciaionBook.Validate("FA No.", FANo);
                            recFADepreciaionBook.Validate("Depreciation Book Code", DepreciationBook);
                            recFADepreciaionBook.Insert(true);
                        end;

                        recFADepreciaionBook.Reset();
                        recFADepreciaionBook.SetRange("FA NO.", FANo);
                        recFADepreciaionBook.SetRange("Depreciation Book Code", DepreciationBook);
                        recFADepreciaionBook.FindFirst();
                        recFADepreciaionBook.Validate("FA Posting Group", FAPostingGroup);

                        if DepreciationMethod <> '' then begin
                            if DepreciationMethod = 'Straight-Line' then
                                DepreciationMethod := Format(recFADepreciaionBook."Depreciation Method"::"Straight-Line")
                            else
                                if DepreciationMethod = 'Reducing-Balance' then
                                    DepreciationMethod := Format(recFADepreciaionBook."Depreciation Method"::"Declining-Balance 1");
                            Evaluate(recFADepreciaionBook."Depreciation Method", DepreciationMethod);
                        end;
                        recFADepreciaionBook.Validate("Depreciation Method");

                        if DepreciationStartDate <> '' then
                            Evaluate(recFADepreciaionBook."Depreciation Starting Date", DepreciationStartDate);
                        recFADepreciaionBook.Validate("Depreciation Starting Date");

                        if DepreciationEndDate <> '' then
                            Evaluate(recFADepreciaionBook."Depreciation Ending Date", DepreciationEndDate);
                        recFADepreciaionBook.Validate("Depreciation Ending Date");

                        if DepreciationYears <> '' then
                            Evaluate(recFADepreciaionBook."No. of Depreciation Years", DepreciationYears);
                        recFADepreciaionBook.Validate("No. of Depreciation Years");

                        if DepreciationPerc <> '' then begin
                            if recFADepreciaionBook."Depreciation Method" = recFADepreciaionBook."Depreciation Method"::"Straight-Line" then begin
                                Evaluate(recFADepreciaionBook."Straight-Line %", DepreciationPerc);
                                recFADepreciaionBook.Validate("Straight-Line %");
                            end else begin
                                if recFADepreciaionBook."Depreciation Method" = recFADepreciaionBook."Depreciation Method"::"Declining-Balance 1" then
                                    Evaluate(recFADepreciaionBook."Declining-Balance %", DepreciationPerc);
                                recFADepreciaionBook.Validate("Declining-Balance %");
                            end;
                        end;
                        recFADepreciaionBook.Modify(True);
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
        recFADepreciaionBook: Record "FA Depreciation Book";
        intCounter: Integer;
}