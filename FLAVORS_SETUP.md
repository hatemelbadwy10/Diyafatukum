# Flutter Flavors Configuration

## Overview
This project is configured with two flavors:
1. **User** - Main customer/user application
2. **Provider** - Provider/vendor application

---

## Android Flavor Setup

### Package Names
- **User:** `com.daem.diyafatukum`
- **Provider:** `com.daem.diyafatukum.provider`

### Build Configuration
```
android/app/build.gradle.kts
- Flavor dimension: "app"
- User flavor application ID: com.daem.diyafatukum
- Provider flavor application ID: com.daem.diyafatukum.provider
```

### Running Android with Flavors
```bash
# User flavor (debug)
flutter run -t lib/main_user.dart --flavor user

# Provider flavor (debug)
flutter run -t lib/main_provider.dart --flavor provider

# User flavor (release)
flutter run -t lib/main_user.dart --flavor user --release

# Provider flavor (release)
flutter run -t lib/main_provider.dart --flavor provider --release
```

---

## iOS Flavor Setup

### Bundle IDs
- **User:** `com.daem.diyafatukum`
- **Provider:** `com.daem.diyafatukum.provider`

### Running iOS with Flavors
```bash
# User flavor
flutter run -t lib/main_user.dart --flavor user

# Provider flavor
flutter run -t lib/main_provider.dart --flavor provider
```

---

## Entry Points

### Main Files
- **lib/main_user.dart** - User application entry point
- **lib/main_provider.dart** - Provider application entry point
- **lib/main.dart** - Default entry point

### Firebase Configuration

#### Android
Place your Firebase config in the appropriate flavor directory:
- `android/app/src/user/google-services.json` - User flavor
- `android/app/src/provider/google-services.json` - Provider flavor

#### iOS
Place your Firebase config files:
- `ios/Runner/GoogleService-Info.plist` - Can be configured per scheme

---

## Building APK/AAB with Flavors

### Debug APK
```bash
# User
flutter build apk --flavor user -t lib/main_user.dart --debug

# Provider
flutter build apk --flavor provider -t lib/main_provider.dart --debug
```

### Release APK
```bash
# User
flutter build apk --flavor user -t lib/main_user.dart --release

# Provider
flutter build apk --flavor provider -t lib/main_provider.dart --release
```

### AAB (Bundle)
```bash
# User
flutter build appbundle --flavor user -t lib/main_user.dart --release

# Provider
flutter build appbundle --flavor provider -t lib/main_provider.dart --release
```

### IPA (iOS)
```bash
# User
flutter build ios --flavor user -t lib/main_user.dart --release

# Provider
flutter build ios --flavor provider -t lib/main_provider.dart --release
```

---

## Firebase Setup for Each Flavor

### Step 1: Create Firebase Projects
1. Go to Firebase Console
2. Create two projects:
   - **diyafatukum-user** - For user app
   - **diyafatukum-provider** - For provider app

### Step 2: Android Configuration
1. **For User Flavor:**
   - Add app with package: `com.daem.diyafatukum`
   - Download `google-services.json`
   - Place in: `android/app/src/user/`

2. **For Provider Flavor:**
   - Add app with package: `com.daem.diyafatukum.provider`
   - Download `google-services.json`
   - Place in: `android/app/src/provider/`

### Step 3: iOS Configuration
1. Create build schemes in Xcode (if needed)
2. Download GoogleService-Info.plist for each flavor
3. Add to project appropriately

---

## Directory Structure

```
android/app/src/
├── main/
│   ├── AndroidManifest.xml (shared)
│   └── ...
├── user/
│   ├── AndroidManifest.xml (user-specific)
│   └── google-services.json
├── provider/
│   ├── AndroidManifest.xml (provider-specific)
│   └── google-services.json
├── debug/
│   └── AndroidManifest.xml
└── profile/
    └── AndroidManifest.xml

ios/
├── Runner/
│   ├── GoogleService-Info.plist (user)
│   └── ...
└── Runner.xcodeproj/

lib/
├── main.dart
├── main_user.dart
├── main_provider.dart
└── ...
```

---

## Quick Commands Reference

| Task | Command |
|------|---------|
| Run User (Debug) | `flutter run -t lib/main_user.dart --flavor user` |
| Run Provider (Debug) | `flutter run -t lib/main_provider.dart --flavor provider` |
| Build User APK | `flutter build apk --flavor user -t lib/main_user.dart --release` |
| Build Provider APK | `flutter build apk --flavor provider -t lib/main_provider.dart --release` |
| Build User Bundle | `flutter build appbundle --flavor user -t lib/main_user.dart --release` |
| Build Provider Bundle | `flutter build appbundle --flavor provider -t lib/main_provider.dart --release` |

---

## Troubleshooting

### Issue: Plugin not found for flavor
**Solution:** Run `flutter pub get` and ensure pubspec.yaml is properly configured

### Issue: GoogleServices not recognized
**Solution:** Ensure `google-services.json` is in the correct flavor directory

### Issue: Build fails with "Multiple APKs"
**Solution:** Ensure you're specifying the flavor with `--flavor` flag

### Issue: iOS simulator issues
**Solution:** Clean and rebuild:
```bash
flutter clean
rm -rf ios/Pods
rm -rf ios/Podfile.lock
flutter pub get
flutter run -t lib/main_user.dart --flavor user
```

---

## Notes

- Flavors are configured at the build level
- Different package names allow both apps to run simultaneously
- Each flavor can have its own Firebase configuration
- Entry points (main_user.dart, main_provider.dart) should handle flavor-specific initialization
