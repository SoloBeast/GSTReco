xmlport 50000 "COA Import"
{
    Caption = 'COA Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    //FieldDelimiter = 'None';
    //FieldSeparator = 'TAB';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(COAImport)
        {
            MinOccurs = Zero;
            tableelement("G/L Account"; "G/L Account")
            {
                AutoSave = false;
                XmlName = 'COAImport';

                textelement(AccountNo)
                {
                    MinOccurs = Zero;
                }
                textelement(AccountName)
                {
                    MinOccurs = Zero;
                }
                textelement(AccountType)
                {
                    MinOccurs = Zero;
                }
                textelement(IncomeBalance)
                {
                    MinOccurs = Zero;
                }
                textelement(AccountCategory)
                {
                    MinOccurs = Zero;
                }
                textelement(AccountSubCategory)
                {
                    MinOccurs = Zero;
                }
                textelement(DirectPosting)
                {
                    MinOccurs = Zero;
                }
                textelement(GenPostingType)
                {
                    MinOccurs = Zero;
                }
                textelement(GenProdGroup)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    intCounter += 1;

                    if (intCounter > 1) and (AccountName <> '') then begin
                        recGLAccount.Init();
                        recGLAccount."No." := AccountNo;
                        recGLAccount.Insert(true);

                        recGLAccount.Reset();
                        recGLAccount.SetRange("No.", AccountNo);
                        recGLAccount.FindFirst();
                        recGLAccount.Name := AccountName;
                        Evaluate(recGLAccount."Account Type", AccountType);
                        Evaluate(recGLAccount."Income/Balance", IncomeBalance);
                        if AccountCategory <> '' then begin
                            Evaluate(recGLAccount."Account Category", AccountCategory);

                            if AccountSubCategory <> '' then begin
                                //Evaluate(recGLAccount."Account Subcategory Entry No.", AccountSubCategory);
                                recGLAccCategory.Reset();
                                recGLAccCategory.SetRange("Account Category", recGLAccount."Account Category");
                                recGLAccCategory.SetRange(Description, AccountSubCategory);
                                recGLAccCategory.FindFirst();
                                recGLAccount."Account Subcategory Entry No." := recGLAccCategory."Entry No.";
                            end;
                        end;

                        if DirectPosting <> '' then
                            Evaluate(recGLAccount."Direct Posting", DirectPosting);
                        if GenPostingType <> '' then
                            Evaluate(recGLAccount."Gen. Posting Type", GenPostingType);
                        recGLAccount.Validate("Gen. Prod. Posting Group", GenProdGroup);
                        recGLAccount.Modify(True);
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
        recGLAccount: Record "G/L Account";
        intCounter: Integer;
        recGLAccCategory: Record "G/L Account Category";
}