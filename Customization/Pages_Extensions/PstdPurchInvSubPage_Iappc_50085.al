pageextension 50085 "Pstd.Purch Inv SPage Ext." extends "Posted Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Job No.")
        {
            Visible = false;
        }
        modify("Deferral Code")
        {
            Visible = false;
        }
        modify("Item Reference No.")
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