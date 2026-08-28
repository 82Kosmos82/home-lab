$name = @("Marketing","Sales","Public")
$path = "E:\Shares"
$description = @("Share for marketing", "Share for sales", "public share for general info")
$counter = @(0,1,2)
foreach($c in $counter)
{
    New-SmbShare -Name $name[$c] -Path "$path\$($name[$c])" -FullAccess "Authenticated Users" -FolderEnumerationMode AccessBased -Description $description[$c]
}
