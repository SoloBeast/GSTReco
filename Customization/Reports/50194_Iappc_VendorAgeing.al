report 50194 "Vendor Ageing Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;

            column(CompanyName; recCompanyInfo.Name) { }
            column(Heading; txtHeading) { }
            column(UserID; UserId)
            { }
            column(TimeStamp; Format(CurrentDateTime))
            { }
            column(blnPrintDetails; Format(blnPrintDetails)) { }
            column(VendorNo; Vendor."No.") { }
            column(VendorName; Vendor.Name) { }
            column(MSMEStatus; Format(Vendor.MSME)) { }
            column(SlabCaption1; txtSlabCaption[1]) { }
            column(SlabCaption2; txtSlabCaption[2]) { }
            column(SlabCaption3; txtSlabCaption[3]) { }
            column(SlabCaption4; txtSlabCaption[4]) { }
            column(SlabCaption5; txtSlabCaption[5]) { }
            column(SlabCaption6; txtSlabCaption[6]) { }
            column(SlabCaption7; txtSlabCaption[7]) { }
            column(SlabCaption8; txtSlabCaption[8]) { }
            column(SlabCaption9; txtSlabCaption[9]) { }
            column(SlabCaption10; txtSlabCaption[10]) { }
            column(SlabCaption11; txtSlabCaption[11]) { }
            column(SlabCaption12; txtSlabCaption[12]) { }
            column(SlabCaption13; txtSlabCaption[13]) { }
            column(SlabCaption14; txtSlabCaption[14]) { }
            column(VendorCode; "No.") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Vendor_Posting_Group; "Vendor Posting Group") { }
            column(MSME; MSME) { }
            column(GL; cdVendorGL) { }
            column(txtGLName; txtGLName) { }
            column(Due_Date_Calc__Basis; "Due Date Calc. Basis") { }



            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemTableView = sorting("Vendor No.", "Posting Date", "Currency Code");
                CalcFields = "Remaining Amt. (LCY)", "Original Amt. (LCY)", "Original Amount", "Remaining Amount";

                column(DocumentDate; Format("Vendor Ledger Entry"."Posting Date")) { }
                column(DueDate; Format("Vendor Ledger Entry"."Due Date")) { }
                column(DocumentNo; "Vendor Ledger Entry"."External Document No.") { }
                column(DocumentAmount; "Vendor Ledger Entry"."Original Amt. (LCY)") { }
                column(CurrencyCode; "Vendor Ledger Entry"."Currency Code") { }
                column(DocumentAmountFCY; "Vendor Ledger Entry"."Original Amount") { }
                column(ExchangeRate; 0) { }
                column(AmountPendingFCY; "Vendor Ledger Entry"."Remaining Amount") { }
                column(FluctuationAmount; 0) { }
                column(OutstandingDays; intOverDueDays) { }
                column(Slab1; decSlabWiseAmount[1]) { }
                column(Slab2; decSlabWiseAmount[2]) { }
                column(Slab3; decSlabWiseAmount[3]) { }
                column(Slab4; decSlabWiseAmount[4]) { }
                column(Slab5; decSlabWiseAmount[5]) { }
                column(Slab6; decSlabWiseAmount[6]) { }
                column(Slab7; decSlabWiseAmount[7]) { }
                column(Slab8; decSlabWiseAmount[8]) { }
                column(Slab9; decSlabWiseAmount[9]) { }
                column(Slab10; decSlabWiseAmount[10]) { }
                column(Slab11; decSlabWiseAmount[11]) { }
                column(Slab12; decSlabWiseAmount[12]) { }
                column(Slab13; decSlabWiseAmount[13]) { }
                column(Slab14; decSlabWiseAmount[14]) { }
                column(TotalAmt; decTotalAmount) { }
                column(AmountPending; "Vendor Ledger Entry"."Remaining Amt. (LCY)") { }
                column(Document_Type; "Document Type") { }
                //Column(Document_Date; "Document Date") { }
                column(Document_Date; Format("Vendor Ledger Entry"."Document Date")) { }
                column(Narration; recPurchComLine.Comment) { }

                trigger OnPreDataItem()
                begin
                    "Vendor Ledger Entry".SetRange("Vendor No.", Vendor."No.");
                    "Vendor Ledger Entry".SetRange("Posting Date", 0D, dtAsOnDate);
                    "Vendor Ledger Entry".SetFilter("Date Filter", '..%1', dtAsOnDate);
                    "Vendor Ledger Entry".SetFilter("Remaining Amt. (LCY)", '<>%1', 0);
                end;

                trigger OnAfterGetRecord()
                begin
                    dtWorkingDate := "Vendor Ledger Entry"."Due Date";
                    intOverDueDays := dtAsOnDate - dtWorkingDate;

                    Clear(decSlabWiseAmount);
                    if dtWorkingDate > dtAsOnDate then
                        decSlabWiseAmount[1] := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                    else
                        if intOverDueDays > (intSlabLength * 12) then
                            decSlabWiseAmount[14] := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                        else
                            if intOverDueDays > (intSlabLength * 11) then
                                decSlabWiseAmount[13] := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                            else
                                if intOverDueDays > (intSlabLength * 10) then
                                    decSlabWiseAmount[12] := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                                else
                                    if intOverDueDays > (intSlabLength * 9) then
                                        decSlabWiseAmount[11] := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                                    else
                                        if intOverDueDays > (intSlabLength * 8) then
                                            decSlabWiseAmount[10] := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                                        else
                                            if intOverDueDays > (intSlabLength * 7) then
                                                decSlabWiseAmount[9] := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                                            else
                                                if intOverDueDays > (intSlabLength * 6) then
                                                    decSlabWiseAmount[8] := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                                                else
                                                    if intOverDueDays > (intSlabLength * 5) then
                                                        decSlabWiseAmount[7] := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                                                    else
                                                        if intOverDueDays > (intSlabLength * 4) then
                                                            decSlabWiseAmount[6] := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                                                        else
                                                            if intOverDueDays > (intSlabLength * 3) then
                                                                decSlabWiseAmount[5] := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                                                            else
                                                                if intOverDueDays > (intSlabLength * 2) then
                                                                    decSlabWiseAmount[4] := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                                                                else
                                                                    if intOverDueDays > (intSlabLength * 1) then
                                                                        decSlabWiseAmount[3] := "Vendor Ledger Entry"."Remaining Amt. (LCY)"
                                                                    else
                                                                        decSlabWiseAmount[2] := "Vendor Ledger Entry"."Remaining Amt. (LCY)";

                    decTotalAmount := decSlabWiseAmount[1] + decSlabWiseAmount[2] + decSlabWiseAmount[3] + decSlabWiseAmount[4] +
                                            decSlabWiseAmount[5] + decSlabWiseAmount[6] + decSlabWiseAmount[7] + decSlabWiseAmount[8] +
                                            decSlabWiseAmount[9] + decSlabWiseAmount[10] + decSlabWiseAmount[11] + decSlabWiseAmount[12] +
                                            decSlabWiseAmount[13] + decSlabWiseAmount[14];
                    recPurchComLine.Reset();
                    recPurchComLine.SetRange("No.", "Vendor Ledger Entry"."Document No.");
                    recPurchComLine.SetFilter("Document Type", '%1 |%2', recPurchComLine."Document Type"::"Posted Invoice", recPurchComLine."Document Type"::"Posted Credit Memo");
                    if not recPurchComLine.FindFirst() then
                        recPurchComLine.Init();


                end;
            }

            trigger OnPreDataItem()
            begin
                recCompanyInfo.GET;

                if dtAsOnDate = 0D then
                    Error('Enter As On Date to generate the report.');

                if intSlabLength = 0 then
                    intSlabLength := 30;

                IF blnPrintDetails THEN
                    txtHeading := 'Vendor Ageing Report Detailed As On ' + FORMAT(dtAsOnDate)
                ELSE
                    txtHeading := 'Vendor Ageing Report As On ' + FORMAT(dtAsOnDate);

                CLEAR(txtSlabCaption);
                txtSlabCaption[1] := 'Not Due';
                txtSlabCaption[2] := FORMAT((intSlabLength * 0) + 1) + ' to ' + FORMAT(intSlabLength * 1);
                txtSlabCaption[3] := FORMAT((intSlabLength * 1) + 1) + ' to ' + FORMAT(intSlabLength * 2);
                txtSlabCaption[4] := FORMAT((intSlabLength * 2) + 1) + ' to ' + FORMAT(intSlabLength * 3);
                txtSlabCaption[5] := FORMAT((intSlabLength * 3) + 1) + ' to ' + FORMAT(intSlabLength * 4);
                txtSlabCaption[6] := FORMAT((intSlabLength * 4) + 1) + ' to ' + FORMAT(intSlabLength * 5);
                txtSlabCaption[7] := FORMAT((intSlabLength * 5) + 1) + ' to ' + FORMAT(intSlabLength * 6);
                txtSlabCaption[8] := FORMAT((intSlabLength * 6) + 1) + ' to ' + FORMAT(intSlabLength * 7);
                txtSlabCaption[9] := FORMAT((intSlabLength * 7) + 1) + ' to ' + FORMAT(intSlabLength * 8);
                txtSlabCaption[10] := FORMAT((intSlabLength * 8) + 1) + ' to ' + FORMAT(intSlabLength * 9);
                txtSlabCaption[11] := FORMAT((intSlabLength * 9) + 1) + ' to ' + FORMAT(intSlabLength * 10);
                txtSlabCaption[12] := FORMAT((intSlabLength * 10) + 1) + ' to ' + FORMAT(intSlabLength * 11);
                txtSlabCaption[13] := FORMAT((intSlabLength * 11) + 1) + ' to ' + FORMAT(intSlabLength * 12);
                txtSlabCaption[14] := 'Above ' + FORMAT(intSlabLength * 12);

                if cdVendorNo <> '' then
                    Vendor.SetRange("No.", cdVendorNo);
            end;

            trigger OnAfterGetRecord()
            begin
                recVPG.Reset();
                recVPG.SetRange(Code, Vendor."Vendor Posting Group");
                if recVPG.FindFirst() then begin
                    cdVendorGL := recVPG."Payables Account";
                    txtGLName := recVPG.Description;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(dtAsOnDate; dtAsOnDate)
                    {
                        Caption = 'As On Date';
                        ApplicationArea = All;
                    }
                    field(intSlabLength; intSlabLength)
                    {
                        Caption = 'Period Length in Days';
                        ApplicationArea = all;
                    }
                    field(cdVendorNo; cdVendorNo)
                    {
                        Caption = 'Vendor No.';
                        ApplicationArea = all;
                        TableRelation = Vendor;
                    }
                    field(blnPrintDetails; blnPrintDetails)
                    {
                        Caption = 'Print Details';
                        ApplicationArea = all;
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            dtAsOnDate := Today;
            intSlabLength := 30;
        end;
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'Customization\Reports\50194_Iappc_VendorAgeing.rdl';
        }
    }

    var
        dtAsOnDate: Date;
        cdVendorNo: Code[20];
        intSlabLength: Integer;
        blnPrintDetails: Boolean;
        recCompanyInfo: Record "Company Information";
        txtHeading: Text;
        txtSlabCaption: array[14] of Text[30];
        decSlabWiseAmount: array[14] of Decimal;
        dtWorkingDate: Date;
        intOverDueDays: Integer;
        decTotalAmount: Decimal;
        recVPG: Record "Vendor Posting Group";
        cdVendorGL: Code[20];
        txtGLName: Text;
        recPurchComLine: Record "Purch. Comment Line";

}