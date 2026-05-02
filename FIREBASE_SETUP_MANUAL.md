# Firebase Manual Setup Guide

## Overview
The Firebase CLI script has been created and `.firebaserc` has been configured. However, project creation via CLI requires billing to be enabled on your Firebase account.

## Step-by-Step Manual Setup

### Step 1: Create Firebase Projects via Console

1. **Go to Firebase Console:** https://console.firebase.google.com/
2. Click **"Create a project"**

#### Project 1: User App
- **Project Name:** `diyafatukum-user`
- **Organization:** Select or create your organization
- **Features:** Enable required services
- **Create Project**

#### Project 2: Provider App
- **Project Name:** `diyafatukum-provider`
- **Organization:** Same as above
- **Features:** Enable required services
- **Create Project**

---

### Step 2: Add Android Apps to Firebase

#### For User App (diyafatukum-user):

1. Go to Firebase Console → Select `diyafatukum-user` project
2. Click **"Add app"** → Select **"Android"**
3. Fill in:
   - **Android package name:** `com.daem.diyafatukum`
   - **App nickname:** Diyafatukum User (optional)
   - **SHA-1 certificate fingerprint:** (optional for now)
4. Click **"Register app"**
5. **Download `google-services.json`**
6. **Place in:** `android/app/src/user/google-services.json`

#### For Provider App (diyafatukum-provider):

1. Go to Firebase Console → Select `diyafatukum-provider` project
2. Click **"Add app"** → Select **"Android"**
3. Fill in:
   - **Android package name:** `com.daem.diyafatukum.provider`
   - **App nickname:** Diyafatukum Provider (optional)
   - **SHA-1 certificate fingerprint:** (optional for now)
4. Click **"Register app"**
5. **Download `google-services.json`**
6. **Place in:** `android/app/src/provider/google-services.json`

---

### Step 3: Add iOS Apps to Firebase (Optional)

#### For User App (diyafatukum-user):

1. Go to Firebase Console → Select `diyafatukum-user` project
2. Click **"Add app"** → Select **"iOS"**
3. Fill in:
   - **iOS bundle ID:** `com.daem.diyafatukum`
   - **App nickname:** Diyafatukum User
4. Download **`GoogleService-Info.plist`**
5. Place in: `ios/Runner/`

#### For Provider App (diyafatukum-provider):

1. Go to Firebase Console → Select `diyafatukum-provider` project
2. Click **"Add app"** → Select **"iOS"**
3. Fill in:
   - **iOS bundle ID:** `com.daem.diyafatukum.provider`
   - **App nickname:** Diyafatukum Provider
4. Download **`GoogleService-Info.plist`**
5. Place in: `ios/Runner/` (or create flavor-specific directories)

---

### Step 4: Enable Required Firebase Services

For each project (diyafatukum-user and diyafatukum-provider):

1. Go to **Build** menu in Firebase Console
2. Enable:
   - ✓ **Authentication** (if using)
   - ✓ **Cloud Firestore** (if using)
   - ✓ **Realtime Database** (if using)
   - ✓ **Cloud Storage** (if using)
   - ✓ **Cloud Messaging** (for push notifications)

---

### Step 5: Verify Configuration Files

Check that these files exist:

```
android/app/src/user/google-services.json
android/app/src/provider/google-services.json
ios/Runner/GoogleService-Info.plist
```

---

### Step 6: Test the Setup

```bash
# Test User App
flutter run -t lib/main_user.dart --flavor user

# Test Provider App
flutter run -t lib/main_provider.dart --flavor provider
```

---

## Firebase Project Details

### .firebaserc Configuration

Your `.firebaserc` file has been automatically created with:

```json
{
  "projects": {
    "user": "diyafatukum-user",
    "provider": "diyafatukum-provider"
  },
  "targets": {},
  "etags": {}
}
```

---

## Troubleshooting

### Issue: "google-services.json not found"
**Solution:** Ensure the file is placed in the correct flavor directory:
- User: `android/app/src/user/google-services.json`
- Provider: `android/app/src/provider/google-services.json`

### Issue: Firebase initialization fails
**Solution:** Make sure your entry points (main_user.dart, main_provider.dart) have Firebase initialized:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

### Issue: Package name mismatch
**Solution:** Verify package names match exactly:
- Android: `com.daem.diyafatukum` (user), `com.daem.diyafatukum.provider` (provider)
- iOS: `com.daem.diyafatukum` (user), `com.daem.diyafatukum.provider` (provider)

### Issue: Multiple google-services.json files
**Solution:** Use build flavors to select the correct file. Your setup already supports this.

---

## Useful Firebase CLI Commands

```bash
# List all projects
firebase projects:list

# Use a specific project
firebase use diyafatukum-user

# List apps in current project
firebase apps:list

# Get app details
firebase apps:describe <APP_ID>

# Deploy Firestore rules (if using)
firebase deploy --only firestore:rules

# Deploy Cloud Functions (if using)
firebase deploy --only functions
```

---

## Next Steps

1. ✅ Create Firebase projects manually via Console
2. ✅ Add Android apps with correct package names
3. ✅ Download and place google-services.json files
4. ✅ Add iOS apps (if needed)
5. ✅ Test with: `flutter run -t lib/main_user.dart --flavor user`

Your project is ready for Firebase integration!
