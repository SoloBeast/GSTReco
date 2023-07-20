pageextension 50075 "Company Info. Ext." extends "Company Information"
{
    layout
    {
        // Add changes to page layout here
        addafter("Company Status")
        {
            field("C.I.N. No."; Rec."C.I.N. No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Bank Account No.")
        {
            field("IFSC Code"; Rec."IFSC Code")
            {
                ApplicationArea = all;
            }
        }

        modify("Allow Blank Payment Info.")
        {
            Visible = false;
        }
        modify("Payment Routing No.")
        {
            Visible = false;
        }
        modify("Giro No.")
        {
            Visible = false;
        }
        modify("SWIFT Code")
        {
            Visible = false;
        }
        modify(IBAN)
        {
            Visible = false;
        }
        modify(BankAccountPostingGroup)
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}