﻿# A Remake of Nates "System Setup Script"

$BloatPath = "https://raw.githubusercontent.com/periurium/NSSS/main/Bloatware.xml"
$AppPath = "https://raw.githubusercontent.com/periurium/NSSS/main/AppAssociations.xml"


# Check if Script is run as Administrator. If not, elevate
If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

    Write-Host "Elevating to Administrator Privileges In 5 seconds"
    Start-Sleep 5
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit

}

# Check if Dell Command Powershell Module is Installed ( This is for Dell BIOs Changes )
Function CheckDellPowerShellModule {

    If ( Get-InstalledModule -Name "DellBIOSProvider" ) {

        # Module is installed :D
        Write-Host "DellBIOSProvider Module Installed :D"
        Write-Host "Importing Module & Custom Functions"
        Start-Sleep 3
        Import-Module DellBIOSProvider
        Write-Host "Setting Dell Bios..."
        Start-Sleep 3

    } else {
        
        Write-Host "Installing DellBIOSProvider Module"

        # Module isn't installed
        # Set Repository to Trusted ( Prevents Popup window ) & Install Module
        Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
        Install-Module DellBIOSProvider
        # Rerunning Check
        CheckDellPowerShellModule

    }


    Get-InstalledModule -Name "DellBIOSProvider"

}


# Set BIOS Settings through DellBIOSProvider Module
Function SetDellBIOSSettings {

    


}


Function GetBloat {

    # Download Bloatware XML File
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/periurium/NSSS/main/Bloatware.xml" -outfile ".\Bloatware.xml"
    # Handle XML File
    [xml]$xmlBloat = Get-Content -Path .\Bloatware.xml
        

}


# Check which Vendor the computer comes from (this is for BIOS and Bloatware)
Function checkMan {

    $vendor = wmic csproduct get vendor
    switch ($vendor)
    {
        'Dell Inc.' {
            CheckDellPowerShellModule
        }
        'Lenovo Inc.' {

        }
    }

}