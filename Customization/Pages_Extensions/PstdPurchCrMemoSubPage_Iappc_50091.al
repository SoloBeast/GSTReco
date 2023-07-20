pageextension 50091 "Pstd.Cr.Memo SPage Ext." extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Return Reason Code")
        {
            Visible = false;
        }
        modify("Deferral Code")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(DeferralSchedule)
        {
            Visible = false;
        }
    }

    var
}