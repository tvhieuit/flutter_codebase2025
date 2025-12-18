#!/bin/bash

echo "🚀 Setting up Flutter project..."

# Check if FVM is installed
if ! command -v fvm &> /dev/null; then
    echo "❌ FVM is not installed. Installing FVM..."
    dart pub global activate fvm
fi

# Install Flutter version
echo "📦 Installing Flutter version..."
fvm install
fvm use

# Get dependencies
echo "📥 Installing dependencies..."
fvm dart run melos exec -- fvm dart pub get --no-example

# Generate localization
echo "🌐 Generating localization files..."
fvm dart run melos exec -- fvm flutter gen-l10n

# Generate code
echo "🔧 Generating code (this may take a while)..."
fvm dart run melos exec -- fvm dart run build_runner build --delete-conflicting-outputs

echo "✅ Setup complete!"
echo ""
echo "To run the app:"
echo "  fvm flutter run --flavor dev --dart-define-from-file=configs/.env.dev.json"
echo ""
echo "To format code:"
echo "  fvm dart run melos exec -- fvm dart format ."

