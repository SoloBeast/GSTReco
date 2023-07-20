pageextension 50002 "GL Setup Ext." extends "General Ledger Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Shortcut Dimension 8 Code")
        {
            field("Bank Dimension"; Rec."Bank Dimension")
            {
                ApplicationArea = all;
            }
        }
        addafter(General)
        {
            group(DigitalSign)
            {
                Caption = 'Digital Signature';
                field("Digital Sign URL"; Rec."Digital Sign URL")
                {
                    ApplicationArea = all;
                }
                field("API Key"; Rec."API Key")
                {
                    ApplicationArea = all;
                }
                field(Signer; Rec.signer)
                {
                    ApplicationArea = all;
                }
                field(Pfxid; Rec.Pfxid)
                {
                    ApplicationArea = all;
                }
                field(Pfxpwd; Rec.Pfxpwd)
                {
                    ApplicationArea = all;
                }
                field(Signloc; Rec.Signloc)
                {
                    ApplicationArea = all;
                }
                field(Signannotation; Rec.Signannotation)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    var
}