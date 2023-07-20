xmlport 50014 "UTR No. Update"
{
    Caption = 'UTR No. Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    TextEncoding = WINDOWS;
    Permissions = tabledata "Bank Account Ledger Entry" = rm;

    schema
    {
        textelement(UTRNoImport)
        {
            MinOccurs = Zero;
            tableelement("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                AutoSave = false;
                XmlName = 'UTRImport';

                textelement(EntryNo)
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

                    if (intCounter > 1) and (EntryNo <> '') and (UTRNo <> '') then begin
                        Evaluate(intEntryNo, EntryNo);
                        recBankLedger.Get(intEntryNo);
                        recBankLedger."UTR No." := UTRNo;
                        recBankLedger.Modify();
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
        MESSAGE('Data has been successfully updated');
    end;

    var
        recBankLedger: Record "Bank Account Ledger Entry";
        intCounter: Integer;
        intEntryNo: Integer;
}