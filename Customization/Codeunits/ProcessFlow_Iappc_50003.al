codeunit 50003 "Process Flow"
{
    Permissions = tabledata "Purch. Rcpt. Line" = rm,
                            tabledata "Item Ledger Entry" = rm,
                            tabledata "Sales Invoice Header" = rm,
                            tabledata "Sales Cr.Memo Header" = rm,
                            tabledata "Detailed GST Ledger Entry" = rm,
                            tabledata "TDS Entry" = rim;

    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed GST Ledger Entry", 'OnAfterInsertEvent', '', true, true)]
    local procedure StopRCMApplicationEntry(var Rec: Record "Detailed GST Ledger Entry")
    begin
        Rec."Remaining Closed" := true;
        Rec."Remaining Base Amount" := 0;
        Rec."Remaining GST Amount" := 0;
        Rec.MODIFY;
    end;

    //TDS On Credit Memo Posting Begin
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure CalculateTDSBeforePosting(var PurchaseHeader: Record "Purchase Header")
    var
        recPurchaseLines: Record "Purchase Line";
    begin
        recPurchaseLines.CalculateTDSOnCreditMemo(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostVendorEntry', '', false, false)]
    local procedure AdjustPurchaseTDSToVendor(var PurchHeader: Record "Purchase Header"; var GenJnlLine: Record "Gen. Journal Line")
    var
        decTotalTDSAmount: Decimal;
        recPurchaseLines: Record "Purchase Line";
        decTotalTDSAmountLCY: Decimal;
    begin
        decTotalTDSAmount := 0;
        recPurchaseLines.Reset();
        recPurchaseLines.SetRange("Document Type", PurchHeader."Document Type");
        recPurchaseLines.SetRange("Document No.", PurchHeader."No.");
        recPurchaseLines.SetFilter("Iappc TDS Section", '<>%1', '');
        if recPurchaseLines.FindFirst() then
            repeat
                decTotalTDSAmount += recPurchaseLines."TDS to Post";
            until recPurchaseLines.Next() = 0;

        if PurchHeader."Document Type" in [PurchHeader."Document Type"::"Return Order", PurchHeader."Document Type"::"Credit Memo"] then
            decTotalTDSAmount := -decTotalTDSAmount;

        if PurchHeader."Currency Code" <> '' then begin
            decTotalTDSAmountLCY := Round(decTotalTDSAmount / PurchHeader."Currency Factor", 0.01);
        end else
            decTotalTDSAmountLCY := decTotalTDSAmount;

        GenJnlLine.Amount := GenJnlLine.Amount + decTotalTDSAmount;
        GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" + decTotalTDSAmountLCY;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostVendorEntry', '', false, false)]
    local procedure PostPurchTDS(var PurchHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
                                var GenJnlLine: Record "Gen. Journal Line");
    var
        decCurrencyFactor: Decimal;
        recTDSToPost: Record "Purchase Line" temporary;
        recPurchaseLines: Record "Purchase Line";
        recSourceCodeSetup: Record "Source Code Setup";
        decSign: Decimal;
        recVendor: Record Vendor;
        recTDSPostingSetup: Record "TDS Posting Setup";
        recGLAccount: Record "G/L Account";
        recTDSEntry: Record "TDS Entry";
        recLocation: Record Location;
        intEntryNo: Integer;
    begin
        if PurchHeader."Currency Code" <> '' then
            decCurrencyFactor := 1 / PurchHeader."Currency Factor"
        else
            decCurrencyFactor := 1;
        recLocation.Get(PurchHeader."Location Code");
        recLocation.TestField("T.A.N. No.");

        recTDSToPost.Reset();
        recTDSToPost.DeleteAll();
        recPurchaseLines.Reset();
        recPurchaseLines.SetRange("Document Type", PurchHeader."Document Type");
        recPurchaseLines.SetRange("Document No.", PurchHeader."No.");
        recPurchaseLines.SetFilter("Iappc TDS Section", '<>%1', '');
        if recPurchaseLines.FindFirst() then begin
            recSourceCodeSetup.GET;
            if PurchHeader."Document Type" in [PurchHeader."Document Type"::"Return Order", PurchHeader."Document Type"::"Credit Memo"] then
                decSign := -1
            else
                decSign := 1;
            recVendor.Get(recPurchaseLines."Pay-to Vendor No.");

            repeat
                recTDSToPost.Reset();
                recTDSToPost.SetRange("Iappc TDS Section", recPurchaseLines."Iappc TDS Section");
                recTDSToPost.SetRange("Concessional Code", recPurchaseLines."Concessional Code");
                if recTDSToPost.FindFirst() then begin
                    recTDSToPost."Line Amount" += recPurchaseLines."Line Amount";
                    recTDSToPost."TDS Amount" += recPurchaseLines."TDS to Post";
                    recTDSToPost."TDS Base Amount" += Round(recPurchaseLines."TDS Base Amount" / recPurchaseLines.Quantity * recPurchaseLines."Qty. to Invoice", 0.01);
                    recTDSToPost.Modify();
                end else begin
                    recTDSToPost.Init();
                    recTDSToPost."Line No." := recPurchaseLines."Line No.";
                    recTDSToPost."Iappc TDS Section" := recPurchaseLines."Iappc TDS Section";
                    recTDSToPost."TDS Amount" := Round(recPurchaseLines."TDS to Post" * decCurrencyFactor, 0.01);
                    recTDSToPost."TDS Base Amount" := Round(recPurchaseLines."TDS Base Amount" / recPurchaseLines.Quantity * recPurchaseLines."Qty. to Invoice", 0.01);
                    recTDSToPost."TDS Base Amount" := Round(recTDSToPost."TDS Base Amount" * decCurrencyFactor, 0.01);
                    recTDSToPost."Tax Group Code" := recVendor."Assessee Code";
                    recTDSToPost."Concessional Code" := recPurchaseLines."Concessional Code";
                    recTDSToPost."TDS %" := recPurchaseLines."TDS %";
                    recTDSToPost."No." := recPurchaseLines."No.";
                    recTDSToPost.Description := recPurchaseLines.Description;
                    recTDSToPost."Line Amount" := recPurchaseLines."Line Amount";
                    recTDSToPost.Insert();
                end;
            until recPurchaseLines.Next() = 0;

            recTDSToPost.Reset();
            if recTDSToPost.FindFirst() then begin
                recTDSEntry.Reset();
                if recTDSEntry.FindLast() then
                    intEntryNo := recTDSEntry."Entry No."
                else
                    intEntryNo := 0;

                repeat
                    if recTDSToPost."TDS Amount" <> 0 then begin
                        recTDSPostingSetup.Reset();
                        recTDSPostingSetup.SetRange("TDS Section", recTDSToPost."Iappc TDS Section");
                        recTDSPostingSetup.SetRange("Effective Date", 0D, PurchHeader."Posting Date");
                        recTDSPostingSetup.FindLast();
                        recTDSPostingSetup.TestField("TDS Account");

                        recGLAccount.Get(recTDSPostingSetup."TDS Account");
                        recGLAccount.TestField(Blocked, false);
                        recGLAccount.TestField("Account Type", recGLAccount."Account Type"::Posting);

                        recTDSEntry.Init();
                        intEntryNo += 1;
                        recTDSEntry."Entry No." := intEntryNo;
                        recTDSEntry."Document No." := PurchHeader."Posting No.";
                        recTDSEntry."Posting Date" := PurchHeader."Posting Date";
                        recTDSEntry."Account No." := recTDSPostingSetup."TDS Account";
                        if decSign < 0 then
                            recTDSEntry."Document Type" := recTDSEntry."Document Type"::"Credit Memo"
                        else
                            recTDSEntry."Document Type" := recTDSEntry."Document Type"::Invoice;
                        recTDSEntry."T.A.N. No." := recLocation."T.A.N. No.";
                        recTDSEntry."Vendor No." := PurchHeader."Pay-to Vendor No.";
                        recTDSEntry."Vendor Name" := PurchHeader."Pay-to Name";
                        //recTDSEntry."External Doc. No." := PurchHeader."Vendor Invoice No.";
                        recTDSEntry."Assessee Code" := recTDSToPost."Tax Group Code";
                        recTDSEntry.Section := recTDSToPost."Iappc TDS Section";
                        recTDSEntry."Concessional Code" := recTDSToPost."Concessional Code";
                        recTDSEntry."TDS Base Amount" := recTDSToPost."TDS Base Amount" * decSign;
                        recTDSEntry."TDS %" := recTDSToPost."TDS %";
                        recTDSEntry."TDS Amount" := recTDSToPost."TDS Amount" * decSign;
                        recTDSEntry."TDS Amount Including Surcharge" := recTDSToPost."TDS Amount" * decSign;
                        recTDSEntry."Total TDS Including SHE CESS" := recTDSToPost."TDS Amount" * decSign;
                        recTDSEntry."Deductee PAN No." := recVendor."P.A.N. No.";
                        recTDSEntry."Invoice Amount" := recTDSToPost."Line Amount" * decSign;
                        recTDSEntry.Insert(true);

                        GenJnlLine.INIT;
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                        GenJnlLine."Posting Date" := PurchHeader."Posting Date";
                        GenJnlLine."Document Date" := PurchHeader."Document Date";
                        if decSign < 0 then
                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"
                        else
                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
                        GenJnlLine."Account No." := recTDSPostingSetup."TDS Account";
                        GenJnlLine.Amount := -(recTDSToPost."TDS Amount" * decSign);
                        GenJnlLine."Amount (LCY)" := -(recTDSToPost."TDS Amount" * decSign);
                        GenJnlLine."Source Currency Amount" := -(recTDSToPost."TDS Amount" * decSign);
                        GenJnlLine."System-Created Entry" := TRUE;
                        GenJnlLine.Description := PurchHeader."Posting Description";
                        GenJnlLine."Document No." := PurchHeader."Posting No.";

                        if PurchHeader."Document Type" in [PurchHeader."Document Type"::"Return Order", PurchHeader."Document Type"::"Credit Memo"] then
                            GenJnlLine."External Document No." := PurchHeader."Vendor Cr. Memo No."
                        else
                            GenJnlLine."External Document No." := PurchHeader."Vendor Invoice No.";
                        GenJnlLine."Source Currency Code" := PurchHeader."Currency Code";
                        GenJnlLine."Reason Code" := PurchHeader."Reason Code";
                        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
                        GenJnlLine."Source No." := PurchHeader."Pay-to Vendor No.";
                        GenJnlLine."Posting No. Series" := PurchHeader."Posting No. Series";
                        GenJnlLine."Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
                        GenJnlLine."Dimension Set ID" := PurchHeader."Dimension Set ID";
                        GenJnlLine."Source Code" := recSourceCodeSetup.Purchases;
                        GenJnlPostLine.RunWithCheck(GenJnlLine);
                    end;
                until recTDSToPost.Next() = 0;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purch. Cr. Memo Subform", 'OnAfterValidateEvent', 'Quantity', true, true)]
    local procedure CalculateGSTTDSOnValidateGSTGroup(var Rec: Record "Purchase Line")
    begin
        Rec.CalculateLineTDS(Rec);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purch. Cr. Memo Subform", 'OnAfterValidateEvent', 'Direct Unit Cost', true, true)]
    local procedure CalculateGSTTDSOnValidateHSNCode(var Rec: Record "Purchase Line")
    begin
        Rec.CalculateLineTDS(Rec);
        Rec.Modify();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purch. Cr. Memo Subform", 'OnAfterValidateEvent', 'Line Discount Amount', true, true)]
    local procedure CalculateGSTTDSOnValidateGSTCredit(var Rec: Record "Purchase Line")
    begin
        Rec.CalculateLineTDS(Rec);
        Rec.Modify();
    end;
    //TDS On Credit Memo Posting End

    [EventSubscriber(ObjectType::Report, Report::"Suggest Bank Acc. Recon. Lines", 'OnBeforeInsertBankAccReconLine', '', true, true)]
    local procedure UpdateChequeNoOnRecoLines(var BankAccLedgEntry: Record "Bank Account Ledger Entry"; var BankAccReconLine: Record "Bank Acc. Reconciliation Line")
    begin
        // BankAccReconLine."Check No." := BankAccLedgEntry."UTR No.";
        BankAccReconLine."UTR No." := BankAccLedgEntry."UTR No.";
        BankAccReconLine."Cheque Date" := BankAccLedgEntry."Cheque Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Shipment", 'OnPostItemJnlLineOnBeforeItemJnlPostLineRunWithCheck', '', true, true)]
    local procedure DimensionSetEntryToCarryOnShipment(InvtShptLine2: Record "Invt. Shipment Line"; var ItemJnlLine: Record "Item Journal Line")
    begin
        ItemJnlLine."Dimension Set ID" := InvtShptLine2."Dimension Set ID";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Receipt", 'OnPostItemJnlLineOnBeforeItemJnlPostLineRunWithCheck', '', true, true)]
    local procedure DimensionSetEntryToCarryOnRcpt(InvtRcptLine2: Record "Invt. Receipt Line"; var ItemJnlLine: Record "Item Journal Line")
    begin
        ItemJnlLine."Dimension Set ID" := InvtRcptLine2."Dimension Set ID";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order Lines", 'OnCopyFromFamilyOnBeforeInsertProdOrderLine', '', true, true)]
    local procedure UpdateVariantFromFamilyLine(FamilyLine: Record "Family Line"; var ProdOrderLine: Record "Prod. Order Line")
    var
        recItem: Record Item;
    begin
        recItem.Get(ProdOrderLine."Item No.");
        ProdOrderLine."Routing No." := recItem."Routing No.";
    end;

    [EventSubscriber(ObjectType::Report, Report::"Suggest Bank Acc. Recon. Lines", 'OnBeforeInsertBankAccReconLine', '', true, true)]
    local procedure UpdateReconciliationLines(var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var BankAccLedgEntry: Record "Bank Account Ledger Entry")
    begin
        BankAccReconLine."Cheque Date" := BankAccLedgEntry."Cheque Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure SalesInvHeaderCheckLocationState(var Rec: Record "Sales Invoice Header")
    var
        recLocation: Record Location;
    begin
        if Rec."Location Code" <> '' then begin
            if Rec."Location State Code" = '' then begin
                recLocation.Get(Rec."Location Code");
                Rec."Location State Code" := recLocation."State Code";
                Rec."Location GST Reg. No." := recLocation."GST Registration No.";
                Rec.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure SalesCrMemoHeaderCheckLocationState(var Rec: Record "Sales Cr.Memo Header")
    var
        recLocation: Record Location;
    begin
        if Rec."Location Code" <> '' then begin
            if Rec."Location State Code" = '' then begin
                recLocation.Get(Rec."Location Code");
                Rec."Location State Code" := recLocation."State Code";
                Rec."Location GST Reg. No." := recLocation."GST Registration No.";
                Rec.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure PurchLocGD1FlowFromUserSetup(var Rec: Record "Purchase Header")
    var
        recUserSetup: Record "User Setup";
    begin
        recUserSetup.Get(UserId);
        if recUserSetup."Default Location Code" <> '' then begin
            Rec."Location Code" := recUserSetup."Default Location Code";
            Rec.UpdateShipToAddress();
            Rec.Modify();
        end;
        if recUserSetup."Default Global Dimension 1" <> '' then begin
            Rec.Validate("Shortcut Dimension 1 Code", recUserSetup."Default Global Dimension 1");
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure SalesLocGD1FlowFromUserSetup(var Rec: Record "Sales Header")
    var
        recUserSetup: Record "User Setup";
    begin
        recUserSetup.Get(UserId);
        if recUserSetup."Default Location Code" <> '' then begin
            Rec."Location Code" := recUserSetup."Default Location Code";
            Rec.UpdateShipToAddress();
            Rec.Modify();
        end;
        if recUserSetup."Default Global Dimension 1" <> '' then begin
            Rec.Validate("Shortcut Dimension 1 Code", recUserSetup."Default Global Dimension 1");
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Production Order", 'OnAfterInsertEvent', '', true, true)]
    local procedure ProdOrderLocFlowFromUserSetup(var Rec: Record "Production Order")
    var
        recUserSetup: Record "User Setup";
    begin
        recUserSetup.Get(UserId);
        if recUserSetup."Default Location Code" <> '' then begin
            Rec."Location Code" := recUserSetup."Default Location Code";
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Production Order", 'OnAfterValidateEvent', 'Source No.', true, true)]
    local procedure ProdOrderGD1FromUserSetup(var Rec: Record "Production Order")
    var
        recUserSetup: Record "User Setup";
    begin
        recUserSetup.Get(UserId);
        if recUserSetup."Default Global Dimension 1" <> '' then begin
            Rec.Validate("Shortcut Dimension 1 Code", recUserSetup."Default Global Dimension 1");
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckSalesHeaderMandatoryFields(var Rec: Record "Sales Line")
    var
        recSalesHeader: Record "Sales Header";
    begin
        if not Rec.IsTemporary then begin
            recSalesHeader.Get(Rec."Document Type", Rec."Document No.");
            recSalesHeader.TestField("Location Code");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckPurchaseHeaderMandatoryFields(var Rec: Record "Purchase Line")
    var
        recPurchaseHeader: Record "Purchase Header";
    begin
        if not Rec.IsTemporary then begin
            recPurchaseHeader.Get(Rec."Document Type", Rec."Document No.");
            recPurchaseHeader.TestField("Location Code");
        end;
    end;

    procedure GetLocalCurrency(): Code[10]
    var
        recGLSetup: Record "General Ledger Setup";
    begin
        recGLSetup.Get();
        recGLSetup.TestField("LCY Code");
        exit(recGLSetup."LCY Code");
    end;

    /*
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeRunCheck', '', true, true)]
    local procedure CheckVoucherMandatoryValue(var GenJournalLine: Record "Gen. Journal Line")
    var
        recJournalTemplate: Record "Gen. Journal Template";
        recJournalNarration: Record "Gen. Journal Narration";
    begin
        if (recJournalTemplate.Get(GenJournalLine."Journal Template Name")) and (GenJournalLine."System-Created Entry" = false) then begin
            if recJournalTemplate."Source Code" in ['BANKPYMTV', 'BANKRCPTV', 'CASHPYMTV', 'CASHRCPTV', 'CONTRAV', 'JOURNALV'] then begin
                recJournalNarration.Reset();
                recJournalNarration.SETRANGE("Journal Template Name", GenJournalLine."Journal Template Name");
                recJournalNarration.SETRANGE("Journal Batch Name", GenJournalLine."Journal Batch Name");
                recJournalNarration.SETRANGE("Document No.", GenJournalLine."Document No.");
                IF NOT recJournalNarration.FINDFIRST THEN
                    ERROR('Narration is mandatory for journal vouching.');
            end;
        end;
    end;
    */

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', true, true)]
    local procedure SalesDocDeleteValidations(var Rec: Record "Sales Header")
    var
        cuArchiveManagement: Codeunit ArchiveManagement;
    begin
        Rec."Manually Closed" := true;
        cuArchiveManagement.StoreSalesDocument(Rec, false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeDeleteEvent', '', true, true)]
    local procedure PurchaseDocDeleteValidations(var Rec: Record "Purchase Header")
    var
        cuArchiveManagement: Codeunit ArchiveManagement;
    begin
        Rec."Manually Closed" := true;
        cuArchiveManagement.StorePurchDocument(Rec, false);
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure UpdateIndentOnPurchLineDelete(var Rec: Record "Purchase Line")
    var
        recIndentLine: Record "Indent Line";
    begin
        IF Rec."Indent No." <> '' THEN BEGIN
            recIndentLine.GET(Rec."Indent No.", Rec."Indent Line No.");
            recIndentLine."Remaining Quantity" := recIndentLine."Remaining Quantity" + Rec.Quantity;
            recIndentLine.MODIFY;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeValidateEvent', 'Quantity', true, true)]
    local procedure UpdateIndentOnPurchQuantityChange(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    var
        recIndentLine: Record "Indent Line";
    begin
        IF Rec."Indent No." <> '' THEN BEGIN
            recIndentLine.GET(Rec."Indent No.", Rec."Indent Line No.");
            IF recIndentLine."Remaining Quantity" + xRec.Quantity < Rec.Quantity THEN
                ERROR('Order quantity can not be more than %1 for selected indent line.', recIndentLine."Remaining Quantity" + xRec.Quantity);

            recIndentLine."Remaining Quantity" := recIndentLine."Remaining Quantity" + xRec.Quantity - Rec.Quantity;
            recIndentLine.MODIFY;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 121, 'OnAfterInsertEvent', '', true, true)]
    local procedure UpdateQCParameter(var Rec: Record "Purch. Rcpt. Line")
    var
        recItem: Record Item;
        recItemCategory: Record "Item Category";
    begin
        if (Rec.Type = Rec.Type::Item) and (Rec.Quantity <> 0) then begin
            recItem.Get(Rec."No.");
            if recItemCategory.Get(recItem."Item Category Code") then begin
                if recItemCategory."Purchase QC Required" then begin
                    Rec."QC Pending" := true;
                    Rec.Modify();
                end;
            end;
        end;
    end;

    procedure PostQC(DocumentNo: Code[20]; LineNo: Integer)
    var
        recItemJournal: Record "Item Journal Line";
        recItemLedger: Record "Item Ledger Entry";
        recLocation: Record Location;
        cuItemJournalPosting: Codeunit "Item Jnl.-Post Line";
        blnQCExist: Boolean;
        recInventorySetup: Record "Inventory Setup";
        intLineNo: Integer;
        recReservationEntry: Record "Reservation Entry";
        intEntryNo: Integer;
        recPurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        blnQCExist := FALSE;
        recInventorySetup.GET;
        recInventorySetup.TESTFIELD("QC Rejection Template");
        recInventorySetup.TESTFIELD("QC Rejection Batch");

        recItemJournal.RESET;
        recItemJournal.SETRANGE("Journal Template Name", recInventorySetup."QC Rejection Template");
        recItemJournal.SETRANGE("Journal Batch Name", recInventorySetup."QC Rejection Batch");
        IF recItemJournal.FIND('+') THEN
            intLineNo := recItemJournal."Line No."
        ELSE
            intLineNo := 0;

        recReservationEntry.RESET;
        IF recReservationEntry.FIND('+') THEN
            intEntryNo := recReservationEntry."Entry No.";

        recItemLedger.RESET;
        recItemLedger.SETRANGE("Document No.", DocumentNo);
        recItemLedger.SetRange("Document Line No.", LineNo);
        recItemLedger.SETRANGE("QC Posted", FALSE);
        IF recItemLedger.FIND('-') THEN BEGIN
            REPEAT
                IF (recItemLedger."Rejected Quantity" <> 0) THEN BEGIN
                    blnQCExist := TRUE;

                    recItemJournal.INIT;
                    recItemJournal.VALIDATE("Journal Template Name", recInventorySetup."QC Rejection Template");
                    recItemJournal.VALIDATE("Journal Batch Name", recInventorySetup."QC Rejection Batch");
                    intLineNo += 10000;
                    recItemJournal.VALIDATE("Line No.", intLineNo);
                    recItemJournal.VALIDATE("Posting Date", WORKDATE);
                    recItemJournal.VALIDATE("Document No.", recItemLedger."Document No.");
                    recItemJournal.VALIDATE("Item No.", recItemLedger."Item No.");
                    recItemJournal.VALIDATE("Entry Type", recItemJournal."Entry Type"::Transfer);
                    recItemJournal.VALIDATE("Location Code", recItemLedger."Location Code");
                    recLocation.GET(recItemLedger."Location Code");
                    recLocation.TESTFIELD("QC Rejection Location");
                    recItemJournal.VALIDATE("New Location Code", recLocation."QC Rejection Location");

                    recItemJournal.VALIDATE(Quantity, recItemLedger."Rejected Quantity");
                    recItemJournal.VALIDATE("Shortcut Dimension 1 Code", recItemLedger."Global Dimension 1 Code");
                    recItemJournal.VALIDATE("Shortcut Dimension 2 Code", recItemLedger."Global Dimension 2 Code");
                    recItemJournal.VALIDATE("New Shortcut Dimension 1 Code", recItemLedger."Global Dimension 1 Code");
                    recItemJournal.VALIDATE("New Shortcut Dimension 2 Code", recItemLedger."Global Dimension 2 Code");
                    recItemJournal.INSERT(TRUE);

                    IF (recItemLedger."Lot No." <> '') OR (recItemLedger."Serial No." <> '') THEN BEGIN
                        recReservationEntry.INIT;
                        intEntryNo += 1;
                        recReservationEntry."Entry No." := intEntryNo;
                        recReservationEntry.Positive := FALSE;
                        recReservationEntry."Item No." := recItemLedger."Item No.";
                        recReservationEntry."Location Code" := recItemLedger."Location Code";
                        recReservationEntry.VALIDATE("Quantity (Base)", -recItemLedger."Rejected Quantity");
                        recReservationEntry."Reservation Status" := recReservationEntry."Reservation Status"::Prospect;
                        recReservationEntry."Creation Date" := TODAY;
                        recReservationEntry."Source Type" := 83;
                        recReservationEntry."Source Subtype" := 4;
                        recReservationEntry."Source ID" := recInventorySetup."QC Rejection Template";
                        recReservationEntry."Source Batch Name" := recInventorySetup."QC Rejection Batch";
                        recReservationEntry."Source Ref. No." := intLineNo;
                        recReservationEntry."Appl.-to Item Entry" := recItemLedger."Entry No.";

                        IF recItemLedger."Lot No." <> '' THEN BEGIN
                            recReservationEntry."Lot No." := recItemLedger."Lot No.";
                            recReservationEntry."New Lot No." := recItemLedger."Lot No.";
                            recReservationEntry."New Expiration Date" := recItemLedger."Expiration Date";
                            recReservationEntry."Item Tracking" := recReservationEntry."Item Tracking"::"Lot No.";
                        END;
                        IF recItemLedger."Serial No." <> '' THEN BEGIN
                            recReservationEntry."Serial No." := recItemLedger."Serial No.";
                            recReservationEntry."New Serial No." := recItemLedger."Serial No.";
                            recReservationEntry."Item Tracking" := recReservationEntry."Item Tracking"::"Serial No.";
                        END;

                        recReservationEntry."Created By" := USERID;
                        recReservationEntry."Qty. per Unit of Measure" := 1;
                        recReservationEntry.Binding := recReservationEntry.Binding::" ";
                        recReservationEntry."Suppressed Action Msg." := FALSE;
                        recReservationEntry."Planning Flexibility" := recReservationEntry."Planning Flexibility"::Unlimited;
                        recReservationEntry."Quantity Invoiced (Base)" := 0;
                        recReservationEntry.Correction := FALSE;
                        recReservationEntry.INSERT;
                    END;

                    cuItemJournalPosting.RunWithCheck(recItemJournal);
                end;

            //recItemLedger."QC Posted" := true;
            //recItemLedger.Modify();
            until recItemLedger.Next() = 0;

            recPurchRcptLine.RESET;
            recPurchRcptLine.SETRANGE("Document No.", DocumentNo);
            recPurchRcptLine.SetRange("Line No.", LineNo);
            recPurchRcptLine.SETRANGE(Type, recPurchRcptLine.Type::Item);
            recPurchRcptLine.SETFILTER("No.", '<>%1', '');
            recPurchRcptLine.SETFILTER(Quantity, '<>%1', 0);
            recPurchRcptLine.SETRANGE("QC Pending", true);
            IF recPurchRcptLine.FINDFIRST THEN begin
                recPurchRcptLine."QC Pending" := false;
                recPurchRcptLine.MODIFY;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Reconciliation Post", 'OnBeforeAppliedAmountCheck', '', true, true)]
    local procedure BankReconciliationPostingValidation(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    begin
        BankAccReconciliationLine.TestField("Value Date");
    end;

    [EventSubscriber(ObjectType::Report, Report::"Refresh Production Order", 'OnAfterRefreshProdOrder', '', true, true)]
    local procedure MarkProdOrderRefreshed(var ProductionOrder: Record "Production Order")
    begin
        ProductionOrder.Refreshed := true;
        ProductionOrder.Modify();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order List", 'OnBeforeActionEvent', 'SendApprovalRequest', true, true)]
    local procedure SalesOrderListApp(var Rec: Record "Sales Header")
    begin
        SalesApprovalMandatoryCheck(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnBeforeActionEvent', 'IappcSendApprovalRequest', true, true)]
    local procedure SalesOrderCardApp(var Rec: Record "Sales Header")
    begin
        SalesApprovalMandatoryCheck(Rec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', true, true)]
    local procedure SalesDocReleaseCheck(var SalesHeader: Record "Sales Header")
    begin
        SalesApprovalMandatoryCheck(SalesHeader);
    end;

    local procedure SalesApprovalMandatoryCheck(var Rec: Record "Sales Header")
    var
        recSalesLine: Record "Sales Line";
    begin
        Rec.TestField("Location Code");

        recSalesLine.Reset();
        recSalesLine.SetRange("Document Type", Rec."Document Type");
        recSalesLine.SetRange("Document No.", Rec."No.");
        recSalesLine.SetFilter("No.", '<>%1', '');
        recSalesLine.FindSet();
        repeat
            recSalesLine.TestField("Location Code", Rec."Location Code");
        until recSalesLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', true, true)]
    local procedure SalesPostMandatoryCheck(var SalesHeader: Record "Sales Header")
    var
        recSalesLine: Record "Sales Line";
    begin
        SalesHeader.TestField("Location Code");
        // SalesHeader.TestField("Salesperson Code");

        recSalesLine.Reset();
        recSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        recSalesLine.SetRange("Document No.", SalesHeader."No.");
        recSalesLine.SetFilter("No.", '<>%1', '');
        recSalesLine.FindSet();
        repeat
            recSalesLine.TestField("Location Code", SalesHeader."Location Code");
        until recSalesLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order List", 'OnBeforeActionEvent', 'SendApprovalRequest', true, true)]
    local procedure PurchOrderListApp(var Rec: Record "Purchase Header")
    begin
        PurchaseApprovalMandatoryCheck(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnBeforeActionEvent', 'IappcSendApprovalRequest', true, true)]
    local procedure PurchOrderCardApp(var Rec: Record "Purchase Header")
    begin
        PurchaseApprovalMandatoryCheck(Rec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasePurchaseDoc', '', true, true)]
    local procedure PurchaseDocReleaseCheck(var PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseApprovalMandatoryCheck(PurchaseHeader);
    end;

    local procedure PurchaseApprovalMandatoryCheck(var Rec: Record "Purchase Header")
    var
        recPurchaseLine: Record "Purchase Line";
    begin
        Rec.TestField("Location Code");

        recPurchaseLine.Reset();
        recPurchaseLine.SetRange("Document Type", Rec."Document Type");
        recPurchaseLine.SetRange("Document No.", Rec."No.");
        recPurchaseLine.SetFilter("No.", '<>%1', '');
        recPurchaseLine.FindSet();
        repeat
            recPurchaseLine.TestField("Location Code", Rec."Location Code");
        until recPurchaseLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', true, true)]
    local procedure PurchasePostMandatoryCheck(var PurchaseHeader: Record "Purchase Header")
    var
        recPurchaseLine: Record "Purchase Line";
    begin
        PurchaseHeader.TestField("Location Code");

        recPurchaseLine.Reset();
        recPurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        recPurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        recPurchaseLine.SetFilter("No.", '<>%1', '');
        recPurchaseLine.FindSet();
        repeat
            recPurchaseLine.TestField("Location Code", PurchaseHeader."Location Code");
        until recPurchaseLine.Next() = 0;
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text1280000;
        ExponentText[4] := Text1280001;
    end;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        DecimalPosition: Decimal;
    begin
        No := Round(No, 0.01);
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                IF No > 99999 THEN BEGIN
                    Ones := No DIV (POWER(100, Exponent - 1) * 10);
                    Hundreds := 0;
                END ELSE BEGIN
                    Ones := No DIV POWER(1000, Exponent - 1);
                    Hundreds := Ones DIV 100;
                END;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                IF No > 99999 THEN
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(100, Exponent - 1) * 10
                ELSE
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;

        IF CurrencyCode <> '' THEN BEGIN
            Currency.GET(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency."Currency Numeric Description");
        END ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'RUPEES ONLY');

        if No > 0 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);

            TensDec := ((No * 100) MOD 100) DIV 10;
            OnesDec := (No * 100) MOD 10;
            IF TensDec >= 2 THEN BEGIN
                AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
                IF OnesDec > 0 THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
            END ELSE
                IF (TensDec * 10 + OnesDec) > 0 THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
                ELSE
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text026);
            IF (CurrencyCode <> '') THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency."Currency Decimal Description" + ' ONLY')
            ELSE
                AddToNoText(NoText, NoTextIndex, PrintExponent, ' PAISA ONLY');
        end;
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[200]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    local procedure GetAmtDecimalPosition(): Decimal
    var
        Currency: Record Currency;
    begin
        Currency.InitRoundingPrecision;
        exit(1 / Currency."Amount Rounding Precision");
    end;

    var
        cuReleaseSalesDoc: Codeunit "Release Sales Document";
        cuApprovalsMgmt: Codeunit "Approvals Mgmt.";
        cuWorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND';
        Text029: Label '%1 results in a written number that is too long.';
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        Text1280000: Label 'LAKH';
        Text1280001: Label 'CRORE';
        Currency: Record Currency;
        TensDec: Integer;
        OnesDec: Integer;
}