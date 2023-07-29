page 50194 "GST Reco Error Log"
{
    ApplicationArea = all;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "Error Log";

    layout
    {
        area(Content)
        {
            repeater(logs)
            {
                field("Error Id"; Rec."Error Id")
                {
                    ApplicationArea = all;
                }
                field("GST Entry No"; Rec."GST Entry No")
                {
                    ApplicationArea = all;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = all;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Error Time"; Rec."Error Time")
                {
                    ApplicationArea = all;
                }
                field("Reco By"; Rec."Reco By")
                {
                    ApplicationArea = all;
                }
                field("Partially Matched"; Rec."Partially Matched")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}