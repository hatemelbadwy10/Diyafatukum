#!/bin/bash

# Build App Bundles Script
# This script builds App Bundles for both user and provider apps (for Play Store distribution)

set -e  # Exit on any error

echo "📦 Building App Bundles for Play Store..."
echo "========================================="

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

# Build user App Bundle
echo ""
print_status "📦 Building user App Bundle..."
echo "================================"
flutter build appbundle --flavor user -t lib/main_user.dart

if [ $? -eq 0 ]; then
    print_success "user App Bundle built successfully!"
else
    print_error "user App Bundle build failed!"
    exit 1
fi

# Build provider App Bundle
echo ""
print_status "📦 Building provider App Bundle..."
echo "================================"
flutter build appbundle --flavor provider -t lib/main_provider.dart

if [ $? -eq 0 ]; then
    print_success "provider App Bundle built successfully!"
else
    print_error "provider App Bundle build failed!"
    exit 1
fi

echo ""
echo "========================================="
print_success "Both App Bundles built successfully!"
echo ""
print_status "Bundle outputs:"
echo "  📱 user Bundle: build/app/outputs/bundle/userRelease/app-user-release.aab"
echo "  🚗 provider Bundle: build/app/outputs/bundle/providerRelease/app-provider-release.aab"

# Show Bundle sizes
if [ -f "build/app/outputs/bundle/userRelease/app-user-release.aab" ]; then
    user_SIZE=$(du -h "build/app/outputs/bundle/userRelease/app-user-release.aab" | cut -f1)
    print_status "user Bundle size: $user_SIZE"
fi

if [ -f "build/app/outputs/bundle/providerRelease/app-provider-release.aab" ]; then
    provider_SIZE=$(du -h "build/app/outputs/bundle/providerRelease/app-provider-release.aab" | cut -f1)
    print_status "provider Bundle size: $provider_SIZE"
fi

echo ""
print_warning "Ready for Play Store upload!"
echo "📝 Note: Make sure to test the bundles before uploading to Play Store"
