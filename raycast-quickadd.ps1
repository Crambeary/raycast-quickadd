# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Capture Idea
# @raycast.mode silent
# @raycast.packageName Obsidian
# @raycast.icon https://obsidian.md/images/obsidian-logo-gradient.svg
# @raycast.description Capture an idea into Obsidian through QuickAdd.
#
# Optional arguments:
# @raycast.argument1 { "type": "text", "placeholder": "Idea text" }

param(
    [string]$IdeaText
)

$VaultName = "Forge"
$ChoiceName = "Capture Idea"

if ([string]::IsNullOrWhiteSpace($IdeaText)) {
    Write-Error "Idea text is required."
    exit 1
}

$obsidianCmd = Get-Command obsidian -ErrorAction SilentlyContinue

if ($obsidianCmd) {
    $output = & $obsidianCmd.Source "vault=$VaultName" "quickadd" "choice=$ChoiceName" "value-idea=$IdeaText" 2>&1
    $exitCode = $LASTEXITCODE

    if ($exitCode -ne 0) {
        if ($output) {
            $message = ($output | ForEach-Object { $_.ToString() }) -join [Environment]::NewLine
            Write-Error $message
        } else {
            Write-Error "Obsidian QuickAdd command failed."
        }
        exit $exitCode
    }

    Write-Output "Idea Captured"
    exit 0
}

Add-Type -AssemblyName System.Web
$vaultEncoded = [System.Web.HttpUtility]::UrlEncode($VaultName)
$choiceEncoded = [System.Web.HttpUtility]::UrlEncode($ChoiceName)
$ideaEncoded = [System.Web.HttpUtility]::UrlEncode($IdeaText)
$uri = "obsidian://quickadd?vault=$vaultEncoded&choice=$choiceEncoded&value-idea=$ideaEncoded"
Start-Process $uri | Out-Null
Write-Output "Idea Captured"