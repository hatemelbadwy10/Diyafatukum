#!/bin/bash

# Build Both Apps Script
# This script builds both user and provider versions of the Banoon app

set -e  # Exit on any error

echo "🔨 Building Both Banoon Apps..."
echo "==============================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Clean previous builds
# print_status "Cleaning previous builds..."
# flutter clean

# Get dependencies
print_status "Getting Flutter dependencies..."
flutter pub get

# Build user App
echo ""
print_status "🔨 Building user App..."
echo "========================="
flutter build apk --flavor user -t lib/main_user.dart

if [ $? -eq 0 ]; then
    print_success "user App built successfully!"
else
    print_error "user App build failed!"
    exit 1
fi

# Build provider App
echo ""
print_status "🔨 Building provider App..."
echo "========================="
flutter build apk --flavor provider -t lib/main_provider.dart

if [ $? -eq 0 ]; then
    print_success "provider App built successfully!"
else
    print_error "provider App build failed!"
    exit 1
fi

echo ""
echo "==============================="
print_success "Both apps built successfully!"
echo ""
print_status "Build outputs:"
echo "  📱 user App: build/app/outputs/flutter-apk/app-user-release.apk"
echo "  🚗 provider App: build/app/outputs/flutter-apk/app-provider-release.apk"

# Show APK sizes
if [ -f "build/app/outputs/flutter-apk/app-user-release.apk" ]; then
    user_SIZE=$(du -h "build/app/outputs/flutter-apk/app-user-release.apk" | cut -f1)
    print_status "user APK size: $user_SIZE"
fi

if [ -f "build/app/outputs/flutter-apk/app-provider-release.apk" ]; then
    provider_SIZE=$(du -h "build/app/outputs/flutter-apk/app-provider-release.apk" | cut -f1)
    print_status "provider APK size: $provider_SIZE"
fi

echo ""
echo "🎉 All builds completed successfully!"
