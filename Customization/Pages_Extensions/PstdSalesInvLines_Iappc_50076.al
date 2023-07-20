pageextension 50076 "Pstd. Sales Inv. SubPage Ext." extends "Posted Sales Invoice Subform"
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