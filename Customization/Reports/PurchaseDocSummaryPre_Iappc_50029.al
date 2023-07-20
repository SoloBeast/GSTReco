report 50029 "Purchase Document Summary"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Customization\Reports\PurchaseDocSummaryPre_Iappc_50029.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.");

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; txtHeading) { }
            column(DocumentNo; "Purchase Header"."No.") { }
            column(PostingNo; "Purchase Header"."Posting No.") { }
            column(PostingDate; Format("Purchase Header"."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(CustomerNo; "Purchase Header"."Buy-from Vendor No.") { }
            column(CustomerName; "Purchase Header"."Buy-from Vendor Name") { }
            column(CustomerGSTReg; "Purchase Header"."Vendor GST Reg. No.") { }
            column(CurrencyCode; "Purchase Header"."Currency Code") { }
            column(ExchangeRate; decCurrencyFactor) { }
            column(DueDate; Format("Purchase Header"."Due Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(GrossAmount; decGrossAmount) { }
            column(LineAmount; decLineAmount) { }
            column(IGSTAmount; decIGSTAmount) { }
            column(CGSTAmount; decCGSTAmount) { }
            column(SGSTAmount; decSGSTAmount) { }
            column(TotalAmount; decLineAmount + decIGSTAmount + decCGSTAmount + decSGSTAmount) { }
            column(LCYAmount; decLCYAmount) { }
            column(LocationCode; "Purchase Header"."Location Code") { }

            trigger OnPreDataItem()
            begin
                recCompanyInfo.Get();
                txtHeading := '';
            end;

            trigger OnAfterGetRecord()
            begin
                if txtHeading = '' then begin
                    if "Purchase Header"."Document Type" = "Purchase Header"."Document Type"::Invoice then
                        txtHeading := 'Purchase Invoice Summary Report'
                    else
                        txtHeading := 'Purchase Credit Memo Summary Report';
                end;

                if "Purchase Header"."Currency Code" <> '' then
                    decCurrencyFactor := 1 / "Purchase Header"."Currency Factor"
                else
                    decCurrencyFactor := 1;

                decGrossAmount := 0;
                decLineAmount := 0;
                decIGSTAmount := 0;
                decCGSTAmount := 0;
                decSGSTAmount := 0;

                recPurchaseLines.Reset();
                recPurchaseLines.SetRange("Document Type", "Purchase Header"."Document Type");
                recPurchaseLines.SetRange("Document No.", "Purchase Header"."No.");
                if recPurchaseLines.FindFirst() then
                    repeat
                        decLineAmount += recPurchaseLines."Line Amount";
                        decGrossAmount += Round(recPurchaseLines.Quantity * recPurchaseLines."Direct Unit Cost", 0.01);

                        recTaxTransactions.Reset();
                        recTaxTransactions.SetRange("Tax Record ID", recPurchaseLines.RecordId);
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
                    until recPurchaseLines.Next() = 0;

                decLCYAmount := Round((decLineAmount + decIGSTAmount + decCGSTAmount + decSGSTAmount) * decCurrencyFactor, 0.01);
            end;
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        recPurchaseLines: Record "Purchase Line";
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