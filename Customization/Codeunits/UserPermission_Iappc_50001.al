codeunit 50001 "Iappc User Permission"
{
    trigger OnRun()
    begin

    end;

    //User Permission Management
    [EventSubscriber(ObjectType::Table, 2000000120, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure DeletePermissionOnUserDeletion(var Rec: Record User)
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", Rec."User Name");
        if recUserPermission.FindSet() then
            recUserPermission.DeleteAll();
    end;

    [EventSubscriber(ObjectType::Page, Page::"User Card", 'OnAfterValidateEvent', 'Windows User Name', true, true)]
    local procedure InsertPermissionOnUserCreation(var Rec: Record User)
    begin
        if Rec."User Name" <> '' then
            FillUserPermission(Rec."User Name");
    end;

    //Check G/L Account Permision
    /*
    [EventSubscriber(ObjectType::Table, 15, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckGLInsertPermission(var Rec: Record "G/L Account")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 1);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create G/L Account, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 15, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckGLModifyPermission(var Rec: Record "G/L Account")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 1);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify G/L Account, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 15, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckGLDeletePermission(var Rec: Record "G/L Account")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 1);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete G/L Account, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 15, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckGLRenamePermission(var Rec: Record "G/L Account")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 1);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename G/L Account, contact your system administrator.');
        end;
    end;

    //Check Customer Permission
    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckCustomerInsertPermission(var Rec: Record Customer)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 2);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Customer, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckCustomerModifyPermission(var Rec: Record Customer)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 2);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Customer, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckCustomerDeletePermission(var Rec: Record Customer)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 2);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Customer, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckCustomerRenamePermission(var Rec: Record Customer)
    begin
        Error('Rename is not allowed.');

        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 2);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Customer, contact your system administrator.');
        end;
    end;

    //Check Vendor Permission
    [EventSubscriber(ObjectType::Table, 23, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckVendorInsertPermission(var Rec: Record Vendor)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 3);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Vendor, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 23, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckVendorModifyPermission(var Rec: Record Vendor)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 3);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Vendor, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 23, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckVendorDeletePermission(var Rec: Record Vendor)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 3);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Vendor, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 23, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckVendorRenamePermission(var Rec: Record Vendor)
    begin
        Error('Rename is not allowed.');

        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 3);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Vendor, contact your system administrator.');
        end;
    end;

    //Check Item Permission
    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckItemInsertPermission(var Rec: Record Item)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 4);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Item, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckItemModifyPermission(var Rec: Record Item)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 4);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Item, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckItemDeletePermission(var Rec: Record Item)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 4);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Item, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckItemRenamePermission(var Rec: Record Item)
    begin
        Error('Rename is not allowed.');

        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 4);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Item, contact your system administrator.');
        end;
    end;

    //Item Variant
    [EventSubscriber(ObjectType::Table, 5401, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckItemVariantInsertPermission(var Rec: Record "Item Variant")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 4);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Item Variant, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5401, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckItemVariantModifyPermission(var Rec: Record "Item Variant")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 4);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Item Variant, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5401, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckItemVariantDeletePermission(var Rec: Record "Item Variant")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 4);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Item Variant, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5401, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckItemVariantRenamePermission(var Rec: Record "Item Variant")
    begin
        Error('Rename is not allowed.');

        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 4);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Item Variant, contact your system administrator.');
        end;
    end;

    //Check Bank Account Permission
    [EventSubscriber(ObjectType::Table, 270, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckBankAccountInsertPermission(var Rec: Record "Bank Account")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 5);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Bank Account, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 270, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckBankAccountModifyPermission(var Rec: Record "Bank Account")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 5);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Bank Account, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 270, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckBankAccountDeletePermission(var Rec: Record "Bank Account")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 5);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Bank Account, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 270, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckBankAccountRenamePermission(var Rec: Record "Bank Account")
    begin
        Error('Rename is not allowed.');

        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 5);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Bank Account, contact your system administrator.');
        end;
    end;

    //Check Dimension Permission
    [EventSubscriber(ObjectType::Table, 348, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckDimensionInsertPermission(var Rec: Record Dimension)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 6);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Dimension, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 348, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckDimensionModifyPermission(var Rec: Record Dimension)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 6);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Dimension, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 348, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckDimensionDeletePermission(var Rec: Record Dimension)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 6);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Dimension, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 348, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckDimensionRenamePermission(var Rec: Record Dimension)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 6);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Dimension, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 349, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckDimensionValueInsertPermission(var Rec: Record "Dimension Value")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 6);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Dimension Value, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 349, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckDimensionValueModifyPermission(var Rec: Record "Dimension Value")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 6);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Dimension Value, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 349, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckDimensionValueDeletePermission(var Rec: Record "Dimension Value")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 6);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Dimension Value, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 349, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckDimensionValueRenamePermission(var Rec: Record "Dimension Value")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 6);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Dimension Value, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckEmployeeInsertPermission(var Rec: Record Employee)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 7);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Employee, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckEmployeeModifyPermission(var Rec: Record Employee)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 7);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Employee, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckEmployeeDeletePermission(var Rec: Record Employee)
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 7);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Employee, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckEmployeeRenamePermission(var Rec: Record Employee)
    begin
        Error('Rename is not allowed.');

        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 7);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Employee, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5600, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckFAInsertPermission(var Rec: Record "Fixed Asset")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Fixed Asset, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5600, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckFAModifyPermission(var Rec: Record "Fixed Asset")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Fixed Asset, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5600, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckFADeletePermission(var Rec: Record "Fixed Asset")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Fixed Asset, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5600, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckFARenamePermission(var Rec: Record "Fixed Asset")
    begin
        Error('Rename is not allowed.');

        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Fixed Asset, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5612, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckFADepBookInsertPermission(var Rec: Record "FA Depreciation Book")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Fixed Asset, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5612, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckFADepBookModifyPermission(var Rec: Record "FA Depreciation Book")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Fixed Asset, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5612, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckFADepBookDeletePermission(var Rec: Record "FA Depreciation Book")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Fixed Asset, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5612, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckFADepBookRenamePermission(var Rec: Record "FA Depreciation Book")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Fixed Asset, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000771, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckBOMHeaderInsertPermission(var Rec: Record "Production BOM Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 9);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Prod. BOM, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000771, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckBOMHeaderModifyPermission(var Rec: Record "Production BOM Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 9);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Prod. BOM, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000771, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckBOMHeaderDeletePermission(var Rec: Record "Production BOM Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 9);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Prod. BOM, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000771, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckBOMHeaderRenamePermission(var Rec: Record "Production BOM Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 9);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Prod. BOM, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000772, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckBOMLineInsertPermission(var Rec: Record "Production BOM Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 9);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Prod. BOM, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000772, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckBOMLineModifyPermission(var Rec: Record "Production BOM Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 9);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Prod. BOM, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000772, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckBOMLineDeletePermission(var Rec: Record "Production BOM Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 9);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Prod. BOM, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000772, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckBOMLineRenamePermission(var Rec: Record "Production BOM Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 9);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Prod. BOM, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000763, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckRoutingHeaderInsertPermission(var Rec: Record "Routing Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 10);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Prod. Routing, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000763, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckRoutingHeaderModifyPermission(var Rec: Record "Routing Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 10);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Prod. Routing, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000763, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckRoutingHeaderDeletePermission(var Rec: Record "Routing Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 10);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Prod. Routing, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000763, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckRoutingHeaderRenamePermission(var Rec: Record "Routing Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 10);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Prod. Routing, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000764, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckRoutingLineInsertPermission(var Rec: Record "Routing Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 10);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Prod. Routing, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000764, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckRoutingLineModifyPermission(var Rec: Record "Routing Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 10);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Prod. Routing, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000764, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckRoutingLineDeletePermission(var Rec: Record "Routing Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 10);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Prod. Routing, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000764, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckRoutingLineRenamePermission(var Rec: Record "Routing Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Master);
            recUserPermission.SetRange("Sub Type", 10);
            recUserPermission.SetRange("Document Type", 0);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Prod. Routing, contact your system administrator.');
        end;
    end;

    //Check Sales Document Permision
    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckSalesDocInsertPermission(var Rec: Record "Sales Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 1);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Sales %1, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckSalesDocModifyPermission(var Rec: Record "Sales Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 1);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Sales %1, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckSalesDocDeletePermission(var Rec: Record "Sales Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 1);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Sales %1, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckSalesDocRenamePermission(var Rec: Record "Sales Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 1);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Sales %1, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckSalesDocLineInsertPermission(var Rec: Record "Sales Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 1);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Sales %1 Line, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckSalesDocLineModifyPermission(var Rec: Record "Sales Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 1);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Sales %1 Line, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckSalesDocLineDeletePermission(var Rec: Record "Sales Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 1);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Sales %1 Line, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckSalesDocLineRenamePermission(var Rec: Record "Sales Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 1);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Sales %1 Line, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    //Check Purchase Document Permision
    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckPurchaseDocInsertPermission(var Rec: Record "Purchase Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 2);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Purchase %1, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPurchaseDocModifyPermission(var Rec: Record "Purchase Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 2);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Purchase %1, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPurchaseDocDeletePermission(var Rec: Record "Purchase Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 2);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Purchase %1, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckPurchaseDocRenamePermission(var Rec: Record "Purchase Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 2);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Purchase %1, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckPurchaseDocLineInsertPermission(var Rec: Record "Purchase Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 2);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Purchase %1 Line, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPurchaseDocLineModifyPermission(var Rec: Record "Purchase Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 2);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Purchase %1 Line, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPurchaseDocLineDeletePermission(var Rec: Record "Purchase Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 2);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Purchase %1 Line, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckPurchaseDocLineRenamePermission(var Rec: Record "Purchase Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 2);
            if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then
                recUserPermission.SetRange("Document Type", 1);
            if Rec."Document Type" = Rec."Document Type"::Quote then
                recUserPermission.SetRange("Document Type", 2);
            if Rec."Document Type" = Rec."Document Type"::Order then
                recUserPermission.SetRange("Document Type", 3);
            if Rec."Document Type" = Rec."Document Type"::Invoice then
                recUserPermission.SetRange("Document Type", 4);
            if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                recUserPermission.SetRange("Document Type", 5);
            if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                recUserPermission.SetRange("Document Type", 6);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Purchase %1 Line, contact your system administrator.', Format(Rec."Document Type"));
        end;
    end;

    //Check Transfer Document Permision
    [EventSubscriber(ObjectType::Table, 5740, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckTransferDocInsertPermission(var Rec: Record "Transfer Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 3);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create the Transfer Order, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5740, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckTransferDocModifyPermission(var Rec: Record "Transfer Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 3);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Transfer Order, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5740, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckTransferDocDeletePermission(var Rec: Record "Transfer Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 3);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Transfer Order, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5740, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckTransferDocRenamePermission(var Rec: Record "Transfer Header")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 3);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Transfer Order, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5741, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckTransferDocLineInsertPermission(var Rec: Record "Transfer Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 3);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Transfer Line, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5741, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckTransferDocLineModifyPermission(var Rec: Record "Transfer Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 3);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Transfer Line, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5741, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckTransferDocLineDeletePermission(var Rec: Record "Transfer Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 3);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Transfer Line, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5741, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckTransferDocLineRenamePermission(var Rec: Record "Transfer Line")
    begin
        if not Rec.IsTemporary then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 3);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Transfer Line, contact your system administrator.');
        end;
    end;

    //Check Production Document Permision
    [EventSubscriber(ObjectType::Table, 5405, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckProductionDocInsertPermission(var Rec: Record "Production Order")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create %1 Production Order, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5405, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckProductionDocModifyPermission(var Rec: Record "Production Order")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify %1 Production Order, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5405, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckProductionDocDeletePermission(var Rec: Record "Production Order")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete %1 Production Order, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5405, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckProductionDocRenamePermission(var Rec: Record "Production Order")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename %1 Production Order, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5406, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckProductionDocLineInsertPermission(var Rec: Record "Prod. Order Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create %1 Production Order Line, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5406, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckProductionDocLineModifyPermission(var Rec: Record "Prod. Order Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify %1 Production Order Line, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5406, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckProductionDocLineDeletePermission(var Rec: Record "Prod. Order Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete %1 Production Order Line, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5406, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckProductionDocLineRenamePermission(var Rec: Record "Prod. Order Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename %1 Production Order Line, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5407, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckProdComDocInsertPermission(var Rec: Record "Prod. Order Component")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create %1 Production Order Component Line, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5407, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckProdComDocModifyPermission(var Rec: Record "Prod. Order Component")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify %1 Production Order Component Line, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5407, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckProdComDocDeletePermission(var Rec: Record "Prod. Order Component")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete %1 Production Order Component Line, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5407, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckProdComDocRenamePermission(var Rec: Record "Prod. Order Component")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename %1 Production Order Component Line, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5409, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckProdDocRoutingInsertPermission(var Rec: Record "Prod. Order Routing Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create %1 Production Order Routing Line, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5409, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckProdDocRoutingModifyPermission(var Rec: Record "Prod. Order Routing Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify %1 Production Order Routing Line, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5409, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckProdDocRoutingDeletePermission(var Rec: Record "Prod. Order Routing Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete %1 Production Order Routing Line, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 5409, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckProdDocRoutingRenamePermission(var Rec: Record "Prod. Order Routing Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        if Rec.Status = Rec.Status::Simulated then
            recUserPermission.SetRange("Document Type", 1);
        if Rec.Status = Rec.Status::Planned then
            recUserPermission.SetRange("Document Type", 2);
        if Rec.Status = Rec.Status::"Firm Planned" then
            recUserPermission.SetRange("Document Type", 3);
        if Rec.Status = Rec.Status::Released then
            recUserPermission.SetRange("Document Type", 4);
        if Rec.Status = Rec.Status::Finished then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename %1 Production Order Routing Line, contact your system administrator.', Format(Rec.Status));
    end;

    [EventSubscriber(ObjectType::Table, 900, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckAssemblyDocInsertPermission(var Rec: Record "Assembly Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 5);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create Assembly Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 900, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckAssemblyDocModifyPermission(var Rec: Record "Assembly Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 5);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Assembly Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 900, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckAssemblyDocDeletePermission(var Rec: Record "Assembly Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 5);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Assembly Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 900, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckAssemblyDocRenamePermission(var Rec: Record "Assembly Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 5);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename Assembly Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 901, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckAssemblyDocLineInsertPermission(var Rec: Record "Assembly Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 5);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create Assembly Line, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 901, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckAssemblyDocLineModifyPermission(var Rec: Record "Assembly Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 5);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Assembly Line, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 901, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckAssemblyDocLineDeletePermission(var Rec: Record "Assembly Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 5);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Assembly Line, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 901, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckAssemblyDocLineRenamePermission(var Rec: Record "Assembly Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 5);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename Assembly Line, contact your system administrator.');
    end;

    /*
    [EventSubscriber(ObjectType::Table, 50003, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckRequisitionInsertPermission(var Rec: Record "Prod. Requisition Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 6);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create Prod. Requisition, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50003, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckRequisitionModifyPermission(var Rec: Record "Prod. Requisition Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 6);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Prod. Requisition, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50003, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckRequisitionDeletePermission(var Rec: Record "Prod. Requisition Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 6);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Prod. Requisition, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50003, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckRequisitionRenamePermission(var Rec: Record "Prod. Requisition Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 6);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename Prod. Requisition, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50004, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckRequisitionLineInsertPermission(var Rec: Record "Prod. Requisition Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 6);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create Prod. Requisition Line, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50004, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckRequisitionLineModifyPermission(var Rec: Record "Prod. Requisition Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 6);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Prod. Requisition Line, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50004, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckRequisitionLineDeletePermission(var Rec: Record "Prod. Requisition Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 6);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Prod. Requisition Line, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50004, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckRequisitionLineRenamePermission(var Rec: Record "Prod. Requisition Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 6);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename Prod. Requisition Line, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckVoucherInsertPermission(var Rec: Record "Gen. Journal Line")
    begin
        if Rec.IsTemporary then
            exit;

        if recGenTemplate.Get(Rec."Journal Template Name") then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 5);

            if recGenTemplate."Source Code" = 'BANKPYMTV' then
                recUserPermission.SetRange("Document Type", 1);
            if recGenTemplate."Source Code" = 'BANKRCPTV' then
                recUserPermission.SetRange("Document Type", 2);
            if recGenTemplate."Source Code" = 'CASHPYMTV' then
                recUserPermission.SetRange("Document Type", 3);
            if recGenTemplate."Source Code" = 'CASHRCPTV' then
                recUserPermission.SetRange("Document Type", 4);
            if recGenTemplate."Source Code" = 'CONTRAV' then
                recUserPermission.SetRange("Document Type", 5);
            if recGenTemplate."Source Code" = 'JOURNALV' then
                recUserPermission.SetRange("Document Type", 6);
            if recGenTemplate."Source Code" = 'GENJNL' then
                recUserPermission.SetRange("Document Type", 7);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create %1, contact your system administrator.', recUserPermission."Document Type Description");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckVoucherModifyPermission(var Rec: Record "Gen. Journal Line")
    begin
        if Rec.IsTemporary then
            exit;

        if recGenTemplate.Get(Rec."Journal Template Name") then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 5);

            if recGenTemplate."Source Code" = 'BANKPYMTV' then
                recUserPermission.SetRange("Document Type", 1);
            if recGenTemplate."Source Code" = 'BANKRCPTV' then
                recUserPermission.SetRange("Document Type", 2);
            if recGenTemplate."Source Code" = 'CASHPYMTV' then
                recUserPermission.SetRange("Document Type", 3);
            if recGenTemplate."Source Code" = 'CASHRCPTV' then
                recUserPermission.SetRange("Document Type", 4);
            if recGenTemplate."Source Code" = 'CONTRAV' then
                recUserPermission.SetRange("Document Type", 5);
            if recGenTemplate."Source Code" = 'JOURNALV' then
                recUserPermission.SetRange("Document Type", 6);
            if recGenTemplate."Source Code" = 'GENJNL' then
                recUserPermission.SetRange("Document Type", 7);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify %1, contact your system administrator.', recUserPermission."Document Type Description");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckVoucherDeletePermission(var Rec: Record "Gen. Journal Line")
    begin
        if Rec.IsTemporary then
            exit;

        if recGenTemplate.Get(Rec."Journal Template Name") then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 5);

            if recGenTemplate."Source Code" = 'BANKPYMTV' then
                recUserPermission.SetRange("Document Type", 1);
            if recGenTemplate."Source Code" = 'BANKRCPTV' then
                recUserPermission.SetRange("Document Type", 2);
            if recGenTemplate."Source Code" = 'CASHPYMTV' then
                recUserPermission.SetRange("Document Type", 3);
            if recGenTemplate."Source Code" = 'CASHRCPTV' then
                recUserPermission.SetRange("Document Type", 4);
            if recGenTemplate."Source Code" = 'CONTRAV' then
                recUserPermission.SetRange("Document Type", 5);
            if recGenTemplate."Source Code" = 'JOURNALV' then
                recUserPermission.SetRange("Document Type", 6);
            if recGenTemplate."Source Code" = 'GENJNL' then
                recUserPermission.SetRange("Document Type", 7);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete %1, contact your system administrator.', recUserPermission."Document Type Description");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckVoucherRenamePermission(var Rec: Record "Gen. Journal Line")
    begin
        if Rec.IsTemporary then
            exit;

        if recGenTemplate.Get(Rec."Journal Template Name") then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 5);

            if recGenTemplate."Source Code" = 'BANKPYMTV' then
                recUserPermission.SetRange("Document Type", 1);
            if recGenTemplate."Source Code" = 'BANKRCPTV' then
                recUserPermission.SetRange("Document Type", 2);
            if recGenTemplate."Source Code" = 'CASHPYMTV' then
                recUserPermission.SetRange("Document Type", 3);
            if recGenTemplate."Source Code" = 'CASHRCPTV' then
                recUserPermission.SetRange("Document Type", 4);
            if recGenTemplate."Source Code" = 'CONTRAV' then
                recUserPermission.SetRange("Document Type", 5);
            if recGenTemplate."Source Code" = 'JOURNALV' then
                recUserPermission.SetRange("Document Type", 6);
            if recGenTemplate."Source Code" = 'GENJNL' then
                recUserPermission.SetRange("Document Type", 7);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename %1, contact your system administrator.', recUserPermission."Document Type Description");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckItemJournalInsertPermission(var Rec: Record "Item Journal Line")
    begin
        if Rec.IsTemporary then
            exit;

        if recItemTemplate.Get(Rec."Journal Template Name") then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 6);

            if recItemTemplate."Source Code" = 'ITEMJNL' then
                recUserPermission.SetRange("Document Type", 1);
            if recItemTemplate."Source Code" = 'RECLASSJNL' then
                recUserPermission.SetRange("Document Type", 2);
            if recItemTemplate."Source Code" = 'REVALJNL' then
                recUserPermission.SetRange("Document Type", 3);
            if recItemTemplate."Source Code" = 'CONSUMPJNL' then
                recUserPermission.SetRange("Document Type", 4);
            if recItemTemplate."Source Code" = 'POINOUTJNL' then
                recUserPermission.SetRange("Document Type", 5);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create %1, contact your system administrator.', recUserPermission."Document Type Description");
        end;
    end;


    [EventSubscriber(ObjectType::Table, 83, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckItemJournalModifyPermission(var Rec: Record "Item Journal Line")
    begin
        if Rec.IsTemporary then
            exit;

        if recItemTemplate.Get(Rec."Journal Template Name") then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 6);

            if recItemTemplate."Source Code" = 'ITEMJNL' then
                recUserPermission.SetRange("Document Type", 1);
            if recItemTemplate."Source Code" = 'RECLASSJNL' then
                recUserPermission.SetRange("Document Type", 2);
            if recItemTemplate."Source Code" = 'REVALJNL' then
                recUserPermission.SetRange("Document Type", 3);
            if recItemTemplate."Source Code" = 'CONSUMPJNL' then
                recUserPermission.SetRange("Document Type", 4);
            if recItemTemplate."Source Code" = 'POINOUTJNL' then
                recUserPermission.SetRange("Document Type", 5);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify %1, contact your system administrator.', recUserPermission."Document Type Description");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckItemJournalDeletePermission(var Rec: Record "Item Journal Line")
    begin
        if Rec.IsTemporary then
            exit;

        if recItemTemplate.Get(Rec."Journal Template Name") then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 6);

            if recItemTemplate."Source Code" = 'ITEMJNL' then
                recUserPermission.SetRange("Document Type", 1);
            if recItemTemplate."Source Code" = 'RECLASSJNL' then
                recUserPermission.SetRange("Document Type", 2);
            if recItemTemplate."Source Code" = 'REVALJNL' then
                recUserPermission.SetRange("Document Type", 3);
            if recItemTemplate."Source Code" = 'CONSUMPJNL' then
                recUserPermission.SetRange("Document Type", 4);
            if recItemTemplate."Source Code" = 'POINOUTJNL' then
                recUserPermission.SetRange("Document Type", 5);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete %1, contact your system administrator.', recUserPermission."Document Type Description");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckItemJournalRenamePermission(var Rec: Record "Item Journal Line")
    begin
        if Rec.IsTemporary then
            exit;

        if recItemTemplate.Get(Rec."Journal Template Name") then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 6);

            if recItemTemplate."Source Code" = 'ITEMJNL' then
                recUserPermission.SetRange("Document Type", 1);
            if recItemTemplate."Source Code" = 'RECLASSJNL' then
                recUserPermission.SetRange("Document Type", 2);
            if recItemTemplate."Source Code" = 'REVALJNL' then
                recUserPermission.SetRange("Document Type", 3);
            if recItemTemplate."Source Code" = 'CONSUMPJNL' then
                recUserPermission.SetRange("Document Type", 4);
            if recItemTemplate."Source Code" = 'POINOUTJNL' then
                recUserPermission.SetRange("Document Type", 5);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename %1, contact your system administrator.', recUserPermission."Document Type Description");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5850, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckInventoryInsertPermission(var Rec: Record "Invt. Document Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Receipt then
            recUserPermission.SetRange("Document Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Shipment then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    [EventSubscriber(ObjectType::Table, 5850, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckInventoryModifyPermission(var Rec: Record "Invt. Document Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Receipt then
            recUserPermission.SetRange("Document Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Shipment then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    [EventSubscriber(ObjectType::Table, 5850, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckInventoryDeletePermission(var Rec: Record "Invt. Document Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Receipt then
            recUserPermission.SetRange("Document Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Shipment then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    [EventSubscriber(ObjectType::Table, 5850, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckInventoryRenamePermission(var Rec: Record "Invt. Document Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Receipt then
            recUserPermission.SetRange("Document Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Shipment then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    [EventSubscriber(ObjectType::Table, 5851, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckInventoryLineInsertPermission(var Rec: Record "Invt. Document Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Receipt then
            recUserPermission.SetRange("Document Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Shipment then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create %1 Line, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    [EventSubscriber(ObjectType::Table, 5851, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckInventoryLineModifyPermission(var Rec: Record "Invt. Document Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Receipt then
            recUserPermission.SetRange("Document Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Shipment then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify %1 Line, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    [EventSubscriber(ObjectType::Table, 5851, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckInventoryLineDeletePermission(var Rec: Record "Invt. Document Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Receipt then
            recUserPermission.SetRange("Document Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Shipment then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete %1 Line, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    [EventSubscriber(ObjectType::Table, 5851, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckInventoryLineRenamePermission(var Rec: Record "Invt. Document Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Receipt then
            recUserPermission.SetRange("Document Type", 6);
        if Rec."Document Type" = Rec."Document Type"::Shipment then
            recUserPermission.SetRange("Document Type", 7);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename %1 Line, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    [EventSubscriber(ObjectType::Table, 50001, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckIndentInsertPermission(var Rec: Record "Indent Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 0);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create Indent, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50001, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckIndentModifyPermission(var Rec: Record "Indent Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 0);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Indent, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50001, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckIndentDeletePermission(var Rec: Record "Indent Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 0);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Indent, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50001, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckIndentRenamePermission(var Rec: Record "Indent Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 0);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename Indent, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50002, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckIndentLineInsertPermission(var Rec: Record "Indent Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 0);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create Indent Line, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50002, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckIndentLineModifyPermission(var Rec: Record "Indent Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 0);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Indent Line, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50002, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckIndentLineDeletePermission(var Rec: Record "Indent Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 0);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Indent Line, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50002, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckIndentLineRenamePermission(var Rec: Record "Indent Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 0);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename Indent Line, contact your system administrator.');
    end;

    /*
    [EventSubscriber(ObjectType::Table, 50005, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckJobWorkInsertPermission(var Rec: Record "Job Work Header")
    begin
        if Rec.IsTemporary then
            exit;

        if Rec.Type = Rec.Type::Inward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Job Work Inward Order, contact your system administrator.');
        end;
        if Rec.Type = Rec.Type::Outward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 2);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Job Work Outward Order, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 50005, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckJobWorkModifyPermission(var Rec: Record "Job Work Header")
    begin
        if Rec.IsTemporary then
            exit;

        if Rec.Type = Rec.Type::Inward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Job Work Inward Order, contact your system administrator.');
        end;
        if Rec.Type = Rec.Type::Outward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 2);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Job Work Outward Order, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 50005, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckJobWorkDeletePermission(var Rec: Record "Job Work Header")
    begin
        if Rec.IsTemporary then
            exit;

        if Rec.Type = Rec.Type::Inward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Job Work Inward Order, contact your system administrator.');
        end;
        if Rec.Type = Rec.Type::Outward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 2);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Job Work Outward Order, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 50005, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckJobWorkRenamePermission(var Rec: Record "Job Work Header")
    begin
        if Rec.IsTemporary then
            exit;

        if Rec.Type = Rec.Type::Inward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Job Work Inward Order, contact your system administrator.');
        end;
        if Rec.Type = Rec.Type::Outward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 2);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Job Work Outward Order, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 50006, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckJobWorkLineInsertPermission(var Rec: Record "Job Work Line")
    begin
        if Rec.IsTemporary then
            exit;

        if Rec.Type = Rec.Type::Inward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Job Work Inward Line, contact your system administrator.');
        end;
        if Rec.Type = Rec.Type::Outward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 2);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to create Job Work Outward Line, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 50006, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckJobWorkLineModifyPermission(var Rec: Record "Job Work Line")
    begin
        if Rec.IsTemporary then
            exit;

        if Rec.Type = Rec.Type::Inward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Job Work Inward Line, contact your system administrator.');
        end;
        if Rec.Type = Rec.Type::Outward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 2);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Modification" then
                Error('You are not authorized to modify Job Work Outward Line, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 50006, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckJobWorkLineDeletePermission(var Rec: Record "Job Work Line")
    begin
        if Rec.IsTemporary then
            exit;

        if Rec.Type = Rec.Type::Inward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Job Work Inward Line, contact your system administrator.');
        end;
        if Rec.Type = Rec.Type::Outward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 2);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Deletion" then
                Error('You are not authorized to delete Job Work Outward Line, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 50006, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckJobWorkLineRenamePermission(var Rec: Record "Job Work Line")
    begin
        if Rec.IsTemporary then
            exit;

        if Rec.Type = Rec.Type::Inward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 1);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Job Work Inward Line, contact your system administrator.');
        end;
        if Rec.Type = Rec.Type::Outward then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
            recUserPermission.SetRange("Sub Type", 8);
            recUserPermission.SetRange("Document Type", 2);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to rename Job Work Outward Line, contact your system administrator.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 50009, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckRGPInsertPermission(var Rec: Record "RGP Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create RGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50009, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckRGPModifyPermission(var Rec: Record "RGP Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify RGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50009, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckRGPDeletePermission(var Rec: Record "RGP Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete RGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50009, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckRGPRenamePermission(var Rec: Record "RGP Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename RGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50010, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckRGPLineInsertPermission(var Rec: Record "RGP Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create RGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50010, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckRGPLineModifyPermission(var Rec: Record "RGP Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify RGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50010, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckRGPLineDeletePermission(var Rec: Record "RGP Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete RGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50010, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckRGPLineRenamePermission(var Rec: Record "RGP Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename RGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50013, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckNRGPInsertPermission(var Rec: Record "NRGP Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create NRGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50013, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckNRGPModifyPermission(var Rec: Record "NRGP Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify NRGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50013, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckNRGPDeletePermission(var Rec: Record "NRGP Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete NRGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50013, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckNRGPRenamePermission(var Rec: Record "NRGP Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename NRGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50014, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CheckNRGPLineInsertPermission(var Rec: Record "NRGP Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to create NRGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50014, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckNRGPLineModifyPermission(var Rec: Record "NRGP Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify NRGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50014, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckNRGPLineDeletePermission(var Rec: Record "NRGP Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete NRGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50014, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckNRGPLineRenamePermission(var Rec: Record "NRGP Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 9);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename NRGP Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50011, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPostedRGPModifyPermission(var Rec: Record "Posted RGP Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 8);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Posted RGP, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50011, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPostedRGPDeletePermission(var Rec: Record "Posted RGP Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 8);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Posted RGP, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50012, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPostedRGPLineModifyPermission(var Rec: Record "Posted RGP Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 8);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Posted RGP, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50012, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPostedRGPLineDeletePermission(var Rec: Record "Posted RGP Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 8);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Posted RGP, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50015, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPostedNRGPModifyPermission(var Rec: Record "Posted NRGP Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 8);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Posted NRGP, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50015, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPostedNRGPDeletePermission(var Rec: Record "Posted NRGP Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 8);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Posted NRGP, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50016, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPostedNRGPLineModifyPermission(var Rec: Record "Posted NRGP Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 8);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Posted NRGP, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 50016, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPostedNRGPLineDeletePermission(var Rec: Record "Posted NRGP Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 8);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Posted NRGP, contact your system administrator.');
    end;
    */

    //Check Sales Posting Permission
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', true, true)]
    local procedure SalesPostPermissionCheck(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    begin
        if PreviewMode then
            exit;

        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            // if SalesHeader.Ship then begin
            //     recUserPermission.Reset();
            //     recUserPermission.SetRange("User ID", UserId);
            //     recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
            //     recUserPermission.SetRange("Sub Type", 1);
            //     recUserPermission.SetRange("Document Type", 1);
            //     if not recUserPermission.FindFirst() then
            //         Error('You are not authorized to post Sales Shipment, contact your system administrator.');
            //     if not recUserPermission."Allow Creation" then
            //         Error('You are not authorized to post Sales Shipment, contact your system administrator.');
            // end;
            // if SalesHeader.Invoice then begin
            //     recUserPermission.Reset();
            //     recUserPermission.SetRange("User ID", UserId);
            //     recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
            //     recUserPermission.SetRange("Sub Type", 1);
            //     recUserPermission.SetRange("Document Type", 2);
            //     if not recUserPermission.FindFirst() then
            //         Error('You are not authorized to post Sales Invoice, contact your system administrator.');
            //     if not recUserPermission."Allow Creation" then
            //         Error('You are not authorized to post Sales Invoice, contact your system administrator.');
            // end;
        end;

        // if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then begin
        //     recUserPermission.Reset();
        //     recUserPermission.SetRange("User ID", UserId);
        //     recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        //     recUserPermission.SetRange("Sub Type", 1);
        //     recUserPermission.SetRange("Document Type", 2);
        //     if not recUserPermission.FindFirst() then
        //         Error('You are not authorized to post Sales Invoice, contact your system administrator.');
        //     if not recUserPermission."Allow Creation" then
        //         Error('You are not authorized to post Sales Invoice, contact your system administrator.');
        // end;

        // if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then begin
        //     if SalesHeader.Ship then begin
        //         recUserPermission.Reset();
        //         recUserPermission.SetRange("User ID", UserId);
        //         recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        //         recUserPermission.SetRange("Sub Type", 1);
        //         recUserPermission.SetRange("Document Type", 3);
        //         if not recUserPermission.FindFirst() then
        //             Error('You are not authorized to post Sales Return Receipt, contact your system administrator.');
        //         if not recUserPermission."Allow Creation" then
        //             Error('You are not authorized to post Sales Return Receipt, contact your system administrator.');
        //     end;
        //     if SalesHeader.Invoice then begin
        //         recUserPermission.Reset();
        //         recUserPermission.SetRange("User ID", UserId);
        //         recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        //         recUserPermission.SetRange("Sub Type", 1);
        //         recUserPermission.SetRange("Document Type", 4);
        //         if not recUserPermission.FindFirst() then
        //             Error('You are not authorized to post Sales Credit Memo, contact your system administrator.');
        //         if not recUserPermission."Allow Creation" then
        //             Error('You are not authorized to post Sales Credit Memo, contact your system administrator.');
        //     end;
        // end;

        // if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then begin
        //     recUserPermission.Reset();
        //     recUserPermission.SetRange("User ID", UserId);
        //     recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        //     recUserPermission.SetRange("Sub Type", 1);
        //     recUserPermission.SetRange("Document Type", 4);
        //     if not recUserPermission.FindFirst() then
        //         Error('You are not authorized to post Sales Credit Memo, contact your system administrator.');
        //     if not recUserPermission."Allow Creation" then
        //         Error('You are not authorized to post Sales Credit Memo, contact your system administrator.');
        // end;
    end;

    [EventSubscriber(ObjectType::Table, 110, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckSalesShipmentModifyPermission(var Rec: Record "Sales Shipment Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Sales Shipment, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 110, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckSalesShipmentDeletePermission(var Rec: Record "Sales Shipment Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Sales Shipment, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 111, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckSalesShipmentLineModifyPermission(var Rec: Record "Sales Shipment Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Sales Shipment Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 111, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckSalesShipmentLineDeletePermission(var Rec: Record "Sales Shipment Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Sales Shipment Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 112, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckSalesInvoiceModifyPermission(var Rec: Record "Sales Invoice Header")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 1);
        // recUserPermission.SetRange("Document Type", 2);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Modification" then
        //     Error('You are not authorized to modify Sales Invoice, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 112, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckSalesInvoiceDeletePermission(var Rec: Record "Sales Invoice Header")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 1);
        // recUserPermission.SetRange("Document Type", 2);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Deletion" then
        //     Error('You are not authorized to delete Sales Invoice, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 113, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckSalesInvoiceLineModifyPermission(var Rec: Record "Sales Invoice Line")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 1);
        // recUserPermission.SetRange("Document Type", 2);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Modification" then
        //     Error('You are not authorized to modify Sales Invoice Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 113, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckSalesInvoiceLineDeletePermission(var Rec: Record "Sales Invoice Line")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 1);
        // recUserPermission.SetRange("Document Type", 2);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Deletion" then
        //     Error('You are not authorized to delete Sales Invoice Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 6660, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckSalesReturnRcptModifyPermission(var Rec: Record "Return Receipt Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Sales Return Receipt, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 6660, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckSalesReturnRcptDeletePermission(var Rec: Record "Return Receipt Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Sales Return Receipt, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 6661, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckSalesReturnRcptLineModifyPermission(var Rec: Record "Return Receipt Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Sales Return Receipt Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 6661, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckSalesReturnRcptLineDeletePermission(var Rec: Record "Return Receipt Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Sales Return Receipt Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 114, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckSalesCreditMemoModifyPermission(var Rec: Record "Sales Cr.Memo Header")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 1);
        // recUserPermission.SetRange("Document Type", 4);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Modification" then
        //     Error('You are not authorized to modify Sales Credit Memo, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 114, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckSalesCreditMemoDeletePermission(var Rec: Record "Sales Cr.Memo Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 4);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Sales Credit Memo, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 115, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckSalesCreditMemoLineModifyPermission(var Rec: Record "Sales Cr.Memo Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 4);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Sales Credit Memo Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 115, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckSalesCreditMemoLineDeletePermission(var Rec: Record "Sales Cr.Memo Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 1);
        recUserPermission.SetRange("Document Type", 4);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Sales Credit Memo Lines, contact your system administrator.');
    end;

    //Check Purchase Posting Permission
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', true, true)]
    local procedure PurchasePostPermissionCheck(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    begin
        if PreviewMode then
            exit;

        // if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
        //     if PurchaseHeader.Receive then begin
        //         recUserPermission.Reset();
        //         recUserPermission.SetRange("User ID", UserId);
        //         recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        //         recUserPermission.SetRange("Sub Type", 2);
        //         recUserPermission.SetRange("Document Type", 1);
        //         if not recUserPermission.FindFirst() then
        //             Error('You are not authorized to post Purchase Receipt, contact your system administrator.');
        //         if not recUserPermission."Allow Creation" then
        //             Error('You are not authorized to post Purchase Receipt, contact your system administrator.');
        //     end;
        //     if PurchaseHeader.Invoice then begin
        //         recUserPermission.Reset();
        //         recUserPermission.SetRange("User ID", UserId);
        //         recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        //         recUserPermission.SetRange("Sub Type", 2);
        //         recUserPermission.SetRange("Document Type", 2);
        //         if not recUserPermission.FindFirst() then
        //             Error('You are not authorized to post Purchase Invoice, contact your system administrator.');
        //         if not recUserPermission."Allow Creation" then
        //             Error('You are not authorized to post Purchase Invoice, contact your system administrator.');
        //     end;
        // end;

        // if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then begin
        //     recUserPermission.Reset();
        //     recUserPermission.SetRange("User ID", UserId);
        //     recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        //     recUserPermission.SetRange("Sub Type", 2);
        //     recUserPermission.SetRange("Document Type", 2);
        //     if not recUserPermission.FindFirst() then
        //         Error('You are not authorized to post Purchase Invoice, contact your system administrator.');
        //     if not recUserPermission."Allow Creation" then
        //         Error('You are not authorized to post Purchase Invoice, contact your system administrator.');
        // end;

        // if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Return Order" then begin
        //     if PurchaseHeader.Receive then begin
        //         recUserPermission.Reset();
        //         recUserPermission.SetRange("User ID", UserId);
        //         recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        //         recUserPermission.SetRange("Sub Type", 2);
        //         recUserPermission.SetRange("Document Type", 3);
        //         if not recUserPermission.FindFirst() then
        //             Error('You are not authorized to post Purchase Return Shipment, contact your system administrator.');
        //         if not recUserPermission."Allow Creation" then
        //             Error('You are not authorized to post Purchase Return Shipment, contact your system administrator.');
        //     end;
        //     if PurchaseHeader.Invoice then begin
        //         recUserPermission.Reset();
        //         recUserPermission.SetRange("User ID", UserId);
        //         recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        //         recUserPermission.SetRange("Sub Type", 2);
        //         recUserPermission.SetRange("Document Type", 4);
        //         if not recUserPermission.FindFirst() then
        //             Error('You are not authorized to post Purchase Credit Memo, contact your system administrator.');
        //         if not recUserPermission."Allow Creation" then
        //             Error('You are not authorized to post Purchase Credit Memo, contact your system administrator.');
        //     end;
        // end;

        // if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo" then begin
        //     recUserPermission.Reset();
        //     recUserPermission.SetRange("User ID", UserId);
        //     recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        //     recUserPermission.SetRange("Sub Type", 2);
        //     recUserPermission.SetRange("Document Type", 4);
        //     if not recUserPermission.FindFirst() then
        //         Error('You are not authorized to post Purchase Credit Memo, contact your system administrator.');
        //     if not recUserPermission."Allow Creation" then
        //         Error('You are not authorized to post Purchase Credit Memo, contact your system administrator.');
        // end;
    end;

    [EventSubscriber(ObjectType::Table, 120, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPurchReceiptModifyPermission(var Rec: Record "Purch. Rcpt. Header")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 2);
        // recUserPermission.SetRange("Document Type", 1);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Modification" then
        //     Error('You are not authorized to modify Purchase Receipt, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 120, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPurchReceiptDeletePermission(var Rec: Record "Purch. Rcpt. Header")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 2);
        // recUserPermission.SetRange("Document Type", 1);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Deletion" then
        //     Error('You are not authorized to delete Purchase Receipt, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 121, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPurchReceiptLineModifyPermission(var Rec: Record "Purch. Rcpt. Line")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 2);
        // recUserPermission.SetRange("Document Type", 1);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Modification" then
        //     Error('You are not authorized to modify Purchase Receipt Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 121, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPurchReceiptLineDeletePermission(var Rec: Record "Purch. Rcpt. Line")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 2);
        // recUserPermission.SetRange("Document Type", 1);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Deletion" then
        //     Error('You are not authorized to delete Purchase Receipt Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 122, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPurchInvoiceModifyPermission(var Rec: Record "Purch. Inv. Header")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 2);
        // recUserPermission.SetRange("Document Type", 2);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Modification" then
        //     Error('You are not authorized to modify Purchase Invoice, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 122, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPurchInvoiceDeletePermission(var Rec: Record "Purch. Inv. Header")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 2);
        // recUserPermission.SetRange("Document Type", 2);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Deletion" then
        //     Error('You are not authorized to delete Purchase Invoice, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 123, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPurchInvoiceLineModifyPermission(var Rec: Record "Purch. Inv. Line")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 2);
        // recUserPermission.SetRange("Document Type", 2);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Modification" then
        //     Error('You are not authorized to modify Purchase Invoice Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 123, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPurchInvoiceLineDeletePermission(var Rec: Record "Purch. Inv. Line")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 2);
        // recUserPermission.SetRange("Document Type", 2);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Deletion" then
        //     Error('You are not authorized to delete Purchase Invoice Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 6650, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPurchReturnShipmentModifyPermission(var Rec: Record "Return Shipment Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 2);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Purchase Return Shipment, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 6650, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPurchReturnShipmentDeletePermission(var Rec: Record "Return Shipment Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 2);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Purchase Return Shipment, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 6651, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPurchReturnShipmentLineModifyPermission(var Rec: Record "Return Shipment Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 2);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Purchase Return Shipment Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 6651, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPurchReturnShipmentLineDeletePermission(var Rec: Record "Return Shipment Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 2);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Purchase Return Shipment Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 124, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPurchCreditMemoModifyPermission(var Rec: Record "Purch. Cr. Memo Hdr.")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 2);
        // recUserPermission.SetRange("Document Type", 4);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Modification" then
        //     Error('You are not authorized to modify Purchase Credit Memo, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 124, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPurchCreditMemoDeletePermission(var Rec: Record "Purch. Cr. Memo Hdr.")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 2);
        // recUserPermission.SetRange("Document Type", 4);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Deletion" then
        //     Error('You are not authorized to delete Purchase Credit Memo, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 125, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPurchCreditMemoLineModifyPermission(var Rec: Record "Purch. Cr. Memo Line")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 2);
        // recUserPermission.SetRange("Document Type", 4);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Modification" then
        //     Error('You are not authorized to modify Purchase Credit Memo Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 125, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPurchCreditMemoLineDeletePermission(var Rec: Record "Purch. Cr. Memo Line")
    begin
        if Rec.IsTemporary then
            exit;

        // recUserPermission.Reset();
        // recUserPermission.SetRange("User ID", UserId);
        // recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        // recUserPermission.SetRange("Sub Type", 2);
        // recUserPermission.SetRange("Document Type", 4);
        // recUserPermission.FindFirst();
        // if not recUserPermission."Allow Deletion" then
        //     Error('You are not authorized to delete Purchase Credit Memo Lines, contact your system administrator.');
    end;

    //Check Transfer Posting Permission
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeTransferOrderPostShipment', '', true, true)]
    local procedure TransferShipmentPostPermissionCheck()
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 3);
        recUserPermission.SetRange("Document Type", 1);
        if not recUserPermission.FindFirst() then
            Error('You are not authorized to post Transfer Shipment, contact your system administrator.');
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to post Transfer Shipment, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 5744, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckTransferShipmentModifyPermission(var Rec: Record "Transfer Shipment Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 3);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Transfer Shipment, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 5744, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckTransferShipmentDeletePermission(var Rec: Record "Transfer Shipment Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 3);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Transfer Shipment, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 5745, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckTransferShipmentLineModifyPermission(var Rec: Record "Transfer Shipment Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 3);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Transfer Shipment Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 5745, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckTransferShipmentLineDeletePermission(var Rec: Record "Transfer Shipment Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 3);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Transfer Shipment Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeTransferOrderPostReceipt', '', true, true)]
    local procedure TransferReceiptPostPermissionCheck()
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 3);
        recUserPermission.SetRange("Document Type", 2);
        if not recUserPermission.FindFirst() then
            Error('You are not authorized to post Transfer Receipt, contact your system administrator.');
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to post Transfer Receipt, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 5746, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckTransferReceiptModifyPermission(var Rec: Record "Transfer Receipt Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 3);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Transfer Receipt, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 5746, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckTransferReceiptDeletePermission(var Rec: Record "Transfer Receipt Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 3);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Transfer Receipt, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 5747, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckTransferReceiptLineModifyPermission(var Rec: Record "Transfer Receipt Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 3);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Transfer Receipt Lines, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 5747, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckTransferReceiptLineDeletePermission(var Rec: Record "Transfer Receipt Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 3);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Transfer Receipt Lines, contact your system administrator.');
    end;

    //Check Item Journal Posting Permission
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", 'OnBeforeCode', '', true, true)]
    local procedure ItemJournalVoucherPostPermissionCheck(var ItemJournalLine: Record "Item Journal Line")
    begin
        if ItemJournalLine."Journal Template Name" <> '' then begin
            if ItemJournalLine."Entry Type" in [ItemJournalLine."Entry Type"::Consumption, ItemJournalLine."Entry Type"::Output,
                                                ItemJournalLine."Entry Type"::"Assembly Consumption", ItemJournalLine."Entry Type"::"Assembly Output"] then begin
                recUserPermission.Reset();
                recUserPermission.SetRange("User ID", UserId);
                recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
                recUserPermission.SetRange("Sub Type", 4);

                if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Consumption then
                    recUserPermission.SetRange("Document Type", 1);
                if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Output then
                    recUserPermission.SetRange("Document Type", 2);
                if ItemJournalLine."Entry Type" in [ItemJournalLine."Entry Type"::"Assembly Consumption", ItemJournalLine."Entry Type"::"Assembly Output"] then
                    recUserPermission.SetRange("Document Type", 3);
                recUserPermission.FindFirst();
                if not recUserPermission."Allow Creation" then
                    Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
            end;

            if ItemJournalLine."Source Code" <> 'REVALJNL' then begin
                if not (ItemJournalLine."Entry Type" in [ItemJournalLine."Entry Type"::Consumption, ItemJournalLine."Entry Type"::Output,
                                                    ItemJournalLine."Entry Type"::"Assembly Consumption", ItemJournalLine."Entry Type"::"Assembly Output"]) then begin
                    recUserPermission.Reset();
                    recUserPermission.SetRange("User ID", UserId);
                    recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
                    recUserPermission.SetRange("Sub Type", 6);

                    if ItemJournalLine."Entry Type" in [ItemJournalLine."Entry Type"::"Negative Adjmt.", ItemJournalLine."Entry Type"::"Positive Adjmt.",
                                                        ItemJournalLine."Entry Type"::Purchase, ItemJournalLine."Entry Type"::Sale] then
                        recUserPermission.SetRange("Document Type", 1);
                    if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Transfer then
                        recUserPermission.SetRange("Document Type", 2);
                    recUserPermission.FindFirst();
                    if not recUserPermission."Allow Creation" then
                        Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
                end;
            end;

            if ItemJournalLine."Source Code" = 'REVALJNL' then begin
                recUserPermission.Reset();
                recUserPermission.SetRange("User ID", UserId);
                recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
                recUserPermission.SetRange("Sub Type", 6);
                recUserPermission.SetRange("Document Type", 3);
                recUserPermission.FindFirst();
                if not recUserPermission."Allow Creation" then
                    Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 910, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPostedAssemblyDocModifyPermission(var Rec: Record "Posted Assembly Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Posted Assembly Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 910, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPostedAssemblyDocDeletePermission(var Rec: Record "Posted Assembly Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Posted Assembly Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 910, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckPostedAssemblyDocRenamePermission(var Rec: Record "Posted Assembly Header")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename Posted Assembly Order, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 911, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CheckPostedAssemblyDocLineModifyPermission(var Rec: Record "Posted Assembly Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Modification" then
            Error('You are not authorized to modify Posted Assembly Line, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 911, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CheckPostedAssemblyDocLineDeletePermission(var Rec: Record "Posted Assembly Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Deletion" then
            Error('You are not authorized to delete Posted Assembly Line, contact your system administrator.');
    end;

    [EventSubscriber(ObjectType::Table, 911, 'OnBeforeRenameEvent', '', true, true)]
    local procedure CheckPostedAssemblyDocLineRenamePermission(var Rec: Record "Posted Assembly Line")
    begin
        if Rec.IsTemporary then
            exit;

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Transaction);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to rename Posted Assembly Line, contact your system administrator.');
    end;

    //Check Voucher Posting Permission
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", 'OnBeforeCode', '', true, true)]
    local procedure JournalVoucherPostPermissionCheck(var GenJournalLine: Record "Gen. Journal Line")
    begin
        if recGenTemplate.Get(GenJournalLine."Journal Template Name") then begin
            recUserPermission.Reset();
            recUserPermission.SetRange("User ID", UserId);
            recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
            recUserPermission.SetRange("Sub Type", 5);

            if recGenTemplate."Source Code" = 'BANKPYMTV' then
                recUserPermission.SetRange("Document Type", 1);
            if recGenTemplate."Source Code" = 'BANKRCPTV' then
                recUserPermission.SetRange("Document Type", 2);
            if recGenTemplate."Source Code" = 'CASHPYMTV' then
                recUserPermission.SetRange("Document Type", 3);
            if recGenTemplate."Source Code" = 'CASHRCPTV' then
                recUserPermission.SetRange("Document Type", 4);
            if recGenTemplate."Source Code" = 'CONTRAV' then
                recUserPermission.SetRange("Document Type", 5);
            if recGenTemplate."Source Code" = 'JOURNALV' then
                recUserPermission.SetRange("Document Type", 6);
            if recGenTemplate."Source Code" = 'GENJNL' then
                recUserPermission.SetRange("Document Type", 7);
            recUserPermission.FindFirst();
            if not recUserPermission."Allow Creation" then
                Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
        end;
    end;

    procedure CheckRequisitionPostPermission()
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 4);
        recUserPermission.SetRange("Document Type", 4);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    procedure CheckJobWorkInwardReceiptPostPermission()
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    procedure CheckJobWorkInwardConsumptionPostPermission()
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    procedure CheckJobWorkInwardIssuePostPermission()
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    procedure CheckJobWorkOutwardIssuePostPermission()
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 4);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    procedure CheckJobWorkOutwardConsumptionPostPermission()
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 5);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    procedure CheckJobWorkOutwardReceiptPostPermission()
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 7);
        recUserPermission.SetRange("Document Type", 6);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    procedure CheckNRGPIssuePostPermission()
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 8);
        recUserPermission.SetRange("Document Type", 1);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    procedure CheckRGPIssuePostPermission()
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 8);
        recUserPermission.SetRange("Document Type", 2);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    procedure CheckRGPReceiptPostPermission()
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", UserId);
        recUserPermission.SetRange(Type, recUserPermission.Type::Posting);
        recUserPermission.SetRange("Sub Type", 8);
        recUserPermission.SetRange("Document Type", 3);
        recUserPermission.FindFirst();
        if not recUserPermission."Allow Creation" then
            Error('You are not authorized to post %1, contact your system administrator.', recUserPermission."Document Type Description");
    end;

    procedure FillUserPermission(cdUserID: Code[50])
    var
    begin
        if cdUserID = '' then
            exit;

        //Master Permissions
        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Master;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'G/L Account';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Master;
        recUserPermission."Sub Type" := 2;
        recUserPermission."Sub Type Description" := 'Customer';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Master;
        recUserPermission."Sub Type" := 3;
        recUserPermission."Sub Type Description" := 'Vendor';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Master;
        recUserPermission."Sub Type" := 4;
        recUserPermission."Sub Type Description" := 'Item';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Master;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Bank Account';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Master;
        recUserPermission."Sub Type" := 6;
        recUserPermission."Sub Type Description" := 'Dimension';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Master;
        recUserPermission."Sub Type" := 7;
        recUserPermission."Sub Type Description" := 'Employee';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Master;
        recUserPermission."Sub Type" := 8;
        recUserPermission."Sub Type Description" := 'Fixed Asset';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Master;
        recUserPermission."Sub Type" := 9;
        recUserPermission."Sub Type Description" := 'Prod. BOM';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Master;
        recUserPermission."Sub Type" := 10;
        recUserPermission."Sub Type Description" := 'Routing';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        //Transaction Permissions
        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Blanket Order';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'Quote';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 3;
        recUserPermission."Document Type Description" := 'Order';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 4;
        recUserPermission."Document Type Description" := 'Invoice';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 5;
        recUserPermission."Document Type Description" := 'Return Order';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 6;
        recUserPermission."Document Type Description" := 'Credit Memo';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 2;
        recUserPermission."Sub Type Description" := 'Purchase';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Blanket Order';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 2;
        recUserPermission."Sub Type Description" := 'Purchase';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'Quote';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 2;
        recUserPermission."Sub Type Description" := 'Purchase';
        recUserPermission."Document Type" := 3;
        recUserPermission."Document Type Description" := 'Order';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 2;
        recUserPermission."Sub Type Description" := 'Purchase';
        recUserPermission."Document Type" := 4;
        recUserPermission."Document Type Description" := 'Invoice';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 2;
        recUserPermission."Sub Type Description" := 'Purchase';
        recUserPermission."Document Type" := 5;
        recUserPermission."Document Type Description" := 'Return Order';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 2;
        recUserPermission."Sub Type Description" := 'Purchase';
        recUserPermission."Document Type" := 6;
        recUserPermission."Document Type Description" := 'Credit Memo';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 3;
        recUserPermission."Sub Type Description" := 'Transfer';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Order';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 4;
        recUserPermission."Sub Type Description" := 'Production';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Simulated';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 4;
        recUserPermission."Sub Type Description" := 'Production';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'Planned Order';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 4;
        recUserPermission."Sub Type Description" := 'Production';
        recUserPermission."Document Type" := 3;
        recUserPermission."Document Type Description" := 'Firm Planned Order';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 4;
        recUserPermission."Sub Type Description" := 'Production';
        recUserPermission."Document Type" := 4;
        recUserPermission."Document Type Description" := 'Released Order';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 4;
        recUserPermission."Sub Type Description" := 'Production';
        recUserPermission."Document Type" := 5;
        recUserPermission."Document Type Description" := 'Assembly Order';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 4;
        recUserPermission."Sub Type Description" := 'Production';
        recUserPermission."Document Type" := 6;
        recUserPermission."Document Type Description" := 'Requisition';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 4;
        recUserPermission."Sub Type Description" := 'Production';
        recUserPermission."Document Type" := 7;
        recUserPermission."Document Type Description" := 'Finished Order';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission."User ID" := cdUserID;
        recUserPermission.Init();
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Bank Payment Voucher';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'Bank Receipt Voucher';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 3;
        recUserPermission."Document Type Description" := 'Cash Payment Voucher';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 4;
        recUserPermission."Document Type Description" := 'Cash Receipt Voucher';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 5;
        recUserPermission."Document Type Description" := 'Contra Voucher';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 6;
        recUserPermission."Document Type Description" := 'Journal Voucher';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 7;
        recUserPermission."Document Type Description" := 'General Journal';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 6;
        recUserPermission."Sub Type Description" := 'Item Journal';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Item Journal';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 6;
        recUserPermission."Sub Type Description" := 'Item Journal';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'Item Reclassification';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 6;
        recUserPermission."Sub Type Description" := 'Item Journal';
        recUserPermission."Document Type" := 3;
        recUserPermission."Document Type Description" := 'Item Revaluation';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 6;
        recUserPermission."Sub Type Description" := 'Item Journal';
        recUserPermission."Document Type" := 4;
        recUserPermission."Document Type Description" := 'Consumption Journal';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 6;
        recUserPermission."Sub Type Description" := 'Item Journal';
        recUserPermission."Document Type" := 5;
        recUserPermission."Document Type Description" := 'Output Journal';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 6;
        recUserPermission."Sub Type Description" := 'Item Journal';
        recUserPermission."Document Type" := 6;
        recUserPermission."Document Type Description" := 'Inventory Receipt';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 6;
        recUserPermission."Sub Type Description" := 'Item Journal';
        recUserPermission."Document Type" := 7;
        recUserPermission."Document Type Description" := 'Inventory Issue';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 7;
        recUserPermission."Sub Type Description" := 'Indent';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 8;
        recUserPermission."Sub Type Description" := 'Job Work';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Inward';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 8;
        recUserPermission."Sub Type Description" := 'Job Work';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'Outward';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 9;
        recUserPermission."Sub Type Description" := 'Gate Pass';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'NRGP';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Transaction;
        recUserPermission."Sub Type" := 9;
        recUserPermission."Sub Type Description" := 'Gate Pass';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'RGP';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        //Posting Permissions
        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Shipment';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'Invoice';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 3;
        recUserPermission."Document Type Description" := 'Receipt';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 4;
        recUserPermission."Document Type Description" := 'Credit Memo';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 5;
        recUserPermission."Document Type Description" := 'E Way Generation';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 6;
        recUserPermission."Document Type Description" := 'E Way Cancellation';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 7;
        recUserPermission."Document Type Description" := 'E Invoice Generation';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 1;
        recUserPermission."Sub Type Description" := 'Sales';
        recUserPermission."Document Type" := 8;
        recUserPermission."Document Type Description" := 'E Invoice Cancellation';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 2;
        recUserPermission."Sub Type Description" := 'Purchase';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Receipt';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 2;
        recUserPermission."Sub Type Description" := 'Purchase';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'Invoice';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 2;
        recUserPermission."Sub Type Description" := 'Purchase';
        recUserPermission."Document Type" := 3;
        recUserPermission."Document Type Description" := 'Shipment';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 2;
        recUserPermission."Sub Type Description" := 'Purchase';
        recUserPermission."Document Type" := 4;
        recUserPermission."Document Type Description" := 'Credit Memo';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 3;
        recUserPermission."Sub Type Description" := 'Transfer';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Shipment';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 3;
        recUserPermission."Sub Type Description" := 'Transfer';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'Receipt';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 4;
        recUserPermission."Sub Type Description" := 'Production';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Consumption Journal';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 4;
        recUserPermission."Sub Type Description" := 'Production';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'Output Journal';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 4;
        recUserPermission."Sub Type Description" := 'Production';
        recUserPermission."Document Type" := 3;
        recUserPermission."Document Type Description" := 'Assembly Order';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 4;
        recUserPermission."Sub Type Description" := 'Production';
        recUserPermission."Document Type" := 4;
        recUserPermission."Document Type Description" := 'Requisition';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Bank Payment Voucher';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'Bank Receipt Voucher';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 3;
        recUserPermission."Document Type Description" := 'Cash Payment Voucher';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 4;
        recUserPermission."Document Type Description" := 'Cash Receipt Voucher';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 5;
        recUserPermission."Document Type Description" := 'Contra Voucher';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 6;
        recUserPermission."Document Type Description" := 'Journal Voucher';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 5;
        recUserPermission."Sub Type Description" := 'Voucher';
        recUserPermission."Document Type" := 7;
        recUserPermission."Document Type Description" := 'General Journal';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 6;
        recUserPermission."Sub Type Description" := 'Item Journal';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Item Journal';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 6;
        recUserPermission."Sub Type Description" := 'Item Journal';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'Item Reclassification';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 6;
        recUserPermission."Sub Type Description" := 'Item Journal';
        recUserPermission."Document Type" := 3;
        recUserPermission."Document Type Description" := 'Item Revaluation';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 7;
        recUserPermission."Sub Type Description" := 'Job Work';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'Inward Receipt';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 7;
        recUserPermission."Sub Type Description" := 'Job Work';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'Inward Consumption';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 7;
        recUserPermission."Sub Type Description" := 'Job Work';
        recUserPermission."Document Type" := 3;
        recUserPermission."Document Type Description" := 'Inward Issue';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 7;
        recUserPermission."Sub Type Description" := 'Job Work';
        recUserPermission."Document Type" := 4;
        recUserPermission."Document Type Description" := 'Outward Issue';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 7;
        recUserPermission."Sub Type Description" := 'Job Work';
        recUserPermission."Document Type" := 5;
        recUserPermission."Document Type Description" := 'Outward Consumtion';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 7;
        recUserPermission."Sub Type Description" := 'Job Work';
        recUserPermission."Document Type" := 6;
        recUserPermission."Document Type Description" := 'Outward Receive';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 8;
        recUserPermission."Sub Type Description" := 'Gate Pass';
        recUserPermission."Document Type" := 1;
        recUserPermission."Document Type Description" := 'NRGP Issue';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 8;
        recUserPermission."Sub Type Description" := 'Gate Pass';
        recUserPermission."Document Type" := 2;
        recUserPermission."Document Type Description" := 'RGP Issue';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);

        recUserPermission.Init();
        recUserPermission."User ID" := cdUserID;
        recUserPermission.Type := recUserPermission.Type::Posting;
        recUserPermission."Sub Type" := 8;
        recUserPermission."Sub Type Description" := 'Gate Pass';
        recUserPermission."Document Type" := 3;
        recUserPermission."Document Type Description" := 'RGP Receive';
        if not recUserPermission.Insert() then
            Clear(recUserPermission);
    end;

    procedure AllowAllPermission(cdUserID: Code[50])
    var
    begin
        if cdUserID = '' then
            Error('Select the user id to allow all permissions.');

        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", cdUserID);
        if not recUserPermission.FindFirst() then
            Error('The user permission does not exist for the user id %1', cdUserID);
        recUserPermission.ModifyAll("Allow Creation", true);
        recUserPermission.ModifyAll("Allow Modification", true);
        recUserPermission.ModifyAll("Allow Deletion", true);
    end;

    procedure DeleteUserPermission(cdUserID: Code[50])
    var
    begin
        recUserPermission.Reset();
        recUserPermission.SetRange("User ID", cdUserID);
        if not recUserPermission.FindFirst() then
            Error('The user permission does not exist for the user id %1', cdUserID);
        recUserPermission.DeleteAll();
    end;

    var
        recUserPermission: Record "User Permission";
        recGenTemplate: Record "Gen. Journal Template";
        recItemTemplate: Record "Item Journal Template";
}