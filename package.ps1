Write-Output "Packaging Lambda app"
Remove-Item -Recurse -Force .\package
New-Item .\package -type directory -f
New-Item .\package\temp -type directory -f
Copy-Item .\backup.js .\package\temp\
Copy-Item .\diff.js .\package\temp\
Copy-Item .\s3-backfill.js .\package\temp\
Copy-Item .\s3-snapshot.js .\package\temp\
Copy-Item .\node_modules\ .\package\temp\ -recurse

$environmentFile = Read-Host -Prompt 'Enter the name of the config file you would like to add to your deployment (e.g. dcx.env)'

$currentdir = $PSScriptRoot

New-Item .\package\temp\index.js -type file -f

get-content .\config\$environmentFile,".\index.js" | set-content ".\package\temp\index.js"

$packageName = "LambdaFunction"

$destination = $currentdir + "\package\" + $packageName + ".zip"

Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($currentdir + "\package\temp", $destination)

Write-Output "lambda app ready to be uploaded. Located at: " $destination