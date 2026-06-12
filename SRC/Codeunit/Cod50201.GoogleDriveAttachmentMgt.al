codeunit 50201 "Google Drive Attachment Mgt"
{
    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnDocumentAttached(var Rec: Record "Document Attachment"; RunTrigger: Boolean)
    var
        SalesHeader: Record "Sales Header";
        TempBlob: Codeunit "Temp Blob";
        FileStream: InStream;
        GDUpload: Codeunit "Google Drive Upload";
        DriveUrl: Text;
        MimeType: Text;
    begin
        // Only Sales Orders
        if Rec."Table ID" <> Database::"Sales Header" then
            exit;

        if not SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."No.") then
            exit;

        // Ensure attachment exists
        if not Rec.HasContent() then
            exit;

        // Get attachment content
        Rec.GetAsTempBlob(TempBlob);
        TempBlob.CreateInStream(FileStream);

        MimeType := GetMimeType(Rec."File Extension");

        // Upload to Google Drive
        DriveUrl :=
            GDUpload.UploadFileToDrive(
                Rec."File Name" + '.' + Rec."File Extension",
                MimeType,
                FileStream);

        // Save URL on Sales Order
        SalesHeader."Google Drive URL" := CopyStr(DriveUrl, 1, MaxStrLen(SalesHeader."Google Drive URL"));
        SalesHeader.Modify();

        Message(
            'File "%1.%2" uploaded successfully to Google Drive.\URL: %3',
            Rec."File Name",
            Rec."File Extension",
            DriveUrl);
    end;

    local procedure GetMimeType(Extension: Text): Text
    begin
        case LowerCase(Extension) of
            'pdf':
                exit('application/pdf');
            'png':
                exit('image/png');
            'jpg', 'jpeg':
                exit('image/jpeg');
            'xlsx':
                exit('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            'xls':
                exit('application/vnd.ms-excel');
            'docx':
                exit('application/vnd.openxmlformats-officedocument.wordprocessingml.document');
            'doc':
                exit('application/msword');
            'pptx':
                exit('application/vnd.openxmlformats-officedocument.presentationml.presentation');
            'ppt':
                exit('application/vnd.ms-powerpoint');
            'txt':
                exit('text/plain');
            'csv':
                exit('text/csv');
            else
                exit('application/octet-stream');
        end;
    end;
}