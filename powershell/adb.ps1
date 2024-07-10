# Define the URL for the latest Android platform tools
$platformToolsUrl = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
# Define the path to download the zip file
$zipFilePath = "$env:TEMP\platform-tools-latest-windows.zip"
# Define the destination directory
$destDir = "C:\adb"

# Download the platform tools zip file
Invoke-WebRequest -Uri $platformToolsUrl -OutFile $zipFilePath

# Create the destination directory if it doesn't exist
if (-Not (Test-Path -Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir
}

# Unzip the downloaded file to the destination directory
Expand-Archive -Path $zipFilePath -DestinationPath $destDir -Force

# Define the path to add to the system environment variables
$adbPath = [System.IO.Path]::Combine($destDir, "platform-tools")

# Check if the path is already in the system environment variable
$path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
if ($path -notcontains $adbPath) {
    # Add the path to the system environment variable
    [System.Environment]::SetEnvironmentVariable("Path", "$path;$adbPath", [System.EnvironmentVariableTarget]::Machine)
}

# Optionally, you can add the path to the user environment variable instead
# $userPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
# if ($userPath -notcontains $adbPath) {
#     [System.Environment]::SetEnvironmentVariable("Path", "$userPath;$adbPath", [System.EnvironmentVariableTarget]::User)
# }

# Clean up the downloaded zip file
Remove-Item -Path $zipFilePath

Write-Output "Android platform tools have been downloaded, extracted to C:\adb, and the path has been updated."
