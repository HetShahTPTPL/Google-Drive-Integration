# Google Drive Integration for Business Central 28 SaaS

## Overview
This solution uploads Sales Order attachments from Microsoft Dynamics 365 Business Central (BC 28 SaaS) to Google Drive automatically when a user attaches a file.

---

# 1. Create a Google Cloud Project

1. Open Google Cloud Console:
   https://console.cloud.google.com

2. Create a new project:
   - Click **Select Project**
   - Click **New Project**
   - Enter a project name
   - Click **Create**

3. Open the created project.

---

# 2. Enable Google Drive API

1. Navigate to:
   APIs & Services → Library

2. Search for:
   - Google Drive API

3. Click:
   - Enable

---

# 3. Configure OAuth Consent Screen

1. Navigate to:
   APIs & Services → OAuth Consent Screen

2. Select:
   - External

3. Fill:
   - App Name
   - Support Email
   - Developer Email

4. Save.

5. Add test users if required.

---

# 4. Create OAuth Client

1. Navigate to:
   APIs & Services → Credentials

2. Click:
   - Create Credentials
   - OAuth Client ID

3. Select:
   - Web Application

4. Add Authorized Redirect URI:

```
https://developers.google.com/oauthplayground
```

5. Save.

6. Copy:

```
Client ID
Client Secret
```

---

# 5. Generate Refresh Token

1. Open:
   https://developers.google.com/oauthplayground

2. Click the gear icon.

3. Enable:

```
Use your own OAuth credentials
```

4. Paste:
   - Client ID
   - Client Secret

5. Close settings.

6. In Step 1 enter:

```
https://www.googleapis.com/auth/drive.file
```

7. Click:
   - Authorize APIs

8. Sign in using the Google account that owns the Drive folder.

9. Click:
   - Exchange Authorization Code for Tokens

10. Copy:

```
Refresh Token
```

---

# 6. Create Google Drive Folder

1. Open Google Drive.

2. Create folder:

```
BC Integration
```

3. Open the folder.

4. Copy the Folder ID from URL.

Example:

```
https://drive.google.com/drive/folders/1ppBx3-qmqEZNCB3Ovkt6ZraQTUVVYmh6
```

Folder ID:

```
1ppBx3-qmqEZNCB3Ovkt6ZraQTUVVYmh6
```

---

# 7. Create Business Central Objects

Create:

## Table

Google Drive Setup

Fields:

- Client ID
- Client Secret
- Refresh Token
- Target Folder ID
- Redirect URI

## Page

Google Drive Setup Card

Fields:

- Client ID
- Client Secret
- Refresh Token
- Target Folder ID
- Redirect URI

Action:

- Test Connection

## Codeunit

Google Drive Upload

Responsibilities:

- Get OAuth Access Token
- Upload file to Google Drive
- Return Google Drive URL

## Codeunit

Google Drive Attachment Management

Responsibilities:

- Subscribe to Document Attachment events
- Read uploaded attachment
- Send attachment to Google Drive
- Store returned URL

---

# 8. Add Google Drive URL Field

Create a field in Sales Header.

Example:

```al
field(50200; "Google Drive URL"; Text[2048])
{
    Caption = 'Google Drive URL';
}
```

Create a page extension to display it on Sales Order.

---

# 9. Configure Setup in Business Central

Open:

```
Google Drive Setup
```

Populate:

| Field | Value |
|---------|---------|
| Client ID | Google OAuth Client ID |
| Client Secret | Google OAuth Client Secret |
| Refresh Token | Refresh Token from OAuth Playground |
| Target Folder ID | Google Drive Folder ID |
| Redirect URI | https://developers.google.com/oauthplayground |

Click:

```
Test Connection
```

Expected message:

```
Connection Successful
```

---

# 10. Upload Attachments from Sales Order

1. Open Sales Order.

2. Open Attachments FactBox.

3. Upload a file.

The process automatically:

1. Saves attachment in BC.
2. Reads attachment stream.
3. Uploads file to Google Drive.
4. Stores Google Drive URL in Sales Order.

---

# 11. Verify Upload

Open Google Drive folder:

```
BC Integration
```

Verify uploaded files exist.

Open Sales Order.

Verify:

```
Google Drive URL
```

contains the generated Drive link.

---

# Troubleshooting

## OAuth token refresh failed (401)

Cause:
- Invalid Client ID
- Invalid Client Secret
- Invalid Refresh Token

Resolution:
- Regenerate Refresh Token
- Verify OAuth credentials

---

## invalid_client

Cause:
- OAuth client deleted
- Wrong Client ID

Resolution:
- Create a new OAuth Client
- Update BC Setup

---

## Missing end boundary in multipart body

Cause:
- Multipart upload formatting issue

Resolution:
- Use BC 28 SaaS resumable upload approach instead of manual multipart upload.

---

## File uploaded as Untitled

Cause:
- Upload created without metadata.

Resolution:
- Send file name in upload metadata step.

---

## Folder not receiving files

Cause:
- Incorrect Folder ID

Resolution:
- Verify Folder ID copied from Drive URL.

---

# Result

After configuration, every attachment uploaded on a Sales Order is automatically uploaded to Google Drive and the generated Drive URL is stored in Business Central.
