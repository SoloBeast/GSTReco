report 50196 "AR Collection Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Customer No.", "Posting Date", "Applies-to ID");
            CalcFields = "Original Amt. (LCY)";

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; txtHeading) { }
            column(SalesPerson; recSalesPerson.Name) { }
            column(PartyName; "Cust. Ledger Entry"."Customer Name") { }
            column(InvoiceNo; "Cust. Ledger Entry"."Document No.") { }
            column(InvoiceDate; Format("Cust. Ledger Entry"."Posting Date")) { }
            column(CurrencyCode; "Cust. Ledger Entry"."Currency Code") { }
            column(DueDate; Format("Cust. Ledger Entry"."Due Date")) { }
            column(OutstandingDays; intOutstandingDays) { }
            column(InvoiceAmount; "Cust. Ledger Entry"."Original Amt. (LCY)") { }

            dataitem(Integer; Integer)
            {
                DataItemTableView = sorting(Number);

                column(ReceivedOn; Format(recReceiptData."Posting Date")) { }
                column(BankName; recReceiptData.Description) { }
                column(BankAccNo; recReceiptData."Message to Recipient") { }
                column(UTRNo; recReceiptData."Cheque No.") { }
                column(ReceiptDate; Format(recReceiptData."Cheque Date")) { }
                column(ReceivedAmountINR; recReceiptData."Amount (LCY)") { }
                column(ReceivedAmountFCY; recReceiptData.Amount) { }

                trigger OnPreDataItem()
                begin
                    Integer.SetRange(Number, 1, intLineNo);
                end;

                trigger OnAfterGetRecord()
                begin
                    recReceiptData.Reset();
                    recReceiptData.SetRange("Line No.", Integer.Number);
                    recReceiptData.FindFirst();
                end;
            }

            trigger OnPreDataItem()
            begin
                if (dtFromDate = 0D) or (dtToDate = 0D) then
                    Error('The From or To Date must not be blank.');

                txtHeading := 'AR Collection Report for the period from ' + Format(dtFromDate) + ' to ' + Format(dtToDate);

                recCompanyInfo.Get();
                "Cust. Ledger Entry".SetRange(Positive, true);
                "Cust. Ledger Entry".SetRange("Posting Date", dtFromDate, dtToDate);
            end;

            trigger OnAfterGetRecord()
            begin
                recReceiptData.Reset();
                recReceiptData.DeleteAll();
                intLineNo := 0;

                if not recSalesPerson.Get("Cust. Ledger Entry"."Salesperson Code") then
                    recSalesPerson.Init();

                FindApplnEntriesDtldtLedgEntry();

                intOutstandingDays := 0;
                if "Cust. Ledger Entry"."Remaining Amt. (LCY)" <> 0 then
                    intOutstandingDays := dtToDate - "Cust. Ledger Entry"."Posting Date" + 1
                else begin
                    recReceiptData.Reset();
                    if recReceiptData.FindLast() then
                        intOutstandingDays := recReceiptData."Posting Date" - "Cust. Ledger Entry"."Posting Date" + 1;
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
                    }
                    field(dtToDate; dtToDate)
                    {
                        ApplicationArea = All;
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
            LayoutFile = 'Customization\Reports\50196_ARCollectionReport.rdl';
        }
    }

    local procedure FindApplnEntriesDtldtLedgEntry()
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        recCLE: Record "Cust. Ledger Entry";
        recBLE: Record "Bank Account Ledger Entry";
        recBankAccount: Record "Bank Account";
    begin
        DtldCustLedgEntry1.SetCurrentKey("Cust. Ledger Entry No.");
        DtldCustLedgEntry1.SetRange("Cust. Ledger Entry No.", "Cust. Ledger Entry"."Entry No.");
        DtldCustLedgEntry1.SetRange(Unapplied, false);
        if DtldCustLedgEntry1.Find('-') then
            repeat
                if DtldCustLedgEntry1."Cust. Ledger Entry No." = DtldCustLedgEntry1."Applied Cust. Ledger Entry No." then begin
                    DtldCustLedgEntry2.Init();
                    DtldCustLedgEntry2.SetCurrentKey("Applied Cust. Ledger Entry No.", "Entry Type");
                    DtldCustLedgEntry2.SetRange("Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    DtldCustLedgEntry2.SetRange("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                    DtldCustLedgEntry2.SetRange(Unapplied, false);
                    if DtldCustLedgEntry2.Find('-') then
                        repeat
                            if DtldCustLedgEntry2."Cust. Ledger Entry No." <> DtldCustLedgEntry2."Applied Cust. Ledger Entry No." then begin
                                recCLE.Reset();
                                recCLE.SetCurrentKey("Entry No.");
                                recCLE.SetRange("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");
                                if recCLE.Find('-') then begin
                                    recReceiptData.Init();
                                    intLineNo += 1;
                                    recReceiptData."Line No." := intLineNo;
                                    recReceiptData."Posting Date" := recCLE."Posting Date";
                                    if "Cust. Ledger Entry"."Currency Code" <> '' then
                                        recReceiptData.Amount := -DtldCustLedgEntry2.Amount;
                                    recReceiptData."Amount (LCY)" := -DtldCustLedgEntry2."Amount (LCY)";

                                    recBLE.Reset();
                                    recBLE.SetRange("Document No.", recCLE."Document No.");
                                    recBLE.SetRange("Posting Date", recCLE."Posting Date");
                                    if recBLE.FindFirst() then begin
                                        recBankAccount.Get(recBLE."Bank Account No.");

                                        recReceiptData."Cheque Date" := recBLE."Cheque Date";
                                        recReceiptData."Cheque No." := recBLE."Cheque No.";
                                        recReceiptData.Description := recBankAccount.Name;
                                        recReceiptData."Message to Recipient" := recBankAccount."Bank Account No.";
                                    end;
                                    recReceiptData.Insert();
                                end;
                            end;
                        until DtldCustLedgEntry2.Next() = 0;
                end else begin
                    recCLE.Reset();
                    recCLE.SetCurrentKey("Entry No.");
                    recCLE.SetRange("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    if recCLE.Find('-') then begin
                        recReceiptData.Init();
                        intLineNo += 1;
                        recReceiptData."Line No." := intLineNo;
                        recReceiptData."Posting Date" := recCLE."Posting Date";
                        if "Cust. Ledger Entry"."Currency Code" <> '' then
                            recReceiptData.Amount := -DtldCustLedgEntry1.Amount;
                        recReceiptData."Amount (LCY)" := -DtldCustLedgEntry1."Amount (LCY)";

                        recBLE.Reset();
                        recBLE.SetRange("Document No.", recCLE."Document No.");
                        recBLE.SetRange("Posting Date", recCLE."Posting Date");
                        if recBLE.FindFirst() then begin
                            recBankAccount.Get(recBLE."Bank Account No.");

                            recReceiptData."Cheque Date" := recBLE."Cheque Date";
                            recReceiptData."Cheque No." := recBLE."Cheque No.";
                            recReceiptData.Description := recBankAccount.Name;
                            recReceiptData."Message to Recipient" := recBankAccount."Bank Account No.";
                        end;
                        recReceiptData.Insert();
                    end;
                end;
            until DtldCustLedgEntry1.Next() = 0;
    end;

    var
        dtFromDate: Date;
        dtToDate: Date;
        recCompanyInfo: Record "Company Information";
        recReceiptData: Record "Gen. Journal Line" temporary;
        intLineNo: Integer;
        txtHeading: Text;
        recSalesPerson: Record "Salesperson/Purchaser";
        intOutstandingDays: Integer;
}