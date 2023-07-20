pageextension 50043 "Sales Order Line Ext." extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = all;
            }
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Total Amount Excl. VAT")
        {
            Visible = false;
        }
        modify("Total VAT Amount")
        {
            Visible = false;
        }
        modify("GST Assessable Value (LCY)")
        {
            Visible = false;
        }
        modify("GST on Assessable Value")
        {
            Visible = false;
        }
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }
        modify("Reserved Quantity")
        {
            Visible = false;
        }
        modify(Exempted)
        {
            Visible = false;
        }
        modify("Planned Delivery Date")
        {
            Visible = false;
        }
        modify("Planned Shipment Date")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Reserve)
        {
            Visible = false;
        }
        modify(OrderTracking)
        {
            Visible = false;
        }
        modify("Insert Ext. Texts")
        {
            Visible = false;
        }
        modify(ExplodeBOM_Functions)
        {
            Visible = false;
        }
        modify("Reservation Entries")
        {
            Visible = false;
        }
        modify(SelectItemSubstitution)
        {
            Visible = false;
        }
        modify(OrderPromising)
        {
            Visible = false;
        }
        modify("Assemble to Order")
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
        modify("Dr&op Shipment")
        {
            Visible = false;
        }
        modify("Speci&al Order")
        {
            Visible = false;
        }
        modify(BlanketOrder)
        {
            Visible = false;
        }
        modify("Select Nonstoc&k Items")
        {
            Visible = false;
        }
    }

    var
}