report 50039 "FA Register"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\FARegister_Iappc_50039.rdl';

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            DataItemTableView = sorting("No.");

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; 'Fixed Asset Register for the Period Starting from ' + format(dtFromDate) + ' to ' + Format(dtToDate)) { }
            column(UserID; UserId) { }
            column(TimeStamp; Format(CurrentDateTime)) { }
            column(FromDate; Format(dtFromDate)) { }
            column(ToDate; Format(dtToDate)) { }
            column(SrNo; intSrNo) { }
            column(AssetNo; "No.") { }
            column(AssetGroup; "FA Class Code") { }
            column(SubGroup; "FA Subclass Code") { }
            column(AssetDescription; Description) { }
            column(FALocation; "FA Location Code") { }
            column(EmployeeNo; "Responsible Employee") { }
            column(EmployeeName; txtEmployeeName) { }
            column(TaggingNo; "Tagging No.") { }
            column(SerialNo; "Serial No.") { }
            column(PostingGroup; recFADepBook."FA Posting Group") { }
            column(DepreciationMethod; Format(recFADepBook."Depreciation Method")) { }
            column(PurchInvNo; cdPurchInvNo) { }
            column(VendorName; txtVendorName) { }
            column(ManufacturerName; Manufacturer) { }
            column(Insurance; Format(Insured)) { }
            column(LOB; cdLOB) { }
            column(FAFunction; cdFunction) { }
            column(Quantity; 1) { }
            column(AdditionDate; Format(dtPutToUse)) { }
            column(UseFulLife; decTotalLife) { }
            column(UsedTillOpening; decLifeUsed) { }
            column(RemainingLife; decTotalLife - decLifeUsed) { }
            column(DepreciationRate; decDepRate) { }
            column(AssetAmount; decAcquisitionCost) { }
            column(SalvageValue; decSalvage) { }
            column(DepAmountOpening; decDepAmtOpening) { }
            column(WDVTillOpening; decAcquisitionCost - decDepAmtOpening) { }
            column(DepDuringYear; decDepCurrPeriod) { }
            column(WDVOnClosing; decAcquisitionCost - decDepAmtOpening - decDepCurrPeriod) { }
            column(AccumulatedDep; decDepAmtOpening + decDepCurrPeriod) { }
            column(OriginalCost; decAcquisitionCost) { }
            column(DepUpToSale; decDepOnSales) { }
            column(WDVOnSale; decWDVForSales) { }
            column(SaleValue; decSalesValue) { }
            column(ProfitLoss; decGainLoss) { }
            column(SalesInvoiceNo; cdInvoiceNo) { }
            column(SalesInvoiceDate; Format(dtInvoiceDate)) { }

            trigger OnPreDataItem()
            begin
                if (Format(dtFromDate) = '') and (Format(dtToDate) = '') then
                    Error('The From or To Date must not be blank.');

                recCompanyInfo.Get();
                intSrNo := 0;
                recFASetup.Get();
                recFASetup.TestField("Default Depr. Book");

                recGLSetup.Get();
            end;

            trigger OnAfterGetRecord()
            begin
                intSrNo += 1;
                dtPutToUse := 0D;
                decTotalLife := 0;
                decAcquisitionCost := 0;
                decDepOnSales := 0;
                decSalesValue := 0;
                cdInvoiceNo := '';
                dtInvoiceDate := 0D;
                txtEmployeeName := '';
                cdPurchInvNo := '';
                txtVendorName := '';
                cdLOB := '';
                cdFunction := '';
                decSalvage := 0;

                if recEmployee.Get("Responsible Employee") then
                    txtEmployeeName := recEmployee.FullName();

                recDefaultDimension.Reset();
                recDefaultDimension.SetRange("Table ID", 5600);
                recDefaultDimension.SetRange("No.", "No.");
                recDefaultDimension.SetRange("Dimension Code", recGLSetup."Global Dimension 1 Code");
                if recDefaultDimension.FindFirst() then
                    cdLOB := recDefaultDimension."Dimension Value Code";

                recDefaultDimension.SetRange("Dimension Code", recGLSetup."Global Dimension 2 Code");
                if recDefaultDimension.FindFirst() then
                    cdFunction := recDefaultDimension."Dimension Value Code";

                recFALedger.Reset();
                recFALedger.SetRange("FA No.", "Fixed Asset"."No.");
                recFALedger.SetRange("FA Posting Type", recFALedger."FA Posting Type"::"Acquisition Cost");
                if recFALedger.FindFirst() then begin
                    cdPurchInvNo := recFALedger."Document No.";

                    recVendorLedger.Reset();
                    recVendorLedger.SetRange("Document No.", recFALedger."Document No.");
                    recVendorLedger.SetRange("Posting Date", recFALedger."Posting Date");
                    if recVendorLedger.FindFirst() then begin
                        recVendorLedger.CalcFields("Vendor Name");
                        txtVendorName := recVendorLedger."Vendor Name";
                    end;
                end;

                recFALedger.SetRange("FA Posting Type", recFALedger."FA Posting Type"::"Salvage Value");
                if recFALedger.FindFirst() then
                    repeat
                        decSalvage += recFALedger."Amount (LCY)";
                    until recFALedger.Next() = 0;
                decSalvage := Abs(decSalvage);
                recFALedger.SetRange("FA Posting Type");

                decDepAmtOpening := 0;
                recFALedger.SetRange("Posting Date", 0D, dtFromDate - 1);
                recFALedger.SetRange("FA Posting Type", recFALedger."FA Posting Type"::Depreciation);
                if recFALedger.FindSet() then
                    repeat
                        decDepAmtOpening += -recFALedger."Amount (LCY)";
                    until recFALedger.Next() = 0;

                decDepCurrPeriod := 0;
                recFALedger.SetRange("Posting Date", dtFromDate, dtToDate);
                if recFALedger.FindSet() then
                    repeat
                        decDepCurrPeriod += -recFALedger."Amount (LCY)";
                    until recFALedger.Next() = 0;

                recFADepBook.Reset();
                recFADepBook.SetRange("FA No.", "Fixed Asset"."No.");
                recFADepBook.SetRange("Depreciation Book Code", recFASetup."Default Depr. Book");
                if recFADepBook.FindFirst() then begin
                    dtPutToUse := recFADepBook."Depreciation Starting Date";
                    decTotalLife := recFADepBook."No. of Depreciation Years";
                    recFADepBook.CalcFields("Acquisition Cost");
                    decAcquisitionCost := recFADepBook."Acquisition Cost";
                    decDepRate := recFADepBook."Declining-Balance %";

                    if recFADepBook."Disposal Date" <> 0D then begin
                        if recFADepBook."Disposal Date" < dtToDate then begin
                            recFADepBook.CalcFields("Proceeds on Disposal", "Gain/Loss");
                            decDepOnSales := decDepAmtOpening + decDepCurrPeriod;
                            decWDVForSales := decAcquisitionCost - decDepOnSales;
                            decSalesValue := recFADepBook."Proceeds on Disposal";
                            decGainLoss := recFADepBook."Gain/Loss";

                            recFALedger.SetRange("FA Posting Type", recFALedger."FA Posting Type"::"Proceeds on Disposal");
                            recFALedger.SetRange("Posting Date");
                            if recFALedger.FindFirst() then begin
                                cdInvoiceNo := recFALedger."Document No.";
                                dtInvoiceDate := recFALedger."Posting Date";
                            end;
                        end;
                    end;
                end;
                if decTotalLife <> 0 then begin
                    if dtPutToUse <> 0D then
                        decLifeUsed := Round((dtFromDate - dtPutToUse) / 365, 0.01);
                    decDepRate := Round(95 / decTotalLife, 0.01);
                end;
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
                }
            }
        }
    }

    var
        dtFromDate: Date;
        dtToDate: Date;
        recCompanyInfo: Record "Company Information";
        intSrNo: Integer;
        recFADepBook: Record "FA Depreciation Book";
        recFASetup: Record "FA Setup";
        dtPutToUse: Date;
        decTotalLife: Decimal;
        decLifeUsed: Decimal;
        decDepRate: Decimal;
        decAcquisitionCost: Decimal;
        decDepAmtOpening: Decimal;
        recFALedger: Record "FA Ledger Entry";
        decDepCurrPeriod: Decimal;
        decDepOnSales: Decimal;
        decSalesValue: Decimal;
        decWDVForSales: Decimal;
        decGainLoss: Decimal;
        cdInvoiceNo: Code[20];
        dtInvoiceDate: Date;
        recEmployee: Record Employee;
        txtEmployeeName: Text[100];
        recVendorLedger: Record "Vendor Ledger Entry";
        txtVendorName: Text[100];
        cdPurchInvNo: Code[20];
        recDefaultDimension: Record "Default Dimension";
        cdLOB: Code[20];
        cdFunction: Code[20];
        recGLSetup: Record "General Ledger Setup";
        decSalvage: Decimal;
}