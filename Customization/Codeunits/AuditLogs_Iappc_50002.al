codeunit 50002 "Audit Logs"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, 15, 'OnBeforeInsertEvent', '', true, true)]
    local procedure GLInsertLog(var Rec: Record "G/L Account")
    begin
        Rec."Created At" := CurrentDateTime;
        Rec."Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 15, 'OnBeforeModifyEvent', '', true, true)]
    local procedure GLModifiedLog(var Rec: Record "G/L Account")
    begin
        Rec."Modified By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CustomerInsertLog(var Rec: Record Customer)
    begin
        Rec."Created At" := CurrentDateTime;
        Rec."Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CustomerModifiedLog(var Rec: Record Customer)
    begin
        Rec."Modified By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 23, 'OnBeforeInsertEvent', '', true, true)]
    local procedure VendorInsertLog(var Rec: Record Vendor)
    begin
        Rec."Created At" := CurrentDateTime;
        Rec."Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 23, 'OnBeforeModifyEvent', '', true, true)]
    local procedure VendorModifiedLog(var Rec: Record Vendor)
    begin
        Rec."Modified By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnBeforeInsertEvent', '', true, true)]
    local procedure VendorBankAccInsertLog(var Rec: Record "Vendor Bank Account")
    begin
        Rec."Created At" := CurrentDateTime;
        Rec."Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnBeforeModifyEvent', '', true, true)]
    local procedure VendorBankAccModifiedLog(var Rec: Record "Vendor Bank Account")
    begin
        Rec."Modified By" := UserId;
        Rec."Modified At" := CurrentDateTime;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeInsertEvent', '', true, true)]
    local procedure ItemInsertLog(var Rec: Record Item)
    begin
        Rec."Created At" := CurrentDateTime;
        Rec."Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeModifyEvent', '', true, true)]
    local procedure ItemModifiedLog(var Rec: Record Item)
    begin
        Rec."Modified By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 270, 'OnBeforeInsertEvent', '', true, true)]
    local procedure BankInsertLog(var Rec: Record "Bank Account")
    begin
        Rec."Created At" := CurrentDateTime;
        Rec."Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 270, 'OnBeforeModifyEvent', '', true, true)]
    local procedure BankModifiedLog(var Rec: Record "Bank Account")
    begin
        Rec."Modified By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 5600, 'OnBeforeInsertEvent', '', true, true)]
    local procedure FAInsertLog(var Rec: Record "Fixed Asset")
    begin
        Rec."Created At" := CurrentDateTime;
        Rec."Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 5600, 'OnBeforeModifyEvent', '', true, true)]
    local procedure FAModifiedLog(var Rec: Record "Fixed Asset")
    begin
        Rec."Modified By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnBeforeInsertEvent', '', true, true)]
    local procedure EmployeeInsertLog(var Rec: Record Employee)
    begin
        Rec."Created At" := CurrentDateTime;
        Rec."Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnBeforeModifyEvent', '', true, true)]
    local procedure EmployeeModifiedLog(var Rec: Record Employee)
    begin
        Rec."Modified By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 349, 'OnBeforeInsertEvent', '', true, true)]
    local procedure DimensionValueInsertLog(var Rec: Record "Dimension Value")
    begin
        Rec."Created At" := CurrentDateTime;
        Rec."Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 349, 'OnBeforeModifyEvent', '', true, true)]
    local procedure DimensionValueModifiedLog(var Rec: Record "Dimension Value")
    begin
        Rec."Modified By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeInsertEvent', '', true, true)]
    local procedure SalesHeaderInsertLog(var Rec: Record "Sales Header")
    begin
        Rec."Created At" := CurrentDateTime;
        Rec."Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeInsertEvent', '', true, true)]
    local procedure PurchaseHeaderInsertLog(var Rec: Record "Purchase Header")
    begin
        Rec."Created At" := CurrentDateTime;
        Rec."Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnBeforeInsertEvent', '', true, true)]
    local procedure GenJournalInsertLog(var Rec: Record "Gen. Journal Line")
    begin
        Rec."Created At" := CurrentDateTime;
        Rec."Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    local procedure UpdateApproverID(var ApprovalEntry: Record "Approval Entry")
    var
        recSalesHeader: Record "Sales Header";
        recPurchaseHeader: Record "Purchase Header";
        recGenLines: Record "Gen. Journal Line";
        txtTemp: Text;
        cdTemplate: Code[20];
        cdBatch: Code[20];
        intLineNo: Integer;
    begin
        if ApprovalEntry.Status = ApprovalEntry.Status::Approved then begin
            if ApprovalEntry."Table ID" = 36 then begin
                recSalesHeader.Reset();
                recSalesHeader.SetRange("Document Type", ApprovalEntry."Document Type");
                recSalesHeader.SetRange("No.", ApprovalEntry."Document No.");
                recSalesHeader.FindFirst();
                recSalesHeader."Approved At" := CurrentDateTime;
                recSalesHeader."Approved By" := UserId;
                recSalesHeader.Modify();
            end;
            if ApprovalEntry."Table ID" = 38 then begin
                recPurchaseHeader.Reset();
                recPurchaseHeader.SetRange("Document Type", ApprovalEntry."Document Type");
                recPurchaseHeader.SetRange("No.", ApprovalEntry."Document No.");
                recPurchaseHeader.FindFirst();
                recPurchaseHeader."Approved At" := CurrentDateTime;
                recPurchaseHeader."Approved By" := UserId;
                recPurchaseHeader.Modify();
            end;
            if ApprovalEntry."Table ID" = 81 then begin
                txtTemp := CopyStr(ApprovalEntry.RecordDetails(), StrPos(ApprovalEntry.RecordDetails(), ':') + 2);
                cdTemplate := CopyStr(txtTemp, 1, StrPos(txtTemp, ',') - 1);
                txtTemp := CopyStr(txtTemp, StrPos(txtTemp, ',') + 1);
                cdBatch := CopyStr(txtTemp, 1, StrPos(txtTemp, ',') - 1);
                txtTemp := CopyStr(txtTemp, StrPos(txtTemp, ',') + 1);
                Evaluate(intLineNo, txtTemp);
                recGenLines.Reset();
                recGenLines.SetRange("Journal Template Name", cdTemplate);
                recGenLines.SetRange("Journal Batch Name", cdBatch);
                recGenLines.SetRange("Line No.", intLineNo);
                recGenLines.FindFirst();
                recGenLines."Approved At" := CurrentDateTime;
                recGenLines."Approved By" := UserId;
                recGenLines.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 110, 'OnBeforeInsertEvent', '', true, true)]
    local procedure SalesShipmentInsertLog(var Rec: Record "Sales Shipment Header")
    begin
        Rec."Posted At" := CurrentDateTime;
        Rec."Posted By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 112, 'OnBeforeInsertEvent', '', true, true)]
    local procedure SalesInvInsertLog(var Rec: Record "Sales Invoice Header")
    begin
        Rec."Posted At" := CurrentDateTime;
        Rec."Posted By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 114, 'OnBeforeInsertEvent', '', true, true)]
    local procedure SalesCrMemoInsertLog(var Rec: Record "Sales Cr.Memo Header")
    begin
        Rec."Posted At" := CurrentDateTime;
        Rec."Posted By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 120, 'OnBeforeInsertEvent', '', true, true)]
    local procedure PurchaseRcptInsertLog(var Rec: Record "Purch. Rcpt. Header")
    begin
        Rec."Posted At" := CurrentDateTime;
        Rec."Posted By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 122, 'OnBeforeInsertEvent', '', true, true)]
    local procedure PurchaseInvInsertLog(var Rec: Record "Purch. Inv. Header")
    begin
        Rec."Posted At" := CurrentDateTime;
        Rec."Posted By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, 124, 'OnBeforeInsertEvent', '', true, true)]
    local procedure PurchaseCrMemoInsertLog(var Rec: Record "Purch. Cr. Memo Hdr.")
    begin
        Rec."Posted At" := CurrentDateTime;
        Rec."Posted By" := UserId;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', true, true)]
    local procedure UpdateUserInfoOnCLE(var CustLedgerEntry: Record "Cust. Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        recSalesHeader: Record "Sales Header";
    begin
        if (GenJournalLine."Source Code" = 'SALES') and (CustLedgerEntry."Document No." <> '***') then begin
            recSalesHeader.Reset();
            recSalesHeader.SetRange("Posting No.", CustLedgerEntry."Document No.");
            if recSalesHeader.FindFirst() then begin
                CustLedgerEntry."Created At" := recSalesHeader."Created At";
                CustLedgerEntry."Created By" := recSalesHeader."Created By";
                CustLedgerEntry."Approved At" := recSalesHeader."Approved At";
                CustLedgerEntry."Approved By" := recSalesHeader."Approved By";
            end;
            recSalesHeader.Reset();
            recSalesHeader.SetRange("Prepayment No.", CustLedgerEntry."Document No.");
            if recSalesHeader.FindFirst() then begin
                CustLedgerEntry."Created At" := recSalesHeader."Created At";
                CustLedgerEntry."Created By" := recSalesHeader."Created By";
                CustLedgerEntry."Approved At" := recSalesHeader."Approved At";
                CustLedgerEntry."Approved By" := recSalesHeader."Approved By";
            end;
        end;
        if GenJournalLine."Source Code" <> 'SALES' then begin
            CustLedgerEntry."Created At" := GenJournalLine."Created At";
            CustLedgerEntry."Created By" := GenJournalLine."Created By";
            CustLedgerEntry."Approved At" := GenJournalLine."Approved At";
            CustLedgerEntry."Approved By" := GenJournalLine."Approved By";
        end;
        CustLedgerEntry."Posted At" := CurrentDateTime;
        CustLedgerEntry."Posted By" := UserId;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeVendLedgEntryInsert', '', true, true)]
    local procedure UpdateUserInfoOnVLE(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        recPurchaseHeader: Record "Purchase Header";
    begin
        if (GenJournalLine."Source Code" = 'PURCHASES') and (VendorLedgerEntry."Document No." <> '***') then begin
            recPurchaseHeader.Reset();
            recPurchaseHeader.SetRange("Posting No.", VendorLedgerEntry."Document No.");
            if recPurchaseHeader.FindFirst() then begin
                VendorLedgerEntry."Created At" := recPurchaseHeader."Created At";
                VendorLedgerEntry."Created By" := recPurchaseHeader."Created By";
                VendorLedgerEntry."Approved At" := recPurchaseHeader."Approved At";
                VendorLedgerEntry."Approved By" := recPurchaseHeader."Approved By";
            end;
            recPurchaseHeader.Reset();
            recPurchaseHeader.SetRange("Prepayment No.", VendorLedgerEntry."Document No.");
            if recPurchaseHeader.FindFirst() then begin
                VendorLedgerEntry."Created At" := recPurchaseHeader."Created At";
                VendorLedgerEntry."Created By" := recPurchaseHeader."Created By";
                VendorLedgerEntry."Approved At" := recPurchaseHeader."Approved At";
                VendorLedgerEntry."Approved By" := recPurchaseHeader."Approved By";
            end;
        end;
        if GenJournalLine."Source Code" <> 'PURCHASES' then begin
            VendorLedgerEntry."Created At" := GenJournalLine."Created At";
            VendorLedgerEntry."Created By" := GenJournalLine."Created By";
            VendorLedgerEntry."Approved At" := GenJournalLine."Approved At";
            VendorLedgerEntry."Approved By" := GenJournalLine."Approved By";
        end;
        VendorLedgerEntry."Posted At" := CurrentDateTime;
        VendorLedgerEntry."Posted By" := UserId;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostBankAccOnBeforeBankAccLedgEntryInsert', '', true, true)]
    local procedure UpdateUserInfoOnBLE(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        BankAccountLedgerEntry."Created At" := GenJournalLine."Created At";
        BankAccountLedgerEntry."Created By" := GenJournalLine."Created By";
        BankAccountLedgerEntry."Approved At" := GenJournalLine."Approved At";
        BankAccountLedgerEntry."Approved By" := GenJournalLine."Approved By";
        BankAccountLedgerEntry."Posted At" := CurrentDateTime;
        BankAccountLedgerEntry."Posted By" := UserId;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGlobalGLEntry', '', true, true)]
    local procedure UpdateUserInfoOnGLE(var GlobalGLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        recPurchaseHeader: Record "Purchase Header";
        recSalesHeader: Record "Sales Header";
    begin
        if (GenJournalLine."Source Code" = 'SALES') and (GlobalGLEntry."Document No." <> '***') then begin
            recSalesHeader.Reset();
            recSalesHeader.SetRange("Posting No.", GlobalGLEntry."Document No.");
            if recSalesHeader.FindFirst() then begin
                GlobalGLEntry."Created At" := recSalesHeader."Created At";
                GlobalGLEntry."Created By" := recSalesHeader."Created By";
                GlobalGLEntry."Approved At" := recSalesHeader."Approved At";
                GlobalGLEntry."Approved By" := recSalesHeader."Approved By";
            end;
            recSalesHeader.Reset();
            recSalesHeader.SetRange("Prepayment No.", GlobalGLEntry."Document No.");
            if recSalesHeader.FindFirst() then begin
                GlobalGLEntry."Created At" := recSalesHeader."Created At";
                GlobalGLEntry."Created By" := recSalesHeader."Created By";
                GlobalGLEntry."Approved At" := recSalesHeader."Approved At";
                GlobalGLEntry."Approved By" := recSalesHeader."Approved By";
            end;
        end;
        if (GenJournalLine."Source Code" = 'PURCHASES') and (GlobalGLEntry."Document No." <> '***') then begin
            recPurchaseHeader.Reset();
            recPurchaseHeader.SetRange("Posting No.", GlobalGLEntry."Document No.");
            if recPurchaseHeader.FindFirst() then begin
                GlobalGLEntry."Created At" := recPurchaseHeader."Created At";
                GlobalGLEntry."Created By" := recPurchaseHeader."Created By";
                GlobalGLEntry."Approved At" := recPurchaseHeader."Approved At";
                GlobalGLEntry."Approved By" := recPurchaseHeader."Approved By";
            end;
            recPurchaseHeader.Reset();
            recPurchaseHeader.SetRange("Prepayment No.", GlobalGLEntry."Document No.");
            if recPurchaseHeader.FindFirst() then begin
                GlobalGLEntry."Created At" := recPurchaseHeader."Created At";
                GlobalGLEntry."Created By" := recPurchaseHeader."Created By";
                GlobalGLEntry."Approved At" := recPurchaseHeader."Approved At";
                GlobalGLEntry."Approved By" := recPurchaseHeader."Approved By";
            end;
        end;
        if GenJournalLine."Source Code" = 'INVTPCOST' then begin
            recPurchaseHeader.Reset();
            recPurchaseHeader.SetRange("Posting No.", GlobalGLEntry."Document No.");
            if recPurchaseHeader.FindFirst() then begin
                GlobalGLEntry."Created At" := recPurchaseHeader."Created At";
                GlobalGLEntry."Created By" := recPurchaseHeader."Created By";
                GlobalGLEntry."Approved At" := recPurchaseHeader."Approved At";
                GlobalGLEntry."Approved By" := recPurchaseHeader."Approved By";
            end;
            recSalesHeader.Reset();
            recSalesHeader.SetRange("Posting No.", GlobalGLEntry."Document No.");
            if recSalesHeader.FindFirst() then begin
                GlobalGLEntry."Created At" := recSalesHeader."Created At";
                GlobalGLEntry."Created By" := recSalesHeader."Created By";
                GlobalGLEntry."Approved At" := recSalesHeader."Approved At";
                GlobalGLEntry."Approved By" := recSalesHeader."Approved By";
            end;
        end;
        if not (GenJournalLine."Source Code" in ['SALES', 'PURCHASES', 'INVTPCOST']) then begin
            GlobalGLEntry."Created At" := GenJournalLine."Created At";
            GlobalGLEntry."Created By" := GenJournalLine."Created By";
            GlobalGLEntry."Approved At" := GenJournalLine."Approved At";
            GlobalGLEntry."Approved By" := GenJournalLine."Approved By";
        end;
        GlobalGLEntry."Posted At" := CurrentDateTime;
        GlobalGLEntry."Posted By" := UserId;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostEmployeeOnBeforeEmployeeLedgerEntryInsert', '', true, true)]
    local procedure UpdateUserInfoOnELE(var EmployeeLedgerEntry: Record "Employee Ledger Entry"; var GenJnlLine: Record "Gen. Journal Line")
    begin
        EmployeeLedgerEntry."Created At" := GenJnlLine."Created At";
        EmployeeLedgerEntry."Created By" := GenJnlLine."Created By";
        EmployeeLedgerEntry."Approved At" := GenJnlLine."Approved At";
        EmployeeLedgerEntry."Approved By" := GenJnlLine."Approved By";
        EmployeeLedgerEntry."Posted At" := CurrentDateTime;
        EmployeeLedgerEntry."Posted By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, Database::"FA Ledger Entry", 'OnAfterInsertEvent', '', true, true)]
    local procedure UpdateUserInfoOnFALE(var Rec: Record "FA Ledger Entry")
    var
        recGLEntry: Record "G/L Entry";
    begin
        if recGLEntry.Get(Rec."G/L Entry No.") then begin
            Rec."Created At" := recGLEntry."Created At";
            Rec."Created By" := recGLEntry."Created By";
            Rec."Approved At" := recGLEntry."Approved At";
            Rec."Approved By" := recGLEntry."Approved By";
            Rec."Posted At" := CurrentDateTime;
            Rec."Posted By" := UserId;
            Rec.Modify();
        end;
    end;

    var
}