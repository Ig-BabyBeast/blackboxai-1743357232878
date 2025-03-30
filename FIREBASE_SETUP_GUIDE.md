# Firebase Configuration Guide

1. **Get Config Files:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project → Project settings
   - Android: Download `google-services.json` → place in `android/app/`
   - iOS: Download `GoogleService-Info.plist` → place in `ios/Runner/`

2. **Enable Services:**
   - Authentication (Email/Password)
   - Firestore Database
   - Storage (if needed)

3. **Update Security Rules:**
   - Review/modify `firestore.rules`
   - Deploy rules: `firebase deploy --only firestore:rules`