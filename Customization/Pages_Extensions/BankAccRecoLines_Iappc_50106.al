pageextension 50106 "Bank Acc. Reco Lines Ext." extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Transaction Date")
        {
            field("Bank Account No."; Rec."Bank Account No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Statement No."; Rec."Statement No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Statement Line No."; Rec."Statement Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter(Difference)
        {
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = all;
            }
        }
        addafter("Check No.")
        {
            field("Cheque Date"; Rec."Cheque Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }

        modify(Description)
        {
            Editable = false;
        }
        modify(Type)
        {
            Visible = false;
        }
        modify("Document No.")
        {
            Visible = true;
            Editable = false;
        }
        modify("Check No.")
        {
            Visible = true;
            Editable = false;
            Caption = 'Cheque No.';
        }
        modify("Transaction Date")
        {
            Editable = false;
        }
        modify("Value Date")
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(ApplyEntries)
        {
            action(ImportValueDate)
            {
                Caption = 'Import Value Date';
                ApplicationArea = all;
                Image = Import;

                trigger OnAction()
                begin
                    Rec.ImportValueDate();
                end;
            }
        }
    }

    var
}