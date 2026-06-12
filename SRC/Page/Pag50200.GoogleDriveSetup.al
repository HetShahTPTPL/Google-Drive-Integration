page 50200 "Google Drive Setup"
{
    PageType = Card;
    SourceTable = "Google Drive Setup";
    Caption = 'Google Drive Setup';
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Client ID"; Rec."Client ID")
                {
                    Caption = 'Client ID';
                    ApplicationArea = All;
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    Caption = 'Client Secret';
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field("Refresh Token"; Rec."Refresh Token")
                {
                    Caption = 'Refresh Token';
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field("Target Folder ID"; Rec."Target Folder ID")
                {
                    Caption = 'Target Folder ID';
                    ApplicationArea = All;
                }
                field("Redirect URI"; Rec."Redirect URI")
                {
                    Caption = 'Redirect URI';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TestConnection)
            {
                Caption = 'Test Connection';
                ApplicationArea = All;
                trigger OnAction()
                var
                    GDUpload: Codeunit "Google Drive Upload";
                begin
                    if GDUpload.GetAccessToken() <> '' then
                        Message('Connection successful!')
                    else
                        Error('Connection failed. Check your credentials.');
                end;
            }
        }
    }
}
