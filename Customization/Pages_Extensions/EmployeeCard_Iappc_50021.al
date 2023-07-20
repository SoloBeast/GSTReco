pageextension 50021 "Employee Card Ext." extends "Employee Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Job Title")
        {
            field(Department; Rec.Department)
            {
                ApplicationArea = all;
            }
            field("Project Assigned"; Rec."Project Assigned")
            {
                ApplicationArea = all;
            }
        }
        modify(Pager)
        {
            Visible = false;
        }
        modify("Union Code")
        {
            Visible = false;
        }
        modify("Union Membership No.")
        {
            Visible = false;
        }
        modify(IBAN)
        {
            Visible = false;
        }
        modify("SWIFT Code")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(PayEmployee)
        {
            Visible = false;
        }
        modify("A&bsences")
        {
            Visible = false;
        }
        modify("F&unctions")
        {
            Visible = false;
        }
        modify("Absences by Ca&tegories")
        {
            Visible = false;
        }
    }

    var
}