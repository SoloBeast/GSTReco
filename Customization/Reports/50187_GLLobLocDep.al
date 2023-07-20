report 50187 "G/L, LOB, LOC and Dept."
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
            column(AccountType; Format(recGLAccount."Account Type")) { }
            column(GLAmount; recReportData."Amount (LCY)") { }
            column(LOBCode; recReportData."Shortcut Dimension 1 Code") { }
            column(LocationCode; recReportData."Job No.") { }
            column(DepartmentCode; recReportData."Shortcut Dimension 2 Code") { }

            trigger OnPreDataItem()
            begin
                if (dtFromDate = 0D) or (dtToDate = 0D) then
                    Error('The From or To Date must not be blank.');

                recCompanyInfo.Get();
                txtReportHeading := 'G/L Account, LOB, Location and Department wise Balance Report from ' + Format(dtFromDate) + ' to ' + Format(dtToDate);

                recReportData.Reset();
                recReportData.DeleteAll();
                intLineNo := 0;

                Clear(qryReport50187);
                if cdGLAccount <> '' then
                    qryReport50187.SetFilter(G_L_Account_No_, cdGLAccount);
                qryReport50187.SetRange(Posting_Date, dtFromDate, dtToDate);
                qryReport50187.Open();
                while qryReport50187.Read() do begin
                    recGLAccount.Get(qryReport50187.G_L_Account_No_);

                    recReportData.Init();
                    intLineNo += 1;
                    recReportData."Line No." := intLineNo;
                    recReportData."Account No." := qryReport50187.G_L_Account_No_;
                    recReportData.Description := recGLAccount.Name;
                    recReportData."Message to Recipient" := Format(recGLAccount."Account Type");
                    recReportData."Amount (LCY)" := qryReport50187.Amount;
                    recReportData."Shortcut Dimension 1 Code" := qryReport50187.Global_Dimension_1_Code;
                    recReportData."Shortcut Dimension 2 Code" := qryReport50187.Global_Dimension_2_Code;
                    recReportData."Job No." := qryReport50187.LOC;
                    recReportData.Insert();
                end;
                qryReport50187.Close();

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
                    field(dtFromDate; dtFromDate)
                    {
                        ApplicationArea = all;
                        Caption = 'From Date';
                    }
                    field(dtToDate; dtToDate)
                    {
                        ApplicationArea = all;
                        Caption = 'To Date';
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
            LayoutFile = 'Customization\Reports\50187_GLLobLocDep.rdl';
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        txtReportHeading: Text;
        dtFromDate: Date;
        dtToDate: Date;
        cdGLAccount: Code[20];
        recReportData: Record "Gen. Journal Line" temporary;
        intLineNo: Integer;
        qryReport50187: Query "Report 50187";
        recGLAccount: Record "G/L Account";
}