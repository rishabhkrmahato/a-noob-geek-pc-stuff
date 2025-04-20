# Remove PDF Passwords on Android using Termux

This guide explains how to remove passwords from PDF files directly on your Android device using Termux and command-line tools like PDFtk or QPDF. This offline method is ideal for sensitive documents like bank statements where online tools are not suitable.

**Prerequisites:**

* An Android device.
* Termux app installed ([GitHub](https://github.com/termux/termux-app) or [F-Droid](https://f-droid.org/)).

---

## 1. Setup Termux and Storage Access

* Install Termux from your chosen source (GitHub or F-Droid).
* Open Termux and grant necessary permissions when prompted.
* Run the following command to set up access to your device's storage:
    ```bash
    termux-setup-storage
    ```
    *You will likely see a system prompt asking for permission to access files; make sure to **Allow** it.*

## 2. Navigate to Your PDF's Directory

* Use the `cd` (change directory) command to go to the folder containing your password-protected PDF. The path usually starts with `/storage/emulated/0/`, which represents your internal storage.
    ```bash
    cd /storage/emulated/0/path/to/your/pdf/folder
    ```
    *Replace `/path/to/your/pdf/folder` with the actual path (e.g., `cd /storage/emulated/0/Download`). You can use a file manager app on your phone to find the correct path.*

## 3. Install PDFtk

* Install PDFtk, a powerful tool for PDF manipulation:
    ```bash
    pkg update && pkg upgrade
    pkg install pdftk
    ```
    *Running `pkg update && pkg upgrade` first is recommended to ensure your package lists are up-to-date.*

## 4. Remove Password with PDFtk

* Use the following command to create a decrypted version of your PDF:
    ```bash
    pdftk <your-input-file.pdf> input_pw <your-password> output <your-output-file.pdf>
    ```
    * Replace `<your-input-file.pdf>` with the exact name of your locked PDF.
    * Replace `<your-password>` with the actual password of the PDF.
    * Replace `<your-output-file.pdf>` with the desired name for the unlocked PDF.
    * **Example:** `pdftk "My Bank Statement.pdf" input_pw S3cr3tP@ssw0rd output Statement-unlocked.pdf`
    * *Note: If your filename or password contains spaces or special characters, enclose them in quotes (`"`).*
    * The unlocked file (`<your-output-file.pdf>`) will be saved in the current directory.

## 5. Alternative: Use QPDF (Optional)

* If PDFtk doesn't work or you prefer another tool, you can use QPDF.
* Install QPDF:
    ```bash
    pkg install qpdf
    ```
* Run the decryption command:
    ```bash
    qpdf --password=<your-password> --decrypt <your-input-file.pdf> <your-output-file.pdf>
    ```
    * Replace the placeholders (`<your-password>`, `<your-input-file.pdf>`, `<your-output-file.pdf>`) as described in the PDFtk section.
    * **Example:** `qpdf --password=S3cr3tP@ssw0rd --decrypt "My Bank Statement.pdf" Statement-unlocked.pdf`

## 6. Troubleshooting: Fixing Mirror Errors

* If you encounter errors during `pkg install` related to repositories or mirrors, run:
    ```bash
    termux-change-repo
    ```
    *Follow the on-screen prompts. It's often best to select the `Main repository` and then try selecting mirrors using spacebar until you find ones that work (often `Grimler` mirrors are reliable).*
* After changing the repository, update your package lists again:
    ```bash
    pkg update && pkg upgrade
    ```
* Then, try installing PDFtk or QPDF again.

---

## Additional Notes

* **Legality & Ethics:** Only remove passwords from PDFs you own or have explicit permission to modify.
* **Sensitive Data:** As mentioned, using offline tools like these is much safer for confidential documents compared to uploading them to online services.
* **PDF24 Tools:** If you need a broader range of PDF tools, PDF24 Tools is a great option. It offers an online version (use with caution for sensitive data) and a free offline version *for Windows PCs*.