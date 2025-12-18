# PowerShell setup script for Windows

Write-Host "🚀 Setting up Chauffeur Flutter project..." -ForegroundColor Cyan

# Check if FVM is installed
if (-not (Get-Command fvm -ErrorAction SilentlyContinue)) {
    Write-Host "❌ FVM is not installed. Installing FVM..." -ForegroundColor Yellow
    dart pub global activate fvm
}

# Install Flutter version
Write-Host "📦 Installing Flutter version..." -ForegroundColor Cyan
fvm install
fvm use

# Get dependencies
Write-Host "📥 Installing dependencies..." -ForegroundColor Cyan
fvm dart run melos exec -- fvm dart pub get --no-example

# Generate localization
Write-Host "🌐 Generating localization files..." -ForegroundColor Cyan
fvm dart run melos exec -- fvm flutter gen-l10n

# Generate code
Write-Host "🔧 Generating code (this may take a while)..." -ForegroundColor Cyan
fvm dart run melos exec -- fvm dart run build_runner build --delete-conflicting-outputs

Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "To run the app:" -ForegroundColor Yellow
Write-Host "  fvm flutter run --flavor dev --dart-define-from-file=configs/.env.dev.json"
Write-Host ""
Write-Host "To format code:" -ForegroundColor Yellow
Write-Host "  fvm dart run melos exec -- fvm dart format ."

