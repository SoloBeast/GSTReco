page 50013 "Contra Voucher Iappc"
{
    ApplicationArea = Basic, Suite;
    AutoSplitKey = true;
    Caption = 'Contra Voucher';
    DelayedInsert = true;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Bank,Application,Payroll,Approve,Page,Post/Print,Line,Account';
    SaveValues = true;
    SourceTable = "Gen. Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Control120)
            {
                ShowCaption = false;

                field("Current Jnl Batch Name"; CurrentJnlBatchName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Batch Name';
                    Lookup = true;
                    ToolTip = 'Specifies the name of the journal batch.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CurrPage.SaveRecord();
                        GenJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                        SetControlAppearanceFromBatch();
                        SetDataForSimpleModeOnBatchChange();
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    begin
                        GenJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                        CurrentJnlBatchNameOnAfterVali();
                        SetDataForSimpleModeOnBatchChange();
                    end;
                }
                field("<Document No. Simple Page>"; CurrentDocNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies a document number for the journal line.';
                    Visible = IsSimplePage;

                    trigger OnValidate()
                    begin
                        if not IsSimplePage then
                            exit;
                        if CurrentDocNo = '' then
                            CurrentDocNo := Rec."Document No.";
                        if CurrentDocNo = Rec."Document No." then
                            exit;

                        if Rec.Count() = 0 then
                            Rec."Document No." := CurrentDocNo;

                        IsChangingDocNo := true;
                        SetDocumentNumberFilter(CurrentDocNo);
                        CurrPage.Update(false);
                    end;
                }
                field("<CurrentPostingDate>"; CurrentPostingDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posting Date';
                    ClosingDates = true;
                    ToolTip = 'Specifies the entry''s posting date.';
                    Visible = IsSimplePage;

                    trigger OnValidate()
                    begin
                        UpdateCurrencyFactor(Rec.FieldNo("Posting Date"));
                    end;
                }
                field("<CurrentCurrencyCode>"; CurrentCurrencyCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Currency Code';
                    TableRelation = Currency.Code;
                    ToolTip = 'Specifies the code of the currency for the amounts on the Voucher line.';
                    Visible = IsSimplePage;

                    trigger OnValidate()
                    begin
                        CheckCurrencyCode(CurrentCurrencyCode);
                        UpdateCurrencyFactor(Rec.FieldNo("Currency Code"));
                    end;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the entry''s posting date.';
                    Visible = not IsSimplePage;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the type of document that the entry on the journal line is.';
                    Visible = not IsSimplePage;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a document number for the journal line.';
                    Visible = not IsSimplePage;
                }
                field("Transaction Nature"; Rec."Transaction Nature")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the type of account that the entry on the journal line will be posted to.';
                    Visible = not IsSimplePage;

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        SetUserInteractions();
                        EnableApplyEntriesAction();
                        CurrPage.SaveRecord();
                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the account number that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        SetUserInteractions();
                        if IsSimplePage then
                            Rec.Validate("Currency Code", CurrentCurrencyCode);
                        CurrPage.SaveRecord();
                    end;
                }
                field(AccountName; AccName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Account Name';
                    Editable = false;
                    ToolTip = 'Specifies the account name that the entry on the journal line will be posted to.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total amount in local currency (including VAT) that the journal line consists of.';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total amount (including VAT) that the journal line consists of, if it is a debit amount.';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total amount (including VAT) that the journal line consists of, if it is a credit amount.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the code for the balancing account type that should be used in this journal line.';
                    Visible = not IsSimplePage;

                    trigger OnValidate()
                    begin
                        EnableApplyEntriesAction();
                    end;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the number of the general ledger, customer, vendor, or bank account to which a balancing entry for the journal line will posted (for example, a cash account for cash purchases).';
                    Visible = not IsSimplePage;

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("UTR No."; Rec."UTR No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);

                        VoucherFunctions.OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 3);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);

                        VoucherFunctions.OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 4);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);

                        VoucherFunctions.OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 5);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);

                        VoucherFunctions.OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 6);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);

                        VoucherFunctions.OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 7);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);

                        VoucherFunctions.OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 8);
                    end;
                }
            }
            group(Control30)
            {
                ShowCaption = false;

                fixed(Control1901776101)
                {
                    ShowCaption = false;

                    group("Number of Lines")
                    {
                        Caption = 'Number of Lines';

                        field(NumberOfJournalRecords; Rec.Count())
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            ShowCaption = false;
                            Editable = false;
                            ToolTip = 'Specifies the number of lines in the current journal batch.';
                        }
                    }
                    group("Account Name")
                    {
                        Caption = 'Account Name';

                        field(AccName1; AccName)
                        {
                            ApplicationArea = Basic, Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies the name of the account.';
                        }
                    }
                    group("Bal. Account Name")
                    {
                        Caption = 'Bal. Account Name';
                        Visible = not IsSimplePage;

                        field(BalAccName1; BalAccName)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bal. Account Name';
                            Editable = false;
                            ToolTip = 'Specifies the name of the balancing account that has been entered on the journal line.';
                        }
                    }
                    group("Total Debit")
                    {
                        Caption = 'Total Debit';
                        Visible = IsSimplePage;

                        field(DisplayTotalDebit; GetTotalDebitAmt())
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Total Debit';
                            Editable = false;
                            ToolTip = 'Specifies the total debit amount in the general journal.';
                        }
                    }
                    group("Total Credit")
                    {
                        Caption = 'Total Credit';
                        Visible = IsSimplePage;

                        field(DisplayTotalCredit; GetTotalCreditAmt())
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Total Credit';
                            Editable = false;
                            ToolTip = 'Specifies the total credit amount in the general journal.';
                        }
                    }
                    group(Control1902759701)
                    {
                        Caption = 'Balance';

                        field(Balance1; Balance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            ToolTip = 'Specifies the balance that has accumulated in the general journal on the line where the cursor is.';
                            Visible = BalanceVisible;
                        }
                    }
                    group("Total Balance")
                    {
                        Caption = 'Total Balance';

                        field(TotalBalance1; TotalBalance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatType = 1;
                            Caption = 'Total Balance';
                            Editable = false;
                            ToolTip = 'Specifies the total balance in the general journal.';
                            Visible = TotalBalanceVisible;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(TaxInformation; "Tax Information Factbox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Table ID Filter" = const(81), "Template Name Filter" = field("Journal Template Name"), "Batch Name Filter" = field("Journal Batch Name"), "Line No. Filter" = field("Line No.");
            }
            part(Control1900919607; "Dimension Set Entries FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Dimension Set ID" = field("Dimension Set ID");
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
            }
            part(WorkflowStatusBatch; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Caption = 'Batch Workflows';
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatusOnBatch;
            }
            part(WorkflowStatusLine; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Caption = 'Line Workflows';
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatusOnLine;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;

                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category10;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                        CurrPage.SaveRecord();
                    end;
                }
                action(FileImport)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Voucher Import';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        xmlVoucherImport: XmlPort "Voucher Import";
                    begin
                        Clear(xmlVoucherImport);
                        xmlVoucherImport.SetTemplateBatch(Rec."Journal Template Name", Rec."Journal Batch Name");
                        xmlVoucherImport.Run();
                        CurrPage.Update();
                    end;
                }
                action("Voucher Narration")
                {
                    PromotedOnly = true;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Voucher Narration';
                    Image = LineDescription;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Select this option to enter narration for the voucher.';

                    trigger OnAction()
                    var
                        GenNarration: Record "Gen. Journal Narration";
                        VoucherNarration: Page "Voucher Narration";
                    begin
                        GenNarration.Reset();
                        GenNarration.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenNarration.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        GenNarration.SetRange("Document No.", Rec."Document No.");
                        GenNarration.SetFilter("Gen. Journal Line No.", '%1', 0);
                        VoucherNarration.SetTableView(GenNarration);
                        VoucherNarration.RunModal();

                        // ShowOldNarration();
                        VoucherFunctions.ShowOldNarration(Rec);
                        CurrPage.Update(true);
                    end;
                }
            }
            group("A&ccount")
            {
                Caption = 'A&ccount';
                Image = ChartOfAccounts;

                action(Card)
                {
                    PromotedOnly = true;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category11;
                    RunObject = Codeunit "Gen. Jnl.-Show Card";
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record on the document or journal line.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Category11;
                    RunObject = Codeunit "Gen. Jnl.-Show Entries";
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
            action(Approvals)
            {
                PromotedOnly = true;
                AccessByPermission = TableData "Approval Entry" = R;
                ApplicationArea = Suite;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category10;
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    GetCurrentlySelectedLines(GenJournalLine);
                    ApprovalsMgmt.ShowJournalApprovalEntries(GenJournalLine);
                end;
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";

                action("Renumber Document Numbers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Renumber Document Numbers';
                    Image = EditLines;
                    ToolTip = 'Resort the numbers in the Document No. column to avoid posting errors because the document numbers are not in sequence. Entry applications and line groupings are preserved.';
                    Visible = not IsSimplePage;

                    trigger OnAction()
                    begin
                        Rec.RenumberDocumentNo()
                    end;
                }
                separator("-")
                {
                    Caption = '-';
                }
                action(Post)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Gen. Jnl.-Post", Rec);
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        if IsSimplePage then
                            if GeneralLedgerSetup."Post with Job Queue" then
                                NewDocumentNo()
                            else
                                SetDataForSimpleModeOnPost();
                        SetJobQueueVisibility();
                        CurrPage.Update(false);
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    Promoted = true;
                    PromotedCategory = Category9;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    var
                        GenJnlPost: Codeunit "Gen. Jnl.-Post";
                    begin
                        GenJnlPost.Preview(Rec);
                    end;
                }
                action(TestReport)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Test Report';
                    Image = TestReport;
                    Promoted = true;
                    PromotedCategory = Report;

                    trigger OnAction()
                    var
                        rptTestReport: Report "Voucher Test Report";

                    begin
                        Clear(rptTestReport);
                        rptTestReport.SetDocumentDetails('CT', Rec."Document No.", Rec."Journal Template Name", Rec."Journal Batch Name");
                        rptTestReport.Run();
                    end;
                }
                action(PostAndPrint)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Gen. Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        if GeneralLedgerSetup."Post & Print with Job Queue" then
                            NewDocumentNo()
                        else
                            SetDataForSimpleModeOnPost();
                        SetJobQueueVisibility();
                        CurrPage.Update(false);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';

                group(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;

                    action(SendApprovalRequestJournalBatch)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Journal Batch';
                        Enabled = not OpenApprovalEntriesOnBatchOrAnyJnlLineExist and CanRequestFlowApprovalForBatchAndAllLines;
                        Image = SendApprovalRequest;
                        ToolTip = 'Send all journal lines for approval, also those that you may not see because of filters.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.TrySendJournalBatchApprovalRequest(Rec);
                            SetControlAppearanceFromBatch();
                            SetControlAppearance();
                        end;
                    }
                    action(SendApprovalRequestJournalLine)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Selected Journal Lines';
                        Enabled = not OpenApprovalEntriesOnBatchOrCurrJnlLineExist and CanRequestFlowApprovalForBatchAndCurrentLine;
                        Image = SendApprovalRequest;
                        ToolTip = 'Send selected journal lines for approval.';

                        trigger OnAction()
                        var
                            GenJournalLine: Record "Gen. Journal Line";
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            GetCurrentlySelectedLines(GenJournalLine);
                            ApprovalsMgmt.TrySendJournalLineApprovalRequests(GenJournalLine);
                            SetControlAppearanceFromBatch();
                        end;
                    }
                }
                group(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;

                    action(CancelApprovalRequestJournalBatch)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Journal Batch';
                        Enabled = CanCancelApprovalForJnlBatch or CanCancelFlowApprovalForBatch;
                        Image = CancelApprovalRequest;
                        ToolTip = 'Cancel sending all journal lines for approval, also those that you may not see because of filters.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.TryCancelJournalBatchApprovalRequest(Rec);
                            SetControlAppearance();
                            SetControlAppearanceFromBatch();
                        end;
                    }
                    action(CancelApprovalRequestJournalLine)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Selected Journal Lines';
                        Enabled = CanCancelApprovalForJnlLine or CanCancelFlowApprovalForLine;
                        Image = CancelApprovalRequest;
                        ToolTip = 'Cancel sending selected journal lines for approval.';

                        trigger OnAction()
                        var
                            GenJournalLine: Record "Gen. Journal Line";
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            GetCurrentlySelectedLines(GenJournalLine);
                            ApprovalsMgmt.TryCancelJournalLineApprovalRequests(GenJournalLine);
                        end;
                    }
                }
                action(CreateFlow)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create a Flow';
                    Image = Flow;
                    ToolTip = 'Create a new Flow from a list of relevant Flow templates.';
                    Visible = IsSaaS;

                    trigger OnAction()
                    var
                        FlowServiceManagement: Codeunit "Flow Service Management";
                        FlowTemplateSelector: Page "Flow Template Selector";
                    begin
                        // Opens page 6400 where the user can use filtered templates to create new flows.
                        FlowTemplateSelector.SetSearchText(FlowServiceManagement.GetJournalTemplateFilter());
                        FlowTemplateSelector.Run();
                    end;
                }
                action(SeeFlows)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'See my Flows';
                    Image = Flow;
                    RunObject = Page "Flow Selector";
                    ToolTip = 'View and configure Flows that you created.';
                }
            }
            group(Approval)
            {
                Caption = 'Approval';

                action(Approve)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveGenJournalLineRequest(Rec);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectGenJournalLineRequest(Rec);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedOnly = true;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateGenJournalLineRequest(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        ClientTypeManagement: Codeunit "Client Type Management";
    begin
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
        if ClientTypeManagement.GetCurrentClientType() <> ClientType::ODataV4 then
            UpdateBalance();
        EnableApplyEntriesAction();
        SetControlAppearance();
        // PostedFromSimplePage is set to TRUE when 'POST' / 'POST+PRINT' action is executed in simple page mode.
        // It gets set to FALSE when OnNewRecord is called in the simple mode.
        // After posting we try to find the first record and filter on its document number
        // Executing LoaddataFromRecord for incomingDocAttachFactbox is also forcing this (PAG39) page to update
        // and for some reason after posting this page doesn't refresh with the filter set by POST / POST-PRINT action in simple mode.
        // To resolve this only call LoaddataFromRecord if PostedFromSimplePage is FALSE.
        if not PostedFromSimplePage then
            CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
        SetJobQueueVisibility();
    end;

    trigger OnAfterGetRecord()
    begin
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        CurrPage.IncomingDocAttachFactBox.Page.SetCurrentRecordID(Rec.RecordId());
        SetUserInteractions();
        VoucherFunctions.ShowOldNarration(Rec);
        // ShowOldNarration();
    end;

    trigger OnInit()
    var
        ClientTypeManagementL: Codeunit "Client Type Management";
    begin
        TotalBalanceVisible := true;
        BalanceVisible := true;
        AmountVisible := true;
        if ClientTypeManagementL.GetCurrentClientType() in [ClientType::SOAP, ClientType::OData, ClientType::ODataV4]
        then
            IsSimplePage := false
        else
            IsSimplePage := GenJnlManagement.GetJournalSimplePageModePreference(Page::"Contra Voucher");

        GeneralLedgerSetup.Get();
        SetJobQueueVisibility();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage.IncomingDocAttachFactBox.Page.SetCurrentRecordID(Rec.RecordId());
    end;

    trigger OnModifyRecord(): Boolean
    begin
        SetUserInteractions();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateBalance();
        EnableApplyEntriesAction();
        Rec.SetUpNewLine(xRec, Balance, BelowxRec);
        if IsSimplePage then begin
            PostedFromSimplePage := false;
            SetDataForSimpleModeOnNewRecord();
        end;
        Clear(ShortcutDimCode);
        Clear(AccName);
        SetUserInteractions();
    end;

    trigger OnOpenPage()
    var
        ServerSetting: Codeunit "Server Setting";
        EnvironmentInfo: Codeunit "Environment Information";
        ClientTypeManagement: Codeunit "Client Type Management";
        JnlSelected: Boolean;
        LastGenJnlBatch: Code[10];
        VoucherEnum: Enum "Gen. Journal Template Type";
    begin
        NarrationText := '';
        IsSaasExcelAddinEnabled := ServerSetting.GetIsSaasExcelAddinEnabled();
        if ClientTypeManagement.GetCurrentClientType() = ClientType::ODataV4 then
            exit;

        BalAccName := '';
        SetControlVisibility();
        SetDimensionVisibility();
        if Rec.IsOpenedFromBatch() then begin
            CurrentJnlBatchName := Rec."Journal Batch Name";
            GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            SetControlAppearanceFromBatch();
            SetDataForSimpleModeOnOpen();
            exit;
        end;
        VoucherFunctions.VoucherTemplateSelection(Page::"Contra Voucher", VoucherEnum::"Contra Voucher", false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');

        LastGenJnlBatch := GenJnlManagement.GetLastViewedJournalBatchName(Page::"Contra Voucher");
        if LastGenJnlBatch <> '' then
            CurrentJnlBatchName := LastGenJnlBatch;
        GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
        SetControlAppearanceFromBatch();

        IsSaaS := EnvironmentInfo.IsSaaS();
        SetDataForSimpleModeOnOpen();
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJnlManagement: Codeunit GenJnlManagement;
        VoucherFunctions: Codeunit "Voucher Functions";
        CurrentJnlBatchName: Code[10];
        AccName: Text[100];
        BalAccName: Text[100];
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        HasIncomingDocument: Boolean;
        ApplyEntriesActionEnabled: Boolean;
        [InDataSet]
        BalanceVisible: Boolean;
        [InDataSet]
        TotalBalanceVisible: Boolean;
        StyleTxt: Text;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesOnJnlBatchExist: Boolean;
        OpenApprovalEntriesOnJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrAnyJnlLineExist: Boolean;
        ShowWorkflowStatusOnBatch: Boolean;
        ShowWorkflowStatusOnLine: Boolean;
        CanCancelApprovalForJnlBatch: Boolean;
        CanCancelApprovalForJnlLine: Boolean;
        IsSaasExcelAddinEnabled: Boolean;
        CanRequestFlowApprovalForBatch: Boolean;
        CanRequestFlowApprovalForBatchAndAllLines: Boolean;
        CanRequestFlowApprovalForBatchAndCurrentLine: Boolean;
        CanCancelFlowApprovalForBatch: Boolean;
        CanCancelFlowApprovalForLine: Boolean;
        AmountVisible: Boolean;
        DebitCreditVisible: Boolean;
        IsSaaS: Boolean;
        IsSimplePage: Boolean;
        JobQueuesUsed: Boolean;
        JobQueueVisible: Boolean;
        CurrentDocNo: Code[20];
        CurrentPostingDate: Date;
        CurrentCurrencyCode: Code[10];
        IsChangingDocNo: Boolean;
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;
        PostedFromSimplePage: Boolean;
        NarrationText: Text[2000];
        GeneralJournalInsertedMsg: Label 'General Journal lines have been successfully inserted from Standard General Journal %1.', Comment = '%1= StandardGeneralJournal.Code';
        GeneralJournalCreatedMsg: Label 'Standard General Journal %1 has been successfully created.', Comment = '%1= StandardGeneralJournal.Code';
        MissingExchangeRatesQst: Label 'There are no exchange rates for currency %1 and date %2. Do you want to add them now? Otherwise, the last change you made will be reverted.', Comment = '%1 - currency code, %2 - posting date';

    procedure CheckCurrencyCode(CurrencyCode: Code[10])
    var
        Currency: Record Currency;
    begin
        Currency.Get(CurrencyCode);
    end;

    procedure SetUserInteractions()
    begin
        StyleTxt := Rec.GetStyle();
    end;

    procedure NewDocumentNo()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LastDocNo: Code[20];
    begin
        if Rec.Count() = 0 then
            exit;
        GenJnlBatch.Get(Rec."Journal Template Name", CurrentJnlBatchName);
        GenJournalLine.Reset();
        GenJournalLine.SetCurrentKey("Document No.");
        GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if GenJournalLine.FindLast() then begin
            LastDocNo := GenJournalLine."Document No.";
            Rec.IncrementDocumentNo(GenJnlBatch, LastDocNo);
        end else
            LastDocNo := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series", Rec."Posting Date");

        CurrentDocNo := LastDocNo;
        SetDocumentNumberFilter(CurrentDocNo);
    end;

    local procedure UpdateBalance()
    begin
        GenJnlManagement.CalcBalance(Rec, xRec, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
    end;

    local procedure EnableApplyEntriesAction()
    begin
        ApplyEntriesActionEnabled :=
          (Rec."Account Type" in [Rec."Account Type"::Customer, Rec."Account Type"::Vendor, Rec."Account Type"::Employee]) or
          (Rec."Bal. Account Type" in [Rec."Bal. Account Type"::Customer, Rec."Bal. Account Type"::Vendor, Rec."Bal. Account Type"::Employee]);
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord();
        GenJnlManagement.SetName(CurrentJnlBatchName, Rec);
        SetControlAppearanceFromBatch();
        CurrPage.Update(false);
    end;

    local procedure GetCurrentlySelectedLines(var GenJournalLine: Record "Gen. Journal Line"): Boolean
    begin
        CurrPage.SetSelectionFilter(GenJournalLine);
        exit(GenJournalLine.FindSet());
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
        CanRequestFlowApprovalForLine: Boolean;
    begin
        OpenApprovalEntriesExistForCurrUser :=
          OpenApprovalEntriesExistForCurrUser or
          ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId());

        OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId());
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist or OpenApprovalEntriesOnJnlLineExist;

        ShowWorkflowStatusOnLine := CurrPage.WorkflowStatusLine.Page.SetFilterOnWorkflowRecord(Rec.RecordId());

        CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId());

        VoucherFunctions.SetPayrollAppearance();

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId(), CanRequestFlowApprovalForLine, CanCancelFlowApprovalForLine);
        CanRequestFlowApprovalForBatchAndCurrentLine := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForLine;
    end;

    local procedure IterateDocNumbers(FindTxt: Text; NextNum: Integer)
    var
        GenJournalLine: Record "Gen. Journal Line";
        CurrentDocNoWasFound: Boolean;
        NoLines: Boolean;
    begin
        if Rec.Count() = 0 then
            NoLines := true;
        GenJournalLine.Reset();
        GenJournalLine.SetCurrentKey("Document No.", "Line No.");
        GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if GenJournalLine.Find(FindTxt) then
            repeat
                if NoLines then begin
                    SetDataForSimpleMode(GenJournalLine);
                    exit;
                end;
                // Find the rec for current doc no.
                if not CurrentDocNoWasFound and (GenJournalLine."Document No." = CurrentDocNo) then
                    CurrentDocNoWasFound := true;
                if CurrentDocNoWasFound and (GenJournalLine."Document No." <> CurrentDocNo) then begin
                    SetDataForSimpleMode(GenJournalLine);
                    exit;
                end;
            until GenJournalLine.Next(NextNum) = 0;
    end;

    local procedure SetControlAppearanceFromBatch()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
        CanRequestFlowApprovalForAllLines: Boolean;
    begin
        if (Rec."Journal Template Name" <> '') and (Rec."Journal Batch Name" <> '') then
            GenJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name")
        else
            if not GenJournalBatch.Get(Rec.GetRangeMax("Journal Template Name"), CurrentJnlBatchName) then
                exit;

        ShowWorkflowStatusOnBatch := CurrPage.WorkflowStatusBatch.Page.SetFilterOnWorkflowRecord(GenJournalBatch.RecordId());
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(GenJournalBatch.RecordId());
        OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(GenJournalBatch.RecordId());

        OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
          OpenApprovalEntriesOnJnlBatchExist or
          ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries(Rec."Journal Template Name", Rec."Journal Batch Name");

        CanCancelApprovalForJnlBatch := ApprovalsMgmt.CanCancelApprovalForRecord(GenJournalBatch.RecordId());

        WorkflowWebhookManagement.GetCanRequestAndCanCancelJournalBatch(
          GenJournalBatch, CanRequestFlowApprovalForBatch, CanCancelFlowApprovalForBatch, CanRequestFlowApprovalForAllLines);
        CanRequestFlowApprovalForBatchAndAllLines := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForAllLines;
    end;

    local procedure SetControlVisibility()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        if IsSimplePage then begin
            AmountVisible := false;
            DebitCreditVisible := true;
        end else begin
            AmountVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
            DebitCreditVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
        end;
    end;

    local procedure SetDocumentNumberFilter(DocNoToSet: Code[20])
    var
        OriginalFilterGroup: Integer;
    begin
        OriginalFilterGroup := Rec.FilterGroup();
        Rec.FilterGroup := 25;
        Rec.SetFilter("Document No.", DocNoToSet);
        Rec.FilterGroup := OriginalFilterGroup;
    end;

    local procedure SetDimensionVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        if not IsSimplePage then
            DimMgt.UseShortcutDims(
              DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimMgt);
    end;

    local procedure GetTotalDebitAmt(): Decimal
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        if IsSimplePage then begin
            GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
            GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            GenJournalLine.SetRange("Document No.", CurrentDocNo);
            GenJournalLine.CalcSums("Debit Amount");
            exit(GenJournalLine."Debit Amount");
        end
    end;

    local procedure GetTotalCreditAmt(): Decimal
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        if IsSimplePage then begin
            GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
            GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            GenJournalLine.SetRange("Document No.", CurrentDocNo);
            GenJournalLine.CalcSums("Credit Amount");
            exit(GenJournalLine."Credit Amount");
        end
    end;

    local procedure SetDataForSimpleMode(GenJournalLine1: Record "Gen. Journal Line")
    begin
        CurrentDocNo := GenJournalLine1."Document No.";
        CurrentPostingDate := GenJournalLine1."Posting Date";
        CurrentCurrencyCode := GenJournalLine1."Currency Code";
        SetDocumentNumberFilter(CurrentDocNo);
    end;

    local procedure SetDataForSimpleModeOnOpen()
    begin
        if IsSimplePage then begin
            Rec.SetCurrentKey("Document No.", "Line No.");
            if Rec.FindFirst() then
                SetDataForSimpleMode(Rec)
            else begin
                CurrentPostingDate := WorkDate();
                Clear(CurrentCurrencyCode);
            end;
        end;
    end;

    local procedure SetDataForSimpleModeOnBatchChange()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJnlManagement.SetLastViewedJournalBatchName(Page::"Contra Voucher", CurrentJnlBatchName);
        if IsSimplePage then begin
            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
            GenJournalLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
            IsChangingDocNo := false;
            if GenJournalLine.FindFirst() then
                SetDataForSimpleMode(GenJournalLine);
        end;
    end;

    local procedure SetDataForSimpleModeOnNewRecord()
    begin
        if Rec.Count() = 0 then
            if ((xRec."Document No." = '') or (xRec."Journal Batch Name" <> Rec."Journal Batch Name")) and (not IsChangingDocNo) then
                CurrentDocNo := Rec."Document No."
            else begin
                Rec."Document No." := CurrentDocNo;
                Rec.Validate("Credit Amount", 0);
                Rec.Validate("Debit Amount", 0);
            end
        else
            Rec."Document No." := CurrentDocNo;

        Rec."Currency Code" := CurrentCurrencyCode;
        if CurrentPostingDate <> 0D then
            Rec.Validate("Posting Date", CurrentPostingDate);
    end;

    local procedure SetDataForSimpleModeOnPropValidation(FiledNumber: Integer)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        if IsSimplePage and (Rec.Count() > 0) then begin
            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
            GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            GenJournalLine.SetRange("Document No.", CurrentDocNo);
            if GenJournalLine.Find('-') then
                repeat
                    case FiledNumber of
                        GenJournalLine.FieldNo("Currency Code"):
                            GenJournalLine.Validate("Currency Code", CurrentCurrencyCode);
                        GenJournalLine.FieldNo("Posting Date"):
                            GenJournalLine.Validate("Posting Date", CurrentPostingDate);
                    end;
                    GenJournalLine.Modify();
                until GenJournalLine.Next() = 0;
        end;
        CurrPage.Update(false);
    end;

    local procedure SetDataForSimpleModeOnPost()
    begin
        PostedFromSimplePage := true;
        Rec.SetCurrentKey("Document No.", "Line No.");
        if Rec.FindFirst() then
            SetDataForSimpleMode(Rec)
    end;

    local procedure UpdateCurrencyFactor(FieldNo: Integer)
    var
        UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if CurrentCurrencyCode <> '' then
            if UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrentPostingDate, CurrentCurrencyCode) then
                SetDataForSimpleModeOnPropValidation(FieldNo)
            else
                if ConfirmManagement.GetResponseOrDefault(
                     StrSubstNo(MissingExchangeRatesQst, CurrentCurrencyCode, CurrentPostingDate), true)
                then begin
                    UpdateCurrencyExchangeRates.OpenExchangeRatesPage(CurrentCurrencyCode);
                    UpdateCurrencyFactor(FieldNo);
                end else begin
                    CurrentCurrencyCode := Rec."Currency Code";
                    CurrentPostingDate := Rec."Posting Date";
                end
        else
            SetDataForSimpleModeOnPropValidation(FieldNo);
    end;

    local procedure SetJobQueueVisibility()
    begin
        JobQueueVisible := Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting";
        JobQueuesUsed := GeneralLedgerSetup.JobQueueActive();
    end;
}