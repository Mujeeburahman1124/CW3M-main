import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/workout/models/workout_model.dart';
import '../../features/nutrition/models/meal_model.dart';

class SyncService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> syncAll() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      log(" No connectivity, skipping sync");
      return;
    }

    log("🔄 Connectivity detected, starting sync...");
    await syncWorkouts();
    await syncMeals();
    log("Sync completed successfully!");
  }

  static Future<void> syncWorkouts() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        log("No user logged in, skipping workout sync");
        return;
      }

      log(" Syncing workouts from Firestore for user: ${currentUser.uid}");
      final box = Hive.box<WorkoutModel>('workoutsBox');
      
      // Clear local data first to avoid duplicates
      await box.clear();
      
      // Pull from Firestore - ONLY current user's data
      final snapshot = await _firestore
          .collection('workouts')
          .where('userId', isEqualTo: currentUser.uid)
          .get();
      log(" Fetched ${snapshot.docs.length} workouts from Firestore");

      for (var doc in snapshot.docs) {
        try {
          final workout = WorkoutModel.fromJson(doc.data());
          await box.put(workout.id, workout);
        } catch (e) {
          log(" Error parsing workout ${doc.id}: $e");
        }
      }
      log(" ${box.length} workouts synced to local storage");
    } catch (e) {
      log(" Error syncing workouts: $e");
    }
  }

  static Future<void> syncMeals() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        log(" No user logged in, skipping meal sync");
        return;
      }

      log(" Syncing meals from Firestore for user: ${currentUser.uid}");
      final box = Hive.box<MealModel>('mealsBox');
      
      // Clear local data first to avoid duplicates
      await box.clear();
      
      // Pull from Firestore - ONLY current user's data
      final snapshot = await _firestore
          .collection('meals')
          .where('userId', isEqualTo: currentUser.uid)
          .get();
      log(" Fetched ${snapshot.docs.length} meals from Firestore");

      for (var doc in snapshot.docs) {
        try {
          final meal = MealModel.fromJson(doc.data());
          await box.put(meal.id, meal);
        } catch (e) {
          log(" Error parsing meal ${doc.id}: $e");
        }
      }
      log(" ${box.length} meals synced to local storage");
    } catch (e) {
      log(" Error syncing meals: $e");
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
