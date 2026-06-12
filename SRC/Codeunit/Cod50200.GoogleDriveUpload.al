codeunit 50200 "Google Drive Upload"
{
    procedure GetAccessToken(): Text
    var
        Setup: Record "Google Drive Setup";
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        Body: Text;
        JsonResp: JsonObject;
        TokenToken: JsonToken;
    begin
        if not Setup.Get('') then
            Error('Google Drive Setup not configured.');

        Body := StrSubstNo(
            'client_id=%1&client_secret=%2&refresh_token=%3&grant_type=refresh_token',
            Setup."Client ID",
            Setup."Client Secret",
            Setup."Refresh Token");

        Content.WriteFrom(Body);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

        Request.Method := 'POST';
        Request.SetRequestUri('https://oauth2.googleapis.com/token');
        Request.Content := Content;

        if not Client.Send(Request, Response) then
            Error('Failed to reach Google OAuth endpoint.');

        if not Response.IsSuccessStatusCode() then begin
            Response.Content.ReadAs(Body);
            Error('OAuth token refresh failed.\Status: %1\Response: %2', Response.HttpStatusCode(), Body);
        end;

        Response.Content.ReadAs(Body);
        JsonResp.ReadFrom(Body);
        JsonResp.Get('access_token', TokenToken);
        exit(TokenToken.AsValue().AsText());
    end;

    procedure UploadFileToDrive(FileName: Text; MimeType: Text; FileContent: InStream): Text
    var
        AccessToken: Text;
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        ResponseText: Text;
        JsonResp: JsonObject;
        IdToken: JsonToken;
    begin
        AccessToken := GetAccessToken();

        Content.WriteFrom(FileContent);

        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', MimeType);

        Request.Method := 'POST';
        Request.SetRequestUri('https://www.googleapis.com/upload/drive/v3/files?uploadType=media');

        Request.Content := Content;

        Request.GetHeaders(Headers);
        Headers.Add('Authorization', 'Bearer ' + AccessToken);

        if not Client.Send(Request, Response) then
            Error('Failed to reach Google Drive API.');

        Response.Content.ReadAs(ResponseText);

        if not Response.IsSuccessStatusCode() then
            Error(
                'Drive upload failed. Status: %1\Response: %2',
                Response.HttpStatusCode(),
                ResponseText);

        JsonResp.ReadFrom(ResponseText);

        if not JsonResp.Get('id', IdToken) then
            Error('Google Drive did not return File ID.');

        UpdateFileMetadata(IdToken.AsValue().AsText(), FileName);

        exit('https://drive.google.com/file/d/' + IdToken.AsValue().AsText() + '/view');
    end;

    local procedure UpdateFileMetadata(FileId: Text; FileName: Text)
    var
        Setup: Record "Google Drive Setup";
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        Body: Text;
    begin
        Setup.Get('');

        Body := StrSubstNo('{"name":"%1"}', FileName);

        Content.WriteFrom(Body);

        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');

        Request.Method := 'PATCH';

        Request.SetRequestUri('https://www.googleapis.com/drive/v3/files/' + FileId + '?addParents=' + Setup."Target Folder ID");

        Request.Content := Content;

        Request.GetHeaders(Headers);
        Headers.Add('Authorization', 'Bearer ' + GetAccessToken());

        if not Client.Send(Request, Response) then
            Error('Failed to update Google Drive metadata.');

        Response.Content.ReadAs(Body);

        if not Response.IsSuccessStatusCode() then
            Error('Metadata update failed: %1', Body);
    end;
}
