report 50192 "Sales Order Status"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; txtHeading) { }
            column(CustomerName; "Sales Header"."Sell-to Customer Name") { }
            column(SalesPersonName; recSalesPerson.Name) { }
            column(OrderDate; Format("Sales Header"."Order Date")) { }
            column(OrderNo; "Sales Header"."No.") { }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");

                column(SalesQty; "Sales Line".Quantity) { }
                column(SalesAmount; "Sales Line"."Line Amount") { }
                column(RemQty; "Sales Line"."Outstanding Quantity") { }
                column(RemValue; "Sales Line"."Outstanding Amount") { }
            }

            trigger OnPreDataItem()
            begin
                recCompanyInfo.Get();
                txtHeading := 'Sales Order Status Report As On ' + Format(Today);
            end;

            trigger OnAfterGetRecord()
            begin
                if not recSalesPerson.Get("Sales Header"."Salesperson Code") then
                    recSalesPerson.Init();
            end;
        }
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'Customization\Reports\50192_Iappc_SalesOrderStatus.rdl';
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        txtHeading: Text;
        recSalesPerson: Record "Salesperson/Purchaser";
}