# Edit the folder paths to match your specific use case.
# Not sure if this will be useful, but I created it anyway.

import time
import logging
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class GitHubMonitorHandler(FileSystemEventHandler):
    def __init__(self, log_file):
        self.log_file = log_file

    def log_event(self, event_type, src_path):
        message = f"{time.strftime('%Y-%m-%d %H:%M:%S')} - {event_type}: {src_path}"
        logging.info(message)

    def on_modified(self, event):
        if event.is_directory:
            event_type = "Directory Modified"
        else:
            event_type = "File Modified"
        self.log_event(event_type, event.src_path)

    def on_created(self, event):
        if event.is_directory:
            event_type = "Directory Created"
        else:
            event_type = "File Created"
        self.log_event(event_type, event.src_path)

    def on_deleted(self, event):
        if event.is_directory:
            event_type = "Directory Deleted"
        else:
            event_type = "File Deleted"
        self.log_event(event_type, event.src_path)

if __name__ == "__main__":
    folder_to_monitor = r"C:\Users\mahat\Documents\GitHub"
    log_file = r"C:\Users\mahat\Documents\GitHub\real_time_changes.log"

    # Set up logging
    logging.basicConfig(
        filename=log_file,
        level=logging.INFO,
        format='%(asctime)s - %(message)s'
    )

    event_handler = GitHubMonitorHandler(log_file)
    observer = Observer()

    # Using a context manager to ensure the observer is properly cleaned up
    observer.schedule(event_handler, path=folder_to_monitor, recursive=True)
    
    logging.info(f"Monitoring folder: {folder_to_monitor}")
    logging.info(f"Logs will be saved to: {log_file}")

    observer.start()
    try:
        while True:
            time.sleep(1)  # Keeps the script running
    except KeyboardInterrupt:
        observer.stop()
        logging.info("\nMonitoring stopped.")
    observer.join()
