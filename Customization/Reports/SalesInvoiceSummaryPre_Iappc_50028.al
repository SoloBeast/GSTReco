report 50028 "Sales Invoice Summary"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\SalesInvoiceSummaryPre_Iappc_50028.rdl';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.");

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; txtHeading) { }
            column(DocumentNo; "Sales Header"."No.") { }
            column(PostingNo; "Sales Header"."Posting No.") { }
            column(PostingDate; Format("Sales Header"."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(CustomerNo; "Sales Header"."Bill-to Customer No.") { }
            column(CustomerName; "Sales Header"."Bill-to Name") { }
            column(CustomerGSTReg; "Sales Header"."Customer GST Reg. No.") { }
            column(CurrencyCode; "Sales Header"."Currency Code") { }
            column(ExchangeRate; decCurrencyFactor) { }
            column(DueDate; Format("Sales Header"."Due Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(GrossAmount; decGrossAmount) { }
            column(LineAmount; decLineAmount) { }
            column(IGSTAmount; decIGSTAmount) { }
            column(CGSTAmount; decCGSTAmount) { }
            column(SGSTAmount; decSGSTAmount) { }
            column(TotalAmount; decLineAmount + decIGSTAmount + decCGSTAmount + decSGSTAmount) { }
            column(LCYAmount; decLCYAmount) { }
            column(LocationCode; "Sales Header"."Location Code") { }

            trigger OnPreDataItem()
            begin
                recCompanyInfo.Get();
                txtHeading := '';
            end;

            trigger OnAfterGetRecord()
            begin
                if txtHeading = '' then begin
                    if "Sales Header"."Document Type" = "Sales Header"."Document Type"::Invoice then
                        txtHeading := 'Sales Invoice Summary Report'
                    else
                        txtHeading := 'Sales Credit Memo Summary Report';
                end;

                if "Sales Header"."Currency Code" <> '' then
                    decCurrencyFactor := 1 / "Sales Header"."Currency Factor"
                else
                    decCurrencyFactor := 1;

                decGrossAmount := 0;
                decLineAmount := 0;
                decIGSTAmount := 0;
                decCGSTAmount := 0;
                decSGSTAmount := 0;

                recSalesLines.Reset();
                recSalesLines.SetRange("Document Type", "Sales Header"."Document Type");
                recSalesLines.SetRange("Document No.", "Sales Header"."No.");
                if recSalesLines.FindFirst() then
                    repeat
                        decLineAmount += recSalesLines."Line Amount";
                        decGrossAmount += Round(recSalesLines.Quantity * recSalesLines."Unit Price", 0.01);

                        recTaxTransactions.Reset();
                        recTaxTransactions.SetRange("Tax Record ID", recSalesLines.RecordId);
                        recTaxTransactions.SetRange("Tax Type", 'GST');
                        recTaxTransactions.SetRange("Value Type", recTaxTransactions."Value Type"::COMPONENT);
                        recTaxTransactions.SetRange("Value ID", 2);
                        if recTaxTransactions.FindFirst() then begin
                            decCGSTAmount += recTaxTransactions."Amount";
                        end;
                        recTaxTransactions.SetRange("Value ID", 3);
                        if recTaxTransactions.FindFirst() then begin
                            decIGSTAmount += recTaxTransactions."Amount";
                        end;
                        recTaxTransactions.SetRange("Value ID", 6);
                        if recTaxTransactions.FindFirst() then begin
                            decSGSTAmount += recTaxTransactions."Amount";
                        end;
                    until recSalesLines.Next() = 0;

                decLCYAmount := Round((decLineAmount + decIGSTAmount + decCGSTAmount + decSGSTAmount) * decCurrencyFactor, 0.01);
            end;
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        recSalesLines: Record "Sales Line";
        recTaxTransactions: Record "Tax Transaction Value";
        decGrossAmount: Decimal;
        decLineAmount: Decimal;
        decIGSTAmount: Decimal;
        decCGSTAmount: Decimal;
        decSGSTAmount: Decimal;
        txtHeading: Text;
        decCurrencyFactor: Decimal;
        decLCYAmount: Decimal;
}