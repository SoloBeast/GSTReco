xmlport 50001 "Customer Import"
{
    Caption = 'Customer Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    //FieldDelimiter = 'None';
    //FieldSeparator = 'TAB';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(CustomerImport)
        {
            MinOccurs = Zero;
            tableelement(Customer; Customer)
            {
                AutoSave = false;
                XmlName = 'CustomerImport';

                textelement(PartyName)
                {
                    MinOccurs = Zero;
                }
                textelement(PartyAddress)
                {
                    MinOccurs = Zero;
                }
                textelement(PartyAddress2)
                {
                    MinOccurs = Zero;
                }
                textelement(PartyCity)
                {
                    MinOccurs = Zero;
                }
                textelement(PartyPostCode)
                {
                    MinOccurs = Zero;
                }
                textelement(PartyState)
                {
                    MinOccurs = Zero;
                }
                textelement(PartyCountry)
                {
                    MinOccurs = Zero;
                }
                textelement(ContactName)
                {
                    MinOccurs = Zero;
                }
                textelement(PartyPhone)
                {
                    MinOccurs = Zero;
                }
                textelement(PartyEmail)
                {
                    MinOccurs = Zero;
                }
                textelement(PostingGroup)
                {
                    MinOccurs = Zero;
                }
                textelement(GenBusPostingGroup)
                {
                    MinOccurs = Zero;
                }
                textelement(PaymentTermCode)
                {
                    MinOccurs = Zero;
                }
                textelement(CurrencyCode)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTRegNo)
                {
                    MinOccurs = Zero;
                }
                textelement(PANNo)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if (intCounter > 1) and (PartyName <> '') then begin
                        recCustomer.Init();
                        recCustomer."No." := '';
                        recCustomer.Insert(true);
                        cdAccountNo := recCustomer."No.";

                        recCustomer.Reset();
                        recCustomer.SetRange("No.", cdAccountNo);
                        recCustomer.FindFirst();
                        recCustomer.Validate(Name, PartyName);
                        recCustomer.Address := PartyAddress;
                        recCustomer."Address 2" := PartyAddress2;
                        recCustomer.City := PartyCity;
                        recCustomer."Post Code" := PartyPostCode;
                        recCustomer.Validate("State Code", PartyState);
                        recCustomer."Country/Region Code" := PartyCountry;
                        recCustomer.Contact := ContactName;
                        recCustomer."Phone No." := PartyPhone;
                        recCustomer."E-Mail" := PartyEmail;
                        recCustomer.Validate("Customer Posting Group", PostingGroup);
                        recCustomer.Validate("Gen. Bus. Posting Group", GenBusPostingGroup);
                        recCustomer.Validate("Payment Terms Code", PaymentTermCode);
                        recCustomer.Validate("Currency Code", CurrencyCode);
                        recCustomer.Validate("P.A.N. No.", PANNo);
                        recCustomer.Validate("GST Registration No.", GSTRegNo);
                        recCustomer.Modify(true);
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
        recCustomer: Record Customer;
        cdAccountNo: Code[20];
        intCounter: Integer;
}