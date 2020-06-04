param (
    [string]$XML = "standard",
    [switch]$Cleanup = $false,
    [switch]$IgnoreDependence = $false
 )
$XMLfile = $XML
[XML]$installDetails = Get-Content $XMLfile


Function Write-Log {
    [CmdletBinding()]
    Param(
    [Parameter(Mandatory=$False)]
    [ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")]
    [String]
    $Level = "INFO",

    [Parameter(Mandatory=$True)]
    [string]
    $Message
    )
    $logFile = "C:\Support\Logs\Autoinstall.txt"
    $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    $tab = [char]9
    $Line = "$Stamp $Level $tab $Message"
    Add-Content $logfile -Value $Line
}
Write-Log -Level INFO -Message "Installing data from $XML"
Write-Log -Level INFO -Message "XML Author $($installDetails.install.info.author)"
if ($installDetails.install.info.dependence) {
    $XMLName = $installDetails.install.info.dependence
    Copy-Item "\\10.49.23.1\Autoinstall\files\XML\$XMLName" "C:\Support\Packages\Autoinstall\"
    Write-Log -Level DEBUG -Message "Dependence was found $XMLName will be installd"
    $arg = "-XML C:\Support\Packages\Autoinstall\$XMLname" 
    Start-Process -FilePath "C:\Support\Packages\Autoinstall\test.exe" -ArgumentList $arg -Wait
}

$steps = $installDetails.install.info.stepscount
$stepCounter = 1
Write-Progress -Activity $installDetails.install.info.name -Status "Starting install" -PercentComplete ((($stepCounter++) / $steps) * 100)
$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
foreach($step in $installDetails.install.data.step){
    
    switch ($step.option) {
        "install" { 
            if ($step.prams) {
                Write-Progress -Activity $installDetails.install.info.name -Status $step.name -PercentComplete ((($stepCounter++) / $steps) * 100)
                Start-Process -FilePath $step.path -ArgumentList $step.prams -Wait
                Write-Log -Level DEBUG -Message "Installing $($step.name)                   Starting $($step.path) with arg $($step.prams)"
                Start-Sleep 3
            } else {
                Write-Progress -Activity $installDetails.install.info.name -Status $step.name -PercentComplete ((($stepCounter++) / $steps) * 100)
                Start-Process -FilePath $step.path  -Wait
                Write-Log -Level DEBUG -Message "Installing $($step.name)                   Starting $($step.path) without arg "
                Start-Sleep 3
            }
        }
        "reg" { 
            Write-Host "Dodaje wpis do rejestru" 
        }
        "create_folder" { 
            switch ($step.path) {
                "%FAV%" {$path = "$env:userprofile\Favorites"}
                "%DESKTOP%" { $path = "$env:userprofile\Desktop"}
                "%DOCU%" { $path = "$env:userprofile\Documents"}
                "%APPDATA%" { $path = "$env:APPDATA" }
                "%ProgramFiles%" {$path = "$env:ProgramFiles"}
                Default { $path = $step.path}
            }
                Write-Progress -Activity $installDetails.install.info.name -Status $step.name -PercentComplete ((($stepCounter++) / $steps) * 100)
                New-Item -Path $path -ItemType directory -Name $step.folder_name | Out-Null
                Write-Log -Level DEBUG -Message "Creating Forder. $($step.name)                   In Path: $($path) with name: $($step.folder_name)"
            
            
        }
        "copy_folder" { 
            switch ($step.path) {
                "%FAV%" {$path = "$env:userprofile\Favorites"}
                "%DESKTOP%" { $path = "$env:userprofile\Desktop"}
                "%DOCU%" { $path = "$env:userprofile\Documents"}
                "%APPDATA%" { $path = "$env:APPDATA" }
                "%ProgramFiles%" {$path = "$env:ProgramFiles"}
                Default { $path = $step.path}
            }
                Write-Progress -Activity $installDetails.install.info.name -Status $step.name -PercentComplete ((($stepCounter++) / $steps) * 100)
                Copy-Item -Path $path -Destination $step.dest_path -Recurse
                Write-Log -Level DEBUG -Message "Copying folder. $($step.name)                   From: $($path) to: $($step.dest_path)"
            
        }
        "script" {
            Write-Progress -Activity $installDetails.install.info.name -Status $step.name -PercentComplete ((($stepCounter++) / $steps) * 100)
            Start-Process -FilePath $step.path -Wait
            Start-Sleep 3
        }
        Default {}
    }
}
$time =  [math]::Round($stopwatch.Elapsed.TotalSeconds,0)
Write-Log -Level DEBUG -Message "$($installDetails.install.info.name) is done and took $time sec. Rebooting to continue installing programs."
if ($installDetails.install.info.after_restart) {
    $RegROPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
    Set-ItemProperty $RegROPath "Autoinstall" -Value "C:\Support\Packages\Autoinstall\test.exe -XML $option" -type String
    Write-Log -Level DEBUG -Message "Data $option"
}
if ($installDetails.install.info.reboot) {
    Write-Log -Level DEBUG -Message "Rebooting PC"
    Restart-Computer 
}
if ($Cleanup -eq $true) {
    Write-Log -Level DEBUG -Message "CleanUping after Installation"
    $CleanTime =  [system.diagnostics.stopwatch]::StartNew()
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty $RegPath "AutoAdminLogon" -Value "0" -type String  
    Set-ItemProperty $RegPath "DefaultDomainName" -Value "." -type String 
    Set-ItemProperty $RegPath "DefaultUsername" -Value " " -type String  
    Remove-ItemProperty $RegPath "DefaultPassword" 
    Remove-ItemProperty $RegPath "AutoLogonCount" 
    Start-Process reg -ArgumentList 'ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /V "1806" /T "REG_DWORD" /D "00000001" /F' -Wait 
    Remove-LocalGroupMember -Group "Administrators" -Member $env:UserName
    Write-Log -Level INFO -Message "User $env:UserName has been remover from local Admin group"
    Set-WinUILanguageOverride -Language de-DE 
    Set-Culture -CultureInfo de-DE
    Set-WinSystemLocale -SystemLocale de-DE
    Set-WinHomeLocation -GeoId 94
    Set-WinUserLanguageList de-DE -force 
    netsh wlan connect ssid=XXX name=XXX
    $Name = $env:COMPUTERNAME
    New-Item -ItemType directory -Path "\\10.49.23.1\Autoinstall\Logs\$Name" | Out-Null
    Copy-Item  "C:\Support\Logs\AutoInstall.txt" "\\10.49.23.1\Autoinstall\Logs\$Name" -Recurse
    Get-WmiObject -Class Win32_Product  | ConvertTo-Html | Out-File "\\10.49.23.199\Autoinstall\Logs\$Name\SW_List.html"
    $CleanTime.Stop()
    $Ctime =  [math]::Round($CleanTime.Elapsed.TotalSeconds,0)
    Write-Log -Level DEBUG -Message "CleanUping after Installation ist done and took $Ctime sec."
    Write-Log -Level DEBUG -Message "Computer will be restarted"
    Restart-Computer 
}
