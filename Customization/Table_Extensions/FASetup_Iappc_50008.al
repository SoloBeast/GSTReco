tableextension 50008 "FA Setup Ext." extends "FA Setup"
{
    fields
    {
        // Add changes to table fields here
        field(70000; "FA Dimension"; Code[20])
        {
            TableRelation = Dimension;
        }
    }

    var
}