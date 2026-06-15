# Google Drive Integration for Business Central

## Overview

This solution integrates Microsoft Dynamics 365 Business Central with Google Drive.

When users upload attachments through the standard Document Attachment functionality, files are automatically uploaded to Google Drive and linked back to Business Central. When attachments are deleted from Business Central, the corresponding files can also be automatically removed from Google Drive.

The solution uses:

- Google Drive API
- OAuth 2.0 Authentication
- Refresh Token Authentication
- Generic Attachment Mapping Architecture
- Business Central Document Attachment Events

---

# Features

- OAuth 2.0 authentication using Google Drive API
- Refresh Token based authentication
- Automatic upload of attachments to Google Drive
- Automatic deletion of Google Drive files when attachments are removed from BC
- Generic attachment mapping table
- Google File ID tracking
- Google Drive URL tracking
- Folder-based uploads
- Connection testing from BC
- Extensible to any BC document using Document Attachments

## Currently Supported

- Sales Orders

## Easily Extendable To

- Purchase Orders
- Transfer Orders
- Posted Documents
- Customers
- Vendors
- Service Documents
- Custom Tables

---

# 1. Create a Google Cloud Project

1. Open https://console.cloud.google.com
2. Create a new project.
3. Select the project.

---

# 2. Enable Google Drive API

1. Navigate to:

   APIs & Services → Library

2. Search for:

   Google Drive API

3. Click Enable.

---

# 3. Configure OAuth Consent Screen

1. Navigate to:

   APIs & Services → OAuth Consent Screen

2. Select External.

3. Enter:

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

   Create Credentials → OAuth Client ID

3. Select:

   Web Application

4. Add Redirect URI:

```text
https://developers.google.com/oauthplayground
```

5. Save.

6. Copy:

```text
Client ID
Client Secret
```

---

# 5. Generate Refresh Token

1. Open:

   https://developers.google.com/oauthplayground

2. Click the gear icon.

3. Enable:

```text
Use your own OAuth credentials
```

4. Enter Client ID and Client Secret.

5. Scope:

```text
https://www.googleapis.com/auth/drive.file
```

6. Click Authorize APIs.

7. Sign in with the Google account.

8. Click Exchange Authorization Code for Tokens.

9. Copy the Refresh Token.

---

# 6. Create Google Drive Folder

1. Create a folder in Google Drive.

Example:

```text
BC Integration
```

2. Open the folder.

3. Copy Folder ID from URL.

Example:

```text
https://drive.google.com/drive/folders/1ppBx3-qmqEZNCB3Ovkt6ZraQTUVVYmh6
```

Folder ID:

```text
1ppBx3-qmqEZNCB3Ovkt6ZraQTUVVYmh6
```

---

# 7. Business Central Objects

## Table: Google Drive Setup

Fields:

- Client ID
- Client Secret
- Refresh Token
- Target Folder ID
- Redirect URI

---

## Page: Google Drive Setup

Fields:

- Client ID
- Client Secret
- Refresh Token
- Target Folder ID
- Redirect URI

Actions:

- Test Connection

---

## Table: Google Drive Attachment

Stores attachment mappings between Business Central and Google Drive.

| Field | Description |
|---------|---------|
| Attachment ID | BC Attachment ID |
| Table ID | Source Table |
| Document No. | Source Document |
| Document Type | Source Document Type |
| File Name | File Name |
| Google File ID | Google Drive File ID |
| Google Drive URL | Drive URL |
| Uploaded DateTime | Upload Date/Time |
| Uploaded By | User ID |

---

## Codeunit: Google Drive Upload

Responsibilities:

- Generate Access Token
- Upload File
- Delete File
- Return Google File ID
- Return Drive URL

---

## Codeunit: Google Drive Attachment Management

Responsibilities:

- Handle attachment events
- Upload files
- Create mapping records
- Delete mapping records
- Delete Google Drive files
- Retrieve Google File IDs

---

# 8. Configure Setup in Business Central

Open:

```text
Google Drive Setup
```

Populate:

| Field | Value |
|---------|---------|
| Client ID | OAuth Client ID |
| Client Secret | OAuth Client Secret |
| Refresh Token | Refresh Token |
| Target Folder ID | Google Drive Folder ID |
| Redirect URI | https://developers.google.com/oauthplayground |

Click:

```text
Test Connection
```

Expected:

```text
Connection Successful
```

---

# 9. Upload Flow

1. User uploads a file through Attachments.
2. BC creates Document Attachment.
3. Attachment content is read.
4. File uploads to Google Drive.
5. Google returns:
   - File ID
   - URL
6. Mapping record is created.

Flow:

```text
Business Central Attachment
        │
        ▼
Document Attachment Event
        │
        ▼
Google Drive Upload Codeunit
        │
        ▼
Google Drive API
        │
        ▼
Google File ID + URL
        │
        ▼
Google Drive Attachment Table
```

---

# 10. Delete Flow

1. User deletes attachment in BC.
2. Mapping record is located.
3. Google File ID is retrieved.
4. File is deleted from Drive.
5. Mapping record is removed.

Flow:

```text
Business Central Attachment Deleted
                │
                ▼
     Find Mapping Record
                │
                ▼
      Get Google File ID
                │
                ▼
     Delete File From Drive
                │
                ▼
      Delete Mapping Record
```

---

# Generic Design

The solution stores Google Drive references in a dedicated mapping table instead of document tables.

Benefits:

- Multiple attachments per document
- Multiple document types
- Centralized tracking
- Reusable architecture
- Easier maintenance

---

# Future Enhancements

- Purchase Order support
- Transfer Order support
- Posted Document support
- Customer support
- Vendor support
- Google Drive FactBox
- Open file directly from BC
- Retry failed uploads
- Sync status tracking
- Job Queue processing
- Background uploads

---

# Troubleshooting

## OAuth token refresh failed (401)

Cause:

- Invalid Client ID
- Invalid Client Secret
- Invalid Refresh Token

Resolution:

- Verify OAuth configuration
- Regenerate Refresh Token

---

## invalid_client

Cause:

- Wrong Client ID
- Deleted OAuth Client

Resolution:

- Create a new OAuth Client
- Update BC Setup

---

## Missing end boundary in multipart body

Cause:

- Multipart upload formatting issue

Resolution:

- Use BC 28 SaaS compatible upload implementation

---

## File uploaded as Untitled

Cause:

- File uploaded without metadata

Resolution:

- Update file metadata after upload

---

## Folder not receiving files

Cause:

- Invalid Folder ID

Resolution:

- Verify Folder ID copied from Google Drive

---

# Result

After configuration:

- Attachments uploaded in BC are automatically uploaded to Google Drive.
- Google File IDs and URLs are stored in Business Central.
- Deleted attachments can automatically delete files from Google Drive.
- Mapping records remain synchronized.
- Architecture is generic and reusable across Business Central.
