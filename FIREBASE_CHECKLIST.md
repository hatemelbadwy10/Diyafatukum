# 🎯 Firebase Setup Checklist

## ✅ Completed

- [x] Firebase CLI v15.5.1 installed and verified
- [x] Logged in to Firebase account (flutterpostman@gmail.com)
- [x] `.firebaserc` configuration file created
- [x] Flutter flavors configured (user & provider)
- [x] Android package names configured:
  - [x] User: `com.daem.diyafatukum`
  - [x] Provider: `com.daem.diyafatukum.provider`
- [x] Android app directories created:
  - [x] `android/app/src/user/`
  - [x] `android/app/src/provider/`
- [x] AndroidManifest.xml files created for each flavor
- [x] Entry points configured:
  - [x] `lib/main_user.dart`
  - [x] `lib/main_provider.dart`
- [x] Documentation created (7 guide files)
- [x] Helper scripts created

---

## ⏳ Pending - Manual Steps Required

### 1. Create Firebase Projects
- [ ] Visit: https://console.firebase.google.com/
- [ ] Create project: `diyafatukum-user`
- [ ] Create project: `diyafatukum-provider`

### 2. Add Android Apps
- [ ] Add Android app to `diyafatukum-user`
  - [ ] Package name: `com.daem.diyafatukum`
  - [ ] Download `google-services.json`
- [ ] Add Android app to `diyafatukum-provider`
  - [ ] Package name: `com.daem.diyafatukum.provider`
  - [ ] Download `google-services.json`

### 3. Configure Project Files
- [ ] Save `google-services.json` to `android/app/src/user/`
- [ ] Save `google-services.json` to `android/app/src/provider/`
- [ ] Verify both files exist
- [ ] Verify both files contain valid JSON

### 4. Verify Firebase Initialization
- [ ] Check `lib/main_user.dart` has Firebase.initializeApp()
- [ ] Check `lib/main_provider.dart` has Firebase.initializeApp()

### 5. Test Build
- [ ] Run: `flutter clean && flutter pub get`
- [ ] Test User app: `flutter run -t lib/main_user.dart --flavor user`
- [ ] Test Provider app: `flutter run -t lib/main_provider.dart --flavor provider`

### 6. (Optional) iOS Setup
- [ ] Create iOS apps in Firebase Console
- [ ] Download `GoogleService-Info.plist` for each project
- [ ] Add to `ios/Runner/`

---

## 📋 Configuration Reference

### Firebase Project IDs
| App | Project ID | Package Name |
|-----|-----------|--------------|
| User | `diyafatukum-user` | `com.daem.diyafatukum` |
| Provider | `diyafatukum-provider` | `com.daem.diyafatukum.provider` |

### File Locations
| File | Location |
|------|----------|
| User google-services.json | `android/app/src/user/google-services.json` |
| Provider google-services.json | `android/app/src/provider/google-services.json` |
| .firebaserc | `.firebaserc` |
| iOS User config | `ios/Runner/GoogleService-Info.plist` (optional) |

---

## 🚀 Quick Start Commands

After completing all manual steps:

```bash
# Clean everything
flutter clean

# Get dependencies
flutter pub get

# Run User App
flutter run -t lib/main_user.dart --flavor user

# Run Provider App (in another terminal)
flutter run -t lib/main_provider.dart --flavor provider
```

---

## 📚 Guide Files

Read in this order:

1. **FIREBASE_QUICK_GUIDE.md** - Quick reference (5 min read)
2. **FIREBASE_SETUP_MANUAL.md** - Detailed steps (10 min read)
3. **FLAVORS_SETUP.md** - Flavor configuration details
4. **PACKAGE_CONFIG.md** - Package naming information

---

## 🆘 Troubleshooting

### Issue: google-services.json not found
```bash
# Check if files exist
ls -la android/app/src/user/google-services.json
ls -la android/app/src/provider/google-services.json
```

### Issue: Invalid JSON error
```bash
# Validate JSON files
python3 -m json.tool android/app/src/user/google-services.json
python3 -m json.tool android/app/src/provider/google-services.json
```

### Issue: Package name mismatch
Make sure your package names in Firebase Console exactly match:
- User: `com.daem.diyafatukum`
- Provider: `com.daem.diyafatukum.provider`

### Issue: Build fails with flavor not found
Ensure you're using the correct command format:
```bash
flutter run -t lib/main_user.dart --flavor user
flutter run -t lib/main_provider.dart --flavor provider
```

---

## ✨ Status Summary

| Component | Status |
|-----------|--------|
| Firebase CLI | ✅ Installed & Configured |
| Flutter Flavors | ✅ Configured |
| Package Names | ✅ Set |
| Android Directories | ✅ Created |
| Documentation | ✅ Complete |
| Firebase Projects | ⏳ Pending |
| Configuration Files | ⏳ Pending |

---

## 📞 Help Resources

- **Firebase Console:** https://console.firebase.google.com/
- **Flutter Flavors Docs:** https://flutter.dev/docs/deployment/flavors
- **Firebase Flutter Docs:** https://firebase.flutter.dev/
- **Help Scripts:** 
  - `manage_firebase_config.sh` - Interactive configuration manager
  - `setup_firebase.sh` - Firebase setup automation

---

**Last Updated:** May 2, 2026
**Setup Status:** Ready for Firebase projects creation
