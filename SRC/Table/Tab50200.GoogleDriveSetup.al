table 50200 "Google Drive Setup"
{
    Caption = 'Google Drive Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(2; "Client ID"; Text[250])
        {
            Caption = 'Client ID';
            DataClassification = ToBeClassified;
        }
        field(3; "Client Secret"; Text[250])
        {
            Caption = 'Client Secret';
            DataClassification = ToBeClassified;
        }
        field(4; "Refresh Token"; Text[500])
        {
            Caption = 'Refresh Token';
            DataClassification = ToBeClassified;
        }
        field(5; "Target Folder ID"; Text[250])
        {
            Caption = 'Target Folder ID';
            DataClassification = ToBeClassified;
        }
        field(6; "Redirect URI"; Text[250])
        {
            Caption = 'Redirect URI';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
