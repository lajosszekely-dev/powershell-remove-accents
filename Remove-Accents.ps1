# Remove-Accents.ps1
# PowerShell script to recursively remove accented characters from file and folder names.
# Overwrites original names. Skips conflicts and logs errors to RenameErrors.log.

# Clear existing RenameErrors.log file
Remove-Item -Path "RenameErrors.log" -ErrorAction SilentlyContinue

# Characters replacement
$replacePairs = @{
  [char]0xE1 = "a"; #á
  [char]0xC1 = "A"; #Á
  [char]0xE9 = "e"; #é
  [char]0xC9 = "E"; #É
  [char]0xED = "i"; #í
  [char]0xCD = "I"; #Í
  [char]0xF3 = "o"; #ó
  [char]0xD3 = "O"; #Ó
  [char]0xFA = "u"; #ú
  [char]0xDA = "U"; #Ú
  [char]0xF6 = "o"; #ö
  [char]0xD6 = "O"; #Ö
  [char]0xFC = "u"; #ü
  [char]0xDC = "U"; #Ü
  [char]0x171 = "u"; #ű
  [char]0x151 = "o"; #ő
  [char]0x0170 = "U"; #Ű
  [char]0x0150 = "O"; #Ő
}

# Variables
$renamedCount = 0
$errors = @()

# Function to replace characters in a string
function Replace-Characters {
    param (
        [string]$text
    )

    foreach ($pair in $replacePairs.GetEnumerator()) {
        $text = $text.Replace($pair.Key, $pair.Value)
    }

    return $text
}

# Function to log errors
function Log-Error {
    param (
        [string]$fullPath,
        [string]$originalName
    )

    $logEntry = "File name: $originalName `t Path: $fullPath"
    $logEntry | Out-File -Append -FilePath "RenameErrors.log"
}

# Get script path
$scriptPath = (Get-Item -Path $MyInvocation.MyCommand.Definition).FullName

# Rename cycle
Get-ChildItem -Recurse | ForEach-Object {
    if ($_.FullName -ne $scriptPath) {  # Exclude the script file from renaming
        $originalName = $_.Name
        $newName = Replace-Characters -text $originalName

        # Check if replacements were made
        if ($originalName -ne $newName) {
            try {
                $item = $_  # Capture the item before renaming
                $_ | Rename-Item -NewName $newName -ErrorAction Stop
                $renamedCount++
            } catch {
                $fullPath = $item.FullName
                Log-Error -fullPath $fullPath -originalName $originalName
                $errors += $fullPath
            }
        }
    }
}

# Result
if ($renamedCount -gt 0) {
    Write-Output "$renamedCount file(s) renamed."
} else {
    Write-Output "No files renamed."
}

# Output errors
if ($errors.Count -gt 0) {
    Write-Output "Errors occurred while renaming the following files:"
    $errors | ForEach-Object {
        Write-Output $_
    }
    Write-Output "Check 'RenameErrors.log' for details."
} else {
    Write-Output "No errors occurred."
}

#press any key to continue
Write-Host ""
Write-Host ""
Write-Host "Press any key to continue..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")