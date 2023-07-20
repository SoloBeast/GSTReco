page 50029 "Purch. Pending QC"
{
    PageType = List;
    ApplicationArea = Basic, Suit;
    UsageCategory = Administration;
    SourceTable = "Purch. Rcpt. Line";
    SourceTableView = sorting("Document No.", "Line No.") where("QC Pending" = const(true));
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    LinksAllowed = false;
    Caption = 'Purch. Pending QC';

    layout
    {
        area(Content)
        {
            repeater(PendingQC)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(QCCheck)
            {
                ApplicationArea = All;
                Caption = 'Quality Check';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "QC Item Ledger Entry";
                RunPageView = sorting("Document No.", "Document Type", "Document Line No.");
                RunPageLink = "Document No." = field("Document No."), "Document Line No." = field("Line No.");
            }
        }
    }

    var
}