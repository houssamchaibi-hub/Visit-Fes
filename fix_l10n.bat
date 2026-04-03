@echo off
REM ========================================
REM Flutter L10n Auto-Fix Script (Batch)
REM ========================================
REM Run this in your project root directory

echo =====================================
echo   Flutter L10n Auto-Fix Script
echo =====================================
echo.

REM Step 1: Check pubspec.yaml
echo [1/7] Checking project directory...
if not exist pubspec.yaml (
    echo ERROR: pubspec.yaml not found!
    echo Please run this script from your project root directory.
    pause
    exit /b 1
)
echo OK: Found pubspec.yaml
echo.

REM Step 2: Check l10n.yaml
echo [2/7] Checking l10n.yaml...
if not exist l10n.yaml (
    echo ERROR: l10n.yaml not found!
    echo Please create l10n.yaml in the same directory as pubspec.yaml
    pause
    exit /b 1
)
echo OK: Found l10n.yaml
echo.

REM Step 3: Check lib\l10n directory
echo [3/7] Checking lib\l10n directory...
if not exist lib\l10n (
    echo Creating lib\l10n directory...
    mkdir lib\l10n
    echo OK: Created lib\l10n directory
) else (
    echo OK: Found lib\l10n directory
)
echo.

REM Step 4: Clean project
echo [4/7] Cleaning project...
call flutter clean
if exist .dart_tool rmdir /s /q .dart_tool
if exist build rmdir /s /q build
if exist pubspec.lock del /f /q pubspec.lock
echo OK: Project cleaned
echo.

REM Step 5: Get dependencies
echo [5/7] Getting dependencies...
call flutter pub get
if errorlevel 1 (
    echo ERROR: flutter pub get failed!
    pause
    exit /b 1
)
echo OK: Dependencies resolved
echo.

REM Step 6: Generate l10n
echo [6/7] Generating l10n files...
call flutter gen-l10n
if errorlevel 1 (
    echo ERROR: flutter gen-l10n failed!
    echo.
    echo Common causes:
    echo   1. Invalid JSON in .arb files
    echo   2. Missing .arb files in lib\l10n\
    echo   3. Incorrect l10n.yaml configuration
    pause
    exit /b 1
)
echo OK: L10n files generated
echo.

REM Step 7: Verify
echo [7/7] Verifying generated files...
if exist .dart_tool\flutter_gen\gen_l10n\app_localizations.dart (
    echo OK: app_localizations.dart generated successfully!
    echo.
    echo =====================================
    echo   SUCCESS! All steps completed
    echo =====================================
    echo.
    echo You can now run:
    echo   flutter run
    echo.
) else (
    echo ERROR: app_localizations.dart was not generated!
    pause
    exit /b 1
)

pause
