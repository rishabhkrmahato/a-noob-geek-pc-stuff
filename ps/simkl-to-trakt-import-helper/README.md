# Simkl to Trakt Import Helper

A small Windows PowerShell helper that reads your own Simkl watch history, watchlist, and ratings, then creates a JSON file for Trakt's importer.

It does **not** upload anything to Trakt automatically. You review and upload the JSON yourself.

## What you need

- A Windows PC with Windows PowerShell (included with Windows).
- Your own Simkl account and a Simkl AUTH V2 app Client ID.
- A Trakt account.

No Python package, client secret, or administrator access is needed.

## One-time Simkl app setup

Each user should create their own app and use their own public Client ID:

1. Sign in to Simkl and open **Profile settings → Developer**.
2. Choose **Register an app** / **Create an AUTH V2 app**.
3. Select **TV, devices & command line**.
4. Name it **Simkl to Trakt Import Helper**, then review and create it.
5. Copy the app's **Client ID**. This helper asks for it when it starts.

This app type does not need a client secret or redirect URL. The helper requests read-only access to your Simkl library.

## Run it

1. Download or clone this repository, then open this folder.
2. Double-click **run-simkl-to-trakt-import-helper.bat**.
3. Paste your Simkl **Client ID** when asked. It is the public app ID, not an access token or secret.
4. On the first run, the helper displays a short code and opens Simkl's PIN page. Enter the code there and approve read access for the app.
5. Wait for the helper to create a JSON file. It opens the export folder when finished.
6. In Trakt, open **Settings → Data → JSON File**, select the generated `.json`, review the preview, and start the import.

Keep the command window open until it says the export finished. If a PIN prompt appears again later, enter the new code and approve access.

## Where your files and sign-in are stored

- JSON exports and summaries go to **Documents\Simkl to Trakt Import Helper Exports**, outside this repository.
- The activity snapshot and an encrypted refresh token are stored under your Windows user's **Local AppData**. The token is protected for your Windows account and is never written into the JSON file.
- The helper asks for the Client ID each time. It keeps separate local sign-in state for each Client ID.

Your JSON export contains personal viewing history, ratings, and watchlist data. Keep it private and do not commit or share it publicly. The `.gitignore` file is optional for running the helper. It tells Git to ignore generated import and summary files if they are copied into this folder by mistake.

## Later imports

The first run reads the full library. Later runs check Simkl's activity first and export only changes since the previous successful export. Upload each newly generated JSON once; if the helper says there are no changes, there is nothing to upload.

The activity marker advances when the helper successfully creates an export file. If you have not uploaded a generated file yet, keep it so you can upload it later.

## What transfers and limitations

- Movies: watched dates when available, Plan to Watch items, and ratings.
- TV and anime: episode history when Simkl provides an ID Trakt can match, Plan to Watch items, and show ratings.
- Trakt's importer has one general watchlist field, so Simkl's separate **Watching**, **On Hold**, **Dropped**, and **Completed** labels are not preserved as separate labels.
- Some episodes may be skipped if Simkl does not provide an identifier accepted by Trakt.
- This helper exports the current watch state exposed by Simkl's API; it does not export paid rewatch-session history.

## Privacy and safety

- Each user supplies their own Client ID. No user's Client ID is included in this repository.
- Never paste an access token, refresh token, PIN, or password into an issue or public chat.
- The helper only reads Simkl. You decide whether and when to upload the generated JSON to Trakt.

This is an independent community tool, not an official Simkl or Trakt application.
