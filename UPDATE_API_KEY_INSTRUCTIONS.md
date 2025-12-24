# 🔑 Quick Fix: Update API Key

## The Problem
Your `google-services.json` has: `"YOUR_API_KEY_HERE"` (placeholder)

## Quick Solution (2 minutes)

### Option 1: Download Fresh File (EASIEST)
1. Go to Firebase Console: https://console.firebase.google.com/u/0/project/smartfoodorder-34a3b/settings/general
2. Scroll to "Your apps" section
3. Click on your Android app (📱 icon)
4. Click "google-services.json" download button
5. Replace the file at: `android/app/google-services.json`
6. Run: `flutter clean && flutter run`

### Option 2: Manual Copy (FAST)
1. Go to Firebase Console → Project Settings → General
2. Find "Web API Key" (looks like: `AIzaSyABCDEF123456...`)
3. Copy that key
4. Open `android/app/google-services.json`
5. Replace line 18:
   ```json
   "current_key": "YOUR_API_KEY_HERE"
   ```
   With:
   ```json
   "current_key": "AIzaSyYOUR_ACTUAL_KEY_HERE"
   ```
6. Save file
7. Run: `flutter clean && flutter run`

## Why This Matters
- ✅ With correct API key: User data saves to Firestore → `users` collection will appear
- ❌ Without it: Authentication works but data doesn't save to database

## Your Current Status
- ✅ Firebase enabled
- ✅ Email/Password authentication enabled
- ✅ Firestore database enabled
- ✅ Workouts & meals saving (I see them in your screenshot!)
- ❌ Users collection missing (because API key is wrong)

## After Fix
You'll see a new `users` collection in Firestore with registered user data!
