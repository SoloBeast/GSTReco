pageextension 50105 "Bank Acc. Reco. Card Ext." extends "Bank Acc. Reconciliation"
{
    layout
    {
        // Add changes to page layout here
        modify(ApplyBankLedgerEntries)
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("Transfer to General Journal")
        {
            Visible = false;
        }
        modify("M&atching")
        {
            Visible = false;
        }
        modify("Ba&nk")
        {
            Visible = false;
        }
        modify(ImportBankStatement)
        {
            Visible = false;
        }
        modify(MatchAutomatically)
        {
            Visible = false;
        }
        modify(MatchManually)
        {
            Visible = false;
        }
        modify(RemoveMatch)
        {
            Visible = false;
        }
        modify(MatchDetails)
        {
            Visible = false;
        }
    }

    var
}