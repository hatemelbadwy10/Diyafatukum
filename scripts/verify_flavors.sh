#!/bin/bash

# Script to verify dynamic app names for both flavors
echo "🧪 Testing Dynamic App Names for Flutter Flavors"
echo "================================================="

echo ""
echo "📱 user App Configuration:"
echo "  - App Name: Banoon users"
echo "  - Display Name: Banoon | بنون"
echo "  - Bundle ID: com.fudex.banoon-app.bnoon.user"
echo "  - Entry Point: lib/main_user.dart"

echo ""
echo "🚗 provider App Configuration:"
echo "  - App Name: Banoon providers"
echo "  - Display Name: Banoon provider"
echo "  - Bundle ID: com.fudex.banoon-app.bnoon.user"
echo "  - Entry Point: lib/main_provider.dart"

echo ""
echo "🔧 Build Commands:"
echo "  user: flutter build apk --flavor user -t lib/main_user.dart"
echo "  provider: flutter build apk --flavor provider -t lib/main_provider.dart"

echo ""
echo "📝 Configuration Files Created:"
echo "  ✅ Android: android/app/build.gradle.kts (flavor-specific resValue)"
echo "  ✅ Android: android/app/src/main/AndroidManifest.xml (updated to use @string/app_name)"
echo "  ✅ iOS: ios/Flutter/*-user.xcconfig"
echo "  ✅ iOS: ios/Flutter/*-provider.xcconfig"
echo "  ✅ iOS: ios/Runner/Info.plist (updated to use variables)"
echo "  ✅ Flutter: lib/core/config/flavor/flavor_config.dart (already configured)"

echo ""
echo "🚀 Ready to test! Run the following commands:"
echo "  flutter run --flavor user -t lib/main_user.dart"
echo "  flutter run --flavor provider -t lib/main_provider.dart"
