page 50032 "Iappc TDS Setup"
{
    PageType = List;
    Caption = 'TDS Setup';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Iappc TDS Setup";

    layout
    {
        area(Content)
        {
            repeater(TDSSetup)
            {
                field("TDS Section"; Rec."TDS Section")
                {
                    ApplicationArea = All;
                }
                field("Assessee Code"; Rec."Assessee Code")
                {
                    ApplicationArea = All;
                }
                field("Concessional Code"; Rec."Concessional Code")
                {
                    ApplicationArea = All;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                }
                field("TDS %"; Rec."TDS %")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
}