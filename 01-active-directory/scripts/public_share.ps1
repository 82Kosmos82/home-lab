$share = "\Public"
$path = "E:\Shares$share"
$acl = Get-Acl $path
$whoUser = "LAB\Domain Users"
$whoAdmin = "LAB\IT-Admins"
$whatUser = "ReadAndExecute"
$whatAdmin = "FullControl"
$where = "ContainerInherit,ObjectInherit"
$propflags = "None"
$allow = "Allow"
$policyUser = @( $whoUser , $whatUser, $where , $propflags , $allow)
$policyAdmins = @( $whoAdmin , $whatAdmin, $where , $propflags , $allow)
$policyAdding = @($policyUser , $policyAdmins)
# при створенні успадкувались права від кореневої папки. будемо їх позбуватись
# перший true розриває успадкування. другий конвертує в явні
$acl.SetAccessRuleProtection($true, $true)
#далі прибираємо правила для локальних юзерів

$acl.PurgeAccessRules([System.Security.Principal.NTAccount]"BUILTIN\Users")

foreach($pol in $policyAdding)
{
    $rule =New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList $pol
    $acl.SetAccessRule($rule)
}
Set-Acl -Path $path -AclObject $acl