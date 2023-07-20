xmlport 50003 "Employee Import"
{
    Caption = 'Employee Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    //FieldDelimiter = 'None';
    //FieldSeparator = 'TAB';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(EmployeeImport)
        {
            MinOccurs = Zero;
            tableelement(Employee; Employee)
            {
                AutoSave = false;
                XmlName = 'EmployeeImport';

                textelement(AccountNo)
                {
                    MinOccurs = Zero;
                }
                textelement(FirstName)
                {
                    MinOccurs = Zero;
                }
                textelement(MiddleName)
                {
                    MinOccurs = Zero;
                }
                textelement(LastName)
                {
                    MinOccurs = Zero;
                }
                textelement(EmpAddress)
                {
                    MinOccurs = Zero;
                }
                textelement(EmpAddress2)
                {
                    MinOccurs = Zero;
                }
                textelement(EmpCity)
                {
                    MinOccurs = Zero;
                }
                textelement(EmpPostCode)
                {
                    MinOccurs = Zero;
                }
                textelement(CountryCode)
                {
                    MinOccurs = Zero;
                }
                textelement(PersonalPhoneNo)
                {
                    MinOccurs = Zero;
                }
                textelement(PersonalEmail)
                {
                    MinOccurs = Zero;
                }
                textelement(JobTitle)
                {
                    MinOccurs = Zero;
                }
                textelement(EmpPostingGroup)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if (intCounter > 1) and (FirstName <> '') then begin
                        recEmployee.Init();
                        if AccountNo <> '' then
                            recEmployee.Validate("No.", AccountNo)
                        else
                            recEmployee."No." := '';
                        recEmployee.Insert(true);
                        cdAccountNo := recEmployee."No.";

                        recEmployee.Reset();
                        recEmployee.SetRange("No.", cdAccountNo);
                        recEmployee.FindFirst();
                        recEmployee.Validate("First Name", FirstName);
                        recEmployee.Validate("Middle Name", MiddleName);
                        recEmployee.Validate("Last Name", LastName);
                        recEmployee.Address := EmpAddress;
                        recEmployee."Address 2" := EmpAddress2;
                        recEmployee.City := EmpCity;
                        recEmployee."Post Code" := EmpPostCode;
                        recEmployee."Country/Region Code" := CountryCode;
                        recEmployee."Phone No." := PersonalPhoneNo;
                        recEmployee."E-Mail" := PersonalEmail;
                        recEmployee."Job Title" := JobTitle;
                        recEmployee.Validate("Employee Posting Group", EmpPostingGroup);
                        recEmployee.Modify(true);
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
        recEmployee: Record Employee;
        cdAccountNo: Code[20];
        intCounter: Integer;
}