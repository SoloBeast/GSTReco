page 50199 GSTRDump
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = GSTRDump;
    Editable = false;
    SourceTableView = sorting("GSTIN Supplier");

    layout
    {
        area(Content)
        {
            repeater(GSTDump)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;

                }
                field("File Type."; Rec."File Type.")
                {
                    ApplicationArea = All;

                }
                field("GSTIN Supplier"; Rec."GSTIN Supplier")
                {
                    ApplicationArea = All;

                }
                field("Trade/Legal Name"; Rec."Trade/Legal Name")
                {
                    ApplicationArea = All;

                }
                field("Invoice No"; Rec."Invoice No")
                {
                    ApplicationArea = All;

                }
                field("Invoice Type"; Rec."Invoice Type")
                {
                    ApplicationArea = All;

                }
                field("Invoice Value"; Rec."Invoice Value")
                {
                    ApplicationArea = All;

                }
                field("Invocie Date"; Rec."Invocie Date")
                {
                    ApplicationArea = All;

                }
                field("Place of Supply"; Rec."Place of Supply")
                {
                    ApplicationArea = All;

                }
                field("Supply Attract Reverce Charge"; Rec."Supply Attract Reverce Charge")
                {
                    ApplicationArea = All;

                }
                field("Rate(%)"; Rec."Rate(%)")
                {
                    ApplicationArea = All;

                }
                field("Taxable Value"; Rec."Taxable Value")
                {
                    ApplicationArea = All;

                }
                field("Integrated Tax"; Rec."Integrated Tax")
                {
                    ApplicationArea = All;

                }
                field("Central Tax"; Rec."Central Tax")
                {
                    ApplicationArea = All;

                }
                field("State/UT Tax"; Rec."State/UT Tax")
                {
                    ApplicationArea = All;

                }
                field(Cess; Rec.Cess)
                {
                    ApplicationArea = All;

                }
                field("GSTR-1/IFF/GSTR-5 Date"; Rec."GSTR-1/IFF/GSTR-5 Date")
                {
                    ApplicationArea = All;

                }
                field("GSTR-1/IFF/GSTR-5 Period"; Rec."GSTR-1/IFF/GSTR-5 Period")
                {
                    ApplicationArea = All;

                }
                field("ITC Availability"; Rec."ITC Availability")
                {
                    ApplicationArea = All;

                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;

                }
                field("Applicable % of Tax Rate"; Rec."Applicable % of Tax Rate")
                {
                    ApplicationArea = All;

                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;

                }
                field(IRN; Rec.IRN)
                {
                    ApplicationArea = All;

                }
                field("IRN Date"; Rec."IRN Date")
                {
                    ApplicationArea = All;

                }
                field("Note Type"; Rec."Note Type")
                {
                    ApplicationArea = All;

                }
                field("Note Type1"; Rec."Note Type1")
                {
                    ApplicationArea = All;

                }
                field("Icegate Reference Date"; Rec."Icegate Reference Date")
                {
                    ApplicationArea = All;

                }
                field("Port Code"; Rec."Port Code")
                {
                    ApplicationArea = All;

                }
                field("Amended (Yes)"; Rec."Amended (Yes)")
                {
                    ApplicationArea = All;

                }
                field("Taxable Amount"; Rec."Taxable Amount")
                {
                    ApplicationArea = All;

                }
                field(Match; Rec.Match)
                {
                    ApplicationArea = all;
                }


            }
        }
    }
}