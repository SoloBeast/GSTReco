codeunit 50000 "Iappc Customization"
{

    Permissions = tabledata "TDS Entry" = rmid;

    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"TDS Entry", 'OnAfterInsertEvent', '', true, true)]
    local procedure UpdateTDSEntryOnInsert(var Rec: Record "TDS Entry")
    var
        recVendorLedger: Record "Vendor Ledger Entry";
    begin
        recVendorLedger.Reset();
        recVendorLedger.SetRange("Document No.", Rec."Document No.");
        if recVendorLedger.FindFirst() then begin
            Rec."External Doc. No." := recVendorLedger."External Document No.";
            Rec."Document Date" := recVendorLedger."Document Date";
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Inv. Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure UpdateFADepStartDateFromPurchPosting(var Rec: Record "Purch. Inv. Line")
    var
        recFA: Record "Fixed Asset";
        recFADepBook: Record "FA Depreciation Book";
    begin
        if (Rec.Type = Rec.Type::"Fixed Asset") and (Rec.Quantity <> 0) then begin
            recFA.Get(Rec."No.");

            recFADepBook.Reset();
            recFADepBook.SetRange("FA No.", recFA."No.");
            recFADepBook.FindFirst();
            recFADepBook."Depreciation Starting Date" := Rec."Posting Date";
            recFADepBook.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"TDS Entry", 'OnAfterInsertEvent', '', true, true)]
    local procedure UpdateTDSEntryCustomFields(var Rec: Record "TDS Entry")
    var
        recGLEntry: Record "G/L Entry";
        recPostedNarration: Record "Posted Narration";
        recPurchComment: Record "Purch. Comment Line";
        txtNarration: Text[250];
    begin
        if Rec."Document No." <> '***' then begin
            txtNarration := '';
            recPurchComment.RESET;
            recPurchComment.SETRANGE("No.", Rec."Document No.");
            IF recPurchComment.FIND('-') THEN
                REPEAT
                    if txtNarration = '' then
                        txtNarration := recPurchComment.Comment
                    else begin
                        if StrLen(txtNarration + recPurchComment.Comment) < 250 then
                            txtNarration := txtNarration + ' ' + recPurchComment.Comment;
                    end;
                UNTIL recPurchComment.NEXT = 0;

            recPostedNarration.Reset();
            recPostedNarration.SetRange("Document No.", Rec."Document No.");
            recPostedNarration.SetRange("Transaction No.", Rec."Transaction No.");
            if recPostedNarration.FindFirst() then
                repeat
                    if txtNarration = '' then
                        txtNarration := recPostedNarration.Narration
                    else begin
                        if StrLen(txtNarration + recPostedNarration.Narration) < 250 then
                            txtNarration := txtNarration + ' ' + recPostedNarration.Narration;
                    end;
                until recPostedNarration.Next() = 0;

            recGLEntry.Reset();
            recGLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
            recGLEntry.SetRange("Document No.", Rec."Document No.");
            recGLEntry.SetRange("Posting Date", Rec."Posting Date");
            recGLEntry.SetRange("Transaction No.", Rec."Transaction No.");
            if recGLEntry.FindLast() then
                Rec."Expense G/L Account" := recGLEntry."G/L Account No.";

            Rec.Narration := txtNarration;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnBeforeTransferLineToPurchaseDoc', '', true, true)]
    local procedure UpdatePurchInvHeaderOnGetReceiptLine(var PurchaseHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        if PurchaseHeader."Purch. Order No." = '' then begin
            PurchaseHeader."Document Basis" := PurchaseHeader."Document Basis"::"PO Base";
            PurchaseHeader."Purch. Order No." := PurchRcptHeader."Order No.";
            PurchaseHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCopyBuyFromVendorFieldsFromVendor', '', true, true)]
    local procedure UpdatePurchHeaderFromVendor(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor)
    begin
        PurchaseHeader."206 AB" := Vendor."206 AB";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeRunCheck', '', true, true)]
    local procedure CheckVoucherMandatoryValue(var GenJournalLine: Record "Gen. Journal Line")
    var
        recJournalTemplate: Record "Gen. Journal Template";
    begin
        if (recJournalTemplate.Get(GenJournalLine."Journal Template Name")) and (GenJournalLine."System-Created Entry" = false) then begin
            GenJournalLine.TestField("Transaction Nature");

            if (GenJournalLine."Created By" = UserId) then
                Error('Voucher can not be posted by the user who created the same.');

            if GenJournalLine."Document Type" <> GenJournalLine."Document Type"::" " then begin
                if GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo" then
                    GenJournalLine.TestField("Transaction Nature", GenJournalLine."Transaction Nature"::"Credit Memo");
                if GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice then
                    GenJournalLine.TestField("Transaction Nature", GenJournalLine."Transaction Nature"::Invoice);
                if GenJournalLine."Document Type" = GenJournalLine."Document Type"::Payment then
                    GenJournalLine.TestField("Transaction Nature", GenJournalLine."Transaction Nature"::Payment);
                if GenJournalLine."Document Type" = GenJournalLine."Document Type"::Refund then
                    GenJournalLine.TestField("Transaction Nature", GenJournalLine."Transaction Nature"::Refund);
            end;

            if GenJournalLine."Advance Payment" then begin
                if (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor) and (GenJournalLine.Amount < 0) then
                    Error('Advance payment can only be ticked with debit amount.');
                if (GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::Vendor) and (GenJournalLine.Amount > 0) then
                    Error('Advance payment can only be ticked with credit amount.');

                if (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer) and (GenJournalLine.Amount > 0) then
                    Error('Advance payment can only be ticked with credit amount.');
                if (GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::Customer) and (GenJournalLine.Amount < 0) then
                    Error('Advance payment can only be ticked with debit amount.');
            end;

            if (recJournalTemplate."Source Code" in ['JOURNALV']) and ((GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor) or (GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::Vendor)) then begin
                GenJournalLine.TestField("Type of Transaction");
                if GenJournalLine."Type of Transaction" = GenJournalLine."Type of Transaction"::"Purch. Order" then
                    GenJournalLine.TestField("Purch. Order No.");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostBankAccOnBeforeBankAccLedgEntryInsert', '', true, true)]
    local procedure UpdateBankLedgerEntryWithAddInfo(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        BankAccountLedgerEntry."Transaction Nature" := GenJournalLine."Transaction Nature";
        BankAccountLedgerEntry."UTR No." := GenJournalLine."UTR No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', true, true)]
    local procedure UpdateCustLedgerEntryWithAddInfo(var CustLedgerEntry: Record "Cust. Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry."Transaction Nature" := GenJournalLine."Transaction Nature";
        CustLedgerEntry."Advance Payment" := GenJournalLine."Advance Payment";
        if GenJournalLine."Currency Code" = '' then
            CustLedgerEntry."Currency Excharge Rate" := 1
        else
            CustLedgerEntry."Currency Excharge Rate" := 1 / GenJournalLine."Currency Factor";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeVendLedgEntryInsert', '', true, true)]
    local procedure UpdateVendorLedgerEntryWithAddInfo(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."Transaction Nature" := GenJournalLine."Transaction Nature";
        VendorLedgerEntry."Advance Payment" := GenJournalLine."Advance Payment";
        VendorLedgerEntry."Type of Transaction" := GenJournalLine."Type of Transaction";
        VendorLedgerEntry."Purch. Order No." := GenJournalLine."Purch. Order No.";
        if GenJournalLine."Currency Code" = '' then
            VendorLedgerEntry."Currency Excharge Rate" := 1
        else
            VendorLedgerEntry."Currency Excharge Rate" := 1 / GenJournalLine."Currency Factor";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostEmployeeOnBeforeEmployeeLedgerEntryInsert', '', true, true)]
    local procedure UpdateEmployeeLedgerEntryWithAddInfo(var EmployeeLedgerEntry: Record "Employee Ledger Entry"; var GenJnlLine: Record "Gen. Journal Line")
    begin
        EmployeeLedgerEntry."Transaction Nature" := GenJnlLine."Transaction Nature";
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', true, true)]
    local procedure UpdateGLEntryWithAddInfo(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."Transaction Nature" := GenJournalLine."Transaction Nature";
        GLEntry."Currency Code" := GenJournalLine."Currency Code";
        if GenJournalLine."Currency Code" = '' then
            GLEntry."Currency Excharge Rate" := 1
        else
            GLEntry."Currency Excharge Rate" := 1 / GenJournalLine."Currency Factor";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', true, true)]
    local procedure ValidationBeforeSalesDocPosting(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        recSalesLine: Record "Sales Line";
    begin
        SalesHeader.TestField("Internal Document Type");

        // if (SalesHeader."Created By" = UserId) and (PreviewMode = false) then
        //     Error('The document can not be posted by the user who created the same.');

        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            if (SalesHeader.Ship = false) or (SalesHeader.Invoice = false) then
                Error('You must post Ship and Invoice together.');
        end;
        // if SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] then begin
        //     SalesHeader.TestField("Company Bank Account Code");
        // end;
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::"Credit Memo", SalesHeader."Document Type"::"Return Order"] then begin
            SalesHeader.TestField("Applies-to Doc. Type");
            SalesHeader.TestField("Applies-to Doc. No.");
        end;

        recSalesLine.Reset();
        recSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        recSalesLine.SetRange("Document No.", SalesHeader."No.");
        if recSalesLine.FindFirst() then
            repeat
                if (recSalesLine."HSN/SAC Code" <> '') and (StrLen(recSalesLine."HSN/SAC Code") <> 6) then
                    Error('The length of the HSN code must be 6 characters.');
            until recSalesLine.Next() = 0;
    end;

    procedure KotakBankFile(var GenJnlLine: Record "Gen. Journal Line")
    var
        recGenJnlLine: Record "Gen. Journal Line";
        blnFileGenerated: Boolean;
        txtFileName: Text;
        txtTextToWrite: Text;
        txtBuilder: TextBuilder;
        recVendor: Record Vendor;
        recBankAccount: Record "Bank Account";
        //recVendorBank: Record "Vendor Bank Account";
        iosOutStream: OutStream;
        iosInStream: InStream;
        cuTempBlob: Codeunit "Temp Blob";
        recVLE: Record "Vendor Ledger Entry";
    begin
        if not Confirm('Do you want to export the Kotak Bank file?', false) then
            exit;

        blnFileGenerated := false;
        Clear(txtTextToWrite);
        Clear(txtBuilder);

        recGenJnlLine.Reset();
        recGenJnlLine.CopyFilters(GenJnlLine);
        if recGenJnlLine.FindSet() then begin
            repeat
                if blnFileGenerated = false then begin
                    txtTextToWrite := 'Client_Code,Product_Code,Payment_Type,Payment_Ref_No.,Payment_Date,Dr_Ac_No,Amount,Beneficiary_Code,Beneficiary_Name,IFSC Code,Beneficiary_Acc_No,Beneficiary_Email,Beneficiary_Mobile,Debit_Narration,Credit_Narration,Enrichment_1,Enrichment_1';
                    txtBuilder.AppendLine(txtTextToWrite);

                    blnFileGenerated := true;
                end;
                txtTextToWrite := 'LATRAVE';
                txtTextToWrite := txtTextToWrite + ',VENPAYPLUS,,';
                txtTextToWrite := txtTextToWrite + ',' + Format(recGenJnlLine."Posting Date", 0, '<Day,2>-<Month,2>-<Year>');
                recBankAccount.Get(recGenJnlLine."Bal. Account No.");
                txtTextToWrite := txtTextToWrite + ',' + recBankAccount."Bank Account No.";
                txtTextToWrite := txtTextToWrite + ',' + DelChr(Format(recGenJnlLine.Amount), '=', ',');
                // recVendorBank.Reset();
                // recVendorBank.SetRange("Vendor No.", recGenJnlLine."Account No.");
                // recVendorBank.FindFirst();
                recVendor.Get(recGenJnlLine."Account No.");
                txtTextToWrite := txtTextToWrite + ',' + recVendor."Beneficiary Code";//
                if recVendor."Beneficiary Code" <> '' then//
                    txtTextToWrite := txtTextToWrite + ',' + ','
                else begin
                    txtTextToWrite := txtTextToWrite + ',' + recVendor.Name;
                    txtTextToWrite := txtTextToWrite + ',' + recVendor."Bank IFSC Code";//IFSC
                    txtTextToWrite := txtTextToWrite + ',' + recVendor."Bank Account No.";
                end;
                txtTextToWrite := txtTextToWrite + ',' + recVendor."E-Mail";
                txtTextToWrite := txtTextToWrite + ',' + recVendor."Mobile Phone No.";
                txtTextToWrite := txtTextToWrite + ',' + '';//Debit Narration;
                if recGenJnlLine."Applies-to Doc. No." <> '' then begin
                    recVLE.Reset();
                    recVLE.SetRange("Document No.", recGenJnlLine."Applies-to Doc. No.");
                    recVLE.FindFirst();
                    txtTextToWrite := txtTextToWrite + ',' + recVLE."External Document No.";
                end else
                    txtTextToWrite := txtTextToWrite + ',,';

                txtTextToWrite := txtTextToWrite + ',' + ',,';
                txtBuilder.AppendLine(txtTextToWrite);
            until recGenJnlLine.Next() = 0;
        end;
        if blnFileGenerated then begin
            txtTextToWrite := Format(Today, 0, '<Day,2><Month,2><Year,2>');
            txtFileName := 'KOTAK_' + txtTextToWrite + '.csv';
            cuTempBlob.CreateOutStream(iosOutStream);
            iosOutStream.WriteText(txtBuilder.ToText());
            cuTempBlob.CreateInStream(iosInStream);
            DownloadFromStream(iosInStream, '', '', '', txtFileName);

            Message('The Kotak file has been exported.');
        end else
            Error('Nothing to export.');
    end;

    procedure KotakBankPaymentFile(var BankLedgerEntry2: Record "Bank Account Ledger Entry")
    var
        recBankLedger: Record "Bank Account Ledger Entry";
        txtTextToWrite: Text;
        txtBuilder: TextBuilder;
        recVendorLedger: Record "Vendor Ledger Entry";
        //recVendorBankAccount: Record "Vendor Bank Account";
        recVendor: Record Vendor;
        recBankAccount: Record "Bank Account";
        txtFileName: Text;
        iosOutStream: OutStream;
        iosInStream: InStream;
        cuTempBlob: Codeunit "Temp Blob";
    begin
        if not Confirm('Do you want to export the Kotak Bank Payment File?', false) then
            exit;

        recBankLedger.Reset();
        recBankLedger.CopyFilters(BankLedgerEntry2);
        recBankLedger.SetFilter("Amount (LCY)", '<%1', 0);
        recBankLedger.SetRange(Reversed, false);
        if recBankLedger.FindSet() then begin
            recBankAccount.Get(recBankLedger."Bank Account No.");

            Clear(txtTextToWrite);
            Clear(txtBuilder);

            txtTextToWrite := 'Client_Code,Product_Code,Payment_Type,Payment_Ref_No.,Payment_Date,Dr_Ac_No,Amount,Beneficiary_Code,Beneficiary_Name,IFSC Code,Beneficiary_Acc_No,Beneficiary_Email,Beneficiary_Mobile,Debit_Narration,Credit_Narration,Enrichment_1,Enrichment_1';
            txtBuilder.AppendLine(txtTextToWrite);

            repeat
                txtTextToWrite := 'LATRAVE';
                txtTextToWrite := txtTextToWrite + ',VENPAYPLUS,,';
                txtTextToWrite := txtTextToWrite + ',' + Format(recBankLedger."Posting Date", 0, '<Day,2>-<Month,2>-<Year>');
                txtTextToWrite := txtTextToWrite + ',' + recBankAccount."Bank Account No.";
                txtTextToWrite := txtTextToWrite + ',' + DelChr(Format(Abs(recBankLedger."Amount (LCY)")), '=', ',');

                recVendorLedger.Reset();
                recVendorLedger.SetRange("Document No.", recBankLedger."Document No.");
                recVendorLedger.SetRange("Posting Date", recBankLedger."Posting Date");
                recVendorLedger.SetRange("Transaction No.", recBankLedger."Transaction No.");
                recVendorLedger.FindFirst();

                recVendor.Get(recVendorLedger."Vendor No.");
                recVendor.TestField("Bank Account No.");
                //recVendorBankAccount.Reset();
                //recVendorBankAccount.SetRange("Vendor No.", recVendorLedger."Vendor No.");
                //recVendorBankAccount.FindFirst();

                txtTextToWrite := txtTextToWrite + ',' + recVendor."Beneficiary Code";
                if recVendor."Beneficiary Code" <> '' then//
                    txtTextToWrite := txtTextToWrite + ',' + ','
                else begin
                    txtTextToWrite := txtTextToWrite + ',' + recVendor.Name;
                    txtTextToWrite := txtTextToWrite + ',' + recVendor."Bank IFSC Code";
                    txtTextToWrite := txtTextToWrite + ',' + recVendor."Bank Account No.";
                end;
                txtTextToWrite := txtTextToWrite + ',' + recVendor."E-Mail";
                txtTextToWrite := txtTextToWrite + ',' + recVendor."Mobile Phone No.";
                txtTextToWrite := txtTextToWrite + ',' + '';
                txtTextToWrite := txtTextToWrite + ',,';

                txtTextToWrite := txtTextToWrite + ',' + ',,';
                txtBuilder.AppendLine(txtTextToWrite);
            until recBankLedger.Next() = 0;

            txtTextToWrite := Format(Today, 0, '<Day,2><Month,2><Year,2>');
            txtFileName := 'KOTAK_' + txtTextToWrite + '.csv';
            cuTempBlob.CreateOutStream(iosOutStream);
            iosOutStream.WriteText(txtBuilder.ToText());
            cuTempBlob.CreateInStream(iosInStream);
            DownloadFromStream(iosInStream, '', '', '', txtFileName);

            Message('The Kotak file has been exported.');
        end else
            Error('Nothing to Export.');
    end;

    procedure AxisBankFile(var BankLedgerEntry2: Record "Bank Account Ledger Entry")
    var
        recBankLedger: Record "Bank Account Ledger Entry";
        tempExcelBuffer: Record "Excel Buffer" temporary;
        recVendorLedger: Record "Vendor Ledger Entry";
        recVendor: Record Vendor;
        //recVendorBankAccount: Record "Vendor Bank Account";
        recBankAccount: Record "Bank Account";
        recEmployeeLedgerEntry: Record "Employee Ledger Entry";
        cdCRNNo: Code[20];
        cdLineNo: Code[10];
    begin
        if not Confirm('Do you want to export the Axis Bank Payment File?', false) then
            exit;

        recBankLedger.Reset();
        recBankLedger.CopyFilters(BankLedgerEntry2);
        recBankLedger.SetFilter("Amount (LCY)", '<%1', 0);
        recBankLedger.SetRange(Reversed, false);
        if recBankLedger.FindSet() then begin
            recBankAccount.Get(recBankLedger."Bank Account No.");
            recBankAccount.TestField("Bank Account No.");

            tempExcelBuffer.Reset();
            tempExcelBuffer.DeleteAll();
            tempExcelBuffer.CreateNewBook('PaymentData');

            //Insert Header Row
            /*
            tempExcelBuffer.NewRow();
            tempExcelBuffer.AddColumn('Payment Method Name', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Amount', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Value Date', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Beneficiary Name', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Bene Account Number', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Email ID of beneficiary', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Email Body', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Debit Account Number', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('CRN (Narration  / Remarks)', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Receiver IFSC', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Receiver A/c type', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Remarks (Beneficiary Account Stmt narration)', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Phone No.', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            */

            cdLineNo := '000';
            repeat
                cdCRNNo := Format(Date2DMY(recBankLedger."Posting Date", 1)) + Format(Date2DMY(recBankLedger."Posting Date", 2)) + Format(Date2DMY(recBankLedger."Posting Date", 3));
                cdLineNo := IncStr(cdLineNo);
                cdCRNNo := cdCRNNo + cdLineNo;

                tempExcelBuffer.NewRow();
                if Abs(recBankLedger."Amount (LCY)") > 200000 then
                    tempExcelBuffer.AddColumn('R', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text)
                else
                    tempExcelBuffer.AddColumn('N', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                tempExcelBuffer.AddColumn(Abs(recBankLedger."Amount (LCY)"), false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Number);
                tempExcelBuffer.AddColumn(recBankLedger."Posting Date", false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Date);

                recVendorLedger.Reset();
                recVendorLedger.SetRange("Document No.", recBankLedger."Document No.");
                recVendorLedger.SetRange("Posting Date", recBankLedger."Posting Date");
                recVendorLedger.SetRange("Transaction No.", recBankLedger."Transaction No.");
                if recVendorLedger.FindFirst() then begin
                    recVendor.Get(recVendorLedger."Vendor No.");
                    recVendor.TestField("Bank Account No.");
                    //recVendorBankAccount.Reset();
                    //recVendorBankAccount.SetRange("Vendor No.", recVendorLedger."Vendor No.");
                    //recVendorBankAccount.FindFirst();
                    //recVendorBankAccount.TestField("Bank Account No.");

                    tempExcelBuffer.AddColumn(recVendor.Name, false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                    tempExcelBuffer.AddColumn(recVendor."Bank Account No.", false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                    tempExcelBuffer.AddColumn(recVendor."E-Mail", false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                    tempExcelBuffer.AddColumn('', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                    tempExcelBuffer.AddColumn(recBankAccount."Bank Account No.", false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                    tempExcelBuffer.AddColumn(cdCRNNo, false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                    tempExcelBuffer.AddColumn(recVendor."Bank IFSC Code", false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                    tempExcelBuffer.AddColumn('11', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                    tempExcelBuffer.AddColumn('', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                    tempExcelBuffer.AddColumn('', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                end else
                    Error('No vendor ledger entry found to export.');
            until recBankLedger.Next() = 0;

            tempExcelBuffer.WriteSheet('HeaderInfo', CompanyName, UserId);
            tempExcelBuffer.CloseBook();
            tempExcelBuffer.SetFriendlyFilename('AxisBankPaymentData');
            tempExcelBuffer.OpenExcel();

            Message('The file has been exported.');
        end else
            Error('Nothing to export.');
    end;

    procedure ExportICICIBankPaymentFile(var BankLedgerEntry2: Record "Bank Account Ledger Entry")
    var
        recBankLedger: Record "Bank Account Ledger Entry";
        tempExcelBuffer: Record "Excel Buffer" temporary;
        recVendorLedger: Record "Vendor Ledger Entry";
        recVendor: Record Vendor;
        //recVendorBankAccount: Record "Vendor Bank Account";
        recBankAccount: Record "Bank Account";
        intSrNo: Integer;
        cdExtDocNo: Code[20];
        dtExtDocDate: Date;
        decInvoiceAmount: Decimal;
    begin
        if not Confirm('Do you want to export the ICICI Bank Payment File?', false) then
            exit;

        recBankLedger.Reset();
        recBankLedger.CopyFilters(BankLedgerEntry2);
        recBankLedger.SetFilter("Amount (LCY)", '<%1', 0);
        recBankLedger.SetRange(Reversed, false);
        if recBankLedger.FindSet() then begin
            recBankAccount.Get(recBankLedger."Bank Account No.");

            tempExcelBuffer.Reset();
            tempExcelBuffer.DeleteAll();
            tempExcelBuffer.CreateNewBook('PaymentData');

            //Insert Header Row
            tempExcelBuffer.NewRow();
            tempExcelBuffer.AddColumn('Sr. No.', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Code', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Operator Name', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Invoice Number', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Invoice Date', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Settlement Type', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('From Date', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('To Date', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Total Invoice Amount', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('IFSC', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Beneficiary Name', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Acc Number', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Branch Place', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Beneficiary Mail', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Beneficiary Contact No.', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('Mode of Payment', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
            tempExcelBuffer.AddColumn('From Account', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);

            intSrNo := 0;
            repeat
                intSrNo += 1;
                tempExcelBuffer.NewRow();
                tempExcelBuffer.AddColumn(intSrNo, false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Number);
                tempExcelBuffer.AddColumn('', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);

                recVendorLedger.Reset();
                recVendorLedger.SetRange("Document No.", recBankLedger."Document No.");
                recVendorLedger.SetRange("Posting Date", recBankLedger."Posting Date");
                recVendorLedger.SetRange("Transaction No.", recBankLedger."Transaction No.");
                recVendorLedger.FindFirst();
                FindApplnEntriesDtldtLedgEntry(recVendorLedger."Entry No.", cdExtDocNo, dtExtDocDate, decInvoiceAmount);

                recVendor.Get(recVendorLedger."Vendor No.");
                recVendor.TestField("Bank Account No.");
                //recVendorBankAccount.Reset();
                //recVendorBankAccount.SetRange("Vendor No.", recVendorLedger."Vendor No.");
                //recVendorBankAccount.FindFirst();

                tempExcelBuffer.AddColumn(recVendor.Name, false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                tempExcelBuffer.AddColumn(cdExtDocNo, false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                tempExcelBuffer.AddColumn(dtExtDocDate, false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Date);
                tempExcelBuffer.AddColumn('', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                tempExcelBuffer.AddColumn(recVendorLedger."Posting Date", false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Date);
                tempExcelBuffer.AddColumn(recVendorLedger."Posting Date", false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Date);
                tempExcelBuffer.AddColumn(decInvoiceAmount, false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Number);
                tempExcelBuffer.AddColumn(recVendor."Bank IFSC Code", false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                tempExcelBuffer.AddColumn(recVendor.Name, false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                tempExcelBuffer.AddColumn(recVendor."Bank Account No.", false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                tempExcelBuffer.AddColumn(recVendor.City, false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                tempExcelBuffer.AddColumn(recVendor."E-Mail", false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                tempExcelBuffer.AddColumn(recVendor."Phone No.", false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);

                if Abs(recBankLedger."Amount (LCY)") > 200000 then
                    tempExcelBuffer.AddColumn('R', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text)
                else
                    tempExcelBuffer.AddColumn('N', false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);
                tempExcelBuffer.AddColumn(recBankAccount."Bank Account No.", false, '', false, false, false, '', tempExcelBuffer."Cell Type"::Text);

            until recBankLedger.Next() = 0;

            tempExcelBuffer.WriteSheet('HeaderInfo', CompanyName, UserId);
            tempExcelBuffer.CloseBook();
            tempExcelBuffer.SetFriendlyFilename('ICICIBankPaymentData');
            tempExcelBuffer.OpenExcel();

            Message('The file has been exported.');
        end else
            Error('Nothing to export.');
    end;

    local procedure FindApplnEntriesDtldtLedgEntry(VLEEntryNo: Integer; ExtDocNo: Code[20]; ExtDocDate: Date; ExtInvoiceAmount: Decimal)
    var
        DtldVendLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        recVLE: Record "Vendor Ledger Entry";
    begin
        ExtDocNo := '';
        ExtDocDate := 0D;
        ExtInvoiceAmount := 0;
        DtldVendLedgEntry1.Reset();
        DtldVendLedgEntry1.SetCurrentKey("Vendor Ledger Entry No.");
        DtldVendLedgEntry1.SetRange("Vendor Ledger Entry No.", VLEEntryNo);
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
                                    recVLE.CalcFields("Original Amt. (LCY)");
                                    ExtDocNo := recVLE."External Document No.";
                                    ExtDocDate := recVLE."Document Date";
                                    ExtInvoiceAmount := Abs(recVLE."Original Amt. (LCY)");
                                end;
                            end;
                        until DtldVendLedgEntry2.Next() = 0;
                end else begin
                    recVLE.Reset();
                    recVLE.SetCurrentKey("Entry No.");
                    recVLE.SetRange("Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    if recVLE.Find('-') then begin
                        recVLE.CalcFields("Original Amt. (LCY)");
                        ExtDocNo := recVLE."External Document No.";
                        ExtDocDate := recVLE."Document Date";
                        ExtInvoiceAmount := Abs(recVLE."Original Amt. (LCY)");
                    end;
                end;
            until DtldVendLedgEntry1.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Payment Terms Code', true, true)]
    local procedure CalculateDueDateFromPaymentTerm(var Rec: Record "Purchase Header")
    begin
        CalculateDueDateBasedOnConfiguration(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Posting Date', true, true)]
    local procedure CalculateDueDateFromPostingDate(var Rec: Record "Purchase Header")
    begin
        CalculateDueDateBasedOnConfiguration(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Document Date', true, true)]
    local procedure CalculateDueDateFromDocumentDate(var Rec: Record "Purchase Header")
    begin
        CalculateDueDateBasedOnConfiguration(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Due Date Calc. Basis', true, true)]
    local procedure CalculateDueDateFromDueDateCalcBasis(var Rec: Record "Purchase Header")
    begin
        CalculateDueDateBasedOnConfiguration(Rec);
    end;

    local procedure CalculateDueDateBasedOnConfiguration(var PurchHeader: Record "Purchase Header")
    var
        recPaymentTermCode: Record "Payment Terms";
    begin
        if (recPaymentTermCode.Get(PurchHeader."Payment Terms Code")) and (Format(recPaymentTermCode."Due Date Calculation") <> '') then begin
            if PurchHeader."Due Date Calc. Basis" <> PurchHeader."Due Date Calc. Basis"::" " then begin
                if PurchHeader."Due Date Calc. Basis" = PurchHeader."Due Date Calc. Basis"::"Document Date" then
                    PurchHeader."Due Date" := CalcDate(recPaymentTermCode."Due Date Calculation", PurchHeader."Document Date")
                else
                    PurchHeader."Due Date" := CalcDate(recPaymentTermCode."Due Date Calculation", PurchHeader."Posting Date");
            end else
                PurchHeader."Due Date" := CalcDate(recPaymentTermCode."Due Date Calculation", PurchHeader."Document Date");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCopyBuyFromVendorFieldsFromVendor', '', true, true)]
    local procedure UpdateVendorInfoOnPurchHeader(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor)
    begin
        PurchaseHeader."Due Date Calc. Basis" := Vendor."Due Date Calc. Basis";
        PurchaseHeader."RCM Applicable" := Vendor."RCM Applicable";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', true, true)]
    local procedure PurchasePostingValidation(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    var
        recPurchLine: Record "Purchase Line";
        recGSTGroup: Record "GST Group";
        recTaxTransaction: Record "Tax Transaction Value";
        decGSTAmount: Decimal;
        recTDSSection: Record "TDS Section";
        recPurchComments: Record "Purch. Comment Line";
    begin
        PurchaseHeader.TestField("Internal Document Type");

        // if (PurchaseHeader."Created By" = UserId) and (PreviewMode = false) then
        //     Error('The document can not be posted by the user who created the same.');

        recPurchComments.Reset();
        recPurchComments.SetRange("Document Type", PurchaseHeader."Document Type");
        recPurchComments.SetRange("No.", PurchaseHeader."No.");
        if not recPurchComments.FindFirst() then
            Error('Comments are mandatory, enter the same first.');

        PurchaseHeader.TestField("RCM Applicable");
        if PurchaseHeader."RCM Applicable" = PurchaseHeader."RCM Applicable"::Yes then
            PurchaseHeader.TestField("Invoice Type", PurchaseHeader."Invoice Type"::"Self Invoice");

        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then begin
            PurchaseHeader.TestField("Document Basis");
            if PurchaseHeader."Document Basis" = PurchaseHeader."Document Basis"::"PO Base" then
                PurchaseHeader.TestField("Purch. Order No.");
        end;

        recPurchLine.Reset();
        recPurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        recPurchLine.SetRange("Document No.", PurchaseHeader."No.");
        recPurchLine.FindFirst();
        repeat
            decGSTAmount := 0;
            recTaxTransaction.Reset();
            recTaxTransaction.SetRange("Tax Record ID", recPurchLine.RecordId);
            recTaxTransaction.SetRange("Tax Type", 'GST');
            recTaxTransaction.SetRange("Value Type", recTaxTransaction."Value Type"::COMPONENT);
            recTaxTransaction.SetFilter("Value ID", '%1|%2|%3', 2, 3, 6);
            if recTaxTransaction.FindFirst() then
                repeat
                    decGSTAmount += recTaxTransaction."Amount (LCY)";
                until recTaxTransaction.Next() = 0;

            if PurchaseHeader."RCM Applicable" = PurchaseHeader."RCM Applicable"::No then begin
                if recGSTGroup.Get(recPurchLine."GST Group Code") then
                    recGSTGroup.TestField("Reverse Charge", false);
            end;
            if PurchaseHeader."RCM Applicable" = PurchaseHeader."RCM Applicable"::Yes then begin
                recGSTGroup.Get(recPurchLine."GST Group Code");
                recGSTGroup.TestField("Reverse Charge", true);
                if decGSTAmount = 0 then
                    Error('GST Amount must not be zero for line no. %1', recPurchLine."Line No.");
            end;

            if (PurchaseHeader."206 AB" = true) and (recPurchLine."TDS Section Code" <> '') then begin
                recTDSSection.Get(recPurchLine."TDS Section Code");
                if recTDSSection."206 AB" = false then
                    Error('The TDS section must beling to 206 AB on purchase line no. %1', recPurchLine."Line No.");
            end;
        until recPurchLine.Next() = 0;
    end;

    var
}