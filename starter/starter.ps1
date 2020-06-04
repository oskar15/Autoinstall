$XMLs = Get-ChildItem -Path "\\10.49.23.1\Autoinstall\files\XML\"
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$main                            = New-Object system.Windows.Forms.Form
$main.ClientSize                 = '303,375'
$main.text                       = "Autoinstall Script 2.0.1"
$main.TopMost                    = $false

$Panel1                          = New-Object system.Windows.Forms.Panel
$Panel1.height                   = 150
$Panel1.width                    = 300
$Panel1.location                 = New-Object System.Drawing.Point(0,0)

$User_panel                      = New-Object system.Windows.Forms.Label
$User_panel.text                 = "User login"
$User_panel.AutoSize             = $true
$User_panel.width                = 25
$User_panel.height               = 10
$User_panel.location             = New-Object System.Drawing.Point(10,10)
$User_panel.Font                 = 'Microsoft Sans Serif,10'

$User_login_label                = New-Object system.Windows.Forms.Label
$User_login_label.text           = "Login: "
$User_login_label.AutoSize       = $true
$User_login_label.width          = 25
$User_login_label.height         = 10
$User_login_label.location       = New-Object System.Drawing.Point(10,40)
$User_login_label.Font           = 'Microsoft Sans Serif,10'

$User_login_TextBox              = New-Object system.Windows.Forms.TextBox
$User_login_TextBox.multiline    = $false
$User_login_TextBox.width        = 136
$User_login_TextBox.height       = 20
$User_login_TextBox.location     = New-Object System.Drawing.Point(90,35)
$User_login_TextBox.Font         = 'Microsoft Sans Serif,10'

$User_pass_label                 = New-Object system.Windows.Forms.Label
$User_pass_label.text            = "Password:"
$User_pass_label.AutoSize        = $true
$User_pass_label.width           = 25
$User_pass_label.height          = 10
$User_pass_label.location        = New-Object System.Drawing.Point(10,70)
$User_pass_label.Font            = 'Microsoft Sans Serif,10'

$User_pass_TextBox               = New-Object system.Windows.Forms.TextBox
$User_pass_TextBox.multiline     = $false
$User_pass_TextBox.PasswordChar  = "*"
$User_pass_TextBox.width         = 136
$User_pass_TextBox.height        = 20
$User_pass_TextBox.location      = New-Object System.Drawing.Point(90,65)
$User_pass_TextBox.Font          = 'Microsoft Sans Serif,10'
$User_pass_TextBox.Add_Leave({
    $user = $User_login_TextBox.Text
    $pass = $User_pass_TextBox.Text
    $testUser = Test-UserCredential -username "\$user" -password "$pass"
    if ($testUser -eq $true)  {
        $Test_result.text = "Pass"
        $Test_result.BackColor = "#7ED321"
    }    
})

$test_user_data                  = New-Object system.Windows.Forms.Button
$test_user_data.text             = "Test"
$test_user_data.width            = 60
$test_user_data.height           = 30
$test_user_data.location         = New-Object System.Drawing.Point(230,111)
$test_user_data.Font             = 'Microsoft Sans Serif,10'
$test_user_data.Add_Click({
    $user = $User_login_TextBox.Text
    $pass = $User_pass_TextBox.Text
    $testUser = Test-UserCredential -username "\$user" -password "$pass"
    if ($testUser -eq $true)  {
        $Test_result.text = "Pass"
        $Test_result.BackColor = "#7ED321"
    }
    })


$test_result_label               = New-Object system.Windows.Forms.Label
$test_result_label.text          = "Test:"
$test_result_label.AutoSize      = $true
$test_result_label.width         = 25
$test_result_label.height        = 10
$test_result_label.location      = New-Object System.Drawing.Point(10,120)
$test_result_label.Font          = 'Microsoft Sans Serif,10'

$Test_result                     = New-Object system.Windows.Forms.Label
$Test_result.text                = "Please run the test"
$Test_result.BackColor           = "#d0021b"
$Test_result.AutoSize            = $true
$Test_result.width               = 25
$Test_result.height              = 10
$Test_result.location            = New-Object System.Drawing.Point(51,119)
$Test_result.Font                = 'Microsoft Sans Serif,10'

$Settings                        = New-Object system.Windows.Forms.Label
$Settings.text                   = "Settings:"
$Settings.AutoSize               = $true
$Settings.width                  = 25
$Settings.height                 = 10
$Settings.location               = New-Object System.Drawing.Point(10,179)
$Settings.Font                   = 'Microsoft Sans Serif,10'

$local_ADM                       = New-Object system.Windows.Forms.CheckBox
$local_ADM.text                  = "Remove Local ADM after install"
$local_ADM.AutoSize              = $false
$local_ADM.width                 = 264
$local_ADM.height                = 20
$local_ADM.location              = New-Object System.Drawing.Point(25,203)
$local_ADM.Font                  = 'Microsoft Sans Serif,10'

$select_profile                  = New-Object system.Windows.Forms.Label
$select_profile.text             = "Select installation profile"
$select_profile.AutoSize         = $true
$select_profile.width            = 25
$select_profile.height           = 10
$select_profile.location         = New-Object System.Drawing.Point(10,230)
$select_profile.Font             = 'Microsoft Sans Serif,10'

$profile                         = New-Object system.Windows.Forms.ComboBox
$profile.text                    = "Select Profile"
$profile.width                   = 100
$profile.height                  = 20
$XMLs | ForEach-Object {[void] $profile.Items.Add($_)}
$profile.location                = New-Object System.Drawing.Point(25,255)
$profile.Font                    = 'Microsoft Sans Serif,10'
$profile.Add_Leave({
    
 })

$Help                            = New-Object system.Windows.Forms.Button
$Help.text                       = "Help"
$Help.width                      = 60
$Help.height                     = 30
$Help.location                   = New-Object System.Drawing.Point(10,330)
$Help.Font                       = 'Microsoft Sans Serif,10'
$Help.Add_Click({
    Show-Help
    })

$Exit                            = New-Object system.Windows.Forms.Button
$Exit.text                       = "Close"
$Exit.width                      = 60
$Exit.height                     = 30
$Exit.location                   = New-Object System.Drawing.Point(156,330)
$Exit.Font                       = 'Microsoft Sans Serif,10'
$Exit.DialogResult                 = [System.Windows.Forms.DialogResult]::Cancel

$Install                         = New-Object system.Windows.Forms.Button
$Install.text                    = "Install"
$Install.width                   = 60
$Install.height                  = 30
$Install.location                = New-Object System.Drawing.Point(230,330)
$Install.Font                    = 'Microsoft Sans Serif,10'
$Install.Add_Click({
    $main.Close()
    Start-Install
    })

$main.controls.AddRange(@($Panel1,$Settings,$local_ADM,$select_profile,$profile,$Help,$Exit,$Install))
$Panel1.controls.AddRange(@($User_panel,$User_login_label,$User_login_TextBox,$User_pass_label,$User_pass_TextBox,$test_user_data,$test_result_label,$Test_result))

Function Test-UserCredential { 
    Param($username, $password) 
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement 
    $ct = [System.DirectoryServices.AccountManagement.ContextType]::Machine, $env:computername 
    $opt = [System.DirectoryServices.AccountManagement.ContextOptions]::SimpleBind 
    $pc = New-Object System.DirectoryServices.AccountManagement.PrincipalContext -ArgumentList $ct 
    $Result = $pc.ValidateCredentials($username, $password).ToString() 
    $Result 
}
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
Function Show-Help {
    $Help                            = New-Object system.Windows.Forms.Form
    $Help.ClientSize                 = '400,141'
    $Help.text                       = "Help"
    $Help.TopMost                    = $false

    $hel_text                        = New-Object system.Windows.Forms.Label
    $hel_text.text                   = "Some help infos"
    $hel_text.AutoSize               = $true
    $hel_text.width                  = 25
    $hel_text.height                 = 10
    $hel_text.location               = New-Object System.Drawing.Point(130,36)
    $hel_text.Font                   = 'Microsoft Sans Serif,10'

    $OK                              = New-Object system.Windows.Forms.Button
    $OK.text                         = "Exit"
    $OK.width                        = 60
    $OK.height                       = 30
    $OK.location                     = New-Object System.Drawing.Point(286,81)
    $OK.Font                         = 'Microsoft Sans Serif,10'
    $OK.DialogResult                 = [System.Windows.Forms.DialogResult]::Cancel

    $Help.controls.AddRange(@($hel_text,$OK))
    $help.ShowDialog()
}

function Start-Install {
    $stopwatch =  [system.diagnostics.stopwatch]::StartNew()
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    $RegROPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
    $DefaultHKEY = "HKU\DEFAULT_USER"
    $steps = 3
    $stepCounter = 1
    Write-Log -Level DEBUG -Message "***********************************************************************"
    Write-Log -Level DEBUG -Message " "
    Write-Log -Level INFO -Message "PC Name: $env:COMPUTERNAME"
    $winVer = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
    $winVer += (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
    Write-Log -Level INFO -Message "Windows Version: $winVer"
    Write-Log -Level DEBUG -Message " "
    Write-Log -Level DEBUG -Message "***********************************************************************"
    Write-Progress -Activity "Autoinstall" -Status "Vorbereitung für Autologon" -PercentComplete ((($stepCounter++) / $steps) * 100)
    $user = $User_login_TextBox.Text
    $pass = $User_pass_TextBox.Text
    if ($User_login_TextBox.Text -and $User_pass_TextBox.Text) {
        Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String  
        Set-ItemProperty $RegPath "DefaultDomainName" -Value "" -type String 
        Set-ItemProperty $RegPath "DefaultUsername" -Value "$user" -type String  
        Set-ItemProperty $RegPath "DefaultPassword" -Value "$pass" -type String
        Set-ItemProperty $RegPath "AutoLogonCount" -Value "1" -type DWord
        Write-Log -Level INFO -Message "Autologon set for User: $user"
    } else {
        Write-Log -Level WARN -Message "Autologon has benn not selected"
    }
   
    Write-Progress -Activity "Postinstall" -Status "script konfiguration" -PercentComplete ((($stepCounter++) / $steps) * 100) 
    try {
        $Path = "C:\Support\Packages\Autoinstall\"
        if (!(test-path $Path)) {New-Item -ItemType directory -Path $Path | Out-Null}
        Copy-Item "\\10.49.23.1\Autoinstall\files\autoinstall.exe" "C:\Support\Packages\Autoinstall"
        $profile = "\\10.49.23.1\Autoinstall\files\XML\" + $profile.SelectedItem
        Set-ItemProperty $RegROPath "Autoinstall" -Value "C:\Support\Packages\Autoinstall\autoinstall.exe $profile -Cleanup" -type String
        Write-Log -Level INFO -Message "Setting up script with Options: $profile"
    }
    catch {
         $ErrorMessage = $_.Exception.Message
         $FailedItem = $_.Exception.ItemName
         Write-Log -Level ERROR -Message "$FailedItem, $ErrorMessage"
    }
    Write-Progress -Activity "Autoinstall" -Status "Erstellung Locales ADM" -PercentComplete ((($stepCounter++) / $steps) * 100)
    try {
        Add-LocalGroupMember -Group "Administrators" -Member $User_login_TextBox.Text
        Write-Log -Level INFO -Message "User $user has been added to Administrator group"
    }
    catch {
         $ErrorMessage = $_.Exception.Message
         $FailedItem = $_.Exception.ItemName
         Write-Log -Level ERROR -Message "$FailedItem, $ErrorMessage"
    }
    $stopwatch.Stop()
    $time =  [math]::Round($stopwatch.Elapsed.TotalSeconds,0)
    Write-Log -Level DEBUG -Message "Setuping is done and took $time sec. Starting XML Installer to continue installing programs."
    Write-Log -Level DEBUG -Message "***********************************************************************"
    Start-Process -FilePath "C:\Support\Packages\Autoinstall\autoinstall.exe" -ArgumentList '-XML "\\10.49.23.1\Autoinstall\files\XML\Postinstall.xml" ' -Wait
}
[void]$main.ShowDialog()
