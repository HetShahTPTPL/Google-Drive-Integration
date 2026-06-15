page 50201 "Google Drive URL"
{
    ApplicationArea = All;
    Caption = 'Google Drive URL';
    PageType = ListPart;
    SourceTable = "Google Drive Attachment";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the File Name field.', Comment = '%';
                }
                field("Google Drive URL"; Rec."Google Drive URL")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Google Drive URL field.', Comment = '%';
                }
            }
        }
    }
}
