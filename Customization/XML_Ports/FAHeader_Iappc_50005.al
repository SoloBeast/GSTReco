xmlport 50005 "FA Header Import"
{
    Caption = 'FA Header Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(FAHeaderImport)
        {
            MinOccurs = Zero;
            tableelement("Fixed Asset"; "Fixed Asset")
            {
                AutoSave = false;
                XmlName = 'FAHeaderImport';

                textelement(FANo)
                {
                    MinOccurs = Zero;
                }
                textelement(Description)
                {
                    MinOccurs = Zero;
                }
                textelement(Description2)
                {
                    MinOccurs = Zero;
                }
                textelement(SerialNo)
                {
                    MinOccurs = Zero;
                }
                textelement(FAClassCode)
                {
                    MinOccurs = Zero;
                }
                textelement(FASubClassCode)
                {
                    MinOccurs = Zero;
                }
                textelement(FALocation)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if (intCounter > 1) and (Description <> '') then begin
                        recFAAccount.Init();
                        if FANo <> '' then
                            recFAAccount."No." := FANo
                        else
                            recFAAccount."No." := '';
                        recFAAccount.Insert(true);
                        FANo := recFAAccount."No.";

                        recFAAccount.Reset();
                        recFAAccount.SetRange("No.", FANo);
                        recFAAccount.FindFirst();
                        recFAAccount.Description := Description;
                        recFAAccount."Description 2" := Description2;
                        recFAAccount."Serial No." := SerialNo;
                        recFAAccount.Validate("FA Class Code", FAClassCode);
                        recFAAccount.Validate("FA Subclass Code", FASubClassCode);
                        recFAAccount.Validate("FA Location Code", FALocation);
                        recFAAccount.Modify(True);
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
        recFAAccount: Record "Fixed Asset";
        intCounter: Integer;
}