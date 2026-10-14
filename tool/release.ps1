#requires -Version 5.1
<#
.SYNOPSIS
    Karartılmış (obfuscated) release derlemesi üretir.

.DESCRIPTION
    Her zaman --obfuscate ve --split-debug-info kullanır; böylece Dart sembolleri
    paketten çıkarılıp karartılır. Derleme sonrası üretilen sembol dosyalarını
    build/sembol-arsivi/<tarih>-<hedef> altına kopyalar (çökme raporlarını
    okuyabilmek için bu dosyalar saklanmalıdır).

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tool/release.ps1
    powershell -ExecutionPolicy Bypass -File tool/release.ps1 -Hedef apk
#>
[CmdletBinding()]
param(
    [ValidateSet('aab', 'apk', 'ipa')]
    [string]$Hedef = 'aab'
)

$ErrorActionPreference = 'Stop'

$kok = Split-Path -Parent $PSScriptRoot
Set-Location $kok

switch ($Hedef) {
    'aab' { $altKomut = 'appbundle'; $sembolKlasoru = 'build/symbols' }
    'apk' { $altKomut = 'apk'; $sembolKlasoru = 'build/symbols' }
    'ipa' { $altKomut = 'ipa'; $sembolKlasoru = 'build/symbols-ios' }
}

if ($Hedef -eq 'aab') {
    # Flutter, AAB üretildikten sonra native sembollerin ayrıldığını apkanalyzer ile
    # doğrular; apkanalyzer Android SDK içindeki cmdline-tools'ta bulunur.
    $sdkYolu = $null
    if (Test-Path 'android/local.properties') {
        $sdkSatiri = Select-String -Path 'android/local.properties' -Pattern '^sdk\.dir=' | Select-Object -First 1
        if ($sdkSatiri) { $sdkYolu = $sdkSatiri.Line.Substring(8).Replace('\\', '\').Trim() }
    }
    if (-not $sdkYolu) { $sdkYolu = $env:ANDROID_HOME }
    if (-not $sdkYolu) { $sdkYolu = $env:ANDROID_SDK_ROOT }
    if ($sdkYolu -and -not (Test-Path (Join-Path $sdkYolu 'cmdline-tools'))) {
        Write-Warning "Android SDK'da cmdline-tools yok: $sdkYolu. Derleme AAB'yi üretir ama Flutter'ın sembol doğrulaması 'failed to strip debug symbols' hatasıyla biter. Çözüm: https://dl.google.com/android/repository/commandlinetools-win-16111833_latest.zip içindeki cmdline-tools klasörünü <sdk>\cmdline-tools\latest altına çıkarın."
    }
}

Write-Host "Karartmalı release derlemesi: flutter build $altKomut --release --obfuscate --split-debug-info=$sembolKlasoru" -ForegroundColor Cyan

$baslangic = Get-Date

# flutter/gradle stderr'e uyarı yazabilir; bu satırların hata sayılmaması için
# tercih geçici olarak düşürülür ve başarı yalnızca çıkış kodundan belirlenir.
$oncekiTercih = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
flutter build $altKomut --release --obfuscate --split-debug-info=$sembolKlasoru
$cikisKodu = $LASTEXITCODE
$ErrorActionPreference = $oncekiTercih
if ($cikisKodu -ne 0) { throw "Derleme başarısız (çıkış kodu $cikisKodu). Karartma uygulanmadı." }

$semboller = @(Get-ChildItem $sembolKlasoru -File)
if ($semboller.Count -eq 0) { throw "Sembol dosyası bulunamadı: $sembolKlasoru" }
if (-not ($semboller | Where-Object { $_.LastWriteTime -ge $baslangic })) {
    Write-Warning "Semboller bu derlemede yenilenmedi (Dart kodu değişmemiş olabilir); arşivdeki dosyalar önceki derlemeye ait olabilir."
}

$arsiv = Join-Path 'build/sembol-arsivi' ("{0}-{1}" -f (Get-Date -Format 'yyyyMMdd-HHmmss'), $Hedef)
New-Item -ItemType Directory -Path $arsiv -Force | Out-Null
Copy-Item (Join-Path $sembolKlasoru '*') $arsiv -Recurse -Force

Write-Host ""
Write-Host "Derleme tamam. Semboller arşivlendi:" -ForegroundColor Green
Get-ChildItem $arsiv -File | ForEach-Object { Write-Host ("  {0}  ({1:N0} bayt)" -f $_.Name, $_.Length) }
Write-Host "  -> $arsiv"
Write-Host ""
Write-Host "Çökme okuma: flutter symbolize -i <trace_dosyasi> -d $sembolKlasoru/app.android-arm64.symbols" -ForegroundColor DarkGray
Write-Host "NOT: build/ sürüm kontrolünde tutulmaz; arşivi kalıcı bir yere kopyalayın." -ForegroundColor Yellow
