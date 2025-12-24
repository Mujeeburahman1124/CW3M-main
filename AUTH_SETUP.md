# Authentication Setup Guide

This Flutter app now includes a complete authentication system using Firebase Authentication and Firestore.

## Features

### 🔐 Authentication
- **Login Screen** - Users can sign in with email and password
- **Sign Up Screen** - New users can create an account
- **Password Reset** - Users can reset their password via email
- **Auto-navigation** - Automatically routes to dashboard when logged in
- **Logout** - Users can sign out from the profile screen

### 💾 Database Integration
- **Firebase Firestore** - User data is stored in Firestore
- **User Model** - Structured user data with uid, email, name, photoUrl, and createdAt
- **Real-time Sync** - Auth state changes are detected in real-time

## File Structure

```
lib/features/auth/
├── models/
│   └── user_model.dart           # User data model
├── services/
│   └── auth_service.dart         # Firebase Auth service
├── providers/
│   └── auth_provider.dart        # Riverpod providers for auth state
└── screens/
    ├── login_screen.dart         # Login UI
    └── signup_screen.dart        # Sign up UI
```

## How It Works

### 1. Sign Up Flow
1. User fills in name, email, password on SignUp screen
2. Firebase creates new user account
3. User data is saved to Firestore in `users` collection
4. User is automatically logged in and redirected to dashboard

### 2. Login Flow
1. User enters email and password on Login screen
2. Firebase authenticates the credentials
3. User data is fetched from Firestore
4. User is redirected to dashboard

### 3. Logout Flow
1. User taps logout button in profile screen
2. Confirmation dialog appears
3. Firebase signs out the user
4. User is redirected to login screen

### 4. Password Reset
1. User enters email on login screen
2. Taps "Forgot Password?"
3. Firebase sends password reset email
4. User can reset password via email link

## Firebase Firestore Structure

```
users/
└── {userId}/
    ├── uid: string
    ├── email: string
    ├── name: string
    ├── photoUrl: string (optional)
    └── createdAt: timestamp
```

## State Management

The app uses **Riverpod** for state management:

- `authStateProvider` - Streams Firebase auth state changes
- `authNotifierProvider` - Manages authentication actions (login, signup, logout)
- `currentUserProvider` - Provides current user data from Firestore

## Security Features

- Password validation (minimum 6 characters)
- Email validation
- Firebase Authentication handles password encryption
- Firestore security rules should be configured in Firebase Console

## Setup Requirements

1. Firebase project must be configured with Authentication enabled
2. Enable Email/Password authentication in Firebase Console
3. Configure Firestore database
4. Add Firebase configuration to `firebase_options.dart`

## Dependencies

```yaml
firebase_core: ^2.24.2
cloud_firestore: ^4.14.0
firebase_auth: ^4.16.0
flutter_riverpod: ^2.4.9
google_fonts: ^6.1.0
```

## Usage Example

### Check if user is logged in
```dart
final authState = ref.watch(authStateProvider);
authState.when(
  data: (user) => user != null ? DashboardScreen() : LoginScreen(),
  loading: () => CircularProgressIndicator(),
  error: (_, __) => LoginScreen(),
);
```

### Sign out
```dart
await ref.read(authNotifierProvider.notifier).signOut();
```

### Get current user
```dart
final user = ref.watch(currentUserProvider);
```

## Error Handling

All authentication errors are handled gracefully with user-friendly error messages:
- Invalid email format
- Weak password
- User not found
- Wrong password
- Email already in use
- Too many attempts
- And more...

## Next Steps

1. Configure Firebase security rules for Firestore
2. Add email verification (optional)
3. Add social login options (Google, Apple, etc.)
4. Implement profile picture upload
5. Add password strength indicator
