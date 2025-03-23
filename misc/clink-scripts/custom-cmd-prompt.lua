-- save this script to any folder and install via "clink installscripts <folder>"

function set_custom_prompt()
    local cwd = clink.get_cwd()  -- Get current working directory
    if cwd == os.getenv("USERPROFILE") then
        clink.prompt.value = "sonu> "  -- Set custom prompt
    else
        clink.prompt.value = cwd .. "> "  -- Set prompt to current directory
    end
end

clink.prompt.register_filter(set_custom_prompt, 1)
