tableextension 50023 "Purchase Line Ext." extends "Purchase Line"
{
    fields
    {
        // Add changes to table fields here
        field(70001; "Indent No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Indent Header";
            Editable = false;
        }
        field(70002; "Indent Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Indent Line"."Line No." WHERE("Indent No." = FIELD("Indent No."));
            Editable = false;
        }
        field(70003; "Order Status"; Enum "Purchase Document Status")
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".Status where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Editable = false;
        }
        field(70004; "QC Pending"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70014; "Vendor Name"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Buy-from Vendor No.")));
        }
        field(71000; "Iappc TDS Section"; Code[20])
        {
            Caption = 'TDS Section';
            DataClassification = ToBeClassified;
            TableRelation = "Allowed Sections"."TDS Section" where("Vendor No" = field("Pay-to Vendor No."));

            trigger OnValidate()
            begin
                CalculateLineTDS(Rec);
            end;
        }
        field(71001; "TDS %"; Decimal)
        {
            Editable = false;
            DataClassification = ToBeClassified;
            MinValue = 0;
            DecimalPlaces = 2 : 2;
        }
        field(71002; "TDS Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            MinValue = 0;
            DecimalPlaces = 2 : 2;
        }
        field(71003; "TDS Base Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            MinValue = 0;
            DecimalPlaces = 2 : 2;
        }
        field(71004; "TDS to Post"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'TDS Amount';
            Editable = false;
            MinValue = 0;
            DecimalPlaces = 2 : 2;
        }
        field(71005; "Concessional Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Concessional Code".Code;

            trigger OnValidate()
            begin
                CalculateLineTDS(Rec);
            end;
        }
    }

    procedure CalculateTDSOnCreditMemo(recPurchaseHeader: Record "Purchase Header")
    var
        recPurchaseLine: Record "Purchase Line";
    begin
        if recPurchaseHeader."Document Type" in [recPurchaseHeader."Document Type"::"Return Order", recPurchaseHeader."Document Type"::"Credit Memo"] then begin
            recPurchaseLine.Reset();
            recPurchaseLine.SetRange("Document Type", recPurchaseHeader."Document Type");
            recPurchaseLine.SetRange("Document No.", recPurchaseHeader."No.");
            recPurchaseLine.SetFilter("TDS Section Code", '<>%1', '');
            if recPurchaseLine.FindFirst() then begin
                repeat
                    if recPurchaseLine."Line Amount" < 0 then
                        Error('You cannot deduct TDS for negative line amounts.\ Document Type=%1'',Document No.=%2,Line No.=%3.',
                        recPurchaseLine."Document Type", recPurchaseLine."Document No.", recPurchaseLine."Line No.");

                    CalculateLineTDS(recPurchaseLine);
                    recPurchaseLine.Modify();
                until recPurchaseLine.Next() = 0;
            end;
        end;
    end;

    procedure CalculateLineTDS(var PurchLine: Record "Purchase Line")
    var
        recTDSSetup: Record "Iappc TDS Setup";
        PurchHeader: Record "Purchase Header";
        recVendor: Record Vendor;
    begin
        PurchHeader.Reset();
        PurchHeader.SetRange("Document Type", PurchLine."Document Type");
        PurchHeader.SetRange("No.", PurchLine."Document No.");
        PurchHeader.FindFirst();
        if PurchHeader."Document Type" in [PurchHeader."Document Type"::"Return Order", PurchHeader."Document Type"::"Credit Memo"] then begin

            recVendor.Get(PurchLine."Pay-to Vendor No.");
            if PurchLine."Iappc TDS Section" <> '' then
                recVendor.TestField("Assessee Code");

            PurchLine."TDS Base Amount" := 0;
            PurchLine."TDS %" := 0;
            PurchLine."TDS Amount" := 0;
            PurchLine."TDS to Post" := 0;

            recTDSSetup.Reset();
            recTDSSetup.SetRange("TDS Section", PurchLine."Iappc TDS Section");
            recTDSSetup.SetRange("Assessee Code", recVendor."Assessee Code");
            recTDSSetup.SetRange("Concessional Code", PurchLine."Concessional Code");
            recTDSSetup.SetRange("Effective Date", 0D, PurchHeader."Posting Date");
            if recTDSSetup.FindFirst() then begin
                PurchLine."TDS Base Amount" := PurchLine."Line Amount" - PurchLine."Inv. Discount Amount";
                PurchLine."TDS %" := recTDSSetup."TDS %";
                PurchLine."TDS Amount" := Round(PurchLine."TDS Base Amount" * PurchLine."TDS %" / 100, 0.01);

                if PurchHeader."Document Type" in [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::"Return Order"] then
                    PurchLine."TDS to Post" := Round(PurchLine."TDS Amount" / PurchLine.Quantity * PurchLine."Qty. to Invoice", 0.01)
                else
                    PurchLine."TDS to Post" := PurchLine."TDS Amount";
            end;
        end;
    end;

    var
}