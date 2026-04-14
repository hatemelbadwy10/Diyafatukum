# Deals

## Flutter SDK version 3.35.5

### add new feature (enter feature name)

```shell
mason make feature_full -o .././lib/modules/common/features
mason make feature_full -o .././lib/modules/parent/features
mason make feature_full -o .././lib/modules/driver/features
```

### generate file that contains assets variables and widgets and injectable:

1. activate flutter gen

```shell
dart pub global activate flutter_gen
```

### auto generate files like (injection.config.dart - assets.gen.dart)

```shell
dart run build_runner build

fluttergen -c pubspec.yaml
```

## generate icon launcher

```shell
flutter pub run flutter_launcher_icons
```

### generate file that contains localization keys:

```shell
dart run easy_localization:generate -S "assets/lang" -O "lib/core/resources/gen" -o "locale_keys.g.dart" -f keys
```

## ignore mason files

```shell
git update-index --skip-worktree mason/.mason/bricks.json

git update-index --skip-worktree mason/mason-lock.json

git update-index --skip-worktree mason/mason.yaml
```

## use rename package

```shell
flutter pub global activate rename
```
## 🎯 Quick Build Commands

### Using Build Scripts (Recommended)

```bash
# Make scripts executable (one-time setup)
chmod +x scripts/*.sh


# Build apk for both apps
./scripts/build_apk.sh

# Build for Play Store (App Bundles)
./scripts/build_aab.sh

# Build ipa for both apps
./scripts/build_ipa.sh both
```
