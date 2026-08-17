
$dir = "Shares"
$path = "E:\"
$pathfold = "$path$dir"
$folders = @(
    "Marketing",
    "Sales",
    "Public"
)
New-Item -ItemType Directory -Name $dir -Path $path
foreach($share in $folders)
{
    New-Item -ItemType Directory -Name $share -Path $pathfold
}