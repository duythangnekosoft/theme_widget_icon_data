$rootDir = $PSScriptRoot
$manifestPath = Join-Path $rootDir "manifest.json"

$targetFolders = @("guide_app", "live_wallpapers", "status_bar_stickers", "theme_icon", "wallpapers")

$manifest = @{}

foreach ($target in $targetFolders) {
    $targetPath = Join-Path $rootDir $target
    if (Test-Path $targetPath) {
        $items = Get-ChildItem -Path $targetPath -Recurse -Directory
        $items += Get-Item $targetPath

        foreach ($folder in $items) {
            $relativePath = $folder.FullName.Substring($rootDir.Length + 1).Replace('\', '/')
            # ĐÃ XÓA bộ lọc "PSIsContainer". Cho phép quét lôi cổ CẢ TÊN FILE VÀ TÊN FOLDER MẸ!
            $children = Get-ChildItem -Path $folder.FullName | Select-Object -ExpandProperty Name

            if ($children) {
                $manifest[$relativePath] = @($children)
            } else {
                $manifest[$relativePath] = @()
            }
        }
    }
}

$manifest | ConvertTo-Json -Depth 10 | Out-File -FilePath $manifestPath -Encoding utf8
Write-Host "Da phuc hoi nguyen trang script THANH CONG: $manifestPath 🚀"
