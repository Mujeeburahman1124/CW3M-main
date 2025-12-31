# FitFlow - Health & Fitness Assistant

FitFlow is a comprehensive mobile application designed to help users track their health and fitness journey. Built with Flutter, it offers a seamless experience for managing workouts, monitoring nutrition, and visualizing progress.

## Features

- **Dashboard**: Get a quick overview of your daily metrics and health status.
- **Workout Tracking**: Log exercises, sets, and reps efficiently.
- **Nutrition Logging**: Keep track of your daily calorie and macronutrient intake.
- **Progress Visualization**: View detailed charts and analytics of your fitness journey.
- **Offline Support**: Uses Hive for local storage to ensure data availability even without internet.
- **Sync & Backup**: Integrates with Firebase to sync your data across devices.
- **Customization**: Dark and Light mode support for comfortable usage in any environment.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Riverpod](https://riverpod.dev/)
- **Backend/Cloud**: [Firebase](https://firebase.google.com/) (Core, Firestore)
- **Local Storage**: [Hive](https://docs.hivedb.dev/)
- **Charts**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Networking**: [connectivity_plus](https://pub.dev/packages/connectivity_plus)

## 🚀 Getting Started

Follow these steps to get the project running on your local machine.

### Prerequisites

- Flutter SDK (>=3.0.0 <4.0.0)
- Dart SDK
- [Firebase account](https://firebase.google.com/) for backend services.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/CW3M-main.git
   cd CW3M-main
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup** (Required):
   
   a. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   
   b. Add an Android app with package name: `com.example.cw3m`
   
   c. Download `google-services.json` from Firebase Console
   
   d. Rename the template file:
   ```bash
   cp android/app/google-services.json.template android/app/google-services.json
   ```
   
   e. Replace the content with your downloaded `google-services.json`
   
   f. Enable Firestore Database and Authentication in Firebase Console

4. **Configure Firestore:**
   - Go to Firestore Database in Firebase Console
   - Create database in production mode
   - Set up security rules (see `firestore.rules`)

5. **Generate Code (Hive Adapters, etc.):**
   ```bash
   dart run build_runner build
   ```

6. **Run the app:**
   ```bash
   flutter run
   ```

### 🔒 Important Security Notes

- **Never commit** `google-services.json` or `firebase_options.dart` with real API keys
- The `google-services.json` is in `.gitignore` to prevent accidental commits
- Use the provided template file to set up your own Firebase configuration

## 📁 Project Structure

```
lib/
├── core/            # Core utilities, services (Hive, Sync), and themes
├── features/        # Feature-based directory structure
│   ├── dashboard/   # Dashboard screen and logic
│   ├── nutrition/   # Nutrition tracking features
│   ├── profile/     # User profile and settings
│   └── workout/     # Workout logging and management
├── main.dart        # Application entry point
└── firebase_options.dart # Firebase configuration
```

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request.
