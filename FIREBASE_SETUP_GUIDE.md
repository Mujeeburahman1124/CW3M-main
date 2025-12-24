# 🔥 Firebase Setup Guide - CRITICAL

## ⚠️ IMPORTANT: Your Firebase is NOT properly configured!

Your app cannot save registration/login data because the Firebase API key is missing.

## 📋 Step-by-Step Firebase Setup

### 1. Go to Firebase Console
Visit: https://console.firebase.google.com/

### 2. Select Your Project
- Open project: **smartfoodorder-34a3b**
- Or create a new Firebase project if you don't have one

### 3. Get Your API Key

#### For Android:
1. Click on **Project Settings** (gear icon)
2. Scroll down to **Your apps** section
3. Select your Android app or click **Add app** if not added
4. Download the **google-services.json** file
5. Replace the file at: `android/app/google-services.json`

The JSON should have a real API key like:
```json
"api_key": [
    {
        "current_key": "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    }
]
```

#### For Web/Windows:
1. Click on **Project Settings** → **General**
2. Scroll to **Your apps**
3. Select **Web app** (or add one)
4. Copy the Firebase configuration
5. Update `lib/firebase_options.dart` with the real values

### 4. Enable Authentication

1. In Firebase Console, go to **Build** → **Authentication**
2. Click **Get Started**
3. Click on **Sign-in method** tab
4. Enable **Email/Password**
5. Click **Save**

### 5. Enable Firestore Database

1. In Firebase Console, go to **Build** → **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select a location
5. Click **Enable**

### 6. Update Security Rules (for testing)

In Firestore Database → Rules, use:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 7. Rebuild Your App
```bash
flutter clean
flutter pub get
flutter run
```

## 🔍 Current Issues

1. ❌ **API Key Missing**: `android/app/google-services.json` has `YOUR_API_KEY_HERE`
2. ❌ **Firebase not initialized properly**: App will crash or not save data
3. ❌ **Authentication may not work**: Enable Email/Password in Firebase Console

## ✅ After Setup

Once configured correctly:
- ✅ User registration will save to Firestore
- ✅ Login will work properly
- ✅ Data will sync to cloud
- ✅ Delete confirmations will work with snackbar feedback

## 🆘 Need Help?

If you don't have access to Firebase Console:
1. Create a new Firebase project at https://console.firebase.google.com/
2. Follow the steps above
3. Replace all Firebase config files with your new project credentials
