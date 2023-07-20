report 50019 "Posted Transfer Receipt"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Transfer Receipt';
    RDLCLayout = 'Customization\Reports\TransferReceipt_Iappc_50019.rdl';

    dataset
    {
        dataitem("Transfer Receipt Header"; "Transfer Receipt Header")
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
            column(VendorName; "Transfer Receipt Header"."Transfer-from Name") { }
            column(VendorAddress; "Transfer Receipt Header"."Transfer-from Address") { }
            column(VendorAddress1; "Transfer Receipt Header"."Transfer-from Address 2") { }
            column(VendorCity; "Transfer Receipt Header"."Transfer-from City") { }
            column(VendorPostCode; "Transfer Receipt Header"."Transfer-from Post Code") { }
            column(VendorState; txtLocationState) { }
            column(VendorCountry; txtLocationCountry) { }
            column(VendorGST; recLocationFrom."GST Registration No.") { }
            column(OrderNo; "Transfer Receipt Header"."Transfer Order No.") { }
            column(OrderDate; Format("Transfer Receipt Header"."Transfer Order Date")) { }
            column(VendorShipmentNo; "Transfer Receipt Header"."External Document No.") { }
            column(VendorShipmentDate; Format("Transfer Receipt Header"."Shipment Date")) { }
            column(Transporter; recShippingAgent.Name) { }
            column(ReceivedBy; recValueEntry."User ID") { }

            dataitem("Transfer Receipt Line"; "Transfer Receipt Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) where(Quantity = filter(<> 0));
                DataItemLink = "Document No." = FIELD("No.");

                column(SrNo; intSrNo) { }
                column(ItemNo; "Transfer Receipt Line"."Item No.") { }
                column(ItemDescription; "Transfer Receipt Line".Description) { }
                column(HSNSAC; "Transfer Receipt Line"."HSN/SAC Code") { }
                column(LineQuantity; "Transfer Receipt Line".Quantity) { }
                column(ItemUOM; "Transfer Receipt Line"."Unit of Measure Code") { }

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
                recLocation.Get("Transfer Receipt Header"."Transfer-to Code");
                txtCompanyState := '';
                txtCompanyCountry := '';
                cdCompanyStateCode := '';
                if recState.Get(recLocation."State Code") then begin
                    txtCompanyState := recState.Description;
                    cdCompanyStateCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get(recLocation."Country/Region Code") then
                    txtCompanyCountry := recCountry.Name;

                txtLocationCountry := '';
                txtLocationState := '';
                recLocationFrom.Get("Transfer Receipt Header"."Transfer-from Code");
                if recState.Get(recLocationFrom."State Code") then
                    txtLocationState := recState.Description;
                if recCountry.Get(recLocationFrom."Country/Region Code") then
                    txtLocationCountry := recCountry.Name;

                if not recShippingAgent.Get("Transfer Receipt Header"."Shipping Agent Code") then
                    recShippingAgent.Init();

                recValueEntry.Reset();
                recValueEntry.SetRange("Document No.", "Transfer Receipt Header"."No.");
                recValueEntry.FindFirst();
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
        txtLocationState: Text[50];
        txtLocationCountry: Text[50];
        recLocationFrom: Record Location;
        intSrNo: Integer;
        recShippingAgent: Record "Shipping Agent";
        recValueEntry: Record "Value Entry";
}