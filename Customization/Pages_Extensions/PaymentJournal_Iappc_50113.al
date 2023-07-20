pageextension 50113 "Payment Journal Ext." extends "Payment Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Advance Payment"; Rec."Advance Payment")
            {
                ApplicationArea = all;
                Visible = true;
            }
            field("Transaction Nature"; Rec."Transaction Nature")
            {
                ApplicationArea = all;
                Visible = true;
            }
            field("Type of Transaction"; Rec."Type of Transaction")
            {
                ApplicationArea = all;
                Visible = true;
            }
        }
        modify("GST on Advance Payment")
        {
            Visible = false;
        }
        modify("Amount Excl. GST")
        {
            Visible = false;
        }
        modify("GST TDS/GST TCS")
        {
            Visible = false;
        }
        modify("GST TCS State Code")
        {
            Visible = false;
        }
        modify("GST TDS/TCS Base Amount")
        {
            Visible = false;
        }
        modify("GST Group Code")
        {
            Visible = false;
        }
        modify("HSN/SAC Code")
        {
            Visible = false;
        }
        modify("GST Credit")
        {
            Visible = false;
        }
        modify("Location State Code")
        {
            Visible = false;
        }
        modify("Location GST Reg. No.")
        {
            Visible = false;
        }
        modify("GST Group Type")
        {
            Visible = false;
        }
        modify("Vendor GST Reg. No.")
        {
            Visible = false;
        }
        modify("GST Vendor Type")
        {
            Visible = false;
        }
        modify("Message to Recipient")
        {
            Visible = false;
        }
        modify("Payment Method Code")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("T.A.N. No.")
        {
            Visible = false;
        }
        modify("Nature of Remittance")
        {
            Visible = false;
        }
        modify("Act Applicable")
        {
            Visible = false;
        }
        modify("TCS Nature of Collection")
        {
            Visible = false;
        }
        modify("T.C.A.N. No.")
        {
            Visible = false;
        }
        modify(Amount)
        {
            Visible = false;
        }
        modify("Applied (Yes/No)")
        {
            Visible = false;
        }
        modify(GetAppliesToDocDueDate)
        {
            Visible = false;
        }
        modify(Correction)
        {
            Visible = false;
        }
        modify("Exported to Payment File")
        {
            Visible = false;
        }
        modify(TotalExportedAmount)
        {
            Visible = false;
        }
        modify("Has Payment Export Error")
        {
            Visible = false;
        }
        //Hemant
        modify("Cheque No.")
        {
            Visible = false;
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("Test Report")
        {
            action(TestReport)
            {
                Caption = 'Test Report';
                ApplicationArea = all;
                Image = TestReport;

                trigger OnAction()
                var
                    rptTestReport: Report "Voucher Test Report";
                begin
                    Clear(rptTestReport);
                    rptTestReport.SetDocumentDetails('BP', Rec."Document No.", Rec."Journal Template Name", Rec."Journal Batch Name");
                    rptTestReport.Run();
                end;
            }
            action(KotakFile)
            {
                Caption = 'Kotak File';
                Image = Export;
                ApplicationArea = all;
                Visible = false;

                trigger OnAction()
                var
                    cuCustomization: Codeunit "Iappc Customization";
                begin
                    Clear(cuCustomization);
                    cuCustomization.KotakBankFile(Rec);
                end;
            }
        }
        modify("Renumber Document Numbers")
        {
            Visible = false;
        }
        modify("Renumber Document Numbers_Promoted")
        {
            Visible = false;
        }
        modify(ApplyEntries)
        {
            Visible = false;
        }
        modify(ApplyEntries_Promoted)
        {
            Visible = false;
        }
        modify(Reconcile)
        {
            Visible = false;
        }
        modify(Reconcile_Promoted)
        {
            Visible = false;
        }
        modify("Bank Charges")
        {
            Visible = false;
        }
        modify("Bank Charges_Promoted")
        {
            Visible = false;
        }
        modify(SuggestEmployeePayments)
        {
            Visible = false;
        }
        modify(SuggestEmployeePayments_Promoted)
        {
            Visible = false;
        }
        modify(NetCustomerVendorBalances)
        {
            Visible = false;
        }
        modify(NetCustomerVendorBalances_Promoted)
        {
            Visible = false;
        }
        modify(CalculatePostingDate)
        {
            Visible = false;
        }
        modify(CalculatePostingDate_Promoted)
        {
            Visible = false;
        }
        modify(PrintCheck)
        {
            Visible = false;
        }
        modify(PrintCheck_Promoted)
        {
            Visible = false;
        }
        modify("Void &All Checks")
        {
            Visible = false;
        }
        modify("Void &All Checks_Promoted")
        {
            Visible = false;
        }
        modify(PreCheck)
        {
            Visible = false;
        }
        modify(Preview_Promoted)
        {
            Visible = false;
        }
        modify("Void Check")
        {
            Visible = false;
        }
        modify("Void Check_Promoted")
        {
            Visible = false;
        }
        modify(Void_Check)
        {
            Visible = false;
        }
        modify(Void_Check_Promoted)
        {
            Visible = false;
        }
        modify(ExportPaymentsToFile)
        {
            Visible = false;
        }
        modify(ExportPaymentsToFile_Promoted)
        {
            Visible = false;
        }
        modify(CreditTransferRegEntries)
        {
            Visible = false;
        }
        modify(CreditTransferRegEntries_Promoted)
        {
            Visible = false;
        }
        modify(CreditTransferRegisters)
        {
            Visible = false;
        }
        modify(CreditTransferRegisters_Promoted)
        {
            Visible = false;
        }
        modify(IncomingDoc)
        {
            Visible = false;
        }
        modify(IncomingDoc_Promoted)
        {
            Visible = false;
        }
        modify(ShowLinesWithErrors)
        {
            Visible = false;
        }
        modify(ShowLinesWithErrors_Promoted)
        {
            Visible = false;
        }
        modify(ShowAllLines)
        {
            Visible = false;
        }
        modify(ShowAllLines_Promoted)
        {
            Visible = false;
        }
        modify("F&unctions")
        {
            Visible = false;
        }
        modify(Workflow)
        {
            Visible = false;
        }
        modify("Tax payments")
        {
            Visible = false;
        }
        modify("Pay TDS")
        {
            Visible = false;
        }
        modify(PreviewCheck)
        {
            Visible = false;
        }
        modify(PreviewCheck_Promoted)
        {
            Visible = false;
        }
        modify(TransmitPayments)
        {
            Visible = false;
        }
        modify(TransmitPayments_Promoted)
        {
            Visible = false;
        }
        modify(VoidPayments)
        {
            Visible = false;
        }
        modify(VoidPayments_Promoted)
        {
            Visible = false;
        }
    }

    var
}