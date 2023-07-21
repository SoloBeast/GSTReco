page 50198 Purchasetransactions
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = PurchaseTransactions;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(PurchaseTransations)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor GST No."; Rec."Vendor GST No.")
                {
                    ApplicationArea = All;

                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;

                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;

                }
                field("Invoice Value"; Rec."Invoice Value")
                {
                    ApplicationArea = All;

                }
                field("Place of Supply"; Rec."Place of Supply")
                {
                    ApplicationArea = All;

                }
                Field(RCM; Rec.RCM)
                {
                    ApplicationArea = All;

                }
                field("GST Rate%"; Rec."GST Rate%")
                {
                    ApplicationArea = All;

                }

                field("IGST Value"; Rec."IGST Value")
                {
                    ApplicationArea = All;

                }
                field("SGST/UGST Value"; Rec."SGST/UGST Value")
                {
                    ApplicationArea = All;

                }
                field("CGST Value"; Rec."CGST Value")
                {
                    ApplicationArea = All;

                }
                field("External Document No"; Rec."External Document No")
                {
                    ApplicationArea = All;

                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;

                }
                field("Taxable Amount"; Rec."Taxable Amount")
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}