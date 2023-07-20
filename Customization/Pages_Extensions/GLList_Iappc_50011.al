pageextension 50011 "GL Account List Ext." extends "G/L Account List"
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
        modify("Reconciliation Account")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
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
    }

    var
}