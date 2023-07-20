pageextension 50101 "Currency Ext." extends Currencies
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Currency Numeric Description"; Rec."Currency Numeric Description")
            {
                ApplicationArea = all;
            }
            field("Currency Decimal Description"; Rec."Currency Decimal Description")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}