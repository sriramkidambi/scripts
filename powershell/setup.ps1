# Check for existing PowerShell version 
if((Get-HostProcess).SessionId -ne 0){
  Write-Host "This script needs to be run within an Administrator PowerShell session."
  exit 1
}
$CurrentVersion = (Get-Command powershell).Version

# Download the latest PowerShell installer
$InstallUrl = "https://aka.ms/PSLatest"
Invoke-WebRequest -Uri $InstallUrl -OutFile .\powershell.msi

# Install PowerShell (if necessary)
if ($CurrentVersion -lt (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ImageSettings" -Name "OSInstallVersion") ) {
 Write-Host "Installing latest PowerShell..."
 msiexec /i powershell.msi
} else {
  Write-Host "Latest PowerShell already installed."
}

# Set execution policy (temp for this script only)
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Oh My Posh
Set-Location -Path "$env:USERPROFILE\.oh-my-posh"
Invoke-WebRequest -Uri "https://github.com/ohmyposh/ohmyposh/releases/latest/download/ohmyposh-installer.ps1" -OutFile .\ohmyposh-installer.ps1
. .\ohmyposh-installer.ps1

# Configure Oh My Posh
ohmyposh configure

# Create profile file (only if it doesn't exist)
if (!(Test-Path $PROFILE)) {
  New-Item -Path $PROFILE -Type File -Force
  Write-Host "New PowerShell profile file created: $($PROFILE)"
}

# Add Oh My Posh and Terminal Icons to the profile
$ProfileContent = Get-Content $PROFILE
$ProfileContent += "oh-my-posh init pwsh --config '$env:POSH_THEMES_PATH\atomic.omp.json' | Invoke-Expression"
$ProfileContent += "`nImport-Module -Name Terminal-Icons"

Set-Content $PROFILE -Value $ProfileContent

# Clean up installer files
Remove-Item .\powershell.msi
Remove-Item .\ohmyposh-installer.ps1


