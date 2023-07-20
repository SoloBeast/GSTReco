table 50001 "Indent Header"
{
    DataClassification = ToBeClassified;
    CompressionType = Page;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Date; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code where("Use As In-Transit" = const(false));
        }
        field(4; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(5; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(6; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Status"; Option)
        {
            OptionMembers = "Open","Pending Approval","Approved";
            Editable = false;
        }
        field(8; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(9; "Last Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Submitted At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Submitted By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Approved / Rejected At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Approved / Rejected By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        recIndentHeader: Record "Indent Header";
        recInventorySetup: Record "Inventory Setup";
        cuNoSeriesMgt: Codeunit NoSeriesManagement;
        recIndentLine: Record "Indent Line";

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            recInventorySetup.GET;
            recInventorySetup.TESTFIELD("Indent Nos.");
            cuNoSeriesMgt.InitSeries(recInventorySetup."Indent Nos.", xRec."No. Series", Date, "No.", "No. Series");
        END;
        Date := TODAY;
        "Created By" := USERID;
    end;

    trigger OnModify()
    begin
        Rec.TestField(Status, Rec.Status::Open);
    end;

    trigger OnDelete()
    begin
        Rec.TestField(Status, Rec.Status::Open);

        recIndentLine.Reset();
        recIndentLine.SetRange("Indent No.", Rec."No.");
        if recIndentLine.FindFirst() then
            recIndentLine.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

    procedure AssistEdit(OldIndentHeader: Record "Indent Header"): Boolean
    var
    begin
        //with recIndentHeader do begin
        recIndentHeader.COPY(Rec);
        recInventorySetup.GET;
        recInventorySetup.TestField("Indent Nos.");
        IF cuNoSeriesMgt.SelectSeries(recInventorySetup."Indent Nos.", OldIndentHeader."No. Series", recIndentHeader."No. Series") THEN BEGIN
            cuNoSeriesMgt.SetSeries(recIndentHeader."No.");
            Rec := recIndentHeader;
            EXIT(TRUE);
        END;
        //end;
    end;

    procedure SubmitForApproval()
    var
    begin
        if Rec.Status <> Rec.Status::Open then
            exit;
        IF NOT CONFIRM('Do you want to submit the indent for approval?', FALSE) THEN
            EXIT;

        Rec.TESTFIELD("Location Code");
        Rec.TESTFIELD("Shortcut Dimension 1 Code");

        recIndentLine.RESET;
        recIndentLine.SETRANGE("Indent No.", Rec."No.");
        IF recIndentLine.FINDFIRST THEN begin
            REPEAT
                recIndentLine.TESTFIELD("No.");
                recIndentLine.TESTFIELD(Quantity);

                recIndentLine.Date := Rec.Date;
                recIndentLine."Location Code" := Rec."Location Code";
                recIndentLine."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                recIndentLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                recIndentLine."Created By" := Rec."Created By";
                recIndentLine.Status := recIndentLine.Status::"Pending Approval";
                recIndentLine."Approved Quantity" := recIndentLine.Quantity;
                recIndentLine.MODIFY;
            UNTIL recIndentLine.NEXT = 0;
        end ELSE
            ERROR('Nothing to submit');

        Rec."Submitted At" := CurrentDateTime;
        Rec."Submitted By" := UserId;
        Rec.Status := Rec.Status::"Pending Approval";
        Rec.MODIFY;
        MESSAGE('The indent is successfully submitted for approval.');
    end;


    procedure Approve(UserRemarks: Text[250])
    var
    begin
        if Rec.Status <> Rec.Status::"Pending Approval" then
            exit;
        IF NOT CONFIRM('Do you want to approve the indent?', FALSE) THEN
            EXIT;

        IF UserRemarks = '' THEN
            ERROR('Enter the approval remarks.');

        recIndentLine.RESET;
        recIndentLine.SETRANGE("Indent No.", Rec."No.");
        IF recIndentLine.FINDFIRST THEN begin
            REPEAT
                recIndentLine."Remaining Quantity" := recIndentLine."Approved Quantity";
                recIndentLine."Approved / Rejected At" := CurrentDateTime;
                recIndentHeader."Approved / Rejected By" := UserId;
                recIndentLine.Status := recIndentLine.Status::Approved;
                recIndentLine.MODIFY;
            UNTIL recIndentLine.NEXT = 0;
        end;

        Rec."Last Remarks" := UserRemarks;
        Rec."Approved / Rejected At" := CurrentDateTime;
        Rec."Approved / Rejected By" := UserId;
        Rec.Status := Rec.Status::Approved;
        Rec.MODIFY;
        MESSAGE('The indent is successfully approved.');
    end;

    procedure Reject(UserRemarks: Text[250])
    var
    begin
        if Rec.Status <> Rec.Status::"Pending Approval" then
            exit;
        IF NOT CONFIRM('Do you want to reject the indent?', FALSE) THEN
            EXIT;

        IF UserRemarks = '' THEN
            ERROR('Enter the rejection remarks.');

        recIndentLine.RESET;
        recIndentLine.SETRANGE("Indent No.", Rec."No.");
        IF recIndentLine.FINDFIRST THEN begin
            REPEAT
                recIndentLine.Status := recIndentLine.Status::Open;
                recIndentLine.MODIFY;
            UNTIL recIndentLine.NEXT = 0;
        end;

        Rec."Last Remarks" := UserRemarks;
        Rec."Approved / Rejected At" := CurrentDateTime;
        Rec."Approved / Rejected By" := UserId;
        Rec.Status := Rec.Status::Open;
        Rec.MODIFY;
        MESSAGE('The indent is successfully rejected.');
    end;
}