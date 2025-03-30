# Release Signing Guide

## Android Signing
1. Generate a keystore file:
```bash
keytool -genkey -v \
  -keystore ~/upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

2. Create `android/key.properties`:
```properties
storePassword=your_password
keyPassword=your_password
keyAlias=upload
storeFile=upload-keystore.jks
```

3. Update `android/app/build.gradle`:
```gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

## iOS Signing
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner → Signing & Capabilities
3. Required steps:
   - Select your Apple Developer Team
   - Set a unique Bundle Identifier
   - Enable "Automatically manage signing"
   - For App Store distribution:
     - Create App Store provisioning profile
     - Archive the build in Xcode

## Verification
Test signed builds:
```bash
# Android
flutter build appbundle --release

# iOS
flutter build ipa --export-options-plist=ios/ExportOptions.plist