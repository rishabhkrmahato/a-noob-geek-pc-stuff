import sys
import pyperclip

def slugify(text):
    # Convert to lowercase, replace spaces with dashes
    slug = "-".join(text.lower().split())
    return slug

if __name__ == "__main__":
    if len(sys.argv) > 1:
        input_text = " ".join(sys.argv[1:])  # Join arguments into a single string
        slugified = slugify(input_text)

        # Copy result to clipboard
        pyperclip.copy(slugified)

        # Print with formatting
        line = "-" * 80
        print(f"\n{line}\n\n{slugified.center(80)}\n\n{line}\n")
    else:
        print("Usage: slug <your text>")
