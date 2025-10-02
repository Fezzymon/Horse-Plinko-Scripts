#Define Passwords
$adminPassword = "34SYL0GG0N"
$userPassword  = 'th3N$4'


#Change System Passwords
$secureAdminPassword = ConvertTo-SecureString $adminPassword -AsPlainText -Force
$secureUserPassword  = ConvertTo-SecureString $userPassword -AsPlainText -Force

# Set the Administrator password
try {
    Set-LocalUser -Name "Administrator" -Password $secureAdminPassword
    Write-Host "[SUCCESS] Administrator password has been changed." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Could not change Administrator password." -ForegroundColor Red
}

# Get all other users, filter out system accounts, and change their passwords
Get-LocalUser | Where-Object { $_.Name -ne "Administrator" -and $_.Name -ne "Guest" -and $_.Name -ne "DefaultAccount" -and $_.Name -ne "WDAGUtilityAccount" } | ForEach-Object {
    $currentUser = $_.Name
    try {
        Set-LocalUser -Name $currentUser -Password $secureUserPassword
        Write-Host "[SUCCESS] Password for user '$currentUser' has been changed." -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Could not change password for user '$currentUser'." -ForegroundColor Red
    }
}


#Use a GUI to display new passwords securely, allows for randomized passwords
$displayData = @(
    [PSCustomObject]@{
        Account     = "Administrator"
        PasswordSet = $adminPassword
    },
    [PSCustomObject]@{
        Account     = "All Other Users"
        PasswordSet = $userPassword
    }
)

# Display the data in a separate GUI window that is less likely to be logged
Write-Host "Displaying passwords in a pop-up window..."
$displayData | Out-GridView -Title "System Passwords Set"


Write-Host "Script finished."
