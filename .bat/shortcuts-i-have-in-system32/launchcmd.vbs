' to be used in powertoys 
' use wscript.exe (full path w/o quotes) as program 
' and this vbs script (full path w/o quotes) as args

Set objShell = CreateObject("WScript.Shell")
objShell.Run "cmd.exe /k cls", 1, False
Set objShell = Nothing
