page 50195 Iappc_Admin_Role_Center2
{
    PageType = RoleCenter;
    Caption = 'Role Center';
    RefreshOnActivate = true;

    layout
    {
        area(RoleCenter)
        {
            part(Sales; "Sales Process")
            {
                ApplicationArea = all;
            }
            part(Purchase; "Purchase Process")
            {
                ApplicationArea = all;
            }
            part(Finance; "Finance Process")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        area(Sections)
        {
            group(Configuration)
            {
                Caption = 'Configuration';
                group(General)
                {
                    Caption = 'General';
                    action(CompanyInfo)
                    {
                        Caption = 'Company Information';
                        ApplicationArea = all;
                        RunObject = page "Company Information";
                    }
                    action(CountryRegion)
                    {
                        Caption = 'Country / Regions';
                        ApplicationArea = all;
                        RunObject = page "Countries/Regions";
                    }
                    action(Dimensions)
                    {
                        Caption = 'Dimensions';
                        ApplicationArea = all;
                        RunObject = page Dimensions;
                    }
                    action(GLSetup)
                    {
                        Caption = 'General Ledger Setup';
                        ApplicationArea = all;
                        RunObject = page "General Ledger Setup";
                    }
                    action(AccountingPeriod)
                    {
                        Caption = 'Accounting Periods';
                        ApplicationArea = all;
                        RunObject = page "Accounting Periods";
                    }
                    action(Location)
                    {
                        Caption = 'Locations';
                        ApplicationArea = all;
                        RunObject = page "Location List";
                    }
                    action(NoSeries)
                    {
                        Caption = 'No. Series';
                        ApplicationArea = all;
                        RunObject = page "No. Series";
                    }
                    action(PostingNoSeries)
                    {
                        Caption = 'Posting No. Series';
                        ApplicationArea = all;
                        RunObject = page "Posting No. Series Setup";
                    }
                }
                group(PostingGroups)
                {
                    Caption = 'Posting Groups';
                    action(BusinessGroup)
                    {
                        Caption = 'Gen. Business Group';
                        ApplicationArea = all;
                        RunObject = page "Gen. Business Posting Groups";
                    }
                    action(ProductGroup)
                    {
                        Caption = 'Gen. Product Group';
                        ApplicationArea = all;
                        RunObject = page "Gen. Product Posting Groups";
                    }
                    action(GeneralSetup)
                    {
                        Caption = 'General Posting Setup';
                        ApplicationArea = all;
                        RunObject = page "General Posting Setup";
                    }
                    action(InventoryPostingGroup)
                    {
                        Caption = 'Inventory Posting Groups';
                        ApplicationArea = all;
                        RunObject = page "Inventory Posting Groups";
                    }
                    action(InventoryPostingSetup)
                    {
                        Caption = 'Inventory Posting Setup';
                        ApplicationArea = all;
                        RunObject = page "Inventory Posting Setup";
                    }
                    action(CustomerGroup)
                    {
                        Caption = 'Customer Posting Group';
                        ApplicationArea = all;
                        RunObject = page "Customer Posting Groups";
                    }
                    action(VendorGroup)
                    {
                        Caption = 'Vendor Posting Group';
                        ApplicationArea = all;
                        RunObject = page "Vendor Posting Groups";
                    }
                    action(BankGroup)
                    {
                        Caption = 'Bank A/c Posting Group';
                        ApplicationArea = all;
                        RunObject = page "Bank Account Posting Groups";
                    }
                    action(FAGroup)
                    {
                        Caption = 'Fixed Asset Group';
                        ApplicationArea = all;
                        RunObject = page "FA Posting Groups";
                    }
                    action(Employees)
                    {
                        Caption = 'Employee Posting Group';
                        ApplicationArea = all;
                        RunObject = page "Employee Posting Groups";
                    }
                }
                group(TaxGroups)
                {
                    Caption = 'Taxations';

                    action(TaxTypes)
                    {
                        Caption = 'Tax Types';
                        ApplicationArea = all;
                        RunObject = page "Tax Types";
                    }
                    group(GST)
                    {
                        action(GSTRegNo)
                        {
                            Caption = 'GST Reg. Nos.';
                            ApplicationArea = all;
                            RunObject = page "GST Registration Nos.";
                        }
                        action(GSTGroup)
                        {
                            Caption = 'GST Groups';
                            ApplicationArea = all;
                            RunObject = page "GST Group";
                        }
                        action(HSNSAC)
                        {
                            Caption = 'HSN / SAC Codes';
                            ApplicationArea = all;
                            RunObject = page "HSN/SAC";
                        }
                        action(GSTPostingSetup)
                        {
                            Caption = 'GST Posting Setup';
                            ApplicationArea = all;
                            RunObject = page "GST Posting Setup";
                        }
                        action(EInvoiceSetup)
                        {
                            ApplicationArea = all;
                            Caption = 'E-Invoice / E-Way Setup';
                            RunObject = page "E Invoice / Way Setup";
                        }
                    }
                    group(TDS)
                    {
                        action(TANNos)
                        {
                            Caption = 'T.A.N. Nos.';
                            ApplicationArea = all;
                            RunObject = page "T.A.N. Nos.";
                        }
                        action(TDSSections)
                        {
                            Caption = 'TDS Sections';
                            ApplicationArea = all;
                            RunObject = page "TDS Sections";
                        }
                        action(TDSSetup)
                        {
                            Caption = 'TDS Setup';
                            ApplicationArea = all;
                            RunObject = page "Iappc TDS Setup";
                        }
                        action(TDSPostingSetup)
                        {
                            Caption = 'TDS Posting Setup';
                            ApplicationArea = all;
                            RunObject = page "TDS Posting Setup";
                        }
                    }
                    group(TCS)
                    {
                        action(TCANNos)
                        {
                            Caption = 'T.C.A.N. Nos.';
                            ApplicationArea = all;
                            RunObject = page "T.C.A.N. Nos.";
                        }
                        action(TCSPostingSetup)
                        {
                            Caption = 'TCS Posting Setup';
                            ApplicationArea = all;
                            RunObject = page "TCS Posting Setup";
                        }
                    }
                }
                group(Users)
                {
                    Caption = 'Users';
                    action(User)
                    {
                        Caption = 'Users';
                        ApplicationArea = all;
                        RunObject = page Users;
                    }
                    action(UserSetup)
                    {
                        Caption = 'User Setup';
                        ApplicationArea = all;
                        RunObject = page "User Setup";
                    }
                    action(UserPermission)
                    {
                        Caption = 'User Permission';
                        ApplicationArea = all;
                        RunObject = page "User Permissions";
                    }
                    action(Permissions)
                    {
                        Caption = 'Permissions';
                        ApplicationArea = all;
                        RunObject = page "Permission Sets";
                    }
                }
                group(TaxSetup)
                {
                    Caption = 'Tax Setup';
                }
                group(Setup)
                {
                    Caption = 'Setups';
                    action(SalesSetup)
                    {
                        Caption = 'Sales Setup';
                        RunObject = page "Sales & Receivables Setup";
                        ApplicationArea = all;
                    }
                    action(PurchSetup)
                    {
                        ApplicationArea = all;
                        Caption = 'Purchase Setup';
                        RunObject = page "Purchases & Payables Setup";
                    }
                    action(FASetup)
                    {
                        Caption = 'Fixed Asset Setup';
                        ApplicationArea = all;
                        RunObject = page "Fixed Asset Setup";
                    }
                    action(InventorySetup)
                    {
                        Caption = 'Inventory Setup';
                        ApplicationArea = all;
                        RunObject = page "Inventory Setup";
                    }
                    action(HRSetup)
                    {
                        Caption = 'HR Setup';
                        ApplicationArea = all;
                        RunObject = page "Human Resources Setup";
                    }
                    action(Manufactring)
                    {
                        Caption = 'Manufacturing Setup';
                        ApplicationArea = all;
                        RunObject = page "Manufacturing Setup";
                    }
                    action(JobSetup)
                    {
                        Caption = 'Jobs Setup';
                        ApplicationArea = all;
                        RunObject = page "Jobs Setup";
                    }
                }
            }
            group(Masters)
            {
                Caption = 'Masters';
                action(COA)
                {
                    Caption = 'Chart of Accounts';
                    ApplicationArea = all;
                    RunObject = page "Chart of Accounts";
                }
                action(Customer)
                {
                    Caption = 'Customers';
                    ApplicationArea = all;
                    RunObject = page "Customer List";
                }
                action(Vendor)
                {
                    Caption = 'Vendors';
                    ApplicationArea = all;
                    RunObject = page "Vendor List";
                }
                action(Bank)
                {
                    Caption = 'Banks';
                    ApplicationArea = all;
                    RunObject = page "Bank Account List";
                }
                action(FA)
                {
                    Caption = 'Fixed Assets';
                    ApplicationArea = all;
                    RunObject = page "Fixed Asset List";
                }
                action(Items)
                {
                    Caption = 'Items';
                    ApplicationArea = all;
                    RunObject = page "Item List";
                }
                action(Employee)
                {
                    Caption = 'Employees';
                    ApplicationArea = all;
                    RunObject = page "Employee List";
                }
                action(Currencies)
                {
                    Caption = 'Currencies';
                    ApplicationArea = all;
                    RunObject = page Currencies;
                }
            }
            group(Transactions)
            {
                Caption = 'Transactions';
                group(Voucher)
                {
                    Caption = 'Voucher';
                    action(BankReceipt)
                    {
                        Caption = 'Bank Receipt Voucher';
                        ApplicationArea = all;
                        RunObject = page "Bank Receipt Voucher Iappc";
                    }
                    action(BankPayment)
                    {
                        Caption = 'Bank Payment Voucher';
                        ApplicationArea = all;
                        RunObject = page "Bank Payment Voucher Iappc";
                    }
                    action(PaymentJournal)
                    {
                        Caption = 'Payment Journal';
                        ApplicationArea = all;
                        RunObject = page "Payment Journal";
                    }
                    action(CashReceipt)
                    {
                        Caption = 'Cash Receipt Voucher';
                        ApplicationArea = all;
                        RunObject = page "Cash Receipt Voucher Iappc";
                    }
                    action(CashPayment)
                    {
                        Caption = 'Cash Payment Voucher';
                        ApplicationArea = all;
                        RunObject = page "Cash Payment Voucher Iappc";
                    }
                    action(ContraVouher)
                    {
                        Caption = 'Contra Voucher';
                        ApplicationArea = all;
                        RunObject = page "Contra Voucher Iappc";
                    }
                    action(GenVouher)
                    {
                        Caption = 'Journal Voucher';
                        ApplicationArea = all;
                        RunObject = page "Journal Voucher Iappc";
                    }
                    action(GenJournal)
                    {
                        Caption = 'General Journal';
                        ApplicationArea = all;
                        RunObject = page "General Journal Iappc";
                    }
                    action(RecurringJournal)
                    {
                        Caption = 'Recurring Journal';
                        ApplicationArea = all;
                        RunObject = page "Recurring General Journal";
                    }
                    action(AllUnPostedVoucher)
                    {
                        Caption = 'All Unposted Voucher';
                        ApplicationArea = all;
                        RunObject = page "All UnPosted Voucher";
                    }


                }
                group(GST_Reco)
                {
                    Caption = 'GSTR_Dump';
                    action(uploadGSTFile)
                    {
                        Caption = 'Upload GST File';
                        ApplicationArea = all;
                        Image = Import;
                        RunObject = codeunit "Import GST  Data";
                    }
                    Action(GSTRDump)
                    {
                        Caption = 'GSTR Dump';
                        ApplicationArea = all;
                        Image = DataEntry;
                        RunObject = page GSTRDumpList;
                    }
                    Action(PurchaseTransactions)
                    {
                        Caption = 'Purchase Transacions';
                        ApplicationArea = all;
                        Image = Purchase;
                        RunObject = page PurchasetransactionList;
                    }
                    action(GSTRCompare)
                    {
                        Caption = 'GSTR Compare';
                        ApplicationArea = all;
                        Image = CompareCost;
                        RunObject = page "GST Reco Compare";
                    }

                }

                group(FAJournals)
                {
                    Caption = 'Fixed Asset Journals';
                    action(FAJournal)
                    {
                        Caption = 'FA Journal';
                        ApplicationArea = all;
                        RunObject = page "Fixed Asset Journal";
                    }
                    action(FAGLJournal)
                    {
                        Caption = 'FA G/L Journal';
                        ApplicationArea = all;
                        RunObject = page "Fixed Asset G/L Journal";
                    }
                }
                group(TaxJournals)
                {
                    Caption = 'Tax Journals';
                    action(TDSAdjustmentJournal)
                    {
                        Caption = 'TDS Adjustment Journal';
                        ApplicationArea = all;
                        RunObject = page "TDS Adjustment Journal";
                    }
                    action(TCSAdjustmentJournal)
                    {
                        Caption = 'TCS Adjustment Journal';
                        ApplicationArea = all;
                        RunObject = page "TCS Adjustment Journal";
                    }
                }
                group(ItemJournals)
                {
                    Caption = 'Item Journals';
                    action(ItemJournal)
                    {
                        Caption = 'Item Journal';
                        ApplicationArea = all;
                        RunObject = page "Item Journal";
                    }
                    action(ItemReclJournal)
                    {
                        Caption = 'Item Reclassification Journal';
                        ApplicationArea = all;
                        RunObject = page "Item Reclass. Journal";
                    }
                    action(ItemRevaluation)
                    {
                        Caption = 'Item Revaluation';
                        ApplicationArea = all;
                        RunObject = page "Revaluation Journal";
                    }
                }
                group(Documents)
                {
                    Caption = 'Documents';
                    action(SalesInv)
                    {
                        Caption = 'Sales Invoices';
                        ApplicationArea = all;
                        RunObject = page "Sales Invoice List";
                    }
                    action(SalesCrMemo)
                    {
                        Caption = 'Sales Credit Memos';
                        ApplicationArea = all;
                        RunObject = page "Sales Credit Memos";
                    }
                    action(PurchInv)
                    {
                        Caption = 'Purchase Invoices';
                        ApplicationArea = all;
                        RunObject = page "Purchase Invoices";
                    }
                    action(PurchCrMemo)
                    {
                        Caption = 'Purchase Credit Memos';
                        ApplicationArea = all;
                        RunObject = page "Purchase Credit Memos";
                    }
                    action(ApprovalEntries)
                    {
                        Caption = 'Pending Approval Entries';
                        ApplicationArea = all;
                        RunObject = page "Approval Entries";
                        RunPageView = WHERE(Status = CONST(Open));
                    }
                }
            }
            group(Periodic)
            {
                Caption = 'Periodic Activities';
                action(Budget)
                {
                    ApplicationArea = all;
                    Caption = 'G/L Budget';
                    RunObject = page "G/L Budget Names";
                }
                action(AdjustItemCost)
                {
                    ApplicationArea = all;
                    Caption = 'Adjust Item Cost';
                    RunObject = report "Adjust Cost - Item Entries";
                }
                action(BankReco)
                {
                    Caption = 'Bank Reconciliation';
                    ApplicationArea = all;
                    RunObject = page "Bank Acc. Reconciliation List";
                }
                action(CalcDepreciation)
                {
                    Caption = 'Calculate Depreciation';
                    ApplicationArea = all;
                    RunObject = report "Calculate Depreciation";
                }
                action(BankRecoReport)
                {
                    Caption = 'Bank Reconciliation Report';
                    ApplicationArea = all;
                    RunObject = report "Bank Reconciliation Report";
                }
                action(BookingTran)
                {
                    Caption = 'Booking Transactions';
                    ApplicationArea = all;
                    RunObject = page "Booking Transactions";
                }
                action(CancelTran)
                {
                    Caption = 'Cancel Transactions';
                    ApplicationArea = all;
                    RunObject = page "Cancel Transactions";
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                group(Ledgers)
                {
                    Caption = 'Ledgers';
                    action(GLLedger)
                    {
                        Caption = 'G/L Ledger';
                        ApplicationArea = all;
                        RunObject = report "Account Ledger";
                    }
                    action(CustLedger)
                    {
                        Caption = 'Customer Ledger';
                        ApplicationArea = all;
                        RunObject = report "Customer Ledger";
                    }
                    action(VendLedger)
                    {
                        Caption = 'Vendor Ledger';
                        ApplicationArea = all;
                        RunObject = report "Vendor Ledger";
                    }
                    action(MSMEReport)
                    {
                        Caption = 'MSME Report';
                        ApplicationArea = all;
                        RunObject = report "MSME Report";
                    }
                    action(BankLedger)
                    {
                        Caption = 'Bank Ledger';
                        ApplicationArea = all;
                        RunObject = Report "Bank Ledger";
                    }
                    action(ItemLedger)
                    {
                        Caption = 'Item Ledger';
                        ApplicationArea = all;
                        RunObject = Report "Item Ledger";
                    }
                    action(FALedger)
                    {
                        Caption = 'Fixed Asset Ledger';
                        ApplicationArea = all;
                        RunObject = report "FA Ledger";
                    }
                    action(EmployeeLedger)
                    {
                        Caption = 'Employee Ledger';
                        ApplicationArea = all;
                        RunObject = report "Employee Ledger";
                    }
                    action(DimLedger)
                    {
                        Caption = 'Dimension Ledger';
                        ApplicationArea = all;
                        RunObject = report "Dimension Ledger";
                    }
                }
                group(Registers)
                {
                    Caption = 'Registers';
                    action(InwardReg)
                    {
                        Caption = 'Inward Supply';
                        ApplicationArea = all;
                        RunObject = report "GST Inward Report";
                    }
                    action(OutwardReg)
                    {
                        Caption = 'Outward Supply';
                        ApplicationArea = all;
                        RunObject = report "GST Outward Report";
                    }
                    action(TARClause34A44)
                    {
                        Caption = 'TAR Clause 34A / 44';
                        ApplicationArea = all;
                        RunObject = report "TAR Clause 34A / 44";
                    }
                    action(DetailedSales)
                    {
                        Caption = 'Detailed Sales Register';
                        ApplicationArea = all;
                        RunObject = report "Detailed Sales Register";
                    }
                    action(DetailedPurch)
                    {
                        Caption = 'Detailed Purchase Register';
                        ApplicationArea = all;
                        RunObject = report "Detailed Purchase Register";
                    }
                    action(TDSEntry)
                    {
                        Caption = 'TDS Register';
                        ApplicationArea = all;
                        RunObject = page "TDS Entries";
                    }
                    action(TCSEntry)
                    {
                        Caption = 'TCS Register';
                        ApplicationArea = all;
                        RunObject = page "TCS Entries";
                    }
                    action(FARegister)
                    {
                        Caption = 'FA Register';
                        ApplicationArea = all;
                        RunObject = report "FA Register";
                    }
                    action(FASchedule)
                    {
                        Caption = 'FA Schedule';
                        ApplicationArea = all;
                        RunObject = report "FA Schedule";
                    }
                    action(AdvanceRegister)
                    {
                        Caption = 'Advance Report';
                        ApplicationArea = all;
                        RunObject = report "Advance Report";
                    }
                }
                group(Ageing)
                {
                    Caption = 'Ageing';
                    action(CustomerAgeing)
                    {
                        ApplicationArea = all;
                        Caption = 'Customer Ageing';
                        RunObject = Report "Aged Accounts Receivable";
                    }
                    action(CollectionReport)
                    {
                        ApplicationArea = all;
                        Caption = 'AR Collection Report';
                        RunObject = Report "AR Collection Report";
                    }
                    action(CustomerAgeningNew)
                    {
                        ApplicationArea = all;
                        Caption = 'Customer Ageing New';
                        RunObject = Report "Customer Ageing Report";
                    }
                    action(VendorAgening)
                    {
                        Caption = 'Vendor Ageing';
                        ApplicationArea = all;
                        RunObject = Report "Aged Accounts Payable";
                    }
                    action(VendorAgeningNew)
                    {
                        ApplicationArea = all;
                        Caption = 'Vendor Ageing New';
                        RunObject = Report "Vendor Ageing Report";
                    }
                    action(ItemAgeing)
                    {
                        Caption = 'Item Ageing';
                        ApplicationArea = all;
                        RunObject = Report "Item Ageing";
                    }
                }
                group(Analysis)
                {
                    Caption = 'Analysis';
                    action(FinancialReports)
                    {
                        ApplicationArea = all;
                        Caption = 'Financial Reports';
                        RunObject = page "Financial Reports";
                    }
                    action(AnalysisByDim)
                    {
                        ApplicationArea = all;
                        Caption = 'Analysis Views';
                        RunObject = page "Analysis View List";
                    }
                    action(DimensionTotal)
                    {
                        ApplicationArea = all;
                        Caption = 'Dimension Total Report';
                        RunObject = report "Dimensions - Total";
                    }
                    action(DimensionDetails)
                    {
                        ApplicationArea = all;
                        Caption = 'Dimension Detail Report';
                        RunObject = report "Dimensions - Detail";
                    }
                    action(TrialBalance)
                    {
                        ApplicationArea = all;
                        Caption = 'Trial Balance';
                        RunObject = Report "Iappc Trial Balance";
                    }
                    action(TrialBalanceMonthly)
                    {
                        ApplicationArea = all;
                        Caption = 'Trial Balance Monthly';
                        RunObject = Report "Trial Balance Monthly";
                    }
                    action(SalesOrderShipment)
                    {
                        ApplicationArea = all;
                        Caption = 'Sales Order Shipment';
                        RunObject = Report "Sales Order Shipment";
                    }
                    action(SalesOrderStatus)
                    {
                        ApplicationArea = all;
                        Caption = 'Sales Order Status';
                        RunObject = Report "Sales Order Status";
                    }
                    action(GLLobLocDept)
                    {
                        Caption = 'G/L, LOB, LOC and Dept Values';
                        ApplicationArea = all;
                        RunObject = report "G/L, LOB, LOC and Dept.";
                    }
                    action(GLLobLocDeptMonthly)
                    {
                        Caption = 'G/L, LOB, LOC and Dept Values Monthly';
                        ApplicationArea = all;
                        RunObject = report "G/L LOB LOC and Dept. Monthly";
                    }
                    action(GLLobLocDeptDimValDetails)
                    {
                        Caption = 'G/L & LOB / LOC / Dept Values Details';
                        ApplicationArea = all;
                        RunObject = report "G/L LOB LOC and Dept. Details";
                    }
                    action(GLLobLocDeptDetails)
                    {
                        Caption = 'G/L & LOB / LOC / Dept Details';
                        ApplicationArea = all;
                        RunObject = report "G/L Dimension Details";
                    }
                    action(GLLobLocDeptDetailsMonthly)
                    {
                        Caption = 'G/L & LOB / LOC / Dept Details Monthly';
                        ApplicationArea = all;
                        RunObject = report "G/L Dimension Details Monthly";
                    }
                }
                group(PostedDocuments)
                {
                    Caption = 'Posted Documents';
                    action(PostedSalesInvoice)
                    {
                        ApplicationArea = all;
                        Caption = 'Posted Sales Invoices';
                        RunObject = page "Posted Sales Invoices";
                    }
                    action(PostedSalesCrMemo)
                    {
                        ApplicationArea = all;
                        Caption = 'Posted Sales Credit Memos';
                        RunObject = page "Posted Sales Credit Memos";
                    }
                    action(PostedPurchRcpt)
                    {
                        ApplicationArea = all;
                        Caption = 'Posted Purchase Receipts';
                        RunObject = page "Posted Purchase Receipts";
                    }
                    action(PostedPurchInvoices)
                    {
                        ApplicationArea = all;
                        Caption = 'Posted Purchase Invoices';
                        RunObject = page "Posted Purchase Invoices";
                    }
                    action(PostedPurchCrMemo)
                    {
                        Caption = 'Posted Purchase Credit Memos';
                        ApplicationArea = all;
                        RunObject = page "Posted Purchase Credit Memos";
                    }
                }
                group(ArchivedDocuments)
                {
                    Caption = 'Archive Documents';
                    action(SalesDocuments)
                    {
                        Caption = 'Sales Documents';
                        ApplicationArea = all;
                        RunObject = page "Sales Order Archives";
                    }
                    action(PurchaseDocuments)
                    {
                        Caption = 'Purchase Documents';
                        ApplicationArea = all;
                        RunObject = page "Purchase Order Archives";
                    }
                    action(ClosedIndents)
                    {
                        Caption = 'Indents';
                        ApplicationArea = all;
                        RunObject = page "Indent List Approved";
                    }
                }
                group(Balances)
                {
                    Caption = 'Balances';
                    action(GLBalances)
                    {
                        ApplicationArea = all;
                        Caption = 'G/L Balances';
                        RunObject = page "G/L Balances";
                    }
                    action(CustBalances)
                    {
                        ApplicationArea = all;
                        Caption = 'Customer Balances';
                        RunObject = page "Customer Balances";
                    }
                    action(VendorBalances)
                    {
                        ApplicationArea = all;
                        Caption = 'Vendor Balances';
                        RunObject = page "Vendor Balances";
                    }
                    action(BankBalances)
                    {
                        ApplicationArea = all;
                        Caption = 'Bank Balances';
                        RunObject = page "Bank Balances";
                    }
                    action(ItemBalances)
                    {
                        ApplicationArea = all;
                        Caption = 'Item Balances';
                        RunObject = page "Item Balances";
                    }
                    action(FABalances)
                    {
                        Caption = 'Fixed Asset Balances';
                        ApplicationArea = all;
                        RunObject = page "FA Balances";
                    }
                    action(EmployeeBalances)
                    {
                        Caption = 'Employee Balances';
                        ApplicationArea = all;
                        RunObject = page "Employee Balances";
                    }
                }
            }
            group(DataImport)
            {
                Caption = 'Import';
                action(COAImport)
                {
                    Caption = 'Chart of Account';
                    ApplicationArea = all;
                    RunObject = xmlport "COA Import";
                }
                action(CustomerImport)
                {
                    Caption = 'Customer';
                    ApplicationArea = all;
                    RunObject = xmlport "Customer Import";
                }
                action(VendorImport)
                {
                    Caption = 'Vendor';
                    ApplicationArea = all;
                    RunObject = xmlport "Vendor Import";
                }
                action(EmployeeImport)
                {
                    Caption = 'Employee';
                    ApplicationArea = all;
                    RunObject = xmlport "Employee Import";
                }
                action(DimensionValue)
                {
                    Caption = 'Dimension Value';
                    ApplicationArea = all;
                    RunObject = xmlport "Dimension Value Import";
                }
                action(FAHeader)
                {
                    Caption = 'FA Header';
                    ApplicationArea = all;
                    RunObject = xmlport "FA Header Import";
                }
                action(FALines)
                {
                    Caption = 'FA Lines';
                    ApplicationArea = all;
                    RunObject = xmlport "FA Lines Import";
                }
                action(ItemImport)
                {
                    Caption = 'Items';
                    ApplicationArea = all;
                    RunObject = xmlport "Item Import";
                }
                action(BOMImport)
                {
                    Caption = 'Prod. BOM';
                    ApplicationArea = all;
                    RunObject = xmlport "Prod. BOM Import";
                }
            }
        }
    }
}