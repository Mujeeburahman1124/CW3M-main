import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import '../../features/workout/models/workout_model.dart';
import '../../features/nutrition/models/meal_model.dart';

class DataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize Firestore collections structure
  static Future<void> initializeCollections() async {
    try {
      log('🔧 Initializing Firestore collections...');
      
      // Check if collections already exist by checking document count
      final usersCheck = await _firestore.collection('users').limit(1).get();
      final workoutsCheck = await _firestore.collection('workouts').limit(1).get();
      final mealsCheck = await _firestore.collection('meals').limit(1).get();
      
      if (usersCheck.docs.isEmpty && workoutsCheck.docs.isEmpty && mealsCheck.docs.isEmpty) {
        log('📊 Collections are empty. Seeding sample data...');
        await seedData();
      } else {
        log('✅ Collections already initialized. Skipping seed.');
      }
    } catch (e) {
      log('⚠️ Error checking collections: $e');
      log('💡 This is normal if Firestore is not configured yet');
    }
  }

  static Future<void> seedData() async {
    try {
      log('Starting health & fitness data seeding...');

      final batch = _firestore.batch();

      // --- Workouts (Last 7 Days) ---
      final now = DateTime.now();
      final workouts = List.generate(10, (i) {
        return WorkoutModel(
          id: 'w_seed_$i',
          name: i % 2 == 0 ? 'HIIT Session' : 'Weight Training',
          description: 'Seeded activity for chart visualization.',
          durationMinutes: 30 + (i * 5),
          category: i % 2 == 0 ? 'Cardio' : 'Strength',
          caloriesBurned: 200 + (i * 20),
          date: now.subtract(Duration(days: i % 7)),
        );
      });

      for (var workout in workouts) {
        final docRef = _firestore.collection('workouts').doc(workout.id);
        batch.set(docRef, workout.toJson());
      }

      // --- Meals (Last 7 Days) ---
      final meals = List.generate(10, (i) {
        return MealModel(
          id: 'm_seed_$i',
          name: i % 2 == 0 ? 'Healthy Salad' : 'Protein Bowl',
          calories: 300 + (i * 30),
          protein: 20 + (i * 2),
          carbs: 40 + (i * 3),
          fat: 10 + (i * 1),
          date: now.subtract(Duration(days: i % 7)),
        );
      });

      for (var meal in meals) {
        final docRef = _firestore.collection('meals').doc(meal.id);
        batch.set(docRef, meal.toJson());
      }

      await batch.commit();
      log('Data seeding completed successfully!');
    } catch (e) {
      log('Error seeding data: $e');
    }
  }
}
