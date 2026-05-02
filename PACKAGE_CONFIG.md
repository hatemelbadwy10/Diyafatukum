# Package and Bundle ID Configuration

## Project Configuration Update

### New Package Details:
- **App Name:** Diyafatukum
- **Company:** DAEM
- **Package Name (Android):** `com.daem.diyafatukum`
- **Bundle ID (iOS):** `com.daem.diyafatukum`

---

## Files Updated:

### 1. **pubspec.yaml**
- ✅ App name: `diyafatukum`
- ✅ Description: `Diyafatukum - A premium dining and hospitality app.`

### 2. **android/app/build.gradle.kts**
- ✅ `namespace`: `com.daem.diyafatukum`
- ✅ `applicationId`: `com.daem.diyafatukum`

### 3. **ios/Runner.xcodeproj/project.pbxproj**
- ✅ `PRODUCT_BUNDLE_IDENTIFIER`: `com.daem.diyafatukum`
- ✅ Test Bundle ID: `com.daem.diyafatukum.RunnerTests`

---

## Firebase Configuration Setup

Use these credentials when creating Firebase projects:

### Android
```
Package Name: com.daem.diyafatukum
```

### iOS
```
Bundle ID: com.daem.diyafatukum
```

### Steps to Configure Firebase:

1. **Go to Firebase Console:** https://console.firebase.google.com/
2. **Create a new project** or select existing
3. **Add App - Android:**
   - Package Name: `com.daem.diyafatukum`
   - App Nickname: Diyafatukum
   - Download `google-services.json`
   - Place in: `android/app/`

4. **Add App - iOS:**
   - Bundle ID: `com.daem.diyafatukum`
   - App Nickname: Diyafatukum
   - Download `GoogleService-Info.plist`
   - Place in: `ios/Runner/`

---

## Next Steps:

1. Download Firebase configuration files:
   - `google-services.json` (for Android)
   - `GoogleService-Info.plist` (for iOS)

2. Add files to your project:
   ```
   android/app/google-services.json
   ios/Runner/GoogleService-Info.plist
   ```

3. Run build runner (if needed):
   ```bash
   dart run build_runner build
   ```

4. Clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
