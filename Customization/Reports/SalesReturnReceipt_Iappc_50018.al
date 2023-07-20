report 50018 "Sales Return Receipt"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Sales Return Receipt';
    RDLCLayout = 'Customization\Reports\SalesReturnReceipt_Iappc_50018.rdl';

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
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
            column(CustomerName; "Sales Cr.Memo Header"."Bill-to Name") { }
            column(CustomerAddress; "Sales Cr.Memo Header"."Bill-to Address") { }
            column(CustomerAddress1; "Sales Cr.Memo Header"."Bill-to Address 2") { }
            column(CustomerCity; "Sales Cr.Memo Header"."Bill-to City") { }
            column(CustomerPostCode; "Sales Cr.Memo Header"."Bill-to Post Code") { }
            column(CustomerState; txtCustomerState) { }
            column(CustomerCountry; txtCustomerCountry) { }
            column(CustomerGST; "Sales Cr.Memo Header"."Customer GST Reg. No.") { }
            column(OrderNo; "Sales Cr.Memo Header"."External Document No.") { }
            column(OrderDate; Format("Sales Cr.Memo Header"."Document Date")) { }
            column(Transporter; recShippingAgent.Name) { }
            column(ReceivedBy; "Sales Cr.Memo Header"."User ID") { }

            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) where(Quantity = filter(<> 0));
                DataItemLink = "Document No." = FIELD("No.");

                column(LineNo; "Sales Cr.Memo Line"."Line No.") { }
                column(SrNo; intSrNo) { }
                column(ItemNo; "Sales Cr.Memo Line"."No.") { }
                column(ItemDescription; "Sales Cr.Memo Line".Description) { }
                column(HSNSAC; "Sales Cr.Memo Line"."HSN/SAC Code") { }
                column(LineQuantity; "Sales Cr.Memo Line".Quantity) { }
                column(ItemUOM; "Sales Cr.Memo Line"."Unit of Measure Code") { }

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
                recLocation.Get("Sales Cr.Memo Header"."Location Code");
                txtCompanyState := '';
                txtCompanyCountry := '';
                cdCompanyStateCode := '';
                if recState.Get(recLocation."State Code") then begin
                    txtCompanyState := recState.Description;
                    cdCompanyStateCode := recState."State Code (GST Reg. No.)";
                end;
                if recCountry.Get(recLocation."Country/Region Code") then
                    txtCompanyCountry := recCountry.Name;

                txtCustomerCountry := '';
                txtCustomerState := '';
                if recState.Get("Sales Cr.Memo Header"."GST Bill-to State Code") then
                    txtCustomerState := recState.Description;
                if recCountry.Get("Sales Cr.Memo Header"."Bill-to Country/Region Code") then
                    txtCustomerCountry := recCountry.Name;

                if not recShippingAgent.Get("Sales Cr.Memo Header"."Shipping Agent Code") then
                    recShippingAgent.Init();
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
        txtCustomerState: Text[50];
        txtCustomerCountry: Text[50];
        intSrNo: Integer;
        recShippingAgent: Record "Shipping Agent";
}