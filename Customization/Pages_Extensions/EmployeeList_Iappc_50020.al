pageextension 50020 "Employee List Ext." extends "Employee List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Last Name")
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = all;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
            }
            field(City; Rec.City)
            {
                ApplicationArea = all;
            }
        }
        addafter("Phone No.")
        {
            field("Company E-Mail"; Rec."Company E-Mail")
            {
                ApplicationArea = all;
            }
            field("Employee Posting Group"; Rec."Employee Posting Group")
            {
                ApplicationArea = all;
            }
            field("Employment Date"; Rec."Employment Date")
            {
                ApplicationArea = all;
            }
            field("Inactive Date"; Rec."Inactive Date")
            {
                ApplicationArea = all;
            }
            field("Birth Date"; Rec."Birth Date")
            {
                ApplicationArea = all;
            }
            field(Balance; Rec.Balance)
            {
                ApplicationArea = all;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;
            }
            field("Created At"; Rec."Created At")
            {
                ApplicationArea = all;
            }
            field("Modified By"; Rec."Modified By")
            {
                ApplicationArea = all;
            }
            field("Last Date Modified"; Rec."Last Date Modified")
            {
                ApplicationArea = all;
            }
        }

        modify("Post Code")
        {
            Visible = true;
        }
        modify("Country/Region Code")
        {
            Visible = true;
        }
        modify("Mobile Phone No.")
        {
            Visible = true;
        }
        modify("E-Mail")
        {
            Visible = true;
        }
        modify("Search Name")
        {
            Visible = false;
        }
        modify(Comment)
        {
            Visible = false;
        }
        moveafter(City; "Post Code")
        moveafter("Post Code"; "Country/Region Code")
    }

    actions
    {
        // Add changes to page actions here
        addafter("Ledger E&ntries")
        {
            action(AccountLedger)
            {
                Caption = 'Employee Ledger';
                Image = LedgerEntries;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    recEmployee.Reset();
                    recEmployee.SetRange("No.", Rec."No.");
                    recEmployee.FindFirst();
                    Clear(rptLedgerReport);
                    rptLedgerReport.SetTableView(recEmployee);
                    rptLedgerReport.Run();
                end;
            }
        }

        modify("Absence Registration")
        {
            Visible = false;
        }
        modify(PayEmployee)
        {
            Visible = false;
        }
        modify(Contact)
        {
            Visible = false;
        }
        modify(ApplyTemplate)
        {
            Visible = false;
        }
        modify("A&bsences")
        {
            Visible = false;
        }
        modify("Absences by Ca&tegories")
        {
            Visible = false;
        }
    }

    var
        recEmployee: Record Employee;
        rptLedgerReport: Report "Employee Ledger";
}