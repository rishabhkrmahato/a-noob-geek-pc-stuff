import customtkinter as ctk
from tkinter import messagebox
import subprocess
import time
import shutil

# --- CONFIGURATION ---
MPC_PATH = r"C:\Program Files (x86)\K-Lite Codec Pack\MPC-HC64\mpc-hc64.exe"
VLC_PATH = shutil.which("vlc") or r"C:\Program Files\VideoLAN\VLC\vlc.exe"
MPV_PATH = shutil.which("mpv") or "mpv.exe"

# --- APPEARANCE SETUP ---
ctk.set_appearance_mode("System")  # Modes: "System" (standard), "Dark", "Light"
ctk.set_default_color_theme("blue")  # Themes: "blue" (standard), "green", "dark-blue"

class MediaLauncherApp(ctk.CTk):
    def __init__(self):
        super().__init__()

        # Window Setup
        self.title("Media Launcher")
        self.geometry("500x600")
        self.grid_columnconfigure(0, weight=1) # Center everything

        # 1. Header Label
        self.label = ctk.CTkLabel(self, text="Media Link Launcher", font=("Roboto Medium", 20))
        self.label.grid(row=0, column=0, padx=20, pady=(20, 10))

        # 2. Text Input Box
        self.textbox = ctk.CTkTextbox(self, width=400, height=200, corner_radius=10)
        self.textbox.grid(row=1, column=0, padx=20, pady=10)
        self.textbox.insert("1.0", "Paste links here...\n")

        # 3. Paste Button
        self.btn_paste = ctk.CTkButton(self, text="Paste from Clipboard", 
                                       command=self.paste_from_clipboard,
                                       fg_color="transparent", border_width=2, 
                                       text_color=("gray10", "#DCE4EE"))
        self.btn_paste.grid(row=2, column=0, padx=20, pady=10)

        # 4. Player Selection (Radio Buttons)
        self.player_var = ctk.StringVar(value="VLC")
        self.radio_frame = ctk.CTkFrame(self)
        self.radio_frame.grid(row=3, column=0, padx=20, pady=10)
        
        self.label_radio = ctk.CTkLabel(self.radio_frame, text="Select Player:", font=("Roboto Medium", 14))
        self.label_radio.grid(row=0, column=0, padx=10, pady=10)

        self.radio_vlc = ctk.CTkRadioButton(self.radio_frame, text="VLC", variable=self.player_var, value="VLC")
        self.radio_vlc.grid(row=0, column=1, padx=10, pady=10)

        self.radio_mpc = ctk.CTkRadioButton(self.radio_frame, text="MPC-HC", variable=self.player_var, value="MPC-HC")
        self.radio_mpc.grid(row=0, column=2, padx=10, pady=10)

        self.radio_mpv = ctk.CTkRadioButton(self.radio_frame, text="mpv", variable=self.player_var, value="mpv")
        self.radio_mpv.grid(row=0, column=3, padx=10, pady=10)

        # 5. Launch Button
        self.btn_launch = ctk.CTkButton(self, text="LAUNCH MEDIA", 
                                        command=self.launch_media,
                                        height=50, font=("Roboto Medium", 16),
                                        fg_color="#2CC985", hover_color="#26AB71") # Greenish color
        self.btn_launch.grid(row=4, column=0, padx=20, pady=20)

        # 6. Status Label
        self.status_label = ctk.CTkLabel(self, text="Ready", text_color="gray")
        self.status_label.grid(row=5, column=0, padx=20, pady=10)

    def paste_from_clipboard(self):
        try:
            clipboard_text = self.clipboard_get()
            self.textbox.delete("1.0", "end")
            self.textbox.insert("1.0", clipboard_text)
            self.status_label.configure(text="Links pasted from clipboard.")
        except:
            self.status_label.configure(text="Clipboard empty.")

    def launch_media(self):
        selected_player = self.player_var.get()
        raw_text = self.textbox.get("1.0", "end").strip()
        
        # Clean up default text if user didn't delete it
        if "Paste links here..." in raw_text:
             raw_text = raw_text.replace("Paste links here...", "")

        links = [line.strip() for line in raw_text.split('\n') if line.strip()]

        if not links:
            self.status_label.configure(text="Error: No links found.")
            return

        # Determine executable path
        exe_path = ""
        if selected_player == "MPC-HC":
            exe_path = MPC_PATH
        elif selected_player == "VLC":
            exe_path = VLC_PATH
        elif selected_player == "mpv":
            exe_path = MPV_PATH

        self.status_label.configure(text=f"Launching {len(links)} links via {selected_player}...")
        self.update() # Force UI update

        for i, link in enumerate(links):
            try:
                if selected_player == "MPC-HC":
                    # THE FIX: /new forces new instance
                    subprocess.Popen([exe_path, link, "/new"])
                else:
                    subprocess.Popen([exe_path, link])
                
                if i < len(links) - 1:
                    self.status_label.configure(text=f"Opened {i+1}/{len(links)}. Waiting 5s...")
                    self.update()
                    time.sleep(5)
            except Exception as e:
                messagebox.showerror("Error", f"Could not launch player.\n{e}")
                return

        self.status_label.configure(text="All links launched!")

if __name__ == "__main__":
    app = MediaLauncherApp()
    app.mainloop()