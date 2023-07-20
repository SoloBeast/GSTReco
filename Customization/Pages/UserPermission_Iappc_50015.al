page 50015 "User Permissions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "User Permission";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(UserFilter)
            {
                Caption = 'User Filter';
                field(cdUserID; cdUserID)
                {
                    Caption = 'User ID';
                    ApplicationArea = all;
                    TableRelation = User;

                    trigger OnValidate()
                    begin
                        if not recUser.Get(cdUserID) then
                            Error('Invalid User id');
                        cdUserID := recUser."User Name";
                        UpdateFilters();
                    end;
                }
            }
            repeater(Permissions)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Sub Type"; Rec."Sub Type")
                {
                    ApplicationArea = All;
                }
                field("Sub Type Description"; Rec."Sub Type Description")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document Type Description"; Rec."Document Type Description")
                {
                    ApplicationArea = All;
                }
                field("Allow Creation"; Rec."Allow Creation")
                {
                    ApplicationArea = All;
                }
                field("Allow Modification"; Rec."Allow Modification")
                {
                    ApplicationArea = All;
                }
                field("Allow Deletion"; Rec."Allow Deletion")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(InsertPermissionSet)
            {
                Caption = 'Insert Permission Set';
                ApplicationArea = all;
                Image = Insert;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if cdUserID = '' then
                        Error('Select user id to insert permission.');

                    Clear(cuUserPermission);
                    cuUserPermission.FillUserPermission(cdUserID);
                    Message('Permission inserted for the selected user.');
                    cdUserID := '';
                    UpdateFilters();
                end;
            }
            action(AllowAll)
            {
                Caption = 'Allow All';
                ApplicationArea = all;
                Image = Administration;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Clear(cuUserPermission);
                    cuUserPermission.AllowAllPermission(cdUserID);
                    Message('All the permissions has been assigned to the selected user.');
                    cdUserID := '';
                    UpdateFilters();
                end;
            }
            action(DeleteUserPermission)
            {
                Caption = 'Delete User Permission';
                ApplicationArea = all;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if cdUserID = '' then
                        Error('Select user id to delete permission.');

                    Clear(cuUserPermission);
                    cuUserPermission.DeleteUserPermission(cdUserID);
                    cdUserID := '';
                    Message('User permission deleted for the selected user.');
                    UpdateFilters();
                end;
            }
        }
    }

    local procedure UpdateFilters()
    var
    begin
        Rec.Reset();
        if cdUserID <> '' then
            Rec.SetRange("User ID", cdUserID);
        CurrPage.Update(false);
    end;

    var
        cdUserID: Code[50];
        recUser: Record User;
        cuUserPermission: Codeunit "Iappc User Permission";
}