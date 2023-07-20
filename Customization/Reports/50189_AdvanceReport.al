report 50189 "Advance Report"
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
            column(UserID; UserId)
            { }
            column(TimeStamp; Format(CurrentDateTime))
            { }
            column(PartyName; recReportData.Description) { }
            column(PartyCode; recReportData."Account No.") { }
            column(DocumentDate; Format(recReportData."Document Date")) { }
            column(DocumentNo; recReportData."Document No.") { }
            column(MSMEStatus; Format(recReportData."Reversing Entry")) { }
            column(Amount; recReportData.Amount) { }
            column(TDSAmount; recReportData."Amount (LCY)") { }
            column(AgeInDays; recReportData."Debit Amount") { }
            column(ChequeNo; recReportData."Cheque No.") { }
            column(BankName; recReportData."Message to Recipient") { }

            trigger OnPreDataItem()
            begin
                if dtAsOnDate = 0D then
                    Error('Enter as on date to generate report.');

                recCompanyInfo.Get();
                txtHeading := 'Advance Report As On ' + Format(dtAsOnDate);

                recReportData.Reset();
                recReportData.DeleteAll();
                intLineNo := 0;

                recVLE.Reset();
                recVLE.SetRange("Posting Date", 0D, dtAsOnDate);
                recVLE.SetRange("Advance Payment", true);
                recVLE.SetFilter("Remaining Amount", '<>%1', 0);
                if cdVendorNo <> '' then
                    recVLE.SetRange("Vendor No.", cdVendorNo);
                if recVLE.FindFirst() then begin
                    repeat
                        recVendor.Get(recVLE."Vendor No.");
                        recVLE.CalcFields("Original Amt. (LCY)");

                        recBLE.Reset();
                        recBLE.SetRange("Document No.", recVLE."Document No.");
                        recBLE.SetRange("Posting Date", recVLE."Posting Date");
                        recBLE.SetRange("Transaction No.", recVLE."Transaction No.");
                        recBLE.FindFirst();
                        recBankAcc.Get(recBLE."Bank Account No.");

                        recReportData.Init();
                        intLineNo += 1;
                        recReportData."Line No." := intLineNo;
                        recReportData."Account No." := recVLE."Vendor No.";
                        recReportData.Description := recVLE."Vendor Name";
                        recReportData."Document Date" := recVLE."Posting Date";
                        recReportData."Document No." := recVLE."Document No.";
                        recReportData."Reversing Entry" := recVendor.MSME;
                        recReportData.Amount := recVLE."Original Amt. (LCY)";
                        recReportData."Amount (LCY)" := Abs(recVLE."Total TDS Including SHE CESS");
                        recReportData."Debit Amount" := dtAsOnDate - recVLE."Posting Date";
                        recReportData."Cheque No." := recBLE."Cheque No.";
                        recReportData."Message to Recipient" := recBankAcc.Name;
                        recReportData.Insert();
                    until recVLE.Next() = 0;
                end;

                recCLE.Reset();
                recCLE.SetRange("Posting Date", 0D, dtAsOnDate);
                recCLE.SetRange("Advance Payment", true);
                recCLE.SetFilter("Remaining Amount", '<>%1', 0);
                if cdCustomerNo <> '' then
                    recCLE.SetRange("Customer No.", cdCustomerNo);
                if recCLE.FindFirst() then begin
                    repeat
                        recCLE.CalcFields("Original Amt. (LCY)");

                        recBLE.Reset();
                        recBLE.SetRange("Document No.", recCLE."Document No.");
                        recBLE.SetRange("Posting Date", recCLE."Posting Date");
                        recBLE.SetRange("Transaction No.", recCLE."Transaction No.");
                        recBLE.FindFirst();
                        recBankAcc.Get(recBLE."Bal. Account No.");

                        recReportData.Init();
                        intLineNo += 1;
                        recReportData."Line No." := intLineNo;
                        recReportData."Account No." := recCLE."Customer No.";
                        recReportData.Description := recCLE."Customer Name";
                        recReportData."Document Date" := recCLE."Posting Date";
                        recReportData."Document No." := recCLE."Document No.";
                        recReportData.Amount := recCLE."Original Amt. (LCY)";
                        recReportData."Debit Amount" := dtAsOnDate - recCLE."Posting Date";
                        recReportData."Cheque No." := recBLE."Cheque No.";
                        recReportData."Message to Recipient" := recBankAcc.Name;
                        recReportData.Insert();
                    until recCLE.Next() = 0;
                end;

                recReportData.Reset();
                Integer.SetRange(Number, 1, recReportData.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                recReportData.Reset();
                recReportData.SetRange("Line No.", Integer.Number);
                recReportData.FindFirst();
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
                    field(dtAsOnDate; dtAsOnDate)
                    {
                        Caption = 'As On Date';
                        ApplicationArea = all;
                    }
                    field(cdCustomerNo; cdCustomerNo)
                    {
                        Caption = 'Customer No.';
                        TableRelation = Customer;
                        ApplicationArea = all;
                    }
                    field(cdVendorNo; cdVendorNo)
                    {
                        Caption = 'Vendor No.';
                        TableRelation = Vendor;
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
            LayoutFile = 'Customization\Reports\50189_AdvanceReport.rdl';
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        txtHeading: Text;
        recReportData: Record "Gen. Journal Line" temporary;
        intLineNo: Integer;
        dtAsOnDate: Date;
        recVLE: Record "Vendor Ledger Entry";
        recCLE: Record "Cust. Ledger Entry";
        recBLE: Record "Bank Account Ledger Entry";
        recBankAcc: Record "Bank Account";
        recVendor: Record Vendor;
        cdCustomerNo: Code[20];
        cdVendorNo: Code[20];
}