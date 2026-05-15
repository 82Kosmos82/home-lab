$packages = @(
    "00-preparation",
    "01-active-directory",
    "02-network",
    "03-linux-automation",
    "03-5-rds-vdi",
    "04-azure-hybrid",
    "05-monitoring-backup"
)
$fold =@(
    "scripts",
    "configs",
    "docs",
    "screenshots"
)
$files = @(
    "README.md",
    "JOURNAL.md",
    ".gitignore"
)
foreach($p in $packages) 
{
    foreach($f in $fold)
    {
        New-Item -ItemType Directory -Path "D:\projects\home-lab\$p\$f" -Force
        New-Item -ItemType File -Path "D:\projects\home-lab\$p\$f\.gitkeep" -Force
    }
    New-Item -ItemType File -Path "D:\projects\home-lab\$p\README.md" -Force

}
foreach($f in $files) {
    New-Item -ItemType File -Path "D:\projects\home-lab\$f" -Force
}

