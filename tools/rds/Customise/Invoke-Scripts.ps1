#Requires -RunAsAdministrator
<#
    .SYNOPSIS
    Configuration changes to a default install of Windows during provisioning.
  
    .NOTES
    NAME: Invoke-Scripts.ps1
    AUTHOR: Aaron Parker, Insentra
#>
[CmdletBinding()]
Param ()

# Log file
$stampDate = Get-Date
$scriptName = ([System.IO.Path]::GetFileNameWithoutExtension($(Split-Path $script:MyInvocation.MyCommand.Path -Leaf)))
$logFile = "$env:SystemRoot\Logs\$scriptName-" + $stampDate.ToFileTimeUtc() + ".log"
Start-Transcript -Path $logFile

# Get system properties
Switch -Regex ((Get-WmiObject Win32_OperatingSystem).Caption) {
    "Microsoft Windows Server*" {
        $Platform = "Server"
    }
    "Microsoft Windows 10*" {
        $Platform = "Client"
    }
}
$Build = ([System.Environment]::OSVersion.Version).Build

# Gather scripts
$AllScripts = @(Get-ChildItem -Path (Join-Path -Path $PWD -ChildPath "*.All.ps1") -ErrorAction SilentlyContinue)
$PlatformScripts = @(Get-ChildItem -Path (Join-Path -Path $PWD -ChildPath "*.$Platform.ps1") -ErrorAction SilentlyContinue)
$BuildScripts = @(Get-ChildItem -Path (Join-Path -Path $PWD -ChildPath "*.$Build.ps1") -ErrorAction SilentlyContinue)

# Run all scripts
ForEach ($script in ($AllScripts + $PlatformScripts + $BuildScripts)) {
    Try {
        Write-Host "Running script: $($script.FullName)."
        . $script.FullName
    }
    Catch {
        Write-Warning -Message "Failed to run script: $($script.FullName)."
        Throw $_.Exception.Message
    }
}

# End log
Stop-Transcript
