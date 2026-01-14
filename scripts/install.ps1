# Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"

# Config
$Repo = "Saisathvik94/organizer"
$Binary = "organizer.exe"
$InstallDir = "$env:ProgramFiles\Organizer"
$TempDir = Join-Path $env:TEMP "organizer-install"

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
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "❌ Please run this script as Administrator!" -ForegroundColor Red
        exit 1
    }
}

function Download-Organizer {
    param($Version)
    $ZipName = "organizer_${Version}_windows_amd64.zip"
    $Url = "https://github.com/$Repo/releases/download/$Version/$ZipName"

    Write-Host "📦 Downloading $ZipName ..." -ForegroundColor Yellow

    if (-Not (Test-Path $TempDir)) {
        New-Item -ItemType Directory -Path $TempDir | Out-Null
    }

    $ZipPath = Join-Path $TempDir $ZipName
    Invoke-WebRequest -Uri $Url -OutFile $ZipPath
    return $ZipPath
}

function Install-Organizer {
    param($ZipPath)
    
    # Extract zip
    Write-Host "📂 Extracting archive ..." -ForegroundColor Yellow
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $TempDir -Force

    # Clean old install
    if (Test-Path "$InstallDir\$Binary") {
        Write-Host "🧹 Removing existing organizer ..." -ForegroundColor Yellow
        Remove-Item "$InstallDir\$Binary" -Force
    }

    # Create install directory
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

    # Move binary
    Move-Item (Join-Path $TempDir $Binary) $InstallDir -Force

    # Add to PATH (only if not present)
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    if ($currentPath -notlike "*$InstallDir*") {
        [Environment]::SetEnvironmentVariable(
            "Path",
            "$currentPath;$InstallDir",
            "Machine"
        )
    }

    # Cleanup temp
    Remove-Item $TempDir -Recurse -Force

    Write-Host "✅ Organizer installed successfully!" -ForegroundColor Green
    Write-Host "🔁 Restart terminal and run: organizer --help"
}

# --- SCRIPT EXECUTION ---
Ensure-Admin
Show-ASCII

# Get latest release version
$Latest = Invoke-RestMethod "https://api.github.com/repos/$Repo/releases/latest"
$Version = $Latest.tag_name

$ZipPath = Download-Organizer -Version $Version
Install-Organizer -ZipPath $ZipPath
