report 50017 "Purchase Receipt"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Purchase Receipt';
    RDLCLayout = 'Customization\Reports\PurchaseReceipt_Iappc_50017.rdl';

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = SORTING("No.");

            column(CompanyName; recCompanyInfo.Name) { }
            column(CompanyLogo; recCompanyInfo.Picture) { }
            column(CompanyAddress; recLocation.Address) { }
            column(CompanyAddress1; recLocation."Address 2") { }
            column(CompanyCity; recLocation.City) { }
            column(CompanyPostCode; recLocation."Post Code") { }
            column(CompanyState; txtCompanyState) { }
            column(CompanyCountry; txtCompanyCountry) { }
            column(CompanyPhoneNo; recLocation."Phone No.") { }
            column(CompanyEmail; recLocation."E-Mail") { }
            column(CompanyCIN; recCompanyInfo."C.I.N. No.") { }
            column(CompanyPAN; recCompanyInfo."P.A.N. No.") { }
            column(CompanyGST; recLocation."GST Registration No.") { }
            column(CompanyStateCode; cdCompanyStateCode + ' (' + txtCompanyState + ')') { }
            column(ReceiptNo; "Purch. Rcpt. Header"."No.") { }
            column(ReceiptDate; Format("Purch. Rcpt. Header"."Posting Date")) { }
            column(GateEntryNo; cdGateEntryNo) { }
            column(GateEntryDate; Format(dtGateEntryDate)) { }
            column(VendorName; "Purch. Rcpt. Header"."Buy-from Vendor Name") { }
            column(VendorAddress; "Purch. Rcpt. Header"."Buy-from Address") { }
            column(VendorAddress1; "Purch. Rcpt. Header"."Buy-from Address 2") { }
            column(VendorCity; "Purch. Rcpt. Header"."Buy-from City") { }
            column(VendorPostCode; "Purch. Rcpt. Header"."Buy-from Post Code") { }
            column(VendorState; txtVendorState) { }
            column(VendorStateGSTCode; txtVendorStateGSTCode) { }
            column(VendorCountry; txtVendorCountry) { }
            column(VendorGST; "Purch. Rcpt. Header"."Vendor GST Reg. No.") { }
            column(OrderNo; "Purch. Rcpt. Header"."Order No.") { }
            column(OrderDate; Format("Purch. Rcpt. Header"."Order Date")) { }
            column(VendorShipmentNo; "Purch. Rcpt. Header"."Vendor Shipment No.") { }
            column(VendorShipmentDate; Format("Purch. Rcpt. Header"."Document Date")) { }
            column(Transporter; recShippingAgent.Name) { }
            column(ReceivedBy; "Purch. Rcpt. Header"."User ID") { }
            column(CreatedBy; "Purch. Rcpt. Header"."Created By") { }
            column(ApprovedBy; "Purch. Rcpt. Header"."Approved By") { }

            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) where(Quantity = filter(<> 0));
                DataItemLink = "Document No." = FIELD("No.");

                column(LineNo; "Purch. Rcpt. Line"."Line No.") { }
                column(SrNo; intSrNo) { }
                column(ItemNo; "Purch. Rcpt. Line"."No.") { }
                column(ItemDescription; "Purch. Rcpt. Line".Description) { }
                column(HSNSAC; "Purch. Rcpt. Line"."HSN/SAC Code") { }
                column(LineQuantity; "Purch. Rcpt. Line".Quantity) { }
                column(ItemUOM; "Purch. Rcpt. Line"."Unit of Measure Code") { }
                column(UnitRate; "Purch. Rcpt. Line"."Direct Unit Cost") { }
                column(LineAmount; Round("Purch. Rcpt. Line".Quantity * "Purch. Rcpt. Line"."Direct Unit Cost", 0.01)) { }

                trigger OnPreDataItem()
                begin
                    intSrNo := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    intSrNo += 1;
                end;
            }

            trigger OnPreDataItem()
            begin
                recCompanyInfo.Get();
                recCompanyInfo.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                recLocation.Get("Purch. Rcpt. Header"."Location Code");
                txtCompanyState := '';
                txtCompanyCountry := '';
                cdCompanyStateCode := '';
                if recState.Get(recLocation."State Code") then begin
                    txtCompanyState := recState.Description;
                    cdCompanyStateCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get(recLocation."Country/Region Code") then
                    txtCompanyCountry := recCountry.Name;

                txtVendorCountry := '';
                txtVendorState := '';
                recVendor.Get("Purch. Rcpt. Header"."Buy-from Vendor No.");
                if recState.Get(recVendor."State Code") then begin
                    txtVendorState := recState.Description;
                    txtVendorStateGSTCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get(recVendor."Country/Region Code") then
                    txtVendorCountry := recCountry.Name;

                if not recShippingAgent.Get("Purch. Rcpt. Header"."Shipping Agent Code") then
                    recShippingAgent.Init();

                cdGateEntryNo := '';
                dtGateEntryDate := 0D;
                recGateEntryAttachment.Reset();
                recGateEntryAttachment.SetRange("Receipt No.", "Purch. Rcpt. Header"."No.");
                if recGateEntryAttachment.FindFirst() then begin
                    recPostedGateEntry.Reset();
                    recPostedGateEntry.SetRange("Entry Type", recGateEntryAttachment."Entry Type");
                    recPostedGateEntry.SetRange("No.", recGateEntryAttachment."Gate Entry No.");
                    recPostedGateEntry.FindFirst();
                    cdGateEntryNo := recPostedGateEntry."No.";
                    dtGateEntryDate := recPostedGateEntry."Posting Date";
                end;
            end;
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        recLocation: Record Location;
        recState: Record State;
        recCountry: Record "Country/Region";
        txtCompanyState: Text[50];
        txtCompanyCountry: Text[50];
        cdCompanyStateCode: Code[2];
        txtVendorState: Text[50];
        txtVendorCountry: Text[50];
        recVendor: Record Vendor;
        intSrNo: Integer;
        recShippingAgent: Record "Shipping Agent";
        recGateEntryAttachment: Record "Posted Gate Entry Attachment";
        recPostedGateEntry: Record "Posted Gate Entry Header";
        cdGateEntryNo: Code[20];
        dtGateEntryDate: Date;
        txtVendorStateGSTCode: Text[20];
}