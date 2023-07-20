report 50193 "MSME Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.") where(MSME = const(true));

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; txtHeading) { }

            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemTableView = sorting("Vendor No.", "Posting Date", "Currency Code");
                DataItemLink = "Vendor No." = field("No.");
                CalcFields = "Original Amt. (LCY)";

                column(VendorName; Vendor.Name) { }
                column(PostingDate; Format("Vendor Ledger Entry"."Posting Date")) { }
                column(DocumentDate; Format("Vendor Ledger Entry"."Document Date")) { }
                column(DueDate; Format("Vendor Ledger Entry"."Due Date")) { }
                column(PaymentTerm; txtPaymterTerm) { }
                column(DueDataBasis; txtDueDateBasis) { }
                column(InvoiceNo; "Vendor Ledger Entry"."External Document No.") { }
                column(MSMEStatus; Format(Vendor.MSME)) { }
                column(InvoiceAmount; -"Vendor Ledger Entry"."Original Amt. (LCY)") { }
                column(DueAmount; -"Vendor Ledger Entry"."Original Amt. (LCY)") { }

                dataitem(Integer; Integer)
                {
                    DataItemTableView = sorting(Number);

                    column(PaidAmount; recAppliedAmount."Amount (LCY)") { }
                    column(PaidOn; Format(recAppliedAmount."Posting Date")) { }
                    column(Days; intDays) { }

                    trigger OnPreDataItem()
                    begin
                        Integer.SetRange(Number, 1, intLineNo);
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        recAppliedAmount.Reset();
                        recAppliedAmount.SetRange("Line No.", Integer.Number);
                        recAppliedAmount.FindFirst();
                        intDays := recAppliedAmount."Posting Date" - "Vendor Ledger Entry"."Document Date" + 1;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    "Vendor Ledger Entry".SetRange("Posting Date", dtFromDate, dtToDate);
                    "Vendor Ledger Entry".SetRange(Positive, false);
                end;

                trigger OnAfterGetRecord()
                begin
                    recAppliedAmount.Reset();
                    recAppliedAmount.DeleteAll();
                    intLineNo := 0;

                    txtPaymterTerm := '';
                    txtDueDateBasis := '';
                    if recPurchInvHeader.Get("Vendor Ledger Entry"."Document No.") then begin
                        txtPaymterTerm := recPurchInvHeader."Payment Terms Code";
                        txtDueDateBasis := Format(recPurchInvHeader."Due Date Calc. Basis");
                    end;

                    FindApplnEntriesDtldtLedgEntry();
                end;
            }

            trigger OnPreDataItem()
            begin
                if (dtFromDate = 0D) or (dtToDate = 0D) then
                    Error('The From or To Date must not be blank.');

                recCompanyInfo.Get();
                txtHeading := 'MSME Report for the period from ' + Format(dtFromDate) + ' to ' + Format(dtToDate);
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
                        Caption = 'From Date';
                        ApplicationArea = All;
                    }
                    field(dtToDate; dtToDate)
                    {
                        Caption = 'To Date';
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
            LayoutFile = 'Customization\Reports\50193_Iappc_MSMEOutstanding.rdl';
        }
    }

    local procedure FindApplnEntriesDtldtLedgEntry()
    var
        DtldVendLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        recVLE: Record "Vendor Ledger Entry";
    begin
        DtldVendLedgEntry1.SetCurrentKey("Vendor Ledger Entry No.");
        DtldVendLedgEntry1.SetRange("Vendor Ledger Entry No.", "Vendor Ledger Entry"."Entry No.");
        DtldVendLedgEntry1.SetRange(Unapplied, false);
        if DtldVendLedgEntry1.Find('-') then
            repeat
                if DtldVendLedgEntry1."Vendor Ledger Entry No." = DtldVendLedgEntry1."Applied Vend. Ledger Entry No." then begin
                    DtldVendLedgEntry2.Init();
                    DtldVendLedgEntry2.SetCurrentKey("Applied Vend. Ledger Entry No.", "Entry Type");
                    DtldVendLedgEntry2.SetRange("Applied Vend. Ledger Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    DtldVendLedgEntry2.SetRange("Entry Type", DtldVendLedgEntry2."Entry Type"::Application);
                    DtldVendLedgEntry2.SetRange(Unapplied, false);
                    if DtldVendLedgEntry2.Find('-') then
                        repeat
                            if DtldVendLedgEntry2."Vendor Ledger Entry No." <> DtldVendLedgEntry2."Applied Vend. Ledger Entry No." then begin
                                recVLE.Reset();
                                recVLE.SetCurrentKey("Entry No.");
                                recVLE.SetRange("Entry No.", DtldVendLedgEntry2."Vendor Ledger Entry No.");
                                if recVLE.Find('-') then begin
                                    recAppliedAmount.Init();
                                    intLineNo += 1;
                                    recAppliedAmount."Line No." := intLineNo;
                                    recAppliedAmount."Posting Date" := recVLE."Posting Date";
                                    recAppliedAmount."Amount (LCY)" := DtldVendLedgEntry2."Amount (LCY)";
                                    recAppliedAmount.Insert();
                                end;
                            end;
                        until DtldVendLedgEntry2.Next() = 0;
                end else begin
                    recVLE.Reset();
                    recVLE.SetCurrentKey("Entry No.");
                    recVLE.SetRange("Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    if recVLE.Find('-') then begin
                        recAppliedAmount.Init();
                        intLineNo += 1;
                        recAppliedAmount."Line No." := intLineNo;
                        recAppliedAmount."Posting Date" := recVLE."Posting Date";
                        recAppliedAmount."Amount (LCY)" := DtldVendLedgEntry1."Amount (LCY)";
                        recAppliedAmount.Insert();
                    end;
                end;
            until DtldVendLedgEntry1.Next() = 0;
    end;

    var
        dtFromDate: Date;
        dtToDate: Date;
        recAppliedAmount: Record "Gen. Journal Line" temporary;
        intLineNo: Integer;
        intDays: Integer;
        recCompanyInfo: Record "Company Information";
        txtHeading: Text;
        recPurchInvHeader: Record "Purch. Inv. Header";
        txtDueDateBasis: Text[50];
        txtPaymterTerm: Text[30];
}