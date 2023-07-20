report 50007 "Dimension Ledger"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\DimensionLedger_Iappc_50007.rdl';

    dataset
    {
        dataitem("Analysis View"; "Analysis View")
        {
            DataItemTableView = sorting(code);
            column(CompanyName; recCompanyInfo.Name)
            { }
            column(Heading; txtHeading)
            { }
            column(txtFilters; txtFilters)
            { }
            dataitem(Integer; Integer)
            {
                DataItemTableView = sorting(Number);
                column(AccountNo; recGLAccount."No.")
                { }
                column(AccountName; recGLAccount.Name)
                { }
                column(DimensionCode; recDimensionValue.Code)
                { }
                column(DimensionName; recDimensionValue.Name)
                { }
                column(OpeningBalance; decOpeningBalance)
                { }
                dataitem("Analysis View Entry"; "Analysis View Entry")
                {
                    DataItemTableView = sorting("Analysis View Code", "Account No.", "Account Source", "Dimension 1 Value Code",
                                                    "Dimension 2 Value Code", "Dimension 3 Value Code", "Dimension 4 Value Code",
                                                    "Business Unit Code", "Posting Date", "Entry No.", "Cash Flow Forecast No.");
                    column(DocumentNo; recGLEntry."Document No.")
                    { }
                    column(Narration; txtNarration)
                    { }
                    column(Posting_Date; format(NormalDate("Posting Date")))
                    { }
                    column(Debit_Amount; "Debit Amount")
                    { }
                    column(Credit_Amount; "Credit Amount")
                    { }
                    column(RunningBalance; decRunningBalance)
                    { }
                    //Triggers for Analysis View Entry
                    trigger OnPreDataItem()
                    begin
                        "Analysis View Entry".SETRANGE("Analysis View Code", cdAnalysisView);
                        "Analysis View Entry".SETRANGE("Account No.", recMasterGroup."Account No.");
                        IF intDimensionNo = 1 THEN
                            "Analysis View Entry".SETRANGE("Dimension 1 Value Code", recMasterGroup."Dimension 1 Value Code")
                        ELSE
                            IF intDimensionNo = 2 THEN
                                "Analysis View Entry".SETRANGE("Dimension 2 Value Code", recMasterGroup."Dimension 1 Value Code")
                            ELSE
                                IF intDimensionNo = 3 THEN
                                    "Analysis View Entry".SETRANGE("Dimension 3 Value Code", recMasterGroup."Dimension 1 Value Code")
                                ELSE
                                    "Analysis View Entry".SETRANGE("Dimension 4 Value Code", recMasterGroup."Dimension 1 Value Code");
                        "Analysis View Entry".SETRANGE("Posting Date", dtFromDate, dtToDate);

                    end;

                    trigger OnAfterGetRecord()
                    begin
                        decRunningBalance := decRunningBalance + "Analysis View Entry"."Debit Amount" - "Analysis View Entry"."Credit Amount";
                        recGLEntry.GET("Analysis View Entry"."Entry No.");

                        txtNarration := '';
                        recpurchcommline.RESET;
                        recpurchcommline.SETRANGE("No.", recGLEntry."Document No.");
                        IF recpurchcommline.FIND('-') THEN
                            REPEAT
                                txtNarration += ' ' + recpurchcommline.Comment;
                            UNTIL recpurchcommline.NEXT = 0;

                        recSalescommline.RESET;
                        recSalescommline.SETRANGE("No.", recGLEntry."Document No.");
                        IF recSalescommline.FIND('-') THEN
                            REPEAT
                                txtNarration += ' ' + recSalescommline.Comment;
                            UNTIL recSalescommline.NEXT = 0;

                        recPostedNarration.Reset();
                        recPostedNarration.SetRange("Document No.", recGLEntry."Document No.");
                        recPostedNarration.SetRange("Transaction No.", recGLEntry."Transaction No.");
                        if recPostedNarration.FindFirst() then
                            repeat
                                txtNarration += ' ' + recPostedNarration.Narration;
                            until recPostedNarration.Next() = 0;

                        if txtNarration = '' then
                            txtNarration := recGLEntry.Description;
                    end;

                }
                //triggers for Integer
                trigger OnPreDataItem()
                begin
                    recMasterGroup.RESET;
                    Integer.SETRANGE(Number, 1, recMasterGroup.COUNT);
                    cdLoopCode := '00000';

                end;

                trigger OnAfterGetRecord()
                begin
                    cdLoopCode := INCSTR(cdLoopCode);
                    recMasterGroup.RESET;
                    recMasterGroup.SETRANGE("Analysis View Code", cdLoopCode);
                    recMasterGroup.FINDFIRST;

                    decOpeningBalance := 0;
                    recAnalysisViewEntry.RESET;
                    recAnalysisViewEntry.SETRANGE("Analysis View Code", cdAnalysisView);
                    recAnalysisViewEntry.SETRANGE("Account No.", recMasterGroup."Account No.");
                    IF intDimensionNo = 1 THEN
                        recAnalysisViewEntry.SETRANGE("Dimension 1 Value Code", recMasterGroup."Dimension 1 Value Code")
                    ELSE
                        IF intDimensionNo = 2 THEN
                            recAnalysisViewEntry.SETRANGE("Dimension 2 Value Code", recMasterGroup."Dimension 1 Value Code")
                        ELSE
                            IF intDimensionNo = 3 THEN
                                recAnalysisViewEntry.SETRANGE("Dimension 3 Value Code", recMasterGroup."Dimension 1 Value Code")
                            ELSE
                                recAnalysisViewEntry.SETRANGE("Dimension 4 Value Code", recMasterGroup."Dimension 1 Value Code");
                    recAnalysisViewEntry.SETRANGE("Posting Date", 0D, dtFromDate - 1);
                    IF recAnalysisViewEntry.FINDFIRST THEN BEGIN
                        recAnalysisViewEntry.CALCSUMS(Amount);
                        decOpeningBalance := recAnalysisViewEntry.Amount;
                    END;
                    decRunningBalance := decOpeningBalance;

                    recGLAccount.GET(recMasterGroup."Account No.");
                    recDimensionValue.GET(cdDimensionCode, recMasterGroup."Dimension 1 Value Code");

                end;
            }
            //Triggers for Analysis View
            trigger OnPreDataItem()
            begin
                recCompanyInfo.GET;

                IF cdAnalysisView = '' THEN
                    ERROR('Select analysis view to generate ledger.');
                IF cdGLAccountNo = '' THEN
                    ERROR('Select G/L Account to generate ledger.');
                IF cdDimensionCode = '' THEN
                    ERROR('Select Dimension code to generate ledger.');
                IF (dtFromDate = 0D) OR (dtToDate = 0D) THEN
                    ERROR('The From or To Date must not be blank.');

                txtHeading := 'Dimension wise Account Ledger for the period starting from ' + FORMAT(dtFromDate) + ' to ' + FORMAT(dtToDate);

                recMasterGroup.RESET;
                recMasterGroup.DELETEALL;

                "Analysis View".SETRANGE(Code, cdAnalysisView);

            end;

            trigger OnAfterGetRecord()
            begin
                cdLoopCode := '00000';
                recGLAccount.RESET;
                IF cdGLAccountNo <> '' THEN
                    recGLAccount.SETRANGE("No.", cdGLAccountNo);
                IF recGLAccount.FINDFIRST THEN
                    REPEAT
                        recDimensionValue.RESET;
                        recDimensionValue.SETRANGE("Dimension Code", cdDimensionCode);
                        IF cdDimensionValueCode <> '' THEN
                            recDimensionValue.SETRANGE(Code, cdDimensionValueCode);
                        IF recDimensionValue.FINDFIRST THEN
                            REPEAT
                                recMasterGroup.INIT;
                                cdLoopCode := INCSTR(cdLoopCode);
                                recMasterGroup."Analysis View Code" := cdLoopCode;
                                recMasterGroup."Account No." := recGLAccount."No.";
                                recMasterGroup."Dimension 1 Value Code" := recDimensionValue.Code;
                                recMasterGroup.INSERT;
                            UNTIL recDimensionValue.NEXT = 0;
                    UNTIL recGLAccount.NEXT = 0;

                intDimensionNo := 0;
                IF "Analysis View"."Dimension 1 Code" = cdDimensionCode THEN
                    intDimensionNo := 1
                ELSE
                    IF "Analysis View"."Dimension 2 Code" = cdDimensionCode THEN
                        intDimensionNo := 2
                    ELSE
                        IF "Analysis View"."Dimension 3 Code" = cdDimensionCode THEN
                            intDimensionNo := 3
                        ELSE
                            IF "Analysis View"."Dimension 4 Code" = cdDimensionCode THEN
                                intDimensionNo := 4
                            ELSE
                                ERROR('Invalid dimension code.');

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(cdAnalysisView; cdAnalysisView)
                    {
                        Caption = 'Analysis View';
                        TableRelation = "Analysis View";
                        ApplicationArea = All;
                    }
                    field(cdGLAccountNo; cdGLAccountNo)
                    {
                        Caption = 'G/L Account No.';
                        ApplicationArea = all;
                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            recAnalysisView.GET(cdAnalysisView);
                            recGLAccount.RESET;
                            recGLAccount.FILTERGROUP(2);
                            IF recAnalysisView."Account Filter" <> '' THEN
                                recGLAccount.SETFILTER("No.", recAnalysisView."Account Filter");
                            recGLAccount.FILTERGROUP(0);
                            IF PAGE.RUNMODAL(0, recGLAccount) = ACTION::LookupOK THEN BEGIN
                                cdGLAccountNo := recGLAccount."No.";
                            END;

                        end;
                    }
                    field(cdDimensionCode; cdDimensionCode)
                    {
                        Caption = 'Dimension Code';
                        ApplicationArea = all;
                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            recAnalysisView.GET(cdAnalysisView);
                            IF recAnalysisView."Dimension 1 Code" <> '' THEN
                                txtDimensionCodeFilter := recAnalysisView."Dimension 1 Code";
                            IF recAnalysisView."Dimension 2 Code" <> '' THEN BEGIN
                                IF txtDimensionCodeFilter = '' THEN
                                    txtDimensionCodeFilter := recAnalysisView."Dimension 2 Code"
                                ELSE
                                    txtDimensionCodeFilter := txtDimensionCodeFilter + '|' + recAnalysisView."Dimension 2 Code";
                            END;
                            IF recAnalysisView."Dimension 3 Code" <> '' THEN BEGIN
                                IF txtDimensionCodeFilter = '' THEN
                                    txtDimensionCodeFilter := recAnalysisView."Dimension 2 Code"
                                ELSE
                                    txtDimensionCodeFilter := txtDimensionCodeFilter + '|' + recAnalysisView."Dimension 3 Code";
                            END;
                            IF recAnalysisView."Dimension 4 Code" <> '' THEN BEGIN
                                IF txtDimensionCodeFilter = '' THEN
                                    txtDimensionCodeFilter := recAnalysisView."Dimension 2 Code"
                                ELSE
                                    txtDimensionCodeFilter := txtDimensionCodeFilter + '|' + recAnalysisView."Dimension 4 Code";
                            END;

                            recDimension.RESET;
                            recDimension.FILTERGROUP(2);
                            recDimension.SETFILTER(Code, txtDimensionCodeFilter);
                            recDimension.FILTERGROUP(0);
                            IF PAGE.RUNMODAL(0, recDimension) = ACTION::LookupOK THEN BEGIN
                                cdDimensionCode := recDimension.Code;
                            END;

                        end;
                    }
                    field(cdDimensionValueCode; cdDimensionValueCode)
                    {
                        Caption = 'Dimension Value Code';
                        ApplicationArea = all;
                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            IF cdDimensionCode = '' THEN
                                ERROR('Select dimension code first to select dimension value.');

                            recDimensionValue.RESET;
                            recDimensionValue.FILTERGROUP(2);
                            recDimensionValue.SETFILTER("Dimension Code", cdDimensionCode);
                            recDimensionValue.FILTERGROUP(0);
                            IF PAGE.RUNMODAL(0, recDimensionValue) = ACTION::LookupOK THEN BEGIN
                                cdDimensionValueCode := recDimensionValue.Code;
                            END;

                        end;
                    }
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
                }
            }
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        txtHeading: Text[250];
        txtFilters: Text;
        recGLAccount: Record "G/L Account";
        recDimensionValue: Record "Dimension Value";
        decOpeningBalance: Decimal;
        recGLEntry: Record "G/L Entry";
        txtNarration: Text;
        decRunningBalance: Decimal;
        cdAnalysisView: Code[20];
        recMasterGroup: Record "Analysis View Entry" temporary;
        intDimensionNo: Integer;
        dtFromDate: Date;
        dtToDate: Date;
        recPostedNarration: Record "Posted Narration";
        recPurchCommLine: Record "Purch. Comment Line";
        recSalesCommLine: Record "Sales Comment Line";
        cdLoopCode: Code[10];
        recAnalysisViewEntry: Record "Analysis View Entry";
        cdDimensionCode: Code[20];
        cdGLAccountNo: Code[20];
        cdDimensionValueCode: Code[20];
        recAnalysisView: Record "Analysis View";
        txtDimensionCodeFilter: Text;
        recDimension: Record Dimension;
}