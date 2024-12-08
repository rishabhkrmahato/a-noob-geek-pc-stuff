#Requires AutoHotkey v2.0

; script to search highlighted text with google with defualt browser, or directly go to the URL if selection is a link.
; AutoHotkey v2 script to search highlighted text with Google or open as a URL, with Win + Shift + G as trigger.

#+g::  ; Press Win + Shift + G to trigger
{
    ; Copy the highlighted text to the clipboard
    Clipboard := ""
    Send "^c"  ; Copy
    ClipWait(0.5)  ; Wait for the clipboard to populate (timeout: 0.5s)

    if !Clipboard  ; Check if the clipboard is empty
        return

    text := Clipboard.Trim()  ; Get trimmed clipboard text

    ; Regex to check if the text is a valid URL
    if RegExMatch(text, "^(https?://|www\.)[^\s]+$")
    {
        ; Open the URL directly in the default browser
        Run(text)
    }
    else
    {
        ; URL encode the text for Google search
        searchQuery := StrReplace(text, " ", "+")
        Run("https://www.google.com/search?q=" searchQuery)
    }
}
