pageextension 50016 "Item List Ext." extends "Item List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Item Category Code")
        {
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;
            }
            field("Created At"; Rec."Created At")
            {
                ApplicationArea = all;
            }
            field("Modified By"; Rec."Modified By")
            {
                ApplicationArea = all;
            }
        }

        modify("Last Date Modified")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Inventory Posting Group")
        {
            Visible = true;
        }
        modify("Item Category Code")
        {
            Visible = true;
        }
        modify("Substitutes Exist")
        {
            Visible = false;
        }
        modify("Assembly BOM")
        {
            Visible = false;
        }
        modify("Cost is Adjusted")
        {
            Visible = false;
        }
        modify("Unit Cost")
        {
            Visible = false;
        }
        modify("Unit Price")
        {
            Visible = false;
        }
        modify("Vendor No.")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }

        moveafter(Type; "Gen. Prod. Posting Group")
        moveafter("Gen. Prod. Posting Group"; "Inventory Posting Group")
        moveafter("Inventory Posting Group"; "Item Category Code")
    }

    actions
    {
        // Add changes to page actions here
        modify("Item Journal")
        {
            Visible = false;
        }
        modify("Item Reclassification Journal")
        {
            Visible = false;
        }
        modify("Inventory - Reorders")
        {
            Visible = false;
        }
        modify("Inventory - Sales Back Orders")
        {
            Visible = false;
        }
        modify(AdjustInventory)
        {
            Visible = false;
        }
        modify("Sales Price Worksheet")
        {
            Visible = false;
        }
        modify("Price List")
        {
            Visible = false;
        }
        modify("Substituti&ons")
        {
            Visible = false;
        }
        modify(Identifiers)
        {
            Visible = false;
        }
        modify("E&xtended Texts")
        {
            Visible = false;
        }
        modify(Translations)
        {
            Visible = false;
        }
        modify("Physical Inventory Journal")
        {
            Visible = false;
        }
        modify("&Reservation Entries")
        {
            Visible = false;
        }
        modify("Item &Tracking Entries")
        {
            Visible = false;
        }
        modify("&Warehouse Entries")
        {
            Visible = false;
        }
        modify("Prepa&yment Percentages")
        {
            Visible = false;
        }
        modify(Orders)
        {
            Visible = false;
        }
        modify("Return Orders")
        {
            Visible = false;
        }
        modify("Ca&talog Items")
        {
            Visible = false;
        }
        modify("&Bin Contents")
        {
            Visible = false;
        }
        modify("Stockkeepin&g Units")
        {
            Visible = false;
        }
        modify("Ser&vice Items")
        {
            Visible = false;
        }
        modify(Troubleshooting)
        {
            Visible = false;
        }
        modify("Troubleshooting Setup")
        {
            Visible = false;
        }
        modify("Resource &Skills")
        {
            Visible = false;
        }
        modify("Skilled R&esources")
        {
            Visible = false;
        }
        modify(Reports)
        {
            Visible = false;
        }
        modify(PricesandDiscounts)
        {
            Visible = false;
        }
        modify("Set Special Prices")
        {
            Visible = false;
        }
        modify(Functions)
        {
            Visible = false;
        }
        modify("Item Tracing")
        {
            Visible = false;
        }
        modify(ApplyTemplate)
        {
            Visible = false;
        }
        modify("&Phys. Inventory Ledger Entries")
        {
            Visible = false;
        }
        modify("Revaluation Journal")
        {
            Visible = false;
        }
        modify("Requisition Worksheet")
        {
            Visible = false;
        }
        modify("Adjust Item Cost/Price")
        {
            Visible = false;
        }
        modify(ReportFactBoxVisibility)
        {
            Visible = false;
        }
        modify(Availability)
        {
            Visible = false;
        }
        modify(Assembly)
        {
            Visible = false;
        }
        modify(Purchases)
        {
            Visible = false;
        }
        modify(Sales)
        {
            Visible = false;
        }
        modify("Assembly/Production")
        {
            Visible = false;
        }
        modify(AssemblyProduction)
        {
            Visible = false;
        }
        modify(Inventory)
        {
            Visible = false;
        }
    }

    var
}