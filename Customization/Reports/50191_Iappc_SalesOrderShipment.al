report 50191 "Sales Order Shipment"
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

                dataitem(Integer; Integer)
                {
                    column(ShipmentLineNo; Integer.Number) { }
                    column(QtyInvoiced; recShipmentData.Quantity) { }
                    column(QtyValue; Round(recShipmentData.Quantity * "Sales Line"."Unit Price", 0.01)) { }
                    column(RemQty; decRemQty) { }
                    column(RemValue; decRemValue) { }

                    trigger OnPreDataItem()
                    begin
                        recShipmentData.Reset();
                        Integer.SetRange(Number, 1, recShipmentData.Count);
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        recShipmentData.Reset();
                        recShipmentData.SetRange("Line No.", Integer.Number);
                        recShipmentData.FindFirst();

                        decRemQty := decRemQty - recShipmentData.Quantity;
                        decRemValue := Round(decRemQty * "Sales Line"."Unit Price", 0.01);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    recShipmentData.Reset();
                    recShipmentData.DeleteAll();
                    intLineNo := 0;
                    decRemQty := "Sales Line".Quantity;
                    decRemValue := "Sales Line"."Line Amount";

                    recSalesShipment.Reset();
                    recSalesShipment.SetRange("Order No.", "Sales Header"."No.");
                    if recSalesShipment.FindFirst() then begin
                        repeat
                            recSalesShipmentLine.Reset();
                            recSalesShipmentLine.SetRange("Document No.", recSalesShipment."No.");
                            recSalesShipmentLine.SetRange("Line No.", "Sales Line"."Line No.");
                            recSalesShipmentLine.SetFilter(Quantity, '<>%1', 0);
                            if recSalesShipmentLine.FindFirst() then begin
                                recShipmentData.Init();
                                intLineNo += 1;
                                recShipmentData."Line No." := intLineNo;
                                recShipmentData.Quantity := recSalesShipmentLine.Quantity;
                                recShipmentData.Insert();
                            end;
                        until recSalesShipment.Next() = 0;
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                recCompanyInfo.Get();
                txtHeading := 'Sales Order Shipment Report As On ' + Format(Today);
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
            LayoutFile = 'Customization\Reports\50191_Iappc_SalesOrderShipment.rdl';
        }
    }

    var
        recCompanyInfo: Record "Company Information";
        txtHeading: Text;
        recSalesPerson: Record "Salesperson/Purchaser";
        recShipmentData: Record "Item Journal Line" temporary;
        intLineNo: Integer;
        recSalesShipment: Record "Sales Shipment Header";
        recSalesShipmentLine: Record "Sales Shipment Line";
        decRemQty: Decimal;
        decRemValue: Decimal;
}