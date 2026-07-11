# Optimize-Art.ps1 — resize + recompress sticker art for the app bundle.
# Repeatable: run after every art drop. Originals are archived (once) to
# art-originals/ (gitignored) before any file is touched.
#
#   powershell -ExecutionPolicy Bypass -File tools/Optimize-Art.ps1
#
# Rules:
# - art_*.png  -> max dimension 640px (stickers render <= ~420px on device)
# - bg_*.png / coloring_*.png -> untouched (full-bleed art keeps its size)
# - Files already <= 640px are skipped.
# - Alpha is preserved (32bpp ARGB, SourceCopy compositing).

Add-Type -AssemblyName System.Drawing

$root      = Split-Path -Parent $PSScriptRoot
$resources = Join-Path $root "Art"
$archive   = Join-Path $root "art-originals"
$maxDim    = 640

if (-not (Test-Path $archive)) { New-Item -ItemType Directory -Path $archive | Out-Null }

$files = Get-ChildItem "$resources\art_*.png"
$beforeTotal = 0; $afterTotal = 0; $optimized = 0; $skipped = 0

foreach ($f in $files) {
    $beforeTotal += $f.Length

    # Archive the original once (never overwrite an existing archive copy).
    $archived = Join-Path $archive $f.Name
    if (-not (Test-Path $archived)) { Copy-Item $f.FullName $archived }

    # Load without locking the file.
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    $ms  = New-Object System.IO.MemoryStream(,$bytes)
    $src = [System.Drawing.Bitmap]::FromStream($ms)

    if ($src.Width -le $maxDim -and $src.Height -le $maxDim) {
        $src.Dispose(); $ms.Dispose()
        $afterTotal += $f.Length
        $skipped++
        continue
    }

    $scale = [Math]::Min($maxDim / $src.Width, $maxDim / $src.Height)
    $newW  = [Math]::Max(1, [int]($src.Width  * $scale))
    $newH  = [Math]::Max(1, [int]($src.Height * $scale))

    $dst = New-Object System.Drawing.Bitmap($newW, $newH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g   = [System.Drawing.Graphics]::FromImage($dst)
    $g.CompositingMode    = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy   # preserve alpha exactly
    $g.InterpolationMode  = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode    = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.DrawImage($src, (New-Object System.Drawing.Rectangle(0, 0, $newW, $newH)))
    $g.Dispose(); $src.Dispose(); $ms.Dispose()

    $tmp = "$($f.FullName).tmp"
    $dst.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $dst.Dispose()
    Move-Item -Force $tmp $f.FullName

    $afterTotal += (Get-Item $f.FullName).Length
    $optimized++
}

$beforeMB = [Math]::Round($beforeTotal / 1MB, 1)
$afterMB  = [Math]::Round($afterTotal / 1MB, 1)
Write-Host "Optimized: $optimized   Skipped (already small): $skipped"
Write-Host "Sticker art total: $beforeMB MB -> $afterMB MB"
Write-Host "Originals archived in art-originals\ (not committed)."
