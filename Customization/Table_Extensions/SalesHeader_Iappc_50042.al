tableextension 50042 "Sales Header Ext." extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Internal Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Actual","Cancel";
        }
        field(60000; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60001; "Created At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60002; "Approved By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60003; "Approved At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60004; "Posted By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60005; "Posted At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70000; "Manually Closed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    procedure DeleteAll(var SalesHeaderToDelete: Record "Sales Header")
    var
        recSalesHeader: Record "Sales Header";
        recDocumentToDelete: Record "Sales Header";
    begin
        if not confirm('Do you want to delete the selected sales documents?', false) then
            exit;

        recSalesHeader.Reset();
        recSalesHeader.CopyFilters(SalesHeaderToDelete);
        if recSalesHeader.FindSet() then
            repeat
                recDocumentToDelete.Reset();
                recDocumentToDelete.SetRange("Document Type", recSalesHeader."Document Type");
                recDocumentToDelete.SetRange("No.", recSalesHeader."No.");
                recDocumentToDelete.FindFirst();
                recDocumentToDelete.Delete(true);
            until recSalesHeader.Next() = 0;

        Message('All the selected sales documents has been deleted.');
    end;

    var
}