pageextension 50055 "Manufacturing Setup Ext." extends "Manufacturing Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Routing Nos.")
        {
            field("Requisition Nos."; Rec."Requisition Nos.")
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