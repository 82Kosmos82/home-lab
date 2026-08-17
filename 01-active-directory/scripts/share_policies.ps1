$share = "\Sales"
$path = "E:\Shares$share"
$acl = Get-Acl $path
$whoUser = "LAB\Sales-Users"
$whoAdmin = "LAB\IT-Admins"
$whatUser = "Modify"
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
$rulesToRemove = $acl.Access |  Where-Object {$_.IdentityReference -eq "BUILTIN\Users"}
foreach ($rule in $rulesToRemove)
{
    $acl.RemoveAccessRule($rule) |Out-Null
}
foreach($pol in $policyAdding)
{
    $rule =New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList $pol
    $acl.SetAccessRule($rule)
}
Set-Acl -Path $path -AclObject $acl