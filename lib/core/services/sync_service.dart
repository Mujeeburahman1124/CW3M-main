import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'dart:developer';
import '../../features/workout/models/workout_model.dart';
import '../../features/nutrition/models/meal_model.dart';

class SyncService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> syncAll() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      log("No connectivity, skipping sync");
      return;
    }

    log("Connectivity detected, starting sync...");
    await syncWorkouts();
    await syncMeals();
  }

  static Future<void> syncWorkouts() async {
    try {
      final box = Hive.box<WorkoutModel>('workoutsBox');
      
      // Pull from Firestore
      final snapshot = await _firestore.collection('workouts').get();
      log("Fetched ${snapshot.docs.length} workouts from Firestore");

      for (var doc in snapshot.docs) {
        final workout = WorkoutModel.fromJson(doc.data());
        await box.put(workout.id, workout);
      }
      log("Workouts synced to local storage");
    } catch (e) {
      log("Error syncing workouts: $e");
    }
  }

  static Future<void> syncMeals() async {
    try {
      final box = Hive.box<MealModel>('mealsBox');
      
      // Pull from Firestore
      final snapshot = await _firestore.collection('meals').get();
      log("Fetched ${snapshot.docs.length} meals from Firestore");

      for (var doc in snapshot.docs) {
        final meal = MealModel.fromJson(doc.data());
        await box.put(meal.id, meal);
      }
      log("Meals synced to local storage");
    } catch (e) {
      log("Error syncing meals: $e");
    }
  }

  // Helper to add data both locally and to Firebase
  static Future<void> saveWorkout(WorkoutModel workout) async {
    final box = Hive.box<WorkoutModel>('workoutsBox');
    await box.put(workout.id, workout);

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await _firestore.collection('workouts').doc(workout.id).set(workout.toJson());
    }
  }

  static Future<void> saveMeal(MealModel meal) async {
    final box = Hive.box<MealModel>('mealsBox');
    await box.put(meal.id, meal);

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await _firestore.collection('meals').doc(meal.id).set(meal.toJson());
    }
  }

  static Future<void> deleteWorkout(String id) async {
    final box = Hive.box<WorkoutModel>('workoutsBox');
    await box.delete(id);

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await _firestore.collection('workouts').doc(id).delete();
    }
  }

  static Future<void> deleteMeal(String id) async {
    final box = Hive.box<MealModel>('mealsBox');
    await box.delete(id);

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await _firestore.collection('meals').doc(id).delete();
    }
  }
}
