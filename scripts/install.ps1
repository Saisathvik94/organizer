#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"

# =========================
# CONFIG
# =========================
$Repo       = "Saisathvik94/organizer"
$Binary     = "organizer.exe"
$InstallDir = "$env:ProgramFiles\Organizer"
$TempDir    = Join-Path $env:TEMP "organizer-install"

# =========================
# FUNCTIONS
# =========================
function Show-ASCII {
@"
 ██████  ██████   ██████   █████  ███    ██ ██ ███████ ███████ ██████  
██    ██ ██   ██ ██       ██   ██ ████   ██ ██    ███  ██      ██   ██ 
██    ██ ██████  ██   ███ ███████ ██ ██  ██ ██   ███   █████   ██████  
██    ██ ██   ██ ██    ██ ██   ██ ██  ██ ██ ██  ███    ██      ██   ██ 
 ██████  ██   ██  ██████  ██   ██ ██   ████ ██ ███████ ███████ ██   ██                                                                                                                                               
"@
}

function Ensure-Admin {
    $isAdmin = ([Security.Principal.WindowsPrincipal]
        [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

    if (-not $isAdmin) {
        Write-Error "❌ Please run this script as Administrator"
        exit 1
    }
}

# =========================
# START INSTALL
# =========================
Ensure-Admin
Show-ASCII

Write-Host "🚀 Installing Organizer..." -ForegroundColor Cyan

# Create temp directory
New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

# Fetch latest release
Write-Host "🔍 Fetching latest release..."
$Latest  = Invoke-RestMethod "https://api.github.com/repos/$Repo/releases/latest"
$Version = $Latest.tag_name

$ZipName = "organizer_${Version}_windows_amd64.zip"
$Url     = "https://github.com/$Repo/releases/download/$Version/$ZipName"
$ZipPath = Join-Path $TempDir $ZipName

# Download
Write-Host "📦 Downloading $ZipName"
Invoke-WebRequest -Uri $Url -OutFile $ZipPath

# Extract
Write-Host "📂 Extracting files"
Expand-Archive $ZipPath -DestinationPath $TempDir -Force

# Validate binary
$ExtractedBinary = Join-Path $TempDir $Binary
if (-not (Test-Path $ExtractedBinary)) {
    Write-Error "❌ Organizer binary not found after extraction"
    exit 1
}

# Clean previous install
if (Test-Path (Join-Path $InstallDir $Binary)) {
    Write-Host "🧹 Removing existing Organizer"
    Remove-Item (Join-Path $InstallDir $Binary) -Force
}

# Install
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Move-Item $ExtractedBinary $InstallDir -Force

# Add to PATH (once)
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($CurrentPath -notlike "*$InstallDir*") {
    Write-Host "➕ Adding Organizer to PATH"
    [Environment]::SetEnvironmentVariable(
        "Path",
        "$CurrentPath;$InstallDir",
        "Machine"
    )
}

# Cleanup
Remove-Item $TempDir -Recurse -Force

# Done
Write-Host ""
Write-Host "✅ Organizer installed successfully!" -ForegroundColor Green
Write-Host "📌 Version: $Version"
Write-Host "📂 Location: $InstallDir"
Write-Host "🔁 Restart your terminal and run:"
Write-Host "   organizer --help" -ForegroundColor Yellow
