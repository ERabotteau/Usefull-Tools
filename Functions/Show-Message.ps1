function Show-Message {

param (
    [string]$Message = "Veuillez entrer votre message",
    [string]$Titre = "Titre de la fenêtre",
    [switch]$OKCancel,
    [switch]$AbortRetryIgnore,
    [switch]$YesNoCancel,
    [switch]$YesNo,
    [switch]$RetryCancel,
    [switch]$IconErreur,
    [switch]$IconQuestion,
    [switch]$IconAvertissement,
    [switch]$IconInformation
    )

# Affecter la valeur selon le type de boutons choisis
if ($OKCancel) { $Btn = 1 }
elseif ($AbortRetryIgnore) { $Btn = 2 }
elseif ($YesNoCancel) { $Btn = 3 }
elseif ($YesNo) { $Btn = 4 }
elseif ($RetryCancel) { $Btn = 5 }
else { $Btn = 0 }

# Affecter la valeur pour l'icone 
if ($IconErreur) {$Icon = 16 }
elseif ($IconQuestion) {$Icon = 32 }
elseif ($IconAvertissement) {$Icon = 48 }
elseif ($IconInformation) {$Icon = 64 }
else {$Icon = 0 }
    

# Charger la biblithèque d'objets graphiques Windows.Forms
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

# Afficher la boite de dialogue et renvoyer la valeur de retour (bouton appuyé)
$Reponse = [System.Windows.Forms.MessageBox]::Show($Message, $Titre , $Btn, $Icon)
Return $Reponse
}