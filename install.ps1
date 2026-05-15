param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("claude", "codex", "antigravity", "all")]
    [string]$Model,

    [string]$ProjectRoot = "."
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsSrc = Join-Path $ScriptDir "skills"
$AdaptersDir = Join-Path $ScriptDir "adapters"

function Install-ForModel {
    param([string]$ModelName, [string]$Root)

    $adapterFile = Join-Path $AdaptersDir "$ModelName.json"
    if (-not (Test-Path $adapterFile)) {
        Write-Error "Unknown model '$ModelName'. Available: claude, codex, antigravity"
        return
    }

    $adapter = Get-Content $adapterFile | ConvertFrom-Json
    $target = Join-Path $Root $adapter.skills_dir

    Write-Host "Installing AI Radija Tools for $ModelName -> $target"

    $skillDirs = Get-ChildItem -Path $SkillsSrc -Directory -Filter "ai-radija-*"
    foreach ($skillDir in $skillDirs) {
        $destDir = Join-Path $target $skillDir.Name
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        Copy-Item (Join-Path $skillDir.FullName "SKILL.md") (Join-Path $destDir "SKILL.md") -Force
    }

    Write-Host "  Installed $($skillDirs.Count) skills."
}

if ($Model -eq "all") {
    Get-ChildItem -Path $AdaptersDir -Filter "*.json" | ForEach-Object {
        $m = $_.BaseName
        Install-ForModel -ModelName $m -Root $ProjectRoot
    }
} else {
    Install-ForModel -ModelName $Model -Root $ProjectRoot
}

Write-Host "Done."
