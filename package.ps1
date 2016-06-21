Write-Output "Packaging Lambda app"
Remove-Item -Recurse -Force .\package
New-Item .\package -type directory -f
New-Item .\package\temp -type directory -f
Copy-Item .\backup.js .\package\temp\
Copy-Item .\diff.js .\package\temp\
Copy-Item .\index.js .\package\temp\
Copy-Item .\s3-backfill.js .\package\temp\
Copy-Item .\s3-snapshot.js .\package\temp\
Copy-Item .\node_modules\ .\package\temp\ -recurse

$dc2 = New-Object System.Management.Automation.Host.ChoiceDescription "&2", "Deploys to dc2"
$dc3 = New-Object System.Management.Automation.Host.ChoiceDescription "&3", "Deploys to dc3"
$dc4 = New-Object System.Management.Automation.Host.ChoiceDescription "&4", "Deploys to dc4"
$dc5 = New-Object System.Management.Automation.Host.ChoiceDescription "&5", "Deploys to dc5"
$dc6 = New-Object System.Management.Automation.Host.ChoiceDescription "&6", "Deploys to dc6"
$dc7 = New-Object System.Management.Automation.Host.ChoiceDescription "&7", "Deploys to dc7"
$dc8 = New-Object System.Management.Automation.Host.ChoiceDescription "&8", "Deploys to dc8"

Write-Output "Which DC would you like to deploy to?"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($dc2, $dc3, $dc4, $dc5, $dc6, $dc7, $dc8)
$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
$dcDeploy = 0

switch ($result)
{
	0 {$dcDeploy = 2}
	1 {$dcDeploy = 3}
	2 {$dcDeploy = 4}
	3 {$dcDeploy = 5}
	4 {$dcDeploy = 6}
	5 {$dcDeploy = 7}
	6 { $dcDeploy = 8}
}
Copy-Item .\config\dc$dcDeploy.env .\package\temp\deploy.env

$version = Read-Host -Prompt 'What version of the application are you deploying?'

$currentdir = $PSScriptRoot
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($currentdir + "\package\temp", $currentdir + ".\package\" + $version + ".zip")