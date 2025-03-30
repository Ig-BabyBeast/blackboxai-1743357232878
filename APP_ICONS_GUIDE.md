# App Icon Configuration Guide

## Android Setup
1. Generate icons using:
   - [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/)
   - Or `flutter pub run flutter_launcher_icons`
2. Replace files in these directories:
   ```
   android/app/src/main/res/mipmap-hdpi/
   android/app/src/main/res/mipmap-mdpi/
   android/app/src/main/res/mipmap-xhdpi/
   android/app/src/main/res/mipmap-xxhdpi/
   android/app/src/main/res/mipmap-xxxhdpi/
   ```

## iOS Setup
1. Use Xcode Assets Catalog:
   ```
   ios/Runner/Assets.xcassets/AppIcon.appiconset
   ```
2. Required sizes (in pixels):
   - 20x20, 29x29, 40x40, 60x60
   - 76x76, 83.5x83.5 (iPad Pro)
   - 1024x1024 (App Store)

## Recommended Tools
- [AppIcon Generator](https://appicon.co/)
- Flutter packages:
  ```yaml
  dev_dependencies:
    flutter_launcher_icons: ^0.13.1
    flutter_native_splash: ^2.3.2
  ```

## Verification
After adding icons:
- Android: Run `flutter build apk --debug`
- iOS: Open in Xcode and check asset catalog