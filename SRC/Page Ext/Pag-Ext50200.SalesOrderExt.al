pageextension 50200 SalesOrderExt extends "Sales Order"
{
    layout
    {
        addlast(FactBoxes)
        {
            part(GoogleDriveDocs; "Google Drive URL")
            {
                ApplicationArea = All;
                Caption = 'Google Drive Documents';
                SubPageLink = "Table ID" = const(36), "Document No." = field("No.");
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("Google Drive URL")
            {
                ApplicationArea = all;
                Caption = 'Google Drive URL';
                Image = Link;
                RunObject = Page "Google Drive URL";
                RunPageLink = "Table ID" = const(36), "Document No." = field("No.");
                ToolTip = 'View Google Drive URL for the record.';
            }
        }
        addlast(Promoted)
        {
            actionref(GoogleDriveURL_Promoted; "Google Drive URL")
            {
            }
        }
    }
}