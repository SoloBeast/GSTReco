pageextension 50072 "FA GL Journal Ext." extends "Fixed Asset G/L Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Location Code") { Visible = false; }
        modify("GST Assessable Value") { Visible = false; }
        modify("Custom Duty Amount") { Visible = false; }
        modify("Budgeted FA No.") { Visible = false; }
        modify("FA Error Entry No.") { Visible = false; }
        addafter("Location Code")
        {
            field("Type of Transaction"; Rec."Type of Transaction")
            {
                ApplicationArea = all;
                Visible = true;
            }
            field("Transaction Nature"; Rec."Transaction Nature")
            {
                ApplicationArea = all;
                Visible = true;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("Apply Entries") { Visible = false; }
        modify("Update Reference Invoice No.") { Visible = false; }
        modify("Renumber Document Numbers") { Visible = false; }
        modify("Insert Conv. LCY Rndg. Lines") { Visible = false; }
        modify(Reconcile) { Visible = false; }
    }

    var
}