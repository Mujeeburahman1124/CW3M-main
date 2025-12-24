# 🔧 Quick Fix: Test Firestore Users Collection

## Problem
`users` collection not appearing in Firebase Firestore after registration.

## ⚡ Instant Test (Do This Now!)

### Step 1: Hot Reload Your App
Press `r` in your terminal or hot restart the app

### Step 2: Navigate to Debug Screen
1. Open the app
2. Go to **Profile** tab (bottom navigation)
3. Scroll down
4. Click **"🔍 Firestore Debug"** button

### Step 3: Test Creating User
1. Click **"Create Test User"** button
2. Watch for response:
   - ✅ **Success** → Go check Firebase Console immediately!
   - ❌ **Error** → Read the error message (see below)

### Step 4: Check Firebase
1. Open Firebase Console: https://console.firebase.google.com/u/0/project/smartfoodorder-34a3b/firestore
2. Refresh the page
3. Look for `users` collection

---

## 🎯 Expected Results

### If Successful:
```
✅ SUCCESS! User created in Firestore.
Check Firebase Console → users collection
```
→ **Refresh Firebase Console** → `users` collection should appear!

### If Error (Permission Denied):
```
❌ ERROR: [firebase_firestore/permission-denied] 
Missing or insufficient permissions
```
→ **Fix**: Update Firestore rules (see below)

### If Error (Network):
```
❌ ERROR: Failed host lookup
```
→ **Fix**: Check internet connection

---

## 🔐 Fix Permission Error

If you get "permission-denied", update Firestore rules:

1. Go to: https://console.firebase.google.com/u/0/project/smartfoodorder-34a3b/firestore/rules

2. Replace ALL with this:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow anyone to write to users (for testing)
    match /users/{userId} {
      allow read, write: if true;
    }
    
    // Workouts & Meals - require auth
    match /workouts/{workoutId} {
      allow read, write: if request.auth != null;
    }
    match /meals/{mealId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

3. Click **Publish**

4. Go back to app → Try "Create Test User" again

---

## 📊 After Fix

Once it works:
1. ✅ `users` collection appears in Firebase
2. ✅ You can register new users and they'll be saved
3. ✅ Login data will be stored in Firestore

---

## 🔄 Test Registration Flow

After users collection is working:

1. In app → **Register** a new user
2. Fill in details → Click register
3. Should see success message
4. Check Firebase Console → New user document should appear in `users` collection

---

## 💡 Why This Matters

The Firestore rules were blocking writes to the `users` collection. By testing with the debug screen, you can:
- See exact error messages
- Test without registering multiple users
- Verify Firebase connection is working
- Confirm rules are configured correctly

---

**Try the debug screen now and let me know what you see!** 🚀
