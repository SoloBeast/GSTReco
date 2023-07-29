xmlport 50199 "Purchase Transactions"
{
    Caption = 'Purchase Transactions';
    Direction = Import;
    UseRequestPage = False;
    Format = VariableText;
    TextEncoding = WINDOWS;
    schema
    {
        textelement(Transactions)
        {
            MinOccurs = Zero;
            tableelement(PurchaseTransactions; PurchaseTransactions)
            {
                AutoSave = false;
                XmlName = 'PurchaseTransactions';

                textelement(VendorGSTNo)
                {
                    MinOccurs = Zero;
                }
                textelement(VendorCode)
                {
                    MinOccurs = Zero;
                }
                textelement(VendorName)
                {
                    MinOccurs = Zero;
                }
                textelement(DocumentType)
                {
                    MinOccurs = Zero;
                }
                textelement(InvoiceValue)
                {
                    MinOccurs = Zero;
                }
                textelement(PlaceOfSupply)
                {
                    MinOccurs = Zero;
                }
                textelement(RCM)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTRatePerc)
                {
                    MinOccurs = Zero;
                }
                textelement(CgstValue)
                {
                    MinOccurs = Zero;
                }
                textelement(SGSTValue)
                {
                    MinOccurs = Zero;
                }
                textelement(IGSTValue)
                {
                    MinOccurs = Zero;
                }
                textelement(ExternalDocumentNo)
                {
                    MinOccurs = Zero;
                }
                textelement(DocumentDate)
                {
                    MinOccurs = Zero;
                }
                textelement(TaxableValue)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                var
                    recPurchTrans: Record PurchaseTransactions;
                begin
                    intCounter += 1;

                    if intCounter > 1 then begin
                        intEntryNo += 1;
                        recPurchTrans.Init();

                        recPurchTrans."Entry No." := intEntryNo;
                        Evaluate(recPurchTrans."Vendor GST No.", VendorGSTNo);
                        Evaluate(recPurchTrans."Vendor Code", VendorCode);
                        Evaluate(recPurchTrans."Vendor Name", VendorName);
                        Evaluate(recPurchTrans."Document Type", DocumentType);
                        Evaluate(recPurchTrans."Invoice Value", InvoiceValue);
                        Evaluate(recPurchTrans."Place of Supply", PlaceOfSupply);
                        Evaluate(recPurchTrans.RCM, RCM);
                        Evaluate(recPurchTrans."GST Rate%", GSTRatePerc);
                        Evaluate(recPurchTrans."IGST Value", IGSTValue);
                        Evaluate(recPurchTrans."SGST/UGST Value", SGSTValue);
                        Evaluate(recPurchTrans."CGST Value", CgstValue);
                        Evaluate(recPurchTrans."External Document No", ExternalDocumentNo);
                        Evaluate(recPurchTrans."Document Date", DocumentDate);
                        Evaluate(recPurchTrans."Taxable Value", TaxableValue);

                        recPurchTrans.Insert();
                    end;
                end;


            }

        }
    }
    trigger OnPreXmlPort()
    var
        recPurch: Record PurchaseTransactions;
    begin
        intCounter := 0;

        recPurch.Reset();
        if recPurch.FindLast() then
            intEntryNo := recPurch."Entry No."
        else
            intEntryNo := 0;

    end;

    var
        intCounter: Integer;
        intEntryNo: Integer;

}