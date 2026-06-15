table 50201 "Google Drive Attachment"
{
    Caption = 'Google Drive Attachment';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Attachment ID"; Integer)
        {
            Caption = 'Attachment ID';
            DataClassification = ToBeClassified;
        }
        field(2; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = ToBeClassified;
        }
        field(3; "Document No."; Code[50])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Document Type"; Integer)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
        }
        field(5; "File Name"; Text[250])
        {
            Caption = 'File Name';
            DataClassification = ToBeClassified;
        }
        field(6; "Google File ID"; Text[100])
        {
            Caption = 'Google File ID';
            DataClassification = ToBeClassified;
        }
        field(7; "Google Drive URL"; Text[2048])
        {
            Caption = 'Google Drive URL';
            DataClassification = ToBeClassified;
        }
        field(8; "Uploaded DateTime"; DateTime)
        {
            Caption = 'Uploaded Date Time';
            DataClassification = ToBeClassified;
        }
        field(9; "Uploaded By"; Guid)
        {
            Caption = 'Uploaded By';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Attachment ID")
        {
            Clustered = true;
        }
        key(Key2; "Table ID", "Document No.")
        {
        }
        key(Key3; "Google File ID")
        {
        }
    }
}