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
        GoogleFileId: Text;
    begin
        if Rec."Table ID" <> Database::"Sales Header" then
            exit;

        if not SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."No.") then
            exit;

        if not Rec.HasContent() then
            exit;

        Rec.GetAsTempBlob(TempBlob);
        TempBlob.CreateInStream(FileStream);

        MimeType := GetMimeType(Rec."File Extension");

        DriveUrl := GDUpload.UploadFileToDrive(Rec."File Name" + '.' + Rec."File Extension", MimeType, FileStream, GoogleFileId);

        GDUpload.CreateAttachmentMapping(Rec, GoogleFileId, DriveUrl);

        Message('File "%1.%2" uploaded successfully to Google Drive.\URL: %3', Rec."File Name", Rec."File Extension", DriveUrl);
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

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnDocumentAttachmentDeleted(var Rec: Record "Document Attachment"; RunTrigger: Boolean)
    var
        GoogleAttachment: Record "Google Drive Attachment";
        GDUpload: Codeunit "Google Drive Upload";
        SalesHeader: Record "Sales Header";
    begin
        if GoogleAttachment.Get(Rec.ID) then begin
            GDUpload.DeleteFileFromDrive(GoogleAttachment."Google File ID");
            GoogleAttachment.Delete();
        end;
    end;
}