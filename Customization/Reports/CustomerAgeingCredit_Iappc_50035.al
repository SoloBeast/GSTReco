report 50035 "Customer Ageing Credit Balance"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Customer Ageing Credit Balance';
    RDLCLayout = 'Customization\Reports\CustomerAgeingCredit_Iappc_50035.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Customer Posting Group";
            PrintOnlyIfDetail = true;

            column(CompanyName; recCompanyInfo.Name) { }
            column(ReportHeadging; txtReportHeading) { }
            column(No; "No.") { }
            column(Name; Name) { }
            column(BaanceOnDate; -"Net Change (LCY)") { }

            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code") ORDER(Ascending);
                DataItemLink = "Customer No." = field("No.");
                CalcFields = "Remaining Amt. (LCY)";

                column(RemainingAmtLCY; "Remaining Amt. (LCY)") { }
                column(Slab1UpTo30Days; decSlabUpTo30Days) { }
                column(Slab2UpTo60Days; decSlabUpTo60Days) { }
                column(Slab3UpTo90Days; decSlabUpTo90Days) { }
                column(Slab4UpTo120Days; decSlabUpTo120Days) { }
                column(Slab5Above120Days; decAbove120Days) { }
                column(PurchaseName; recSalesPerson.Name) { }

                trigger OnPreDataItem()
                begin
                    "Cust. Ledger Entry".SetRange("Posting Date", 0D, dtAsOnDate);
                    "Cust. Ledger Entry".SetFilter("Date Filter", '..%1', dtAsOnDate);
                    "Cust. Ledger Entry".SetFilter("Remaining Amt. (LCY)", '<%1', 0);
                end;

                trigger OnAfterGetRecord()
                begin
                    if "Cust. Ledger Entry"."Salesperson Code" <> '' then begin
                        if not recSalesPerson.Get("Cust. Ledger Entry"."Salesperson Code") then
                            recSalesPerson.Init();
                    end else begin
                        if not recSalesPerson.Get(Customer."Salesperson Code") then
                            recSalesPerson.Init();
                    end;

                    decSlabUpTo30Days := 0;
                    decSlabUpTo60Days := 0;
                    decSlabUpTo90Days := 0;
                    decSlabUpTo120Days := 0;
                    decAbove120Days := 0;
                    if dtAsOnDate - "Cust. Ledger Entry"."Posting Date" > 120 then
                        decAbove120Days := "Cust. Ledger Entry"."Remaining Amt. (LCY)"
                    else
                        if dtAsOnDate - "Cust. Ledger Entry"."Posting Date" > 90 then
                            decSlabUpTo120Days := "Cust. Ledger Entry"."Remaining Amt. (LCY)"
                        else
                            if dtAsOnDate - "Cust. Ledger Entry"."Posting Date" > 60 then
                                decSlabUpTo90Days := "Cust. Ledger Entry"."Remaining Amt. (LCY)"
                            else
                                if dtAsOnDate - "Cust. Ledger Entry"."Posting Date" > 30 then
                                    decSlabUpTo60Days := "Cust. Ledger Entry"."Remaining Amt. (LCY)"
                                else
                                    decSlabUpTo30Days := "Cust. Ledger Entry"."Remaining Amt. (LCY)";
                end;
            }

            trigger OnPreDataItem()
            begin
                recCompanyInfo.Get();
                if dtAsOnDate = 0D then
                    Error('As On Date must not be blank.');
                txtReportHeading := 'Customer Ageing Report Credit Balance As On ' + Format(dtAsOnDate);

                Customer.SetFilter("Date Filter", '..%1', dtAsOnDate);
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
        recSalesPerson: Record "Salesperson/Purchaser";
        decSlabUpTo30Days: Decimal;
        decSlabUpTo60Days: Decimal;
        decSlabUpTo90Days: Decimal;
        decSlabUpTo120Days: Decimal;
        decAbove120Days: Decimal;
}