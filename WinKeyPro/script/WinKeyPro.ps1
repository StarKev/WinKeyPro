# Kevin Lemos Graça (StarKev) - 21.03.2025

# EN : Window Settings
# FR : Paramètres de la fenêtre
$Host.UI.RawUI.WindowTitle = "WinKeyPro"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 > $null
$Host.UI.RawUI.ForegroundColor = 'White'

# EN : Set window size
# FR : Définir la taille de la fenêtre
$windowWidth = 110
$windowHeight = 25
$bufferHeight = 1000
try {
    $Host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size ($windowWidth, $windowHeight)
    $Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size ($windowWidth, $bufferHeight)
} catch {
    Write-Host "Warning: Unable to set window size in this environment." -ForegroundColor Yellow
}

# EN : Check if the script is running as administrator
# FR : Vérifier si le script est exécuté en tant qu'administrateur
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

#---------------------------------------------------------------------------

# EN : Product keys for each Windows version
# FR : Clés de produit pour chaque version de Windows
$windowsKeys = @{
    "1" = "YTMG3-N6DKC-DKB77-7M9GH-8HVX7" # Windows Home / Core
    "2" = "W269N-WFGWX-YVC9B-4J6C9-T83GX" # Windows Professional
    "3" = "NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J" # Windows Pro for Workstations
    "4" = "6TP4R-GNPTD-KYYHQ-7B7DP-J447Y" # Windows Pro Education
    "5" = "NPPR9-FWDCX-D2C8J-H872K-YT43"  # Windows Education
    "6" = "NW6C2-QMPVW-D7KKK-3GKT6-VCFB2" # Windows Enterprise
    "7" = "M7XTQ-FN8P6-TTKYV-9D4CC-J462D" # Windows Enterprise 2019 LTSC
}

# EN : Translated messages
# FR : Messages traduits
$messages = @{
    "EN" = @{
        "title" = "Windows Activation"
        "choose_version" = "Choose your Windows version:"
        "options" = "Other options:"
        "custom_key" = "Enter your license key (XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):"
        "activation_in_progress" = "Activating Windows..."
        "activation_success" = "Windows successfully activated!"
        "uninstall_success" = "Windows license removed."
        "invalid_choice" = "Invalid choice, please try again."
        "windows_versions" = @(
            "Windows Home / Core",
            "Windows Professional",
            "Windows Pro for Workstations",
            "Windows Pro Education",
            "Windows Education",
            "Windows Enterprise",
            "Windows Enterprise 2019 LTSC"
        )
        "menu_options" = @(
            "Remove Windows license",
            "Activate with a custom key",
            "Check activation status",
            "Exit"
        )
    }
    "FR" = @{
        "title" = "Activation Windows"
        "choose_version" = "Choisissez votre version de Windows :"
        "options" = "Autres options :"
        "custom_key" = "Entrez votre clé de licence (XXXXX-XXXXX-XXXXX-XXXXX-XXXXX) :"
        "activation_in_progress" = "Activation en cours..."
        "activation_success" = "Windows activé avec succès !"
        "uninstall_success" = "Licence Windows désinstallée."
        "invalid_choice" = "Choix invalide, essayez à nouveau."
        "windows_versions" = @(
            "Windows Famille / Core",
            "Windows Professionnel",
            "Windows Pro Stations de travail",
            "Windows Pro Éducation",
            "Windows Éducation",
            "Windows Entreprise",
            "Windows Enterprise 2019 LTSC"
        )
        "menu_options" = @(
            "Supprimer la licence Windows",
            "Activer avec une clé personnalisée",
            "Vérifier l'état d'activation",
            "Quitter"
        )
    }
}

#---------------------------------------------------------------------------

# EN : Language selection
# FR : Sélection de la langue
function Select-Language {
    cls
    Write-Host "======================================" -ForegroundColor Yellow
    Write-Host "    Please select your language     "
    Write-Host "  / Veuillez choisir votre langue  "
    Write-Host "======================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1) English"
    Write-Host "2) Français"
    Write-Host ""
    $langChoice = Read-Host "Enter your choice / Entrez votre choix"
    
    switch ($langChoice) {
        '1' { $Global:Lang = "EN" }
        '2' { $Global:Lang = "FR" }
        default {
            Write-Host "`nInvalid choice / Choix invalide" -ForegroundColor Red
            Start-Sleep -Seconds 1
            Select-Language
        }
    }
}

# EN : Call the function for language selection
# FR : Appel de la fonction pour la sélection de langue
Select-Language

# EN : Retrieve messages in the chosen language
# FR : Récupération des messages dans la langue choisie
$msg = $messages[$Lang]

# EN : Main menu loop
# FR : Boucle du menu principal
Do {
    Clear-Host
    Write-Host "`n==================================================" -ForegroundColor Yellow
    Write-Host " __        ___       _  __          ____            "
    Write-Host " \ \      / (_)_ __ | |/ /___ _   _|  _ \ _ __ ___  "
    Write-Host "  \ \ /\ / /| | '_ \| ' // _ \ | | | |_) | '__/ _ \ "
    Write-Host "   \ V  V / | | | | | . \  __/ |_| |  __/| | | (_) |"
    Write-Host "    \_/\_/  |_|_| |_|_|\_\___|\__, |_|   |_|  \___/ "
    Write-Host "                              |___/                 "
    Write-Host "===================================================`n" -ForegroundColor Yellow
             
    # EN : Display translated Windows versions
    # FR : Affichage des versions de Windows traduites
    for ($i = 0; $i -lt $msg["windows_versions"].Count; $i++) {
        Write-Host "$($i+1)) $($msg["windows_versions"][$i])"
    }

    Write-Host "`n" $msg["options"]
    Write-Host "S) $($msg["menu_options"][0])"
    Write-Host "A) $($msg["menu_options"][1])"
    Write-Host "V) $($msg["menu_options"][2])"
    Write-Host "X) $($msg["menu_options"][3])`n"

    $choice = Read-Host "Votre choix / Your choice"

    Switch ($choice.ToUpper()) {
        {$_ -in "1","2","3","4","5","6","7"} {
            Clear-Host
            Write-Host "`n" $msg["activation_in_progress"] -ForegroundColor Yellow
            Start-Process "cscript" -ArgumentList "$env:SystemRoot\System32\slmgr.vbs /ipk $($windowsKeys[$choice])" -NoNewWindow -Wait
            Start-Process "cscript" -ArgumentList "$env:SystemRoot\System32\slmgr.vbs /skms kms.03k.org" -NoNewWindow -Wait
            Start-Process "cscript" -ArgumentList "$env:SystemRoot\System32\slmgr.vbs /ato" -NoNewWindow -Wait
            Write-Host "`n" $msg["activation_success"] -ForegroundColor Green
        }
        "S" {
            Clear-Host
            Start-Process "cscript" -ArgumentList "$env:SystemRoot\System32\slmgr.vbs -upk" -NoNewWindow -Wait
            Write-Host "`n" $msg["uninstall_success"] -ForegroundColor Green
        }
        "A" {
            Clear-Host
            $customKey = Read-Host $msg["custom_key"]
            Start-Process "cscript" -ArgumentList "$env:SystemRoot\System32\slmgr.vbs /ipk $customKey" -NoNewWindow -Wait
            Start-Process "cscript" -ArgumentList "$env:SystemRoot\System32\slmgr.vbs -dli" -NoNewWindow -Wait
            Write-Host "`n" $msg["activation_success"] -ForegroundColor Green
        }
        "V" {
            Clear-Host
            Start-Process "cscript" -ArgumentList "$env:SystemRoot\System32\slmgr.vbs -dli" -NoNewWindow -Wait
        }
        "X" {
            Exit
        }
        Default {
            Write-Host "`n" $msg["invalid_choice"] -ForegroundColor Red
        }
    }
    Pause
} While ($true)
