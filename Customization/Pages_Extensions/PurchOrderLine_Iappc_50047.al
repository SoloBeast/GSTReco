pageextension 50047 "Purch. Order Line Ext." extends "Purchase Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addbefore("GST Group Code")
        {
            field("GenProdPostingGroup"; Rec."Gen. Prod. Posting Group")
            {
                Caption = 'Gen. Prod. Posting Group';
                ApplicationArea = all;
            }
        }
        modify("Deferral Code")
        {
            Visible = true;
        }
        modify("GST Group Code")
        {
            Visible = true;
        }
        modify("HSN/SAC Code")
        {
            Visible = true;
        }
        modify("Location Code")
        {
            Visible = true;
        }
        modify("Nature of Remittance")
        {
            Visible = false;
        }
        modify("Act Applicable")
        {
            Visible = false;
        }
        modify("Custom Duty Amount")
        {
            Visible = false;
        }
        modify("GST Assessable Value")
        {
            Visible = false;
        }
        modify("Total VAT Amount")
        {
            Visible = false;
        }
        modify("Total Amount Excl. VAT")
        {
            Visible = false;
        }
        modify("Bin Code")
        {
            Visible = false;
        }
        modify("Reserved Quantity")
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
        modify("Planned Receipt Date")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here        
        modify("Reservation Entries")
        {
            Visible = false;
        }
        modify(DocumentLineTracking)
        {
            Visible = false;
        }
        modify(DeferralSchedule)
        {
            Visible = false;
        }
        modify(Reserve)
        {
            Visible = false;
        }
        modify(OrderTracking)
        {
            Visible = false;
        }
        modify("Dr&op Shipment")
        {
            Visible = false;
        }
        modify("Speci&al Order")
        {
            Visible = false;
        }
    }

    var
}