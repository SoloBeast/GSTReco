report 50012 "Bank Reconciliation Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\BankReconciliationReport_Iappc_50012.rdl';

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = sorting("No.");
            CalcFields = "Balance at Date (LCY)";
            column(CompanyName; recCompanyInfo.Name)
            { }
            column(BankNo; "No.")
            { }
            column(BankName; Name)
            { }
            column(BankAccountNo; "Bank Account No.")
            { }
            column(RecoDate; Format(dtRecoDate))
            { }
            column(ClosingBalance; "Balance at Date (LCY)")
            { }

            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemTableView = sorting("Bank Account No.", "Posting Date");
                CalcFields = "Value Date";

                column(Document_No_; "Document No.")
                { }
                column(Description; txtDescription)
                { }
                column(Posting_Date; Format("Posting Date"))
                { }
                column(Debit_Amount__LCY_; "Debit Amount (LCY)")
                { }
                column(Credit_Amount__LCY_; "Credit Amount (LCY)")
                { }

                trigger OnPreDataItem()
                begin
                    "Bank Account Ledger Entry".SetRange("Bank Account No.", "Bank Account"."No.");
                    "Bank Account Ledger Entry".SETFILTER("Posting Date", '..%1', dtRecoDate);
                end;

                trigger OnAfterGetRecord()
                begin
                    IF "Bank Account Ledger Entry".Open = FALSE THEN BEGIN
                        IF "Bank Account Ledger Entry"."Value Date" <= dtRecoDate THEN
                            CurrReport.SKIP;
                    END;

                    txtDescription := '';
                    CustLedEntry.RESET;
                    CustLedEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
                    IF CustLedEntry.FIND('-') THEN BEGIN
                        Cust.GET(CustLedEntry."Customer No.");
                        txtDescription := Cust.Name;
                    END ELSE BEGIN
                        VendLedEntry.RESET;
                        VendLedEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
                        IF VendLedEntry.FIND('-') THEN BEGIN
                            Vend.GET(VendLedEntry."Vendor No.");
                            txtDescription := Vend.Name;
                        END ELSE BEGIN
                            FALedEntry.RESET;
                            FALedEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
                            IF FALedEntry.FIND('-') THEN BEGIN
                                FA.GET(FALedEntry."FA No.");
                                txtDescription := FA.Description;
                            END ELSE BEGIN
                                BankLedEntry.RESET;
                                BankLedEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
                                BankLedEntry.SETFILTER("Entry No.", '<>%1', "Bank Account Ledger Entry"."Entry No.");
                                IF BankLedEntry.FIND('-') THEN BEGIN
                                    BankMaster.GET(BankLedEntry."Bank Account No.");
                                    txtDescription := BankMaster.Name;
                                END ELSE BEGIN
                                    GLEntry.RESET;
                                    GLEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
                                    GLEntry.SETFILTER("Entry No.", '<>%1', "Bank Account Ledger Entry"."Entry No.");
                                    IF GLEntry.FIND('-') THEN BEGIN
                                        recGLAccount.GET(GLEntry."G/L Account No.");
                                        txtDescription := recGLAccount.Name;
                                    END;
                                END;
                            END;
                        END;
                    END;
                    if txtDescription = '' then
                        txtDescription := "Bank Account Ledger Entry".Description;

                end;
            }

            trigger OnPreDataItem()
            begin
                IF cdBankCode = '' THEN
                    ERROR('Select the Bank Account.');

                IF dtRecoDate = 0D THEN
                    ERROR('Enter Reconciliation Date.');

                recCompanyInfo.get;

                "Bank Account".SETRANGE("No.", cdBankCode);
                "Bank Account".SETFILTER("Date Filter", '..%1', dtRecoDate);
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(cdBankCode; cdBankCode)
                    {
                        Caption = 'Bank No.';
                        ApplicationArea = All;
                        TableRelation = "Bank Account";
                    }
                    field(dtRecoDate; dtRecoDate)
                    {
                        Caption = 'Reconciliation Date';
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        cdBankCode: Code[20];
        dtRecoDate: Date;
        CustLedEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        txtDescription: Text[250];
        VendLedEntry: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        FALedEntry: Record "FA Ledger Entry";
        FA: Record "Fixed Asset";
        BankLedEntry: Record "Bank Account Ledger Entry";
        BankMaster: Record "Bank Account";
        GLEntry: Record "G/L Entry";
        recGLAccount: Record "G/L Account";
}