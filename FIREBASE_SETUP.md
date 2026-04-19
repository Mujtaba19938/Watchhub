# Firebase Web Configuration Guide

## Step 1: Get Your Firebase Web Config

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (or create a new one if you don't have one)
3. Click the gear icon ⚙️ next to "Project Overview"
4. Select "Project settings"
5. Scroll down to "Your apps" section
6. If you don't have a web app yet:
   - Click the "</>" (Web) icon
   - Register your app with a nickname (e.g., "WatchHub Web")
   - Click "Register app"
7. Copy the Firebase configuration object. It should look like this:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSy...",
  authDomain: "your-project-id.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project-id.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdef"
};
```

## Step 2: Update firebase_options.dart

Open `lib/firebase_options.dart` and replace the placeholder values in the `web` section:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_API_KEY_FROM_FIREBASE_CONSOLE',
  appId: 'YOUR_APP_ID_FROM_FIREBASE_CONSOLE',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);
```

Replace:
- `YOUR_API_KEY_FROM_FIREBASE_CONSOLE` → `apiKey` from Firebase Console
- `YOUR_APP_ID_FROM_FIREBASE_CONSOLE` → `appId` from Firebase Console
- `YOUR_MESSAGING_SENDER_ID` → `messagingSenderId` from Firebase Console
- `YOUR_PROJECT_ID` → `projectId` from Firebase Console

## Step 3: Enable Firebase Authentication

1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password" provider
5. Click "Save"

## Step 4: Enable Firestore Database

1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Start in "Test mode" (for development)
4. Choose a location (closest to your users)
5. Click "Enable"

## Step 5: Test the Setup

1. Run your app: `flutter run -d chrome`
2. Try to sign up a new user
3. Check Firebase Console → Authentication → Users (you should see the new user)
4. Check Firebase Console → Firestore Database → users collection (user data should appear)

## Troubleshooting

- If you see "Firebase is not available" message, double-check that all values in `firebase_options.dart` are correct
- Make sure Firebase Authentication and Firestore are enabled in Firebase Console
- Check browser console for any Firebase-related errors

