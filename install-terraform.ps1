# Define install directory inside user's home folder
$home = [Environment]::GetFolderPath("UserProfile")
$installPath = "$home\tools\terraform"

# Create install directory if it doesn't exist
if (-Not (Test-Path -Path $installPath)) {
    New-Item -ItemType Directory -Path $installPath | Out-Null
    Write-Host "Created directory: $installPath"
} else {
    Write-Host "Directory already exists: $installPath"
}

# Function to get latest Terraform version dynamically from HashiCorp releases
function Get-LatestTerraformVersion {
    $url = "https://releases.hashicorp.com/terraform/index.json"
    try {
        $json = Invoke-RestMethod -Uri $url
        return $json.versions.PSObject.Properties.Name | Sort-Object -Descending | Select-Object -First 1
    } catch {
        Write-Error "Failed to fetch latest version: $_"
        exit 1
    }
}

$terraformVersion = Get-LatestTerraformVersion
Write-Host "Latest Terraform version detected: $terraformVersion"

# Download URL for latest terraform zip (windows amd64)
$terraformZipUrl = "https://releases.hashicorp.com/terraform/$terraformVersion/terraform_${terraformVersion}_windows_amd64.zip"
$zipPath = "$env:TEMP\terraform.zip"

Write-Host "Downloading Terraform from $terraformZipUrl..."
Invoke-WebRequest -Uri $terraformZipUrl -OutFile $zipPath -UseBasicParsing

Write-Host "Extracting to $installPath..."
Expand-Archive -Path $zipPath -DestinationPath $installPath -Force

Remove-Item $zipPath

# Add install path to user PATH if not already present
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($oldPath -notlike "*$installPath*") {
    $newPath = "$oldPath;$installPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Added $installPath to user PATH environment variable."
    Write-Host "Please restart your terminal or log out and back in for changes to take effect."
} else {
    Write-Host "$installPath is already in the user PATH."
}

# Verify terraform installation
Write-Host "`nTerraform version:"
& "$installPath\terraform.exe" -version
