page 50042 "E Invoice / Way Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales & Receivables Setup";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General';

                field("E-Invoice User ID"; Rec."E-Invoice User ID")
                {
                    ApplicationArea = All;
                }
                field("E-Invoice Password"; Rec."E-Invoice Password")
                {
                    ApplicationArea = All;
                }
                field("E-Invoicing Client ID"; Rec."E-Invoicing Client ID")
                {
                    ApplicationArea = All;
                }
                field("E-Invoicing Client Secret"; Rec."E-Invoicing Client Secret")
                {
                    ApplicationArea = All;
                }
                field("E-Invoice Access Token API"; Rec."E-Invoice Access Token API")
                {
                    ApplicationArea = All;
                }
                field("E-Invoice Generation API"; Rec."E-Invoice Generation API")
                {
                    ApplicationArea = All;
                }
                field("E-Invoice Cancellation API"; Rec."E-Invoice Cancellation API")
                {
                    ApplicationArea = All;
                }
                field("E-Way Generation API"; Rec."E-Way Generation API")
                {
                    ApplicationArea = All;
                }
                field("E-Way Cancellation API"; Rec."E-Way Cancellation API")
                {
                    ApplicationArea = All;
                }
                field("E-Invoice Token"; Rec."E-Invoice Token")
                {
                    ApplicationArea = All;
                }
                field("Show Json"; Rec."Show Json")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
}