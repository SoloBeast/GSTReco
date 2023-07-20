report 50183 "G/L Dimension Details"
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
            column(GLName; recGLAccount.Name) { }
            column(IncomeBalance; Format(recGLAccount."Income/Balance")) { }
            column(AccountCategory; Format(recGLAccount."Account Category")) { }
            column(GroupName; recGLAccount."Group Name") { }
            column(SubGroupName; recGLAccount."Sub Group Name") { }
            column(SUbCategory; recGLAccount."Account Subcategory Descript.") { }
            column(DirectPosting; Format(recGLAccount."Direct Posting")) { }
            column(AccountType; Format(recGLAccount."Account Type")) { }
            column(DimCode; recReportData."Shortcut Dimension 1 Code") { }
            column(DimName; recReportData."Transaction Information") { }
            column(GLAmount; recReportData."Amount (LCY)") { }

            trigger OnPreDataItem()
            begin
                if (dtFromDate = 0D) or (dtToDate = 0D) then
                    Error('The From or To Date must not be blank.');
                if opDimToView = 0 then
                    Error('Select the Basis of Analysis');

                recCompanyInfo.Get();
                txtReportHeading := 'G/L Account and ' + Format(opDimToView) + ' wise Detail Report from ' + Format(dtFromDate) + ' to ' + Format(dtToDate);

                recReportData.Reset();
                recReportData.DeleteAll();
                intLineNo := 0;

                if opDimToView = opDimToView::"Line of Business" then begin
                    Clear(qryReport50185_LOB);
                    if cdGLAccount <> '' then
                        qryReport50185_LOB.SetFilter(G_L_Account_No_, cdGLAccount);
                    qryReport50185_LOB.SetRange(Posting_Date, dtFromDate, dtToDate);
                    qryReport50185_LOB.Open();
                    while qryReport50185_LOB.Read() do begin
                        recDimensionValue.Reset();
                        recDimensionValue.SetRange("Global Dimension No.", 1);
                        recDimensionValue.SetRange(Code, qryReport50185_LOB.Global_Dimension_1_Code);
                        if not recDimensionValue.FindFirst() then
                            recDimensionValue.Init();

                        recReportData.Reset();
                        recReportData.SetRange("Account No.", qryReport50185_LOB.G_L_Account_No_);
                        recReportData.SetRange("Shortcut Dimension 1 Code", qryReport50185_LOB.Global_Dimension_1_Code);
                        if recReportData.FindFirst() then begin
                            recReportData."Amount (LCY)" += qryReport50185_LOB.Amount;
                            recReportData.Modify();
                        end else begin
                            recReportData.Init();
                            intLineNo += 1;
                            recReportData."Line No." := intLineNo;
                            recReportData."Account No." := qryReport50185_LOB.G_L_Account_No_;
                            recReportData."Shortcut Dimension 1 Code" := qryReport50185_LOB.Global_Dimension_1_Code;
                            recReportData."Transaction Information" := recDimensionValue.Name;
                            recReportData."Amount (LCY)" := qryReport50185_LOB.Amount;
                            recReportData.Insert();
                        end;

                    end;
                    qryReport50185_LOB.Close();
                end;
                if opDimToView = opDimToView::Location then begin
                    Clear(qryReport50185_LOC);
                    if cdGLAccount <> '' then
                        qryReport50185_LOC.SetFilter(G_L_Account_No_, cdGLAccount);
                    qryReport50185_LOC.SetRange(Posting_Date, dtFromDate, dtToDate);
                    qryReport50185_LOC.Open();
                    while qryReport50185_LOC.Read() do begin
                        recDimensionValue.Reset();
                        recDimensionValue.SetRange("Global Dimension No.", 2);
                        recDimensionValue.SetRange(Code, qryReport50185_LOC.LOC);
                        if not recDimensionValue.FindFirst() then
                            recDimensionValue.Init();

                        recReportData.Reset();
                        recReportData.SetRange("Account No.", qryReport50185_LOC.G_L_Account_No_);
                        recReportData.SetRange("Shortcut Dimension 1 Code", qryReport50185_LOC.LOC);
                        if recReportData.FindFirst() then begin
                            recReportData."Amount (LCY)" += qryReport50185_LOC.Amount;
                            recReportData.Modify();
                        end else begin
                            recReportData.Init();
                            intLineNo += 1;
                            recReportData."Line No." := intLineNo;
                            recReportData."Account No." := qryReport50185_LOC.G_L_Account_No_;
                            recReportData."Shortcut Dimension 1 Code" := qryReport50185_LOC.LOC;
                            recReportData."Transaction Information" := recDimensionValue.Name;
                            recReportData."Amount (LCY)" := qryReport50185_LOC.Amount;
                            recReportData.Insert();
                        end;
                    end;
                    qryReport50185_LOC.Close();
                end;
                if opDimToView = opDimToView::Department then begin
                    Clear(qryReport50185_Dept);
                    if cdGLAccount <> '' then
                        qryReport50185_Dept.SetFilter(G_L_Account_No_, cdGLAccount);
                    qryReport50185_Dept.SetRange(Posting_Date, dtFromDate, dtToDate);
                    qryReport50185_Dept.Open();
                    while qryReport50185_Dept.Read() do begin
                        recDimensionValue.Reset();
                        recDimensionValue.SetRange("Global Dimension No.", 3);
                        recDimensionValue.SetRange(Code, qryReport50185_Dept.Global_Dimension_2_Code);
                        if not recDimensionValue.FindFirst() then
                            recDimensionValue.Init();

                        recReportData.Reset();
                        recReportData.SetRange("Account No.", qryReport50185_Dept.G_L_Account_No_);
                        recReportData.SetRange("Shortcut Dimension 1 Code", qryReport50185_Dept.Global_Dimension_2_Code);
                        if recReportData.FindFirst() then begin
                            recReportData."Amount (LCY)" += qryReport50185_Dept.Amount;
                            recReportData.Modify();
                        end else begin
                            recReportData.Init();
                            intLineNo += 1;
                            recReportData."Line No." := intLineNo;
                            recReportData."Account No." := qryReport50185_Dept.G_L_Account_No_;
                            recReportData."Shortcut Dimension 1 Code" := qryReport50185_Dept.Global_Dimension_2_Code;
                            recReportData."Transaction Information" := recDimensionValue.Name;
                            recReportData."Amount (LCY)" := qryReport50185_Dept.Amount;
                            recReportData.Insert();
                        end;
                    end;
                    qryReport50185_Dept.Close();
                end;

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
                        Caption = 'From Date';
                        ApplicationArea = all;
                    }
                    field(dtToDate; dtToDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea = all;
                    }
                    field(opDimToView; opDimToView)
                    {
                        Caption = 'Analysis Based On';
                        ApplicationArea = all;
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
            LayoutFile = 'Customization\Reports\50183_GLLobLocDeptDetail.rdl';
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        txtReportHeading: Text;
        dtFromDate: Date;
        dtToDate: Date;
        opDimToView: Option " ","Line of Business","Location","Department";
        cdGLAccount: Code[20];
        recReportData: Record "Gen. Journal Line" temporary;
        intLineNo: Integer;
        qryReport50185_LOB: Query "Report 50185 GL / LOB";
        qryReport50185_LOC: Query "Report 50185 GL / LOC";
        qryReport50185_Dept: Query "Report 50187 GL / Dept.";
        recGLAccount: Record "G/L Account";
        recDimensionValue: Record "Dimension Value";
}