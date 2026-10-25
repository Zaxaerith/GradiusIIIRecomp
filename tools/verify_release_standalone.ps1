# GradiusIIIRecomp - Official Release Standalone Independent Verification
param(
    [string]$Version = "0.1.0-preview"
)

$ErrorActionPreference = 'Stop'

$projectRoot = (Resolve-Path "$PSScriptRoot\..").Path
$zipName = "GradiusIIIRecomp-windows-x64-v$Version.zip"
$zipPath = Join-Path $projectRoot "dist\$zipName"
$realRom = Join-Path $projectRoot "Gradius III (USA).sfc"
$testBase = Join-Path $env:LOCALAPPDATA "GradiusIIIReleaseValidation"

if (-not (Test-Path $zipPath)) { throw "Release ZIP not found at $zipPath" }
if (-not (Test-Path $realRom)) { throw "ROM not found at $realRom" }

if (Test-Path $testBase) { Remove-Item -Recurse -Force $testBase }
New-Item -ItemType Directory -Path $testBase -Force | Out-Null

Write-Host "=== Step 1: Extracting $zipName to Clean Test Directory ==="
Expand-Archive -Path $zipPath -DestinationPath $testBase

$extractedDir = Join-Path $testBase "GradiusIIIRecomp-windows-x64-v$Version"
$exePath = Join-Path $extractedDir "GradiusIiiSNESRecomp.exe"

if (-not (Test-Path $exePath)) {
    throw "Executable missing in extracted directory: $exePath"
}

Write-Host "Extracted directory: $extractedDir"
Get-ChildItem -Path $extractedDir

Write-Host "`n=== Step 2: Verifying Integrity Level and Permissions ==="
icacls $exePath

# Sanitize PATH completely
$oldPath = $env:PATH
$env:PATH = "C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem"

function Run-Step([string]$name, [string[]]$procArgs, [int]$timeoutMs = 15000, [int]$expectedExit = 0) {
    Write-Host "`n--- Running: $name ---"
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $exePath
    $psi.WorkingDirectory = $extractedDir
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $false
    $psi.RedirectStandardError = $false
    if ($procArgs -and $procArgs.Count -gt 0) {
        $psi.Arguments = ($procArgs -join " ")
    }
    
    $p = [System.Diagnostics.Process]::Start($psi)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $exited = $p.WaitForExit($timeoutMs)
    $sw.Stop()
    
    if (-not $exited) {
        Write-Warning "Process $($p.Id) timed out in $name. Forcing kill."
        try { $p.Kill() } catch { }
        throw "Failed: $name timed out after ${timeoutMs}ms"
    }
    
    Write-Host "Result: ExitCode=$($p.ExitCode), Elapsed=$($sw.ElapsedMilliseconds)ms"
    if ($p.ExitCode -ne $expectedExit) {
        throw "Failed: $name expected exit code $expectedExit but got $($p.ExitCode)"
    }
    Write-Host "PASS: $name"
}

try {
    # 1. First launch without ROM (smoke 25 frames)
    $env:LNG_SMOKE_FRAMES = "25"
    Run-Step "1. First Launch Without ROM (GUI Smoke 25 frames)" @() -expectedExit 0
    Remove-Item Env:\LNG_SMOKE_FRAMES

    # 2. Reject Invalid / Corrupt ROM
    $badRom = Join-Path $extractedDir "corrupt_rom.sfc"
    $dummyBytes = New-Object byte[] (524288)
    [System.IO.File]::WriteAllBytes($badRom, $dummyBytes)
    [System.IO.File]::WriteAllText((Join-Path $extractedDir "rom.cfg"), $badRom)
    [System.IO.File]::WriteAllText((Join-Path $extractedDir "config.local.ini"), "[General]`r`nSkipLauncher = 1`r`n")

    # 2a: With SkipLauncher=1, boot is rejected immediately with error code 1
    Run-Step "2a. Corrupt ROM Rejection with SkipLauncher=1 (ExitCode 1)" @() -expectedExit 1

    # 2b: With SkipLauncher=0, corrupt ROM causes GUI launcher to open and warn
    [System.IO.File]::WriteAllText((Join-Path $extractedDir "config.local.ini"), "[General]`r`nSkipLauncher = 0`r`n")
    $env:LNG_SMOKE_FRAMES = "25"
    Run-Step "2b. Corrupt ROM Handling with Launcher GUI (Smoke 25 frames)" @() -expectedExit 0
    Remove-Item Env:\LNG_SMOKE_FRAMES
    Remove-Item $badRom -Force

    # 3. Direct game launch with valid ROM and SkipLauncher=1 + Autosave=1
    $destRom = Join-Path $extractedDir "Gradius III (USA).sfc"
    Copy-Item $realRom -Destination $destRom
    [System.IO.File]::WriteAllText((Join-Path $extractedDir "rom.cfg"), $destRom)
    [System.IO.File]::WriteAllText((Join-Path $extractedDir "config.local.ini"), "[General]`r`nSkipLauncher = 1`r`nAutosave = 1`r`n")

    $env:SNESRECOMP_RUN_FRAMES = "200"
    Run-Step "3. Direct Game Launch with Valid ROM (200 frames)" @() -expectedExit 0
    Remove-Item Env:\SNESRECOMP_RUN_FRAMES

    # 4. Check savestate generated and reload
    $save0 = Join-Path $extractedDir "saves\save0.sav"
    if (Test-Path $save0) {
        $saveItem = Get-Item $save0
        Write-Host "Save state successfully generated: $($saveItem.Length) bytes at $save0"
    } else {
        throw "Expected save state not found at $save0"
    }

    $env:SNESRECOMP_RUN_FRAMES = "60"
    Run-Step "4. Reload Save State & Run (60 frames)" @() -expectedExit 0
    Remove-Item Env:\SNESRECOMP_RUN_FRAMES

    # 5. Force launcher open with --launcher flag even with SkipLauncher=1
    $env:LNG_SMOKE_FRAMES = "25"
    Run-Step "5. Force Launcher Override (--launcher flag)" @("--launcher") -expectedExit 0
    Remove-Item Env:\LNG_SMOKE_FRAMES

    # 6. Command line --help
    Run-Step "6. CLI Help Flag (--help)" @("--help") -expectedExit 0

    Write-Host "`n======================================================="
    Write-Host "  ALL RELEASE STANDALONE VERIFICATION STEPS PASSED CLEANLY "
    Write-Host "======================================================="
}
finally {
    # Restore PATH
    $env:PATH = $oldPath
    # Clean up test directory
    if (Test-Path $testBase) {
        Remove-Item -Recurse -Force $testBase
    }
}
