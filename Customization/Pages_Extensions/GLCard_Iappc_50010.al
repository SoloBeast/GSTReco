pageextension 50010 "G/L Card Ext." extends "G/L Account Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Group Name"; Rec."Group Name")
            {
                ApplicationArea = all;
            }
            field("Sub Group Name"; Rec."Sub Group Name")
            {
                ApplicationArea = all;
            }
        }
        modify("Automatic Ext. Texts")
        {
            Visible = false;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = false;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Default IC Partner G/L Acc. No")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
        modify(Consolidation)
        {
            Visible = false;
        }
        modify("New Page")
        {
            Visible = false;
        }
        modify("No. of Blank Lines")
        {
            Visible = false;
        }
        modify(Reporting)
        {
            Visible = false;
        }
        modify("Cost Accounting")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("General Posting Setup")
        {
            Visible = false;
        }
        modify("VAT Posting Setup")
        {
            Visible = false;
        }
        modify("G/L Register")
        {
            Visible = false;
        }
        modify("E&xtended Texts")
        {
            Visible = false;
        }
        modify("Receivables-Payables")
        {
            Visible = false;
        }
        modify("Where-Used List")
        {
            Visible = false;
        }
        modify("F&unctions")
        {
            Visible = false;
        }
        modify(DocsWithoutIC)
        {
            Visible = false;
        }
        modify(Action1900210206)
        {
            Visible = false;
        }
    }

    var
}