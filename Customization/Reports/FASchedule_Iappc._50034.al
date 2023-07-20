report 50034 "FA Schedule"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\FASchedule_Iappc._50034.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; 'Schedule for Fixed Asset As On ' + Format(dtToDate)) { }
            column(FromDate; Format(dtFromDate)) { }
            column(PYClosingDate; Format(dtFromDate - 1)) { }
            column(ToDate; Format(dtToDate)) { }
            column(HeadingRow; recFADetails.Quantity) { }
            column(SrNo; intSrNo) { }
            column(FANo; recFADetails."Account No.") { }
            column(ClassName; recFADetails."Payer Information") { }
            column(SubClassName; recFADetails."Transaction Information") { }
            column(OpeningBalance; recFADetails."Debit Amount") { }
            column(Additions; recFADetails."Credit Amount") { }
            column(Deductions; recFADetails.Amount) { }
            column(TotalValue; recFADetails."Debit Amount" + recFADetails."Credit Amount" - recFADetails.Amount) { }
            column(OpeningDep; recFADetails."Amount (LCY)") { }
            column(ForTheYearDep; recFADetails."VAT %") { }
            column(DeductionDep; recFADetails."VAT Base Discount %") { }
            column(closingDep; recFADetails."Amount (LCY)" + recFADetails."VAT %" - recFADetails."VAT Base Discount %") { }
            column(NetBlockCY; (recFADetails."Debit Amount" + recFADetails."Credit Amount" - recFADetails.Amount) - (recFADetails."Amount (LCY)" + recFADetails."VAT %" - recFADetails."VAT Base Discount %")) { }
            column(NetBlockPY; recFADetails."Debit Amount" - recFADetails."Amount (LCY)") { }

            trigger OnPreDataItem()
            begin
                if (Format(dtFromDate) = '') and (Format(dtToDate) = '') then
                    Error('The From or To Date must not be blank.');

                recCompanyInfo.Get();
                recFASetup.Get();
                recFASetup.TestField("Default Depr. Book");
                recFADetails.Reset();
                recFADetails.DeleteAll();
                intEntryNo := 0;
                cdOldClassCode := '';

                recFA.Reset();
                recFA.SetCurrentKey("FA Class Code");
                recFA.SetFilter("Opening Date Filter", '..%1', dtFromDate - 1);
                recFA.SetFilter("Date Filter", '%1..%2', dtFromDate, dtToDate);
                recFA.FindFirst();
                repeat
                    recFA.CalcFields("Opening Balance");

                    if not recClass.Get(recFA."FA Class Code") then
                        recClass.Init();
                    if not recSubClass.Get(recFA."FA Subclass Code") then
                        recSubClass.Init();

                    if cdOldClassCode <> recFA."FA Class Code" then begin
                        recFADetails.Init();
                        intEntryNo += 1;
                        recFADetails."Line No." := intEntryNo;
                        recFADetails.Description := recClass.Name;
                        recFADetails.Quantity := 1;
                        recFADetails.Insert();
                        intSrNo := 0;
                    end;

                    recFADetails.Reset();
                    recFADetails.SetRange("Gen. Prod. Posting Group", recFA."FA Class Code");
                    recFADetails.SetRange("Gen. Bus. Posting Group", recFA."FA Subclass Code");
                    if recFADetails.FindFirst() then begin
                        recFADetails."Debit Amount" += recFA."Opening Balance";

                        decTempValue := 0;
                        recFALedger.Reset();
                        recFALedger.SetRange("FA No.", recFA."No.");
                        recFALedger.SetRange("Posting Date", dtFromDate, dtToDate);
                        recFALedger.SetRange("Depreciation Book Code", recFASetup."Default Depr. Book");
                        recFALedger.SetRange("FA Posting Category", recFALedger."FA Posting Category"::" ");
                        recFALedger.SetRange("FA Posting Type", recFALedger."FA Posting Type"::"Acquisition Cost");
                        if recFALedger.FindFirst() then
                            repeat
                                decTempValue += recFALedger."Amount (LCY)";
                            until recFALedger.Next() = 0;
                        recFADetails."Credit Amount" += decTempValue;

                        decTempValue := 0;
                        recFALedger.SetRange("FA Posting Category", recFALedger."FA Posting Category"::Disposal);
                        recFALedger.SetRange("FA Posting Type", recFALedger."FA Posting Type"::"Acquisition Cost");
                        if recFALedger.FindFirst() then
                            repeat
                                decTempValue += -recFALedger."Amount (LCY)";
                            until recFALedger.Next() = 0;
                        recFADetails.Amount += decTempValue;

                        decTempValue := 0;
                        recFALedger.SetRange("Posting Date", 0D, dtFromDate - 1);
                        recFALedger.SetRange("Depreciation Book Code", recFASetup."Default Depr. Book");
                        recFALedger.SetRange("FA Posting Category", recFALedger."FA Posting Category"::" ");
                        recFALedger.SetRange("FA Posting Type", recFALedger."FA Posting Type"::Depreciation);
                        if recFALedger.FindFirst() then
                            repeat
                                decTempValue += -recFALedger."Amount (LCY)";
                            until recFALedger.Next() = 0;
                        recFADetails."Amount (LCY)" += decTempValue;

                        decTempValue := 0;
                        recFALedger.SetRange("Posting Date", dtFromDate, dtToDate);
                        if recFALedger.FindFirst() then
                            repeat
                                decTempValue += -recFALedger."Amount (LCY)";
                            until recFALedger.Next() = 0;
                        recFADetails."VAT %" += decTempValue;

                        decTempValue := 0;
                        recFALedger.SetRange("FA Posting Category", recFALedger."FA Posting Category"::Disposal);
                        recFALedger.SetRange("FA Posting Type", recFALedger."FA Posting Type"::Depreciation);
                        if recFALedger.FindFirst() then
                            repeat
                                decTempValue += recFALedger."Amount (LCY)";
                            until recFALedger.Next() = 0;
                        recFADetails."VAT Base Discount %" += decTempValue;

                        recFADetails.Modify();
                    end else begin
                        intSrNo += 1;

                        recFADetails.Init();
                        intEntryNo += 1;
                        recFADetails."Line No." := intEntryNo;
                        recFADetails.Quantity := 0;
                        recFADetails."FA Error Entry No." := intSrNo;
                        recFADetails."Gen. Prod. Posting Group" := recFA."FA Class Code";
                        recFADetails."Gen. Bus. Posting Group" := recFA."FA Subclass Code";
                        recFADetails.Description := recSubClass.Name;
                        recFADetails."Debit Amount" := recFA."Opening Balance";
                        recFADetails."Payer Information" := recClass.Name;
                        recFADetails."Transaction Information" := recSubClass.Name;

                        decTempValue := 0;
                        recFALedger.Reset();
                        recFALedger.SetRange("FA No.", recFA."No.");
                        recFALedger.SetRange("Posting Date", dtFromDate, dtToDate);
                        recFALedger.SetRange("Depreciation Book Code", recFASetup."Default Depr. Book");
                        recFALedger.SetRange("FA Posting Category", recFALedger."FA Posting Category"::" ");
                        recFALedger.SetRange("FA Posting Type", recFALedger."FA Posting Type"::"Acquisition Cost");
                        if recFALedger.FindFirst() then
                            repeat
                                decTempValue += recFALedger."Amount (LCY)";
                            until recFALedger.Next() = 0;
                        recFADetails."Credit Amount" := decTempValue;

                        decTempValue := 0;
                        recFALedger.SetRange("FA Posting Category", recFALedger."FA Posting Category"::Disposal);
                        recFALedger.SetRange("FA Posting Type", recFALedger."FA Posting Type"::"Acquisition Cost");
                        if recFALedger.FindFirst() then
                            repeat
                                decTempValue += -recFALedger."Amount (LCY)";
                            until recFALedger.Next() = 0;
                        recFADetails.Amount := decTempValue;

                        decTempValue := 0;
                        recFALedger.SetRange("Posting Date", 0D, dtFromDate - 1);
                        recFALedger.SetRange("Depreciation Book Code", recFASetup."Default Depr. Book");
                        recFALedger.SetRange("FA Posting Category", recFALedger."FA Posting Category"::" ");
                        recFALedger.SetRange("FA Posting Type", recFALedger."FA Posting Type"::Depreciation);
                        if recFALedger.FindFirst() then
                            repeat
                                decTempValue += -recFALedger."Amount (LCY)";
                            until recFALedger.Next() = 0;
                        recFADetails."Amount (LCY)" := decTempValue;

                        decTempValue := 0;
                        recFALedger.SetRange("Posting Date", dtFromDate, dtToDate);
                        if recFALedger.FindFirst() then
                            repeat
                                decTempValue += -recFALedger."Amount (LCY)";
                            until recFALedger.Next() = 0;
                        recFADetails."VAT %" := decTempValue;

                        decTempValue := 0;
                        recFALedger.SetRange("FA Posting Category", recFALedger."FA Posting Category"::Disposal);
                        recFALedger.SetRange("FA Posting Type", recFALedger."FA Posting Type"::Depreciation);
                        if recFALedger.FindFirst() then
                            repeat
                                decTempValue += recFALedger."Amount (LCY)";
                            until recFALedger.Next() = 0;
                        recFADetails."VAT Base Discount %" := decTempValue;

                        recFADetails.Insert();
                    end;

                    cdOldClassCode := recFA."FA Class Code";
                until recFA.Next() = 0;

                recFADetails.Reset();
                Integer.SetRange(Number, 1, intEntryNo);
            end;

            trigger OnAfterGetRecord()
            begin
                recFADetails.Reset();
                recFADetails.SetRange("Line No.", Integer.Number);
                recFADetails.FindFirst();
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
        recFASetup: Record "FA Setup";
        recFALedger: Record "FA Ledger Entry";
        recClass: Record "FA Class";
        recSubClass: Record "FA Subclass";
        recFADetails: Record "Gen. Journal Line" temporary;
        cdOldClassCode: Code[20];
        intEntryNo: Integer;
        recFA: Record "Fixed Asset";
        decTempValue: Decimal;
}