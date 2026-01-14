#Requires -RunAsAdministrator
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

    if ($Version -eq "snapshot") {
        $ZipName = "organizer_snapshot_win_amd64.zip"
    } else {
        $ZipName = "organizer_${Version}_win_amd64.zip"
    }

    $Url = "https://github.com/$Repo/releases/download/$Version/$ZipName"
    Write-Host "📦 Downloading $ZipName ..." -ForegroundColor Yellow

    New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
    $ZipPath = Join-Path $TempDir $ZipName

    Invoke-WebRequest -Uri $Url -OutFile $ZipPath
    return $ZipPath
}

function Install-Organizer {
    param($ZipPath)

    Write-Host "📂 Extracting archive ..." -ForegroundColor Yellow
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $TempDir -Force

    $ExtractedBinary = Join-Path $TempDir $Binary
    if (-not (Test-Path $ExtractedBinary)) {
        Write-Error "❌ Organizer binary not found after extraction"
        exit 1
    }

    if (Test-Path "$InstallDir\$Binary") {
        Write-Host "🧹 Removing existing organizer ..." -ForegroundColor Yellow
        Remove-Item "$InstallDir\$Binary" -Force
    }

    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    Move-Item $ExtractedBinary $InstallDir -Force

    $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    if ($currentPath -notlike "*$InstallDir*") {
        [Environment]::SetEnvironmentVariable(
            "Path",
            "$currentPath;$InstallDir",
            "Machine"
        )
    }

    Remove-Item $TempDir -Recurse -Force

    Write-Host "✅ Organizer installed successfully!" -ForegroundColor Green
    Write-Host "🔁 Restart terminal and run: organizer --help"
}

# --- SCRIPT EXECUTION ---
Ensure-Admin
Show-ASCII

$Latest = Invoke-RestMethod "https://api.github.com/repos/$Repo/releases/latest"
$Version = $Latest.tag_name

$ZipPath = Download-Organizer -Version $Version
Install-Organizer -ZipPath $ZipPath
