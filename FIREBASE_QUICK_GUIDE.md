# Firebase Setup - Quick Reference

## Current Status ✓

- ✅ Firebase CLI installed (v15.5.1)
- ✅ Logged in as: `flutterpostman@gmail.com`
- ✅ `.firebaserc` configuration created
- ✅ Flavor directories created

---

## Firebase Projects to Create

| App | Project ID | Package Name |
|-----|-----------|--------------|
| **User** | `diyafatukum-user` | `com.daem.diyafatukum` |
| **Provider** | `diyafatukum-provider` | `com.daem.diyafatukum.provider` |

---

## Firebase Console Link

Open and create projects:
👉 https://console.firebase.google.com/

---

## What to Do Now

### 1️⃣ Create Projects (Manual)
Go to Firebase Console and create 2 projects with the IDs above.

### 2️⃣ Add Android Apps
For each project, add an Android app with the corresponding package name.

### 3️⃣ Download Configuration Files

**User App:**
- Download `google-services.json` from Firebase Console
- Save to: `android/app/src/user/google-services.json`

**Provider App:**
- Download `google-services.json` from Firebase Console
- Save to: `android/app/src/provider/google-services.json`

### 4️⃣ Verify Files Exist
```bash
ls -la android/app/src/user/google-services.json
ls -la android/app/src/provider/google-services.json
```

### 5️⃣ Test the Apps

**Run User App:**
```bash
flutter run -t lib/main_user.dart --flavor user
```

**Run Provider App:**
```bash
flutter run -t lib/main_provider.dart --flavor provider
```

---

## Firebase CLI Useful Commands

```bash
# List all your Firebase projects
firebase projects:list

# Switch to user project
firebase use diyafatukum-user

# Switch to provider project
firebase use diyafatukum-provider

# List apps in current project
firebase apps:list

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Cloud Functions
firebase deploy --only functions
```

---

## Configuration Files Location

```
diyafatukum/
├── android/
│   └── app/
│       └── src/
│           ├── user/
│           │   ├── AndroidManifest.xml
│           │   └── google-services.json        ← Download & place here
│           ├── provider/
│           │   ├── AndroidManifest.xml
│           │   └── google-services.json        ← Download & place here
│           ├── main/
│           ├── debug/
│           └── profile/
├── ios/
│   └── Runner/
│       └── GoogleService-Info.plist            ← Place iOS config here (optional)
├── lib/
│   ├── main_user.dart
│   ├── main_provider.dart
│   └── main.dart
├── .firebaserc                                  ← ✓ Already created
├── setup_firebase.sh                            ← Setup script
└── FIREBASE_SETUP_MANUAL.md                     ← Full manual guide
```

---

## Troubleshooting

**Q: Where do I download google-services.json?**
A: Firebase Console → Select Project → Project Settings → General tab → Scroll to "Android apps" section → Download JSON

**Q: My files aren't recognized?**
A: Make sure they're in the exact correct directories and the file names match exactly.

**Q: Can I run both apps at the same time?**
A: Yes! With different package names, you can install both on the same device.

**Q: Do I need separate iOS configurations?**
A: Recommended, but you can start with Android first. iOS setup is similar.

---

## Checklist Before Running

- [ ] Created 2 Firebase projects
- [ ] Added Android apps to each project
- [ ] Downloaded `google-services.json` files (2 total)
- [ ] Placed files in correct flavor directories
- [ ] Verified Firebase is initialized in main entry points
- [ ] Run `flutter clean` and `flutter pub get`
- [ ] Ready to test!

---

## Ready?

You're all set to build and test! 🚀

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Run user app
flutter run -t lib/main_user.dart --flavor user

# Or run provider app (in another terminal)
flutter run -t lib/main_provider.dart --flavor provider
```
