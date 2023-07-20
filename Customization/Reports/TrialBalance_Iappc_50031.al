report 50031 "Iappc Trial Balance"
{
    UsageCategory = Administration;
    Caption = 'Trial Balance';
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\TrialBalance_Iappc_50031.rdl';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.") where("Account Type" = filter(<> "Begin-Total"));
            CalcFields = "Opening Balance", "Debit Amount", "Credit Amount", "Balance at Date";

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; 'Trial Balance of General Ledger from ' + format(dtFromDate) + ' to ' + Format(dtToDate)) { }
            column(GLCode; "No.") { }
            column(GLName; Name) { }
            column(Income_Balance; "Income/Balance") { }
            column(Account_Category; "Account Category") { }
            column(Account_Subcategory_Descript_; "Account Subcategory Descript.") { }
            column(Group_Name; "Group Name") { }
            column(Sub_Group_Name; "Sub Group Name") { }
            column(DrOpening; decDrOpening) { }
            column(CrOpening; decCrOpening) { }
            column(Debit_Amount; "Debit Amount") { }
            column(Credit_Amount; "Credit Amount") { }
            column(DrClosing; decDrClosing) { }
            column(CrClosing; decCrClosing) { }
            column(HighLight; intHighLight) { }
            column(DrOpeningTotal; decTotal[1]) { }
            column(CrOpeningTotal; decTotal[2]) { }
            column(DebitTotal; decTotal[3]) { }
            column(CreditTotal; decTotal[4]) { }
            column(DrClosingTotal; decTotal[5]) { }
            column(CrClosingTotal; decTotal[6]) { }
            column(Account_Type; Format("Account Type")) { }

            trigger OnPreDataItem()
            begin
                if (Format(dtFromDate) = '') and (Format(dtToDate) = '') then
                    Error('The From or To Date must not be blank.');

                recCompanyInfo.Get();
                "G/L Account".SetFilter("Opening Date Filter", '..%1', ClosingDate(dtFromDate - 1));
                "G/L Account".SetFilter("Date Filter", '%1..%2', dtFromDate, ClosingDate(dtToDate));
                if opAccountType = opAccountType::"Income Statement" then
                    "G/L Account".SetRange("Income/Balance", "G/L Account"."Income/Balance"::"Income Statement");
                if opAccountType = opAccountType::"Balance Sheet" then
                    "G/L Account".SetRange("Income/Balance", "G/L Account"."Income/Balance"::"Balance Sheet");
                if blnHideEndTotal then
                    "G/L Account".SetRange("Account Type", "G/L Account"."Account Type"::Posting);
                Clear(decTotal);
            end;

            trigger OnAfterGetRecord()
            begin
                decCrClosing := 0;
                decCrOpening := 0;
                decDrClosing := 0;
                decDrOpening := 0;

                if "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting then
                    intHighLight := 1
                else
                    intHighLight := 0;

                if "G/L Account"."Opening Balance" > 0 then
                    decDrOpening := "G/L Account"."Opening Balance"
                else
                    decCrOpening := -"G/L Account"."Opening Balance";

                if "G/L Account"."Balance at Date" > 0 then
                    decDrClosing := "G/L Account"."Balance at Date"
                else
                    decCrClosing := -"G/L Account"."Balance at Date";

                if "G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting then begin
                    decTotal[1] += decDrOpening;
                    decTotal[2] += decCrOpening;
                    decTotal[3] += "G/L Account"."Debit Amount";
                    decTotal[4] += "G/L Account"."Credit Amount";
                    decTotal[5] += decDrClosing;
                    decTotal[6] += decCrClosing;
                end;

                if decDrClosing + decDrOpening + decCrClosing + decCrOpening + "G/L Account"."Debit Amount" + "G/L Account"."Credit Amount" = 0 then
                    CurrReport.Skip();
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
                    field(dtFromDate; dtFromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                    }
                    field(dtToDate; dtToDate)
                    {
                        ApplicationArea = all;
                        Caption = 'To Date';
                    }
                    field(opAccountType; opAccountType)
                    {
                        Caption = 'Account Type';
                        ApplicationArea = all;
                    }
                    field(blnHideEndTotal; blnHideEndTotal)
                    {
                        Caption = 'Hide End Total';
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    var
        dtFromDate: Date;
        dtToDate: Date;
        recCompanyInfo: Record "Company Information";
        decDrOpening: Decimal;
        decCrOpening: Decimal;
        decDrClosing: Decimal;
        decCrClosing: Decimal;
        intHighLight: Integer;
        decTotal: array[6] of Decimal;
        opAccountType: Option " ","Income Statement","Balance Sheet";
        blnHideEndTotal: Boolean;
}