report 50186 "G/L LOB LOC and Dept. Monthly"
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
            column(ReportHeading; txtReportHeading) { }
            column(GLNo; recReportData."Account No.") { }
            column(GLName; recReportData.Description) { }
            column(IncomeBalance; Format(recGLAccount."Income/Balance")) { }
            column(AccountCategory; Format(recGLAccount."Account Category")) { }
            column(GroupName; recGLAccount."Group Name") { }
            column(SubGroupName; recGLAccount."Sub Group Name") { }
            column(SUbCategory; recGLAccount."Account Subcategory Descript.") { }
            column(DirectPosting; Format(recGLAccount."Direct Posting")) { }
            column(AccountType; recReportData."Message to Recipient") { }
            column(GLAmount; recReportData."Amount (LCY)") { }
            column(LOBCode; recReportData."Shortcut Dimension 1 Code") { }
            column(LocationCode; recReportData."Job No.") { }
            column(DepartmentCode; recReportData."Shortcut Dimension 2 Code") { }
            column(MonthSorting; recReportData."FA Error Entry No.") { }
            column(MonthName; recReportData."VAT Registration No.") { }

            trigger OnPreDataItem()
            begin
                if intYear = 0 then
                    Error('Enter the year to view the report.');
                dtFromDate := DMY2Date(1, 4, intYear);
                dtToDate := DMY2Date(31, 3, intYear + 1);

                recCompanyInfo.Get();
                txtReportHeading := 'G/L Account, LOB, Location and Department wise Monthly Balance Report for the financial year ' + Format(intYear) + '-' + Format(intYear + 1);

                recReportData.Reset();
                recReportData.DeleteAll();
                intLineNo := 0;

                Clear(qryReport50186);
                if cdGLAccount <> '' then
                    qryReport50186.SetFilter(G_L_Account_No_, cdGLAccount);
                qryReport50186.SetRange(Posting_Date, dtFromDate, dtToDate);
                qryReport50186.Open();
                while qryReport50186.Read() do begin
                    recGLAccount.Get(qryReport50186.G_L_Account_No_);
                    intMonth := Date2DMY(qryReport50186.Posting_Date, 2);
                    opMonth := intMonth;

                    recReportData.Reset();
                    recReportData.SetRange("Journal Template Name", Format(intMonth));
                    recReportData.SetRange("Account No.", qryReport50186.G_L_Account_No_);
                    recReportData.SetRange("Shortcut Dimension 1 Code", qryReport50186.Global_Dimension_1_Code);
                    recReportData.SetRange("Shortcut Dimension 2 Code", qryReport50186.Global_Dimension_2_Code);
                    recReportData.SetRange("Job No.", qryReport50186.LOC);
                    if recReportData.FindFirst() then begin
                        recReportData."Amount (LCY)" += qryReport50186.Amount;
                        recReportData.Modify();
                    end else begin
                        recReportData.Init();
                        recReportData."Journal Template Name" := Format(intMonth);
                        intLineNo += 1;
                        recReportData."Line No." := intLineNo;
                        recReportData."VAT Registration No." := Format(opMonth);

                        if intMonth > 3 then
                            recReportData."FA Error Entry No." := intMonth - 3
                        else
                            recReportData."FA Error Entry No." := intMonth + 9;
                        recReportData."Account No." := qryReport50186.G_L_Account_No_;
                        recReportData.Description := recGLAccount.Name;
                        recReportData."Message to Recipient" := Format(recGLAccount."Account Type");
                        recReportData."Amount (LCY)" := qryReport50186.Amount;
                        recReportData."Shortcut Dimension 1 Code" := qryReport50186.Global_Dimension_1_Code;
                        recReportData."Shortcut Dimension 2 Code" := qryReport50186.Global_Dimension_2_Code;
                        recReportData."Job No." := qryReport50186.LOC;
                        recReportData.Insert();
                    end;
                end;
                qryReport50186.Close();

                Integer.SetRange(Number, 1, intLineNo);
            end;

            trigger OnAfterGetRecord()
            begin
                recReportData.Reset();
                recReportData.SetRange("Line No.", Integer.Number);
                recReportData.FindFirst();
                recGLAccount.Get(recReportData."Account No.");
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
                    Caption = 'Filters';
                    field(intYear; intYear)
                    {
                        Caption = 'Enter Year e.g. 2022 for 2022-23';
                        ApplicationArea = all;
                        BlankZero = true;
                    }
                    field(cdGLAccount; cdGLAccount)
                    {
                        Caption = 'G/L Account';
                        ApplicationArea = all;
                        TableRelation = "G/L Account";
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
            LayoutFile = 'Customization\Reports\50186_GLLobLocDepMonthly.rdl';
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        txtReportHeading: Text;
        intYear: Integer;
        dtFromDate: Date;
        dtToDate: Date;
        cdGLAccount: Code[20];
        recReportData: Record "Gen. Journal Line" temporary;
        intLineNo: Integer;
        qryReport50186: Query "Report 50186";
        recGLAccount: Record "G/L Account";
        intMonth: Integer;
        opMonth: Option " ","January","February","March","April","May","June","July","August","September","October","November","December";
}