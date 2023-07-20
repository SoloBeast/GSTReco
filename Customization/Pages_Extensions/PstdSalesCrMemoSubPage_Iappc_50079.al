pageextension 50079 "Pstd. Sales Cr.Memo SPage Ext." extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = all;
            }
        }
        modify("Item Reference No.")
        {
            Visible = false;
        }
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