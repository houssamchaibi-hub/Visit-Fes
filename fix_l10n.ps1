# ========================================
# 🔧 Flutter L10n Auto-Fix Script
# ========================================
# Script to automatically fix flutter_gen issues
# Run this in your project root directory

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Flutter L10n Auto-Fix Script" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check if we're in the right directory
Write-Host "[1/8] Checking project directory..." -ForegroundColor Yellow
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ Error: pubspec.yaml not found!" -ForegroundColor Red
    Write-Host "Please run this script from your project root directory." -ForegroundColor Red
    exit 1
}
Write-Host "✅ Found pubspec.yaml" -ForegroundColor Green
Write-Host ""

# Step 2: Check l10n.yaml exists
Write-Host "[2/8] Checking l10n.yaml..." -ForegroundColor Yellow
if (-not (Test-Path "l10n.yaml")) {
    Write-Host "❌ Error: l10n.yaml not found in project root!" -ForegroundColor Red
    Write-Host "Please create l10n.yaml in the same directory as pubspec.yaml" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Found l10n.yaml" -ForegroundColor Green
Write-Host ""

# Step 3: Check lib/l10n directory exists
Write-Host "[3/8] Checking lib/l10n directory..." -ForegroundColor Yellow
if (-not (Test-Path "lib\l10n")) {
    Write-Host "⚠️  lib\l10n directory not found. Creating it..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "lib\l10n" -Force | Out-Null
    Write-Host "✅ Created lib\l10n directory" -ForegroundColor Green
} else {
    Write-Host "✅ Found lib\l10n directory" -ForegroundColor Green
}
Write-Host ""

# Step 4: Check .arb files exist
Write-Host "[4/8] Checking .arb files..." -ForegroundColor Yellow
$arbFiles = Get-ChildItem -Path "lib\l10n\*.arb" -ErrorAction SilentlyContinue
if ($arbFiles.Count -eq 0) {
    Write-Host "❌ Error: No .arb files found in lib\l10n\" -ForegroundColor Red
    Write-Host "Please add your .arb files (app_en.arb, app_ar.arb, etc.) to lib\l10n\" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Found $($arbFiles.Count) .arb file(s):" -ForegroundColor Green
foreach ($file in $arbFiles) {
    Write-Host "   - $($file.Name)" -ForegroundColor Gray
}
Write-Host ""

# Step 5: Clean project
Write-Host "[5/8] Cleaning project..." -ForegroundColor Yellow
flutter clean
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item pubspec.lock -ErrorAction SilentlyContinue
Write-Host "✅ Project cleaned" -ForegroundColor Green
Write-Host ""

# Step 6: Get dependencies
Write-Host "[6/8] Getting dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error: flutter pub get failed!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Dependencies resolved" -ForegroundColor Green
Write-Host ""

# Step 7: Generate l10n files
Write-Host "[7/8] Generating l10n files..." -ForegroundColor Yellow
flutter gen-l10n
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error: flutter gen-l10n failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Common causes:" -ForegroundColor Yellow
    Write-Host "  1. Invalid JSON in .arb files" -ForegroundColor Yellow
    Write-Host "  2. Missing required fields in .arb files" -ForegroundColor Yellow
    Write-Host "  3. Incorrect l10n.yaml configuration" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ L10n files generated" -ForegroundColor Green
Write-Host ""

# Step 8: Verify generation
Write-Host "[8/8] Verifying generated files..." -ForegroundColor Yellow
$genPath = ".dart_tool\flutter_gen\gen_l10n\app_localizations.dart"
if (Test-Path $genPath) {
    Write-Host "✅ app_localizations.dart generated successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Generated files:" -ForegroundColor Cyan
    $genFiles = Get-ChildItem -Path ".dart_tool\flutter_gen\gen_l10n\*.dart"
    foreach ($file in $genFiles) {
        Write-Host "   ✓ $($file.Name)" -ForegroundColor Gray
    }
} else {
    Write-Host "❌ Error: app_localizations.dart was not generated!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  ✅ SUCCESS! All steps completed" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "You can now run:" -ForegroundColor Yellow
Write-Host "  flutter run" -ForegroundColor Cyan
Write-Host ""
Write-Host "Note: If you modify .arb files, run:" -ForegroundColor Yellow
Write-Host "  flutter gen-l10n" -ForegroundColor Cyan
Write-Host ""
