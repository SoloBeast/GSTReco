page 50030 "QC Item Ledger Entry"
{
    PageType = List;
    UsageCategory = Administration;
    SourceTable = "Item Ledger Entry";
    LinksAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'QC Item Entries';
    Permissions = tabledata "Item Ledger Entry" = rm;

    layout
    {
        area(Content)
        {
            repeater(PendingEntries)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Rejected Quantity"; Rec."Rejected Quantity")
                {
                    ApplicationArea = all;
                }
                field("Approved Quantity"; Rec."Approved Quantity")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PostQC)
            {
                ApplicationArea = All;
                Caption = 'Post QC';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if not Confirm('Do you want to post the QC Entries?', false) then
                        exit;
                    cuIappcProcess.PostQC(Rec."Document No.", Rec."Document Line No.");

                    Message('The QC entries has been posted.');
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        cuIappcProcess: Codeunit "Process Flow";
}