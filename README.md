# POWERSHELL REMOVE ACCENTS

A PowerShell script that recursively removes accented characters from file and folder names.
⚠ **Warning:** The script will **overwrite** original file and folder names!

## EXAMPLE

Before:  
`C:\Projekt\Működés\Térkép\Játék élmény.docx`  
After:
`C:\Projekt\Mukodes\Terkep\Jatek elmeny.docx`

## FEATURES

- Recursively renames all files and folders by removing accented characters (e.g. á → a, é → e)
- Overwrites original names with sanitized versions
- Logs failed rename operations to `RenameErrors.log`
- Displays output for skipped files due to naming conflicts

## USAGE

1. Copy the script to the root folder you want to sanitize.
2. Right-click on the script and select **"Run with PowerShell"**.
3. Wait for the final message that indicates completion.

## TROUBLESHOUTING

1. Unblock the script:
   If you downloaded the script, right-click on the `.ps1` file → **Properties** → check **"Unblock"** → Apply.

2. Set execution policy:
   Run PowerShell as Administrator and enter:  
   `Set-ExecutionPolicy RemoteSigned -Scope Process -Force`

3. File name conflict:
   If the script fails due to existing unaccented names, remove or rename those files and run the script again.

## FUTURE IMPROVEMENTS

- Add code signing support for better script validation
- Optional dry-run mode (no actual renaming, only preview)
- GUI front-end for easier usage
- Support for excluding specific folders or extensions
- Multilingual character map support (e.g. Polish, Turkish)

## NOTES

- The script uses simple character replacement logic and does not rely on external libraries.
- Tested on Windows 10+ with PowerShell 5.1 (build 26100)
