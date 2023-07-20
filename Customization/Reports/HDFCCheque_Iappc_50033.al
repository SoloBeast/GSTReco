report 50092 "HDFC Cheque"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'HDFC Cheque';
    RDLCLayout = 'Customization\Reports\HDFCCheque_Iappc_50033.rdl';

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            column(txtPartyName; txtPartyName) { }
            column(txtChequeDate; txtDateToPrint) { }
            column(txtAmountInWords; txtAmountInWords[1] + ' ' + txtAmountInWords[2]) { }
            column(decAmount; decAmount) { }
            column(txtAccountPayee; txtAccountPayee) { }

            trigger OnPreDataItem()
            begin
                if blnAccountPayee then
                    txtAccountPayee := 'Account Payee Only'
                else
                    txtAccountPayee := '';
            end;

            trigger OnAfterGetRecord()
            begin
                recTaxTransactions.Reset();
                recTaxTransactions.SetRange("Tax Record ID", "Gen. Journal Line".RecordId);

                IF ("Account Type" = "Account Type"::"Bank Account") AND ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") AND
                                                                                  (Amount > 0) THEN BEGIN
                    decAmount := "Gen. Journal Line"."Debit Amount";
                END ELSE begin
                    IF ("Account Type" = "Account Type"::"Bank Account") AND ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") AND
                                                                             (Amount < 0) THEN BEGIN
                        decAmount := "Gen. Journal Line"."Credit Amount";
                    END ELSE begin
                        IF "Bal. Account No." <> '' THEN BEGIN
                            decAmount := "Gen. Journal Line"."Debit Amount" - decTDSAmount;
                        END ELSE BEGIN
                            decAmount := "Gen. Journal Line"."Credit Amount";
                        END;
                    end;
                end;

                cuProcess.InitTextVariable();
                Clear(txtAmountInWords);
                cuProcess.FormatNoText(txtAmountInWords, decAmount, "Gen. Journal Line"."Currency Code");

                txtPartyName := "Gen. Journal Line".Description;
                txtChequeDate := FORMAT("Gen. Journal Line"."Cheque Date");
                txtDateToPrint := '';
                FOR x := 1 TO STRLEN(txtChequeDate) DO BEGIN
                    if x in [3, 6] then begin
                        txtDateToPrint := txtDateToPrint;
                    end else begin
                        IF x = 7 THEN
                            txtDateToPrint := txtDateToPrint + '2     0     ';
                        txtDateToPrint := txtDateToPrint + COPYSTR(txtChequeDate, x, 1) + '     ';
                    end;
                END;
            end;

            trigger OnPostDataItem()
            begin
                /*
                recJournalLine.RESET;
                recJournalLine.SETRANGE("Journal Template Name", "Gen. Journal Line"."Journal Template Name");
                recJournalLine.SETRANGE("Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
                recJournalLine.SETRANGE("Line No.", "Gen. Journal Line"."Line No.");
                recJournalLine.FIND('-');
                recJournalLine."Check Printed" := TRUE;
                recJournalLine.MODIFY;

                recCheckLedgEntry.INIT;

                IF ("Account Type" = "Account Type"::"Bank Account") AND ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") AND
                                                                                  (Amount > 0) THEN BEGIN
                    recCheckLedgEntry."Bank Account No." := "Gen. Journal Line"."Bal. Account No.";
                END ELSE
                    IF ("Account Type" = "Account Type"::"Bank Account") AND ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") AND
                                                                             (Amount < 0) THEN BEGIN
                        recCheckLedgEntry."Bank Account No." := "Gen. Journal Line"."Account No.";
                    END ELSE
                        IF "Bal. Account No." <> '' THEN BEGIN
                            recCheckLedgEntry."Bank Account No." := "Gen. Journal Line"."Bal. Account No.";
                        END ELSE
                            IF "Bal. Account No." <> '' THEN BEGIN
                                recCheckLedgEntry."Bank Account No." := "Gen. Journal Line"."Bal. Account No.";
                            END ELSE BEGIN
                                recCheckLedgEntry."Bank Account No." := "Gen. Journal Line"."Account No.";
                            END;

                recCheckLedgEntry."Posting Date" := "Posting Date";
                recCheckLedgEntry."Document No." := "Gen. Journal Line"."Cheque No.";
                recCheckLedgEntry.Description := recJournalLine.Description;
                recCheckLedgEntry."Bank Payment Type" := "Bank Payment Type"::"Computer Check";
                recCheckLedgEntry."Entry Status" := recCheckLedgEntry."Entry Status"::Printed;
                recCheckLedgEntry."Check Date" := "Gen. Journal Line"."Cheque Date";
                recCheckLedgEntry."Check No." := "Gen. Journal Line"."Cheque No.";
                cuCheckManagement.InsertCheck(recCheckLedgEntry, rdRecordID);

                IF ("Account Type" = "Account Type"::"Bank Account") AND ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") AND
                                                                                  (Amount > 0) THEN BEGIN
                    recBankAccount.GET("Gen. Journal Line"."Bal. Account No.");
                END ELSE
                    IF ("Account Type" = "Account Type"::"Bank Account") AND ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") AND
                                                                             (Amount < 0) THEN BEGIN
                        recBankAccount.GET("Gen. Journal Line"."Account No.");
                    END ELSE
                        IF "Bal. Account No." <> '' THEN BEGIN
                            recBankAccount.GET("Gen. Journal Line"."Bal. Account No.");
                        END ELSE BEGIN
                            recBankAccount.GET("Gen. Journal Line"."Account No.");
                        END;

                recBankAccount."Last Check No." := "Gen. Journal Line"."Cheque No.";
                recBankAccount.MODIFY;
                */
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(FilterOptions)
                {
                    Caption = 'Options';
                    field(blnAccountPayee; blnAccountPayee)
                    {
                        ApplicationArea = All;
                        Caption = 'Account Payee';
                    }
                }
            }
        }
    }

    var
        decAmount: Decimal;
        txtPartyName: Text;
        txtChequeDate: Text;
        txtAmountInWords: array[2] of Text[80];
        txtAccountPayee: Text;
        blnAccountPayee: Boolean;
        x: Integer;
        recJournalLine: Record "Gen. Journal Line";
        recCheckLedgEntry: Record "Check Ledger Entry";
        cuCheckManagement: Codeunit CheckManagement;
        rdRecordID: RecordId;
        recBankAccount: Record "Bank Account";
        txtDateToPrint: Text;
        cuProcess: Codeunit "Process Flow";
        recTaxTransactions: Record "Tax Transaction Value";
        decTDSAmount: Decimal;
}