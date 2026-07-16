# One-time setup: extract logo/certs PNGs from signature-assets/images.js
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$imagesJs = Join-Path "signature-assets" "images.js"
if (-not (Test-Path $imagesJs)) {
    Write-Error "Missing $imagesJs"
}

$text = Get-Content $imagesJs -Raw
$logoMatch = [regex]::Match($text, "logo:\s*'(data:image/png;base64,[^']+)'")
$certsMatch = [regex]::Match($text, "certs:\s*'(data:image/png;base64,[^']+)'")

if (-not $logoMatch.Success -or -not $certsMatch.Success) {
    Write-Error "Could not parse base64 images from images.js"
}

function Write-DataUrlPng($dataUrl, $outPath) {
    $b64 = $dataUrl -replace '^data:image/png;base64,', ''
    [IO.File]::WriteAllBytes((Join-Path $PSScriptRoot $outPath), [Convert]::FromBase64String($b64))
}

Write-DataUrlPng $logoMatch.Groups[1].Value "signature-assets\sisco-logo.png"
Write-DataUrlPng $certsMatch.Groups[1].Value "signature-assets\certs.png"

Write-Host "Setup complete: signature-assets\sisco-logo.png and certs.png are ready."
