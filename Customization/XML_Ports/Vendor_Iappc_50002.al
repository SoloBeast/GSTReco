xmlport 50002 "Vendor Import"
{
    Caption = 'Vendor Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    //FieldDelimiter = 'None';
    //FieldSeparator = 'TAB';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(VendorImport)
        {
            MinOccurs = Zero;
            tableelement(Vendor; Vendor)
            {
                AutoSave = false;
                XmlName = 'VendorImport';

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
                        recVendor.Init();
                        recVendor."No." := '';
                        recVendor.Insert(true);
                        cdAccountNo := recVendor."No.";

                        recVendor.Reset();
                        recVendor.SetRange("No.", cdAccountNo);
                        recVendor.FindFirst();
                        recVendor.Validate(Name, PartyName);
                        recVendor.Address := PartyAddress;
                        recVendor."Address 2" := PartyAddress2;
                        recVendor.City := PartyCity;
                        recVendor."Post Code" := PartyPostCode;
                        recVendor.Validate("State Code", PartyState);
                        recVendor."Country/Region Code" := PartyCountry;
                        recVendor.Contact := ContactName;
                        recVendor."Phone No." := PartyPhone;
                        recVendor."E-Mail" := PartyEmail;
                        recVendor.Validate("Vendor Posting Group", PostingGroup);
                        recVendor.Validate("Gen. Bus. Posting Group", GenBusPostingGroup);
                        recVendor.Validate("Payment Terms Code", PaymentTermCode);
                        recVendor.Validate("Currency Code", CurrencyCode);
                        recVendor.Validate("P.A.N. No.", PANNo);
                        recVendor.Validate("GST Registration No.", GSTRegNo);
                        recVendor.Modify(true);
                    end;
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
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
        recVendor: Record Vendor;
        cdAccountNo: Code[20];
        intCounter: Integer;
}