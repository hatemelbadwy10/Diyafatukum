# Build Scripts

This directory contains convenience scripts for building and running different flavors of the Banoon app.

## Available Scripts

### 🔨 Build Scripts

#### `build_all.sh`

Builds both user and provider app APKs in one command.

```bash
./scripts/build_all.sh
```

#### `build_bundles.sh`

Builds App Bundles (AAB files) for Play Store distribution.

```bash
./scripts/build_bundles.sh
```

### 🚀 Development Scripts

#### `run_dev.sh`

Interactive script to run apps in development mode.

```bash
./scripts/run_dev.sh
```

## Usage Examples

### Building for Distribution

```bash
# Build both apps
./scripts/build_all.sh
```

### Building for Play Store

```bash
# Build App Bundles for Play Store upload
./scripts/build_bundles.sh
```

## Output Locations

### APK Files

- user APK: `build/app/outputs/flutter-apk/app-user-release.apk`
- provider APK: `build/app/outputs/flutter-apk/app-provider-release.apk`

### App Bundle Files

- user Bundle: `build/app/outputs/bundle/userRelease/app-user-release.aab`
- provider Bundle: `build/app/outputs/bundle/providerRelease/app-provider-release.aab`

## Prerequisites

- Flutter SDK installed and in PATH
- Android SDK configured
- For iOS builds: Xcode installed (macOS only)
- Dependencies installed (`flutter pub get`)

## Troubleshooting

If scripts fail to execute:

```bash
# Make sure scripts are executable
chmod +x scripts/*.sh

# Check Flutter installation
flutter doctor
```

## Script Features

- ✅ Colored output for better readability
- ✅ Error handling and validation
- ✅ Automatic cleanup before builds
- ✅ Build size reporting
- ✅ Success/failure status reporting

# Build Scripts Documentation

This directory contains shell scripts to build and manage the Banoon Flutter app flavors.

## 📱 iOS Build Scripts

### 🍎 `build_ios_ipa.sh` - Complete IPA Builder

**Full-featured script for App Store distribution**

```bash
# Build user app IPA with archive
./scripts/build_ios_ipa.sh user --clean --archive

# Build provider app IPA and upload to App Store
./scripts/build_ios_ipa.sh provider --archive --upload

# Build both apps with clean
./scripts/build_ios_ipa.sh both --clean --archive
```

**Features:**

- ✅ Automatic cleaning and dependency resolution
- ✅ Flutter build and Xcode archive
- ✅ IPA export for App Store distribution
- ✅ Optional upload to App Store Connect
- ✅ Export options plist generation
- ✅ Comprehensive error handling

## Common Script Features

- ✅ Error handling and validation
- ✅ Automatic cleanup before builds
- ✅ Build size reporting
- ✅ Success/failure status reporting
