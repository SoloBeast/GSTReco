report 50190 "Trial Balance Monthly"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; txtHeading) { }
            column(HighLight; intHighLight) { }
            column(No_; recGLAccount."No.") { }
            column(Name; recGLAccount.Name) { }
            column(Income_Balance; recGLAccount."Income/Balance") { }
            column(Account_Category; recGLAccount."Account Category") { }
            column(Group_Name; recGLAccount."Group Name") { }
            column(Sub_Group_Name; recGLAccount."Sub Group Name") { }
            column(Account_Type; Format(recGLAccount."Account Type")) { }
            column(Totaling; recGLAccount.Totaling) { }
            column(Gen__Posting_Type; recGLAccount."Gen. Posting Type") { }
            column(Gen__Bus__Posting_Group; recGLAccount."Gen. Bus. Posting Group") { }
            column(Gen__Prod__Posting_Group; recGLAccount."Gen. Prod. Posting Group") { }
            column(Direct_Posting; Format(recGLAccount."Direct Posting")) { }
            column(AprAmount; recTrialAmount.Amount) { }
            column(MayAmount; recTrialAmount."Amount (LCY)") { }
            column(JunAmount; recTrialAmount."Amount Before Adjustment") { }
            column(JulAmount; recTrialAmount."Amount Excl. GST") { }
            column(AugAmount; recTrialAmount."GST Amount on Hold") { }
            column(SepAmount; recTrialAmount."VAT Amount") { }
            column(OctAmount; recTrialAmount."VAT Amount (LCY)") { }
            column(NovAmount; recTrialAmount."Debit Amount") { }
            column(DecAmount; recTrialAmount."Credit Amount") { }
            column(JanAmount; recTrialAmount."Bal. VAT Amount") { }
            column(FebAmount; recTrialAmount."Bal. VAT Amount (LCY)") { }
            column(MarAmount; recTrialAmount."VAT Base Amount") { }
            column(SumAprAmount; decSumAmount[1]) { }
            column(SumMayAmount; decSumAmount[2]) { }
            column(SumJunAmount; decSumAmount[3]) { }
            column(SumJulAmount; decSumAmount[4]) { }
            column(SumAugAmount; decSumAmount[5]) { }
            column(SumSepAmount; decSumAmount[6]) { }
            column(SumOctAmount; decSumAmount[7]) { }
            column(SumNovAmount; decSumAmount[8]) { }
            column(SumDecAmount; decSumAmount[9]) { }
            column(SumJanAmount; decSumAmount[10]) { }
            column(SumFebAmount; decSumAmount[11]) { }
            column(SumMarAmount; decSumAmount[12]) { }
            column(SortingNo; recTrialAmount."IC Partner Transaction No.") { }
            column(MonthName; recTrialAmount.Description) { }
            column(MonthAmount; recTrialAmount."Amount (LCY)") { }
            column(SumAmount; decSumAmount[1]) { }

            trigger OnPreDataItem()
            begin
                if intYear = 0 then
                    Error('Enter the year to generate the report.');

                dtPeriodStart := DMY2Date(1, 4, intYear);
                dtPeriodEnd := DMY2Date(31, 3, intYear + 1);

                recCompanyInfo.Get();
                txtHeading := 'Monthly Trial Balance Report for the year ' + Format(intYear) + ' - ' + Format(intYear + 1);

                recTrialAmount.Reset();
                recTrialAmount.DeleteAll();
                intLineNo := 0;

                recGLAccount.Reset();
                recGLAccount.SetFilter("Account Type", '<>%1', recGLAccount."Account Type"::"Begin-Total");
                //Hemant
                if opAccountType = opAccountType::"Income Statement" then
                    recGLAccount.SetRange("Income/Balance", recGLAccount."Income/Balance"::"Income Statement");
                if opAccountType = opAccountType::"Balance Sheet" then
                    recGLAccount.SetRange("Income/Balance", recGLAccount."Income/Balance"::"Balance Sheet");
                if blnHideEndTotal then
                    recGLAccount.SetRange("Account Type", recGLAccount."Account Type"::Posting);
                recGLAccount.FindFirst();
                repeat
                    recGLToCalculate.Reset();
                    recGLToCalculate.SetRange("No.", recGLAccount."No.");

                    recDate.Reset();
                    recDate.SetRange("Period Type", recDate."Period Type"::Month);
                    recDate.SetRange("Period Start", dtPeriodStart, ClosingDate(dtPeriodEnd));
                    if recDate.FindFirst() then
                        repeat
                            recGLToCalculate.SetFilter("Date Filter", '%1..%2', recDate."Period Start", ClosingDate(recDate."Period End"));
                            recGLToCalculate.FindFirst();
                            recGLToCalculate.CalcFields("Net Change");

                            recTrialAmount.Reset();
                            recTrialAmount.SetRange("Account No.", recGLAccount."No.");
                            if recTrialAmount.FindFirst() then begin
                                if recDate."Period No." = 4 then
                                    recTrialAmount.Amount := recGLToCalculate."Net Change";
                                if recDate."Period No." = 5 then
                                    recTrialAmount."Amount (LCY)" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 6 then
                                    recTrialAmount."Amount Before Adjustment" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 7 then
                                    recTrialAmount."Amount Excl. GST" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 8 then
                                    recTrialAmount."GST Amount on Hold" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 9 then
                                    recTrialAmount."VAT Amount" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 10 then
                                    recTrialAmount."VAT Amount (LCY)" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 11 then
                                    recTrialAmount."Debit Amount" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 12 then
                                    recTrialAmount."Credit Amount" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 1 then
                                    recTrialAmount."Bal. VAT Amount" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 2 then
                                    recTrialAmount."Bal. VAT Amount (LCY)" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 3 then
                                    recTrialAmount."VAT Base Amount" := recGLToCalculate."Net Change";
                                recTrialAmount.Modify();
                            end else begin
                                recTrialAmount.Init();
                                intLineNo += 1;
                                recTrialAmount."Line No." := intLineNo;
                                recTrialAmount."Account No." := recGLAccount."No.";

                                if recDate."Period No." = 4 then
                                    recTrialAmount.Amount := recGLToCalculate."Net Change";
                                if recDate."Period No." = 5 then
                                    recTrialAmount."Amount (LCY)" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 6 then
                                    recTrialAmount."Amount Before Adjustment" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 7 then
                                    recTrialAmount."Amount Excl. GST" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 8 then
                                    recTrialAmount."GST Amount on Hold" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 9 then
                                    recTrialAmount."VAT Amount" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 10 then
                                    recTrialAmount."VAT Amount (LCY)" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 11 then
                                    recTrialAmount."Debit Amount" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 12 then
                                    recTrialAmount."Credit Amount" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 1 then
                                    recTrialAmount."Bal. VAT Amount" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 2 then
                                    recTrialAmount."Bal. VAT Amount (LCY)" := recGLToCalculate."Net Change";
                                if recDate."Period No." = 3 then
                                    recTrialAmount."VAT Base Amount" := recGLToCalculate."Net Change";
                                recTrialAmount.Insert();
                            end;
                        until recDate.Next() = 0;
                until recGLAccount.Next() = 0;
                Clear(decSumAmount);

                recTrialAmount.Reset();
                Integer.SetRange(Number, 1, recTrialAmount.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                recTrialAmount.Reset();
                recTrialAmount.SetRange("Line No.", Integer.Number);
                recTrialAmount.FindFirst();

                recGLAccount.Get(recTrialAmount."Account No.");
                if recGLAccount."Account Type" <> recGLAccount."Account Type"::Posting then begin
                    intHighLight := 1;

                    /*
                    decSumAmount[1] += recTrialAmount.Amount;
                    decSumAmount[2] += recTrialAmount."Amount (LCY)";
                    decSumAmount[3] += recTrialAmount."Amount Before Adjustment";
                    decSumAmount[4] += recTrialAmount."Amount Excl. GST";
                    decSumAmount[5] += recTrialAmount."GST Amount on Hold";
                    decSumAmount[6] += recTrialAmount."VAT Amount";
                    decSumAmount[7] += recTrialAmount."VAT Amount (LCY)";
                    decSumAmount[8] += recTrialAmount."Debit Amount";
                    decSumAmount[9] += recTrialAmount."Credit Amount";
                    decSumAmount[10] += recTrialAmount."Bal. VAT Amount";
                    decSumAmount[11] += recTrialAmount."Bal. VAT Amount (LCY)";
                    decSumAmount[12] += recTrialAmount."VAT Base Amount";
                    */
                end else
                    intHighLight := 0;
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
                    field(intYear; intYear)
                    {
                        Caption = 'Year e.g. 2022 for 2022-23';
                        BlankZero = true;
                        ApplicationArea = all;
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

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'Customization\Reports\50190_TrialBalanceMonthly.rdl';
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        intYear: Integer;
        txtHeading: Text;
        recDate: Record Date;
        recTrialAmount: Record "Gen. Journal Line" temporary;
        intLineNo: Integer;
        recGLAccount: Record "G/L Account";
        dtPeriodStart: Date;
        dtPeriodEnd: Date;
        intHighLight: Integer;
        decSumAmount: array[12] of Decimal;
        recGLToCalculate: Record "G/L Account";
        opAccountType: Option " ","Income Statement","Balance Sheet";
        blnHideEndTotal: Boolean;
}