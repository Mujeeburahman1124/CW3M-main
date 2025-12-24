// Firestore Database Structure Documentation
// This file documents the Firestore collections used in the FitFlow app

/*
DATABASE STRUCTURE:
==================

📁 users/
  └── {userId}/
      ├── uid: string
      ├── email: string
      ├── name: string
      ├── photoUrl: string (optional)
      └── createdAt: timestamp

📁 workouts/
  └── {workoutId}/
      ├── id: string
      ├── name: string
      ├── description: string
      ├── durationMinutes: number
      ├── category: string (Cardio, Strength, Flexibility, Sports)
      ├── caloriesBurned: number
      └── date: timestamp

📁 meals/
  └── {mealId}/
      ├── id: string
      ├── name: string
      ├── calories: number
      ├── protein: number
      ├── carbs: number
      ├── fat: number
      └── date: timestamp

📁 categories/ (optional - for food categories)
  └── {categoryId}/
      └── name: string

📁 foods/ (optional - for food items)
  └── {foodId}/
      ├── name: string
      ├── calories: number
      ├── protein: number
      ├── carbs: number
      └── fat: number

SECURITY RULES:
==============
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Authenticated users can read/write workouts
    match /workouts/{workoutId} {
      allow read, write: if request.auth != null;
    }
    
    // Authenticated users can read/write meals
    match /meals/{mealId} {
      allow read, write: if request.auth != null;
    }
    
    // Public read for categories and foods
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /foods/{foodId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}

INITIALIZATION:
==============
Collections are created automatically when:
1. First user registers → creates 'users' collection
2. First workout is added → creates 'workouts' collection
3. First meal is added → creates 'meals' collection
4. App seeds sample data → creates all collections with sample data

*/
