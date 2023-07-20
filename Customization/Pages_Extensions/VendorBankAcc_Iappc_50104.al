pageextension 50104 "Vendor Bank Acc. Ext." extends "Vendor Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        addbefore(Name)
        {
            field("Vendor Name"; Rec."Vendor Name")
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

        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}