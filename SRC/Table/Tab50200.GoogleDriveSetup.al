table 50200 "Google Drive Setup"
{
    Caption = 'Google Drive Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Client ID"; Text[250])
        {
            Caption = 'Client ID';
        }
        field(3; "Client Secret"; Text[250])
        {
            Caption = 'Client Secret';
        }
        field(4; "Refresh Token"; Text[500])
        {
            Caption = 'Refresh Token';
        }
        field(5; "Target Folder ID"; Text[250])
        {
            Caption = 'Target Folder ID';
        }
        field(6; "Redirect URI"; Text[250])
        {
            Caption = 'Redirect URI';
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
