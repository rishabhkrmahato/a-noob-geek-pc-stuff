### **EASY PDF-TOOLS FOR ANDROID**

1. **Get Termux**  
   Download Termux from [GitHub](https://github.com/termux/termux-app) or [F-Droid](https://f-droid.org/). 
   Install it and **_give all necessary permissions_**.<br> 
   Run this to set up storage access:  
   ```bash
   termux-setup-storage
   ```
<br>

2. **Navigate to Your PDF Directory**
   Use the `cd` command to go to the **_folder_** with your PDF:  
   ```bash
   cd /storage/emulated/0/path-to-the-directory-of-your-pdf
   ```
   Replace `/path-to-the-directory-of-your-pdf` with the actual path.
<br>

3. **Install PDFtk**  
   Install the tool for managing PDFs:  
   ```bash
   pkg install pdftk
   ```
<br>

4. **Remove Password with PDFtk**  
   Run this command to decrypt your PDF:  
   ```bash
   pdftk input.pdf input_pw password123 output output.pdf
   ```
   Replace `input.pdf`, `password123`, and `output.pdf` with your file name, password, and desired output file name.
<br>

5. **Use Other Tools (Optional)**    
   If you prefer alternatives:
   <br>
   - **QPDF:**  
     ```bash
     pkg install qpdf
     qpdf --password=password123 --decrypt input.pdf output.pdf
     ```
<br>

6. **Fix Mirror Errors in Termux**  
   If you get errors during installation:  
   (select all mirrors in the interactive menu)
   ```bash
   termux-change-repo 
   apt update && apt upgrade
   ```
<br>

For example, I recently used it to remove the password from a bank statement PDF. 
Since I couldn't use online tools for such sensitive data, I relied on offline methods. 
If you ever decide to use an online tool, **PDF24 Tools** is one of the best options—it works both online and offline (PC-only) and is excellent for handling anything PDF.
