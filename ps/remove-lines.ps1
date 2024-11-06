# i use this to remove multiple lines having a common text eg. here: 
# edit and change it accordingly

$filePath = "C:\Users\mahat\Documents\GitHub\files-in-my-repo.txt"
$text = Get-Content $filePath | Where-Object { $_ -notmatch 'C:\\Users\\mahat\\Documents\\GitHub\\a-noob-geek-pc-stuff\\.git\\objects\\' }
$text | Set-Content $filePath
