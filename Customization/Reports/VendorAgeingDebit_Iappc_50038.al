report 50038 "Vendor Ageing Debit Balance"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Vendor Ageing Debit Balance';
    RDLCLayout = 'Customization\Reports\VendorAgeingDebit_Iappc_50038.rdl';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Vendor Posting Group";
            CalcFields = "Net Change (LCY)";
            PrintOnlyIfDetail = true;

            column(CompanyName; recCompanyInfo.Name) { }
            column(ReportHeadging; txtReportHeading) { }
            column(No; "No.") { }
            column(Name; Name) { }
            column(BaanceOnDate; -"Net Change (LCY)") { }

            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code") ORDER(Ascending);
                DataItemLink = "Vendor No." = field("No.");
                CalcFields = "Remaining Amt. (LCY)";

                column(RemainingAmtLCY; "Remaining Amt. (LCY)") { }
                column(Slab1UpTo30Days; decSlabUpTo30Days) { }
                column(Slab2UpTo60Days; decSlabUpTo60Days) { }
                column(Slab3UpTo90Days; decSlabUpTo90Days) { }
                column(Slab4UpTo120Days; decSlabUpTo120Days) { }
                column(Slab5Above120Days; decAbove120Days) { }
                column(PurchaseName; recPurchaser.Name) { }

                trigger OnPreDataItem()
                begin
                    "Vendor Ledger Entry".SetRange("Posting Date", 0D, dtAsOnDate);
                    "Vendor Ledger Entry".SetFilter("Date Filter", '..%1', dtAsOnDate);
                    "Vendor Ledger Entry".SetFilter("Remaining Amt. (LCY)", '>%1', 0);
                end;

                trigger OnAfterGetRecord()
                begin
                    if "Vendor Ledger Entry"."Purchaser Code" <> '' then begin
                        if not recPurchaser.Get("Vendor Ledger Entry"."Purchaser Code") then
                            recPurchaser.Init();
                    end else begin
                        if not recPurchaser.Get(Vendor."Purchaser Code") then
                            recPurchaser.Init();
                    end;

                    decSlabUpTo30Days := 0;
                    decSlabUpTo60Days := 0;
                    decSlabUpTo90Days := 0;
                    decSlabUpTo120Days := 0;
                    decAbove120Days := 0;
                    if dtAsOnDate - "Vendor Ledger Entry"."Posting Date" > 120 then
                        decAbove120Days := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                    else
                        if dtAsOnDate - "Vendor Ledger Entry"."Posting Date" > 90 then
                            decSlabUpTo120Days := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                        else
                            if dtAsOnDate - "Vendor Ledger Entry"."Posting Date" > 60 then
                                decSlabUpTo90Days := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                            else
                                if dtAsOnDate - "Vendor Ledger Entry"."Posting Date" > 30 then
                                    decSlabUpTo60Days := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                                else
                                    decSlabUpTo30Days := "Vendor Ledger Entry"."Remaining Amt. (LCY)";
                end;
            }

            trigger OnPreDataItem()
            begin
                recCompanyInfo.Get();
                if dtAsOnDate = 0D then
                    Error('As On Date must not be blank.');
                txtReportHeading := 'Vendor Ageing Report Debit Balance As On ' + Format(dtAsOnDate);

                Vendor.SetFilter("Date Filter", '..%1', dtAsOnDate);
                //Vendor.SetFilter("Net Change (LCY)", '<%1', 0);
            end;

            trigger OnAfterGetRecord()
            begin
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
                    field(dtAsOnDate; dtAsOnDate)
                    {
                        Caption = 'As On Date';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        dtAsOnDate := Today;
    end;

    var
        dtAsOnDate: Date;
        recCompanyInfo: Record "Company Information";
        txtReportHeading: Text;
        recPurchaser: Record "Salesperson/Purchaser";
        decSlabUpTo30Days: Decimal;
        decSlabUpTo60Days: Decimal;
        decSlabUpTo90Days: Decimal;
        decSlabUpTo120Days: Decimal;
        decAbove120Days: Decimal;
}