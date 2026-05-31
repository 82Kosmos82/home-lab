#csv structure: FirstName,LastName,Department,Title
#Requires -RunAsAdministrator
#Requires -Module ActiveDirectory


$users = Import-Csv -Path "users.csv"
$password = "P@ssword1!"
$p=ConvertTo-SecureString "$password" -AsPlainText -Force
$ouMap = @{
    "IT"        = "OU=IT,OU=Users,OU=LAB,DC=lab,DC=internal"
    "Marketing" = "OU=Marketing,OU=Users,OU=LAB,DC=lab,DC=internal"
    "Sales"     = "OU=Sales,OU=Users,OU=LAB,DC=lab,DC=internal"
    "Interns"   = "OU=Interns,OU=Users,OU=LAB,DC=lab,DC=internal"
}

foreach($u in $users )
{
    $name ="$($u.FirstName) $($u.LastName)"
    try {
        $Map =$ouMap[$u.Department] 
        if(-not $Map)
        {
            Write-Warning "Unknown Department: $($u.Department)"
            continue
        }
        $n="$($u.FirstName.Substring(0,1).ToLower())"
        New-ADUser -Name $name `
        -SamAccountName "$n.$($u.LastName.ToLower())" `
        -Path $Map `
        -PasswordNeverExpires $true `
        -AccountPassword $p `
        -GivenName "$($u.FirstName)" `
        -Surname "$($u.LastName)" `
        -Enabled $true `
        -UserPrincipalName "$n.$($u.LastName.ToLower())@lab.internal"

        Write-Host "Added user: $n.$($u.LastName)" -ForegroundColor Green
    }
    catch {
            Write-Warning "Failed to create user $name : $_"
            continue
    }
    
}
